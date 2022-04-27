create or replace package PACK_NOTAFISCAL is

  -- Author  : JHONATAN.MATTANA
  -- Created : 26/04/2022 09:09:21
  -- Purpose : PACOTE PARA CENTRALIZAR PROCEDIMENTOS REFERENTES A NOTA FISCAL
  
 PROCEDURE INSERE_NOTA (I_NR_NOTA      IN NOTAFISCAL_CURSO.NR_NOTA%TYPE,
                         I_VL_NOTA     IN NOTAFISCAL_CURSO.VL_NOTA%TYPE,
                         I_DS_VENDEDOR IN NOTAFISCAL_CURSO.DS_VENDEDOR%TYPE,
                         I_DS_CLIENTE  IN NOTAFISCAL_CURSO.DS_CLIENTE%TYPE,
                         I_DT_COMPRA   IN NOTAFISCAL_CURSO.DT_COMPRA%TYPE,
                         O_MENSAGEM    OUT VARCHAR2); 
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                        
 PROCEDURE INSERE_CARRO (I_NR_PLACA     IN CARRO_CURSO.NR_PLACA%TYPE,
                          I_DS_MODELO    IN CARRO_CURSO.DS_MODELO%TYPE,
                          I_DT_COMPRA    IN CARRO_CURSO.DT_COMPRA%TYPE,
                          I_VL_VENDA     IN CARRO_CURSO.VL_VENDA%TYPE,
                          I_NR_ANOMODELO IN CARRO_CURSO.NR_ANOMODELO%TYPE,
                          O_MENSAGEM   OUT VARCHAR2);
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                         
 PROCEDURE INSERE_PESSOA (I_NM_PESSOA     IN PESSOA_CURSO.NM_PESSOA%TYPE,
                           I_NR_CPF        IN PESSOA_CURSO.NR_CPF%TYPE,
                           I_DT_NASCIMENTO IN PESSOA_CURSO.DT_NASCIMENTO%TYPE,  
                           I_ID_PESSOA     IN PESSOA_CURSO.ID_PESSOA%TYPE,
                           I_NR_ALTURA     IN PESSOA_CURSO.NR_ALTURA%TYPE,
                           O_MENSAGEM      OUT VARCHAR2);
                           
 PROCEDURE EXCLUI_CARRO (I_NR_PLACA IN CARRO_CURSO.NR_PLACA%TYPE,
                          O_MENSAGEM OUT VARCHAR2);
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                         
 PROCEDURE EXLUI_PESSOA(I_ID_PESSOA IN PESSOA_CURSO.ID_PESSOA%TYPE,
                         O_MENSAGEM  OUT VARCHAR2);                         
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                                        
 PROCEDURE INSERE_ITEMNOTA (I_ID_ITEM  IN ITEMNOTA_CURSO.ID_ITEM%TYPE,
                             I_VL_ITEM  IN ITEMNOTA_CURSO.VL_ITEM%TYPE,
                             I_DS_ITEM  IN ITEMNOTA_CURSO.DS_ITEM%TYPE,
                             I_NR_NOTA  IN ITEMNOTA_CURSO.NR_NOTA%TYPE,
                             O_MENSAGEM OUT VARCHAR2); 
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 FUNCTION RETORNA_QUANTIDADEDECARROS (I_NR_ANOMODELO IN CARRO_CURSO.NR_ANOMODELO%TYPE)
                                                      RETURN NUMBER;       
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                                                     
 FUNCTION RETORNA_VALORNOTA(I_NR_NOTA IN NOTAFISCAL_CURSO.NR_NOTA%TYPE)
                                      RETURN NOTAFISCAL_CURSO.VL_NOTA%TYPE;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                                      
 FUNCTION RETORNA_QTDENOTAS(I_DT_COMPRA IN NOTAFISCAL_CURSO.DT_COMPRA%TYPE)
                                       RETURN NUMBER;                                                                                                                                                                  
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 FUNCTION RETORNA_QTVENDAS_VENDEDOR (I_DS_VENDEDOR IN NOTAFISCAL_CURSO.DS_VENDEDOR%TYPE)
                                                  RETURN NUMBER;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 FUNCTION RETORNA_VALORTOTALNOTAS RETURN NUMBER;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 FUNCTION RETORNA_NOMECLIENTES RETURN VARCHAR2;
 --------------------------------------------------------------------------------
 -------------------------------------------------------------------------------- 
 FUNCTION TESTE_VETOR RETURN VARCHAR2;

end PACK_NOTAFISCAL;
/
create or replace package body PACK_NOTAFISCAL is
  PROCEDURE INSERE_NOTA (I_NR_NOTA     IN NOTAFISCAL_CURSO.NR_NOTA%TYPE,
                         I_VL_NOTA     IN NOTAFISCAL_CURSO.VL_NOTA%TYPE,
                         I_DS_VENDEDOR IN NOTAFISCAL_CURSO.DS_VENDEDOR%TYPE,
                         I_DS_CLIENTE  IN NOTAFISCAL_CURSO.DS_CLIENTE%TYPE,
                         I_DT_COMPRA   IN NOTAFISCAL_CURSO.DT_COMPRA%TYPE,
                         O_MENSAGEM    OUT VARCHAR2) IS
    V_NR_NOTA NOTAFISCAL_CURSO.NR_NOTA%TYPE;
    E_GERAL EXCEPTION;                     
  BEGIN
    
    SELECT MAX(NOTAFISCAL_CURSO.NR_NOTA)
      INTO V_NR_NOTA
      FROM NOTAFISCAL_CURSO;
      
      --Se a variavel V_NR_NOTA for null, considere 0
      V_NR_NOTA := NVL(V_NR_NOTA,0) + 1;
    
    BEGIN
      INSERT INTO NOTAFISCAL_CURSO
        (NR_NOTA,
         VL_NOTA,
         DS_VENDEDOR,
         DS_CLIENTE,
         DT_COMPRA)
      VALUES
       (NVL(I_NR_NOTA, V_NR_NOTA),
        I_VL_NOTA,
        I_DS_VENDEDOR,
        I_DS_CLIENTE,
        SYSDATE);
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        BEGIN
          UPDATE NOTAFISCAL_CURSO
            SET VL_NOTA     = I_VL_NOTA,
                DS_VENDEDOR = I_DS_VENDEDOR,
                DS_CLIENTE  = I_DS_CLIENTE,
                DT_COMPRA   = I_DT_COMPRA
            WHERE NR_NOTA = I_NR_NOTA;   
        EXCEPTION
          WHEN OTHERS THEN
            O_MENSAGEM := 'Erro ao atualizar nota: Erro: ' || SQLERRM;
            RAISE E_GERAL;
        END;
        WHEN OTHERS THEN
          O_MENSAGEM := 'ERRO' || SQLERRM;
          RAISE E_GERAL;
    END;
      
    COMMIT;
    
  EXCEPTION
    WHEN E_GERAL THEN  
      O_MENSAGEM := '[INSERE NOTA]' || O_MENSAGEM;
    WHEN OTHERS THEN
      O_MENSAGEM := 'Erro ao inserir nota fiscal. Erro: ' || SQLERRM;   
      
  END;   
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  PROCEDURE INSERE_CARRO (I_NR_PLACA     IN CARRO_CURSO.NR_PLACA%TYPE,
                          I_DS_MODELO    IN CARRO_CURSO.DS_MODELO%TYPE,
                          I_DT_COMPRA    IN CARRO_CURSO.DT_COMPRA%TYPE,
                          I_VL_VENDA     IN CARRO_CURSO.VL_VENDA%TYPE,
                          I_NR_ANOMODELO IN CARRO_CURSO.NR_ANOMODELO%TYPE,
                          O_MENSAGEM   OUT VARCHAR2) IS
    E_GERAL EXCEPTION;                        
  BEGIN
    BEGIN
      INSERT INTO CARRO_CURSO(
        NR_PLACA,
        DS_MODELO,
        DT_COMPRA,
        VL_VENDA,
        NR_ANOMODELO)
      VALUES(
        I_NR_PLACA,
        I_DS_MODELO,
        I_DT_COMPRA,
        I_VL_VENDA,
        I_NR_ANOMODELO);  
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        BEGIN
          UPDATE CARRO_CURSO
            SET DS_MODELO    = I_DS_MODELO,
                DT_COMPRA    = I_DT_COMPRA,
                VL_VENDA     = I_VL_VENDA,
                NR_ANOMODELO = I_NR_ANOMODELO
          WHERE NR_PLACA = I_NR_PLACA;   
        EXCEPTION
          WHEN OTHERS THEN
            O_MENSAGEM := 'Erro ao atualizar veiculo. Erro: ' || SQLERRM;  
            RAISE E_GERAL;
        END;
      WHEN OTHERS THEN
        O_MENSAGEM := 'Erro ao inserir veiculo. Erro: ' || SQLERRM;
        RAISE E_GERAL;
    END;  
    
    COMMIT;
    
  EXCEPTION
    WHEN E_GERAL THEN
      O_MENSAGEM := '[INSERE_CARRO]' || O_MENSAGEM;
    WHEN OTHERS THEN
      O_MENSAGEM := 'Erro no procedimento que insere o carro: ' || SQLERRM;
  END;
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  PROCEDURE INSERE_PESSOA (I_NM_PESSOA     IN PESSOA_CURSO.NM_PESSOA%TYPE,
                           I_NR_CPF        IN PESSOA_CURSO.NR_CPF%TYPE,
                           I_DT_NASCIMENTO IN PESSOA_CURSO.DT_NASCIMENTO%TYPE,  
                           I_ID_PESSOA     IN PESSOA_CURSO.ID_PESSOA%TYPE,
                           I_NR_ALTURA     IN PESSOA_CURSO.NR_ALTURA%TYPE,
                           O_MENSAGEM      OUT VARCHAR2) IS
    V_ID_PESSOA PESSOA_CURSO.ID_PESSOA%TYPE;  
    E_GERAL EXCEPTION;                       
  BEGIN
    
    IF I_NM_PESSOA IS NULL THEN
      O_MENSAGEM := 'O nome precisa ser informado!';
      RAISE E_GERAL;
    END IF;
    
    IF I_NR_CPF IS NULL THEN
      O_MENSAGEM := 'O CPF precisa ser informado!';  
      RAISE E_GERAL;
    END IF;  
    
    IF I_DT_NASCIMENTO IS NULL THEN
      O_MENSAGEM := 'A data de nascimento precisa ser informada!';
      RAISE E_GERAL;
    END IF;  
    
    IF LENGTH(I_NR_CPF) <> 11 THEN
      O_MENSAGEM := 'CPF informado é inválido!';
      RAISE E_GERAL;
    END IF;  
    
    IF INSTR(I_NM_PESSOA, ' ') = 0 THEN
      O_MENSAGEM := 'Precisa ser informado o nome completo!';
      RAISE E_GERAL;
    END IF;   
     
    BEGIN
      SELECT MAX(PESSOA_CURSO.ID_PESSOA)
        INTO V_ID_PESSOA
        FROM PESSOA_CURSO;
    EXCEPTION
      WHEN OTHERS THEN
        V_ID_PESSOA := 0;
    END;
    
    V_ID_PESSOA := NVL(V_ID_PESSOA,0) + 1;
    
    BEGIN
      INSERT INTO PESSOA_CURSO(
        NM_PESSOA,
        NR_CPF,
        DT_NASCIMENTO,
        ID_PESSOA,
        NR_ALTURA)
      VALUES(
        I_NM_PESSOA,
        I_NR_CPF,
        I_DT_NASCIMENTO,
        NVL(I_ID_PESSOA, V_ID_PESSOA),
        I_NR_ALTURA);
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        BEGIN
          UPDATE PESSOA_CURSO
            SET NM_PESSOA     = I_NM_PESSOA,
                NR_CPF        = I_NR_CPF,
                DT_NASCIMENTO = I_DT_NASCIMENTO,
                NR_ALTURA     = I_NR_ALTURA
          WHERE ID_PESSOA = I_ID_PESSOA;    
        EXCEPTION
          WHEN OTHERS THEN
            O_MENSAGEM := 'Erro ao atualizar pessoa. Erro; ' || SQLERRM;
            RAISE E_GERAL;
        END;
      WHEN OTHERS THEN
        O_MENSAGEM := 'Erro ao inserir peossa. Erro: ' || SQLERRM;
        RAISE E_GERAL;  
    END;
    
    COMMIT;
    
  EXCEPTION
    WHEN E_GERAL THEN
      O_MENSAGEM := '[INSERE PESSOA]' || O_MENSAGEM;
    WHEN OTHERS THEN 
      O_MENSAGEM := 'Erro no procedimento que insere uma pessoa: ' || SQLERRM;
  END;  
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  PROCEDURE EXCLUI_CARRO (I_NR_PLACA IN CARRO_CURSO.NR_PLACA%TYPE,
                          O_MENSAGEM OUT VARCHAR2) IS
    E_GERAL EXCEPTION;
    
    BEGIN
      IF I_NR_PLACA IS NULL THEN
        O_MENSAGEM := 'Informe a placa';
        RAISE E_GERAL;
      END IF;
      
      BEGIN
        DELETE CARRO_CURSO
         WHERE NR_PLACA = I_NR_PLACA;
      EXCEPTION
        WHEN OTHERS THEN
          O_MENSAGEM := 'Erro ao excluir carro: ' || SQLERRM;
      END;   
      
      COMMIT;
        
    EXCEPTION
      WHEN E_GERAL THEN
        O_MENSAGEM := '[EXCLUI_CARRO]' || O_MENSAGEM;
      WHEN OTHERS THEN
        O_MENSAGEM := 'Erro no procedimento de exclusão de carro: ' || SQLERRM;
    END; 
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  PROCEDURE EXLUI_PESSOA(I_ID_PESSOA IN PESSOA_CURSO.ID_PESSOA%TYPE,
                         O_MENSAGEM  OUT VARCHAR2) IS
      E_GERAL EXCEPTION;                     
    BEGIN
      IF I_ID_PESSOA IS NULL THEN
        O_MENSAGEM := 'Informe um ID para a pessoa!';
        RAISE E_GERAL;
      END IF;
      
      BEGIN
        DELETE PESSOA_CURSO
         WHERE ID_PESSOA = I_ID_PESSOA;
      EXCEPTION
        WHEN OTHERS THEN
         O_MENSAGEM := 'Erro ao excluir pessoa!' || SQLERRM;
      END;
      
      COMMIT;
      
    EXCEPTION
      WHEN E_GERAL THEN
        O_MENSAGEM := '[EXCLUI_PESSOA]' || O_MENSAGEM;
      WHEN OTHERS THEN
        O_MENSAGEM := 'Erro no procedimento de exclusão de pessoa: ' || SQLERRM;
    END;              
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  PROCEDURE INSERE_ITEMNOTA (I_ID_ITEM  IN ITEMNOTA_CURSO.ID_ITEM%TYPE,
                             I_VL_ITEM  IN ITEMNOTA_CURSO.VL_ITEM%TYPE,
                             I_DS_ITEM  IN ITEMNOTA_CURSO.DS_ITEM%TYPE,
                             I_NR_NOTA  IN ITEMNOTA_CURSO.NR_NOTA%TYPE,
                             O_MENSAGEM OUT VARCHAR2) IS
    E_GERAL EXCEPTION;
    V_ID_ITEM ITEMNOTA_CURSO.ID_ITEM%TYPE;
    V_COUNT NUMBER;
  BEGIN
    IF I_VL_ITEM IS NULL THEN
      O_MENSAGEM := 'O valor do item precisa ser informado!';
      RAISE E_GERAL;
    END IF;
    
    IF I_DS_ITEM IS NULL THEN
      O_MENSAGEM := 'A descrição precisa ser informada!';
      RAISE E_GERAL;
    END IF;
        
    IF I_NR_NOTA IS NULL THEN
      O_MENSAGEM := 'O número da nota precisa ser informado!';
      RAISE E_GERAL;
    END IF;  
    
    BEGIN
      SELECT COUNT(*)
        INTO V_COUNT
        FROM NOTAFISCAL_CURSO
       WHERE NOTAFISCAL_CURSO.NR_NOTA = I_NR_NOTA;
    EXCEPTION
      WHEN OTHERS THEN
        V_COUNT := 0;
    END;
    
    IF V_COUNT = 0 THEN
      O_MENSAGEM := 'Nota ' || I_NR_NOTA || ' não cadastrada';
      RAISE E_GERAL;
    END IF;  
    
    BEGIN
      SELECT MAX(ITEMNOTA_CURSO.ID_ITEM)
        INTO V_ID_ITEM
        FROM ITEMNOTA_CURSO;
    EXCEPTION
      WHEN OTHERS THEN
        V_ID_ITEM := 0;
    END;
    
    V_ID_ITEM := V_ID_ITEM + 1;
    
    BEGIN
      INSERT INTO ITEMNOTA_CURSO(
        ID_ITEM,
        VL_ITEM,
        DS_ITEM,
        NR_NOTA)
      VALUES(
        NVL(I_ID_ITEM, V_ID_ITEM),
        I_VL_ITEM,
        I_DS_ITEM,
        I_NR_NOTA);  
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        BEGIN
          UPDATE ITEMNOTA_CURSO
            SET VL_ITEM = I_VL_ITEM,
                DS_ITEM = I_DS_ITEM
          WHERE ID_ITEM = I_ID_ITEM;    
        EXCEPTION
          WHEN OTHERS THEN
            O_MENSAGEM := 'Erro ao atualizar o item: ' || SQLERRM;
        END;
      WHEN OTHERS THEN
        O_MENSAGEM := 'Erro ao inserir a nota: ' || SQLERRM;
    END;
    
    COMMIT;
    
  EXCEPTION
    WHEN E_GERAL THEN
      O_MENSAGEM := '[INSERE_ITEMNOTA] ' || O_MENSAGEM;
    WHEN OTHERS THEN
      O_MENSAGEM := 'Erro no procedimento que insere nota: ' || SQLERRM;  
  END;     
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  FUNCTION RETORNA_QUANTIDADEDECARROS (I_NR_ANOMODELO IN CARRO_CURSO.NR_ANOMODELO%TYPE)
                                                      RETURN NUMBER IS
    V_COUNT NUMBER;
  BEGIN
  
    SELECT COUNT(*)
      INTO V_COUNT
      FROM CARRO_CURSO
     WHERE CARRO_CURSO.NR_ANOMODELO = I_NR_ANOMODELO;  
  
    RETURN V_COUNT;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;  
  END;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 -- Crie uma função que receba o número de uma nota e retorne o seu valor
 FUNCTION RETORNA_VALORNOTA(I_NR_NOTA IN NOTAFISCAL_CURSO.NR_NOTA%TYPE)
                                      RETURN NOTAFISCAL_CURSO.VL_NOTA%TYPE IS
   V_VL_NOTA NOTAFISCAL_CURSO.VL_NOTA%TYPE;
 BEGIN
   SELECT NOTAFISCAL_CURSO.VL_NOTA
     INTO V_VL_NOTA
     FROM NOTAFISCAL_CURSO
    WHERE NOTAFISCAL_CURSO.NR_NOTA = I_NR_NOTA;
    
   RETURN V_VL_NOTA; 
 EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL; 
 END; 
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                                    
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 -- Crie uma função que receba a data e retorne a quantidade de notas 
 -- emitidas naquela data  
 FUNCTION RETORNA_QTDENOTAS(I_DT_COMPRA IN NOTAFISCAL_CURSO.DT_COMPRA%TYPE)
                                        RETURN NUMBER IS
   V_COUNT NUMBER;
 BEGIN
   SELECT COUNT(*)
     INTO V_COUNT
     FROM NOTAFISCAL_CURSO
    WHERE NOTAFISCAL_CURSO.DT_COMPRA = I_DT_COMPRA; 
   
   RETURN V_COUNT; 
    
 EXCEPTION
   WHEN OTHERS THEN
     RETURN NULL;
 END;                                        
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 -- Crie uma função que receba o nome de um vendedor e retorne quantas
 -- notas foram emitidas por ele
 FUNCTION RETORNA_QTVENDAS_VENDEDOR (I_DS_VENDEDOR IN NOTAFISCAL_CURSO.DS_VENDEDOR%TYPE)
                                                   RETURN NUMBER IS
   V_COUNT NUMBER;                                                  
 BEGIN
   SELECT COUNT(*)
     INTO V_COUNT
     FROM NOTAFISCAL_CURSO
    WHERE NOTAFISCAL_CURSO.DS_VENDEDOR = I_DS_VENDEDOR;
    
   RETURN V_COUNT;
     
 EXCEPTION
   WHEN OTHERS THEN
     RETURN NULL;
 END;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                                                                                                                                                                                                                           
 FUNCTION RETORNA_VALORTOTALNOTAS RETURN NUMBER IS
   V_VL_SUMNF NUMBER;
   
   CURSOR CUR_NOTAS IS
     SELECT NOTAFISCAL_CURSO.VL_NOTA
       FROM NOTAFISCAL_CURSO;  
 BEGIN
   V_VL_SUMNF := 0;
   FOR I IN CUR_NOTAS LOOP
     V_VL_SUMNF := V_VL_SUMNF + NVL(I.VL_NOTA, 0);
   END LOOP;
   
   RETURN V_VL_SUMNF;  
 END;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 -- Crie uma função que retorne o nome de todos os clientes, sem repetir, em
 -- uma string separado por vírgulas
 FUNCTION RETORNA_NOMECLIENTES RETURN VARCHAR2 IS
   V_DS_NOMECLIENTES VARCHAR2(32000);
   
   V_COUNT NUMBER;
   
   CURSOR CUR_CLIENTES IS
     SELECT DISTINCT NOTAFISCAL_CURSO.DS_CLIENTE
       FROM NOTAFISCAL_CURSO;
 BEGIN
   V_COUNT := 0;
   FOR I IN CUR_CLIENTES LOOP
     V_COUNT := V_COUNT + 1;
     IF V_COUNT = 1 THEN
       V_DS_NOMECLIENTES := I.DS_CLIENTE;
     ELSE
       V_DS_NOMECLIENTES := V_DS_NOMECLIENTES || ', ' || I.DS_CLIENTE;
     END IF;    
   END LOOP;  
   
   RETURN V_DS_NOMECLIENTES;
 END;      
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 FUNCTION TESTE_VETOR RETURN VARCHAR2 IS
   TYPE T_CLIENTES IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
   V_CLIENTES T_CLIENTES;
 BEGIN
   V_CLIENTES(1) := 'Daniel';
   V_CLIENTES(2) := 'Kedssy'; 
   V_CLIENTES(3) := 'Matheus';
 
   RETURN V_CLIENTES(3); 
 END;
end PACK_NOTAFISCAL;
/
