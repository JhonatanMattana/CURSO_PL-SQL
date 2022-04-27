create or replace package PACK_POSTO is

  -- Author  : JHONATAN.MATTANA
  -- Created : 27/04/2022 16:43:03
  -- Purpose : 
  PROCEDURE GRAVA_COMBUSTIVEL(IO_CD_COMBUSTIVEL IN OUT COMBUSTIVELCURSO.CD_COMBUSTIVEL%TYPE,
                              I_DS_COMBUSTIVEL IN COMBUSTIVELCURSO.DS_COMBUSTIVEL%TYPE,
                              I_VL_COMBUSTIVEL IN COMBUSTIVELCURSO.VL_COMBUSTIVEL%TYPE,
                              O_MENSAGEM       OUT VARCHAR2);
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
      O_MENSAGEM := 'A descrição do combustível precisa ser informada.';
      RAISE E_GERAL;
    END IF;
    
    IF I_VL_COMBUSTIVEL IS NULL THEN
      O_MENSAGEM := 'O valor do combustível precisa ser informado.';
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
            O_MENSAGEM := 'Erro inesperado ao atualizar o bombustível (' || IO_CD_COMBUSTIVEL || ')
                          :' || SQLERRM;
            RAISE E_GERAL;
        END;
     WHEN OTHERS THEN
       O_MENSAGEM := 'Erro ao inserir o combustível (' || IO_CD_COMBUSTIVEL || '): ' || SQLERRM;
       RAISE E_GERAL; 
   END;
    
   COMMIT;
   
  EXCEPTION
    WHEN E_GERAL THEN
      ROLLBACK;
      O_MENSAGEM := '[GRAVA_COMBUSTIVEL] ' || O_MENSAGEM;
    WHEN OTHERS THEN
      ROLLBACK;
      O_MENSAGEM := '[GRAVA_COMBUSTIVEL] Erro no procedimento que grava combustível: '
                     || SQLERRM;
  END; 
end PACK_POSTO;
/
