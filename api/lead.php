<?php
/**
 * API de Leads - Landing Pages NeoClinic Health
 * Recebe dados do formulário e salva em www.leads
 * URL: https://www.neoclinichealth.com.br/api/lead.php
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método não permitido']);
    exit;
}

$configPath = __DIR__ . '/config.php';
if (!file_exists($configPath)) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Configuração não encontrada']);
    exit;
}

$config = require $configPath;

$input = json_decode(file_get_contents('php://input'), true) ?? $_POST;

$landingPage = trim($input['landing_page'] ?? '');
$nome = trim($input['nome'] ?? '');
$email = trim($input['email'] ?? '');
$telefone = trim($input['telefone'] ?? '');
$clinica = trim($input['clinica'] ?? '');
$profissionais = trim($input['profissionais'] ?? '');
$faturamento = trim($input['faturamento'] ?? '');
$cidade = trim($input['cidade'] ?? '');
$especialidade = trim($input['especialidade'] ?? '');
$mensagem = trim($input['mensagem'] ?? '');

if (empty($landingPage) || empty($nome) || empty($email)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Campos obrigatórios: landing_page, nome, email']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'E-mail inválido']);
    exit;
}

$landingPagesPermitidos = ['lp', 'gestao', 'lp2', 'lp3'];
if (!in_array($landingPage, $landingPagesPermitidos)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Landing page inválida']);
    exit;
}

try {
    $pdo = new PDO(
        "mysql:host={$config['db_host']};dbname={$config['db_name']};charset=utf8mb4",
        $config['db_user'],
        $config['db_pass'],
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    $stmt = $pdo->prepare("
        INSERT INTO www.leads (landing_page, nome, email, telefone, clinica, profissionais, faturamento, cidade, especialidade, mensagem, ip, user_agent)
        VALUES (:landing_page, :nome, :email, :telefone, :clinica, :profissionais, :faturamento, :cidade, :especialidade, :mensagem, :ip, :user_agent)
    ");

    $stmt->execute([
        ':landing_page' => $landingPage,
        ':nome' => $nome,
        ':email' => $email,
        ':telefone' => $telefone,
        ':clinica' => $clinica,
        ':profissionais' => $profissionais,
        ':faturamento' => $faturamento,
        ':cidade' => $cidade,
        ':especialidade' => $especialidade,
        ':mensagem' => $mensagem,
        ':ip' => $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null,
        ':user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? null
    ]);

    echo json_encode(['success' => true, 'message' => 'Lead registrado com sucesso']);

} catch (PDOException $e) {
    error_log('Lead API Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Erro ao salvar. Tente novamente.']);
}
