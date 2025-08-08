
-- AULA 07/08 --

-- TRIGGERS:

--      - um obj de banco de dados que dispara automaticamente
--        quando acontece um evento (delete, insert, etc)

--        ex: toda vez que tiver um delete é lançado algum obj

--      - pode ser sempre antes de uma ação (antes de um insert 
--        pega os dados e insere e depois faz o update)


-- CRIAÇÃO DA NOVA TABELA
CREATE TABLE PEDIDO_NOVOS AS SELECT * FROM PEDIDO;

ALTER TABLE PEDIDO_NOVOS ADD STATUS VARCHAR2(30);

SELECT * FROM PEDIDO_NOVOS;
-----


-- fazendo a trigger
CREATE OR REPLACE TRIGGER trg_pedido BEFORE
    INSERT ON pedido_novos
    -- são na linha que ta atualizando = status
    -- sem o each ia 'ler' toda a tabela depois achar a linha pra fazer o trigger 
    FOR EACH ROW
BEGIN

-- ATUALIZA o STATUS do pedido para "NOVO" após a inserção
    IF :new.status IS NULL THEN
        :new.status := 'Novo Pedido';
    END IF;
END;

-- Fazendo um insert na tabela PEDIDO_NOVOS
INSERT INTO pedido_novos (
    cod_pedido,
    cod_cliente,
    cod_usuario
) VALUES ( 557197,
           74,
           1 );
           
-- fazendo um select com where
SELECT * FROM pedido_novos WHERE cod_pedido = 557197;


-- CRIANDO a tabela TB_AUDITORIA
CREATE TABLE tb_auditoria (
    id       NUMBER
        GENERATED ALWAYS AS IDENTITY,
    tabela   VARCHAR2(30),
    operacao VARCHAR2(30),
    data     DATE,
    usuario  VARCHAR2(30)
)


SELECT * FROM tb_auditoria;


--  trigger: chamado trg_auditoria, são executado automaticamente
--  após qualquer operação de INSERT, UPDATE ou DELETE na tabela
--  PEDIDO_NOVOS. A cada vez que uma dessas operações ocorre, ele
--  insere um registro na tabela TB_AUDITORIA contendo:

  --------------------------------------------------------------
--|-- o nome da tabela (PEDIDO_NOVOS),                         |

--|-- o tipo de operação realizada (INSERT, UPDATE ou DELETE), |

--|-- a data e hora da operação (SYSDATE),                     |

--|-- o nome do usuário da sessãoo que realizou a operação.     |
  --------------------------------------------------------------
  
CREATE OR REPLACE TRIGGER trg_auditoria AFTER
    INSERT OR UPDATE OR DELETE ON pedido_novos
    FOR EACH ROW
DECLARE
    operacao     VARCHAR2(30);
    nome_usuario VARCHAR2(30);
BEGIN
    -- Determina a operação realizada (INSERT, UPDATE ou DELETE)
    IF inserting THEN
        operacao := 'INSERT';
    ELSIF updating THEN
        operacao := 'UPDATE';
    ELSIF deleting THEN
        operacao := 'DELETE';
    END IF;

-- Obtém o nome de usuário da sessão atual
    nome_usuario := sys_context('USERENV', 'SESSION_USER');

-- Registra a auditoria na tabela de auditoria
    INSERT INTO tb_auditoria (
        tabela,
        operacao,
        data,
        usuario
    ) VALUES ( 'PEDIDO_NOVOS',
               operacao,
               sysdate,
               nome_usuario );

END;

-- testando:

INSERT INTO pedido_novos (
    cod_pedido,
    cod_cliente,
    cod_usuario
) VALUES ( 556196,
           76,
           2 );
           
-- fazendo o select 
SELECT * FROM tb_auditoria;

SET SERVEROUTPUT ON;

-- EXERCICIOS:
-- 1. Crie uma trigger para registrar as alterações de DATA DE ENTREGA(dat_entrega) na tabela PEDIDO.
CREATE OR REPLACE TRIGGER trg_alt_data_entrega BEFORE
    UPDATE OF dat_entrega ON pedido
    FOR EACH ROW
BEGIN 
    -- só registra se a data de entrega mudou mesmo
    IF :old.dat_entrega != :new.dat_entrega THEN
    DBMS_OUTPUT.PUT_LINE('Data de entrega alterada.');
    END IF;
END;

-- fazendo um update pra testar a trigger:
UPDATE pedido
SET
    dat_entrega = TO_DATE('2025-08-09', 'YYYY-MM-DD')
WHERE
    cod_pedido = 160387;
    
    
-- select da tabela PEDIDO
SELECT * FROM PEDIDO WHERE cod_pedido = 999999;


-- devolvendo pra 

-- 2. Crie uma trigger que consulta a quantidade de itens na tabela ITEM_PEDIDO e some 
--    o total de produto do mesmo pedido, caso esse total seja maio que 20 itens aplique
--    um desconto automático que 20% (if - count)

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER trg_applica_desconto
AFTER INSERT ON item_pedido
DECLARE 
    total_itens NUMBER;
BEGIN
-- loop pra aplicar o desconto em todos pedidos que passaram de 20 itens 
    FOR 

BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO item_pedido (
      cod_pedido,
      cod_item_pedido,
      cod_produto,
      qtd_item,
      val_unitario_item
    ) VALUES (
      130900,       -- pedido existente, use o seu
      i,
      i,            -- cod_produto usando os códigos válidos 1 a 10
      1,
      10
    );
  END LOOP;
END;


-- select na tabela ITEM_PEDIDO
SELECT * FROM ITEM_PEDIDO;

SELECT cod_pedido FROM pedido WHERE ROWNUM = 1;

SELECT cod_produto FROM produto WHERE ROWNUM <= 10;




-- 3. Crie uma trigger em na tabela de clientes para validar CPF/CNPJ contenha somente 
--    valores numéricos (tem essa função no banco)

CREATE OR REPLACE TRIGGER trg_valida_num_cpf_cnpj
BEFORE INSERT OR UPDATE OF num_cpf_cnpj ON cliente
FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(TO_CHAR(:new.num_cpf_cnpj), '^[0-9]+$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'CPF/CNPJ deve conter apenas números.');
    END IF;
END;

-- testando 
-- Exemplo válido: CPF/CNPJ numérico
INSERT INTO cliente (
    cod_cliente,
    nom_cliente,
    des_razao_social,
    tip_pessoa,
    num_cpf_cnpj,
    dat_cadastro,
    sta_ativo
) VALUES (
    1001,
    'João Silva',
    'João Silva ME',
    'F',
    12345678901,
    SYSDATE,
    'S'
);


DESC CLIENTE;
SELECT * FROM CLIENTE;