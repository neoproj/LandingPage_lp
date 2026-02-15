#!/bin/bash
# Deploy LP NeoClinic Health para lp.neoclinichealth.com.br
# Uso: ./deploy-ssh.sh [usuario@servidor]
# A chave SSH será usada automaticamente de ~/.ssh/

SERVER="${1:-usuario@seu-servidor.com}"
REMOTE_PATH="/var/www/lp.neoclinichealth.com.br"

echo ">>> Deploy para $SERVER"
echo ">>> Pasta remota: $REMOTE_PATH"
echo ""

# Criar pasta no servidor se não existir
ssh "$SERVER" "mkdir -p $REMOTE_PATH"

# Enviar arquivos (rsync preserva estrutura)
rsync -avz --delete \
  --exclude '.git' \
  --exclude 'node_modules' \
  --exclude 'deploy' \
  --exclude 'DEPLOY.md' \
  --exclude 'vercel.json' \
  ./ "$SERVER:$REMOTE_PATH/"

echo ""
echo ">>> Deploy concluído!"
echo ">>> Acesse: https://lp.neoclinichealth.com.br"
