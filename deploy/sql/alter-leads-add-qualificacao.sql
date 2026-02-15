-- Execute se a tabela www.leads já existir (adiciona campos de qualificação)
-- Ignore erros de "Duplicate column" se as colunas já existirem
ALTER TABLE www.leads ADD COLUMN clinica VARCHAR(255);
ALTER TABLE www.leads ADD COLUMN profissionais VARCHAR(20);
ALTER TABLE www.leads ADD COLUMN faturamento VARCHAR(50);
ALTER TABLE www.leads ADD COLUMN cidade VARCHAR(150);
