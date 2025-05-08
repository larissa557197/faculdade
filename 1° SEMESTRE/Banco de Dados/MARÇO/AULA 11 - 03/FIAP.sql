
set serveroutput on;

-- LOOP
-- usar o loop quando tiver uma condição de de saida

/*DECLARE
BEGIN
    LOOP
        <intrucoes>
        EXIT WHEN <condicao>
    END LOOP;
END;*/
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
        EXIT WHEN v_contador > 20;
    END LOOP;
END;

-- enquanto uma coisa tiver acontecendo ele fica no loop
/*WHILE <condi*/

DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    WHILE v_contador <= 20 LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
    END LOOP;
END;

-- for
/*for < contador> IN <valor inicial> .. <valor final > 
    loop < instrucao >
    end loop; > 
end;*/

BEGIN
    FOR v_contador IN 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

-- de 20 até 1
BEGIN
    FOR v_contador IN REVERSE 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

-- EXERCÍCIO
-- 1. Montar um bloco de programação que realize o processamento de uma tabuada qualquer, por exemplo a tabuada do número 150.
DECLARE
    tabuada  NUMBER := &tabuada;
    contador NUMBER(2) := 1;
BEGIN
    FOR tabuada IN 1..10 LOOP
        dbms_output.put_line(contador
                             || ' X '
                             || tabuada
                             || ' = '
                             || contador * tabuada);
    END LOOP;
END;

-- 2. Em um intervalo numérico inteiro, informar quantos números são pares e quantos são ímpares.
DECLARE
    num_par   NUMBER := 0;
    num_impar NUMBER := 0;
BEGIN
    FOR num IN 1..55 LOOP
        IF MOD(num, 2) = 0 THEN
            num_par := num_par + 1;
        ELSE
            num_impar := num_impar + 1;
        END IF;
    END LOOP;

    dbms_output.put_line('A QTD DE Nºs PARES SÃO: ' || num_par);
    dbms_output.put_line('A QTD DE Nºs ÍMPARES SÃO: ' || num_impar);
END;

-- 3. Exibir e média dos valores pares em um intervalo numérico e soma dos ímpares.
DECLARE
    valor_inicio NUMBER := &valor1;
    valor_final  NUMBER := &valor2;
    soma_pares   NUMBER := 0;
    cont_pares   NUMBER := 0;
    soma_impares NUMBER := 0;
    media_pares  NUMBER := 0;
BEGIN
    FOR num IN valor_inicio..valor_final LOOP
        IF MOD(num, 2) = 0 THEN
            soma_pares := soma_pares + num;
            cont_pares := cont_pares + 1;
        ELSE
            soma_impares := soma_impares + num;
        END IF;
    END LOOP;

    -- Calcular a média dos pares (evitar divisão por zero)
    IF cont_pares > 0 THEN
        media_pares := soma_pares / cont_pares;
    END IF;

    -- Exibir os resultados
    dbms_output.put_line('VALOR INICIAL: ' || valor_inicio);
    dbms_output.put_line('VALOR FINAL: ' || valor_final);
    dbms_output.put_line('Média dos números pares: ' || media_pares);
    dbms_output.put_line('Soma dos números ímpares: ' || soma_impares);
END;

