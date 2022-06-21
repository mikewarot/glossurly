Unit STRINGS;
{
  Author   : Michael Warot
  Date     : January, 1988
  Purpose  : Put together all of those misc. functions and procedures

  07-11-88 MAW Add routine [WaitForKey] to wait for ANY keypress
  06-06-89 MAW Move TrapInt for compatability with TP5.5
  08-01-89 MAW Split up MISC
  11-03-89 MAW Add SKIP and GRAB for string parsing
               Add GrabWord to pull a number from a string
  11-13-91 MAW Remove Uses CRT,Dos; ***NOT NEEDED!***
  02-11-92 MAW Fix bug in Macro_Substitute
}
Interface
Type
  CharSet    = Set of Char;
Var
  Fill_Char  : Char;

{  Trim off a string to N columns wide }
Function Trim(S : String; N : Byte):String;

{ Convert a string to upper case }
Function ToUpper(a : String):String;

{ Return a string for a number with leading zeros }
Function Numb(I : LongInt;
              L : Byte): String;

Function RightJustify(S:String; L:Byte):String;

Function Clean(a : string):String;

Function CleanRight(a : string):String;

Function Center(a : string;
                b : byte): String;

  Function HexByte(X:Byte   ):String;   { Yep, print hex results  2 digits }
  Function HexWord(X:Word   ):String;   { 4 digits }
  Function HexLong(X:Longint):String;   { 8 digits }

  Function IsAlpha(C : Char):Boolean;   { True if A in a..z or A..Z }

  Function StringOf(A : String;
                    B : Byte   ): String;

  { Search data for a non-case sensitive match of pattern }
  Function Pattern_Match(Pattern,Data : String):Boolean;

  { True if Pattern is non-alpha or match }
  Function List_Match(Pattern, Data : Char):Boolean;

  Function Number_Match(Pattern, Data : Longint): Boolean;

  Function Macro_Substitute(Find,Sub, Data : String):String;

  { Skip (delete) characters at start of S if they are in Pattern
    i.e. Skip(foo,[Tab,' ']) will skip spaces
  }
  Procedure Skip(Var S   : String;
                 Pattern : CharSet);

  { Grab (and delete) characters at start of S if they are in Pattern
    i.e. Grab(foo,['0'..'9'] will grab a number from a string
  }
  Function  Grab(Var S   : String;
                 Pattern : CharSet):String;

  { Grab a WORD (unsigned int) from a string }
  Function  GrabWord(Var S : String;
                     Var L : Word):  Boolean;

  { Skip Spaces, always true, for inclusion in If..Then logic }
  Function SkipSpace(Var S : String): Boolean;

  { Get a Quoted or Non-Quoted string, with space skipping }
  Function PullString(Var S : String): String;

  { Get a Quoted or Non-Quoted number, with space skipping }
  Function PullNumber(Var S : String):Word;

  { Get a Quoted or Non-Quoted long integer, with space skipping }
  Function PullLongint(Var S : String):Longint;

  { Expand %NAME% environment variable names }
  function EnvMacro(A : String):String;

  { Return the first L characters of S, deleting them from the string }
  Function RipString(Var S : String;
                         L : Byte):String;

  { Take the first L characters of S as a longint, deleting them as we go }
  Function RipNumber(Var S : String;
                         L : Byte):Longint;

  Function NiceNumber(N : Longint): String;
Implementation
(**************************************
  This part hidden from application
 **************************************)
 
uses
  SysUtils;
Function Trim(S : String; N : Byte):String;
Begin
  If Length(S) > N then SetLength(S,N);
  While Length(S) < N do S := S + ' ';
  Trim := S;
End;

{ Convert a string to upper case }
Function ToUpper(a : String):String;
var
  s : string;
  c : char;
Begin
  s := '';
  for C in a do
    s := s + UpCase(C);
  ToUpper := s;
End;


Function Numb(I : LongInt;
              L : Byte): String;
Var
  Tmp : String;
Begin
  Str(Abs(I),Tmp);
  While Length(Tmp) < L do
    Tmp := '0' + Tmp;
  If I < 0 then
    Tmp[1] := '-';
  Numb := Tmp;
End; { Function Numb }

Function RightJustify(S:String; L:Byte):String;
Begin
  If Length(S) > L then
    SetLength(S,L)
  else
    While Length(S) < L do
      Insert(' ',S,1);
  RightJustify := S;
End;

Function Clean(a : string):String;
var
  i : byte;
begin
  for i := 1 to length(a) do
    if a[i]=#0 then a[i] := ' ';
    if a[i]=#9 then a[i] := ' ';
  While (Length(a) > 0) and (a[1] = ' ') do
    delete(a,1,1);
  While (Length(a) > 0) and (a[length(a)] = ' ') do
    delete(a,length(a),1);
  Clean := a;
end; { clean }

Function CleanRight(a : string):String;
begin
  While (Length(a) > 0) and (a[length(a)] = ' ') do
    delete(a,length(a),1);
  CleanRight := a;
end; { CleanRight }

Function Center(a : string;
                b : byte): String;
Begin
  a := clean(a);
  if length(a) < b then
    a := trim('',(b-length(a)) div 2) + a;
  Center := a;
End; { Center }


  Function HexByte(X:Byte):String;
    Const
      HexStr : Array[0..15] of Char = '0123456789ABCDEF';
  Begin
    HexByte := HexStr[X shr 4] + HexStr[X and $0f];
  End;

  Function HexWord(X:Word):String;
  Begin
    HexWord := HexByte(Hi(X)) + HexByte(Lo(X));
  End;

  Function HexLong(X:Longint):String;
  Begin
    HexLong := HexWord(X shr 16) + HexWord(X and $ffff);
  End;

Function IsAlpha(C : Char):Boolean;
Begin
  IsAlpha := ((C >= 'A') AND (C <= 'Z')) OR
             ((C >= 'a') AND (C <= 'z'));
End;

  Function StringOf(A : String;
                    B : Byte   ): String;
  Var
    Tmp : String;
  Begin
    If A = '' then
      A := ' ';
    Tmp := A;
    While Length(Tmp) < B do
      Tmp := Tmp + A;
    If Length(Tmp) > B then
      SetLength(Tmp,B);
    StringOf := Tmp;
  End;

  Function Pattern_Match(Pattern,Data : String):Boolean;
  Begin
    Pattern  := Clean(ToUpper(Pattern));
    Data     := ToUpper(Data);
    Pattern_Match := (Length(Pattern)   =  0)   OR
                     (Pos(Pattern,Data) <> 0);
  End; { Pattern_Match }

  Function List_Match(Pattern, Data : Char):Boolean;
  Begin
    Pattern := UpCase(Pattern);
    Data    := UpCase(Data);
    List_Match := Not IsAlpha(Pattern) OR
                  (Pattern = Data);
  End; { List_Match }

  Function Number_Match(Pattern, Data : Longint): Boolean;
  Begin
    Number_Match := (Pattern = 0) OR
                    (Pattern = Data);
  End; { Number_Match }

(***** OLD COPY ****

  Function Macro_Substitute(Find,Sub, Data : String):String;
  Var
    i,j : byte;
    x   : string;
  begin
    x := '';
    j := length(Find);
    if j <> 0 then
    begin
      for i := 1 to length(data) do
      begin
        if copy(data,1,j) = find then
        begin
          x := x + sub;
          delete(data,1,j);
        end
        else
        begin
          x := x + copy(data,1,1);
          delete(data,1,1);
        end;
      end;
    end
    else
      X := Data;
    Macro_Substitute := X;
  end;

**** END OLD COPY *****)

  Function Macro_Substitute(Find,Sub, Data : String):String;
  Var
    i,j,k : byte;
    x     : string;
  begin
    x := '';
    j := length(Find);
    k := length(Data);
    if j <> 0 then
    begin
      i := 1;
      while i <= length(data) do
      begin
        if (data[i] = find[1]) AND (copy(data,i,j) = find) then
        begin
          x := x + sub;
          inc(i,j);
        end
        else
        begin
          x := x + data[i];
          inc(i);
        end;
      end;
    end
    else
      X := Data;
    Macro_Substitute := X;
  end;

  { Skip (delete) characters at start of S if they are in Pattern
    i.e. Skip(foo,[Tab,' ']) will skip spaces
  }
  Procedure Skip(Var S   : String;
                 Pattern : CharSet);
  Begin
    While (Length(S) > 0) and
      (S[1] in Pattern) do
        Delete(S,1,1);
  End;

  { Grab (and delete) characters at start of S if they are in Pattern
    i.e. Grab(foo,['0'..'9'] will grab a number from a string
  }
  Function  Grab(Var S   : String;
                 Pattern : CharSet):String;
  Var
    Tmp : String;
  Begin
    Tmp := '';
    While (Length(S) > 0) AND (S[1] in Pattern) do
    begin
      Tmp := Tmp + S[1];
      Delete(S,1,1);
    end;
    Grab := Tmp;
  End;

  { Grab a WORD (unsigned int) from a string }
  Function  GrabWord(Var S : String;
                     Var L : Word):  Boolean;
  Var
    Tmp : String;
    Err : Integer;
  Begin
    Tmp := Grab(S,['0'..'9']);         { Get String }
    Val(Tmp,L,Err);                    { Try conversion }
    GrabWord := Err=0;                 { Return Status }
  End;

  { Skip Spaces, always true, for inclusion in If..Then logic }
  Function SkipSpace(Var S : String): Boolean;
  Begin
    Skip(S,[' ',#9]);
    SkipSpace := True;
  End;

  Function PullString(Var S : String): String;
  Var
    Tmp   : String;
    Quote : String[1];
  Begin
    Tmp := '';
    If SkipSpace(S) then;
    If Length(S) <> 0 then
    begin
      If (S[1] in [#34,#39]) then     { Quote chars }
      begin
        Quote := S[1];
        delete(s,1,1);
      end
      else
        Quote := ' ';

      While (Length(S) <> 0) AND (S[1] <> Quote) do
      begin
        Tmp := Tmp + Copy(S,1,1);
        Delete(S,1,1);
      end;

      Delete(S,1,1);

      If SkipSpace(S) then;
    end;
    PullString := Tmp;
  End;

  Function PullNumber(Var S : String):Word;
  Var
    W : Word;
    E : Integer;
  Begin
    Val(PullString(S),W,E);
    If E <> 0 then
      W := 0;
    PullNumber := W;
  End;

  Function PullLongint(Var S : String):Longint;
  Var
    L : Longint;
    E : Integer;
  Begin
    Val(PullString(S),L,E);
    If E <> 0 then
      L := 0;
    PullLongint := L;
  End;

  function EnvMacro(A : String):String;
  var
    b   : string;
    i,j : byte;
  begin
    j := 0;
    b := '';
    for i := 1 to length(a) do
    begin
      if a[i] = '%' then
      begin
        if j = 0 then
          j := succ(i)
        else
        begin
          B := B + GetEnvironmentVariable(copy(a,j,i-j));
          j := 0;
        end;
      end
      else
        if j = 0 then
          B := B + a[i];
    end;
    EnvMacro := B;
  end;

  { Return the first L characters of S, deleting them from the string }
  Function RipString(Var S : String;
                         L : Byte):String;
  Begin
    RipString := Copy(S,1,L);
    Delete(S,1,L);
  End;

  { Take the first L characters of S as a longint, deleting them as we go }
  Function RipNumber(Var S : String;
                         L : Byte):Longint;
  Var
    X : Longint;
    Err : Integer;
    A : String;
  Begin
    A := Clean(Copy(S,1,L));
    Delete(S,1,L);
    Val(A,X,Err);
    If Err = 0 then RipNumber := X
               else RipNumber := -1;
  End;

  Function NiceNumber(N : Longint): String;
  Var
    S : String;
    J : Byte;
  Begin
    Str(N,S);
    J := Length(S);
    While J > 3 do
    begin
      Dec(J,3);
      Insert(',',S,J+1);
    end;
    NiceNumber := S;
  End;


Begin
  Fill_Char := ' ';  { Default to spaces for fills }
End. { Unit STRINGS }
