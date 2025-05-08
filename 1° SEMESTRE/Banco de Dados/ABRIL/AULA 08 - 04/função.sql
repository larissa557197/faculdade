-- SINTAXE
-- obrigatoriamente a função tem que ter um return

set SERVEROUTPUT on;

CREATE OR REPLACE FUNCTION calcx_fgts (
    valor NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN valor * 0.08;
END calcx_fgts;

-- usando o select
        -- nome da função -> parametro dela 
SELECT calcx_fgts(1000) FROM DUAL; -- DUAL: tabela temporária

-- dentro de uma procedure
CREATE OR REPLACE PROCEDURE prx_fgts AS
    v_valor NUMBER;
BEGIN
    v_valor := calcx_fgts(150000);
    dbms_output.put_line('O valor do FGTS é: ' || v_valor);
END;

CALL prx_fgts();

-- EXCEÇÕES:
-- crio uma exceção e uso ela -> exception

CREATE OR REPLACE FUNCTION calcx_fgts (
    valor NUMBER
) RETURN NUMBER IS
    me_erro EXCEPTION;
    v_valor NUMBER;
BEGIN
    v_valor := valor * 0.08;
    IF v_valor < 80 THEN
        RAISE me_erro;
    END IF;
    RETURN v_valor;
EXCEPTION
    WHEN me_erro THEN
        raise_application_error(-20001, 'FGTS NÃO PODE SER MENOR QUE 80 REAIS');
        -- tem exceções da prórpia oracle
END calcx_fgts;

SELECT calcx_fgts(100) FROM DUAL;


-- EXERCÍCIOS

-- 1) Crie um procedimento chamado prc_insere_produto para todas as colunas da tabela de produtos, valide:
        -- se o nome do produto tem mais de 3 caracteres e não contem números (0 a 9)
CREATE OR REPLACE PROCEDURE prc_insere_produto (
   p_cod_produto NUMBER,
   p_nom_produto VARCHAR2,
   p_cod_barra NUMBER,
   p_sta_ativo VARCHAR2,
   p_dat_cadastro DATE,
   p_dat_cancelamento DATE
) AS
BEGIN
   -- Se o nome do produto tem mais de 3 caracteres
   IF LENGTH(p_nom_produto) > 3 THEN
       -- Verifica se o nome não contém números
       IF NOT REGEXP_LIKE(p_nom_produto, '[0-9]') THEN
           -- Inserindo o produto na tabela
           INSERT INTO produto (cod_produto, nom_produto, cod_barra, sta_ativo, dat_cadastro, dat_cancelamento)
           VALUES (p_cod_produto, p_nom_produto, p_cod_barra, p_sta_ativo, p_dat_cadastro, p_dat_cancelamento);
           COMMIT;
           dbms_output.put_line('Produto inserido com sucesso!');
       ELSE
           -- Caso o nome contenha números, lançar erro
           RAISE_APPLICATION_ERROR(-20001, 'Erro: O nome do produto não pode ter números.');
       END IF;
   ELSE
       -- Caso o nome tenha 3 ou menos caracteres, lançar erro
       RAISE_APPLICATION_ERROR(-20002, 'Erro: O nome do produto deve ter mais de 3 caracteres.');
   END IF;
END;

SELECT * FROM produto;

CALL prc_insere_produto(55, 'Cabo', 4428922004, 'Ativo', SYSDATE, NULL);   

-- 2) Crie um procedimento chamado prc_insere_cliente para inserir novos clientes, valide:
      -- Se o nome do cliente tem mais de 3 caracteres e não contem números (0 a 9)
CREATE OR REPLACE PROCEDURE prc_insere_cliente (
    p_cod_cliente NUMBER, 
    p_nom_cliente VARCHAR2, 
    p_razao_social VARCHAR2, 
    p_tip_pessoa VARCHAR2, 
    p_num_cpf_cnpj VARCHAR2, 
    p_dat_cadastro DATE,
    p_dat_cancelamento DATE,
    p_sta_ativo VARCHAR2
) AS
BEGIN
    -- Se o nome do cliente tem mais de 3 caracteres
    IF LENGTH(p_nom_cliente) > 3 THEN
        -- Se o nome do cliente não contém números usando REGEXP_LIKE
        IF NOT REGEXP_LIKE(p_nom_cliente, '[0-9]') THEN
            -- Inserindo o cliente na tabela
            INSERT INTO cliente (cod_cliente, nom_cliente, des_razao_social, tip_pessoa, num_cpf_cnpj, dat_cadastro, dat_cancelamento, sta_ativo)
            VALUES (p_cod_cliente, p_nom_cliente, p_razao_social, p_tip_pessoa, p_num_cpf_cnpj, p_dat_cadastro, p_dat_cancelamento, p_sta_ativo);

            COMMIT;  -- Realiza o commit
            dbms_output.put_line('Cliente inserido com sucesso!');
        ELSE
            -- Caso o nome contenha números, lançar erro
           RAISE_APPLICATION_ERROR(-20001, 'Erro: O nome do cliente não pode ter números.');
        END IF;
    ELSE
        -- Caso o nome tenha 3 ou menos caracteres, lançar erro
       RAISE_APPLICATION_ERROR(-20002, 'Erro: O nome do cliente deve ter mais de 3 caracteres.');
    END IF;
END;


CALL prc_insere_cliente(147, 'Laura Muniz', 'LM Solutions', 'F', '12345678901', SYSDATE, NULL, 'S');

SELECT * FROM cliente;


-- 3) Crie uma função chamada FUN_VALIDA_NOME que valide se o nome tem mais do que 3 caracteres e não tenha números.

CREATE OR REPLACE FUNCTION fun_valida_nome (
   nome VARCHAR2
) RETURN VARCHAR2 IS
    ME_ERRO EXCEPTION;
BEGIN
   -- Verifica se o nome tem mais de 3 caracteres
   IF LENGTH(nome) <= 3 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Nome deve ter mais de 3 caracteres');
   END IF;
   -- Verifica se o nome contém números
   IF REGEXP_LIKE(nome, '[0-9]') THEN
       RAISE_APPLICATION_ERROR(-20002, 'Nome não pode conter números');
   END IF;
   -- Se passou nas duas validações, retorna o nome como válido
   RETURN nome;
EXCEPTION
   WHEN OTHERS THEN
       -- Captura qualquer erro inesperado 
       RAISE me_erro;
       
END fun_valida_nome;

SELECT fun_valida_nome('Maria') FROM DUAL;
SELECT fun_valida_nome('Jo') FROM DUAL;  -- o nome tem menos que 3 caracteres
SELECT fun_valida_nome('João123') FROM DUAL; -- o nome tem numeros 

-- 4) Altere os procedimentos dos exercícios 1 e 2 para chamar a função do exercício 3

-- exercicio 1 pra chamar a função do ex 3:
CREATE OR REPLACE PROCEDURE prc_insere_produto (
  p_cod_produto NUMBER,
  p_nom_produto VARCHAR2,
  p_cod_barra NUMBER,
  p_sta_ativo VARCHAR2,
  p_dat_cadastro DATE,
  p_dat_cancelamento DATE
) AS
  v_resultado VARCHAR2(100);
BEGIN
  -- Chama a função de validação de nome do produto
  v_resultado := fun_valida_nome(p_nom_produto);
  -- Se o nome do produto for válido, faz a inserção
  IF v_resultado = p_nom_produto THEN
     -- Inserindo o produto na tabela
     INSERT INTO produto (cod_produto, nom_produto, cod_barra, sta_ativo, dat_cadastro, dat_cancelamento)
     VALUES (p_cod_produto, p_nom_produto, p_cod_barra, p_sta_ativo, p_dat_cadastro, p_dat_cancelamento);
     COMMIT;
     dbms_output.put_line('Produto inserido com sucesso!');
  ELSE
     -- Caso o nome do produto não seja válido, a função já gerará erro
     NULL; -- Não é necessário realizar mais ações, pois a função já gera erro se inválido
  END IF;
EXCEPTION
  WHEN OTHERS THEN
     -- Captura qualquer erro inesperado
     RAISE_APPLICATION_ERROR(-20003, 'Erro ao inserir o produto' );
END;

CALL prc_insere_produto(56, 'Cabos', 44289220045, 'Ativo', SYSDATE, NULL);
SELECT * FROM produto;

-- exercicio 2 para chamar a função do ex 3:
CREATE OR REPLACE PROCEDURE prc_insere_cliente (
   p_cod_cliente NUMBER,
   p_nom_cliente VARCHAR2,
   p_razao_social VARCHAR2,
   p_tip_pessoa VARCHAR2,
   p_num_cpf_cnpj VARCHAR2,
   p_dat_cadastro DATE,
   p_dat_cancelamento DATE,
   p_sta_ativo VARCHAR2
) AS
   v_resultado VARCHAR2(100);
BEGIN
   -- Chama a função de validação de nome do cliente
   v_resultado := fun_valida_nome(p_nom_cliente);
   -- Se o nome do cliente for válido, faz a inserção
   IF v_resultado = p_nom_cliente THEN
       -- Inserindo o cliente na tabela
       INSERT INTO cliente (cod_cliente, nom_cliente, des_razao_social, tip_pessoa, num_cpf_cnpj, dat_cadastro, dat_cancelamento, sta_ativo)
       VALUES (p_cod_cliente, p_nom_cliente, p_razao_social, p_tip_pessoa, p_num_cpf_cnpj, p_dat_cadastro, p_dat_cancelamento, p_sta_ativo);
       COMMIT;  -- Realiza o commit
       dbms_output.put_line('Cliente inserido com sucesso!');
   ELSE
       -- Caso o nome do cliente não seja válido, a função já gerará erro
       NULL; -- Não é necessário realizar mais ações, pois a função já gera erro se inválido
   END IF;
EXCEPTION
   WHEN OTHERS THEN
       -- Captura qualquer erro inesperado
       RAISE_APPLICATION_ERROR(-20003, 'Erro ao inserir o cliente ');
END;

CALL prc_insere_cliente(148, 'Bru1234', 'BM Solutions', 'F', '12345678901', SYSDATE, NULL, 'S');

SELECT * FROM cliente;


-- 5) Altere o procedimento do exercício 1 para que tenha um último parâmetro chamado P_RETORNO 
      -- do tipo varchar2 que deverá retornar a informação ‘produto cadastrado com sucesso’.
      
-- será feito na proxima aula 
      
-- 6) Crie um bloco anônimo e chame o procedimento do exercício 1
      
DECLARE
    v_retorno VARCHAR2(100);  -- Variável para capturar a mensagem de retorno
BEGIN
  -- Chama o procedimento prc_insere_produto
    prc_insere_produto(p_cod_produto => 55, p_nom_produto => 'Cabo', p_cod_barra => 4428922004, p_sta_ativo => 'Ativo', p_dat_cadastro => sysdate
    ,
                      p_dat_cancelamento => NULL, p_retorno => v_retorno  -- Passando a variável v_retorno como parâmetro de saída
                      );
  -- Exibe a mensagem de retorno
    dbms_output.put_line(v_retorno);
END;