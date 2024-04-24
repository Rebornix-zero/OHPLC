void PROGRAM0_init__(PROGRAM0 *data__, BOOL retain) {
  __INIT_LOCATED(UINT,__QW0_0_0_0,data__->LOCALVAR0,retain)
  __INIT_LOCATED_VALUE(data__->LOCALVAR0,0)
  __INIT_VAR(data__->LOCALVAR1,0,retain)
  __INIT_VAR(data__->_TMP_ADD4_OUT,0,retain)
}

// Code part
void PROGRAM0_body__(PROGRAM0 *data__) {
  // Initialise TEMP variables

  __SET_VAR(data__->,_TMP_ADD4_OUT,,ADD__UINT__UINT(
    (BOOL)__BOOL_LITERAL(TRUE),
    NULL,
    (UINT)2,
    (UINT)__GET_VAR(data__->LOCALVAR1,),
    (UINT)1));
  __SET_VAR(data__->,LOCALVAR1,,__GET_VAR(data__->_TMP_ADD4_OUT,));
  __SET_LOCATED(data__->,LOCALVAR0,,__GET_VAR(data__->LOCALVAR1,));

  goto __end;

__end:
  return;
} // PROGRAM0_body__() 





