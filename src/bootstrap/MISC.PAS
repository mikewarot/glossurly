Unit Misc;
{
  Author   : Michael Warot
  Date     : January, 1988
  Purpose  : Put together all of those misc. functions and procedures

  07-11-88 MAW Add routine [WaitForKey] to wait for ANY keypress
  06-06-89 MAW Move TrapInt for compatability with TP5.5
  08-01-89 MAW Move excess code out into KEYS and STRINGS
}
Interface
  Uses Strings;
  
  Procedure Abend(Status  : Byte;
                  Message : String);

  Function Min(A,B : Longint):Longint;

  Function Max(A,B : Longint):Longint;

  Function Ptr_Diff(Var A,B): Longint;

  Function Value(S : String):Longint;

  Function InRange(A,B,C : Longint):Boolean;
  { Return true if A >= B and A <= C }

Implementation
(**************************************
  This part hidden from application
 **************************************)



Procedure Abend(Status  : Byte;
                Message : String);
Begin
{ WriteLn(#12); }
  WriteLn('%ERR-F-',Message);
  WriteLn;
  Halt(Status);
End;

  Function Min(A,B : Longint):Longint;
  Begin
    If A > B then Min := B
             else Min := A;
  End;

  Function Max(A,B : Longint):Longint;
  Begin
    If A > B then Max := A
             else Max := B;
  End;

  Function Ptr_Diff(Var A,B): Longint;
  Begin
    Ptr_Diff := (Seg(B)-Seg(A)) SHL 4 +
                (Ofs(B)-Ofs(A));
  End;

  Function Value(S : String): Longint;
  Var
    Tmp : Longint;
    Err : Integer;
  Begin
    S := Clean(S);
    Val(S,Tmp,Err);
    If Err <> 0 then
      Tmp := 0;
    Value := Tmp;
  End;

  Function InRange(A,B,C : Longint):Boolean;
  Begin
    InRange := (A >= B) AND (A <= C);
  End; { InRange }

Begin
End. { Unit Misc }
