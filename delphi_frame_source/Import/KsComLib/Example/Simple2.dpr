program Simple2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DRTPAPI in '..\DRTPAPI.pas',
  KCDataPack in '..\KCDataPack.PAS';

const
  BufferSize = 4096;

type
  TTestData = packed record
    IValue : Integer;
    Dump : Integer;
    DValue : Double;
  end;

var
  Handle : Integer;
  I : Integer;
  IP : string;
  Recvbuffer : Array[0..BufferSize-1] of Byte;
  Port : Integer;
  Encode : Integer;
  Data : TTestData;
begin
  KCCheckDefine;

  if not DRTPAPI.DLLLoaded then
  begin
    Writeln('Cannot Load DRTPAPI.DLL');
    Exit;
  end;

  if ParamCount<>3 then
  begin
    Writeln('usage:Simple [remoteIP] [remotePORT] [EncryptMethod]');
    Writeln('Press Enter...');
    Readln;
    Exit;
  end;

  if not DRTPInitialize() then           //��ʼ����ÿ��������һ�μ��ɣ�
  begin
    Writeln('DRTPInitialize Failed.');
    Exit;
  end;

  //������DRTPGetHost�õ���Ӧip��·��ͨѶ�������ı���

  //����·��ͨѶ������
  IP := ParamStr(1);
  Port := StrToInt(ParamStr(2));
  Encode := StrToInt(ParamStr(3));
  Handle:=DRTPConnect(Pchar(IP),Port,Encode);
  if  Handle=0 then
  begin
    Writeln('drtpconnect error!');
    DRTPUninitialize();
    Exit;
  end;

  if not DRTPCheckNetState(Handle,2000) then       //�������״̬������ʡ�ԣ�
  begin
    Writeln('network instability');
    DRTPClose(Handle);      //�ر�����
    DRTPUninitialize(); //�ͷ���Դ
    Exit;
  end;

  Data.IValue := 100;
  Data.DValue := 100.5;
  Data.Dump := 0;
  //�������ݵ�Ŀ�����أ����Ϊ0���������ܺ�800�����ȼ�Ϊ2����ָ��·��
  if not DRTPSend(Handle,0,800,PChar(@Data),SizeOf(Data),2,false) then
  begin
    Writeln('drtpsend error!');
    DRTPClose(Handle);  //�ر�����
    DRTPUninitialize();           //�ͷ���Դ
    Exit;
  end;

  Writeln('waiting for data arriving.....');
  while not DRTPCheckDataArrived(Handle,1000) do ;   //����Ƿ������ݵ������ʡ�ԣ�

  Writeln('receve data...................');
  I:=DRTPReceive(Handle,PChar(@Data),SizeOf(Data),0);        //��������

  if i<=0 then
  begin
    DRTPGetLastError(Handle,PChar(@Recvbuffer),4096);              //ȡ�ó�����Ϣ
    Writeln('error:%s',PChar(@Recvbuffer));
  end
  else
    Writeln(Format('Int=%d,Double=%f',[Data.IValue,Data.DValue]));
  DRTPClose(Handle);      //�ر�����
  DRTPUninitialize();        //�ͷ���Դ

  Writeln('Press Enter...');
  Readln;
end.
