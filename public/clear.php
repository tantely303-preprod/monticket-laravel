<?php

// -----------------------------------------------------------
//  clear.php -- Execute Laravel cache clearing in production
// -----------------------------------------------------------

header('Content-Type: text/plain');

// Sécurité minimale : change ce token !
$token = "MON_TOKEN_SECRET_12345";

if (!isset($_GET['token']) || $_GET['token'] !== $token) {
    http_response_code(403);
    echo "ACCESS DENIED";
    exit;
}

echo "=== Cleaning Laravel caches ===\n\n";

$commands = [
    "php artisan cache:clear",
    "php artisan route:clear",
    "php artisan config:clear",
    "php artisan view:clear",
    "php artisan optimize:clear",
    "php artisan config:cache"
];

foreach ($commands as $cmd) {
    echo "> $cmd\n";
    $output = shell_exec($cmd . " 2>&1");
    echo $output . "\n";
}

echo "\n=== DONE ===\n";

