program look;
uses
  crt,keys,strings;
Const
  MaxLine = 16000;

  Procedure Usage;
  begin
    WriteLn('LOOK2 - Look at a file.  -- Version 1.0');
    WriteLn('Copyright(C) 1992,2022 Michael Warot, all rights reserved');
    WriteLn;
    WriteLn('usage: LOOK2 filename');
    Halt(1);
  end;

var
  Height   : DWord;
  Width    : Dword;
  Lines    : Array[1..MaxLine] of ^String;
  LineC    : DWord;
  Buffer   : string;
  Source   : Text;
  i,j,
  Current  : DWord;
  Done     : Boolean;
  Ascii,
  Extend   : Char;
  FileName : String;
  Xpos     : DWord;
  Header   : String;

begin
  If ParamCount <> 1 then Usage;
  Assign(Source,ParamStr(1));
  {$I-} Reset(Source); {$I+}
  If IOresult <> 0 then
  begin
    WriteLn('file not found: ',ParamStr(1));
    Halt(1);
  end;

  FileName := Clean(ParamStr(1));

  FillChar(lines,sizeof(lines),#0); { Lines is now all nil }
  LineC := 0;
  While Not Eof(Source) and (LineC < MaxLine) do
  begin
    ReadLn(Source,Buffer);
(*
    If Buffer[0] > #80 then Buffer[0] := #80; { Truncate long lines }
*)
    Inc(LineC);
    GetMem(Lines[LineC],Length(Buffer)+1);
    Lines[LineC]^ := Buffer;
  end;

  //  Window(1,1,80,25);
  ClrScr;
  Current := 1;
  Xpos    := 0;
  Done    := False;
  Height := (WindMaxY - WindMinY)+1;
  Width   := WindMaxX; { number of columns }

  WriteLn('Window Corners : (',WindMinX,',',WindMinY,')  (',WindMaxX,',',WindMaxY,')');
  WriteLn('Width = ',Width);
  WriteLn('Height = ',Height);
  Readln;
  Repeat
    Header := 'LOOK ' + NiceNumber(Current)+'+'+NiceNumber(XPos)+'   '+NiceNumber(LineC)+' File:'+FileName;
    Header := Trim(Header,Width);

    GotoXY(1,1); TextAttr := $71;
    Write(Header);

    TextAttr := $17;
    For i := 0 to Height-3 do
    begin
      GotoXY(1,i+2);
      J := i + current;
      If j <= LineC then
        Write(Trim(Copy(Lines[j]^,1+Xpos,Xpos+1+Width),Width))
      else
        Write(Trim('',Width));
    end;
    GotoXY(1,Height); TextAttr := $71;
    Write(Trim(' ^v - Scroll   PgUp,PgDn - Scoll Page   Home,End - Top/End file       X - Exit ',Width-1));
	GotoXY(1,Height);

    Repeat
      GetKey(Ascii,Extend);
      Case Ascii of
        'x','X',ESC  : Done := True;
      End;
      Case Extend of
        Home  : Current := 1;
        EEnd  : If LineC > (Height-2) then Current := LineC-(height-3)
                              else Current := 1;
        PgUp  : If Current > (Height-2) then Dec(Current,(height-2))
                                else Current := 1;
        PgDn  : If Current + (Height-2) < LineC then
                  Inc(Current,(Height-2))
                else
                  Current := LineC;
        Up    : If Current > 1  then Dec(Current);
        Down  : If Current < LineC then Inc(Current);
        Right : If Xpos < 250 then Inc(Xpos);
        Left  : If Xpos > 0   then Dec(Xpos);
        F10,
        Alt_X : Done := True;
      End;
    Until Done OR (Not Keypressed);
  Until Done;

  Close(Source);
end.
