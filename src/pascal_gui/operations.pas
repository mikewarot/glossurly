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

begin
  ErrorName := '';
  Buffer := '';
end.

