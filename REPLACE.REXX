/* REXX  REPLACE*/
/*----------------------------------------------*/
START:
RETURN REPLACE(ARG(1),ARG(2),ARG(3));
EXIT;
REPLACE: PROCEDURE
PARSE ARG INP_STR, OLD_STR, NEW_STR;
OUT_STR = '';
L0      = LENGTH(OLD_STR);
IX      = INDEX(INP_STR,OLD_STR);
DO WHILE(IX > 0)
   OUT_STR  = OUT_STR || SUBSTR(INP_STR,1,IX - 1) || NEW_STR
   INP_STR  = SUBSTR(INP_STR,IX + L0,LENGTH(INP_STR) - IX - L0 + 1)
   IX       = INDEX(INP_STR,OLD_STR)
END
OUT_STR = OUT_STR || INP_STR;
RETURN OUT_STR;
EXIT;
