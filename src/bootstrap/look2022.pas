program Look2022;
uses
  crt,keys,strings;
const
  MaxLine = 16000;
  Safety  = $1000;

  Procedure Usage;
  begin
    WriteLn('Look2022 - Look at a file. -- Version 0.1');
    WriteLn('Copyright(C) 2022 - Mike Warot');
    WriteLn;
    WriteLn('Usage: Look2022 filename');
    Halt(1);
  end;

var
  Height : Integer;
  Current,
  LineC  : Integer;
  Done   : Boolean;
  Ascii, Extend : Char;
  Filename : String;
  Xpos,Ypos,SrcPos : Integer;
  i,j : integer;

begin
  If ParamCount <> 1 then Usage;
  Filename := ParamStr(1);

  LineC := 1000;  // just make a bottom, for now

  // ClrScr;
  Current := 1;
  Xpos := 0;
  Done := False;
  Height := (WindMaxY - WindMinY)+1;
  WriteLn('WindMinX,WindMinY = ',WindMinX,',',WindMinY);
  WriteLn('WindMaxX,WindMaxY = ',WindMaxX,',',WindMaxY);
  ReadLn;


  Repeat
    GotoXY(1,1); TextAttr := $71;
    Write('LOOK2022 ',Current:5, '+',Xpos:3,'   ',LineC:5);

    TextAttr := $17;
    For i := 0 to Height-3 do
    begin
      GotoXY(1,i+2);
      j := i + current;
      If j < LineC then
        Write('filler')
      else
        Write('      ');
    end;
    GotoXY(1,Height); TextAttr := $71;
    Write('^v - Scroll  - PgUp,PgDn - Scroll Page   Home,End - Top/End file       X - Exit');
    GetKey(Ascii,Extend);
    Case Ascii of
      'x','X',ESC : Done := True;
    End;
    Case Extend of
      Home : Current := 1;
      EEnd : If LineC > (Height-2) then Current := LineC-(Height-3)
                                   else Current := 1;
      PgUp : If Current > (Height-2) then Dec(Current,(Height-2))
                                     else Current := 1;
      PgDn : If Current + (Height-2) < LineC then
               Inc(Current,(Height-2))
             else
               Current := LineC;
      Up    : If Current > 1 then Dec(Current);
      Down  : If Current < LineC then Inc(Current);
      Right : If Xpos < 250 then inc(Xpos);
      Left  : If Xpos > 0 then Dec(Xpos);
      F10,
      Alt_X : Done := True;
    end;
  Until Done;
End.
