
-- INTRODU��O A BLOCO AN�NIMO

-- mostrar na tela 
SET SERVEROUTPUT ON;

DECLARE
    idade NUMBER;
    -- auto vari�vel - declarei a variavel e atribui o valor p ela
    -- := sintaxe = atribuir valor - s� oracle/PL-SQL
    nome VARCHAR2(30) := 'LARIS';
    -- & => ler o teclado
    endereco VARCHAR2(50) := '&ENDERECO';
    
 -- imprimindo
BEGIN
    -- atribuindo valor a variavel
    idade := 39;                             -- concatenar => ||
    dbms_output.put_line('A IDADE INFORMADA �: ' || idade);
    dbms_output.put_line('O NOME INFORMADO �: ' || nome);
    -- para isneri os dados pelo terminal
    dbms_output.put_line('ENDERE�O INFORMADO �: ' || endereco);
END;

-- EXERCICIO 1
/*
Criar um bloco PL-SQL para calcular o valor do novo sal�rio m�ninmo que dever� ser de 25% e, acima do atual, que � de R$?
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
    dbms_output.put_line('O SAL�RIO M�NIMO �: ' || salario_min);
    dbms_output.put_line('SAL�RIO ATUAL: ' || salario_atual);
END;

-- EXERCICIO 2
/*
Criar um bloco PL-SQL para calcular o valor em reais de 45 dol�res, sendo que o valor do c�mbio a ser considerado � de ?*/
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

-- EXERC�CIO 3
/*
Criar um bloco PL-SQL para calcular o valor das parcelas de uma compra de um carro, nas seguintes condi��es:
    1 - Parcelas para aquisi��o em 10 pagamentos
    2 - O valor da compra dever� ser infromado em tempo de excu��o
    3 - O valor total dos juros � de 3% e dever� ser aplicado sobre o montante financiado
    4 - No final informar o valor de cada parcela
*/

SET SERVEROUTPUT ON;

DECLARE

    CARRO NUMBER := &VALOR;
    
    
 -- imprimindo
BEGIN
    
     dbms_output.put_line('VALOR DO CARRO � VISTA: R$ ' || CARRO);
     dbms_output.put_line('VALOR DE CADA PARCELA: R$ ' || (CARRO * 1.03)/10);
     dbms_output.put_line('VALOR DO CARRO FINANCIADO: ' || CARRO * 1.03);

END;




