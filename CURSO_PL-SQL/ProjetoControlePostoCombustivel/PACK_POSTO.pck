create or replace package PACK_POSTO is

  -- Author  : JHONATAN.MATTANA
  -- Created : 27/04/2022 16:43:03
  -- Purpose : 
 PROCEDURE GRAVA_COMBUSTIVEL(IO_CD_COMBUSTIVEL IN OUT COMBUSTIVELCURSO.CD_COMBUSTIVEL%TYPE,
                              I_DS_COMBUSTIVEL IN COMBUSTIVELCURSO.DS_COMBUSTIVEL%TYPE,
                              I_VL_COMBUSTIVEL IN COMBUSTIVELCURSO.VL_COMBUSTIVEL%TYPE,
                              O_MENSAGEM       OUT VARCHAR2);
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------                             
 PROCEDURE GRAVA_PROPRIETARIO(IO_CD_PROPRIETARIO IN OUT PROPRIETARIOCURSO.CD_PROPRIETARIO%TYPE,
                              I_NM_PROPRIETARIO  IN PROPRIETARIOCURSO.NM_PROPRIETARIO%TYPE,
                              I_NR_CNPJCPF       IN PROPRIETARIOCURSO.NR_CNPJCPF%TYPE,
                              I_DS_ENDERECO      IN PROPRIETARIOCURSO.DS_ENDERECO%TYPE,
                              I_NR_TELEFONE      IN PROPRIETARIOCURSO.NR_TELEFONE%TYPE,
                              O_MENSAGEM         OUT VARCHAR2);                            
 --------------------------------------------------------------------------------
 -------------------------------------------------------------------------------- 
 PROCEDURE GRAVA_VEICULO(I_NR_PLACA        IN VEICULOCURSO.NR_PLACA%TYPE,
                         I_CD_COMBUSTIVEL  IN COMBUSTIVELCURSO.CD_COMBUSTIVEL%TYPE,
                         I_CD_PROPRIETARIO IN PROPRIETARIOCURSO.CD_PROPRIETARIO%TYPE,
                         I_KM_ATUAL        IN VEICULOCURSO.KM_ATUAL%TYPE,
                         O_MENSAGEM        OUT VARCHAR2);
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE GRAVA_FRENTISTA(IO_CD_FRENTISTA IN OUT FRENTISTACURSO.CD_FRENTISTA%TYPE,
                           I_NM_FRENTISTA  IN FRENTISTACURSO.NM_FRENTISTA%TYPE,
                           I_PC_COMISSAO   IN FRENTISTACURSO.PC_COMISSAO%TYPE,
                           O_MENSAGEM      OUT VARCHAR2);
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE GARAVA_ABASTECIMENTO(IO_CD_ABASTECIMENTO IN OUT ABASTECIMENTOCURSO.CD_ABASTECIMENTO%TYPE,
                                I_NR_PLACA          IN VEICULOCURSO.NR_PLACA%TYPE,
                                I_CD_FRENTISTA      IN FRENTISTACURSO.CD_FRENTISTA%TYPE,
                                I_QT_ABASTECIDA     IN ABASTECIMENTOCURSO.QT_ABASTECIDA%TYPE,
                                I_KM_ABASTECIMENTO  IN ABASTECIMENTOCURSO.KM_ABASTECIMENTO%TYPE,
                                O_MENSAGEM          OUT VARCHAR2); 
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE EXCLUI_PROPRIETARIO(I_CD_PROPRIETARIO IN PROPRIETARIOCURSO.CD_PROPRIETARIO%TYPE,
                               O_MENSAGEM        OUT VARCHAR2);                                                          
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE EXCLUI_COMBUSTIVEL(I_CD_COMBUSTIVEL IN COMBUSTIVELCURSO.CD_COMBUSTIVEL%TYPE,
                               O_MENSAGEM        OUT VARCHAR2);
end PACK_POSTO;
/
create or replace package body PACK_POSTO is

  PROCEDURE GRAVA_COMBUSTIVEL(IO_CD_COMBUSTIVEL IN OUT COMBUSTIVELCURSO.CD_COMBUSTIVEL%TYPE,
                              I_DS_COMBUSTIVEL IN COMBUSTIVELCURSO.DS_COMBUSTIVEL%TYPE,
                              I_VL_COMBUSTIVEL IN COMBUSTIVELCURSO.VL_COMBUSTIVEL%TYPE,
                              O_MENSAGEM       OUT VARCHAR2) IS
    E_GERAL          EXCEPTION;
  BEGIN
    IF I_DS_COMBUSTIVEL IS NULL THEN
      O_MENSAGEM := 'A descri��o do combust�vel precisa ser informada.';
      RAISE E_GERAL;
    END IF;
    
    IF I_VL_COMBUSTIVEL IS NULL THEN
      O_MENSAGEM := 'O valor do combust�vel precisa ser informado.';
      RAISE E_GERAL;
    END IF;    
    
    IF IO_CD_COMBUSTIVEL IS NULL THEN
      BEGIN
        SELECT MAX(COMBUSTIVELCURSO.CD_COMBUSTIVEL)
          INTO IO_CD_COMBUSTIVEL
          FROM COMBUSTIVELCURSO;
      EXCEPTION
        WHEN OTHERS THEN
          IO_CD_COMBUSTIVEL := 0;  
      END;    
    
      IO_CD_COMBUSTIVEL := NVL(IO_CD_COMBUSTIVEL, 0) + 1;
    END IF;
    
    BEGIN
      INSERT INTO COMBUSTIVELCURSO(
        CD_COMBUSTIVEL,
        DS_COMBUSTIVEL,
        VL_COMBUSTIVEL,
        DT_RECORD)
      VALUES(
        IO_CD_COMBUSTIVEL,
        I_DS_COMBUSTIVEL,
        I_VL_COMBUSTIVEL,
        SYSDATE);
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        BEGIN
          UPDATE COMBUSTIVELCURSO
             SET DS_COMBUSTIVEL = I_DS_COMBUSTIVEL,
                 VL_COMBUSTIVEL = I_VL_COMBUSTIVEL,
                 DT_REFRESH     = SYSDATE
           WHERE CD_COMBUSTIVEL = IO_CD_COMBUSTIVEL;    
        EXCEPTION
          WHEN OTHERS THEN
            O_MENSAGEM := 'Erro inesperado ao atualizar o bombust�vel (' || IO_CD_COMBUSTIVEL || ')
                          :' || SQLERRM;
            RAISE E_GERAL;
        END;
     WHEN OTHERS THEN
       O_MENSAGEM := 'Erro ao inserir o combust�vel (' || IO_CD_COMBUSTIVEL || '): ' || SQLERRM;
       RAISE E_GERAL; 
   END;
    
   COMMIT;
   
  EXCEPTION
    WHEN E_GERAL THEN
      ROLLBACK;
      O_MENSAGEM := '[GRAVA_COMBUSTIVEL] ' || O_MENSAGEM;
    WHEN OTHERS THEN
      ROLLBACK;
      O_MENSAGEM := '[GRAVA_COMBUSTIVEL] Erro no procedimento que grava combust�vel: '
                     || SQLERRM;
  END;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE GRAVA_PROPRIETARIO(IO_CD_PROPRIETARIO IN OUT PROPRIETARIOCURSO.CD_PROPRIETARIO%TYPE,
                              I_NM_PROPRIETARIO  IN PROPRIETARIOCURSO.NM_PROPRIETARIO%TYPE,
                              I_NR_CNPJCPF       IN PROPRIETARIOCURSO.NR_CNPJCPF%TYPE,
                              I_DS_ENDERECO      IN PROPRIETARIOCURSO.DS_ENDERECO%TYPE,
                              I_NR_TELEFONE      IN PROPRIETARIOCURSO.NR_TELEFONE%TYPE,
                              O_MENSAGEM         OUT VARCHAR2) IS
   E_GERAL EXCEPTION;
 BEGIN
   IF I_NM_PROPRIETARIO IS NULL THEN
     O_MENSAGEM := 'O nome do propriet�rio precisa ser informado.';
     RAISE E_GERAL;
   END IF;
   
   IF I_NR_CNPJCPF IS NULL THEN
     O_MENSAGEM := 'O n�mero do CPF/CNPJ precisa ser informado.';  
     RAISE E_GERAL;
   END IF;
   
   IF LENGTH(I_NR_CNPJCPF) <> 11 AND LENGTH(I_NR_CNPJCPF) <> 14 THEN
     O_MENSAGEM := 'Precisa ser informado um n�mero correto de CPF/CNPJ';
     RAISE E_GERAL; 
   END IF;  
   
   IF IO_CD_PROPRIETARIO IS NULL THEN
     BEGIN
       SELECT MAX(PROPRIETARIOCURSO.CD_PROPRIETARIO)
         INTO IO_CD_PROPRIETARIO
         FROM PROPRIETARIOCURSO;
     EXCEPTION
       WHEN OTHERS THEN
         IO_CD_PROPRIETARIO := 0;
     END;
     IO_CD_PROPRIETARIO := NVL(IO_CD_PROPRIETARIO, 0) + 1;
   END IF;
     
   BEGIN
     INSERT INTO PROPRIETARIOCURSO(
       CD_PROPRIETARIO,
       NM_PROPRIETARIO,
       NR_CNPJCPF,
       DS_ENDERECO,
       NR_TELEFONE,
       DT_RECORD)
     VALUES(
       IO_CD_PROPRIETARIO,
       I_NM_PROPRIETARIO,
       I_NR_CNPJCPF,
       I_DS_ENDERECO,
       I_NR_TELEFONE,
       SYSDATE);  
   EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
       BEGIN
         UPDATE PROPRIETARIOCURSO
            SET NM_PROPRIETARIO = NVL(I_NM_PROPRIETARIO, NM_PROPRIETARIO),
                NR_CNPJCPF = NVL(I_NR_CNPJCPF, NR_CNPJCPF),
                DS_ENDERECO = NVL(I_DS_ENDERECO, DS_ENDERECO),
                NR_TELEFONE = NVL(I_NR_TELEFONE, NR_TELEFONE),
                DT_REFRESH = SYSDATE
          WHERE CD_PROPRIETARIO = IO_CD_PROPRIETARIO;    
       EXCEPTION
         WHEN OTHERS THEN
           O_MENSAGEM := 'Erro ao atualizar propriet�rio('|| IO_CD_PROPRIETARIO ||'): ' || SQLERRM;
           RAISE E_GERAL;
       END;
     WHEN OTHERS THEN
       O_MENSAGEM := 'Erro ao inserir propriet�rio('|| IO_CD_PROPRIETARIO ||'): ' || SQLERRM;
       RAISE E_GERAL;
   END;
   
   COMMIT;
   
 EXCEPTION
   WHEN E_GERAL THEN
     O_MENSAGEM := '[GRAVA_PROPRIETARIO] ' || O_MENSAGEM;
   WHEN OTHERS THEN
     ROLLBACK;
     O_MENSAGEM := '[GRAVA_PROPRIETARIO] Erro no procedimento que grava o propriet�rio: ' || SQLERRM;
 END;
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 -------------------------------------------------------------------------------- 
 PROCEDURE GRAVA_VEICULO(I_NR_PLACA        IN VEICULOCURSO.NR_PLACA%TYPE,
                         I_CD_COMBUSTIVEL  IN COMBUSTIVELCURSO.CD_COMBUSTIVEL%TYPE,
                         I_CD_PROPRIETARIO IN PROPRIETARIOCURSO.CD_PROPRIETARIO%TYPE,
                         I_KM_ATUAL        IN VEICULOCURSO.KM_ATUAL%TYPE,
                         O_MENSAGEM        OUT VARCHAR2) IS
   E_GERAL EXCEPTION;  
   V_COUNT NUMBER;                      
 BEGIN 
   
   IF I_NR_PLACA IS NULL THEN
     O_MENSAGEM := 'A placa precisa ser informada';
     RAISE E_GERAL;
   END IF;  
   
   IF I_CD_COMBUSTIVEL IS NULL THEN 
     O_MENSAGEM := 'O tipo de combust�vel precisa ser informada';
     RAISE E_GERAL;
   END IF; 
   
   IF I_CD_PROPRIETARIO IS NULL THEN
     O_MENSAGEM := 'O propriet�rio precisa ser informada';
     RAISE E_GERAL;
   END IF;  
   
   BEGIN
     SELECT COUNT(*)
       INTO V_COUNT
       FROM COMBUSTIVELCURSO
      WHERE COMBUSTIVELCURSO.CD_COMBUSTIVEL = I_CD_COMBUSTIVEL;  
   EXCEPTION
     WHEN OTHERS THEN
       V_COUNT := 0;
   END;
   
   IF NVL(V_COUNT, 0) = 0 THEN
     O_MENSAGEM := 'Nenhum combust�vel cadastrado com o c�digo ' || I_CD_COMBUSTIVEL ||'. Verifique!';
     RAISE E_GERAL;
   END IF;
   
   BEGIN
     SELECT COUNT(*)
       INTO V_COUNT
       FROM PROPRIETARIOCURSO
      WHERE PROPRIETARIOCURSO.CD_PROPRIETARIO = I_CD_PROPRIETARIO;
   EXCEPTION
     WHEN OTHERS THEN
       V_COUNT := 0;
   END;
   
   IF NVL(V_COUNT, 0) = 0 THEN
     O_MENSAGEM := 'Nenhum propriet�rio cadastrado com o c�digo ' || I_CD_PROPRIETARIO ||'. Verifique!';
     RAISE E_GERAL;
   END IF;
   
   BEGIN
     INSERT INTO VEICULOCURSO(
       NR_PLACA,
       CD_COMBUSTIVEL,
       CD_PROPRIETARIO,
       KM_ATUAL,
       DT_RECORD)
     VALUES(
       I_NR_PLACA,
       I_CD_COMBUSTIVEL,
       I_CD_PROPRIETARIO,
       NVL(I_KM_ATUAL, 0),
       SYSDATE);
   EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
       BEGIN
         UPDATE VEICULOCURSO
            SET CD_PROPRIETARIO = NVL(I_CD_PROPRIETARIO, CD_PROPRIETARIO),
                KM_ATUAL = NVL(I_KM_ATUAL, KM_ATUAL),
                DT_REFRESH = SYSDATE
          WHERE NR_PLACA = I_NR_PLACA;   
       EXCEPTION
         WHEN OTHERS THEN
           O_MENSAGEM := 'Erro ao atualizar o ve�culo ' || I_NR_PLACA || ': ' || SQLERRM;
           RAISE E_GERAL;
       END;
     
     WHEN OTHERS THEN
       O_MENSAGEM := ' Erro ao inserir o ve�culo ' || I_NR_PLACA ||': ' || SQLERRM;  
       RAISE E_GERAL;
   END;
   
   COMMIT;
   
 EXCEPTION 
   WHEN E_GERAL THEN
     ROLLBACK;
     O_MENSAGEM := '[GRAVA_VEICULO] ' || O_MENSAGEM;
   WHEN OTHERS THEN
     ROLLBACK;
     O_MENSAGEM := '[GRAVA_VEICULO] Erro no procedimento que insere ve�culo: ' || SQLERRM;  
 END;  
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE GRAVA_FRENTISTA(IO_CD_FRENTISTA IN OUT FRENTISTACURSO.CD_FRENTISTA%TYPE,
                           I_NM_FRENTISTA  IN FRENTISTACURSO.NM_FRENTISTA%TYPE,
                           I_PC_COMISSAO   IN FRENTISTACURSO.PC_COMISSAO%TYPE,
                           O_MENSAGEM      OUT VARCHAR2) IS
    E_GERAL EXCEPTION;
 BEGIN
   IF I_NM_FRENTISTA IS NULL THEN
     O_MENSAGEM := 'O nome do frentista precisa ser informado!';
     RAISE E_GERAL;
   END IF;  
   
   IF IO_CD_FRENTISTA IS NULL THEN
     BEGIN
       SELECT MAX(FRENTISTACURSO.CD_FRENTISTA)
         INTO IO_CD_FRENTISTA
         FROM FRENTISTACURSO;
     EXCEPTION
       WHEN OTHERS THEN
         IO_CD_FRENTISTA := 0;
     END;
     
     IO_CD_FRENTISTA := NVL(IO_CD_FRENTISTA, 0) + 1;
     
   END IF;   
   
   BEGIN 
     INSERT INTO FRENTISTACURSO(
       CD_FRENTISTA,
       NM_FRENTISTA,
       PC_COMISSAO,
       DT_RECORD)
     VALUES(
       IO_CD_FRENTISTA,
       I_NM_FRENTISTA,
       I_PC_COMISSAO,
       SYSDATE);
   EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
       BEGIN
         UPDATE FRENTISTACURSO
            SET NM_FRENTISTA = NVL(I_NM_FRENTISTA, NM_FRENTISTA),
                PC_COMISSAO = NVL(I_PC_COMISSAO, 0),
                DT_REFRESH = SYSDATE
          WHERE CD_FRENTISTA = IO_CD_FRENTISTA;      
       EXCEPTION
         WHEN OTHERS THEN
           O_MENSAGEM := 'Erro ao atualizar o frentista ' || IO_CD_FRENTISTA|| ': ' || SQLERRM;
           RAISE E_GERAL;  
       END;
     WHEN OTHERS THEN
       O_MENSAGEM := 'Erro ao gravar o frentista ' || IO_CD_FRENTISTA || ': ' || SQLERRM;
       RAISE E_GERAL;
   END;
   
   COMMIT;
   
 EXCEPTION
   WHEN E_GERAL THEN
     ROLLBACK;
     O_MENSAGEM := '[GRAVA_FRENTISTA] ' || O_MENSAGEM;
   WHEN OTHERS THEN
     ROLLBACK;
     O_MENSAGEM := '[GRAVA_FRENTISTA] Erro no procedimento que insere o frentista: ' || SQLERRM;  
 END;  
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE GARAVA_ABASTECIMENTO(IO_CD_ABASTECIMENTO IN OUT ABASTECIMENTOCURSO.CD_ABASTECIMENTO%TYPE,
                                I_NR_PLACA          IN VEICULOCURSO.NR_PLACA%TYPE,
                                I_CD_FRENTISTA      IN FRENTISTACURSO.CD_FRENTISTA%TYPE,
                                I_QT_ABASTECIDA     IN ABASTECIMENTOCURSO.QT_ABASTECIDA%TYPE,
                                I_KM_ABASTECIMENTO  IN ABASTECIMENTOCURSO.KM_ABASTECIMENTO%TYPE,
                                O_MENSAGEM          OUT VARCHAR2) IS
   E_GERAL          EXCEPTION;  
   V_COUNT          NUMBER;
   V_VL_COMBUSTIVEL COMBUSTIVELCURSO.VL_COMBUSTIVEL%TYPE;
 BEGIN
   IF I_NR_PLACA IS NULL THEN
     O_MENSAGEM := 'A placa precisa ser informada!';
     RAISE E_GERAL;
   END IF;
   
   IF I_CD_FRENTISTA IS NULL THEN
     O_MENSAGEM := 'O frentista precisa ser informado!';
     RAISE E_GERAL;
   END IF;
   
   IF I_QT_ABASTECIDA IS NULL THEN
     O_MENSAGEM := 'A quantidade abastecida precisa ser informada!';
     RAISE E_GERAL;
   END IF;    
     
   BEGIN
     SELECT COUNT(*)
       INTO V_COUNT
       FROM VEICULOCURSO
      WHERE VEICULOCURSO.NR_PLACA = I_NR_PLACA;
   EXCEPTION
     WHEN OTHERS THEN
       V_COUNT := 0;
   END;
   
   IF NVL(V_COUNT, 0) = 0 THEN
     O_MENSAGEM := 'Veiculo de placa ' || I_NR_PLACA || ' n�o cadastrado!';
     RAISE E_GERAL;
   END IF;  
   
   BEGIN 
     SELECT COUNT(*)
       INTO V_COUNT
       FROM FRENTISTACURSO
      WHERE FRENTISTACURSO.CD_FRENTISTA = I_CD_FRENTISTA; 
   EXCEPTION
     WHEN OTHERS THEN
       V_COUNT := 0;
   END;
   
   IF NVL(V_COUNT, 0) = 0 THEN
     O_MENSAGEM := 'Frentista de codigo ' || I_CD_FRENTISTA || ' n�o cadastrado!';
     RAISE E_GERAL;  
   END IF;
   
   BEGIN
     SELECT COMBUSTIVELCURSO.VL_COMBUSTIVEL
       INTO V_VL_COMBUSTIVEL
       FROM COMBUSTIVELCURSO,
            VEICULOCURSO
      WHERE COMBUSTIVELCURSO.CD_COMBUSTIVEL = VEICULOCURSO.CD_COMBUSTIVEL
        AND VEICULOCURSO.NR_PLACA = I_NR_PLACA;    
   EXCEPTION
     WHEN OTHERS THEN
       V_VL_COMBUSTIVEL := 0;
   END;
   
   IF NVL(V_VL_COMBUSTIVEL, 0) = 0 THEN
     O_MENSAGEM := 'Valor n�o cadastrado para o combustivel, ou zerado. Verifique o cadastro do combustivel.';
     RAISE E_GERAL;
   END IF;
   

   IF IO_CD_ABASTECIMENTO IS NULL THEN
     BEGIN
       SELECT MAX(ABASTECIMENTOCURSO.CD_ABASTECIMENTO)
         INTO IO_CD_ABASTECIMENTO
         FROM ABASTECIMENTOCURSO;
     EXCEPTION
       WHEN OTHERS THEN
         IO_CD_ABASTECIMENTO := 0;
     END;
     
     IO_CD_ABASTECIMENTO := NVL(IO_CD_ABASTECIMENTO, 0) + 1;
     
     BEGIN
       UPDATE VEICULOCURSO
          SET KM_ATUAL = I_KM_ABASTECIMENTO,
              DT_REFRESH = SYSDATE
        WHERE NR_PLACA = I_NR_PLACA; 
     EXCEPTION
       WHEN OTHERS THEN
         O_MENSAGEM := 'Erro ao atualizar a quilometragem do veiculo ' || I_NR_PLACA || ': ' || SQLERRM;
         RAISE E_GERAL;   
     END;
   END IF;  
   
   BEGIN
     INSERT INTO ABASTECIMENTOCURSO(
       CD_ABASTECIMENTO,
       NR_PLACA,
       CD_FRENTISTA,
       QT_ABASTECIDA,
       KM_ABASTECIMENTO,
       VL_COMBUSTIVEL,
       DT_RECORD)
     VALUES(
       IO_CD_ABASTECIMENTO,
       I_NR_PLACA,
       I_CD_FRENTISTA,
       I_QT_ABASTECIDA,
       I_KM_ABASTECIMENTO,
       V_VL_COMBUSTIVEL,
       SYSDATE);  
       
   EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
       BEGIN
         UPDATE ABASTECIMENTOCURSO
            SET NR_PLACA = I_NR_PLACA,
                CD_FRENTISTA = I_CD_FRENTISTA,
                QT_ABASTECIDA = I_QT_ABASTECIDA,
                DT_REFRESH = SYSDATE
          WHERE CD_ABASTECIMENTO = IO_CD_ABASTECIMENTO;     
       EXCEPTION
         WHEN OTHERS THEN
           O_MENSAGEM := 'Erro ao atualizar o abastecimento ' || IO_CD_ABASTECIMENTO || ': ' || SQLERRM;
           RAISE E_GERAL;
       END;
     WHEN OTHERS THEN
       O_MENSAGEM := 'Erro ao inserir o abastecimento: ' || SQLERRM;
   END;
   
   COMMIT;
   
 EXCEPTION
   WHEN E_GERAL THEN
     ROLLBACK;
     O_MENSAGEM := '[GARAVA_ABASTECIMENTO] ' || O_MENSAGEM;
   WHEN OTHERS THEN
     ROLLBACK;
     O_MENSAGEM := '[GARAVA_ABASTECIMENTO] Erro no procedimento que insere o abastecimento: ' || SQLERRM;  
 END;      
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE EXCLUI_PROPRIETARIO(I_CD_PROPRIETARIO IN PROPRIETARIOCURSO.CD_PROPRIETARIO%TYPE,
                               O_MENSAGEM        OUT VARCHAR2) IS
   E_GERAL EXCEPTION;
   V_COUNT NUMBER;
 BEGIN
   BEGIN
     SELECT COUNT(*)
       INTO V_COUNT
       FROM VEICULOCURSO
      WHERE VEICULOCURSO.CD_PROPRIETARIO = I_CD_PROPRIETARIO;
   EXCEPTION
     WHEN OTHERS THEN
       V_COUNT := 0;
   END;  
   
   IF V_COUNT > 0 THEN
     O_MENSAGEM := 'O propriet�rio nao pode ser exclu�do, pois existem ve�culos 
     cadastrados que pertencem a ele';
     RAISE E_GERAL;
   END IF;
   
   BEGIN
     DELETE PROPRIETARIOCURSO
      WHERE CD_PROPRIETARIO = I_CD_PROPRIETARIO;
   EXCEPTION
     WHEN OTHERS THEN
       O_MENSAGEM := 'Erro ao exclu�r o propriet�rio ' || I_CD_PROPRIETARIO || ': ' || SQLERRM;
       RAISE E_GERAL;
   END;
   
 EXCEPTION
   WHEN E_GERAL THEN
     ROLLBACK;
     O_MENSAGEM := '[EXCLUI_PROPRIETARIO] ' || O_MENSAGEM;  
     
   WHEN OTHERS THEN
     ROLLBACK;
     O_MENSAGEM := '[EXCLUI_PROPRIETARIO] Erro no procedimento de exclusao do propriet�rio: ' || SQLERRM;
 END; 
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 --------------------------------------------------------------------------------
 PROCEDURE EXCLUI_COMBUSTIVEL(I_CD_COMBUSTIVEL IN COMBUSTIVELCURSO.CD_COMBUSTIVEL%TYPE,
                               O_MENSAGEM        OUT VARCHAR2) IS
   E_GERAL EXCEPTION;
   V_COUNT NUMBER;
 BEGIN
   BEGIN
     SELECT COUNT(*)
       INTO V_COUNT
       FROM VEICULOCURSO
      WHERE VEICULOCURSO.CD_COMBUSTIVEL = I_CD_COMBUSTIVEL;
   EXCEPTION
     WHEN OTHERS THEN
       V_COUNT := 0;
   END;  
   
   IF V_COUNT > 0 THEN
     O_MENSAGEM := 'O combust�vel nao pode ser exclu�do, pois existem ve�culos 
     associados a ele';
     RAISE E_GERAL;
   END IF;
   
   BEGIN
     DELETE COMBUSTIVELCURSO
      WHERE CD_COMBUSTIVEL = I_CD_COMBUSTIVEL;
   EXCEPTION
     WHEN OTHERS THEN
       O_MENSAGEM := 'Erro ao exclu�r o combust�vel ' || I_CD_COMBUSTIVEL || ': ' || SQLERRM;
       RAISE E_GERAL;
   END;
   
 EXCEPTION
   WHEN E_GERAL THEN
     ROLLBACK;
     O_MENSAGEM := '[EXCLUI_COMBUSTIVEL] ' || O_MENSAGEM;  
     
   WHEN OTHERS THEN
     ROLLBACK;
     O_MENSAGEM := '[EXCLUI_COMBUSTIVEL] Erro no procedimento de exclusao do combust�vel: ' || SQLERRM;
 END;                                                                                                          
end PACK_POSTO;
/
