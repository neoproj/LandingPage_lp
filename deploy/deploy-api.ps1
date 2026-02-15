# Deploy API de Leads para o servidor www
# Uso: .\deploy-api.ps1
# Envia api/ para /home/andre/www.neoclinichealth.com.br/api/

param(
    [string]$Server = "andre@76.13.161.233",
    [string]$RemotePath = "/home/andre/www.neoclinichealth.com.br/api"
)

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$ApiPath = Join-Path $ProjectRoot "api"

if (-not (Test-Path $ApiPath)) {
    Write-Host "Pasta api/ nao encontrada" -ForegroundColor Red
    exit 1
}

$sshDir = "$env:USERPROFILE\.ssh"
$SshKey = if (Test-Path "$sshDir\id_ed25519") { "$sshDir\id_ed25519" }
          elseif (Test-Path "$sshDir\id_rsa") { "$sshDir\id_rsa" }
          else { $null }
$sshOpts = if ($SshKey) { @("-i", $SshKey) } else { @() }

Write-Host ">>> Deploy API para $Server" -ForegroundColor Cyan
Write-Host ">>> Destino: $RemotePath" -ForegroundColor Cyan

& ssh @sshOpts $Server "mkdir -p $RemotePath"
& scp @sshOpts -r (Join-Path $ApiPath "lead.php") "${Server}:${RemotePath}/"
& scp @sshOpts (Join-Path $ApiPath "config.example.php") "${Server}:${RemotePath}/"

Write-Host ">>> Concluido! Configure config.php no servidor." -ForegroundColor Green
