<?php

error_reporting(0);
set_time_limit(5 * 60);

// Configuration

$log_file = '/data/on-github-push-data.log';

$log_size_bytes = 5 * 1024 * 1024;

$command_to_execute = 'nohup /opt/jekyll/update-content.sh >>' . $log_file . ' 2>&1 &';

process_request();

//

function process_request() {

  // Load configuration.
  $branch = getenv('GITHUB_BRANCH');
  $repository = getenv('GITHUB_REPOSITORY');
  $secret = getenv('GITHUB_SECRET');

  // Receive POST data for signature calculation, don't change!
  $post_data = file_get_contents('php://input');
  $signature = hash_hmac('sha1', $post_data, $secret);

  // Required data in POST body.
  $required_data = array(
    'ref' => 'refs/heads/' . $branch,
    'repository' => array(
      'full_name' => $repository,
    ),
  );

  // Required data in headers.
  $required_headers = array(
    'REQUEST_METHOD' => 'POST',
    'HTTP_X_GITHUB_EVENT' => 'push',
    'HTTP_USER_AGENT' => 'GitHub-Hookshot/*',
    'HTTP_X_HUB_SIGNATURE' => 'sha1=' . $signature,
  );

  log_message("Received request from {$_SERVER['REMOTE_ADDR']}");

  // Decode payload if this fail we just ignore the request.
  $data = json_decode($post_data, true);

  // First do all checks and then report back in order to avoid timing attacks
  $headers_ok = array_matches($_SERVER, $required_headers, '$_SERVER');
  $data_ok = array_matches($data, $required_data, '$data');

  // Respond
  header("Content-Type: text/plain");
  if ($headers_ok && $data_ok) {
    log_message("Executing command");
    global $command_to_execute;
    shell_exec($command_to_execute);
    http_response_code(200);
    exit();
  } else {
    http_response_code(403);
    exit();
  }
}

function log_message(string $content)
{
    global $log_file;
    if ($log_file === '') {
      return;
    }

    global $log_size_bytes;

    // Check if file exists and exceeds size.
    // If yes clear it, this allows for log rotation support.
    if (file_exists($log_file)) {
        $fileSize = filesize($log_file);
        if ($fileSize !== false && $fileSize >= $log_size_bytes) {
            // Clear file
            $handle = fopen($log_file, 'w');
            if ($handle === false) {
                return false;
            }
            fclose($handle);
        }
    }

    // Prepare log line with timestamp
    $timestamp = date('Y-m-d H:i:s');
    $line = sprintf("%s : %s%s", $timestamp, $content, PHP_EOL);

    // Append log entry
    file_put_contents($log_file, $line, FILE_APPEND);
}

function array_matches($have, $should, $name = 'array')
{
  $ret = true;
  if (is_array($have)) {
    foreach ($should as $key => $value) {
      if (!array_key_exists($key, $have)) {
        log_message("Missing: $key");
        $ret = false;
      } else if (is_array($value) && is_array($have[$key])) {
        $ret &= array_matches($have[$key], $value);
      } else if (is_array($value) || is_array($have[$key])) {
        log_message("Type mismatch: $key");
        $ret = false;
      } else if (!fnmatch($value, $have[$key])) {
        log_message("Failed comparison: $key={$have[$key]} (expected $value)");
        $ret = false;
      }
    }
  } else {
    log_message("Not an array: $name");
    $ret = false;
  }
  return $ret;
}
