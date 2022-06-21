Unit Keys;
{
  Author   : Michael Warot
  Date     : January, 1988
  Purpose  : Put together all of those misc. functions and procedures

  07-11-88 MAW Add routine [WaitForKey] to wait for ANY keypress
  06-06-89 MAW Move TrapInt for compatability with TP5.5
  08-01-89 MAW Split MISC ===> KEYS and STRINGS
}
Interface
Uses
  Crt,Misc;

{ Usefull keyboard constants }
Const
  F1  = #59;  Home = #71;  Shft_F1  = #84;  Ctrl_F1  = #94;   Alt_F1  = #104;
  F2  = #60;  Up   = #72;  Shft_F2  = #85;  Ctrl_F2  = #95;   Alt_F2  = #105;
  F3  = #61;  PgUp = #73;  Shft_F3  = #86;  Ctrl_F3  = #96;   Alt_F3  = #106;
  F4  = #62;  Left = #75;  Shft_F4  = #87;  Ctrl_F4  = #97;   Alt_F4  = #107;
  F5  = #63;  Right= #77;  Shft_F5  = #88;  Ctrl_F5  = #98;   Alt_F5  = #108;
  F6  = #64;  EEnd = #79;  Shft_F6  = #89;  Ctrl_F6  = #99;   Alt_F6  = #109;
  F7  = #65;  Down = #80;  Shft_F7  = #90;  Ctrl_F7  = #100;  Alt_F7  = #110;
  F8  = #66;  PgDn = #81;  Shft_F8  = #91;  Ctrl_F8  = #101;  Alt_F8  = #111;
  F9  = #67;  Ins  = #82;  Shft_F9  = #92;  Ctrl_F9  = #102;  Alt_F9  = #112;
  F10 = #68;  Del  = #83;  Shft_F10 = #93;  Ctrl_F10 = #103;  Alt_F10 = #113;

  Ctrl_Home = #119;        Ctrl_PgUp  = #132;
  Ctrl_Left = #115;        Ctrl_Right = #116;
  Ctrl_End  = #117;        Ctrl_PgDn  = #118;

  BS  = #8;   Tab = #9;   LF  = #10;  FF  = #12;
  CR  = #13;  ESC = #27;  CTRL_DEL = #127;

  Alt_Q = #16;   Alt_A = #30;   Alt_Z = #44;    Alt_1 = #120;
  Alt_W = #17;   Alt_S = #31;   Alt_X = #45;    Alt_2 = #121;
  Alt_E = #18;   Alt_D = #32;   Alt_C = #46;    Alt_3 = #122;
  Alt_R = #19;   Alt_F = #33;   Alt_V = #47;    Alt_4 = #123;
  Alt_T = #20;   Alt_G = #34;   Alt_B = #48;    Alt_5 = #124;
  Alt_Y = #21;   Alt_H = #35;   Alt_N = #49;    Alt_6 = #125;
  Alt_U = #22;   Alt_J = #36;   Alt_M = #50;    Alt_7 = #126;
  Alt_I = #23;   Alt_K = #37;                   Alt_8 = #127;
  Alt_O = #24;   Alt_L = #38;                   Alt_9 = #128;
  Alt_P = #25;                                  Alt_0 = #129;

  BackTab = #15;

  Ctrl_Enter = #10;

{  Get an Ascii code (A) or a scan code (B) from the keyboard }
Procedure GetKey(Var A,B : Char);

{ Get a yes/no answer }
Function YesNo:Boolean;

Procedure WaitForKey;
{ Waits for ANY key to come in on the keyboard... }

Implementation
(**************************************
  This part hidden from application
 **************************************)

Procedure GetKey(Var A,B : Char);
Begin
  A := ReadKey;
  If (A = #0) and KeyPressed then B := ReadKey else B := #0;
End; { GetKey }

Function YesNo:Boolean;
Var
  c,d : char;
Begin
  GetKey(c,d);
  C := UpCase(c);
  While NOT (C in [ESC,'Y','N']) do
  begin
    GetKey(c,d);
    C := UpCase(c);
  end;
  YesNo := C = 'Y';
End; { YesNo }

Procedure WaitForKey;
Var
  C          : Char;
Begin
  Repeat
    C := ReadKey;
  Until Not Keypressed;
End; { WaitForKey }

Begin
End. { Unit KEYS }
