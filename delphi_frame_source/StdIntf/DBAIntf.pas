unit DBAIntf;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>DBAIntf
   <What>�����˷�������Դ�ĳ���ӿ�
   <Written By> Huang YanLai (������)
   <History>
**********************************************}

{
  IDBAccess is a basic data access interface for internal usage.
  I recommend : The implements of IHDataset and other interfaces
should be based on IDBAccess.
}

interface

uses SysUtils,Listeners,classes;

type
  //TTriState = (tsUnknown,tsFalse,tsTrue);
  // ֧�ֵ��ֶ���������
  TDBFieldType = (ftInteger,ftFloat,ftCurrency,ftChar,ftDatetime,ftBinary,ftOther);
  // ���������͵Ĳ���
  TDBFieldOption = (foFixedChar);
  TDBFieldOptions = set of TDBFieldOption;
  {
    <Class>TDBFieldDef
    <What>���������ֶ����Ե���
    <Properties>
      FieldIndex - �ֶ��ڽ�����е�����(������)����1��ʼ��š�
      FieldName - �ֶ�����
      DisplayName - �ֶ���ʾ����
      FieldType - �ֶ���������;
      FieldSize - ԭʼ�ֶδ�С��bytes��
      RawType - ԭʼ�ֶ��������ͣ������������ṩ
      Options - ���������͵Ĳ���;
      isOnlyDate -  ���������ʱ�����ͣ��Ƿ���������ڲ���
      isOnlyTime - ���������ʱ�����ͣ��Ƿ������ʱ�䲿��
      autoTrim  - �Ƿ��Զ�ȥ���ַ������ұߵĿո�
    <Methods>
      -
    <Event>
      -
  }
  TDBFieldDef = class
  private
    FisOnlyDate: boolean;
    FisOnlyTime: boolean;
    FautoTrim: boolean;
    procedure SetIsOnlyDate(const Value: boolean);
    procedure SetIsOnlyTime(const Value: boolean);
  public
    FieldIndex : Integer; // indexed from 1
    FieldName : String;
    DisplayName : String;
    FieldType : TDBFieldType;
    FieldSize : Integer;  // the raw data size
    RawType :   Integer;    // the raw data type defined by the database driver
    Options :   TDBFieldOptions;
    property    isOnlyDate : boolean read FisOnlyDate write SetIsOnlyDate;
    property    isOnlyTime : boolean read FisOnlyTime write SetIsOnlyTime;
    property    autoTrim : boolean read FautoTrim write FautoTrim default true;
    constructor Create;
    procedure   assign(source : TDBFieldDef); virtual;
  end;

  //TDataReadMode = (rmRaw,rmChar);
  {
    <Class>EDBAccessError
    <What>����Դ���ʴ���
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EDBAccessError = class(Exception);
  {
    <Class>EDBUnsupported
    <What>��������������֧�ֵĲ���
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EDBUnsupported = class(EDBAccessError);
  {
    <Class>EDBNoDataset
    <What>�����޽����
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EDBNoDataset = class(EDBAccessError);

  {
    <Class>EInvalidDatabase
    <What>��Ч�����ݿ�
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EInvalidDatabase = class(Exception);

  {
    <Enum>TDBState
    <What>IDBAccess״̬
    <Item>
      dsNotReady - δ����
      dsReady - ׼����ִ��������
      dsBusy  - ���ڴ��������ȡ��������δ�꣩
  }
  TDBState =(dsNotReady,dsReady,dsBusy);
  // Զ���̵���(RPC)��������
  TDBParamMode=(pmUnknown,pmInput,pmOutput,pmInputOutput);
  {
    <Enum>TDBResponseType
    <What>����Դ������Ӧ������
    <Item>
      rtNone  - ��
      rtDataset - �����
      rtReturnValue - ����ֵ
      rtOutputValue - RPC �������
      rtError - ����
      rtMessage - �ı���Ϣ
  }
  TDBResponseType=(rtNone,rtDataset, rtReturnValue, rtOutputValue, rtError, rtMessage);
  {
    <Enum>TDBEventType
    <What>IDBAccess�������¼�����
    <Item>
      etOpened - ������
      etClosed  - �ر�����
      etBeforeExec  - ��ִ��������ǰ
      etAfterExec - ��ִ�������Ժ�
      etGone2NextResponse - ������һ����Ӧ
      etFinished  - ���з��ص���Ӧ������
      etDestroy - ʵ����ɾ��
  }
  TDBEventType = (etOpened,etClosed,etBeforeExec,etAfterExec,etGone2NextResponse,etFinished,etDestroy);
  {
    <Class>TDBEvent
    <What>IDBAccess�������¼�����
    <Properties>
      EventType - �¼�����
    <Methods>
      -
    <Event>
      -
  }
  TDBEvent = class(TObjectEvent)
  public
    EventType : TDBEventType;
  end;
  {
    <Interface>IDBAccess
    <What>��������Դ�ĳ���ӿ�
    <Properties>
      -
    <Methods>
      -
  }
  IDBAccess = interface
    ['{FFAD05C0-8CA8-11D3-AAFA-00C0268E6AE8}']
    // 0) ������������/�ر�����Դ���ӣ��Լ��������״̬
    procedure   open;
    procedure   close;
    function    state : TDBState;
    function    Ready : Boolean;
    function    CmdCount:Integer;
    // 0.1) ��������Դ��Ӧ�ı�׼����
    function    nextResponse: TDBResponseType;
    function    curResponseType: TDBResponseType;
    procedure   finished;
    function    get_isMessageNotified:boolean;
    procedure   set_isMessageNotified(value:boolean);
    // 0.2) ֧��Listener�ķ�������������֪���ڲ�������ʱ�䡣ͨ��IListener���ݵ���TDBEvent����
    procedure   addListener(Listener : IListener);
    procedure   removeListener(Listener : IListener);
    // 0.3) �ڱ�׼��������(TDBFieldType)������Դ��ԭʼ��������֮����е�ת������
    // raw data (base on database driver) to standard data type ( TDBFieldType )
    // return standard data size
    function    rawDataToStd(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer;
    function    stdDataToRaw(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer;
    // 0.4) ���ʵ�ָýӿڵĶ����ʵ��
    function    getImplement : TObject;
    // 1) ͨ��SQL�ı�������Դ���з��ʵķ���
    function    GetSQLText : String;
    procedure   SetSQLText(const Value:String);
    property    SQLText : String read GetSQLText write SetSQLText;
    function    GetExtraSQLText : String;
    procedure   SetExtraSQLText(const Value:String);
    property    ExtraSQLText : String read GetExtraSQLText write SetExtraSQLText;
    procedure   exec;
    procedure   execSQL(const ASQLText : String);

    // 2) �����ؽ�����ķ���
    // 2.1) ��������
    //function    hasDataset:TTriState;
    function    nextRow : Boolean;
    function    eof : Boolean;
    // 2.2) ����ֶεĶ���
    function    fieldCount : Integer;
    function    fieldName(index : Integer) : string;
    function    fieldType(index : Integer) : Integer;  //rawtype
    function    fieldSize(index : Integer) : Integer;
    function    fieldDataLen(index : Integer) : Integer;
    procedure   getFieldDef(index : Integer; FieldDef : TDBFieldDef);
    // 2.3) ��ȡ�ֶε�ֵ
    function    readData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readData2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawData(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    isNull(index:Integer): Boolean;
    // extend data read for data results
    function    fieldAsInteger(index:Integer): Integer;
    function    fieldAsFloat(index:Integer): Double;
    function    fieldAsDateTime(index:Integer): TDateTime;
    function    fieldAsString(index:Integer): String;
    function    fieldAsCurrency(index:Integer): Currency;
    // 2.4) ��ȡSQLServer, Sybase��COMPUTE�ֶ���Ϣ�ķ���(�������������в�֧�����ַ���)
    // Returns the number of COMPUTE clauses in the current set of results
    function    cumputeClauseCount : Integer;
    // if isSupportCompute=false, nextRow will skip compute rows. default is false
    function    GetisSupportCompute : Boolean;
    procedure   setisSupportCompute(value : Boolean);
    property    isSupportCompute : Boolean read GetisSupportCompute write setisSupportCompute;
    function    isThisACumputeRow : Boolean;
    function    ComputeFieldCount : Integer;
    function    ComputeFieldType(index : Integer) : Integer;
    function    ComputeFieldSize(index : Integer) : Integer;
    function    ComputeFieldDataLen(index : Integer) : Integer;
    procedure   getComputeFieldDef(index : Integer; FieldDef : TDBFieldDef);
    function    readComputeData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readComputeData2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawComputeData(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    computeIsNull(index : Integer): boolean;

    // 3) ��ȡ���������Ϣ
    //procedure   ReachOutputs;
    //function    hasOutput: TTriState;
    function    outputCount : Integer;
    procedure   getOutputDef(index : Integer; FieldDef : TDBFieldDef);
    function    readOutput(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readOutput2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawOutput(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    outputIsNull(index : Integer): boolean;

    // 4) ��ȡ���ز�����Ϣ
    //procedure   ReachReturn;
    //function    hasReturn: TTriState;
    function    readReturn(buffer : pointer; buffersize : Integer) : Integer;
    function    returnValue : Integer;

    // 5) ͨ��RPC������洢���̣�������Դ���з��ʵķ���
    procedure   initRPC(rpcname : String; flags : Integer);
    // if value=nil, it is a null value
    procedure   setRPCParam(name : String; mode : TDBParamMode; datatype : TDBFieldType;
                  size : Integer; length : Integer; value : pointer; rawType : Integer);
    procedure   execRPC;

    // 6) �������Դ���ص���Ϣ
    procedure   getMessage(msg : TStrings);
    function    MessageText : string;
    // 7) �������Դ���ص�����
    function    getError : EDBAccessError;
  end;

const
  // ��׼���ݳ���
  StdDataSize : array[TDBFieldType] of Integer
    = (sizeof(Integer),sizeof(Double),Sizeof(Currency),0,Sizeof(TDatetime),0,0);

implementation

uses safeCode;

{ TDBFieldDef }

procedure TDBFieldDef.assign(source: TDBFieldDef);
begin
  FieldIndex := source.FieldIndex;
  FieldName := source.FieldName;
  DisplayName := source.DisplayName;
  FieldType := source.FieldType;
  FieldSize := source.FieldSize;
  RawType := source.RawType;
  FisOnlyDate := source.FisOnlyDate;
  FisOnlyTime := source.FisOnlyTime;
end;

constructor TDBFieldDef.Create;
begin
  FieldIndex := 0;
  FieldName := '';
  DisplayName := '';
  FieldType := ftOther;
  FieldSize := 0;
  RawType := 0;
  FisOnlyDate := false;
  FisOnlyTime := false;
  Options := [];
  FautoTrim := true;
end;

procedure TDBFieldDef.SetIsOnlyDate(const Value: boolean);
begin
  if FieldType<>ftDatetime then
  begin
    FisOnlyDate := false;
    FisOnlyTime := false;
  end else
  begin
    FisOnlyDate := Value;
    if FisOnlyDate then FisOnlyTime := false;
  end;
end;

procedure TDBFieldDef.SetIsOnlyTime(const Value: boolean);
begin
  if FieldType<>ftDatetime then
  begin
    FisOnlyDate := false;
    FisOnlyTime := false;
  end else
  begin
    FisOnlyTime := Value;
    if FisOnlyTime then FisOnlyDate := false;
  end;
end;

end.
