unit WVCmdReq;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>WVCmdReq
   <What>����WorkView����������Զ�����Command�������
  �����Զ���ɶ���������ݰ�
   <Written By> Huang YanLai (������)
   <History>
**********************************************}

{$I KSConditions.INC }

interface

uses SysUtils, Classes, DataTypes, WVCommands, WorkViews;

type
  TWVRequest = class;

  TWVBindingDirection = (bdField2Param, bdParam2Field, bdBiDirection);
  TWVBindingEvent = procedure (FieldData, ParamData : TKSDataObject) of object;
  {
    <Class>TWVFieldParamBinding
    <What>���������ֶκ���������İ󶨹�ϵ
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVFieldParamBinding = class(TCollectionItem)
  private
    FFieldName: string;
    FParamName: string;
    FDirection: TWVBindingDirection;
    FRequest: TWVRequest;
    FOnBindInput: TWVBindingEvent;
    FOnBindOutput: TWVBindingEvent;
    FDefaultValue: Variant;
    procedure   BindInput(Command : TWVCommand);
    procedure   BindOutput(Command : TWVCommand);
    procedure   ClearOutput;
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure   Assign(Source: TPersistent); override;
    property    Request : TWVRequest read FRequest;
  published
    property    ParamName : string read FParamName write FParamName;
    property    FieldName : string read FFieldName write FFieldName;
    property    Direction : TWVBindingDirection read FDirection write FDirection default bdField2Param;
    property    DefaultValue : Variant read FDefaultValue write FDefaultValue;
    property    OnBindInput : TWVBindingEvent read FOnBindInput write FOnBindInput;
    property    OnBindOutput : TWVBindingEvent read FOnBindOutput write FOnBindOutput;
  end;

  TRequestEvent = procedure (Request : TWVRequest; Command : TWVCommand) of object;
  {
    <Class>TWVRequest
    <What>���workview��command֮������ݰ�
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVRequest = class(TComponent)
  private
    FWorkView: TWorkView;
    FID: TWVCommandID;
    FVersion: TWVCommandVersion;
    FContext: TWVContext;
    FBindings: TCollection;
    FBeforeExec: TRequestEvent;
    FAfterExec: TRequestEvent;
    FClearOutputsBeforeExec: Boolean;
    procedure   SetWorkView(const Value: TWorkView);
    procedure   SetBindings(const Value: TCollection);
    procedure   BindInputs(Command : TWVCommand);
    procedure   BindOutputs(Command : TWVCommand);
    procedure   ClearOutputs;
    procedure   DoBeforeExec(Command : TWVCommand);
    procedure   DoAfterExec(Command : TWVCommand);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    property    Context : TWVContext read FContext write FContext;
    procedure   SendCommand;
  published
    property    WorkView : TWorkView read FWorkView write SetWorkView;
    property    ID : TWVCommandID read FID write FID;
    property    Version : TWVCommandVersion read FVersion write FVersion default 1;
    property    Bindings : TCollection read FBindings write SetBindings;
    property    BeforeExec : TRequestEvent read FBeforeExec write FBeforeExec;
    property    AfterExec : TRequestEvent read FAfterExec write FAfterExec;
    property    ClearOutputsBeforeExec : Boolean read FClearOutputsBeforeExec write FClearOutputsBeforeExec default True;
  end;


implementation

uses SafeCode
{$ifdef VCL60_UP }
,Variants
{$else}

{$endif}
;

type
  TOwnedCollectionAccess = class(TOwnedCollection);

{ TWVFieldParamBinding }

constructor TWVFieldParamBinding.Create(Collection: TCollection);
begin
  inherited;
  FRequest := TWVRequest(TOwnedCollectionAccess(Collection).GetOwner);
  FDirection := bdField2Param;
  FDefaultValue := Unassigned;
end;

procedure TWVFieldParamBinding.Assign(Source: TPersistent);
begin
  if Source is TWVFieldParamBinding then
    with TWVFieldParamBinding(Source) do
    begin
      Self.ParamName := ParamName;
      Self.FieldName := FieldName;
      Self.Direction := Direction;
    end
  else
    inherited;
end;

function TWVFieldParamBinding.GetDisplayName: string;
var
  S : string;
begin
  case Direction of
    bdField2Param : S := '->';
    bdParam2Field : S := '<-';
  else
    S := '<->';
  end;
  Result := FieldName + S + ParamName;
end;

procedure TWVFieldParamBinding.BindInput(Command: TWVCommand);
var
  Field : TWVField;
  FieldData, ParamData : TKSDataObject;
begin
  CheckObject(Request.WorkView,'Error : Invalid WorkView For TWVRequest');
  if Direction in [bdField2Param, bdBiDirection] then
  begin
    if FieldName<>'' then
    begin
      Field := Request.WorkView.FieldByName(FieldName);
      FieldData := Field.Data;
    end else
    begin
      Field := nil;
      FieldData := nil;
    end;
    ParamData := Command.ParamData(ParamName);
    if Assigned(FOnBindInput) then
      FOnBindInput(FieldData,ParamData)
    else if Field<>nil then
    begin
      // ���ָ�����ֶΣ�ʹ���ֶε�ֵ
      if not FieldData.IsEmpty then // �������Ϊ�գ�ʹ�����������ȱʡֵ
        ParamData.Assign(FieldData);
    end
    else // ���û��ָ���ֶΣ�ʹ�ð������ȱʡֵ(����)
      if not VarIsEmpty(DefaultValue) then // �������Ϊ�գ�ʹ�����������ȱʡֵ
        ParamData.Value := DefaultValue;
  end;
end;

procedure TWVFieldParamBinding.BindOutput(Command: TWVCommand);
var
  Field : TWVField;
  FieldData, ParamData : TKSDataObject;
begin
  CheckObject(Request.WorkView,'Error : Invalid WorkView For TWVRequest');
  if Direction in [bdParam2Field, bdBiDirection] then
  begin
    Field := Request.WorkView.FieldByName(FieldName);
    FieldData := Field.Data;
    if ParamName<>'' then
      ParamData := Command.ParamData(ParamName) else
      ParamData := nil;
    if Assigned(FOnBindOutput) then
      FOnBindOutput(FieldData,ParamData)
    else if ParamData<>nil then
      // ���ָ��������ʹ�ò�����ֵ
      FieldData.Assign(ParamData)
    else
      // ���û��ָ��������ʹ��ȱʡֵ
      FieldData.Value := DefaultValue;
  end;
end;

procedure TWVFieldParamBinding.ClearOutput;
var
  Field : TWVField;
  FieldData : TKSDataObject;
begin
  CheckObject(Request.WorkView,'Error : Invalid WorkView For TWVRequest');
  if Direction in [bdParam2Field] then
  begin
    Field := Request.WorkView.FieldByName(FieldName);
    FieldData := Field.Data;
    FieldData.Clear;
  end;
end;

{ TWVRequest }

constructor TWVRequest.Create(AOwner: TComponent);
begin
  inherited;
  FID := '';
  FVersion := 1;
  FBindings := TOwnedCollection.Create(Self, TWVFieldParamBinding);
  FClearOutputsBeforeExec := True;
end;

destructor TWVRequest.Destroy;
begin
  FreeAndNil(FBindings);
  inherited;
end;

procedure TWVRequest.DoAfterExec(Command : TWVCommand);
begin
  if Assigned(AfterExec) then
    AfterExec(Self,Command);
end;

procedure TWVRequest.DoBeforeExec(Command : TWVCommand);
begin
  if Assigned(BeforeExec) then
    BeforeExec(Self,Command);
end;

procedure TWVRequest.BindInputs(Command : TWVCommand);
var
  I : Integer;
begin
  for I:=0 to Bindings.Count-1 do
  begin
    TWVFieldParamBinding(Bindings.Items[I]).BindInput(Command);
  end;
end;

procedure TWVRequest.BindOutputs(Command : TWVCommand);
var
  I : Integer;
begin
  for I:=0 to Bindings.Count-1 do
  begin
    TWVFieldParamBinding(Bindings.Items[I]).BindOutput(Command);
  end;
end;

procedure TWVRequest.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent=WorkView) then
  begin
    WorkView := nil;
  end;
end;

procedure TWVRequest.SendCommand;
var
  Command : TWVCommand;
begin
  CheckObject(Context,'Invalid Context');
  Command := Context.CommandFactory.NewCommand(ID,Version);
  try
    BindInputs(Command);
    if FClearOutputsBeforeExec then
      ClearOutputs;
    DoBeforeExec(Command);
    Context.CommandBus.Process(Command);
    DoAfterExec(Command);
    BindOutputs(Command);
    Command.CheckError;
  finally
    Command.Free;
  end;
end;

procedure TWVRequest.SetBindings(const Value: TCollection);
begin
  FBindings.Assign(Value);
end;

procedure TWVRequest.SetWorkView(const Value: TWorkView);
begin
  if FWorkView<>Value then
  begin
    FWorkView := Value;
    if FWorkView<>nil then
      FWorkView.FreeNotification(Self);
  end;
end;

procedure TWVRequest.ClearOutputs;
var
  I : Integer;
begin
  for I:=0 to Bindings.Count-1 do
    TWVFieldParamBinding(Bindings.Items[I]).ClearOutput;
end;

end.
