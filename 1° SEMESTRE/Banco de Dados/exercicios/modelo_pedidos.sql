BEGIN
    FOR x IN (
        SELECT
            table_name
        FROM
            user_tables
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE '
                          || x.table_name
                          || 'CASCADE CONSTRAINTS';
    END LOOP;
END;

@ 'C:\Users\labsfiap\Desktop\oracle\SCRIPT_MODELO_PEDIDO(1).SQL';

ALTER TABLE CIDADE MODIFY NOM_CIDADE VARCHAR2(50);
ALTER TABLE PEDIDO ADD STATUS VARCHAR2(50);

set serveroutput on;


-- 1. Tabelas independentes
INSERT INTO PAIS SELECT * FROM PF1788.PAIS;
COMMIT;
SELECT * FROM PAIS;
 
INSERT INTO TIPO_MOVIMENTO_ESTOQUE SELECT * FROM PF1788.TIPO_MOVIMENTO_ESTOQUE;
COMMIT;
SELECT * FROM TIPO_MOVIMENTO_ESTOQUE;

 
INSERT INTO TIPO_ENDERECO SELECT * FROM PF1788.TIPO_ENDERECO;
COMMIT;
SELECT * FROM TIPO_ENDERECO;

 
INSERT INTO USUARIO SELECT * FROM PF1788.USUARIO;
COMMIT;
SELECT * FROM USUARIO;
 
INSERT INTO VENDEDOR SELECT * FROM PF1788.VENDEDOR;
COMMIT;
SELECT * FROM VENDEDOR;

 
INSERT INTO CLIENTE SELECT * FROM PF1788.CLIENTE;
COMMIT;
SELECT * FROM CLIENTE;

 
INSERT INTO PRODUTO SELECT * FROM PF1788.PRODUTO;
COMMIT;

SELECT * FROM PRODUTO;
 
INSERT INTO ESTOQUE SELECT * FROM PF1788.ESTOQUE;
COMMIT;

SELECT * FROM ESTOQUE;

-- 2. Tabelas com depend?ncias de n?vel 2
INSERT INTO ESTADO SELECT * FROM PF1788.ESTADO;
COMMIT;
 
SELECT * FROM ESTADO;
 
INSERT INTO CIDADE SELECT * FROM PF1788.CIDADE;
COMMIT;

SELECT * FROM CIDADE;
 
INSERT INTO ENDERECO_CLIENTE SELECT * FROM PF1788.ENDERECO_CLIENTE;
COMMIT;

SELECT * FROM ENDERECO_CLIENTE;
 
INSERT INTO CLIENTE_VENDEDOR SELECT * FROM PF1788.CLIENTE_VENDEDOR;
COMMIT;

SELECT * FROM CLIENTE_VENDEDOR;
 
INSERT INTO ESTOQUE_PRODUTO SELECT * FROM PF1788.ESTOQUE_PRODUTO;
COMMIT;

SELECT * FROM ESTOQUE_PRODUTO;
 
INSERT INTO PRODUTO_COMPOSTO SELECT * FROM PF1788.PRODUTO_COMPOSTO;
COMMIT;

SELECT * FROM PRODUTO_COMPOSTO;
 
-- 3. Tabela dependente de cliente, usuario, vendedor, endereco_cliente
INSERT INTO PEDIDO SELECT * FROM PF1788.PEDIDO;
COMMIT;

SELECT * FROM PEDIDO;
 
-- 4. Tabelas que dependem diretamente de pedido
INSERT INTO ITEM_PEDIDO SELECT * FROM PF1788.ITEM_PEDIDO;
COMMIT;

SELECT * FROM ITEM_PEDIDO;
 
INSERT INTO HISTORICO_PEDIDO SELECT * FROM PF1788.HISTORICO_PEDIDO;
COMMIT;

SELECT * FROM HISTORICO_PEDIDO;
 
-- 5. Por ?ltimo, movimenta??o de estoque
INSERT INTO MOVIMENTO_ESTOQUE SELECT * FROM PF1788.MOVIMENTO_ESTOQUE;
COMMIT;

SELECT * FROM MOVIMENTO_ESTOQUE;

-- 1. Crie um bloco anônimo que calcula o total de movimentações de estoque para um determinado produto.

DECLARE
    v_movimentacoes NUMBER;
    v_cod_prod NUMBER := 16; -- &cod_produto
BEGIN
    SELECT SUM(qtd_movimentacao_estoque)INTO v_movimentacoes
    FROM movimento_estoque
    WHERE cod_produto = v_cod_prod;
    dbms_output.put_line('Produto: ' || v_cod_prod || ' | Total de Movimentações: ' || v_movimentacoes);
END;

-- 2. Utilizando FOR crie um bloco anônimo que calcula a média de valores totais de pedidos para um cliente específico.
DECLARE
    v_total_pedidos NUMBER := 0;
    v_quant_prod NUMBER := 0;
    v_cod_cliente NUMBER := 88; -- Código do cliente
    v_media NUMBER := 0;
BEGIN
    -- Contar a quantidade de pedidos do cliente
    SELECT COUNT(1) INTO v_quant_prod
    FROM pedido
    WHERE cod_cliente = v_cod_cliente;

    -- Somar os valores totais dos pedidos do cliente
    FOR i IN (SELECT v_total_pedidos FROM pedido WHERE cod_cliente = v_cod_cliente) LOOP
        v_total_pedidos := v_total_pedidos + i.v_total_pedidos;
    END LOOP;

    -- Evitar divisão por zero
    IF v_quant_prod > 0 THEN
        v_media := ROUND(v_total_pedidos / v_quant_prod, 2);
        dbms_output.put_line('Cliente: ' || v_cod_cliente || ' | Quant.Pedidos: ' || v_quant_prod || ' | Média de valores R$ ' || v_media);
    ELSE
        dbms_output.put_line('Cliente: ' || v_cod_cliente || ' não possui pedidos.');
    END IF;
END;

-- 3. Crie um bloco anônimo que exiba os produtos compostos ativos

BEGIN
    FOR i IN (SELECT cod_produto_relacionado, cod_produto FROM produto_composto WHERE sta_ativo = 'S'
    ) LOOP
        dbms_output.put_line('Produto Composto: ' || i.cod_produto_relacionado || ' | Produto: ' || i.cod_produto);
    END LOOP;
END;

-- 4. Crie um bloco anônimo para calcular o total de movimentações de estoque para um determinado produto usando INNER JOIN com a tabela de tipo_movimento_estoque.

DECLARE
    v_total_movimentacoes NUMBER := 0;
    v_cod_prod NUMBER := 16;
BEGIN
    SELECT SUM(qtd_movimentacao_estoque)
    INTO v_total_movimentacoes
    FROM movimento_estoque
    INNER JOIN tipo_movimento_estoque ON movimento_estoque.cod_tipo_movimento_estoque = tipo_movimento_estoque.cod_tipo_movimento_estoque
    WHERE movimento_estoque.cod_produto = v_cod_prod;

    dbms_output.put_line('Produto: ' || v_cod_prod || ' | Total de Movimentações: ' || v_total_movimentacoes);
END;

-- 5. Crie um bloco anônimo para exibir os produtos compostos e, se houver, suas informações de estoque, usando LEFT JOIN com a tabela estoque_produto.
BEGIN
    FOR i IN (
        SELECT tbl_pc.cod_produto, tbl_ep.qtd_produto FROM produto_composto tbl_pc LEFT JOIN estoque_produto tbl_ep ON tbl_pc.cod_produto = tbl_ep.cod_produto) LOOP
        IF i.qtd_produto IS NULL THEN
            i.qtd_produto := 0;
        END IF;
        dbms_output.put_line('Produto Composto: ' || i.cod_produto || ' | Estoque: ' || i.qtd_produto);
    END LOOP;
END;

-- 6. Bloco que exibe as informações de pedidos e, se houver, as informações dos clientes relacionados usando RIGHT JOIN com a tabela cliente.
BEGIN
    FOR i IN (
        SELECT NVL(p.cod_pedido, 0) as cod_pedido, NVL(p.val_total_pedido, 0) as val_total_pedido, c.cod_cliente, c.nom_cliente
        FROM cliente c
        LEFT JOIN pedido p ON p.cod_cliente = c.cod_cliente
    ) LOOP
        dbms_output.put_line('Pedido: ' || i.cod_pedido || 
                             ' | Valor R$' || i.val_total_pedido || 
                             ' | Cliente: ' || i.cod_cliente || 
                             ' | Nome: ' || i.nom_cliente);
    END LOOP;
END;


-- 7. Bloco que calcula a média de valores totais de pedidos para um cliente específico e exibe as informações do cliente usando INNER JOIN com a tabela cliente.
DECLARE
    v_total_pedidos NUMBER := 0;
    v_quant_pedidos NUMBER := 0;
    v_media NUMBER := 0;
    v_cod_cliente NUMBER := 88;
    v_nom_cliente VARCHAR2(100);
BEGIN
    SELECT NVL(SUM(p.val_total_pedido), 0), COUNT(p.cod_pedido), c.nom_cliente
    INTO v_total_pedidos, v_quant_pedidos, v_nom_cliente
    FROM pedido p
    INNER JOIN cliente c ON p.cod_cliente = c.cod_cliente
    WHERE c.cod_cliente = v_cod_cliente
    GROUP BY c.nom_cliente;

    IF v_quant_pedidos > 0 THEN
        v_media := v_total_pedidos / v_quant_pedidos;
    END IF;

    dbms_output.put_line('Cliente: ' || v_cod_cliente || ' | Nome: ' || v_nom_cliente || ' | Média de valores R$' || ROUND(v_media, 2));
END;

