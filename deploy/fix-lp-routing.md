# Corrigir: lp caindo no backoffice

Se **lp.neoclinichealth.com.br** redireciona para o backoffice, o backoffice provavelmente tem `default_server`.

## 1. Verificar config do backoffice

```bash
ssh andre@76.13.161.233
grep -r "default_server" /etc/nginx/
```

## 2. Remover default_server do backoffice

Edite o arquivo do backoffice (ex: `/etc/nginx/sites-available/backoffice...`):

**Antes:**
```
listen 80 default_server;
```

**Depois:**
```
listen 80;
```

Ou mova `default_server` para outro server (ex: o www principal).

## 3. Garantir que o lp carrega primeiro

```bash
sudo ln -sf /etc/nginx/sites-available/lp.neoclinichealth.com.br /etc/nginx/sites-enabled/00-lp.neoclinichealth.com.br
sudo nginx -t && sudo systemctl reload nginx
```

## 4. Limpar cache do navegador

- Ctrl+Shift+Delete (limpar cache)
- Ou abra em aba anônima para testar
