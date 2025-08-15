-- ========================
-- CRIAÇÃO DAS TABELAS
-- ========================

CREATE TABLE tbl_estado (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    uf        VARCHAR(2) NOT NULL,
    CHECK (LEN(uf) = 2)
);

CREATE TABLE tbl_cidade (
    id_cidade INT IDENTITY(1,1) PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_estado) REFERENCES tbl_estado(id_estado)
);

CREATE TABLE tbl_bairro (
    id_bairro INT IDENTITY(1,1) PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    id_cidade INT NOT NULL,
    FOREIGN KEY (id_cidade) REFERENCES tbl_cidade(id_cidade)
);

CREATE TABLE tbl_localizacao (
    id_localizacao INT IDENTITY(1,1) PRIMARY KEY,
    logradouro     VARCHAR(100) NOT NULL,
    numero         VARCHAR(10) NOT NULL,
    complemento    VARCHAR(50),
    cep            VARCHAR(8) NOT NULL,
    id_bairro      INT NOT NULL,
    CHECK (cep LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    FOREIGN KEY (id_bairro) REFERENCES tbl_bairro(id_bairro)
);

CREATE TABLE tbl_usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    email      VARCHAR(200) NOT NULL UNIQUE,
    senha      VARCHAR(100) NOT NULL,
    role       VARCHAR(20) NOT NULL DEFAULT 'USER',
    CHECK (role IN ('ADMIN', 'USER'))
);

CREATE TABLE tbl_orgaos_publicos (
    id_orgao INT IDENTITY(1,1) PRIMARY KEY,
    nome         VARCHAR(150) NOT NULL,
    area_atuacao VARCHAR(20) NOT NULL,
    CHECK (area_atuacao IN ('Urbana', 'Ambiental', 'Saude'))
);

CREATE TABLE tbl_denuncias (
    id_denuncia    INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario     INT NOT NULL,
    id_localizacao INT NOT NULL,
    data_hora      DATETIME NOT NULL,
    descricao      VARCHAR(250) NOT NULL,
    id_orgao       INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_localizacao) REFERENCES tbl_localizacao(id_localizacao),
    FOREIGN KEY (id_orgao) REFERENCES tbl_orgaos_publicos(id_orgao)
);

CREATE TABLE tbl_acompanhamento_denuncia (
    id_acompanhamento INT IDENTITY(1,1) PRIMARY KEY,
    status            VARCHAR(20) NOT NULL,
    data_atualizacao  DATETIME NOT NULL,
    descricao         VARCHAR(200),
    id_denuncia       INT NOT NULL,
    CHECK (status IN ('Aberto', 'Em Andamento', 'Concluido')),
    FOREIGN KEY (id_denuncia) REFERENCES tbl_denuncias(id_denuncia) ON DELETE CASCADE
);

-- ========================
-- POPULANDO AS TABELAS
-- ========================

-- ESTADOS
INSERT INTO tbl_estado (nome, uf) VALUES ('São Paulo', 'SP');
INSERT INTO tbl_estado (nome, uf) VALUES ('Rio de Janeiro', 'RJ');
INSERT INTO tbl_estado (nome, uf) VALUES ('Minas Gerais', 'MG');
INSERT INTO tbl_estado (nome, uf) VALUES ('Paraná', 'PR');
INSERT INTO tbl_estado (nome, uf) VALUES ('Bahia', 'BA');

-- CIDADES
INSERT INTO tbl_cidade (nome, id_estado) VALUES ('São Paulo', 1);
INSERT INTO tbl_cidade (nome, id_estado) VALUES ('Rio de Janeiro', 2);
INSERT INTO tbl_cidade (nome, id_estado) VALUES ('Belo Horizonte', 3);
INSERT INTO tbl_cidade (nome, id_estado) VALUES ('Curitiba', 4);
INSERT INTO tbl_cidade (nome, id_estado) VALUES ('Salvador', 5);

-- BAIRROS
INSERT INTO tbl_bairro (nome, id_cidade) VALUES ('Centro', 1);
INSERT INTO tbl_bairro (nome, id_cidade) VALUES ('Copacabana', 2);
INSERT INTO tbl_bairro (nome, id_cidade) VALUES ('Savassi', 3);
INSERT INTO tbl_bairro (nome, id_cidade) VALUES ('Batel', 4);
INSERT INTO tbl_bairro (nome, id_cidade) VALUES ('Barra', 5);

-- LOCALIZACOES
INSERT INTO tbl_localizacao (logradouro, numero, complemento, cep, id_bairro)
VALUES ('Rua Augusta', '123', 'Apto 12', '01000000', 1);

INSERT INTO tbl_localizacao (logradouro, numero, complemento, cep, id_bairro)
VALUES ('Av. Atlântica', '456', NULL, '22000000', 2);

INSERT INTO tbl_localizacao (logradouro, numero, complemento, cep, id_bairro)
VALUES ('Rua da Bahia', '789', 'Fundos', '30100000', 3);

INSERT INTO tbl_localizacao (logradouro, numero, complemento, cep, id_bairro)
VALUES ('Av. do Batel', '101', NULL, '80400000', 4);

INSERT INTO tbl_localizacao (logradouro, numero, complemento, cep, id_bairro)
VALUES ('Av. Oceânica', '202', 'Casa', '40100000', 5);

-- USUÁRIOS
INSERT INTO tbl_usuarios (nome, email, senha, role)
VALUES ('João Silva', 'joao@gmail.com', 'senha123', 'USER');

INSERT INTO tbl_usuarios (nome, email, senha, role)
VALUES ('Maria Souza', 'maria@gmail.com', 'senha456', 'ADMIN');

INSERT INTO tbl_usuarios (nome, email, senha, role)
VALUES ('Carlos Lima', 'carlos@gmail.com', 'senha789', 'USER');

INSERT INTO tbl_usuarios (nome, email, senha, role)
VALUES ('Ana Paula', 'ana@gmail.com', 'senha321', 'USER');

INSERT INTO tbl_usuarios (nome, email, senha, role)
VALUES ('Fernanda Costa', 'fernanda@gmail.com', 'senha654', 'ADMIN');

-- ÓRGÃOS PÚBLICOS
INSERT INTO tbl_orgaos_publicos (nome, area_atuacao)
VALUES ('Secretaria de Urbanismo', 'Urbana');

INSERT INTO tbl_orgaos_publicos (nome, area_atuacao)
VALUES ('Instituto Ambiental', 'Ambiental');

INSERT INTO tbl_orgaos_publicos (nome, area_atuacao)
VALUES ('Vigilância Sanitária', 'Saude');

INSERT INTO tbl_orgaos_publicos (nome, area_atuacao)
VALUES ('Prefeitura Municipal', 'Urbana');

INSERT INTO tbl_orgaos_publicos (nome, area_atuacao)
VALUES ('Secretaria da Saúde', 'Saude');

-- DENUNCIAS
INSERT INTO tbl_denuncias (id_usuario, id_localizacao, data_hora, descricao, id_orgao)
VALUES (1, 1, GETDATE(), 'Calçada danificada.', 1);

INSERT INTO tbl_denuncias (id_usuario, id_localizacao, data_hora, descricao, id_orgao)
VALUES (2, 2, GETDATE(), 'Lixo acumulado.', 2);

INSERT INTO tbl_denuncias (id_usuario, id_localizacao, data_hora, descricao, id_orgao)
VALUES (3, 3, GETDATE(), 'Posto de saúde sem médicos.', 3);

INSERT INTO tbl_denuncias (id_usuario, id_localizacao, data_hora, descricao, id_orgao)
VALUES (4, 4, GETDATE(), 'Buraco na via.', 4);

INSERT INTO tbl_denuncias (id_usuario, id_localizacao, data_hora, descricao, id_orgao)
VALUES (5, 5, GETDATE(), 'Foco de dengue.', 5);

-- ACOMPANHAMENTO
INSERT INTO tbl_acompanhamento_denuncia (status, data_atualizacao, descricao, id_denuncia)
VALUES ('Aberto', GETDATE(), 'Denúncia registrada.', 1);

INSERT INTO tbl_acompanhamento_denuncia (status, data_atualizacao, descricao, id_denuncia)
VALUES ('Em Andamento', GETDATE(), 'Equipe enviada ao local.', 2);

INSERT INTO tbl_acompanhamento_denuncia (status, data_atualizacao, descricao, id_denuncia)
VALUES ('Concluido', GETDATE(), 'Problema resolvido.', 3);

INSERT INTO tbl_acompanhamento_denuncia (status, data_atualizacao, descricao, id_denuncia)
VALUES ('Em Andamento', GETDATE(), 'Serviço em execução.', 4);

INSERT INTO tbl_acompanhamento_denuncia (status, data_atualizacao, descricao, id_denuncia)
VALUES ('Aberto', GETDATE(), 'Aguardando avaliação.', 5);
 