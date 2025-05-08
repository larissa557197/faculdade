
-- INTRODUÇÃO A BLOCO ANÔNIMO

-- mostrar na tela 
SET SERVEROUTPUT ON;

DECLARE
    idade NUMBER;
    -- auto variável - declarei a variavel e atribui o valor p ela
    -- := sintaxe = atribuir valor - só oracle/PL-SQL
    nome VARCHAR2(30) := 'LARIS';
    -- & => ler o teclado
    endereco VARCHAR2(50) := '&ENDERECO';
    
 -- imprimindo
BEGIN
    -- atribuindo valor a variavel
    idade := 39;                             -- concatenar => ||
    dbms_output.put_line('A IDADE INFORMADA É: ' || idade);
    dbms_output.put_line('O NOME INFORMADO É: ' || nome);
    -- para isneri os dados pelo terminal
    dbms_output.put_line('ENDEREÇO INFORMADO É: ' || endereco);
END;

-- EXERCICIO 1
/*
Criar um bloco PL-SQL para calcular o valor do novo salário míninmo que deverá ser de 25% e, acima do atual, que é de R$?
*/

SET SERVEROUTPUT ON;

DECLARE
    SALARIO_MIN NUMBER := 1518;
    SALARIO NUMBER;
    SALARIO_ATUAL NUMBER;
 -- imprimindo
BEGIN
     salario := salario_min * 0.25;
    salario_atual := salario + salario_min;
    dbms_output.put_line('O SALÁRIO MÍNIMO É: ' || salario_min);
    dbms_output.put_line('SALÁRIO ATUAL: ' || salario_atual);
END;

-- EXERCICIO 2
/*
Criar um bloco PL-SQL para calcular o valor em reais de 45 doláres, sendo que o valor do câmbio a ser considerado é de ?*/
SET SERVEROUTPUT ON;

DECLARE
    dolares NUMBER := 45;
    reais NUMBER;
    cambio NUMBER := 5.71;
 -- imprimindo
BEGIN
    reais := dolares * cambio;
    dbms_output.put_line('CAMBIO: ' || reais);

END;

-- EXERCíCIO 3
/*
Criar um bloco PL-SQL para calcular o valor das parcelas de uma compra de um carro, nas seguintes condições:
    1 - Parcelas para aquisição em 10 pagamentos
    2 - O valor da compra deverá ser infromado em tempo de excução
    3 - O valor total dos juros é de 3% e deverá ser aplicado sobre o montante financiado
    4 - No final informar o valor de cada parcela
*/

SET SERVEROUTPUT ON;

DECLARE

    CARRO NUMBER := &VALOR;
    
    
 -- imprimindo
BEGIN
    
     dbms_output.put_line('VALOR DO CARRO À VISTA: R$ ' || CARRO);
     dbms_output.put_line('VALOR DE CADA PARCELA: R$ ' || (CARRO * 1.03)/10);
     dbms_output.put_line('VALOR DO CARRO FINANCIADO: ' || CARRO * 1.03);

END;




