/* REXX  JSON2STEM*/
/*----------------------------------------------------------------------------*/
START:
JSON_STR = ARG(1);
JSON_STM = ARG(2);
EXEC_STR = '';
PARSER_HANDLE = JSON_START();
GLOB_VARS = 'EXEC_STR ' || HWT_CONSTANTS;
RES  = JSON_PARS(PARSER_HANDLE,JSON_STR);
IF   RES <> 0 THEN
     CALL EXIT;
RES  =  JSON_TRAVERS(PARSER_HANDLE,0,'', JSON_STM);
IF   RES <> 0 THEN
     CALL EXIT;
RES  =  JSON_TRMNT(PARSER_HANDLE);
IF   RES <> 0 THEN
     CALL EXIT;
RETURN EXEC_STR;
EXIT;
/*----------------------------------------------------------------------------*/
JSON_START:
CALL JSON_HWTCALLS;
IF   RESULT <> 0 THEN
     DO
     SAY  'JSON_HWTCALLS RESULT: ' || RESULT;
     EXIT FATALERROR( '** Service HWTCALLS failure **' );
     END;
CALL JSON_GETCONST;
IF   RESULT <> 0 THEN
     DO
     SAY  'JSON_GETCONST RESULT: ' || RESULT;
     EXIT FATALERROR( '** Parser GETCONST failure **' );
     END;
PARS_HANDEL = JSON_INIT();
RETURN PARS_HANDEL;
/*----------------------------------------------------------------------------*/
JSON_HWTCALLS:
CALL HWTCALLS 'ON';
R_C = RESULT;
RETURN R_C;
/*----------------------------------------------------------------------------*/
SRVC_WRAPPER:
SRVC_NAME = ARG(1);
SRVC_PARM = ARG(2);
RETURNCODE = -1;
DIAG_AREA. = '';
ADDRESS HWTJSON  SRVC_NAME  ,
                'RETURNCODE',
                 SRVC_PARM  ,
                'DIAG_AREA.';
R_C = RC;
IF  JSON_ISERROR(R_C,RETURNCODE) THEN
    DO
    CALL JSON_SURFACEDIAG SRVC_NAME, R_C, RETURNCODE, DIAG_AREA.
    RETURN FATALERROR( '** ' || SRVC_NAME || '(JSON) failure **' )
    END;
RETURN 0;
/*----------------------------------------------------------------------------*/
JSON_GETCONST:
RES = SRVC_WRAPPER('HWTCONST');
RETURN RES;
/*----------------------------------------------------------------------------*/
JSON_INIT: PROCEDURE EXPOSE (GLOB_VARS)
RES = SRVC_WRAPPER('HWTJINIT','PARS_HANDLE');
IF RES <> 0 THEN
   RETURN RES
ELSE
   RETURN PARS_HANDLE;
/*----------------------------------------------------------------------------*/
JSON_PARS: PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
JSON_TEXTBODY = ARG(2);
RES = SRVC_WRAPPER('HWTJPARS','PARSER_HANDLE JSON_TEXTBODY');
RETURN RES;
/*----------------------------------------------------------------------------*/
JSON_TRAVERS: PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
OBJECT_NAME   = ARG(3);
STEM_STRING   = ARG(4);

IF  OBJECT_NAME <> '' THEN
    STEM_STRING = STEM_STRING || '.#' || OBJECT_NAME;

TYPE = JSON_GETTYPE(PARSER_HANDLE,OBJECT_TOKN);
IF  TYPE = -1 THEN
    RETURN TYPE;
SELECT
  WHEN  TYPE = 'HWTJ_OBJECT_TYPE'  THEN
        RES = JSON_GETOBJ(PARSER_HANDLE,OBJECT_TOKN,OBJECT_NAME,STEM_STRING);
  WHEN  TYPE = 'HWTJ_ARRAY_TYPE'   THEN
        RES = JSON_GETARY(PARSER_HANDLE,OBJECT_TOKN,OBJECT_NAME,STEM_STRING);
  WHEN  TYPE = 'HWTJ_STRING_TYPE'  THEN
        RES = JSON_GETSTR(PARSER_HANDLE,OBJECT_TOKN,OBJECT_NAME,STEM_STRING);
  WHEN  TYPE = 'HWTJ_NUMBER_TYPE'  THEN
        RES = JSON_GETNUM(PARSER_HANDLE,OBJECT_TOKN,OBJECT_NAME,STEM_STRING);
  WHEN  TYPE = 'HWTJ_BOOLEAN_TYPE' THEN
        RES = JSON_GETBOL(PARSER_HANDLE,OBJECT_TOKN,OBJECT_NAME,STEM_STRING);
OTHERWISE SAY 'JSON TYPE UNHANDLED: ' TYPE
        RES = -1
END;
RETURN RES;
/*----------------------------------------------------------------------------*/
JSON_GETTYPE: PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
RES = SRVC_WRAPPER('HWTJGJST','PARSER_HANDLE OBJECT_TOKN OBJECT_TYPE');
IF RES <> 0 THEN
   RETURN RES
ELSE
   RETURN OBJECT_TYPE;
RETURN 0;
/*----------------------------------------------------------------------------*/
JSON_GETOBJ: PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
OBJECT_NAME   = ARG(3);
STEM_STRING   = ARG(4);
COUNT = JSON_GETOBJ_CNT(PARSER_HANDLE,OBJECT_TOKN);
CMD   = STEM_STRING || '.0 = ' || COUNT ||';';
SAY       CMD;
EXEC_STR = EXEC_STR || CMD;

DO I = 0 TO COUNT-1 BY 1
   SRVC_PARM = 'PARSER_HANDLE'    ,
               'OBJECT_TOKN'      ,
               'I'                ,
               'NEXT_OBJECT_NAME' ,
               'NEXT_OBJECT_TOKN' ;
   RES  = SRVC_WRAPPER('HWTJGOEN',SRVC_PARM);
   IF RES <> 0 THEN
      RETURN RES;

   CMD = STEM_STRING || '.' || I+1 || '.NAME= ''' || NEXT_OBJECT_NAME ||''';';
   SAY       CMD;
   EXEC_STR = EXEC_STR || CMD;
   V0 = PARSER_HANDLE;
   V1 = NEXT_OBJECT_TOKN;
   V2 = NEXT_OBJECT_NAME;
   V3 = STEM_STRING;
   RES  = JSON_TRAVERS(V0,V1,V2,V3);
   IF RES <> 0 THEN
      RETURN RES;
END;
RETURN 0;
/*----------------------------------------------------------------------------*/
JSON_GETOBJ_CNT: PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
RES = SRVC_WRAPPER('HWTJGNUE','PARSER_HANDLE OBJECT_TOKN OBJECT_CONT');
IF RES <> 0 THEN
   RETURN RES
ELSE
   RETURN OBJECT_CONT;
/*----------------------------------------------------------------------------*/
JSON_GETARY: PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
OBJECT_NAME   = ARG(3);
STEM_STRING   = ARG(4);

COUNT = JSON_GETOBJ_CNT(PARSER_HANDLE,OBJECT_TOKN);
CMD   = STEM_STRING || '.0 = ' || COUNT ||';';
SAY       CMD;
EXEC_STR = EXEC_STR || CMD;
DO I = 0 TO COUNT-1 BY 1
   SRVC_PARM = 'PARSER_HANDLE' ,
               'OBJECT_TOKN'   ,
               'I'             ,
               'NEXT_ITEM_TOKN';
   RES = SRVC_WRAPPER('HWTJGAEN',SRVC_PARM);
   IF RES <> 0 THEN
      RETURN RES;
   V3 = STEM_STRING || '.' || I+1 ;
   RES = JSON_TRAVERS(PARSER_HANDLE,NEXT_ITEM_TOKN,'',V3);
   IF RES <> 0 THEN
      RETURN RES;
END;
RETURN 0;
/*----------------------------------------------------------------------------*/
JSON_GETSTR:PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
OBJECT_NAME   = ARG(3);
STEM_STRING   = ARG(4);
RES = SRVC_WRAPPER('HWTJGVAL','PARSER_HANDLE OBJECT_TOKN OBJECT_VALU');
IF  RES  = 0 THEN
    DO
    CMD = STEM_STRING || '= ''' || OBJECT_VALU || ''';';
    SAY       CMD;
    EXEC_STR = EXEC_STR || CMD;
    END;
RETURN RES;
/*----------------------------------------------------------------------------*/
JSON_GETNUM:PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
OBJECT_NAME   = ARG(3);
STEM_STRING   = ARG(4);
RES = SRVC_WRAPPER('HWTJGVAL','PARSER_HANDLE OBJECT_TOKN OBJECT_VALU');
IF  RES  = 0 THEN
    DO
    CMD = STEM_STRING || '= ' || OBJECT_VALU ||';';
    SAY       CMD;
    EXEC_STR = EXEC_STR || CMD;
    END;
RETURN RES;
/*----------------------------------------------------------------------------*/
JSON_GETBOL:PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
OBJECT_TOKN   = ARG(2);
OBJECT_NAME   = ARG(3);
STEM_STRING   = ARG(4);
RES = SRVC_WRAPPER('HWTJGBOV','PARSER_HANDLE OBJECT_TOKN OBJECT_VALU');
IF  RES  = 0 THEN
    DO
    CMD = STEM_STRING || '= ' || OBJECT_VALU ||';';
    SAY       CMD;
    EXEC_STR = EXEC_STR || CMD;
    END;
RETURN RES;
/*----------------------------------------------------------------------------*/
JSON_TRMNT: PROCEDURE EXPOSE (GLOB_VARS)
PARSER_HANDLE = ARG(1);
RES = SRVC_WRAPPER('HWTJTERM','PARSER_HANDLE');
RETURN RES;
/*----------------------------------------------------------------------------*/
JSON_ISERROR:
ARG R_C, TOOLKIT_RC;
IF  R_C   <> 0 THEN
    RETURN 1;
TOOLKIT_RC = STRIP(TOOLKIT_RC,'L',0);
IF  TOOLKIT_RC  = '' THEN
    RETURN 0;
IF  TOOLKIT_RC <= HWTJ_WARNING then
    RETURN 0;
RETURN 1;
/*----------------------------------------------------------------------------*/
JSON_SURFACEDIAG: PROCEDURE EXPOSE DIAG_AREA.
  ARG  WHO, R_C, TOOLKIT_RC;
  SAY '*ERROR* (' || WHO || ') at time: ' || TIME();
  SAY 'Rexx RC: ' || R_C || ', Toolkit ReturnCode: ' || TOOLKIT_RC;
  IF R_C == 0 THEN
     DO
     SAY 'DIAG_AREA.REASONCODE: ' || DIAG_AREA.HWTJ_REASONCODE
     SAY 'DIAG_AREA.REASONDESC: ' || DIAG_AREA.HWTJ_REASONDESC
     END;
 RETURN;
/*----------------------------------------------------------------------------*/
FATALERROR:
ARG ERRORMSG;
SAY ERRORMSG;
RETURN -1;
/*----------------------------------------------------------------------------*/
