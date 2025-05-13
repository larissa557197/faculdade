-- paralelizar os processos com os cursores
-- dentro de um crusor eu posso chamar em várias sessões diferentes 
-- posso chamar um cursor dentro do outro 
-- evitar ORDER BY pra melhor "funcionamento"
-- desempenho e .. de dados rápida
-- TIPOS:

    -- explicitos:
        -- um objeto com mesmo cursor
        -- "isso é um cursor"
        -- vai ser sempre SELECT, tirando quando for o FOR
        -- podem ter WHERE
        
            
    -- implícitos:
        -- SELECT, UPDATE, DELETE dentro de um BEGIN -> END
    
    -- comportamento:
    
        -- estático:
            -- sempre vai retornar 
        -- dinâmicos:
            -- depende de um parâmetro, e dependendo do where ele vai chamar uma quantidade de dados expecificos
        
    -- podem ser:
        -- FOR UPDATE
 
set SERVEROUTPUT on;       
        
CREATE TABLE historico (
    cod_produto       NUMBER,
    nome_produto      VARCHAR2(50),
    data_movimentacao DATE
);

-- EXPLICITO:
DECLARE
    v_codigo produto.cod_produto%TYPE := 2;
    CURSOR cur_emp IS
    SELECT
        nom_produto
    FROM
        produto
    WHERE
        cod_produto = v_codigo;

BEGIN
    FOR x IN cur_emp LOOP
        INSERT INTO historico VALUES (
            v_codigo,
            x.nom_produto,
            sysdate
        );

        COMMIT;
    END LOOP;
END;

-- maneira extensa:
    -- var 
    -- quando precisa ser exato
    -- ex: consulta pra ver coisas bem exatas 
    -- precisa ser finalizado
    -- TER EXATIDÃO em cada linha
        --

-- navegação:
    -- é sempre em sequencia 
    
-- com parâmetros:

    -- igual em funções e procedures


-- subir o dado pra memoria e atualizar:

    -- WHERE CURRENT OF

-- ROWID:
    -- vai saber onde ta no disco 
    -- toda tabela tem esse endereço de disco

SELECT ROWID, x.* FROM cliente x;    

-- exercicios 

-- 1.) Fazer um bloco anônimo com cursor que realize uma consulta na tabela de clientes 
--     e retorne o código e o nome do cliente, use dbms_output para mostrar as informações como o exemplo abaixo: 
--     Cliente: 1 Nome: Jose da Silva
--     Cliente: 2 Nome: Maria da Silva


DECLARE
    CURSOR c_consulta_cliente IS
    SELECT
        cod_cliente,
        nom_cliente
    FROM
        cliente;

BEGIN
    FOR x IN c_consulta_cliente LOOP
        dbms_output.put_line('Cliente: '
                             || x.cod_cliente
                             || ' - Nome: '
                             || x.nom_cliente);
    END LOOP;
END;



-- 2.) Faça um procedimento chamado PRC_VALIDA_TOTAL_PEDIDO que receba como parametro o código do pedido e
--     que utilize dois cursores, um para localizar o pedido e outro para acessar os itens deste pedido , fazendo a soma dos
--     itens e ao final verificar se a soma dos itens (quantidade * preço unitário) – desconto é igual ao total do pedido.
--     Caso os valores coincidam retorne pelo parametro p_retorno a mensagem ‘pedido ok’ , caso contrario retorne ‘total
--     dos itens não coincide com valor total do pedido’

CREATE OR REPLACE PROCEDURE prc_valida_total_pedido (
    p_cod_pedido IN NUMBER,
    p_retorno OUT VARCHAR2
) AS
    -- Variáveis do pedido
    v_val_total     pedido.val_total_pedido%TYPE;
    v_val_desconto  pedido.val_desconto%TYPE;

    -- Variável para somar os itens
    v_soma_itens NUMBER := 0;

    -- Cursor 1: pedido
    CURSOR c_pedido IS
        SELECT val_total_pedido, val_desconto
        FROM pedido
        WHERE cod_pedido = p_cod_pedido;

    -- Cursor 2: itens do pedido
    CURSOR c_itens IS
        SELECT qtd_item_pedido, val_item_pedido
        FROM item_pedido
        WHERE cod_pedido = p_cod_pedido;
BEGIN
    -- Abre o cursor do pedido
    OPEN c_pedido;
    FETCH c_pedido INTO v_val_total, v_val_desconto;

    IF c_pedido%NOTFOUND THEN
        p_retorno := 'Pedido não encontrado.';
        CLOSE c_pedido;
        RETURN;
    END IF;
    CLOSE c_pedido;

    -- Soma os itens do pedido
    FOR item IN c_itens LOOP
        v_soma_itens := v_soma_itens + (item.qtd_item_pedido * item.val_item_pedido);
    END LOOP;

    -- Valida
    IF ROUND(v_soma_itens - v_val_desconto, 2) = ROUND(v_val_total, 2) THEN
        p_retorno := 'Pedido OK';
    ELSE
        p_retorno := 'Total dos itens não coincide com valor total do pedido';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_retorno := 'Erro ao validar o pedido.';
END;


-- testando
DECLARE
    v_mensagem VARCHAR2(100);
BEGIN
    prc_valida_total_pedido(1234, v_mensagem);
    DBMS_OUTPUT.PUT_LINE(v_mensagem);
END;


-- 3.)  Faça um procedimento chamado PRC_DELETA_PEDIDO que receba como parametro o numero do pedido e que
--      antes de excluir o pedido execute um cursor na tabela de itens de pedido e faça o delete de cada um deles usando a
--      técnica de ROWID.


CREATE OR REPLACE PROCEDURE prc_deleta_pedido(p_cod_pedido IN NUMBER) AS
    -- Cursor com ROWID para excluir itens
    CURSOR c_itens IS
        SELECT rowid FROM item_pedido WHERE cod_pedido = p_cod_pedido;
BEGIN
    -- Deletar os itens usando rowid
    FOR reg IN c_itens LOOP
        DELETE FROM item_pedido WHERE rowid = reg.rowid;
    END LOOP;

    -- Agora excluir o pedido
    DELETE FROM pedido WHERE cod_pedido = p_cod_pedido;

    DBMS_OUTPUT.PUT_LINE('Pedido e itens excluídos com sucesso.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir o pedido.');
END;

-- testando
BEGIN
    prc_deleta_pedido(1234); -- substitua pelo número do pedido
END;

