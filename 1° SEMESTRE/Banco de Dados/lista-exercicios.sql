set serveroutput on;

-- 1.	Crie um bloco anônimo que calcula o total de movimentações de estoque para um determinado produto.
DECLARE
    valor_total_movimentacoes NUMBER;
    valor_produto_code        VARCHAR2(26);
BEGIN
    valor_produto_code := 'S10_1949';
    SELECT
        SUM(quantityordered)
    INTO valor_total_movimentacoes
    FROM
        vendas
    WHERE
        productcode = valor_produto_code;

    dbms_output.put_line('Ttoal de movimentações para o produto '
                         || valor_produto_code
                         || ' é: '
                         || valor_total_movimentacoes);
END;

-- 2.	Utilizando FOR crie um bloco anônimo que calcula a média de valores totais de pedidos para um cliente específico.

DECLARE
    valor_media NUMBER;
    telefone VARCHAR2(26);

BEGIN

    telefone := '2125557818';
    SELECT AVG(sales)
    INTO valor_media
    FROM vendas
    WHERE phone = telefone;
    
    dbms_output.put_line('A média de valores totais de pedidos para o cliente com telefone ' || telefone || ' é: ' || valor_media);
    

END;


-- 3.	Crie um bloco anônimo que exiba os produtos compostos ativos

BEGIN
    FOR vendas IN (
        SELECT PRODUCTCODE, STATUS
        FROM vendas
        WHERE STATUS IN ('Shipped', 'In Process')  
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Produto: ' || vendas.PRODUCTCODE || ' - Status: ' || vendas.STATUS);
    END LOOP;
END;

        


-- 4.	Crie um bloco anônimo para calcular o total de movimentações de estoque para um determinado produto usando INNER JOIN com a tabela de tipo_movimento_estoque.

-- 5.	Crie um bloco anônimo para exibir os produtos compostos e, se houver, suas informações de estoque, usando LEFT JOIN com a tabela estoque_produto.

-- 6.	Crie um bloco que exiba as informações de pedidos e, se houver, as informações dos clientes relacionados usando RIGHT JOIN com a tabela cliente.

-- 7.	Crie um bloco que calcule a média de valores totais de pedidos para um cliente específico e exibe as informações do cliente usando INNER JOIN com a tabela cliente.

SELECT * FROM VENDAS;