unit ComWriUtils;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> ComWriUtils
   <What> �ؼ���д�ߵĹ���
   <Written By> Huang YanLai(������)
   <History>Move TSafeProcCaller to CompUtils
**********************************************}

interface

uses windows,messages,sysutils,Classes,Controls;

{ 1. "RegisterRefProp" and "ReferTo" }

{ How to use "RegisterRefProp" and "ReferTo"
  1) in YourComponent.create
    call RegisterRefProp(self,'MyProperty');
  2) in YourComponent.SetMyProperty(value : TComponent)
    call ReferTo(value)
}

{ Register  a property that refers a component.
  The property must be published.
}
type
  TReferenceMan = class(TComponent)
  private
    FClients : TStringList;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor 	destroy; override;
    procedure 	RegisterRefProp(Instance : TComponent; const PropName : string);
    procedure 	ReferTo(RefInstance : TComponent);
  end;

procedure RegisterRefProp(Instance : TComponent; const PropName : string);

procedure ReferTo(RefInstance : TComponent);

{ 2. Some Exceptions and procedure
  remove to Safecode.
}

{3. TMsgFilter and some Hook procedures}

type
  { %TMsgFilter : ��Ϣ�����������뵽ָ��Delphi�ؼ�����Ϣ����ѭ���С�
    ���͵��ؼ�����Ϣ���ȷ��͵�TMsgFilter(WndProc)��Ȼ��ͨ��DefaultHandler���ÿؼ�ԭ������Ϣ����  }
	TMsgFilter = class
  private
    FEnabled: boolean;
    // %FReleasing : �Ƿ����ͷ�״̬
    FReleasing : boolean;
    function 	GetHandle: THandle;
    procedure SetEnabled(const Value: boolean);
  protected
    // %OldWndProc : �ؼ�ԭ������Ϣ����
    OldWndProc : TWndMethod; // save origin WindowProc
    // %Control : ����ס�Ŀؼ�
    Control : TControl;
    { PreHandle handle message before dispatch
      if return false, do not pass it to next handle
    }
    function	PreHandle(var Message: TMessage) : boolean ; dynamic;
    { %WndProc
       1. ����TMsgFilter������ڲ���Ϣ
       2. if enabled
         2.1 ����PreHandle
         2.2 �������������Dispatch��
          ����TMsgFilter������û�д������Ϣ����DefaultHandler
       3. ���򣬵���DefaultHandler
    }
    procedure WndProc(var Message: TMessage); dynamic;
    // %AmI : �ж��Ƿ���TMsgFilter�������Ϣ(#message)
    function 	AmI(const message):boolean;
    // %EnableChanged : ��Enable�仯ʱ������
    procedure EnableChanged; dynamic;
  public
    // %HookedControl : ����ס�Ŀؼ�
    property    HookedControl : TControl read Control;
    // %Enabled : �Ƿ�ʹ��TMsgFilter����Ϣ����(���false,ֱ�ӵ��ÿؼ�ԭ���Ĵ���)
    property		Enabled : boolean read FEnabled write SetEnabled;
    // %Create : #AControl�Ǳ���ס�Ŀؼ���ע�����AControl.freeNotification(MsgFilterManager)
    constructor Create(AControl : TControl); virtual;
    // %destroy : ��Ҫֱ�ӵ���destroy����Free,Ӧ��ʹ��UnHookMsgFilter
    destructor 	destroy; override;
    // DefaultHandler call OldWndProc
    // %DefaultHandler : ���ÿؼ�ԭ������Ϣ����
    procedure   DefaultHandler(var Message); override;
    // %Handle : ����ؼ���TWinControl����Windows Handle,���򷵻�0
    property 	  Handle : THandle read GetHandle;
  end;

  TMsgFilterClass = class of TMsgFilter;

  // %TMsgFilterManager : ����TMsgFilter���ͷţ�������ס�Ŀؼ��ͷ�ʱ������Notification
  TMsgFilterManager = class(TComponent)
  protected
    // %Notification : ��(AComponent is TControl)and(Operation=opRemove) ����UnHookMsgFilter
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  end;

  // %HookMsgFilter : ����#MFClass��ʵ����ס#AControl��������ʵ��
  function	HookMsgFilter(AControl : TControl; MFClass : TMsgFilterClass):TMsgFilter;

  {// the obsolete procedure
  // this procedure will release all msgFilter on AControl
  procedure UnhookMsgFilter(AControl : TControl);
  }
  // %UnHookMsgFilter : �ͷ�#AControl������Ϊ#ClassType(��������)����Ϣ������
  procedure UnHookMsgFilter(AControl : TControl; ClassType:TMsgFilterClass);

  // new 99/06/08
  // %UnHookMsgFilterEx : �ͷ�#AControl������Ϊ#ClassType(��������)����Ϣ������
  // #˵������Ϊ�����ж��#ClassType��ס��ͬ��#AControl,���#all=true,�ͷ�����#ClassType���͵Ĺ��ӡ�
  procedure UnHookMsgFilterEx(AControl : TControl; ClassType:TMsgFilterClass; all : boolean);

  // %NotifyMsgFilter : ����TMsgFilter������ڲ���Ϣ��������Ϣ�����
  // #AControl : #NotifyCode:֪ͨ����; #SubClass : �Ƿ��������; #ClassType:֪ͨ��TMsgFilter��
  function	NotifyMsgFilter(AControl : TControl;
  	NotifyCode:word; SubClass : boolean; ClassType:TMsgFilterClass):longint;

  // %EnableMsgFilter : Enable/Disable #AControl�ϵ�����Ϊ#ClassType����Ϣ������
  procedure EnableMsgFilter(AControl : TControl;
  	enabled: boolean; ClassType:TMsgFilterClass);
var
  //%CM_MsgFilter : TMsgFilter������ڲ���Ϣ�������registerWindowMessage('CM_MsgFilter')����
  CM_MsgFilter : Cardinal;

type
  // %TMsgFilter������ڲ���Ϣ�ṹ
	TCMMsgFilter = record
    msg : Cardinal;                  // ��Ϣ�����=CM_MsgFilter
    NotifyCode : word;               // ֪ͨ����
    SubClass   : wordbool;           // �Ƿ��������
    ClassType  : TMsgFilterClass;    // ֪ͨ��TMsgFilter��
    result		 : longint;            // ���ؽ��
  end;

// TCMMsgFilter.NotifyCode:
const
  mf_enable = 1;
  mf_disable = 2;
  // find a MsgFilter need be released
  mf_FindReleased = 3;   // ����ҵ�Ҫ�ͷŵ���Ϣ������������1������0
  // before a MsgFilter release, it send a mt_Releasing to control
  // please see MsgFilter.WndProc for detail
  mf_Releasing = 4;
  mf_custom = 10;

{4. GetChildren Procedure
 If a component wants to save all components it owns to resource,
 must do as follows:
   1)procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
   2)In GetChildren, do
   begin
	   inherited GetChildren(Proc, Root);
		 CommonGetChildren(self,Proc,Root);
   end;
}

// %CommonGetChildren : ������Stream�б���#Comp������ӵ�е�ChildComponent
procedure CommonGetChildren(Comp : TComponent; Proc: TGetChildProc; Root: TComponent);

{5. Some List Classes }
type
  // %TNumberList : �����б�
	TNumberList = class(TList)
  private
    function GetItems(index: integer): Integer;
    procedure SetItems(index: integer; const Value: Integer);
  public
    function Add(Item: longword): Integer;
    function IndexOf(Item: longword): Integer;
    function Remove(Item: longword): Integer;
    property  Items[index : integer] : Integer
      read GetItems write SetItems; default;
  end;

  // %TObjectList : �����б����Owned,���ͷ��б�ʱ���ͷŰ��������еĶ���
  TObjectList = class(TList)
  private
    FOwned : boolean;
    function  GetItems(index: integer): TObject;
    procedure SetItems(index: integer; const Value: TObject);
  public
    constructor Create(AOwned : boolean=true);
    function	Add(AObject : TObject):integer;
    procedure Delete(Index: Integer);
    function	Remove(Item: TObject): Integer;
    procedure Clear; override;
    property 	Owned: boolean	Read FOwned;
    property  Items[index : integer] : TObject
      read GetItems write SetItems; default;
  end;
  (*
  TStringMapItem=class
  public
    Name  : string;
    value : string;
    constructor Create(const	AName,Avalue: string);
  end;

  TStringMap = class(TObjectList)
  private
    function GetNames(index: integer): string;
    function GetValues(index: integer): string;
    procedure SetNames(index: integer; const Value: string);
    procedure SetValues(index: integer; const Value: string);

  public
    NameCaseSen,ValueCaseSen:boolean;
    constructor Create;
    procedure Add(const	Name,value: string);
    // remove first matched item
    procedure RemoveName(const	Name:string);
    procedure RemoveValue(const	Value:string);
    // if not found return false
    function 	GetValueByName(const	Name:string; var Value:string):boolean ;
    function 	GetNameByValue(const	Value:string; var Name:string):boolean ;
    {
    		the two procedures add resultString in TStrings.
      	you may clear the TStrings before call to make sure
      that TStrings only contains resulStrings.
      	why do the procedures	not clear TStrings:
        because in PathServer, I want to add all alias-values in one TStrings.
    }
    procedure	GetValuesByName(const	Name:string; Values:Tstrings);
    procedure	GetNamesByValue(const	Value:string; Names:Tstrings);
    // return the first matched item index
    function  IndexOfName(const	Name:string):integer ;
    function  IndexOfValue(const	value:string):integer ;
    property 	Names[index : integer] : string Read GetNames Write SetNames;
    property 	Values[index : integer]: string  Read GetValues Write SetValues;
  end;

  TPointerMapItem = class
  public
    Name  : pointer;
    value : pointer;
    constructor Create(const	AName,Avalue: pointer);
  end;

  TPointerMap = class(TObjectList)
  private
    function 	GetNames(index: integer): pointer;
    function 	GetValues(index: integer): pointer;
    procedure SetNames(index: integer; const Value: pointer);
    procedure SetValues(index: integer; const Value: pointer);
  public
    constructor Create;
    procedure Add(const	Name,value: pointer);
    // remove first matched item
    procedure RemoveName(const	Name:pointer);
    procedure RemoveValue(const	Value:pointer);
    // if not found return false
    function 	GetValueByName(const	Name:pointer; var Value:pointer):boolean ;
    function 	GetNameByValue(const	Value:pointer; var Name:pointer):boolean ;
    {
    		the two procedures add resultString in TStrings.
      	you may clear the TStrings before call to make sure
      that TStrings only contains resulStrings.
      	why do the procedures	not clear TStrings:
        because in PathServer, I want to add all alias-values in one TStrings.
    }
    procedure	GetValuesByName(const	Name:pointer; Values:TList);
    procedure	GetNamesByValue(const	Value:pointer; Names:TList);
    // return the first matched item index
    function  IndexOfName(const	Name:pointer):integer ;
    function  IndexOfValue(const	value:pointer):integer ;
    property 	Names[index : integer] : pointer Read GetNames Write SetNames;
    property 	Values[index : integer]: pointer  Read GetValues Write SetValues;
  end;
  *)

type
  // %TMapItem : ����Name��Value��ӳ����Ŀ
  TMapItem = class
  protected
    function    FNameAddr : pointer; virtual; abstract;
    function 		FValueAddr : pointer; virtual; abstract;
  public
    // CompareXXX return
    //   <0 : <
    //   =  : =
    //   >0 : >
    function		CompareName(const AName):integer; virtual; abstract;
    function		CompareValue(const AValue):integer; virtual; abstract;
    procedure 	CopyName(var name);virtual; abstract;
    procedure 	CopyValue(var value);virtual; abstract;
    //constructor Create(const Name,value);virtual; abstract;
  end;

  // %TMapList : ����TMapItem ���б�
  // 1.���Կ���Name��Value��Ψһ��
  // 2.������Name->Value,Value->Name
  TMapList = class(TObjectList)
  private
    FUniqueValue: boolean;
    FUniqueName: boolean;
    function 		CheckUniqueName(const Name):boolean;
    function 		CheckUniqueValue(const value):boolean;
  public

    constructor Create(AUniqueName,AUniqueValue : boolean);
    property    UniqueName : boolean read FUniqueName;
    property    UniqueValue: boolean read FUniqueValue;
    function		GetValueByName(const	Name;var Value):boolean;
    function		GetNameByValue(const	Value;var Name):boolean;
    // return the first matched item index
    function  	IndexOfName(const	Name):integer;
    function  	IndexOfValue(const	value):integer;
    procedure		GetValue(index : integer; var value);
    procedure		GetName(index : integer; var name);
    // before real add, the add procedure will check Unique constraint
    // return whether successful
    function 		Add(MapItem:TMapItem):boolean;
    // before real add, the add procedure will check Unique constraint
    // if not match the constraint, Add2 will free MapItem !
    // return whether successful
    function 		Add2(MapItem:TMapItem):boolean;
    function		RemoveName(const	Name):boolean;
    function		RemoveValue(const	Value):boolean;

    // FindXXX : user 2-divide method to find quick
    // Important Notes :
    // Names must be sort in little to great when use FindName
    // Values must be sort in little to great when use FindValue
    function    FindName(const	Name):integer;
    function  	FindValue(const	value):integer;
  end;


  TStringMap = class;

  // %TStringMapItem : �ַ������ַ�����ӳ����Ŀ
  TStringMapItem=class(TMapItem)
  private
    FStringMap : TStringMap;
  protected
    function    FNameAddr : pointer; override;
    function 		FValueAddr : pointer; override;
  public
    Name  : string;
    value : string;
    constructor Create(AStringMap : TStringMap;
    		const	AName,Avalue: string);
    function		CompareName(const AName):integer; override;
    function		CompareValue(const AValue):integer; override;
    procedure 	CopyName(var Aname); override;
    procedure 	CopyValue(var Avalue); override;
  end;

  // %TStringMap : �ַ������ַ�����ӳ���б����Կ���name��Value�Ĵ�Сд������
  TStringMap = class(TMapList)
  private
    function 	GetNames(index: integer): string;
    function 	GetValues(index: integer): string;
    procedure SetNames(index: integer; const Value: string);
    procedure SetValues(index: integer; const Value: string);
  public
    NameCaseSen,ValueCaseSen:boolean;
    constructor Create(AUniqueName,AUniqueValue : boolean);
    function		Add(const	Name,value: string):boolean;
    function    AddItem(const	Name,value: string): TStringMapItem;
    property 		Names[index : integer] : string Read GetNames Write SetNames;
    property 		Values[index : integer]: string  Read GetValues Write SetValues;
    function    FindNearestName(const name:string) : integer;
    function    FindNearestValue(const Value:string) : integer;
  end;

  function  ConvertNameToAlias(const FileName:string;
            var Alias:string;
            AliasList : TStringMap): boolean;

type
  // %TPointerMapItem : ָ�뵽ָ���ӳ����Ŀ
  TPointerMapItem = class(TMapItem)
  protected
    function    FNameAddr : pointer; override;
    function 		FValueAddr : pointer; override;
  public
    Name  : pointer;
    value : pointer;
    constructor Create(AName,Avalue: pointer);
    function		CompareName(const AName):integer; override;
    function		CompareValue(const AValue):integer; override;
    procedure 	CopyName(var Aname); override;
    procedure 	CopyValue(var Avalue); override;
  end;

  // %TPointerMap : ָ�뵽ָ���ӳ���б�
  TPointerMap = class(TMapList)
  private
    function    GetNames(index: integer): pointer;
    function    GetValues(index: integer): pointer;
    procedure   SetNames(index: integer; const Value: pointer);
    procedure   SetValues(index: integer; const Value: pointer);
  public
    function		Add(const	Name,value: pointer):boolean;
    property 		Names[index : integer] : pointer	Read GetNames Write SetNames;
    property 		Values[index : integer]: pointer	Read GetValues Write SetValues;
  end;

  // %TStrIntMapItem : �ַ�����������ӳ����Ŀ����Сд������
  TStrIntMapItem = class(TMapItem)
  protected
    function    FNameAddr : pointer; override;
    function 		FValueAddr : pointer; override;
  public
    Name  : String;
    value : integer;
    constructor Create(const	AName : string ; Avalue: integer);
    function		CompareName(const AName):integer; override;
    function		CompareValue(const AValue):integer; override;
    procedure 	CopyName(var Aname); override;
    procedure 	CopyValue(var Avalue); override;
  end;

  // %TStrIntMap : �ַ�����������ӳ���б���Сд������
  TStrIntMap = class(TMapList)
  public
    function		Add(const	Name : string ;value: integer):boolean;
    // not first clear the strings
    // name is string, value is object
    procedure 	CopyToStrings(AStrings : TSTrings);
    //property 		Names[index : integer] : pointer	Read GetNames Write SetNames;
    //property 		Values[index : integer]: pointer	Read GetValues Write SetValues;
  end;


{7.IFileView}
type
  IFileView = interface
    ['{836BE940-470D-11D2-B3AA-0080C85570FA}']
    function LoadFromFile(const Filename:string): boolean;
  end;

//8)
// Component Common Attributes
// %TCompCommonAttrs : �����������������һ�����Ĺ������ԣ���Щ�����ΪClient��
// �����Ըı�ʱ��֪ͨ���е�Client
  TCompCommonAttrs = class(TComponent)
  private
    FOnPropChanged: TNotifyEvent;
  protected
    // %FClients : Clients�б�
    FClients :  TList;
    // %FUpdatingCount : ���¼���
    FUpdatingCount : integer;
    // %FAttrsUpdating : ���ڷ���LM_ComAttrsChanged��Ϣ֪ͨ����
    FAttrsUpdating : boolean;
    // %Notification : ��FClientsɾ��Ҫ�ͷŵ�Client
    procedure   Notification(AComponent: TComponent;
                  Operation: TOperation); override;
    // %PropChanged : ���Ա��ı�ʱ�����á�
    //���UpdatingCount<=0,����OnPropChanged,������UpdateClients
    procedure   PropChanged; virtual;
    // %UpdateIntAttr : �����������͵�����,����ֵ�Ƿ��޸�
    function    UpdateIntAttr(var OldValue : integer;
                  NewValue : integer):boolean;
    // %UpdateBoolAttr : ����Bool���͵�����,����ֵ�Ƿ��޸�
    function    UpdateBoolAttr(var OldValue : boolean;
                  NewValue : boolean):boolean;
    // new 99/06/08
    // %UpdatePersistentAttr : ����TPersistent���͵�����,����ֵ�Ƿ��޸�
    function    UpdatePersistentAttr(StoreObject,NewValue : TPersistent):boolean;
    // %UpdateComponentAttr : ����TComponent���͵�����,����ֵ�Ƿ��޸�
    function    UpdateComponentAttr(var OldValue : TComponent;
                  NewValue : TComponent):boolean;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    procedure   AddClient(Client : TObject);
    procedure   RemoveClient(Client : TObject);
    // %UpdateClients : ʹ����ϢLM_ComAttrsChanged֪ͨ���е�Clients,�����Ѿ��ı�
    procedure   UpdateClients;
    // %BeginUpdate : ���Ӹ��¼���
    procedure   BeginUpdate;
    // %EndUpdate : ���ٸ��¼���,����PropChanged
    procedure   EndUpdate;
    // %OnPropChanged : �������޸�ʱ������
    property    OnPropChanged : TNotifyEvent
                  read FOnPropChanged write FOnPropChanged;
    // %NotifyClients : ʹ��LM_ComAttrsNotify��Ϣ��#NotifyCode֪ͨClients
    procedure   NotifyClients(NotifyCode : LParam);
    // %BroadcastClients : ��Clients�й㲥#msg
    procedure   BroadcastClients(const msg : TMessage);
    // %AttrsUpdating : ���ڷ���LM_ComAttrsChanged��Ϣ֪ͨ����
    property 		AttrsUpdating : boolean read FAttrsUpdating ;
  end;

  { How to use TCompCommonAttrs:
    If AComp.Attrs is TCompCommonAttrs,
   add three methods to AComponent:
    1) AComp.SetAttrs(value : TCompCommonAttrs);
    begin
      if FAttrs=value then exit;
      if FAttrs<>nil then
        FAttrs.removeClient(self);
      FAttrs:= value;
      if FAttrs<>nil then
        FAttrs.AddClient(self);
      repaint; // or something
    end;

    or AComp.SetAttrs(value : TCompCommonAttrs);
    begin
      if SetCommonAttrsProp(self,TCompCommonAttrs(FAttrs),value) then
        repaint; // or something
    end;

    2) AComp.Notification(AComponent: TComponent;
                  Operation: TOperation); override;
    begin
      inherited Notification(AComponent,Operation);
      if (AComponent=FAttrs) and (Operation=opRemove) then
        FAttrs:= nil;
    end;

    3) AComp.LMComAttrsChanged(var message : TMessage);message LM_ComAttrsChanged;
    begin
      if message.WParem=WParam(FAttrs) then
        repaint; // or other codes
    end;
  }

function SetCommonAttrsProp(AOwner : TObject;
  var AttrsProp : TCompCommonAttrs;
      NewValue : TCompCommonAttrs): boolean;

function  GetCtrlText(AControl : TControl): string;

procedure SetCtrlText(AControl : TControl;const Text: string);

implementation

uses TypInfo,TypUtils,safecode,DebugMemory,LibMessages, KSStrUtils;

var
  ReferenceMan : TReferenceMan;

procedure RegisterRefProp(Instance : TComponent; const PropName : string);
begin
  ReferenceMan.RegisterRefProp(Instance,PropName);
end;

procedure ReferTo(RefInstance : TComponent);
begin
  ReferenceMan.ReferTo(RefInstance);
end;

{ TReferenceMan }

constructor TReferenceMan.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClients := TStringList.create;
end;

destructor TReferenceMan.destroy;
begin
  FClients.free;
  inherited destroy;
end;

procedure TReferenceMan.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i : integer;
  ex : Exception;
begin
  ex := nil;
  if Operation<>opRemove then exit;
  repeat
    i := FClients.IndexOfObject(AComponent);
    if i>=0 then FClients.delete(i);
  until i<0;
  for i:=0 to FClients.count-1 do
    try
      if AComponent=GetClassProperty(FClients.objects[i],FClients[i])
       then SetClassProperty(FClients.objects[i],FClients[i],nil);
    except
      On e : Exception do Ex:=e;
    end;
  inherited Notification(AComponent ,Operation);
  if ex<>nil then raise ex;
end;

procedure TReferenceMan.ReferTo(RefInstance: TComponent);
begin
  if RefInstance<>nil then
    RefInstance.freeNotification(self);
end;

procedure TReferenceMan.RegisterRefProp(Instance: TComponent;
  const PropName: string);
var
  PropInfo: PPropInfo;
begin
  if checkProperty(Instance,PropName,
    [tkClass], PropInfo)
    then begin
           FClients.addObject(Propname,Instance);
           Instance.freeNotification(self);
         end
    else RaiseInvalidParam;
end;


var
  MsgFilterManager : TMsgFilterManager;

{ TMsgFilter }

constructor TMsgFilter.Create(AControl: TControl);
begin
  inherited Create;
  //if AControl=nil then RaiseInvalidParam;
  CheckObject(AControl,'Error : Control is nil for TMsgFilter');
  // new add
  AControl.freeNotification(MsgFilterManager);

  Control:=AControl;
  OldWndProc := AControl.WindowProc;
  AControl.WindowProc := WndProc;
  Enabled := true;
  FReleasing := false;
  {$ifdef debug}
  OutputDebugString(pchar('Hook:'+GetDebugText(self)
    + ' On:' +  GetDebugText(AControl)));
  {$endif}
end;

procedure TMsgFilter.DefaultHandler(var Message);
begin
  OldWndProc(TMessage(message));
  //bypass := true;
  //IgnoreMsg(TMessage(message));
end;

destructor TMsgFilter.destroy;
{var
  TheMethod : TWndMethod;
  MyMethod : TWndMethod;}
begin
 { TheMethod := TWndMethod(Control.WindowProc);
  MyMethod := TWndMethod(self.WndProc);
  if (TheMethod.data=MyMethod.data)
  	and (TheMethod.Code=MyMethod.code) then}
  //Control.WindowProc := OldWndProc;
  {$ifdef debug}
  OutputDebugString(pchar('UnHook:'+GetDebugText(self)
    +' On:' +  GetDebugText(Control)));
  {$endif}
  inherited destroy;
end;

function	TMsgFilter.PreHandle(var Message: TMessage) : boolean ;
begin
  result := true;
end;

function TMsgFilter.GetHandle: THandle;
begin
  if control is TWinControl then
    result := (control as TWinControl).handle
  else result:=0 ;
end;

procedure TMsgFilter.WndProc(var Message: TMessage);
var
  instance : TMsgFilter;
begin
  //bypass := false;
  if (message.msg=CM_MsgFilter)
  and (TCMMsgFilter(message).NotifyCode=mf_Releasing) then
  begin
    // ������ͷ���Ϣ����������Ϣ,change the message filter chain
    // ��Message.lparam�а�����һ����Ϣ��������ʵ��
    if FReleasing then
    begin
      // if self is Releasing
      instance := TMsgFilter(Message.lparam);
      if instance=nil then
        // ���û����һ����Ϣ������,ֱ�ӻָ�control.WindowProc
        control.WindowProc := OldWndProc
      else
        // �����޸���һ����Ϣ��������OldWndProc
        instance.oldWndProc := OldWndProc;
      // �����ݵ���һ������������
    end
    // otherwise pass message to next filter with self=lparam
    else
    begin
      message.LParam := longint(self);
      // ���ݵ���һ������������
      DefaultHandler(message);
    end;
    exit;
  end;

  if (message.msg=CM_MsgFilter) and AmI(message) then
  begin
    // �����������Ϣ���������ڲ���Ϣ
    with TCMMsgFilter(message) do
    case NotifyCode of
      // ����Enable/Disable
      mf_enable : enabled := true;
      mf_disable: enabled := false;
      mf_FindReleased :
      	begin
          // ׼���ͷ�
          FReleasing := true;
          // ����mf_releasing��Ϣ���޸�message filter chain
          NotifyCode := mf_releasing;
          message.lparam := longint(nil);
          Control.WindowProc(message);
          // �ͷ��Լ�������Ϣ�з���1
          free;
          message.result := 1;
          // �����ݵ���һ������������
          exit;
        end;
    end;
    // add 99/06/08
    // ���ݵ���һ������������
    DefaultHandler(message);
  end
  // normal message
  else if Enabled then
  begin
    // message Filter
	  if PreHandle(message) then
    	dispatch(message);
  end
  else DefaultHandler(message);
end;

function TMsgFilter.AmI(const message): boolean;
begin
  with TCMMsgFilter(message) do
    AmI := ( subclass and (self is ClassType))
    		or ( not subclass and (self.classtype = ClassType));
end;


function	HookMsgFilter(AControl : TControl; MFClass : TMsgFilterClass):TMsgFilter;
begin
  if (AControl<>nil) and (MFClass<>nil) then
  begin
    result:=MFClass.Create(AControl);
    //AControl.freeNotification(MsgFilterManager);
  end
  else result:=nil;
end;

{
procedure UnhookMsgFilter(AControl : TControl);
var
  AObj : TObject;
  Method : TMethod;
begin
  if (AControl<>nil) then
  begin
	repeat
    Method := TMethod(AControl.WindowProc);
    AObj := Method.data;
    if AObj is TMsgFilter
    	then AObj.free
      else break;
  until false;
  end;
end;
}
{
procedure UnhookMsgFilterAll(AControl : TControl);
begin
  Control.WindowProc := Control.WndProc;
end;
}
procedure UnHookMsgFilter(AControl : TControl; ClassType:TMsgFilterClass);
(*
{$ifdef debug}
var
  s : string;
  r : integer;
{$endif}
*)
begin
  if (AControl<>nil) and (ClassType<>nil) then
  begin
    (*
    {$ifdef debug}
	  s := ClassType.ClassName;
	  r := NotifyMsgFilter(AControl,mf_FindReleased,true,ClassType);
    {$else}
    NotifyMsgFilter(AControl,mf_FindReleased,true,ClassType);
    {$endif}
    *)
    NotifyMsgFilter(AControl,mf_FindReleased,true,ClassType);
  end;
end;

procedure UnHookMsgFilterEx(AControl : TControl; ClassType:TMsgFilterClass; all : boolean);
var
  r : integer;
  {$ifdef debug}
  s : string;
  {$endif}
begin
  if (AControl<>nil) and (ClassType<>nil) then
  begin
    {$ifdef debug}
	  s := ClassType.ClassName;
    {$endif}
    repeat
      r := NotifyMsgFilter(AControl,mf_FindReleased,true,ClassType);
    until not all or (r<>1);
  end;
end;

function	NotifyMsgFilter(AControl : TControl;
  	NotifyCode:word; SubClass : boolean; ClassType:TMsgFilterClass):longint;
begin
  result := AControl.Perform(CM_MsgFilter,makelong(notifyCode,word(subclass)),longint(ClassType));
end;

procedure EnableMsgFilter(AControl : TControl;
  	enabled: boolean; ClassType:TMsgFilterClass);
var
  NotifyCode : word;
begin
  if enabled then NotifyCode:=mf_enable
  else NotifyCode:=mf_disable;
  NotifyMsgFilter(AControl,NotifyCode,true,classtype);
end;

procedure TMsgFilter.EnableChanged;
begin

end;

procedure TMsgFilter.SetEnabled(const Value: boolean);
begin
  if value<> FEnabled then
  begin
    FEnabled := Value;
    EnableChanged;
  end;
end;

{ TMsgFilterManager }

procedure TMsgFilterManager.Notification(AComponent: TComponent;
  Operation: TOperation);
{$ifdef debug }
var
  TheClassName : string;
{$endif}
begin
  {$ifdef debug }
  if AComponent<>nil then TheClassName := AComponent.className;
  {$endif}
  if (AComponent is TControl) and
		 (Operation=opRemove) then
     UnHookMsgFilter(AComponent as TControl,TMsgFilter);
  inherited Notification(AComponent,Operation);
end;

{ TNumberList }

function TNumberList.Add(Item: longword): Integer;
begin
  result := inherited Add(pointer(item));
end;

function TNumberList.GetItems(index: integer): Integer;
begin
  result := integer(inherited items[index]);
end;

function TNumberList.IndexOf(Item: longword): Integer;
begin
  result := inherited Indexof(pointer(item));
end;

function TNumberList.Remove(Item: longword): Integer;
begin
  result := inherited remove(pointer(item));
end;

procedure TNumberList.SetItems(index: integer; const Value: Integer);
begin
  inherited items[index]:=pointer(value);
end;

{ TObjectList }

function	TObjectList.Add(AObject: TObject):integer;
begin
  if AObject<>nil then
  	result:=inherited Add(AObject)
  else
  	result:=-1;  
end;

procedure TObjectList.Clear;
var
  i : integer;
begin
  if Owned then
  begin
    for i:=0 to count-1 do
      TObject(items[i]).free;
  end;
  inherited Clear;
end;

constructor TObjectList.Create(AOwned: boolean=true);
begin
  inherited Create;
  FOwned :=AOwned;
end;

procedure TObjectList.Delete(Index: Integer);
begin
  if (Owned) and (index>0) and (index<count) then
  begin
    TObject(items[index]).free;
  end;
  inherited Delete(Index);
end;

function TObjectList.GetItems(index: integer): TObject;
begin
  result := TObject(inherited items[index]);
end;

procedure TObjectList.SetItems(index: integer; const Value: TObject);
begin
  inherited items[index] := Value;
end;

function TObjectList.Remove(Item: TObject): Integer;
var
  i : integer;
begin
  i := IndexOf(Item);
  delete(i);
  result := i;
end;

procedure CommonGetChildren(Comp : TComponent; Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
begin
  if Root = Comp then
    for I := 0 to Comp.ComponentCount - 1 do
    begin
      OwnedComponent := Comp.Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end;
end;

(*
{ TStringMap }

constructor TStringMap.Create;
begin
  inherited Create(true);
end;

procedure TStringMap.Add(const Name, value: string);
begin
  inherited Add(TStringmapItem.Create(Name, value));
end;

function TStringMap.IndexOfName(const Name: string): integer;
var
  i : integer;
begin
  for i:=0 to count-1 do
  	if (nameCaseSen and (TStringmapItem(items[i]).name=name) )
      or (not nameCaseSen and (CompareText(TStringmapItem(items[i]).name,name)=0))
     then
    begin
      result:=i;
      exit;
    end;
  result := -1;
end;


function TStringMap.IndexOfValue(const value: string): integer;
var
  i : integer;
begin
  for i:=0 to count-1 do
  	if (nameCaseSen and (TStringmapItem(items[i]).Value=Value) )
      or (not nameCaseSen and (CompareText(TStringmapItem(items[i]).Value,Value)=0))
    then
    begin
      result:=i;
      exit;
    end;
  result:=-1;
end;

function TStringMap.GetNameByValue(const Value: string;
  var Name: string): boolean;
var
  i : integer;
begin
  i:=IndexOfvalue(value);
  result:= i>=0;
  if result then name := names[i];
end;

function TStringMap.GetValueByName(const Name: string;
  var Value: string): boolean;
var
  i : integer;
begin
  i:=IndexOfName(name);
  result:= i>=0;
  if result then value:= values[i];
end;

PROCEDURE	TStringMap.GetNamesByValue(const Value: string;
  Names: Tstrings);
var
  i : integer;
begin
  for i:=0 to count-1 do
  	if (nameCaseSen and (TStringmapItem(items[i]).Value=Value) )
      or (not nameCaseSen and (CompareText(TStringmapItem(items[i]).Value,Value)=0))
    then
    begin
      Names.Add(TStringmapItem(items[i]).name);
    end;
end;

procedure	TStringMap.GetValuesByName(const Name: string;
  Values: Tstrings);
var
  i : integer;
begin
  for i:=0 to count-1 do
  	if (nameCaseSen and (TStringmapItem(items[i]).name=name) )
      or (not nameCaseSen and (CompareText(TStringmapItem(items[i]).name,name)=0))
     then
    begin
      Values.Add(TStringmapItem(items[i]).value);
    end;
end;

procedure TStringMap.RemoveName(const Name: string);
var
  i : integer;
begin
  i := IndexOfName(name);
  if i>=0 then delete(i);
end;

procedure TStringMap.RemoveValue(const Value: string);
var
  i : integer;
begin
  i := IndexOfValue(value);
  if i>=0 then delete(i);
end;


function TStringMap.GetNames(index: integer): string;
begin
  result:=TStringMapItem(Items[index]).name;
end;

function TStringMap.GetValues(index: integer): string;
begin
  result:=TStringMapItem(Items[index]).value;
end;

procedure TStringMap.SetNames(index: integer; const Value: string);
begin
  TStringMapItem(Items[index]).name:=value;
end;

procedure TStringMap.SetValues(index: integer; const Value: string);
begin
  TStringMapItem(Items[index]).value:=value;
end;


{ TStringMapItem }

constructor TStringMapItem.Create(const AName, Avalue: string);
begin
  inherited Create;
  Name := AName;
  Value := AValue;
end;


{	TPointerMap	}

constructor TPointerMap.Create;
begin
  inherited Create(true);
end;

procedure TPointerMap.Add(const Name, value: pointer);
begin
  inherited Add(TPointermapItem.Create(Name, value));
end;

function TPointerMap.IndexOfName(const Name: pointer): integer;
var
  i : integer;
begin
  for i:=0 to count-1 do
  	if TPointermapItem(items[i]).name=name then
    begin
      result:=i;
      exit;
    end;
  result := -1;
end;


function TPointerMap.IndexOfValue(const value: pointer): integer;
var
  i : integer;
begin
  for i:=0 to count-1 do
  	if TPointermapItem(items[i]).Value=Value then
    begin
      result:=i;
      exit;
    end;
  result:=-1;
end;

function TPointerMap.GetNameByValue(const Value: pointer;
  var Name: pointer): boolean;
var
  i : integer;
begin
  i:=IndexOfvalue(value);
  result:= i>=0;
  if result then name := names[i];
end;

function TPointerMap.GetValueByName(const Name: pointer;
  var Value: pointer): boolean;
var
  i : integer;
begin
  i:=IndexOfName(name);
  result:= i>=0;
  if result then value:= values[i];
end;

PROCEDURE	TPointerMap.GetNamesByValue(const Value: pointer;
  Names: TList);
var
  i : integer;
begin
  for i:=0 to count-1 do
  	if TPointermapItem(items[i]).Value=Value then
      Names.Add(TPointermapItem(items[i]).name);
end;

procedure	TPointerMap.GetValuesByName(const Name: pointer;
  Values: TList);
var
  i : integer;
begin
  for i:=0 to count-1 do
    if TPointermapItem(items[i]).name=name then
      Values.Add(TPointermapItem(items[i]).value);
end;

procedure TPointerMap.RemoveName(const Name: pointer);
var
  i : integer;
begin
  i := IndexOfName(name);
  if i>=0 then delete(i);
end;

procedure TPointerMap.RemoveValue(const Value: pointer);
var
  i : integer;
begin
  i := IndexOfValue(value);
  if i>=0 then delete(i);
end;


function TPointerMap.GetNames(index: integer): pointer;
begin
  result:=TPointerMapItem(Items[index]).name;
end;

function TPointerMap.GetValues(index: integer): pointer;
begin
  result:=TPointerMapItem(Items[index]).value;
end;

procedure TPointerMap.SetNames(index: integer; const Value: pointer);
begin
  TPointerMapItem(Items[index]).name:=value;
end;

procedure TPointerMap.SetValues(index: integer; const Value: pointer);
begin
  TPointerMapItem(Items[index]).value:=value;
end;

{TPointerMapItem}

constructor TPointerMapItem.Create(const AName, Avalue: pointer);
begin
  inherited Create;
  Name := AName;
  Value := AValue;
end;
*)


{ TMapList }

constructor TMapList.Create(AUniqueName, AUniqueValue: boolean);
begin
  inherited Create(true);
  FUniqueName := AUniqueName;
  FUniqueValue := AUniqueValue;
end;

function TMapList.CheckUniqueName(const Name): boolean;
begin
  result := not FUniqueName or
  					(FUniqueName and (IndexOfName(Name)<0));
end;

function TMapList.CheckUniqueValue(const value): boolean;
begin
  result := not FUniqueValue or
  					(FUniqueValue and (IndexOfValue(value)<0));
end;

procedure TMapList.GetName(index: integer; var name);
begin
  TMapItem(Items[index]).CopyName(name);
end;

function TMapList.GetNameByValue(const Value; var Name): boolean;
var
  i : integer;
begin
  i := IndexOfValue(value);
  result := i>=0;
  if result then GetName(i,name);
end;

procedure TMapList.GetValue(index: integer; var value);
begin
  TMapItem(Items[index]).CopyValue(value);
end;

function TMapList.GetValueByName(const Name; var Value): boolean;
var
  i : integer;
begin
  i := IndexOfName(Name);
  result := i>=0;
  if result then GetValue(i,value);
end;

function TMapList.IndexOfName(const Name): integer;
var
  i : integer;
begin
  for i:=0 to count-1 do
    if TMapItem(Items[i]).CompareName(name)=0 then
    begin
      result:=i;
      exit;
    end;
  result := -1;
end;

function TMapList.IndexOfValue(const value): integer;
var
  i : integer;
begin
  for i:=0 to count-1 do
    if TMapItem(Items[i]).CompareValue(value)=0 then
    begin
      result:=i;
      exit;
    end;
  result := -1;
end;

function TMapList.Add(MapItem:TMapItem): boolean;
begin
  Assert(MapItem<>nil);
  result := CheckUniqueName(MapItem.FNameAddr^)
    and CheckUniqueValue(MapItem.FValueAddr^);
  if result then inherited Add(MapItem);
end;

function TMapList.RemoveName(const Name): boolean;
var
  i : integer;
begin
  i := IndexOfName(name);
  result := i>=0;
  if result then delete(i);
end;

function TMapList.RemoveValue(const Value): boolean;
var
  i : integer;
begin
  i := IndexOfValue(Value);
  result := i>=0;
  if result then delete(i);
end;

function TMapList.Add2(MapItem: TMapItem): boolean;
begin
  result := Add(MapItem);
  if not result then MapItem.free;
end;

function TMapList.FindName(const Name): integer;
var
  i,j,k,cp : integer;
begin
  OutputDebugString(pchar('name:'+string(name)));
  if count<0 then
  begin
    result := -1;
    exit;
  end;
  i:=0;
  j:=Count-1;
  while i<j do
  begin
    k:=(i+j) div 2;
    cp := TMapItem(Items[k]).CompareName(Name);
    if cp=0 then
    begin
      result := k;
      exit;
    end
    else if cp<0 then
      // item[k]<name
      i:=k+1
    else
      // item[k]>name
      j:=k-1;
  end;
  if (i<count) and (TMapItem(Items[i]).CompareName(Name)=0) then
    result:=i
  else result:=-1;
end;

function TMapList.FindValue(const value): integer;
var
  i,j,k,cp : integer;
begin
  if count<0 then
  begin
    result := -1;
    exit;
  end;
  i:=0;
  j:=Count-1;
  while i<j do
  begin
    k:=(i+j) div 2;
    cp := TMapItem(Items[k]).CompareValue(Value);
    if cp=0 then
    begin
      result := k;
      exit;
    end
    else if cp<0 then
      // item[k]<value
      i:=k+1
    else
      // item[k]>value
      j:=k-1;
  end;
  if (i<count) and (TMapItem(Items[i]).CompareValue(Value)=0) then
    result:=i
  else result:=-1;
end;

{ TStringMapItem }

constructor TStringMapItem.Create(AStringMap: TStringMap; const AName,
  Avalue: string);
begin
  inherited Create;
  FStringMap := AStringMap;
  Name := AName;
  Value := AValue;
end;

procedure TStringMapItem.CopyName(var Aname);
begin
  String(AName):=name;
end;

procedure TStringMapItem.CopyValue(var Avalue);
begin
  string(Avalue):=Value;
end;

function TStringMapItem.CompareName(const AName): integer;
begin
  if FStringMap.nameCaseSen then
    result := CompareStr(Name,String(Aname))
  else result :=CompareText(name,String(AName));
end;

function TStringMapItem.CompareValue(const AValue): integer;
begin
  if FStringMap.ValueCaseSen then
    result := CompareStr(Value,String(Avalue))
  else result := CompareText(Value,string(AValue));
end;

function TStringMapItem.FNameAddr: pointer;
begin
  result := @Name;
end;

function TStringMapItem.FValueAddr: pointer;
begin
  result := @Value;
end;

{ TStringMap }

constructor TStringMap.Create(AUniqueName,AUniqueValue : boolean);
begin
  inherited Create(AUniqueName,AUniqueValue);
end;

function TStringMap.Add(const Name, value: string): boolean;
var
  StringMapItem : TStringMapItem;
begin
  StringMapItem := TStringMapItem.Create(self,Name,value);
  //result := inherited Add(StringMapItem);
  //if not result then StringMapItem.free;
  result := inherited Add2(StringMapItem);
end;

function TStringMap.GetNames(index: integer): string;
begin
  result := TStringMapItem(Items[index]).name;
end;

function TStringMap.GetValues(index: integer): string;
begin
  result := TStringMapItem(Items[index]).value;
end;

procedure TStringMap.SetNames(index: integer; const Value: string);
begin
  TStringMapItem(Items[index]).name := Value;
end;

procedure TStringMap.SetValues(index: integer; const Value: string);
begin
  TStringMapItem(Items[index]).value := value;
end;

function TStringMap.FindNearestName(const name: string): integer;
var
  i : integer;
  MaxMatchIndex,MaxMatchChars:integer;
  Match : integer;
begin
  if count<0 then
  begin
    result:=-1;
    Exit;
  end;
  MaxMatchIndex := 0;
  MaxMatchChars := 0;
  for i:=0 to count-1 do
    if StringMarch(pchar(name),pchar(names[i]),match) then
    begin
      MaxMatchIndex:= i;
      break;
    end
    else if Match>MaxMatchChars then
          begin
            MaxMatchIndex:= i;
            MaxMatchChars:= Match;
          end;
  result :=  MaxMatchIndex;
end;

function TStringMap.FindNearestValue(const Value: string): integer;
var
  i : integer;
  MaxMatchIndex,MaxMatchChars:integer;
  Match : integer;
begin
  if count<0 then
  begin
    result:=-1;
    Exit;
  end;
  MaxMatchIndex := 0;
  MaxMatchChars := 0;
  for i:=0 to count-1 do
    if StringMarch(pchar(value),pchar(values[i]),match) then
    begin
      MaxMatchIndex:= i;
      break;
    end
    else if Match>MaxMatchChars then
          begin
            MaxMatchIndex:= i;
            MaxMatchChars:= Match;
          end;
  result :=  MaxMatchIndex;
end;

function TStringMap.AddItem(const Name, value: string): TStringMapItem;
begin
  result := TStringMapItem.Create(self,Name,value);
  //result := inherited Add(StringMapItem);
  //if not result then StringMapItem.free;
  if not (inherited Add2(result)) then
    result := nil;
end;

{ TPointerMapItem }

constructor TPointerMapItem.Create(AName, Avalue: pointer);
begin
  inherited Create;
  Name := AName;
  Value := AValue;
end;

procedure TPointerMapItem.CopyName(var Aname);
begin
  pointer(AName) := Name;
end;

procedure TPointerMapItem.CopyValue(var Avalue);
begin
  pointer(AValue):=value;
end;

function TPointerMapItem.CompareName(const AName): integer;
begin
  result := integer(Name)-integer(pointer(AName));
end;

function TPointerMapItem.CompareValue(const AValue): integer;
begin
  result := integer(value)-integer(pointer(AValue));
end;

function TPointerMapItem.FNameAddr: pointer;
begin
  result := @Name;
end;

function TPointerMapItem.FValueAddr: pointer;
begin
  result := @Value;
end;

{ TPointerMap }

function TPointerMap.Add(const Name, value: pointer): boolean;
begin
  result := Inherited Add2(TPointerMapItem.Create(Name,Value));
end;

function TPointerMap.GetNames(index: integer): pointer;
begin
  result := TPointerMapItem(Items[index]).name;
end;

function TPointerMap.GetValues(index: integer): pointer;
begin
  result := TPointerMapItem(Items[index]).value;
end;

procedure TPointerMap.SetNames(index: integer; const Value: pointer);
begin
  TPointerMapItem(Items[index]).name := Value;
end;

procedure TPointerMap.SetValues(index: integer; const Value: pointer);
begin
  TPointerMapItem(Items[index]).value := value;
end;

{ TStrIntMapItem }

constructor TStrIntMapItem.Create(const AName: string; Avalue: integer);
begin
  inherited Create;
  Name := AName;
  Value := AValue;
end;

procedure TStrIntMapItem.CopyName(var Aname);
begin
  string(AName) := Name;
end;

procedure TStrIntMapItem.CopyValue(var Avalue);
begin
  integer(AValue) := value;
end;

function TStrIntMapItem.CompareName(const AName): integer;
begin
  result := CompareText(Name,string(AName));
end;

function TStrIntMapItem.CompareValue(const AValue): integer;
begin
  result := value-Integer(AValue);
end;

function TStrIntMapItem.FNameAddr: pointer;
begin
  result := @Name;
end;

function TStrIntMapItem.FValueAddr: pointer;
begin
  result := @Value;
end;

{ TStrIntMap }

function TStrIntMap.Add(const Name: string; value: integer): boolean;
begin
  result := inherited Add2(TStrIntMapItem.Create(Name,Value));
end;

procedure TStrIntMap.CopyToStrings(AStrings: TSTrings);
var
  i : integer;
begin
  for i:=0 to count-1 do
  with TStrIntMapItem(Items[i]) do
    AStrings.AddObject(Name,TObject(Value));
end;

{ TCompCommonAttrs }

constructor TCompCommonAttrs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClients := TList.Create;
  FUpdatingCount := 0;
end;

destructor TCompCommonAttrs.destroy;
begin
  FClients.free;
  FClients := nil;
  inherited destroy;
end;

procedure TCompCommonAttrs.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if Operation=opRemove then
    RemoveClient(AComponent);
end;

procedure TCompCommonAttrs.PropChanged;
begin
  if FUpdatingCount<=0 then
  begin
    if Assigned(FOnPropChanged) then
      FOnPropChanged(self);
    UpdateClients;
  end;
end;

procedure TCompCommonAttrs.AddClient(Client: TObject);
begin
  if (Client<>nil) and
    (FClients.IndexOf(Client)<0) then
  begin
    FClients.Add(Client);
    if Client is TComponent then
      TComponent(Client).FreeNotification(self);
  end;
end;

procedure TCompCommonAttrs.RemoveClient(Client: TObject);
begin
  if FClients<>nil then
    FClients.Remove(Client);
end;

procedure TCompCommonAttrs.UpdateClients;
var
  //i : integer;
  msg : TMessage;
begin
  FUpdatingCount := 0;
  {for i:=0 to FClients.Count-1 do
    if TComponent(FClients[i]) is TControl then
      TControl(FClients[i]).Perform(
        LM_ComAttrsChanged,
        integer(self),0)
    else
    begin
      msg.Msg := LM_ComAttrsChanged;
      msg.WParam := integer(self);
      msg.lparam := 0;
      msg.result := 0;
      TComponent(FClients[i]).dispatch(msg);
    end;}
  FAttrsUpdating := true;
  msg.Msg := LM_ComAttrsChanged;
  msg.WParam := Wparam(self);
  msg.LParam := 0;
  BroadcastClients(msg);
  FAttrsUpdating := false;
end;

function  TCompCommonAttrs.UpdateIntAttr(var OldValue : integer;
                  NewValue : integer):boolean;
begin
  result := OldValue<>NewValue;
  if result then
  begin
    OldValue:=NewValue;
    PropChanged;
  end;
end;

function  TCompCommonAttrs.UpdateBoolAttr(var OldValue : boolean;
                  NewValue : boolean):boolean;
begin
  result := OldValue<>NewValue;
  if result then
  begin
    OldValue:=NewValue;
    PropChanged;
  end;
end;

function TCompCommonAttrs.UpdatePersistentAttr(StoreObject,
  NewValue: TPersistent): boolean;
begin
  result := StoreObject<>NewValue;
  if result then
  begin
    StoreObject.Assign(NewValue);
    PropChanged;
  end;
end;

function TCompCommonAttrs.UpdateComponentAttr(var OldValue: TComponent;
  NewValue: TComponent): boolean;
begin
  result := OldValue<>NewValue;
  if result then
  begin
    OldValue:=NewValue;
    if NewValue<>nil then
      NewValue.FreeNotification(self);
    PropChanged;
  end;
end;

procedure TCompCommonAttrs.BeginUpdate;
begin
  inc(FUpdatingCount);
end;

procedure TCompCommonAttrs.EndUpdate;
begin
  dec(FUpdatingCount);
  PropChanged;
end;

procedure TCompCommonAttrs.BroadcastClients(const msg: TMessage);
var
  msg2 : TMessage;
  i : integer;
begin
  for i:=0 to FClients.Count-1 do
    if TObject(FClients[i]) is TControl then
      TControl(FClients[i]).Perform(
        msg.Msg,msg.WParam,Msg.LParam)
    else
    begin
    // avoid that msg be changed
      msg2 := msg;
      TObject(FClients[i]).dispatch(msg2);
    end;
end;

procedure TCompCommonAttrs.NotifyClients(NotifyCode: LParam);
var
  msg : TMessage;
begin
  msg.Msg := LM_ComAttrsNotify;
  msg.WParam := WParam(self);
  msg.LParam := NotifyCode;
  BroadcastClients(msg);
end;

function SetCommonAttrsProp(AOwner : TObject;
  var AttrsProp : TCompCommonAttrs;
      NewValue : TCompCommonAttrs): boolean;
begin
  result := AttrsProp<>Newvalue;
  if result then
  begin
    if AttrsProp<>nil then
        AttrsProp.removeClient(AOwner);
    AttrsProp:= Newvalue;
    if AttrsProp<>nil then
        AttrsProp.AddClient(AOwner);
  end;
end;

type
  TControlAccess=class(TControl);

function  GetCtrlText(AControl : TControl): string;
begin
  assert(AControl<>nil);
  result:=TControlAccess(AControl).text;
end;

procedure SetCtrlText(AControl : TControl;const Text: string);
begin
  assert(AControl<>nil);
  TControlAccess(AControl).text:=text;
end;

function  ConvertNameToAlias(const FileName:string;
            var Alias:string;
            AliasList : TStringMap): boolean;
var
  i : integer;
  MaxMatch : integer;
  MatchIndex : integer;
begin
  assert(AliasList<>nil);
  MaxMatch := 0;
  MatchIndex := -1;
  for i:=0 to AliasList.count-1 do
  begin
    if length(AliasList.Values[i])>MaxMatch then
    begin
      if StartWith(FileName,AliasList.Values[i]) then
      begin
        MaxMatch := Length(AliasList.Values[i]);
        MatchIndex := i;
      end;
    end;
  end;
  if MaxMatch>0 then
  begin
    result := true;
    Alias := format('$(%s)%s',[AliasList.Names[MatchIndex],
      copy(FileName,MaxMatch+1,length(FileName)-MaxMatch)]);
  end
  else
  begin
    result := false;
    Alias := FileName;
  end;
end;


initialization
  ReferenceMan := TReferenceMan.create(nil);
  MsgFilterManager := TMsgFilterManager.create(nil);
  CM_MsgFilter := registerWindowMessage('CM_MsgFilter');
  CheckNotZero(CM_MsgFilter);
finalization
  MsgFilterManager.free;
  ReferenceMan.free;
end.
