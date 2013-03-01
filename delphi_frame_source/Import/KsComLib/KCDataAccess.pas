unit KCDataAccess;

interface

uses Windows,Classes,IntfUtils, DBAIntf, Listeners, DBAHelper, KCDataPack, BDAImpEx;

const
  // ��־���
  lcKCDataset = 12;
  lcKCDatasetDetail = 19;
  
  OneSecond = 1000;
  OneMinute = 60*OneSecond;

  MinCheckTimeOut         = 5;    // ��������Ƿ񵽴����С�ĳ�ʱʱ��(����)
  DefaultCheckDataTimeOut = OneSecond;  // ȱʡ�ļ�������Ƿ񵽴�ĳ�ʱʱ��(����)
  DefaultTryReceiveCount  = 2;    // ��������ʱ��ȱʡ���ԵĴ���
  DefaultTryReceiveTimeOut= OneSecond; // ��������ʱ��,������յ��ĵ�һ�����Ǵ���ģ����ҳ��Դ�������1����������ÿ�γ�ʱ��ʱ��(����)

type
  EKCAccess = class(EDBAIntfHelper);

  TKCAccess = class;

  TKCPackageBuffer = array[0..MAXPACKAGESIZE-1] of Byte;

  TDoProgressEvent = procedure (Sender : TObject; TryCount : Integer; var ContinueReceive : Boolean) of object;
  TWaitDataEvent = procedure (Sender : TObject; var ContinueWait : Boolean) of object;

  {
    <Class>TKCAccess
    <What>ʵ��ͨ�����˴�ͨѶƽ̨��һ���ض��İ��ṹ�������ݿ�Ķ���ʵ���˹ؼ��Ľ�ڡ�
    <Properties>
      UserID - ���ڱ�־��¼�û���ID
      DestNo - Ŀ�ķ��������
      FuncNo - �����ܺ�
      Priority-ͨѶ���ȼ�
      Timeout - ��������ʱ��ĳ�ʱ�����룩
      SleepBetweenReceive - ����ܵ�һ���հ������򽫼��������հ���ֱ��������Ϊֹ�������Թ涨�����δ���֮��ļ��ʱ��(����)
        �����̨�ڴ���һ����ʱ��Ĳ�ѯ��ʱ�򣬿����ȷ���һЩ�հ�����ʾ������
      IsCallback - �ڽ������ݵ�ʱ���Ƿ���ûص�����ʽ�����ϼ�������Ƿ񵽴ͬʱ�ص�OnWait��
      MaxTryReceiveCount - ��������ʱ��ȱʡ���ԵĴ�����
        ����1��ʾ����ܵ���һ�����ݰ�����ȷ�����ٳ��Լ����������ݡ�
        ����1����ʾ�������Խ��յĴ�����
      TryReceiveTimeOut - ��������ʱ��,������յ��ĵ�һ�����Ǵ���ģ����ҳ��Դ�������1����������ÿ�γ�ʱ��ʱ��(����)
        ���ʱ����Ա�Timeout�����Խ���ķ��������޷���ȷ���
      CheckDataTimeOut - �ڻص�ģʽ��ÿ�μ�������Ƿ񵽴�ĳ�ʱʱ��(����)
    <Methods>
      -
    <Event>
      OnDoProgress - ����ܵ�һ���հ������򽫼��������հ���ֱ��������Ϊֹ��
        ���¼������δ���֮��ı����ã��������ڸ�����Ļ��ʾ��
        �����̨�ڴ���һ����ʱ��Ĳ�ѯ��ʱ�򣬿����ȷ���һЩ�հ�����ʾ������
      OnWait       - �ڻص�ģʽ��������Ƿ񵽴��ʱ�򱻵��ã��������ڸ�����Ļ��ʾ��
      AfterReceive - �ڽ������ݰ���ǰ������
      BeforeReceive- �ڽ������ݰ��Ժ󱻵���
  }
  TKCAccess = class(TDBAIntfHelper)
  private
    FHandle: THandle;
    FGatewayIP: string;
    FGatewayEncode: Word;
    FGatewayPort: Word;
    FReceiveBuffer : TKCPackageBuffer;
    FSendBuffer : TKCPackageBuffer;
    FReceiveHead : PSTDataHead;
    FReceiveBody : PByte;
    FSendHead : PSTDataHead;
    FSendBody : PByte;
    FReturn : Integer;
    FSendBindingIndexs : TList;
    FSendBindingOffsets : TList;
    FSendBodySize : Integer;
    FSendBufferReady : Boolean;
    FReceiveBufferReady : Boolean;
    FRecordCountInPackage : Integer;
    FHaveMorePackage : Boolean;
    FRecordIndexInPackage : Integer;
    FRecordBuffer : PByte;
    FNextRecordBuffer : PByte;
    FHaveVarCharFields : Boolean;
    FVarFieldStartIndex : Integer;
    FFixedRecordSize : Integer;
    FVarRecordSize : Integer;
    FReceiveBindingIndexs : TList;
    FReceiveBindingOffsets : TList;
    FReceiveBindingDataSizes : TList;
    FLastCmdCount : Integer;
    FPriority: Byte;
    FDestNo: Word;
    FFuncNo: Word;
    FUserID: Integer;
    FTimeout: LongWord;
    FSleepBetweenReceive: Integer;
    FOnDoProgress: TDoProgressEvent;
    FCookie : TSTCookie;
    FOnWait: TWaitDataEvent;
    FIsCallback: Boolean;
    FPackageCounter : LongWord;
    FAfterReceive: TNotifyEvent;
    FBeforeReceive: TNotifyEvent;
    FReceiving : Boolean;
    FMaxTryReceiveCount: Longword;
    FCheckDataTimeOut: Longword;
    FTryReceiveTimeOut: Longword;
    FWaitingFirstReturn : Boolean;
    FGatewayIP2: string;
    FGatewayPort2: Word;
    FConnectedIP: string;
    FConnectedPort: Word;
    procedure   CheckAPICall(Result : Boolean; const APIName:string);
    procedure   SendPackage(BufferSize : Integer);
    procedure   InternalRecievePackage(AnalysePackage : Boolean=True);
    procedure   RecievePackage(AnalysePackage : Boolean=True);
    procedure   CreateFields;
    procedure   CalculateVarParts;
    procedure   GetMorePackage;
    procedure   DoProgress(TryCount : Integer; var ContinueReceive : Boolean);
    procedure   DoWait(var ContinueWait : Boolean);
    procedure   ClearCookie;
    procedure   DumpSendBuffer;
    procedure   DumpReceiveBuffer;
    {$ifdef debug }
    procedure   DumpBuffer(Buffer : PByte);
    {$endif}
  protected
    property    Handle : THandle read FHandle;
    // InternalDoConnect be called when connect to server
    procedure   InternalDoConnect; override;
    // InternalDoDisConnect be called when disconnect to server
    procedure   InternalDoDisConnect; override;
    // InternalGetFieldCount be called when current response is a dataset
    function    InternalGetFieldCount : Integer; override;
    // InternalGetOutputCount be called when current response is a output
    function    InternalGetOutputCount : Integer; override;
    // InternalCancelResponse be called when user want not to get more response data.
    procedure   InternalCancelResponse; override;
    // InternalExec;
    procedure   InternalExec; override;
    // InternalExecRPC;
    procedure   InternalExecRPC; override;
    // produceResponseQueue;
    procedure   produceResponseQueue; override;
  public
    constructor Create(Counting : boolean=false);
    destructor  Destroy;override;
    property    GatewayIP : string read FGatewayIP write FGatewayIP;
    property    GatewayIP2 : string read FGatewayIP2 write FGatewayIP2;
    property    GatewayPort : Word read FGatewayPort write FGatewayPort;
    property    GatewayPort2 : Word read FGatewayPort2 write FGatewayPort2;
    property    GatewayEncode : Word read FGatewayEncode write FGatewayEncode;

    property    ConnectedIP : string read FConnectedIP;
    property    ConnectedPort : Word read FConnectedPort;

    // call
    { TODO : ��ʱ��֧������䳤�Ĳ�����Ҫ֧������䳤�Ĳ����������Ȱ����ݱ����ڽṹ���棬���ѹ���� }
    procedure   BeginDefineParam;
    function    AddParam(BindIndex : Integer):Integer; overload;
    function    AddParam(const BindName : string):Integer; overload;
    procedure   EndDefineParam;
    function    ParamCount : Integer;
    procedure   SetParamValue(ParamIndex : Integer; const Value : Byte); overload;
    procedure   SetParamValue(ParamIndex : Integer; const Value : Longint); overload;
    procedure   SetParamValue(ParamIndex : Integer; const Value : string); overload;
    procedure   SetParamValue(ParamIndex : Integer; const Value : Double); overload;
    procedure   CallGateway(RequestType : Integer);

    property    UserID : Integer read FUserID write FUserID;
    property    DestNo : Word read FDestNo write FDestNo;
    property    FuncNo : Word read FFuncNo write FFuncNo;
    property    Priority : Byte read FPriority write FPriority default 2;
    property    Timeout : LongWord read FTimeout write FTimeout default OneMinute;
    property    SleepBetweenReceive : Integer read FSleepBetweenReceive write FSleepBetweenReceive default OneSecond;
    property    IsCallback : Boolean read FIsCallback write FIsCallback default False;
    property    MaxTryReceiveCount : Longword read FMaxTryReceiveCount write FMaxTryReceiveCount default DefaultTryReceiveCount;
    property    TryReceiveTimeOut : Longword read FTryReceiveTimeOut write FTryReceiveTimeOut default DefaultTryReceiveTimeOut;
    property    CheckDataTimeOut : Longword read FCheckDataTimeOut write FCheckDataTimeOut default DefaultCheckDataTimeOut;
    property    OnDoProgress : TDoProgressEvent read FOnDoProgress write FOnDoProgress;
    property    OnWait : TWaitDataEvent read FOnWait write FOnWait;
    property    AfterReceive : TNotifyEvent read FAfterReceive write FAfterReceive;
    property    BeforeReceive : TNotifyEvent read FBeforeReceive write FBeforeReceive;

    // for interface
    function    rawDataToStd(rawType : integer; rawBuffer : pointer; rawSize : integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:integer):integer; override;
    function    stdDataToRaw(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer; override;
    function    nextRow : Boolean; override;
    procedure   getFieldDef(index : integer; FieldDef : TDBFieldDef); override;
    function    fieldName(index : Integer) : string; override;
    function    FieldType(index : integer) : integer; override;
    function    FieldSize(index : integer) : integer; override;
    function    FieldIndex(afieldName:pchar): integer; override;
    function    FieldDataLen(index : integer) : integer; override;
    function    readData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer; override;
    function    readRawData(index : Integer; buffer : pointer; buffersize : Integer) : Integer; override;
    function    isNull(index:integer): boolean; override;
    procedure   getOutputDef(index : integer; FieldDef : TDBFieldDef); override;
    function    readOutput(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer; override;
    function    readRawOutput(index : Integer; buffer : pointer; buffersize : Integer) : Integer; override;
    function    outputIsNull(index : Integer): boolean; override;
    function    readReturn(buffer : pointer; buffersize : Integer) : Integer; override;
    function    returnValue : integer; override;
    procedure   initRPC(rpcname : String; flags : Integer); override;
    procedure   setRPCParam(name : String; mode : TDBParamMode; datatype : TDBFieldType;
                  size : Integer; length : Integer; value : pointer; rawType : Integer); override;
  end;

  TKCDatabase = class(THDatabase)
  private
    FPriority: Byte;
    FUserID: Integer;
    FFuncNo: Word;
    FDestNo: Word;
    FGatewayIP: string;
    FGatewayEncode: Word;
    FGatewayPort: Word;
    FOnDoProgress: TDoProgressEvent;
    FTimeout: Integer;
    FSleepBetweenReceive: Integer;
    FOnWait: TWaitDataEvent;
    FIsCallback: Boolean;
    FBeforeReceive: TNotifyEvent;
    FAfterReceive: TNotifyEvent;
    FMaxTryReceiveCount: Longword;
    FCheckDataTimeOut: Longword;
    FTryReceiveTimeOut: Longword;
    FGatewayIP2: string;
    FGatewayPort2: Word;
    procedure   DoProgress(Sender : TObject; TryCount : Integer; var ContinueReceive : Boolean);
    procedure   DoWait(Sender : TObject; var ContinueWait : Boolean);
  protected
    function    newDBAccess : IDBAccess; override;
  public
    constructor Create(AOwner : TComponent); override;
    function    getDBAccess : IDBAccess; override;
    procedure   notUseDBAccess(aDBAccess : IDBAccess); override;
  published
    property    GatewayIP : string read FGatewayIP write FGatewayIP;
    property    GatewayIP2 : string read FGatewayIP2 write FGatewayIP2;
    property    GatewayPort : Word read FGatewayPort write FGatewayPort;
    property    GatewayPort2 : Word read FGatewayPort2 write FGatewayPort2;
    property    GatewayEncode : Word read FGatewayEncode write FGatewayEncode;
    property    DestNo : Word read FDestNo write FDestNo;
    property    FuncNo : Word read FFuncNo write FFuncNo;
    property    Priority : Byte read FPriority write FPriority  default 2;
    property    UserID : Integer read FUserID write FUserID;
    property    Timeout : Integer read FTimeout write FTimeout default OneMinute;
    property    SleepBetweenReceive : Integer read FSleepBetweenReceive write FSleepBetweenReceive default OneSecond;
    property    IsCallback : Boolean read FIsCallback write FIsCallback default False;
    property    MaxTryReceiveCount : Longword read FMaxTryReceiveCount write FMaxTryReceiveCount default DefaultTryReceiveCount;
    property    TryReceiveTimeOut : Longword read FTryReceiveTimeOut write FTryReceiveTimeOut default DefaultTryReceiveTimeOut;
    property    CheckDataTimeOut : Longword read FCheckDataTimeOut write FCheckDataTimeOut default DefaultCheckDataTimeOut;
    property    Connected;
    property    MaxConnection;
    property    MinConnection;
    property    OnDoProgress : TDoProgressEvent read FOnDoProgress write FOnDoProgress;
    property    OnWait : TWaitDataEvent read FOnWait write FOnWait;
    property    AfterReceive : TNotifyEvent read FAfterReceive write FAfterReceive;
    property    BeforeReceive : TNotifyEvent read FBeforeReceive write FBeforeReceive;
    property    OnConnected;
    property    OnDisConnected;
  end;

  TDatasetCallback = (cbSetByDatabase, cbNotCallBack, cbCallBack);

  TKCDataset = class(THCustomDataset)
  private
    FRequestType: Integer;
    FParams: THRPCParams;
    FReturnCode: Integer;
    FTimeout: Integer;
    FSleepBetweenReceive: Integer;
    FOnDoProgress: TDoProgressEvent;
    FFuncNo: Word;
    FOnWait: TWaitDataEvent;
    FBeforeReceive: TNotifyEvent;
    FAfterReceive: TNotifyEvent;
    FIsCallback: TDatasetCallback;
    FPriority: Byte;
    procedure   BindingParams(KCAccess : TKCAccess);
    procedure   SetParams(const Value: THRPCParams);
    procedure   DoProgress(Sender : TObject; TryCount : Integer; var ContinueReceive : Boolean);
    procedure   DoWait(Sender : TObject; var ContinueWait : Boolean);
    procedure   DoBeforeReceive(Sender : TObject);
    procedure   DoAfterReceive(Sender : TObject);
  protected
    procedure   InternalExec;  override;
    procedure   CloseDBAccess; override;
    function    ValidDatabase(const Value: THDatabase) : Boolean; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    property    ReturnCode : Integer read FReturnCode;
  published
    property    FuncNo : Word read FFuncNo write FFuncNo default 0;
    property    RequestType : Integer read FRequestType write FRequestType;
    property    Params: THRPCParams read FParams write SetParams;
    property    Timeout : Integer read FTimeout write FTimeout default -1;
    property    Priority : Byte read FPriority write FPriority  default 0;
    property    SleepBetweenReceive : Integer read FSleepBetweenReceive write FSleepBetweenReceive default -1;
    property    IsCallback : TDatasetCallback read FIsCallback write FIsCallback default cbSetByDatabase;
    property    OnDoProgress : TDoProgressEvent read FOnDoProgress write FOnDoProgress;
    property    OnWait : TWaitDataEvent read FOnWait write FOnWait;
    property    AfterReceive : TNotifyEvent read FAfterReceive write FAfterReceive;
    property    BeforeReceive : TNotifyEvent read FBeforeReceive write FBeforeReceive;
  end;

procedure RaiseKCAccessError(const FormatStr : string; const Args: array of const); overload;

procedure RaiseKCAccessError(const Msg : string); overload;

procedure KCAccessCheck(OK : Boolean; const FormatStr : string; const Args: array of const); overload;

procedure KCAccessCheck(OK : Boolean; const Msg : string); overload;

{$ifdef TestPackError }
var
  TestPackError : Boolean= False;
{$endif}

implementation

uses SysUtils, DRTPAPI, LogFile, SafeCode;

resourcestring
  EAPICallFail      = '����%sʧ��:%s';
  ECannotLoadDLL    = '�޷�װ��DRTPAPI.DLL����';
  EBindParam        = '��Ч�İ󶨲���%s';
  EBindParam2       = '��Ч�İ󶨲���%d';
  EDuplicateBind    = '�ظ��󶨲���%d';
  EBindDataTypeError= '�������ʹ���(%s)';
  EInvalidHandle    = '��Ч�ľ��';
  EUserCanceled     = '�û�ȡ�����շ�������';
  ETimeout          = '�޷����յ���������';
  EBadPackage       = '�������ݲ���ȷ';
  EInvalidDataType  = '�������Ͳ���ȷ';
  EInvalidDatabase  = '��Ч�����ݿ����';
  EBadFlag          = '����ȷ�ı��ı�־';
  EBadData          = 'ϵͳ���󣬴������%d';

procedure RaiseKCAccessError(const FormatStr : string; const Args: array of const); overload;
begin
  raise EKCAccess.CreateFmt(FormatStr, Args);
end;

procedure RaiseKCAccessError(const Msg : string); overload;
begin
  raise EKCAccess.Create(Msg);
end;

procedure KCAccessCheck(OK : Boolean; const FormatStr : string; const Args: array of const); overload;
begin
  if not OK then
    RaiseKCAccessError(FormatStr,Args);
end;

procedure KCAccessCheck(OK : Boolean; const Msg : string); overload;
begin
  if not OK then
    RaiseKCAccessError(Msg);
end;

{ TKCAccess }

constructor TKCAccess.Create(Counting : boolean=false);
begin
  KCAccessCheck(DRTPAPI.DLLLoaded,ECannotLoadDLL);
  inherited;
  FReceiveHead := PSTDataHead(@FReceiveBuffer[0]);
  FReceiveBody := PByte(FReceiveHead);
  Inc(FReceiveBody,SizeOf(FReceiveHead^));
  FSendHead := PSTDataHead(@FSendBuffer[0]);
  FSendBody := PByte(FSendHead);
  FSendBindingIndexs := TList.Create;
  FSendBindingOffsets := TList.Create;
  FReceiveBindingIndexs := TList.Create;
  FReceiveBindingOffsets := TList.Create;
  FReceiveBindingDataSizes := TList.Create;
  FSendBufferReady := False;
  FReceiveBufferReady := False;
  FTimeout := OneMinute;
  FSleepBetweenReceive := OneSecond;
  FIsCallback := False;
  FPackageCounter := 0;
  FPriority := 2;
  FMaxTryReceiveCount := DefaultTryReceiveCount;
  FCheckDataTimeOut := DefaultCheckDataTimeOut;
  FTryReceiveTimeOut := DefaultTryReceiveTimeOut;
  Inc(FSendBody,SizeOf(FSendHead^));
  FGatewayIP := '';
  FGatewayIP2 := '';
  FGatewayEncode := 0;
  FGatewayPort := 0;
  FGatewayPort2 := 0;
  ClearCookie;
end;

destructor TKCAccess.Destroy;
begin
  inherited;
  FreeAndNil(FSendBindingIndexs);
  FreeAndNil(FSendBindingOffsets);
  FreeAndNil(FReceiveBindingIndexs);
  FreeAndNil(FReceiveBindingOffsets);
  FreeAndNil(FReceiveBindingDataSizes);
end;

procedure TKCAccess.InternalDoConnect;

  procedure DoConnect(const AIP : string; APort : Word);
  begin
    FConnectedIP := AIP;
    FConnectedPort := APort;
    WriteLog(Format('IP=%s,Port=%d,Encode=%d',[FConnectedIP,FConnectedPort,GatewayEncode]),lcKCDataset);
    FHandle := DRTPConnect(PChar(FConnectedIP),FConnectedPort,GatewayEncode);
  end;

begin
  DoConnect(GatewayIP,GatewayPort);
  if (FHandle=0) and (GatewayIP2<>'') then
    DoConnect(GatewayIP2,GatewayPort2);
  FConnected := FHandle<>0;
  CheckAPICall(FConnected,'DRTPConnect');
end;

procedure TKCAccess.InternalDoDisConnect;
begin
  if Handle<>0 then
    DRTPClose(Handle);
  FHandle := 0;
end;

procedure TKCAccess.CheckAPICall(Result: Boolean; const APIName: string);
var
  ErrorMsg : array[0..255] of char;
  Msg : string;
begin
  if not Result then
  begin
    if Handle<>0 then
    begin
      FillChar(ErrorMsg,SizeOf(ErrorMsg),0);
      DRTPGetLastError(Handle,PChar(@ErrorMsg),SizeOf(ErrorMsg)-1);
      Msg := PChar(@ErrorMsg);
    end else
      Msg := '';
    try
      WriteLog(Format('%s fail, close TKCAccess',[APIName]),lcKCDataset);
      Connected := False;
    except
      WriteException;
    end;
    raise EKCAccess.Create(Format(EAPICallFail,[APIName,Msg]));
  end;
end;

// call
procedure TKCAccess.BeginDefineParam;
begin
  DoBeforeExecute;
  FSendBindingIndexs.Clear;
  FSendBindingOffsets.Clear;
  FReceiveBindingIndexs.Clear;
  FReceiveBindingOffsets.Clear;
  FReceiveBindingDataSizes.Clear;
  FillChar(FSendBuffer,SizeOf(FSendBuffer),0);
  FillChar(FReceiveBuffer,SizeOf(FReceiveBuffer),0);
  FSendBufferReady := False;
  FReceiveBufferReady := False;
  //KCClearParamBits(FSendHead^.ParamBits);
end;

function TKCAccess.AddParam(const BindName: string): Integer;
var
  I : Integer;
begin
  for I:=0 to PARAMBITS-1 do
  begin
    if SameText(BindName,KCPackDataNames[I]) then
    begin
      Result := AddParam(I);
      Exit;
    end;
  end;
  Result := -1;
  RaiseKCAccessError(EBindParam,[BindName]);
end;

function TKCAccess.AddParam(BindIndex: Integer): Integer;
begin
  KCAccessCheck(
    not (KCPackDataTypes[BindIndex] in [kcEmpty,kcVarChar]),
    EBindParam2,
    [BindIndex]);
  KCAccessCheck(
    FSendBindingIndexs.IndexOf(Pointer(BindIndex))<0,
    EDuplicateBind,
    [BindIndex]);
  Result := FSendBindingIndexs.Add(Pointer(BindIndex));
  FSendBindingOffsets.Add(Pointer(0));
end;

procedure TKCAccess.EndDefineParam;
var
  I,J : Integer;
  BindIndex : Integer;
  ByteIndex : Integer;
  Mask : Byte;
begin
  FSendBodySize := 0;
  Assert(FSendBindingIndexs.Count=FSendBindingOffsets.Count);
  for I:=0 to FSendBindingIndexs.Count-1 do
  begin
    BindIndex := Integer(FSendBindingIndexs[I]);
    ByteIndex := BindIndex div BITSPERBYTE;
    Mask := 1;
    Mask := Mask shl (BindIndex mod BITSPERBYTE);
    FSendHead^.ParamBits[ByteIndex] := FSendHead^.ParamBits[ByteIndex] or Mask;
    Inc(FSendBodySize,KCPackDataSizes[BindIndex]);
    for J:=0 to FSendBindingOffsets.Count-1 do
    begin
      if Integer(FSendBindingIndexs[J])>BindIndex then
        FSendBindingOffsets[J]:=Pointer(Integer(FSendBindingOffsets[J])+KCPackDataSizes[BindIndex]);
    end;
  end;
  FSendBufferReady := True;
  {$ifdef debug }
  //KCDumpParamBits(FSendHead^.ParamBits);
  WriteLog('Offsets',lcKCPack);
  for I:=0 to FSendBindingIndexs.Count-1 do
  begin
    WriteLog(Format('%s : %d',[KCPackDataNames[Integer(FSendBindingIndexs[I])],Integer(FSendBindingOffsets[I])]),lcKCPack);
  end;
  {$endif}
end;

function TKCAccess.ParamCount: Integer;
begin
  Result := FSendBindingIndexs.Count;
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer;
  const Value: Longint);
var
  Data : PByte;
begin
  KCAccessCheck(
    (KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]=SizeOf(Longint))
      and (KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])]=KCInteger),
    EBindDataTypeError,
    ['Integer']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  Move(Value,Data^,SizeOf(Value));
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer; const Value: Byte);
var
  Data : PByte;
begin
  KCAccessCheck(
    (KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]=SizeOf(Byte))
      and (KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])]=KCInteger),
    EBindDataTypeError,
    ['Byte']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  Move(Value,Data^,SizeOf(Value));
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer;
  const Value: Double);
var
  Data : PByte;
begin
  KCAccessCheck(
    (KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]=SizeOf(Double))
      and (KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])]=KCFloat),
    EBindDataTypeError,
    ['Double']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  Move(Value,Data^,SizeOf(Value));
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer;
  const Value: string);
var
  Data : PByte;
begin
  KCAccessCheck(
    KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])] in [kcChar,kcBit],
    EBindDataTypeError,
    ['String']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  case KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])] of
    kcChar : KCPutStr(Data^,KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])],Value);
    kcBit : PackChars2Bits(PChar(Value),Length(Value),Data,KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]);
    else Assert(False);
  end;
end;

procedure TKCAccess.CallGateway(RequestType : Integer);
var
  Size : Integer;
begin
  KCAccessCheck(FHandle<>0,EInvalidHandle);
  FReceiving := False;
  FWaitingFirstReturn := True;
  FSendHead^.RequestType := RequestType;
  FSendHead^.FirstFlag := 1;
  FSendHead^.NextFlag := 0;
  FSendHead^.RecCount := 1;
  FSendHead^.RetCode := 0;
  FSendHead^.Cookie := FCookie;
  Size := SizeOf(FSendHead^)+FSendBodySize;
  SendPackage(Size);
  DoAfterExecute;
end;

procedure TKCAccess.produceResponseQueue;
begin
  Assert(FCurResponseType=rtNone);
  Assert(FLastCmdCount<FCmdCount); // ÿ������ֻ����һ�������
  FLastCmdCount:=FCmdCount;
  RecievePackage;
  if FReceiveBindingIndexs.Count>0 then
    putResponseSignal(rtDataset) else
  begin
    FEof := True;
    FDoneReading := True;
  end;
end;

procedure TKCAccess.InternalRecievePackage(AnalysePackage: Boolean);
  // ��������Ƿ񵽴�
  procedure DoCheckDataArrived(ReceiveTimeOut : Longword);
  var
    TimeOutForCheck : LongWord;
    DataOK : Boolean;
    ContinueWait : Boolean;
    StartTime : LongWord;
    CurTime : LongWord;
  begin
    if IsCallback then
    begin
      // ΪDRTPCheckDataArrived��ȡ��̵�ʱ����
      TimeOutForCheck := CheckDataTimeOut;
      if (ReceiveTimeOut>0) and (TimeOutForCheck>ReceiveTimeOut) then
        TimeOutForCheck := ReceiveTimeOut;
      if TimeOutForCheck<MinCheckTimeOut then
        TimeOutForCheck := MinCheckTimeOut;
      ContinueWait := True;
      // ��¼��ʼʱ��
      StartTime := GetTickCount;
      repeat
        // ��������Ƿ񵽴�
        DataOK := DRTPCheckDataArrived(FHandle,TimeOutForCheck);
        if not DataOK then
        begin
          // ���û�е������Ƿ�����ȴ�
          DoWait(ContinueWait);
          // ����Ƿ��û�ȡ��
          KCAccessCheck(ContinueWait,EUserCanceled);
          if ContinueWait and (ReceiveTimeOut>0) then
          begin
            //���ʱ���Ƿ񳬹�timeout
            CurTime := GetTickCount;
            if (CurTime-StartTime>ReceiveTimeOut)
              or (CurTime<StartTime) then
              ContinueWait := False;
          end;
        end;
      until DataOK or not ContinueWait;
      // �������û�е��������ʱ����
      KCAccessCheck(DataOk,ETimeout);
    end;
  end;

  function  IsPackageOK : Boolean;
  begin
    Result := (FPackageCounter=FReceiveHead^.userdata) and // userdataҪ����
      ( (FReceiveHead^.RequestType=FSendHead^.RequestType) or //RequestTypeҪ����
        ((FSendHead^.FirstFlag=0) and (FSendHead^.NextFlag=0)) // ����ȡ������ʱ����Բ�Ҫ��RequestType
      );
    if FReceiveHead^.RequestType=400000 then
      Result := True;
    {$ifdef TestPackError }
    if Result and TestPackError then
    begin
      Result := False;
      WriteLog('Ignore Data For TestPackError!',lcKCPack);
    end;
    {$endif}
  end;

var
  DataSuccessfullyReceived : Boolean;
  ReceiveTimeOut : Longword;
  {$ifdef NoCheckPkNo}

  {$else}
  TryReceiveCount : Longword;
  {$endif}
begin
  {$ifdef NoCheckPkNo}

  {$else}
  TryReceiveCount := 0;
  {$endif}
  ReceiveTimeOut := TimeOut;
  // ѭ�����գ�ֱ���յ���ȷ�����ݰ����ߴ���������࣬��������
  repeat
    // ��������Ƿ񵽴�
    DoCheckDataArrived(ReceiveTimeOut);
    // ��������
    CheckAPICall(DRTPReceive(FHandle,PChar(FReceiveHead),SizeOf(FReceiveBuffer),Timeout)>0,'DRTPReceive');
    // ������ݰ����
    {$ifdef NoCheckPkNo}
    DataSuccessfullyReceived := True;
    {$else}
    if IsPackageOK then
    begin
      WriteLog('Successfully Received At Time '+IntToStr(GetTickCount),lcKCPack);
      DataSuccessfullyReceived := True; // �ɹ����ܵ���ȷ�����ݰ�
    end
    else
    begin
      // �յ�����İ�
      WriteLog('Badly Received At Time '+IntToStr(GetTickCount),lcKCPack);
      DumpReceiveBuffer;
      DataSuccessfullyReceived := False;
      Inc(TryReceiveCount);
      ReceiveTimeOut := TryReceiveTimeOut;
      // ���(����Ź������)�������յĴ������Ŀ���࣬����ʧ��
      if {(FPackageCounter<FReceiveHead^.userdata) or }(TryReceiveCount>=MaxTryReceiveCount) then
        RaiseKCAccessError(EBadPackage);
    end;
    {$endif}
  until DataSuccessfullyReceived;
  // �յ���ȷ�����ݰ�
  FCookie := FReceiveHead^.Cookie;

  if AnalysePackage then
  begin
    // �������ܵ������ݱ�
    DumpReceiveBuffer;
    FReceiveBufferReady := True;
    FReturn := FReceiveHead^.RetCode;
    FHaveMorePackage := FReceiveHead^.NextFlag=1;
    FRecordCountInPackage := FReceiveHead^.RecCount;
    FRecordIndexInPackage := 0;
    FNextRecordBuffer := FReceiveBody;
    //FRecordBuffer := FReceiveBody;
    if FWaitingFirstReturn then
    begin
      // ����ȴ���һ�����ذ������ذ���־��ȷ=1����ô�����ֶΣ��������
      if FReceiveHead^.FirstFlag=1 then
        CreateFields else
        RaiseKCAccessError(EBadFlag);
    end else
    begin
      // ������ǵ�һ���������Ƿ��ذ���־=1��˵�����ݴ���
      if FReceiveHead^.FirstFlag=1 then
        RaiseKCAccessError(EBadData,[FReturn]);
    end;
  end;
end;

procedure TKCAccess.RecievePackage(AnalysePackage : Boolean=True);
begin
  FReceiveBufferReady := False;
  try
    try
      // ��������ǰ���¼���������ɽ�ֹ�������пؼ��ĸ���
      if IsCallback and Assigned(BeforeReceive) then
      begin
        WriteLog('BeforeReceive',lcKCPack);
        BeforeReceive(Self);
      end;
      InternalRecievePackage(AnalysePackage);
    finally
      FWaitingFirstReturn := False;
      // �������պ���¼���������ɻָ��������пؼ��ĸ���
      if IsCallback and Assigned(AfterReceive) then
      begin
        WriteLog('AfterReceive',lcKCPack);
        AfterReceive(Self);
      end;
    end;
    if FSendHead.Cookie.UserID<>0 then
      UserID := FSendHead.Cookie.UserID;
  except
    // ����������󣬽�������
    WriteLog('RecievePackage fail, close TKCAccess',lcKCDataset);
    Connected := False;
    FHaveMorePackage := False;
    FDoneReading := True;
    finished;
    raise;
  end;
end;

procedure TKCAccess.CreateFields;
var
  I,J : Integer;
  Mask : Byte;
  Count : Integer;
  AOffset : Integer;
begin
  Count := 0;
  AOffset := 0;
  FReceiveBindingIndexs.Clear;
  FReceiveBindingOffsets.Clear;
  FReceiveBindingDataSizes.Clear;
  FHaveVarCharFields := False;
  FFixedRecordSize := 0;
  FVarFieldStartIndex := 0;
  for I:=0 to ParamBitsSize-1 do
  begin
    Mask := 1;
    for J:=0 to BITSPERBYTE-1 do
    begin
      if (FReceiveHead^.ParamBits[I] and Mask)<>0 then
      begin
        Assert(KCPackDataTypes[Count]<>kcEmpty);
        FReceiveBindingIndexs.Add(Pointer(Count));
        FReceiveBindingOffsets.Add(Pointer(AOffset));
        FReceiveBindingDataSizes.Add(Pointer(KCPackDataSizes[Count]));
        if KCPackDataTypes[Count]<>kcVarChar then
        begin
          Assert(not FHaveVarCharFields); // �䳤�ֶα���������档(�䳤�ֶκ��治���ж����ֶ�)
          Inc(AOffset,KCPackDataSizes[Count]);
        end
        else if not FHaveVarCharFields then
        begin
          FVarFieldStartIndex := FReceiveBindingIndexs.Count-1;
          FHaveVarCharFields := True;
        end;
      end;
      Mask := Mask shl 1;
      Inc(Count);
    end;
  end;
  FFixedRecordSize := AOffset;
  if FReceiveBindingIndexs.Count=0 then
  begin
    WriteLog('No Fields',lcKCPack);
  end;
end;

procedure TKCAccess.GetMorePackage;
var
  TryCount : Integer;
  ContinueReceive : Boolean;
begin
  Assert(FHaveMorePackage);
  TryCount := 0;
  ContinueReceive := True;
  FSendHead.FirstFlag := 0;
  FSendHead.NextFlag := 1;
  FSendHead.RecCount := 0;
  repeat
    // �ص��û�����ĺ������ṩһ������Windows��Ϣ���ж�����Ļ��ᡣ
    if TryCount>0 then
    begin
      DoProgress(TryCount, ContinueReceive);
      if not ContinueReceive then
      begin
        FHaveMorePackage := False;
        Break;
      end;
    end;
    {
    KCClearParamBits(FSendHead^.ParamBits);
    SendPackage(SizeOf(FSendHead^));
    }
    // ���͵�ʱ�򸽴�Cookie����������Ĳ���
    FSendHead^.Cookie := FCookie;
    SendPackage(SizeOf(FSendHead^)+FSendBodySize);
    RecievePackage;
    Inc(TryCount);
  until (FRecordCountInPackage>0) or not FHaveMorePackage;
end;


// Dataset
function TKCAccess.nextRow: Boolean;
begin
  // ͨ��FReceiving��־������÷�������(����ӵصݹ����)
  if FReceiving then
  begin
    Result := False;
    WriteLog('Re-Enter TKCAccess.nextRow',lcDebug);
    Exit;
  end;
  FReceiving := True;
  try
    if (FRecordIndexInPackage>=FRecordCountInPackage) and FHaveMorePackage then
      GetMorePackage;

    if FRecordIndexInPackage<FRecordCountInPackage then
    begin
      Result := True;
      FRecordBuffer := FNextRecordBuffer;
      FVarRecordSize:=0;
      CalculateVarParts;
      Inc(FRecordIndexInPackage);
      Inc(FNextRecordBuffer,FFixedRecordSize+FVarRecordSize);
    end
    else
    begin
      Assert(not FHaveMorePackage);
      Result := False;
      FDoneReading := True;
    end;
    FEof := not Result;
  finally
    FReceiving := False;
  end;
end;

// Field
function TKCAccess.InternalGetFieldCount: Integer;
begin
  Result := FReceiveBindingIndexs.Count;
  Assert((Result=FReceiveBindingOffsets.Count) and (Result=FReceiveBindingDataSizes.Count));
end;

function TKCAccess.FieldDataLen(index: integer): integer;
begin
  //Result := KCPackDataSizes[Integer(FReceiveBindingIndexs[Index-1])];
  //Result := FieldSize(Index);
  Result := Integer(FReceiveBindingDataSizes[Index-1]);
  if KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])]=kcBit then
    Result := Result * 8;
end;

function TKCAccess.FieldIndex(afieldName: pchar): integer;
var
  I : Integer;
begin
  for I:=0 to FReceiveBindingIndexs.Count-1 do
  begin
    if StrIComp(afieldName,PChar(KCPackDataNames[Integer(FReceiveBindingIndexs[I])]))=0 then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function TKCAccess.fieldName(index: Integer): string;
begin
  Result := KCPackDataNames[Integer(FReceiveBindingIndexs[Index-1])];
end;

function TKCAccess.FieldSize(index: integer): integer;
begin
  Result := KCPackDataSizes[Integer(FReceiveBindingIndexs[Index-1])];
  if KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])]=kcBit then
    Result := Result * 8;
  {if KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])] in [kcChar,kcVarChar] then
    Dec(Result); // exclude #0}
end;

function TKCAccess.FieldType(index: integer): integer;
begin
  Result := Ord(KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])]);
end;

procedure TKCAccess.getFieldDef(index: integer; FieldDef: TDBFieldDef);
begin
  FieldDef.FieldIndex := index;
  FieldDef.FieldName := fieldName(index);
  FieldDef.DisplayName := FieldDef.FieldName;
  FieldDef.RawType := FieldType(index);
  case TKCType(FieldDef.RawType) of
      kcChar,kcVarChar,kcBit : FieldDef.FieldType := ftChar;
      kcInteger : FieldDef.FieldType := ftInteger;
      kcFloat : FieldDef.FieldType:=ftFloat;
    else FieldDef.FieldType := ftOther;
  end;
  FieldDef.FieldSize := FieldSize(index);
  FieldDef.Options := []; // both varchar to trim right
end;

// Field Data
function TKCAccess.rawDataToStd(rawType: integer; rawBuffer: pointer;
  rawSize: integer; stdType: TDBFieldType; stdBuffer: pointer;
  stdSize: integer): integer;
var
  len : Integer;
begin
  { TODO : ������������ת�� }
  Result := -1;
  case TKCType(RawType) of
    kcChar,kcVarChar : if (StdType=ftChar) then
                begin
                  fillChar(StdBuffer^,stdSize,0);
                  len := rawSize;
                  if len>=stdSize then
                    len := stdSize;
                  move(rawBuffer^,StdBuffer^,len);
                  result := len;
                end;
    kcInteger : if (StdType=ftInteger) {and (StdSize>=SizeOf(Longint))} then
                begin
                  if RawSize=1 then
                    FillChar(StdBuffer^,StdSize,0);
                  Result := SizeOf(Longint);
                  Move(RawBuffer^,StdBuffer^,rawSize);
                end;
    kcFloat   : if (StdType=ftFloat) and (StdSize>=SizeOf(Double)) then
                begin
                  Result := SizeOf(Double);
                  Move(RawBuffer^,StdBuffer^,Result);
                end;
    kcBit :     begin
                  Assert(StdType=ftChar);
                  Result := UnPackBits2Chars(RawBuffer,stdSize,stdBuffer,stdSize);
                end;
  end;
end;

function TKCAccess.readData(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
var
  Data : PByte;
  DataSize : Integer;
begin
  Data := FRecordBuffer;
  Inc(Data,Integer(FReceiveBindingOffsets[Index-1]));
  DataSize := Integer(FReceiveBindingDataSizes[Index-1]);
  Result := rawDataToStd(FieldType(index),Data,DataSize,DataType,buffer,buffersize);
end;

function TKCAccess.readRawData(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

function TKCAccess.stdDataToRaw(rawType: Integer; rawBuffer: pointer;
  rawSize: Integer; stdType: TDBFieldType; stdBuffer: pointer;
  stdSize: Integer): Integer;
begin
  Result := -1;
  NotSupport;
end;

function TKCAccess.isNull(index: integer): boolean;
begin
  Result := False;
end;

// Return Value
function TKCAccess.readReturn(buffer: pointer;
  buffersize: Integer): Integer;
begin
  if bufferSize>=SizeOf(FReturn) then
    Result := SizeOf(FReturn) else
    Result := buffersize;
  Move(FReturn,Buffer^,Result);
end;

function TKCAccess.returnValue: integer;
begin
  Result := FReturn;
end;

// Other
procedure TKCAccess.InternalCancelResponse;
begin
  WriteLog(Format('======== Cancel[%8.8x] ========',[Integer(Self)]),lcKCPack);
  FSendHead.FirstFlag := 0;
  FSendHead.NextFlag := 0;
  FSendHead.RecCount := 1;
  FSendHead.RetCode := 0;
  FSendHead.Cookie := FCookie;
  SendPackage(SizeOf(FSendHead^)+FSendBodySize);
  RecievePackage(False);
end;

// Not Support
procedure TKCAccess.InternalExec;
begin
  NotSupport;
end;

procedure TKCAccess.getOutputDef(index: integer; FieldDef: TDBFieldDef);
begin
  NotSupport;
end;

function TKCAccess.InternalGetOutputCount: Integer;
begin
  Result := 0;
  NotSupport;
end;

function TKCAccess.outputIsNull(index: Integer): boolean;
begin
  Result := True;
  NotSupport;
end;

function TKCAccess.readOutput(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

function TKCAccess.readRawOutput(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

procedure TKCAccess.initRPC(rpcname: String; flags: Integer);
begin
  NotSupport;
end;

procedure TKCAccess.setRPCParam(name: String; mode: TDBParamMode;
  datatype: TDBFieldType; size, length: Integer; value: pointer;
  rawType: Integer);
begin
  NotSupport;
end;

procedure TKCAccess.InternalExecRPC;
begin
  NotSupport;
end;

procedure TKCAccess.SendPackage(BufferSize: Integer);
begin
  Inc(FPackageCounter);
  FSendHead.userdata := FPackageCounter;
  FSendHead.Cookie.UserID := UserID;
  DumpSendBuffer;
  WriteLog(Format('Send At Time %d, to Server(IP=%s, Port=%d, Encode=%d, Dest=%d, FuncNo=%d, Priority=%d)',
    [GetTickCount, ConnectedIP, ConnectedPort, GatewayEncode, DestNo, FuncNo, Priority]),
    lcKCPack);
  CheckAPICall(DRTPSend(FHandle,DestNo,FuncNo,PChar(FSendHead),BufferSize,Priority,False),'DRTPSend');
end;

{$ifndef debug }

procedure TKCAccess.DumpSendBuffer(BufferSize : Integer);
begin

end;

procedure TKCAccess.DumpReceiveBuffer(BufferSize: Integer);
begin

end;

{$else}

procedure TKCAccess.DumpSendBuffer;
begin
  WriteLog(Format('======== Dump Send[%8.8x] ========',[Integer(Self)]),lcKCPack);
  DumpBuffer(PByte(FSendHead));
end;

procedure TKCAccess.DumpReceiveBuffer;
begin
  WriteLog(Format('======== Dump Receive[%8.8x] ========',[Integer(Self)]),lcKCPack);
  DumpBuffer(PByte(FReceiveHead));
end;

procedure TKCAccess.DumpBuffer(Buffer : PByte);
var
  Head : PSTDataHead;
  Body : PByte;
  RecordSize : Integer;
  RecordCount : Integer;
  Pack : TSTPack;
begin
  // �������pack����־����ô�˳������Ż�����
  if not (lcKCPack in LogCatalogs) then
    Exit;
  //WriteLog(Format('Dump Buffer Size=%d',[BufferSize]),lcKCPack);
  Head := PSTDataHead(Buffer);
  WriteLog(Format('RequestType=%d',[Head^.RequestType]),lcKCPack);
  WriteLog(Format('FirstFlag=%d',[Head^.FirstFlag]),lcKCPack);
  WriteLog(Format('NextFlag=%d',[Head^.NextFlag]),lcKCPack);
  WriteLog(Format('RecCount=%d',[Head^.RecCount]),lcKCPack);
  WriteLog(Format('RetCode=%d',[Head^.RetCode]),lcKCPack);
  WriteLog(Format('UserData=%d',[Head^.UserData]),lcKCPack);
  WriteLog(Format('Cookie.UserID=%d',[Head^.Cookie.UserID]),lcKCPack);
  WriteLog(Format('Cookie.hostname=%s',[KCGetStr(Head^.Cookie.HostName,SizeOf(Head^.Cookie.HostName))]),lcKCPack);
  WriteLog(Format('Cookie.queuename=%s',[KCGetStr(Head^.Cookie.queuename,SizeOf(Head^.Cookie.queuename))]),lcKCPack);
  WriteLog(Format('Cookie.queuetype=%d',[Head^.Cookie.queuetype]),lcKCPack);
  RecordCount := Head^.RecCount;
  KCDumpParamBits(Head^.ParamBits);
  Body := Buffer;
  Inc(Body,SizeOf(Head^));
  if lcKCPackDetail in LogCatalogs then
    while RecordCount>0 do
    begin
      RecordSize := KCUnPackData(Head^.ParamBits,Pack,Body);
      KCDumpPack(Pack);
      //Dec(BufferSize,RecordSize);
      Inc(Body,RecordSize);
      Dec(RecordCount);
    end;
end;

{$endif}


procedure TKCAccess.DoProgress(TryCount: Integer; var ContinueReceive : Boolean);
begin
  if FSleepBetweenReceive>0 then
    Sleep(FSleepBetweenReceive);
  if Assigned(FOnDoProgress) then
  begin
    FOnDoProgress(Self,TryCount, ContinueReceive);
  end;
end;

procedure TKCAccess.ClearCookie;
begin
  FillChar(FCookie,SizeOf(FCookie),0);
end;

procedure TKCAccess.CalculateVarParts;
var
  I : Integer;
  FieldIndexInPack : Integer;
  FieldDataSize : Word;
  PData : PChar;
  Offset : Integer;
begin
  // ����䳤����
  Assert(FVarRecordSize=0);
  if FHaveVarCharFields then
  begin
    // �޸� FVarRecordSize �� FReceiveBindingOffsets, FReceiveBindingDataSizes
    Assert(FVarFieldStartIndex<=FReceiveBindingIndexs.Count-1);
    PData := PChar(FRecordBuffer);
    Offset := FFixedRecordSize;
    Inc(PData,Offset);
    for I:=FVarFieldStartIndex to FReceiveBindingIndexs.Count-1 do
    begin
      FieldIndexInPack := Integer(FReceiveBindingIndexs[I]);
      Assert(KCPackDataTypes[FieldIndexInPack]=kcVarChar);
      Move(PData^,FieldDataSize,SizeOf(FieldDataSize)); // include #0
      Assert((KCPackDataSizes[FieldIndexInPack]>=FieldDataSize) and (FieldDataSize>0));
      Inc(PData,SizeOf(FieldDataSize));
      Inc(Offset,SizeOf(FieldDataSize));
      FReceiveBindingOffsets[I] := Pointer(Offset);
      FReceiveBindingDataSizes[I] := Pointer(FieldDataSize);
      Inc(Offset,FieldDataSize);
      Inc(PData,FieldDataSize);
      Inc(FVarRecordSize,FieldDataSize+SizeOf(FieldDataSize));
    end;
  end;
end;

procedure TKCAccess.DoWait(var ContinueWait: Boolean);
begin
  if Assigned(FOnWait) then
  begin
    FOnWait(Self, ContinueWait);
  end;
end;

{ TKCDatabase }

constructor TKCDatabase.Create(AOwner: TComponent);
begin
  KCAccessCheck(DRTPAPI.DLLLoaded,ECannotLoadDLL);
  FTimeout := OneMinute;
  FSleepBetweenReceive := OneSecond;
  FIsCallback := False;
  FPriority := 2;
  FMaxTryReceiveCount := DefaultTryReceiveCount;
  FCheckDataTimeOut := DefaultCheckDataTimeOut;
  FTryReceiveTimeOut := DefaultTryReceiveTimeOut;
  FGatewayIP := '';
  FGatewayIP2 := '';
  FGatewayEncode := 0;
  FGatewayPort := 0;
  FGatewayPort2 := 0;
  inherited;
end;

procedure TKCDatabase.DoProgress(Sender: TObject; TryCount: Integer;
  var ContinueReceive: Boolean);
begin
  if Assigned(FOnDoProgress) then
    FOnDoProgress(Sender,TryCount,ContinueReceive);
end;

procedure TKCDatabase.DoWait(Sender: TObject; var ContinueWait: Boolean);
begin
  if Assigned(FOnWait) then
    FOnWait(Sender,ContinueWait);
end;

function TKCDatabase.getDBAccess: IDBAccess;
var
  KCAccess : TKCAccess;
begin
  Result := inherited getDBAccess;
  if Result<>nil then
  begin
    KCAccess := TKCAccess(Result.getImplement);
    // reset DBAccess properties
    if Timeout>=0 then
      KCAccess.Timeout := Timeout;
    if SleepBetweenReceive>=0 then
      KCAccess.SleepBetweenReceive:= SleepBetweenReceive;
    KCAccess.FuncNo := FuncNo;
    KCAccess.IsCallback := IsCallback;
    KCAccess.UserID := UserID;
    KCAccess.Priority := Priority;
    KCAccess.MaxTryReceiveCount := MaxTryReceiveCount;
    KCAccess.TryReceiveTimeOut := TryReceiveTimeOut;
    KCAccess.CheckDataTimeOut := CheckDataTimeOut;
    Result.open;
  end;
end;

function TKCDatabase.newDBAccess: IDBAccess;
var
  KCAccess : TKCAccess;
begin
  KCAccess := TKCAccess.create(true);
  try
    KCAccess.DestNo := DestNo;
    KCAccess.FuncNo := FuncNo;
    KCAccess.Priority := Priority;
    KCAccess.UserID := UserID;
    KCAccess.GatewayIP := GatewayIP;
    KCAccess.GatewayPort := GatewayPort;
    KCAccess.GatewayIP2 := GatewayIP2;
    KCAccess.GatewayPort2 := GatewayPort2;
    KCAccess.GatewayEncode := GatewayEncode;
    KCAccess.Open;
  except
    FreeAndNil(KCAccess);
  end;
  if KCAccess<>nil then
  begin
    Result := KCAccess;
    writeLog('new dbaccess ok',lcKCDataset);
    //writeLog()
  end  else
  begin
    result := nil;
    writeLog('new dbaccess error!',lcKCDataset);
  end;
end;

procedure TKCDatabase.notUseDBAccess(aDBAccess: IDBAccess);
begin
  inherited;
  if (aDBAccess<>nil) and (TKCAccess(aDBAccess.getImplement).UserID<>0) then
  begin
    UserID := TKCAccess(aDBAccess.getImplement).UserID;
  end;
end;

{ TKCDataset }

constructor TKCDataset.Create(AOwner: TComponent);
begin
  KCAccessCheck(DRTPAPI.DLLLoaded,ECannotLoadDLL);
  inherited;
  FParams := THRPCParams.Create(self);
  FTimeout := -1;
  FSleepBetweenReceive := -1;
  FFuncNo := 0;
  FIsCallback := cbSetByDatabase;
  FPriority := 0;
end;

destructor TKCDataset.Destroy;
begin
  inherited;
  FParams.free;
end;

procedure TKCDataset.BindingParams(KCAccess : TKCAccess);
var
  I : Integer;
  Param : THRPCParam;
begin
  KCAccess.BeginDefineParam;
  for I:=0 to Params.Count-1 do
  begin
    Param := Params[I];
    KCAccess.AddParam(Param.Name);
  end;
  KCAccess.EndDefineParam;
  WriteLog(Format('TKCDataset.ParamCount=%d',[Params.Count]),lcKCDatasetDetail);
  for I:=0 to Params.Count-1 do
  begin
    Param := Params[I];
    case Param.DataType of
      ftInteger : KCAccess.SetParamValue(I,Param.AsInteger);
      ftFloat : KCAccess.SetParamValue(I,Param.AsFloat);
      ftChar : KCAccess.SetParamValue(I,Param.AsString);
    else
      RaiseKCAccessError(EInvalidDataType);
    end;
    WriteLog(Format('TKCDataset.%s=%s',[Param.Name,Param.AsString]),lcKCDatasetDetail);
  end;
end;

procedure TKCDataset.InternalExec;
var
  acs : IDBAccess;
  temp : TObject;
  KCAccess : TKCAccess;
begin
  //FreturnStatus:=0;
  acs := getDBAccess;
  temp := acs.getImplement;
  KCAccessCheck(temp is TKCAccess,EInvalidDatabase);
  KCAccess := TKCAccess(temp);
  BindingParams(KCAccess);
  if Timeout>=0 then
    KCAccess.Timeout := TimeOut;
  if SleepBetweenReceive>=0 then
    KCAccess.SleepBetweenReceive := SleepBetweenReceive;
  if FuncNo>0 then
    KCAccess.FuncNo := FuncNo;
  if Priority>0 then
    KCAccess.FuncNo := Priority;
  KCAccess.OnDoProgress := DoProgress;
  KCAccess.OnWait := DoWait;
  KCAccess.AfterReceive := DoAfterReceive;
  KCAccess.BeforeReceive := DoBeforeReceive;
  case IsCallback of
    cbNotCallBack : KCAccess.IsCallback := False;
    cbCallBack :    KCAccess.IsCallback := True;
  end;
  WriteLog(Format('FuncNo=%d,RequestType=%d',[KCAccess.FuncNo,RequestType]),lcKCDatasetDetail);
  KCAccess.CallGateway(RequestType);
  KCAccess.checkResponseQueue;
  FReturnCode := KCAccess.returnValue;
  FData.DBAccess :=  acs;
end;

procedure TKCDataset.SetParams(const Value: THRPCParams);
begin
  FParams := Value;
end;

procedure TKCDataset.CloseDBAccess;
begin
  if FData.DBAccess<>nil then
  begin
    WriteLog('TKCDataset.CloseDBAccess',lcKCDatasetDetail);
    TKCAccess(FData.DBAccess.getImplement).AfterReceive := nil;
    TKCAccess(FData.DBAccess.getImplement).BeforeReceive:= nil;
    TKCAccess(FData.DBAccess.getImplement).OnDoProgress := nil;
    TKCAccess(FData.DBAccess.getImplement).OnWait := nil;
    {
    if (TKCAccess(FData.DBAccess.getImplement).UserID<>0) and (Database<>nil) then
      TKCDatabase(Database).UserID := TKCAccess(FData.DBAccess.getImplement).UserID;
    }
  end;
  inherited;
end;

procedure TKCDataset.DoProgress(Sender: TObject; TryCount: Integer;
  var ContinueReceive: Boolean);
begin
  if Assigned(FOnDoProgress) then
    FOnDoProgress(Self,TryCount,ContinueReceive);
  if ContinueReceive and (Database is TKCDatabase) then
    TKCDatabase(Database).DoProgress(Self,TryCount,ContinueReceive);
end;

function TKCDataset.ValidDatabase(const Value: THDatabase): Boolean;
begin
  Result := Value is TKCDatabase;
end;

procedure TKCDataset.DoWait(Sender: TObject; var ContinueWait: Boolean);
begin
  if Assigned(FOnWait) then
    FOnWait(Self,ContinueWait);
  if ContinueWait and (Database is TKCDatabase) then
    TKCDatabase(Database).DoWait(Self,ContinueWait);
end;

procedure TKCDataset.DoBeforeReceive(Sender : TObject);
begin
  {
  ����ʹ��DisableControls������������ش���
  DisableControls;
  Inc(FDisableCouting);
  }
  if Assigned(BeforeReceive) then
    BeforeReceive(Sender);
  if Database<>nil then
  begin
    if Assigned(TKCDatabase(Database).BeforeReceive) then
      TKCDatabase(Database).BeforeReceive(Sender);
  end;
end;

procedure TKCDataset.DoAfterReceive(Sender : TObject);
begin
  {
  ����ʹ��EnableControls������������ش���
  EnableControls;
  Dec(FDisableCouting);
  }
  if Assigned(AfterReceive) then
    AfterReceive(Sender);
  if Database<>nil then
  begin
    if Assigned(TKCDatabase(Database).AfterReceive) then
      TKCDatabase(Database).AfterReceive(Sender);
  end;
end;

initialization
  if DRTPAPI.DLLLoaded then
    DRTPInitialize;

finalization
  if DRTPAPI.DLLLoaded then
    DRTPUninitialize;
end.
