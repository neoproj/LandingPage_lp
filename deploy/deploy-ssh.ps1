# Deploy LP NeoClinic Health para lp.neoclinichealth.com.br
# Uso: .\deploy-ssh.ps1 -Server "usuario@ip-ou-dominio"
# Chave SSH: C:\Users\Andre Luiz\.ssh

param(
    [Parameter(Mandatory=$true)]
    [string]$Server,
    [string]$RemotePath = "/home/andre/lp.neoclinichealth.com.br"
)

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $ProjectRoot

if ($SshKey) { Write-Host ">>> Chave SSH: $SshKey" -ForegroundColor Gray }
Write-Host ">>> Deploy para $Server" -ForegroundColor Cyan
Write-Host ">>> Pasta remota: $RemotePath" -ForegroundColor Cyan
Write-Host ""

# Usar chave SSH de C:\Users\Andre Luiz\.ssh (id_rsa ou id_ed25519)
$sshDir = "$env:USERPROFILE\.ssh"
$SshKey = if (Test-Path "$sshDir\id_ed25519") { "$sshDir\id_ed25519" }
          elseif (Test-Path "$sshDir\id_rsa") { "$sshDir\id_rsa" }
          else { $null }
$sshOpts = if ($SshKey) { @("-i", $SshKey) } else { @() }

# Criar pasta no servidor
& ssh @sshOpts $Server "mkdir -p $RemotePath"

# Enviar arquivos via scp
$files = @("index.html", "css", "js", "assets")
foreach ($item in $files) {
    $path = Join-Path $ProjectRoot $item
    if (Test-Path $path) {
        Write-Host "Enviando $item..."
        & scp @sshOpts -r $path "${Server}:${RemotePath}/"
    }
}

# Enviar NeoClinic-01.png da raiz se existir
$logoRoot = Join-Path $ProjectRoot "NeoClinic-01.png"
if (Test-Path $logoRoot) {
    & scp @sshOpts $logoRoot "${Server}:${RemotePath}/"
}

Write-Host ""
Write-Host ">>> Deploy concluído!" -ForegroundColor Green
Write-Host ">>> Acesse: https://lp.neoclinichealth.com.br"
