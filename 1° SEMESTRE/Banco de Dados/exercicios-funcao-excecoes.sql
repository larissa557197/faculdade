

SET SERVEROUTPUT ON;

/*
Função 1 – fnc_percentual_desconto
Crie uma função chamada `fnc_percentual_desconto` que, ao receber o código de um pedido, 
calcule o percentual de desconto aplicado sobre o valor total do pedido. A função deve utilizar
`JOIN` com a tabela `item_pedido` para validar que o pedido possui ao menos um item, e deve tratar
possíveis exceções como: pedido inexistente, divisão por zero e erro genérico.

Critérios de avaliação:
•	- Uso correto de JOIN -> SELECT * FROM PEDIDO A INNER JOIN ITEM_PEDIDO B ON (A.COD_PEDIDO = B_COD_PEDIDO) WHERE A.COD_PEDIDO = 130501
•	- Retorno numérico com duas casas decimais (opcional, mas desejável)
•	- Tratamento com EXCEPTION

*/

-- basicamente essa função serve pra descobrir qual foi o percentual
-- de desconto que o cliente ganhou no pedido

CREATE OR REPLACE FUNCTION fnc_percentual_desconto (
    p_cod_pedido NUMBER
) RETURN NUMBER IS
    val_desc NUMBER;
BEGIN
    SELECT
        SUM(b.val_desconto_item) / 100
    INTO val_desc
    FROM
        pedido a
    INNER JOIN item_pedido b ON a.cod_pedido = b.cod_pedido
    WHERE a.cod_pedido = p_cod_pedido;

    RETURN ROUND(val_desc, 2); -- retorna o percentual com 2 casas

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20001, 'NÃO ENCONTROU NADA');
    WHEN OTHERS THEN
        raise_application_error(-20002, 'ERRO DESCONHECIDO');
END;

DESC item_pedido;
SELECT fnc_percentual_desconto(160386) FROM dual;
 
/*Função 2 – fnc_media_itens_por_pedido
Crie uma função que retorne a média de itens por pedido considerando todos os pedidos com itens registrados. 
Utilize `JOIN` com a tabela `historico_pedido` para garantir que os pedidos são válidos. Implemente tratamento
de erro para divisão por zero e erro genérico.

Critérios de avaliação:
•	- Uso correto de agregações (COUNT, DISTINCT)
•	- Uso de JOIN
•	- Tratamento de exceções
*/

CREATE OR REPLACE FUNCTION fnc_media_itens_por_pedido
RETURN NUMBER
IS
    v_total_itens NUMBER := 0;
    v_total_pedidos NUMBER := 0;
    v_media NUMBER := 0;
BEGIN
    --  Total de itens (linhas da item_pedido com pedido válido)
    SELECT COUNT(*) INTO v_total_itens
    FROM item_pedido ip
    INNER JOIN historico_pedido hp ON ip.cod_pedido = hp.cod_pedido;

    -- Total de pedidos diferentes com pelo menos um item
    SELECT COUNT(DISTINCT ip.cod_pedido) INTO v_total_pedidos
    FROM item_pedido ip
    INNER JOIN historico_pedido hp ON ip.cod_pedido = hp.cod_pedido;

    -- Se for tiver como dividir, calcula a média
    IF v_total_pedidos > 0 THEN
        v_media := v_total_itens / v_total_pedidos;
    END IF;

    RETURN ROUND(v_media, 2);

-- tratando as exceções
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        RETURN -1; -- erro por divisão por zero
    WHEN OTHERS THEN
        RETURN -2; -- erro desconhecido
END;

SELECT fnc_media_itens_por_pedido FROM dual;

/*Procedimento 1 – prc_relatorio_estoque_produto
Implemente um procedimento que receba o código de um produto e exiba, via `DBMS_OUTPUT`, 
o total de unidades movimentadas e a data da última movimentação. Utilize um `LEFT JOIN` 
com a tabela `produto_composto` para mostrar que o produto pode fazer parte de composições, 
mesmo que não tenha. Inclua tratamento para ausência de dados e erro genérico.

Critérios de avaliação:
•	- Utilização de agregações (SUM, MAX)
•	- Uso de LEFT JOIN
•	- Impressão no terminal com DBMS_OUTPUT
*/

CREATE OR REPLACE PROCEDURE prc_relatorio_estoque_produto(p_cod_produto NUMBER) AS
    v_total_movimentado NUMBER := 0;
    v_ultima_data DATE;
BEGIN
    -- Consulta com LEFT JOIN para garantir que o produto aparece mesmo sem composição
    SELECT SUM(me.QTD_MOVIMENTACAO_ESTOQUE), MAX(me.DAT_MOVIMENTO_ESTOQUE)
    INTO v_total_movimentado, v_ultima_data
    FROM produto p
    LEFT JOIN produto_composto pc ON p.cod_produto = pc.cod_produto
    LEFT JOIN movimento_estoque me ON p.cod_produto = me.cod_produto
    WHERE p.cod_produto = p_cod_produto;

    -- Verificar se houve movimentações
    IF v_total_movimentado IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Produto ' || p_cod_produto || ' não possui movimentações registradas.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Produto: ' || p_cod_produto);
        DBMS_OUTPUT.PUT_LINE('Total movimentado: ' || v_total_movimentado);
        DBMS_OUTPUT.PUT_LINE('Última movimentação: ' || TO_CHAR(v_ultima_data, 'DD/MM/YYYY'));
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao gerar o relatório do produto.');
END;

BEGIN
    prc_relatorio_estoque_produto(101); 
END;

BEGIN
    prc_relatorio_estoque_produto(35); 
END;

DESC movimento_estoque;

SELECT * FROM PRODUTO;


/*Procedimento 2 – prc_relatorio_composicao_ativa
Crie um procedimento que, dado o código de um produto, exiba os componentes ativos que 
fazem parte de sua composição. Use JOIN com a tabela `movimento_estoque` para relacionar 
os componentes com movimentações. Implemente o procedimento utilizando um `FOR LOOP` com 
`CURSOR IMPLÍCITO`, e trate erros genéricos.

Critérios de avaliação:
•	- Uso de JOIN
•	- Laço FOR ... IN (SELECT ...) LOOP
•	- Impressão formatada com DBMS_OUTPUT
*/

CREATE OR REPLACE PROCEDURE prc_relatorio_composicao_ativa(p_cod_produto NUMBER) AS
BEGIN
    FOR comp IN (
        SELECT pc.cod_produto_relacionado, 
               pc.COD_PRODUTO ,
               me.QTD_MOVIMENTACAO_ESTOQUE,
               me.DAT_MOVIMENTO_ESTOQUE 
        FROM produto_composto pc
        INNER JOIN movimento_estoque me 
            ON pc.cod_produto = me.cod_produto
        WHERE pc.cod_produto_relacionado = p_cod_produto
          AND pc.sta_ativo = 'S'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Composição Ativa: Produto Principal = ' || comp.cod_produto_relacionado ||
            ' | Componente = ' || comp.cod_produto ||
            ' | Qtde Movimentada = ' || comp.QTD_MOVIMENTACAO_ESTOQUE ||
            ' | Data = ' || TO_CHAR(comp.DAT_MOVIMENTO_ESTOQUE , 'DD/MM/YYYY')
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao exibir a composição ativa do produto.');
END;

BEGIN
    prc_relatorio_composicao_ativa(40); 
END;

SELECT * FROM PRODUTO_COMPOSTO;

/*Procedimento 3 – prc_relatorio_pedido
Desenvolva um procedimento que exiba informações detalhadas de 
um pedido, como: valor total, desconto e status de entrega (`ENTREGUE` ou `PENDENTE`). 
O procedimento deve aceitar o código do pedido como parâmetro e utilizar JOIN com a tabela `item_pedido` 
para garantir que o pedido possua itens. Inclua tratamento para pedido inexistente e erros genéricos.

Critérios de avaliação:
•	- Lógica condicional (IF/ELSE) para status
•	- Uso de JOIN
•	- Uso correto de DBMS_OUTPUT.PUT_LINE
*/

SELECT * FROM PEDIDO;
DESC PEDIDO;

CREATE OR REPLACE PROCEDURE prc_relatorio_pedido(p_cod_pedido NUMBER) AS
    v_val_total     pedido.val_total_pedido%TYPE;
    v_val_desconto  pedido.val_desconto%TYPE;
    v_status        pedido.status%TYPE;
    v_qtd_itens     NUMBER;
BEGIN
    -- Verifica se o pedido tem pelo menos um item usando JOIN com item_pedido
    SELECT COUNT(*) INTO v_qtd_itens
    FROM pedido p
    JOIN item_pedido ip ON p.cod_pedido = ip.cod_pedido
    WHERE p.cod_pedido = p_cod_pedido;

    IF v_qtd_itens = 0 THEN
        DBMS_OUTPUT.PUT_LINE('O pedido não possui itens registrados.');
        RETURN;
    END IF;

    -- Busca os dados do pedido
    SELECT val_total_pedido, val_desconto, status
    INTO v_val_total, v_val_desconto, v_status
    FROM pedido
    WHERE cod_pedido = p_cod_pedido;

    -- Exibe os dados
    DBMS_OUTPUT.PUT_LINE('Pedido: ' || p_cod_pedido);
    DBMS_OUTPUT.PUT_LINE('Valor com desconto: R$' || v_val_total);
    DBMS_OUTPUT.PUT_LINE('Desconto aplicado: R$' || v_val_desconto);

    -- Interpreta o status
    IF LOWER(v_status) = 'concluído' THEN
        DBMS_OUTPUT.PUT_LINE('Status: ENTREGUE');
    ELSIF LOWER(v_status) = 'pendente' THEN
        DBMS_OUTPUT.PUT_LINE('Status: PENDENTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Status: OUTRO');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao consultar o pedido.');
END;


BEGIN
  prc_relatorio_pedido(162890);
END;


