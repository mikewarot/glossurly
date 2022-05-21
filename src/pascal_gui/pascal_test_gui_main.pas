unit pascal_test_gui_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    Memo2: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    OpenDialog1: TOpenDialog;
    Separator1: TMenuItem;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
uses
  DateUtils,TestEngine;

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  If OpenDialog1.Execute then
  begin
    statusbar1.Panels[0].Text:= 'File: '+OpenDialog1.FileName;
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
end;

procedure LogMessage(S : String);
begin
  Form1.Memo2.Append(S);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TestEngine.LogFunction := @LogMessage;

  TestEngine.RunTests(Memo1.ToString);

  StatusBar1.Panels[1].Text := 'Pass: ' + PassCount.ToString;
  StatusBar1.Panels[2].Text := 'Fail: ' + FailCount.ToString;
  StatusBar1.Panels[3].Text:=
    'Run Time - ' + MilliSecondsBetween(TestEnd,TestStart).ToString+' mSec';
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  StatusBar1.Panels[3].Width:= 200;
  StatusBar1.Panels[2].Width:= 100;
  StatusBar1.Panels[1].Width:= 100;
  StatusBar1.Panels[0].Width:= StatusBar1.ClientWidth-400;
end;

end.

