import { spawn } from "node:child_process";
import fileSystem from "node:fs";

import express from "express";

const __dirname = import.meta.dirname;

const configuration = {
  ldf: {
    // HTTP port for Linked Data Fragments server.
    port: parseInt(process.env.LDF_PORT ?? 3000),
    workers: parseInt(process.env.LDF_WORKERS ?? 4),
    config: filterKeysWithPrefix(process.env, "LDF_"),
    // Path to ldf-server configuration.
    configurationFilePath: null,
  },
  host: {
    port: parseInt(process.env.PORT ?? 5000),
    token: process.env.RELOAD_TOKEN ?? "",
  },
};

const state = {
  // When reloading we need to delete files and restart the ldf-server.
  reloading: false,
  terminated: false,
  indexRemoved: false,
  // Holds ldf-server.
  ldfProcess: null,
};

function filterKeysWithPrefix(object, prefix) {
  const filtered = {};
  for (const [key, value] of Object.entries(object)) {
    if (key.startsWith(prefix)) {
      filtered[key] = value;
    }
  }
  return filtered;
}

(async function main() {
  configuration.ldf.configurationFilePath =
    await prepareConfiguration(configuration.ldf);
  startLinkedDataFragmentServer();
  startHttpServer();
})();

async function prepareConfiguration(ldf) {
  // We can do sync operation here.
  const sourcePath = __dirname + "/configuration.template.json";
  const template = JSON.parse(fileSystem.readFileSync(sourcePath, "utf8"));
  // Update
  const instance = replaceTemplates(template, ldf.config);
  // Write
  const targetPath = __dirname + "/configuration.json";
  fileSystem.writeFileSync(
    targetPath,
    JSON.stringify(instance, null, 2),
    { encoding: "utf8" },
  );
  return targetPath;
}

/**
 * Replace all occurrences of "{KEY}" in given JavaScript object.
 */
function replaceTemplates(value, replacements) {
  if (value == null || undefined) {
    return value;
  } else if (Array.isArray(value)) {
    return value.map(item => replaceTemplates(item, replacements));
  } else if (typeof value === "object") {
    const result = {};
    for (const [key, keyValue] of Object.entries(value)) {
      result[key] = replaceTemplates(keyValue, replacements);
    }
    return result;
  } else if (typeof value === "string") {
    let result = value;
    // Replace all occurrences of {KEY} with corresponding values
    for (const [key, value] of Object.entries(replacements)) {
      const pattern = new RegExp(`\\{${key}\\}`, "g");
      result = result.replace(pattern, value);
    }
    return result;
  } else {
    // Other primitive values.
    return value;
  }
}

function startLinkedDataFragmentServer() {
  const configurationFilePath = configuration.ldf.configurationFilePath;
  const port = configuration.ldf.port;
  const workerCount = configuration.ldf.workers

  console.log(`${timestamp()} Starting LDF server.`,
    configurationFilePath, port, workerCount);
  const ldfProcess = spawn("node", [
    "./node_modules/@ldf/server/bin/ldf-server",
    configurationFilePath, port, workerCount,
  ], {
    cwd: __dirname,
  });

  ldfProcess.stdout.on("data", (data) => {
    console.log(`${timestamp()} ldf:stdout: ${data.toString().trim()}`);
  });

  ldfProcess.stderr.on("data", (data) => {
    console.error(`${timestamp()} ldf:stderr: ${data.toString().trim()}`);
  });

  ldfProcess.on("close", (code) => {
    console.log(`${timestamp()} ldf: Child process exited with code '${code}'.`);
    if (!state.reloading) {
      console.log(`${timestamp()} Terminating main process`)
      process.exit(code);
    }
    if (state.indexRemoved) {
      // File has been removed before process termination.
      // Thus we can start a new process.
      startLinkedDataFragmentServer();
    } else {
      state.reloading = true;
    }
  });

  state.ldfProcess = ldfProcess;
  // If we were reloading now we are done.
  state.reloading = false;
};

function timestamp() {
  return '[' + new Date().toISOString() + ']';
}

function startHttpServer() {
  const app = express();

  // We need to use GET as LP:ETL does not work well with POST.
  app.get("/api/reload", (req, res) => {
    const token = req.query.token ?? "";
    if (token !== configuration.host.token) {
      const unauthorized_code = 401;
      res.status(unauthorized_code).send();
      return;
    }
    restartLinkedDataFragmentServer();
    res.send();
  });

  app.listen(configuration.host.port, () => {
    const port = configuration.host.port;
    console.log(`${timestamp()} Control HTTP server listening on port ${port}.`);
  });

}

function restartLinkedDataFragmentServer() {
  console.log(`${timestamp()} Executing reload.`);
  if (state.reloading) {
    // We are already reloading!
    return;
  }
  // This tell us that it is ok if the main thread ends.
  state.reloading = true;
  state.terminated = false;
  state.indexRemoved = false;
  // Terminate old process.
  console.log(`${timestamp()} Sending SIGTERM to ldf.`);
  state.ldfProcess.kill("SIGTERM");
  // Remove index file.
  // We originally just use SIGHUP for @ldf/server.
  // But sometimes the @ldf/server use all memory and crashed, this should help.
  const indexFile = "/data/nkod.hdt.index.v1-1";
  fileSystem.unlink(indexFile, () => {
    console.log(`${timestamp()} Index file "${indexFile}" has been removed.`);
    if (state.terminated === true) {
      // The process has been terminated before we deleted the file.
      // Thus we can start a new thread.
      startLinkedDataFragmentServer();
    } else {
      state.indexRemoved = true;
    }
  });
}
