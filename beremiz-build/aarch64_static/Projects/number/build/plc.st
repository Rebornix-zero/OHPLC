PROGRAM program0
  VAR
    LocalVar0 AT %QW0.0.0.0 : UINT;
  END_VAR
  VAR
    LocalVar1 : UINT := 0;
    _TMP_ADD4_OUT : UINT;
  END_VAR

  _TMP_ADD4_OUT := ADD(LocalVar1, 1);
  LocalVar1 := _TMP_ADD4_OUT;
  LocalVar0 := LocalVar1;
END_PROGRAM


CONFIGURATION config

  RESOURCE resource1 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
