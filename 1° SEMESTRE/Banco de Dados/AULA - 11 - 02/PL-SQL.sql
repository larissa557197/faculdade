/* 
DROP TABLE end_cliente;
DROP TABLE bairro;
DROP TABLE cidade;
DROP TABLE estado;
DROP TABLE pais; */

 
CREATE TABLE pais (
    id_pais   NUMBER PRIMARY KEY,
    nome_pais VARCHAR2(30)
);
 
CREATE TABLE estado (
    id_estado   NUMBER PRIMARY KEY,
    nome_estado VARCHAR2(30),
    id_pais     NUMBER
);
 
ALTER TABLE estado
    ADD CONSTRAINT fk_estado FOREIGN KEY ( id_pais )
        REFERENCES pais ( id_pais );
 
CREATE TABLE cidade (
    id_cidade   NUMBER PRIMARY KEY,
    nome_cidade VARCHAR2(30),
    id_estado   NUMBER
);
 
ALTER TABLE cidade
    ADD CONSTRAINT fk_cidade FOREIGN KEY ( id_estado )
        REFERENCES estado ( id_estado );
 
CREATE TABLE bairro (
    id_bairro   NUMBER PRIMARY KEY,
    nome_bairro VARCHAR2(30),
    id_cidade   NUMBER
);
 
ALTER TABLE bairro
    ADD CONSTRAINT fk_bairro FOREIGN KEY ( id_cidade )
        REFERENCES cidade ( id_cidade );
 
CREATE TABLE end_cliente (
    id_endereco NUMBER PRIMARY KEY,
    cep         NUMBER,
    logradouro  VARCHAR2(50),
    numero      NUMBER,
    complemento VARCHAR2(50),
    id_bairro   NUMBER
);
 
ALTER TABLE end_cliente
    ADD CONSTRAINT fk_end_cliente FOREIGN KEY ( id_bairro )
        REFERENCES bairro ( id_bairro );
        
-- INSERTS

-- PAÍS
INSERT INTO pais(id_pais, nome_pais)
    VALUES (1, 'Brasil');

INSERT INTO pais(id_pais, nome_pais)
    VALUES (2, 'Argentina');
    
INSERT INTO pais(id_pais, nome_pais)
    VALUES (3, 'Estados Unidos');

INSERT INTO pais(id_pais, nome_pais)
    VALUES (4, 'França');

INSERT INTO pais(id_pais, nome_pais)
    VALUES (5, 'Inglaterra');    

SELECT * FROM pais;

UPDATE pais
SET nome_pais = 'Reino Unido'  -- ou o nome correto do país
WHERE id_pais = 5;  -- Certifique-se de usar o id correto do país que foi inserido errado


-- ESTADO
INSERT INTO estado (id_estado, nome_estado, id_pais)
VALUES (1, 'São Paulo', 1);  -- Brasil

INSERT INTO estado (id_estado, nome_estado, id_pais)
VALUES (2, 'Rio de Janeiro', 1);  -- Brasil

INSERT INTO estado (id_estado, nome_estado, id_pais)
VALUES (3, 'Buenos Aires', 2);  -- Argentina

INSERT INTO estado (id_estado, nome_estado, id_pais)
VALUES (4, 'California', 3);  -- Estados Unidos

INSERT INTO estado (id_estado, nome_estado, id_pais)
VALUES (5, 'Île-de-France', 4);  -- França

INSERT INTO estado (id_estado, nome_estado, id_pais)
VALUES (6, 'Londres', 5); -- Londres   
    


SELECT * FROM estado;    

-- CIDADE
INSERT INTO cidade (id_cidade, nome_cidade, id_estado)
VALUES (1, 'São Paulo', 1);  -- São Paulo, Brasil

INSERT INTO cidade (id_cidade, nome_cidade, id_estado)
VALUES (2, 'Rio de Janeiro', 2);  -- Rio de Janeiro, Brasil

INSERT INTO cidade (id_cidade, nome_cidade, id_estado)
VALUES (3, 'Buenos Aires', 3);  -- Buenos Aires, Argentina

INSERT INTO cidade (id_cidade, nome_cidade, id_estado)
VALUES (4, 'Los Angeles', 4);  -- Los Angeles, California, EUA

INSERT INTO cidade (id_cidade, nome_cidade, id_estado)
VALUES (5, 'Paris', 5);  -- Paris, Île-de-France, França
    
INSERT INTO cidade (id_cidade, nome_cidade, id_estado)
    VALUES (6, 'Londres', 6); -- Londres

SELECT * FROM cidade;

-- BAIRRO
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade)
VALUES (1, 'Pinheiros', 1);  -- São Paulo, Brasil

INSERT INTO bairro (id_bairro, nome_bairro, id_cidade)
VALUES (2, 'Copacabana', 2);  -- Rio de Janeiro, Brasil

INSERT INTO bairro (id_bairro, nome_bairro, id_cidade)
VALUES (3, 'San Telmo', 3);  -- Buenos Aires, Argentina

INSERT INTO bairro (id_bairro, nome_bairro, id_cidade)
VALUES (4, 'Hollywood', 4);  -- Los Angeles, EUA

INSERT INTO bairro (id_bairro, nome_bairro, id_cidade)
VALUES (5, 'Montmartre', 5);  -- Paris, França

INSERT INTO bairro (id_bairro, nome_bairro, id_cidade)
VALUES (6, 'Oxford Street', 6);

SELECT * FROM bairro;

-- END_CLIENTE
INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro)
VALUES (1, 12345678, 'Rua dos Três Irmãos', 100, 'Apto 101', 1);  -- Pinheiros, São Paulo

INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro)
VALUES (2, 23456789, 'Avenida Atlântica', 200, 'Bloco B', 2);  -- Copacabana, Rio de Janeiro

INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro)
VALUES (3, 34567890, 'Calle Defensa', 300, 'Piso 1', 3);  -- San Telmo, Buenos Aires

INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro)
VALUES (4, 45678901, 'Hollywood Boulevard', 400, 'Loja 3', 4);  -- Hollywood, Los Angeles

INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro)
VALUES (5, 56789012, 'Rue Lepic', 500, 'Andar 2', 5);  -- Montmartre, Paris

INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro)
VALUES (6, 12345678, 'Rua da Torre', 101, 'Apto 202', 6);  -- Endereço no bairro Westminster


SELECT * FROM end_cliente;

