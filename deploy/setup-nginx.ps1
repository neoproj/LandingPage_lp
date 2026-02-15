# Envia config Nginx para o servidor e exibe comandos para ativar
# Uso: .\setup-nginx.ps1

param([string]$Server = "andre@76.13.161.233")

$sshDir = "$env:USERPROFILE\.ssh"
$SshKey = if (Test-Path "$sshDir\id_ed25519") { "$sshDir\id_ed25519" }
          elseif (Test-Path "$sshDir\id_rsa") { "$sshDir\id_rsa" }
          else { $null }
$sshOpts = if ($SshKey) { @("-i", $SshKey) } else { @() }

$configPath = Join-Path $PSScriptRoot "nginx-lp.conf"

Write-Host ">>> Enviando nginx-lp.conf para $Server" -ForegroundColor Cyan
& scp @sshOpts $configPath "${Server}:/tmp/nginx-lp.conf"

Write-Host ""
Write-Host ">>> Conecte ao servidor e execute:" -ForegroundColor Yellow
Write-Host "  sudo cp /tmp/nginx-lp.conf /etc/nginx/sites-available/lp.neoclinichealth.com.br"
Write-Host "  sudo ln -sf /etc/nginx/sites-available/lp.neoclinichealth.com.br /etc/nginx/sites-enabled/00-lp.neoclinichealth.com.br"
Write-Host "  sudo nginx -t && sudo systemctl reload nginx"
Write-Host ""
Write-Host ">>> Se lp cair no backoffice: verifique se o backoffice tem default_server e remova." -ForegroundColor Gray
