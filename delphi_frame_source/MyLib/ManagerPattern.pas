unit ManagerPattern;


{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>ManagerPattern
   <What>ʾ��Manager���ģʽ(Design Pattern)
   <How To>���Ƹ��ļ�,���������ļ�;
   ��TManager��TManagedItem�滻Ϊ��Ҫ��������;
   ��Manager �滻Ϊ��Ҫ�ı�����.
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses SysUtils, Classes;

type
  // forward declare
  TManager = class;
  TManagedItem = class;

  TManager = class(TObject)
  private
    FItems: TList;
    function GetItems(index: Integer): TManagedItem;
  protected

  public
    constructor Create;
    Destructor  Destroy;override;
    class procedure   AddManagedItem(Item:TManagedItem);
    class procedure   RemoveManagedItem(Item:TManagedItem);
    property Items[index : Integer] : TManagedItem read GetItems;
  published

  end;

  TManagedItem = class(TComponent)
  private

  protected

  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    //procedure   Changed(Target:TObject);
  end;

var
  Manager : TManager;

implementation

{ TManager }

constructor TManager.Create;
begin
  FItems := TList.create;
end;

destructor TManager.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

class procedure TManager.AddManagedItem(Item: TManagedItem);
begin
  if Manager<>nil then
    if Manager.FItems<>nil then
      Manager.FItems.Add(Item);
end;

class procedure TManager.RemoveManagedItem(Item: TManagedItem);
begin
  if Manager<>nil then
    if Manager.FItems<>nil then
      Manager.FItems.Remove(Item);
end;

function TManager.GetItems(index: Integer): TManagedItem;
begin
  Result := TManagedItem(FItems[index]);
end;

{ TManagedItem }

constructor TManagedItem.Create(AOwner: TComponent);
begin
  inherited;
  TManager.AddManagedItem(self);
end;

destructor TManagedItem.Destroy;
begin
  TManager.RemoveManagedItem(self);
  inherited;
end;

initialization
  Manager := TManager.create;

finalization
  FreeAndNil(Manager);

end.
