-------------------------------------
--            CP3                   |
-------------------------------------
-- RM 557197 - Larissa Muniz        |
-- RM 555678 - João Victor Michaeli |
-- RM 558062 - Henrique Garcia      |
-------------------------------------

SET SERVEROUTPUT ON;


-- 1.	Crie uma função `fn_categoria_movimentada` que retorne a categoria mais movimentada (em quantidade total) no mês atual. Use JOINs, CASE e SYSDATE.
CREATE OR REPLACE FUNCTION fn_categoria_movimentada
RETURN VARCHAR2 IS
    v_nome_produto VARCHAR2(100);
BEGIN
    SELECT nom_produto
    INTO v_nome_produto
    FROM (
        SELECT 
            CASE 
                WHEN p.nom_produto IS NULL THEN 'Produto sem nome'
                ELSE p.nom_produto
            END AS nom_produto,
            SUM(m.qtd_movimentacao_estoque) AS total
        FROM produto p
        JOIN movimento_estoque m ON p.cod_produto = m.cod_produto
        WHERE m.dat_movimento_estoque 
              BETWEEN TRUNC(SYSDATE, 'MM') AND LAST_DAY(SYSDATE)
        GROUP BY 
            CASE 
                WHEN p.nom_produto IS NULL THEN 'Produto sem nome'
                ELSE p.nom_produto
            END
        ORDER BY total DESC
    )
    WHERE ROWNUM = 1;

    RETURN v_nome_produto;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Sem movimentações este mês';
    WHEN OTHERS THEN
        RETURN 'Erro ao calcular produto';
END;

SELECT fn_categoria_movimentada FROM dual;

-- insert de exemplo para evideniciar o codigo por causa das datas 
INSERT INTO movimento_estoque (
    SEQ_MOVIMENTO_ESTOQUE,
    COD_PRODUTO,
    DAT_MOVIMENTO_ESTOQUE,
    QTD_MOVIMENTACAO_ESTOQUE,
    COD_TIPO_MOVIMENTO_ESTOQUE
)
VALUES (95, 1, TO_DATE('03/05/2025', 'DD/MM/YYYY'), 50, 1);



select * from movimento_estoque;


select * from produto;

DESC produto;

-- 2.	Crie uma procedure `sp_valida_produtos_sem_movimento` 
-- que liste produtos sem nenhum movimento nos últimos 6 meses. 
-- Use RIGHT JOIN, EXCEPTION e DBMS_OUTPUT.
CREATE OR REPLACE PROCEDURE sp_valida_produtos_sem_movimento AS
    v_count NUMBER := 0;
BEGIN
    FOR prod IN (
        SELECT DISTINCT p.cod_produto, p.nom_produto
        FROM movimento_estoque m
        RIGHT JOIN produto p ON m.cod_produto = p.cod_produto
        WHERE m.dat_movimento_estoque IS NULL
           OR m.dat_movimento_estoque < ADD_MONTHS(SYSDATE, -6)
    ) LOOP
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('Produto sem movimento recente: ' ||
                             prod.cod_produto || ' - ' || prod.nom_produto);
    END LOOP;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Todos os produtos tiveram movimentação nos últimos 6 meses.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao verificar produtos sem movimento.');
END;

BEGIN
    sp_valida_produtos_sem_movimento;
END;

INSERT INTO produto (COD_PRODUTO, NOM_PRODUTO, COD_BARRA, STA_ATIVO, DAT_CADASTRO, DAT_CANCELAMENTO)
VALUES (999, 'Prod Test S Movim', '999', 'S', SYSDATE, TO_DATE('03/05/2025', 'DD/MM/YYYY'));
COMMIT;




-- 3. Utilizando um cursor, liste todos os produtos com mais de 100 unidades 
-- movimentadas no total. Para cada um, calcule e exiba o total acumulado 
-- por meio de variável PL/SQL.

DECLARE
    --  o total de movimentações de todos os produtos
    v_total_geral NUMBER := 0;

    --  busca produtos com mais de 100 unidades movimentadas
    CURSOR c_produtos IS
        SELECT p.cod_produto, p.nom_produto, SUM(m.qtd_movimentacao_estoque) AS total_mov
        FROM produto p
        JOIN movimento_estoque m ON p.cod_produto = m.cod_produto
        GROUP BY p.cod_produto, p.nom_produto
        HAVING SUM(m.qtd_movimentacao_estoque) > 100;

BEGIN
    
    FOR prod IN c_produtos LOOP
        -- acumula o total em variável
        v_total_geral := v_total_geral + prod.total_mov;

        -- mostra os dados
        DBMS_OUTPUT.PUT_LINE(
            'Produto: ' || prod.cod_produto || ' - ' || prod.nom_produto ||
            ' | Total Movimentado: ' || prod.total_mov
        );
    END LOOP;

    -- exibe o acumulado final
    DBMS_OUTPUT.PUT_LINE('Total geral movimentado (somente dos produtos com mais de 100 unidades): ' || v_total_geral);
END;

-- 4. Implemente a procedure `sp_qtd_movimentos_produto(p_cod_produto IN NUMBER, p_total OUT NUMBER)
-- ` que retorna a quantidade total de movimentos associados ao 

CREATE OR REPLACE PROCEDURE sp_qtd_movimentos_produto (
    p_cod_produto IN NUMBER,
    p_total OUT NUMBER
) AS
BEGIN
    -- Conta a quantidade de registros de movimentação para o produto 
    SELECT COUNT(*)
    INTO p_total
    FROM movimento_estoque
    WHERE cod_produto = p_cod_produto;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_total := 0;  -- Se não encontrar nada, retorna 0
    WHEN OTHERS THEN
        p_total := -1; -- Erro genérico
END;

DECLARE
    v_total_mov NUMBER;
BEGIN
    sp_qtd_movimentos_produto(10, v_total_mov);
    DBMS_OUTPUT.PUT_LINE('Total de movimentações do produto 10: ' || v_total_mov);
END;

-- 5. Atualize todos os produtos da categoria e de uma categoria específica, 
-- apenas se sua movimentação total for inferior a 50 unidades. Use cursor + LOOP com UPDATE.
DECLARE
    CURSOR c_produtos IS
        SELECT p.cod_produto
        FROM produto p
        LEFT JOIN movimento_estoque m ON p.cod_produto = m.cod_produto
        GROUP BY p.cod_produto
        HAVING SUM(NVL(m.qtd_movimentacao_estoque, 0)) < 50;

BEGIN
    FOR prod IN c_produtos LOOP
        UPDATE produto
        SET sta_ativo = 'N'
        WHERE cod_produto = prod.cod_produto;

        DBMS_OUTPUT.PUT_LINE('Produto desativado: ' || prod.cod_produto);
    END LOOP;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar produtos.');
        ROLLBACK;
END;

-- 6.	Crie uma procedure que para cada produto, busque as datas e quantidades dos 
--      movimentos e exiba no seguinte formato:
        -- Produto: Teclado Gamer
   --   -> 10/04/2025 | Entrada: 10
   --   -> 12/04/2025 | Saída: -5
   --   Utilize cursores aninhados.
 
CREATE OR REPLACE PROCEDURE sp_relatorio_movimentos_produto AS
BEGIN
    -- Cursor externo: lista todos os produtos
    FOR prod IN (
        SELECT cod_produto, nom_produto
        FROM produto
    ) LOOP
        -- Exibe o nome do produto
        DBMS_OUTPUT.PUT_LINE('Produto: ' || prod.nom_produto);

        -- Cursor interno: movimentações para o produto atual
        FOR mov IN (
            SELECT dat_movimento_estoque, qtd_movimentacao_estoque
            FROM movimento_estoque
            WHERE cod_produto = prod.cod_produto
            ORDER BY dat_movimento_estoque
        ) LOOP
            -- Define tipo da movimentação com base no sinal
            DBMS_OUTPUT.PUT_LINE(
                '-> ' || TO_CHAR(mov.dat_movimento_estoque, 'DD/MM/YYYY') ||
                ' | ' ||
                CASE 
                    WHEN mov.qtd_movimentacao_estoque >= 0 THEN 'Entrada: '
                    ELSE 'Saída: '
                END || mov.qtd_movimentacao_estoque
            );
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(''); -- linha em branco entre produtos
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao gerar relatório de movimentações.');
END;

BEGIN
    sp_relatorio_movimentos_produto;
END;
 
-- 7.	Crie `sp_relatorio_geral_movimento` que exiba o tota
-- l movimentado por tipo de movimento (entrada/saída), 
-- inclusive aqueles sem registro associado (produto ou tipo). 
-- Use GROUP BY.

CREATE OR REPLACE PROCEDURE sp_relatorio_geral_movimento AS
BEGIN
    FOR reg IN (
        SELECT t.DES_TIPO_MOVIMENTO_ESTOQUE AS tipo_mov,
               SUM(m.QTD_MOVIMENTACAO_ESTOQUE) AS total
        FROM tipo_movimento_estoque t
        LEFT JOIN movimento_estoque m ON t.COD_TIPO_MOVIMENTO_ESTOQUE = m.COD_TIPO_MOVIMENTO_ESTOQUE
        GROUP BY t.DES_TIPO_MOVIMENTO_ESTOQUE
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Tipo de Movimento: ' || reg.tipo_mov || ' | Total Movimentado: ' || NVL(reg.total, 0));
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao gerar relatório geral de movimentos.');
END;

BEGIN
    sp_relatorio_geral_movimento;
END;

-- 8. Implemente um bloco anônimo que tenta inserir um novo produto já existente
-- e capture o erro ORA-00001, exibindo uma mensagem customizada de violação de
-- chave primária.
DECLARE
    v_cod_produto produto.cod_produto%TYPE := 1;  -- codigo de um produto existente
    v_nome_produto produto.nom_produto%TYPE := 'Produto Duplicado';
BEGIN
    INSERT INTO produto (cod_produto, nom_produto)
    VALUES (v_cod_produto, v_nome_produto);

    DBMS_OUTPUT.PUT_LINE('Produto inserido com sucesso.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: produto já existe (violação de chave primária).');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado.');
END;

-- 9. Crie `sp_limpa_movimentos_antigos` que exclui movimentações com mais de 2
-- anos, mas faz rollback se a quantidade de registros excluídos ultrapassar 1000. 
-- Use ROLLBACK e COUNT(1).
CREATE OR REPLACE PROCEDURE sp_limpa_movimentos_antigos AS
    v_qtd_excluir NUMBER;
BEGIN
    -- Verifica quantas movimentações têm mais de 2 anos
    SELECT COUNT(1)
    INTO v_qtd_excluir
    FROM movimento_estoque
    WHERE dat_movimento_estoque < ADD_MONTHS(SYSDATE, -24);

    -- Exibe quantos seriam excluídos
    DBMS_OUTPUT.PUT_LINE('Movimentações com mais de 2 anos: ' || v_qtd_excluir);

    IF v_qtd_excluir <= 1000 THEN
        -- Faz a exclusão e commita
        DELETE FROM movimento_estoque
        WHERE dat_movimento_estoque < ADD_MONTHS(SYSDATE, -24);

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Exclusão concluída com sucesso.');
    ELSE
        -- Rollback se passar do limite
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Rollback realizado. Mais de 1000 registros seriam excluídos.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro durante o processo: ' || SQLERRM);
END;

BEGIN
    sp_limpa_movimentos_antigos;
END;

-- 10. Crie a função `fn_previsao_movimentacao(p_cod_produto NUMBER)` que, 
-- com base na média de movimentações nos últimos 3 meses, retorna uma previsão 
-- da movimentação esperada para o próximo mês.
CREATE OR REPLACE FUNCTION fn_previsao_movimentacao(p_cod_produto NUMBER)
RETURN NUMBER
IS
    v_total_movimentado NUMBER := 0;
    v_qtd_meses NUMBER := 3;
    v_media NUMBER := 0;
BEGIN
    -- Soma a quantidade de movimentações dos últimos 3 meses
    SELECT SUM(qtd_movimentacao_estoque)
    INTO v_total_movimentado
    FROM movimento_estoque
    WHERE cod_produto = p_cod_produto
      AND dat_movimento_estoque >= ADD_MONTHS(SYSDATE, -v_qtd_meses);

    -- Se houver movimentações, calcula a média
    IF v_total_movimentado IS NOT NULL THEN
        v_media := ROUND(v_total_movimentado / v_qtd_meses, 2);
    END IF;

    RETURN v_media;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Nenhuma movimentação
    WHEN ZERO_DIVIDE THEN
        RETURN -1; -- Erro de divisão por zero
    WHEN OTHERS THEN
        RETURN -2; -- Erro inesperado
END;

SELECT fn_previsao_movimentacao(5) AS previsao FROM dual;

SELECT COUNT(*)
FROM movimento_estoque
WHERE dat_movimento_estoque >= ADD_MONTHS(SYSDATE, -3);

INSERT INTO movimento_estoque (SEQ_MOVIMENTO_ESTOQUE, cod_produto, DAT_MOVIMENTO_ESTOQUE, QTD_MOVIMENTACAO_ESTOQUE, COD_TIPO_MOVIMENTO_ESTOQUE)
VALUES (999, 5, SYSDATE, 50, 1);

COMMIT;

select * from movimento_estoque;