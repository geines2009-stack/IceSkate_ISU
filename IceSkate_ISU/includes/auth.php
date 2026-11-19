<?php
if (!headers_sent()) {
    header('X-Content-Type-Options: nosniff');
    header('X-Frame-Options: SAMEORIGIN');
    header('Referrer-Policy: strict-origin-when-cross-origin');
    header('Permissions-Policy: camera=(), microphone=(), geolocation=()');
}
if (session_status() !== PHP_SESSION_ACTIVE) {
    ini_set('session.use_strict_mode', '1');
    session_set_cookie_params(['httponly'=>true, 'secure'=>!empty($_SERVER['HTTPS']), 'samesite'=>'Lax']);
    session_start();
}
function logged(): bool { return isset($_SESSION['user_id']); }
function require_login(): void { if (!logged()) { header('Location: login.php'); exit; } }
function is_admin(): bool { return ($_SESSION['perfil'] ?? '') === 'admin'; }
function require_admin(): void { require_login(); if (!is_admin()) { http_response_code(403); exit('Acesso negado. Esta área é exclusiva da administração ISU.'); } }
function e($value): string { return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }
function csrf_token(): string { if (empty($_SESSION['csrf'])) $_SESSION['csrf'] = bin2hex(random_bytes(32)); return $_SESSION['csrf']; }
function verify_csrf(): void { if ($_SERVER['REQUEST_METHOD'] === 'POST') { $token = $_POST['csrf'] ?? ''; if (!hash_equals($_SESSION['csrf'] ?? '', $token)) { http_response_code(419); exit('Solicitação inválida. Atualize a página e tente novamente.'); } } }
function flash($message, $type='success'): void { $_SESSION['flash'] = ['message'=>$message, 'type'=>$type]; }
function get_flash(): ?array { $f=$_SESSION['flash'] ?? null; unset($_SESSION['flash']); return $f; }
