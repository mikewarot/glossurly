program bootstrap;
var
  buffer : AnsiString; // up to 2 gigabytes long!
  cursor,l : Int64;  // left and right ends of the currently selected range

  Function ReadFile(FileName : String):AnsiString;
  var
    Buffer : AnsiString;
    Src : File;
    Size,NumRead : Int64;
  begin
    Buffer := '';
    Assign(Src,FileName);
    Reset(Src,1);
    size := FileSize(Src);
    // WriteLn(Filename,' is ',size,' bytes long');
    SetLength(Buffer,Size);
    Blockread(src,Buffer[1],size,NumRead);
    close(src);
    SetLength(Buffer,NumRead);
    ReadFile := Buffer;
  end;


begin
  Buffer := 'Hello, World!';
  //  Buffer := ReadFile('messages_1.json');
  Buffer := ReadFile('220603 starting 200416 exported Mike''s Chat-notabs.txt');
  Cursor := 0;  L := 0;  // start before the first character
  WriteLn('Buffer is ',Length(Buffer),' bytes long');
  //  WriteLn(Buffer);
End.
