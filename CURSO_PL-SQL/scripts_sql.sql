/*
CRIE UMA TABELA NOTAFISCAL QUE VAI TER, NUMERO DA NOTA, VALOR DA NOTA,
DESCRI��O DO VENDEDOR, DESCRI��O DO CLIENTE, DATA DE COMPRA.

CRIE UMA TABELA ITEMNOTA QUE VAI TER UM ID DO ITEM, VALOR DO ITEM,
DESCRI��O DO ITEM, REFERENCIAR A TABELA NOTAFISCAL.
*/

CREATE TABLE NOTAFISCAL_CURSO(
  NR_NOTA NUMBER(15),
  VL_NOTA NUMBER(15,2),
  DS_VENDEDOR VARCHAR2(100),
  DS_CLIENTE VARCHAR(100),
  DT_COMPRA DATE,
  CONSTRAINT PKNOTAFISCAL_CURSO PRIMARY KEY (NR_NOTA)
);

SELECT * FROM NOTAFISCAL_CURSO;

----------------------------------------------------------------

CREATE TABLE ITEMNOTA_CURSO(
  ID_ITEM NUMBER(15),
  VL_ITEM NUMBER(15,2),
  DS_ITEM VARCHAR2(100),
  NR_NOTA NUMBER(15),
  CONSTRAINT PKITEMNOTA_CURSO PRIMARY KEY (ID_ITEM),
  CONSTRAINT FKITEMNOTA_NOTAFISCALCURSO FOREIGN KEY (NR_NOTA) REFERENCES NOTAFISCAL_CURSO(NR_NOTA) 
);

SELECT * FROM ITEMNOTA_CURSO;

----------------------------------------------------------------

CREATE TABLE PESSOA_CURSO(
  NM_PESSOA VARCHAR2(100),
  NR_CPF VARCHAR2(11),
  DT_NASCIMENTO DATE,
  ID_PESSOA NUMBER(15),
  NR_ALTURA NUMBER(8,2),
  CONSTRAINT PKPESSOACURSO PRIMARY KEY (ID_PESSOA)
);

SELECT * FROM PESSOA_CURSO;

----------------------------------------------------------------

CREATE TABLE CARRO_CURSO(
  NR_PLACA VARCHAR2(7),
  DS_MODELO VARCHAR2(100),
  DT_COMPRA DATE,
  VL_VENDA NUMBER(15,2),
  NR_ANOMODELO NUMBER(4),
  ID_PESSOA NUMBER(15),
  CONSTRAINT PKCARROCURSO PRIMARY KEY (NR_PLACA),
  CONSTRAINT FKCARROCURSO_PESSOACURSO FOREIGN KEY (ID_PESSOA) REFERENCES PESSOA_CURSO(ID_PESSOA)
);

SELECT * FROM CARRO_CURSO;
----------------------------------------------------------------

SELECT PACK_NOTAFISCAL.RETORNA_QUANTIDADEDECARROS(1990)
  FROM DUAL;

SELECT NOTAFISCAL_CURSO.DS_VENDEDOR,
       COUNT(*),
       SUM(NOTAFISCAL_CURSO.VL_NOTA),
       MIN(NOTAFISCAL_CURSO.VL_NOTA),
       MAX(NOTAFISCAL_CURSO.VL_NOTA)
  FROM NOTAFISCAL_CURSO
GROUP BY NOTAFISCAL_CURSO.DS_VENDEDOR;     
----------------------------------------------------------------
--DROP TABLE ABASTECIMENTOCURSO;

--DROP TABLE FRENTISTACURSO;

--DROP TABLE PROPRIETARIOCURSO;

--DROP TABLE VEICULOCURSO;

--DROP TABLE COMBUSTIVELCURSO;

--COMMIT;
