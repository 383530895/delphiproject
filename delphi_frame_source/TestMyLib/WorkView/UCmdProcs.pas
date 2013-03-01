unit UCmdProcs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WVCmdProc, WVCommands;

type
  TdmCmProcs = class(TDataModule)
    WVProcessor1: TWVProcessor;
    procedure WVProcessor1Process(Command: TWVCommand);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmCmProcs: TdmCmProcs;

implementation

{$R *.DFM}

procedure TdmCmProcs.WVProcessor1Process(Command: TWVCommand);
var
  S : string;
begin
  S := Command.ParamData('�ͻ���').AsString;
  if (S<>'') and (S[1]='1') then
    Command.ParamData('���ر�־').SetInteger(1) else
    Command.ParamData('���ر�־').SetInteger(0);
  ShowMessage(Command.GetDetail);
end;

end.
