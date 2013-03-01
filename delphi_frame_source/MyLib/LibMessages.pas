unit LibMessages;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> LibMessages
   <What> ����MyLib�õ����Զ���Windows��Ϣ����
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses Messages;

{ my Library Messages }

const
  LM_Base = WM_User + 1000;
  LM_END  = LM_BASE + $200;

  LM_TrayNotify = LM_BASE + 1;

  // used By AppearUtils.TAppearances
  // Wparam is index of items
  LM_AppearChanged = LM_BASE + 2;

  // used by TCompCommonAttrs
  // to indecate its properties changed
  // WParam is TCompCommonProps
  LM_ComAttrsChanged = LM_BASE + 3;
  // used by TCompCommonAttrs
  // to notify its clients
  // WParam is TCompCommonProps
  // LParem is NotifyCode.
  LM_ComAttrsNotify = LM_BASE + 4;

  LM_AnotherAppInstanceStart = LM_BASE + 5;

  {
  �������Դ�������ļ�

  WorkViews.pas
  LM_WorkViewNotify = LM_BASE + 10

  CoolCtrls.pas
  LM_ButtonDown = LM_BASE + 50;

  
  }

implementation

end.
