PROGRAM program0
  VAR
    isensor AT %IX100.0.0.0 : BOOL;
    oconvey AT %QX100.0.1.0 : BOOL;
    isenor1 AT %IX100.0.2.1 : BOOL;
    oconvey1 AT %QX100.0.3.1 : BOOL;
  END_VAR

  oconvey := isensor;
  oconvey1 := isenor1;
END_PROGRAM


CONFIGURATION config

  RESOURCE resource1 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
