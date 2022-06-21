program win32test;

uses windows;

var
  stdout : long;
  msg : AnsiString;
  aux : ulong;
  Info : TConsoleScreenBufferInfo;

begin
  stdout := GetStdHandle (STD_OUTPUT_HANDLE);
  msg := 'Win32 Console API';
  WriteConsole (stdout, PChar (msg), length (msg), aux, nil);
  If GetConsoleScreenBufferInfo(stdout,Info) then
  begin
    WriteLn('Screen Window (',Info.srWindow.Left,',',Info.srWindow.Top,')  (',Info.srWindow.Right,',',Info.srWindow.Bottom,')');
  end;
  readln;
end.
