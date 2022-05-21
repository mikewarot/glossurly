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

implementation
uses
  DateUtils;

procedure RunTests(TestSuite : String);
begin
  TestStart := Now;
  TestEnd   := TestStart;
  LogFunction('--- Starting Test ---');

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

