<?php
require_once __DIR__ . '/includes/config.php';

try {
    $pdo = new PDO(
        'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
        DB_USER,
        DB_PASS,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    echo 'Database connection successful!';

} catch (PDOException $e) {
    http_response_code(500);
    error_log('BGB360 database test: ' . $e->getMessage());
    echo 'Database connection failed. Check database credentials and permissions.';
}