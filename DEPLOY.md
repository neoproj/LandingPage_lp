# Deploy - lp.neoclinichealth.com.br

Guia para publicar a landing page no subdomínio **lp.neoclinichealth.com.br** e configurar o sistema de leads.

---

## Banco de Dados (www.leads)

Execute o SQL no servidor para criar a tabela de leads:

```bash
mysql -u usuario -p nome_banco < deploy/sql/www-leads.sql
```

**Identificadores das 4 landing pages:**
| slug    | domínio                         |
|---------|----------------------------------|
| `lp`    | lp.neoclinichealth.com.br       |
| `gestao`| gestao.neoclinichealth.com.br   |
| `lp2`   | 3ª landing page                 |
| `lp3`   | 4ª landing page                 |

---

## API de Leads (deploy no www)

A API deve ficar em **www.neoclinichealth.com.br/api/**:

1. Copie a pasta `api/` para o servidor em `/home/andre/www.neoclinichealth.com.br/api/` (ou caminho do www)
2. Renomeie `config.example.php` para `config.php` e preencha as credenciais do banco
3. Garanta que o PHP tenha extensão PDO MySQL

---

## Deploy via SSH (chave em C:\Users\Andre Luiz\.ssh)

O script usa automaticamente `id_rsa` ou `id_ed25519` da pasta `.ssh`.

**No Windows (PowerShell):**
```powershell
cd "c:\LandingPages\laçamento.neoclinichealth.com.br"
.\deploy\deploy-ssh.ps1 -Server "usuario@ip-do-servidor"
```

**No Linux/macOS:**
```bash
./deploy/deploy-ssh.sh usuario@ip-do-servidor
```

Substitua `usuario` pelo seu usuário SSH e `ip-do-servidor` pelo IP ou domínio do servidor.

---

## Opção 1: Vercel (mais rápido, gratuito)

1. Acesse [vercel.com](https://vercel.com) e faça login com GitHub
2. **Add New Project** → importe o repositório `neoproj/LandingPage_lp`
3. Em **Framework Preset** escolha "Other"
4. **Deploy**
5. Depois do deploy: **Settings** → **Domains** → adicione `lp.neoclinichealth.com.br`
6. No painel do seu provedor de DNS (Registro.br, Cloudflare, etc.), crie:
   - **Tipo:** CNAME
   - **Nome:** lp (ou lp.neoclinichealth)
   - **Valor:** cname.vercel-dns.com

---

## Opção 2: Servidor VPS (Nginx)

### 1. Criar pasta no servidor
```bash
sudo mkdir -p /var/www/lp.neoclinichealth.com.br
sudo chown $USER:$USER /var/www/lp.neoclinichealth.com.br
```

### 2. Clonar ou fazer upload dos arquivos
```bash
cd /var/www/lp.neoclinichealth.com.br
git clone https://github.com/neoproj/LandingPage_lp.git .
# OU: faça upload de index.html, css/, js/, assets/
```

### 3. Configurar Nginx
```bash
sudo cp deploy/nginx-lp.conf /etc/nginx/sites-available/lp.neoclinichealth.com.br
sudo ln -s /etc/nginx/sites-available/lp.neoclinichealth.com.br /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### 4. DNS
No painel DNS do domínio neoclinichealth.com.br:
- **Tipo:** A
- **Nome:** lp
- **Valor:** IP do seu servidor

---

## Opção 3: cPanel / Hospedagem compartilhada

1. Crie o subdomínio `lp` em **Domínios** → **Subdomínios**
2. Use o **Gerenciador de Arquivos** ou **FTP**
3. Envie para a pasta do subdomínio (ex: `public_html/lp` ou `lp.neoclinichealth.com.br`):
   - `index.html`
   - pasta `css/`
   - pasta `js/`
   - pasta `assets/`

---

## Arquivos necessários para o deploy

```
index.html
css/styles.css
js/main.js
assets/NeoClinic-01.png
```

O DNS pode levar até 24–48 horas para propagar.
