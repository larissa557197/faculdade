-- PACKAGE

-- fica em memória, quando executado depois tanto
-- a busca quanto o "rodar" é mais rápido


-- Criando nova tabela menor comparada as outras
CREATE TABLE clientes_aula (
    p_nome  VARCHAR2(30),
    p_email VARCHAR2(30),
    idade   NUMBER
);

----- package ----

CREATE OR REPLACE PACKAGE pkg_aula_01 AS
    PROCEDURE adicionar_cliente (
        p_nome  VARCHAR2,
        p_email VARCHAR,
        idade   NUMBER
    );
 
    FUNCTION contar_clientes RETURN NUMBER;
 
END pkg_aula_01;

-- BODY --

CREATE OR REPLACE PACKAGE BODY pkg_aula_01 AS
    PROCEDURE adicionar_cliente (
        p_nome  VARCHAR2,
        p_email VARCHAR,
        idade   NUMBER
    ) IS
    BEGIN
        INSERT INTO clientes_aula VALUES ( p_nome,
                                           p_email,
                                           idade );
        COMMIT;
    END adicionar_cliente;
    FUNCTION contar_clientes RETURN NUMBER IS
        total_clientes NUMBER;
    BEGIN
        SELECT
            COUNT(1)
        INTO total_clientes
        FROM
            clientes_aula;
        RETURN total_clientes;
    END contar_clientes;
END pkg_aula_01;


-- exibindo a aplicação
call pkg_aula_01.adicionar_cliente('Larissa', 'larimuniz@gmail.com', 19);

SELECT pkg_aula_01.contar_clientes from dual;


-- exercicio:  Criar uma package para contar todos os produtos e inserir novos produtos
CREATE OR REPLACE PACKAGE pkg_ex_aula_01 AS
    PROCEDURE adicionar_produto (
        cod_produto  NUMBER,
        nom_produto VARCHAR2,
        cod_barra   VARCHAR2,
        sta_ativo VARCHAR2,
        dat_cadastro DATE,
        dat_cancelamento DATE
);
 
    FUNCTION contar_produtos RETURN NUMBER;
 
END pkg_ex_aula_01;

-----
CREATE OR REPLACE PACKAGE BODY pkg_ex_aula_01 AS
    PROCEDURE adicionar_produto (
        cod_produto  NUMBER,
        nom_produto VARCHAR2,
        cod_barra   VARCHAR2,
        sta_ativo VARCHAR2,
        dat_cadastro DATE,
        dat_cancelamento DATE
    ) IS
    BEGIN
        INSERT INTO produto VALUES ( cod_produto,
        nom_produto,
        cod_barra,
        sta_ativo,
        dat_cadastro,
        dat_cancelamento
        );
        COMMIT;
    END adicionar_produto;
    FUNCTION contar_produtos RETURN NUMBER IS
        total_produtos NUMBER;
    BEGIN
        SELECT
            COUNT(1)
        INTO total_produtos
        FROM
            produto;
        RETURN total_produtos;
    END contar_produtos;
END pkg_ex_aula_01;

--- executando

call pkg_ex_aula_01.adicionar_produto(100, 'chiclete', 'f10op11', 'Ativo', DATE '2025-08-14', NULL);

SELECT pkg_ex_aula_01.contar_produtos from dual;

-----


select * from produto;

desc produto;