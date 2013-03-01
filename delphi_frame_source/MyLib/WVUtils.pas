unit WVUtils;

interface

uses Classes, WVCommands, WVCmdTypeInfo, WVCmdReq, WVCmdProc;

procedure RegisterDecsriptorsAndProcessors(Context : TWVContext);

implementation

uses Forms;

procedure RegisterDecsriptorsAndProcessors(Context : TWVContext);
var
  I : Integer;
  Comp : TComponent;
begin
  if Application<>nil then
  begin
    // ע�����е�������������
    for I:=0 to Application.ComponentCount-1 do
    begin
      Comp := Application.Components[I];
      RegisterCommandDescriptors(Comp,Context);
    end;
    // ע�����е����������������������������Ժ�ע�ᣩ
    for I:=0 to Application.ComponentCount-1 do
    begin
      Comp := Application.Components[I];
      RegisterCommandProcessors(Comp,Context);
    end;
  end;
end;

end.
