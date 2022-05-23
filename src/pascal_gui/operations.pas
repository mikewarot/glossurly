unit Operations;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

var
  ErrorName : String;
  Buffer    : String;

Procedure Init;
Procedure Clear;
Procedure CommandInsert(Position : Integer;   S : String);
Procedure CommandDelete(Position,L : Integer);
Procedure CommandImport(FileName : String);

implementation


Procedure Init;
Begin
  ErrorName := '';
  Buffer := '';
end;

Procedure Clear;
begin
  ErrorName := '';
  Buffer := '';
end;

Procedure CommandInsert(Position : Integer;   S : String);
Begin
  If (Position < 0) or (Position > (Length(Buffer)+1)) then
    ErrorName := 'Range Error'
  else
    Insert(S,Buffer,Position+1);
End;

Procedure CommandDelete(Position,L : Integer);
Begin
  If (Position < 0) or (Position > (Length(Buffer)+1)) OR (Position+L > Length(Buffer)) then
    ErrorName := 'Range Error'
  else
    Delete(Buffer,Position+1,L);
End;

Procedure CommandImport(FileName : String);
Var
  f : textfile;
Begin
  AssignFile(F,FileName);
  try
    reset(f);
    read(f,buffer);
    close(f);
    ErrorName := '';
  except
    on e:Exception do
      ErrorName := E.Message;
  end;
End;

begin
  ErrorName := '';
  Buffer := '';
end.

