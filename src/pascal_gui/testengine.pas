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
  TestSection : String;

procedure RunTests(TestSuite : String);

procedure RunTest(Test : String);

implementation
uses
  DateUtils,MyStrings,Operations;

procedure RunTest(Test : String);
var
  command : string;
  StringParam : String;
  OffsetParam,
  LengthParam : Integer;
begin
  SkipSpace(Test);  If Test = '' then Exit;
  If Test[1] = '-' then
  begin
    Delete(Test,1,1);
    SkipSpace(Test);
    TestSection := Test;
    Exit;
  end;
  If Test[1] = '#' then Exit;  // comment

  command := grabName(Test);
  case Command of
    'INIT'   : Operations.Init;
    'CLEAR'  : Operations.Clear;
    'EXPECT' : begin
                 Expect(Test,'(');
                 StringParam := GrabQuotedString(Test);
                 If Operations.Buffer <> StringParam then
                 begin
                   Inc(FailCount);
                   LogFunction('Error - Expected ['+StringParam+'] = Instead got ['+Operations.Buffer+']');
                 end
                 else
                   Inc(PassCount);
               end;
    'DELETE' : begin
                 Expect(Test,'(');
                 OffsetParam := GrabNumber(Test);
                 Expect(Test,',');
                 LengthParam := GrabNumber(Test);
                 CommandDelete(OffsetParam,LengthParam);
               end;
    'INSERT' : begin
                 Expect(Test,'(');
                 OffsetParam := GrabNumber(Test);
                 Expect(Test,',');
                 StringParam := GrabQuotedString(Test);
                 CommandInsert(OffsetParam,StringParam);
               end
  else
    begin
      inc(FailCount);
      LogFunction(TestSection + ': Unknown Command - '+Command+' '+Test);
    end;
  end; // case
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
  TestSection := 'Unlabeled Section';
end.

