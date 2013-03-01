unit HdExcpEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,DB, BDE;

type
  TErrorMsgDialog = class(TForm)
    btnOK: TButton;
    btnDetail: TButton;
    mmMsgs: TMemo;
    mmInfo: TMemo;
    procedure btnDetailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FisShowDetails: boolean;
    procedure SetisShowDetails(const Value: boolean);
    class procedure HandleAppError(Sender: TObject; E: Exception);
    { Private declarations }
  public
    { Public declarations }
    property    isShowDetails : boolean read FisShowDetails write SetisShowDetails;
    procedure   Execute(E : Exception);
  end;

var
  ErrorMsgDialog: TErrorMsgDialog;

threadvar
  CurProgressMsg : string;

procedure SetProgressMsg(const Msg:string);

procedure ClearProgressMsg;

procedure HandleProgressException;

procedure HandleThisException(E : Exception);

procedure InstallExceptHanlder;

const
  KnownExceptCount = 12;
  KnownExceptions : array[1..KnownExceptCount] of ExceptClass
    = ( EOutOfMemory,
        EInvalidPointer,
        EHeapException,
        EInOutError,
        EIntError,
        EMathError,
        EAccessViolation,
        EStackOverflow,
        EExternal,
        EWin32Error,
        EDatabaseError,
        Exception
      );
  KnownExceptionInfos : array[1..KnownExceptCount] of string[20]
    = ( '�ڴ����',
        '��Чָ��',
        '��',
        '�������',
        '��������',
        '��ѧ����',
        '���ʵ�ַ',
        '��ջ���',
        '�ⲿ',
        'Win32����ϵͳ',
        '���ݿ����',
        ''
      );

implementation

{$R *.DFM}

procedure SetProgressMsg(const Msg:string);
begin
  CurProgressMsg := Msg;
end;

procedure ClearProgressMsg;
begin
  CurProgressMsg := '';
end;

procedure HandleProgressException;
var
  E : Exception;
begin
  E := Exception(ExceptObject);
  HandleThisException(E);
end;

procedure HandleThisException(E : Exception);
var
  Dialog : TErrorMsgDialog;
begin
  if (E<>nil) and not (E is EAbort) then
  begin
    Dialog := TErrorMsgDialog.Create(nil);
    try
      Dialog.Execute(E);
    finally
      Dialog.free;
    end;
  end;
end;

procedure InstallExceptHanlder;
begin
  if Application<>nil then
    Application.OnException := TErrorMsgDialog.HandleAppError;
end;

procedure TErrorMsgDialog.btnDetailClick(Sender: TObject);
begin
  isShowDetails := not isShowDetails;
end;

procedure TErrorMsgDialog.Execute(E: Exception);
var
  Info,Msg,ExtraInfo : string;
  i : integer;
begin
  assert(E<>nil);
  ExtraInfo := '';
  mmInfo.lines.clear;
  mmMsgs.lines.clear;
  // Set Info
  if CurProgressMsg<>'' then Info := '  �ڽ���'+CurProgressMsg+'����ʱ����'
  else Info := '  ����';
  CurProgressMsg:='';
  for i:=1 to KnownExceptCount do
    if E is KnownExceptions[i] then
    begin
      Info := Info + KnownExceptionInfos[i];
      break;
    end;
  Info := Info+'����';
  // set Msg
  Msg := E.ClassName+#13#10;
  // set Database Error Msg
  if E is EDBEngineError then
    with EDBEngineError(E) do
    begin
      for i:=0 to ErrorCount-1 do
      with Errors[i] do
      begin
        Msg := format('%s[%d] (Catalog: %d,SubCode: %d,Server Code: %d)'#13#10' %s'#13#10,
          [Msg,I+1,Category,SubCode,NativeError,Message]);
        case  Category of
          ERRCAT_SYSTEM    :  ExtraInfo := ExtraInfo + ' (���ݿ��������) ';
          ERRCAT_NOTFOUND  :  ExtraInfo := ExtraInfo + ' (�Ҳ�����¼) ';
          ERRCAT_DATACORRUPT : ExtraInfo := ExtraInfo + ' (���ݱ��ƻ�) ';
          ERRCAT_IO        :  ExtraInfo := ExtraInfo + ' (I/O����) ';
          ERRCAT_LIMIT     :  ExtraInfo := ExtraInfo + ' (ϵͳ��Դ���) ';
          ERRCAT_INTEGRITY :  ExtraInfo := ExtraInfo + ' (����һ���Դ���) ';
          ERRCAT_INVALIDREQ:  ExtraInfo := ExtraInfo + ' (��Ч�Ĳ���) ';
          ERRCAT_LOCKCONFLICT : ExtraInfo := ExtraInfo + ' (���ݿ�������ͻ) ';
          ERRCAT_SECURITY  :  ExtraInfo := ExtraInfo + ' (û�з���Ȩ��) ';
        end;
      end;
      if ExtraInfo<>'' then Info := Info+#13#10+ExtraInfo;
    end;
  mmInfo.lines.Add(Info);
  mmMsgs.lines.Add(msg);
  ShowModal;
end;

procedure TErrorMsgDialog.FormCreate(Sender: TObject);
begin
  FIsShowDetails := false;
  ClientHeight := mmMsgs.Top - 2;
  btnDetail.caption := '��ʾ��ϸ��Ϣ';
end;

class procedure TErrorMsgDialog.HandleAppError(Sender: TObject;
  E: Exception);
begin
  HandleThisException(e);
end;

procedure TErrorMsgDialog.SetisShowDetails(const Value: boolean);
begin
  if FisShowDetails <> Value then
  begin
    FisShowDetails := Value;
    if FisShowDetails then
    begin
      ClientHeight := mmMsgs.Top + mmMsgs.Height+2;
      btnDetail.caption := '������ϸ��Ϣ';
    end
    else
    begin
      ClientHeight := mmMsgs.Top - 2;
      btnDetail.caption := '��ʾ��ϸ��Ϣ';
    end;
  end;
end;

end.
