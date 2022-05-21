unit TestEngine;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;
type
  tLogger = Procedure(LogMessage : String);
var
  TestStart,TestEnd: tDateTime;
  PassCount,FailCount : Integer;
  LogFunction : tLogger;

procedure RunTests(TestSuite : String);

procedure RunTest(Test : String);

implementation
uses
  DateUtils,MyStrings;

procedure RunTest(Test : String);
begin
  LogFunction('Test<<<'+Test+'>>>');
end;

procedure RunTests(TestSuite : String);
begin
  TestStart := Now;
  TestEnd   := TestStart;
  LogFunction('--- Starting Test ---');

  While TestSuite <> '' do
  begin
    RunTest(GrabLine(TestSuite));
  end;

  LogFunction('--- End Test ---');
  TestEnd := Now;
  LogFunction(PassCount.ToString + ' Tests Passed');
  LogFunction(FailCount.ToString + ' Tests Failed');
  LogFunction('Run Time - ' + MilliSecondsBetween(TestEnd,TestStart).ToString+' mSec');
end;

procedure NoLog(S: String);
begin
end;

begin
  LogFunction := @NoLog;
  PassCount := 0;
  FailCount := 0;
  TestStart := Now;
  TestEnd := Now;
end.

