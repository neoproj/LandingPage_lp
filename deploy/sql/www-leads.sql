-- Schema www - Tabela de leads das landing pages
-- Execute no MySQL/MariaDB: mysql -u usuario -p nome_banco < www-leads.sql

CREATE SCHEMA IF NOT EXISTS www;
USE www;

CREATE TABLE IF NOT EXISTS leads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    landing_page VARCHAR(50) NOT NULL COMMENT 'Identificador: lp, gestao, lp2, lp3',
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(50),
    clinica VARCHAR(255),
    profissionais VARCHAR(20),
    faturamento VARCHAR(50),
    cidade VARCHAR(150),
    especialidade VARCHAR(100),
    mensagem TEXT,
    ip VARCHAR(45),
    user_agent VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_landing_page (landing_page),
    INDEX idx_created_at (created_at),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Identificadores das 4 landing pages (use nos formulários):
-- 'lp'      = lp.neoclinichealth.com.br (NeoClinic 3.7.0)
-- 'gestao'  = gestao.neoclinichealth.com.br
-- 'lp2'     = 3ª landing page
-- 'lp3'     = 4ª landing page
