unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R myres.res}
procedure TForm1.Button1Click(Sender: TObject);
var hRes:Thandle;
//    pRes: pointer; ***************
    pRes:  Cardinal;
    ResSize:integer;
    i:integer;
    {$IFDEF WIN32}
    s:shortstring;
    {$ELSE}
    s:string;
    {$ENDIF}
begin
  hRes:=FindResource(hInstance,'MYUSERDATA','MYDATATYPE');
  if hRes=0 then
    begin
      showMessage('û���ҵ���Դ�ļ���');
      exit;
    end;
  ResSize:=SizeOfResource(hinstance,hRes);
  if ResSize=0 then
    begin
      showmessage('û��װ���κ���Դ��');
      exit;
    end;
// pRes:=LockResource(hRes);
 // ****************
  pRes:=LoadResource(hInstance, hRes);
  if pRes=0 then
    begin
      showmessage('��Դװ��ʧ�ܣ�');
      FreeResource(pRes);
      exit;
    end;

  s:='';
  i:=0;
//  while(i<ResSize) do
  while (pChar(pRes)[i]<>'#') and (i<ResSize) do //************
    begin
      s:=s+pChar(pRes)[i];
      inc(i);
    end;

  showMessage(s);
 // UnLockResource(hRes);// *************
  FreeResource(pRes);
end;




end.
