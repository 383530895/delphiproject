unit RPBands;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPBands (Report Bands)
   <What>����ӡ�������Ϊ��һЩBand����γɵ�ģ�͡�
   �õ�Ԫ���������ģ�͵Ļ������Ԫ�أ�ͬʱ�ڸ�ģ�͵���ʵ���˷�ҳ�����ЩBand���㷨��
   ���ģ�Ͳ��漰������Ĵ�ӡϸ�ڣ�ֻ�Ƿ�װ��һ����ҳ��ӡ���㷨��
   �ڸ������ݼ�������������RPDataBrowsers.pas��TRPDatasetBrowser
   <Note>
   1��ֻ��TSimpleBand�Ŷ�Ӧ����Ĵ�ӡ���ݣ�TGroupBand��TRepeatBand���SimpleBand��TPrintBandsStack�е�����
   2��TReport����TPrintBandsStack��TBandPrinter�����ӡ��
   3��TPrintBandsStack��������Ҫ˳���ӡ��Band���б�
   ������ΪTReport.Print�Ĺ�������TPrintBandsStack������һ�������޳�ֽ�������δ�ӡ��Band���б�
   4��TBand�������ProcessPrintStack��������˽�GroupBand�滻Ϊ�������Band���Լ�Band���Զ����ơ�
   5��TBandPrinter.PrintBand���TSimpleBand�Ĵ�ӡ���ڴ�ӡ��ʱ����ɷ�ҳ������ҳ��ʱ���ӡ��Ҫ��ͷ����β����
   6���ܽ᣺TBand����������������޴�ֽ������Ҫ˳���ӡ��SimpleBand�����ɣ�TBandPrinter���SimpleBand�Ĵ�ӡ�ͷ�ҳ��
   <Written By> Huang YanLai
   <History>�޸���UBands.pas���㷨��֤�����������û��ʵ�ʵĴ�ӡ��,����ʹ��ǰ׺RP
**********************************************}

{ TODO : �������������һҳ̫�󣬲��Ϸ�ҳ���޷���ӡ�� }

{ TODO : ��һҳ������ӡһ��Header������û�пռ��ӡDetail���Ƿ���Headerǰ���ҳ�� }

{ TODO : �����ҳ��û�����ݣ�ͬʱû��ָ��Footer���л��ܣ���ӡHeader���Ƿ���ࣿ }

interface

uses Windows, SysUtils, Classes, Contnrs, RPDB, RPDefines;

const
  FloatDifference = 0.001;

type
  TRPGroupBand = class;
  TRPPrintBandsStack = class;
  TRPBandPrinter = class;
  TRPReport = class;

  {
    <Class>TRPBand
    <What>һ�������ʵ��,������֯��ӡ�����ݡ�
    <Properties>
      Parent -
      Height - �߶�,��0.1mmΪ��λ��
              ֻ�в��Ƿ����У�Lefter��Righter����TSimpleBand��Height���м�ֵ���������Band��ֵΪ0��
              TRPReport.Height��ʾҳ�ߡ�
      Width - ��ʾ��ȡ�
              TReport��Width��ʾҳ���ȡ�
              �ڴ�ӡ��ǰ������Band�ĸ��ֶε�ֵ��Ч��Ϊ0��
              �ڴ�ӡ��ǰ������TReport��Prepare�����Ժ󣬸��ݼ�����¸�TReport�ĸ�����Band��Width��ֵ���ڴ�ӡ��ʱ��Width����Ч��
    <Methods>
      ProcessPrintStack - �����ӡBand��ջ��������ʱջ��Ԫ���Ǹ�Band��
      Prepare - ׼����ӡ����������Band�Ĵ�С�ȵȡ�
      Reset - ��λ�����DetailBand�ĸ��ƴ���,�����ʼ����������
    <Event>
      -
  }
  TRPBand = class(TObject)
  private
    FParent: TRPGroupBand;
    FHeight: TFloat;
    FCaption: String;
    FWidth: TFloat;
    FReport: TRPReport;
    FBandName: string;
  protected
    procedure   Prepare; virtual;
    procedure   Reset; virtual;
    procedure   ProcessPrintStack(PrintStack : TRPPrintBandsStack;
      BandPrinter : TRPBandPrinter); virtual; abstract;
  public
    constructor Create(AParent : TRPGroupBand); virtual;
    Destructor  Destroy;override;
    property    Parent : TRPGroupBand read FParent;
    property    Height : TFloat read FHeight write FHeight;
    property    Width : TFloat read FWidth write FWidth;
    property    Caption : String read FCaption write FCaption;
    function    BandIndex : Integer;
    property    Report : TRPReport read FReport;
    property    BandName : string read FBandName write FBandName;
  end;

  {
    <Class>TSimpleBand
    <What>���ܰ�����Band�����԰�����ӡ�ؼ����Ǵ������մ�ӡ���ݵ�Band���������͵�Band���ƴ�ӡ����ʽ��
    <Properties>
      IsSpace - �Ƿ��ǿհ׼�����ڴ����ҳ��ʱ��������Ŀհ�Band���£����û�ҳ��
        ע�⣺���һ��Band��Header���Ͳ�����Space
      IsForceNewPage - �Ƿ�Ҫ���ڴ�ӡ��ҳ��ǰǿ�Ʒ�ҳ��
      NoNewPageAtFirst - ��IsForceNewPage=True��ȷ���Ƿ��ڵ�һ�δ�ӡ��Band��ʱ��(���ݰ�����Band��RepeatBand.Count=1ȷ��)��ǿ�Ʒ�ҳ��
      IsForceEndPage - �Ƿ�Ҫ���ڴ�ӡ���ҳ�Ժ�ǿ�Ʒ�ҳ�������Band����ֻ��Footer������ҳ
      ReportObject - ����ʵ��Ҫ��ӡ����Ķ��󡣸ö��󽫱����ݸ�IReportProcessor������ʵ��ʵ�ʵĴ�ӡ�����
      OwnObject - �Ƿ�ӵ��ReportObject���󣨿���ReportObject���ͷţ�
    <Methods>
      ProcessPrintStack - ���Լ��Ӷ�ջ��ͷ��������Ҫ���ӡ��
      IsGroupColumn - ���ظ�Band�Ƿ��Ǹ�Band�ķ����С�
                      ����˵����Band�Ƿ����Parent.Lefter����Paren.Right��
    <Event>
      -
  }
  TRPSimpleBand = class(TRPBand)
  private
    FIsSpace: Boolean;
    FIsForceNewPage: Boolean;
    FFieldName: String;
    FReportObject: TObject;
    FOwnObject: Boolean;
    FIsAlignBottom: Boolean;
    FIsForceEndPage: Boolean;
    FNoNewPageAtFirst: Boolean;
    function    GetIsAlignBottom: Boolean;
  protected
    procedure   ProcessPrintStack(PrintStack : TRPPrintBandsStack;
      BandPrinter : TRPBandPrinter); override;
    procedure   Prepare; override;
  public
    constructor Create(AParent : TRPGroupBand); override;
    Destructor  Destroy;override;
    function    IsGroupColumn: Boolean;
    property    IsSpace : Boolean read FIsSpace write FIsSpace;
    property    IsForceNewPage : Boolean read FIsForceNewPage write FIsForceNewPage;
    property    IsForceEndPage : Boolean read FIsForceEndPage write FIsForceEndPage;
    property    NoNewPageAtFirst : Boolean read FNoNewPageAtFirst write FNoNewPageAtFirst;
    property    IsAlignBottom : Boolean read GetIsAlignBottom write FIsAlignBottom;
    property    FieldName : String read FFieldName write FFieldName;
    property    OwnObject : Boolean read FOwnObject write FOwnObject;
    property    ReportObject : TObject read FReportObject write FReportObject;
  end;

  {
    <Class>TRPGroupBand
    <What>���԰�����Band�����ܰ�����ӡ�ؼ���������ͷ��(header)��β��(footer)����߷�����(lefter)���ұ߷�����(righter)��
    �ڷ�ҳ��ʱ��Ҫ����ͷβ�ͷ����еĴ�ӡ��
    ����Band�б��У���һ����Header�������Ǳ�ʾ���ݵ�Band�����һ����Footer��Lefter��Righter��һ����ѡ�Ĵ���հ׵�Band��
    ��Letfer��Righter�Ժ󣬱�ʾ���ݵ�Band�Ŀ��Ҫ��С��
    <Properties>
      ContentBandWidth - �������ݵ���Band�Ŀ�ȡ�ֻ��Prepare�Ժ���Ч��
      ContentWidth - ��ȥ�����п���Ժ�Ĵ�ӡ���ݵ��ܿ�ȡ�һ�����ContentBandWidth��ֻ��Prepare�Ժ���Ч��
      ContentX - ��ӡ����Band����ʼX���ꡣ����Ը�Band��������߷����еĿ�ȣ���ֻ��Prepare�Ժ���Ч��
      LastBand - ���������һ��SimpleBand��ֻ��Prepare�Ժ���Ч��
    <Methods>
      ProcessPrintStack - ���Լ��Ӷ�ջ��ͷ��������Ȼ�󽫰�������Bandѹ���ջ��
      Prepare - ��������Band�����ݵĴ�С�ȵȡ�������������Band��Prepare������
      CalculateContentWidth - ����Band�����ݵĴ�С��
      IsContainThis - �����Ƿ�ֱ�ӻ��߼�ӣ�������Band��
    <Event>
      -
  }
  TRPGroupBand = class(TRPBand)
  private
    FChildren : TObjectList;
    FIsDetroying : Boolean;
    FFooter: TRPSimpleBand;
    FHeader: TRPSimpleBand;
    FRighter: TRPSimpleBand;
    FLefter: TRPSimpleBand;
    FContentBandWidth: TFloat;
    FContentWidth: TFloat;
    FContentX: TFloat;
    FLastBand: TRPSimpleBand;
  protected
    procedure   CalculateContentWidth; virtual;
    procedure   Prepare; override;
    procedure   ProcessPrintStack(PrintStack : TRPPrintBandsStack;
      BandPrinter : TRPBandPrinter); override;
    property    LastBand : TRPSimpleBand read FLastBand; // return this last simple band
    property    ContentBandWidth : TFloat read FContentBandWidth;
    property    ContentWidth : TFloat read FContentWidth;
    property    ContentX : TFloat read FContentX write FContentX;
  public
    constructor Create(AParent : TRPGroupBand); override;
    Destructor  Destroy;override;
    procedure   Clear;
    property    Header : TRPSimpleBand read FHeader write FHeader;
    property    Footer : TRPSimpleBand read FFooter write FFooter;
    property    Lefter : TRPSimpleBand read FLefter write FLefter;
    property    Righter : TRPSimpleBand read FRighter write FRighter;
    function    IsContainThis(Band : TRPBand): Boolean;
    procedure   GetAllSimpleBands(SimpleBands : TList);
  end;

  {
    <Class>TRPRepeatBand
    <What>���԰�����Band�����ܰ�����ӡ�ؼ������ҿ��Ը��ơ�
    ������ TRPDatasetBrowser ����
    <Properties>
      Count - ��ǰ���������ڴ�ӡ���еĴ���
      Columns - ������ȷʡΪ1��

    <Methods>
      ProcessPrintStack - 1�����Eof=True�����Լ��Ӷ�ջ��ͷ������������ӡ����
        2������Eof=False�������������Լ���������������Bandѹ���ջ��������������Band���Ƶ���ջ�У���
      Reset - ��ʼ��������
      CalculateContentWidth - �����й���Ҫ���д�ӡ�ļ��㡣
      Eof - �����Ƿ������
    <Event>
      -
  }
  TRPRepeatBand = class(TRPGroupBand)
  private
    FCount : Integer;
    FTotal: Integer;
    FColumns: Integer;
    FBrowser: TRPDatasetBrowser;
  protected
    procedure   CalculateContentWidth; override;
    procedure   Reset; override;
    procedure   Prepare; override;
    procedure   ProcessPrintStack(PrintStack: TRPPrintBandsStack;
      BandPrinter: TRPBandPrinter); override;
  public
    constructor Create(AParent : TRPGroupBand); override;
    Destructor  Destroy;override;
    function    Eof : Boolean; virtual;
    property    Total : Integer read FTotal write FTotal;
    property    Count : Integer read FCount;
    property    Columns : Integer read FColumns write FColumns;
    property    Browser : TRPDatasetBrowser read FBrowser;
  end;

  {
    <Class>TRPPrintBandsStack
    <What>����Ҫ��ӡ��Band��
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPPrintBandsStack = class(TStack)
  private

  protected

  public
    procedure Push(AItem: TRPBand);
    function  Pop: TRPBand;
    function  Peek: TRPBand;
  end;

  {
    <Class>TRPPrintedBandInfo
    <What>��������ӡ��Band����Ϣ��
    <Properties>
      Band - ��ӡ��SimpleBand��ʵ����
      ARect - ��ӡ��λ�ô�С��
    <Methods>
      -
    <Event>
      -
  }
  TRPPrintedBandInfo = class(TObject)
  private
    FARect: TRPRect;
    FBand: TRPSimpleBand;
  protected

  public
    constructor Create(ABand : TRPSimpleBand; const ItsRect:TRPRect);
    property  Band : TRPSimpleBand read FBand write FBand;
    property  ARect : TRPRect read FARect write FARect;
  end;

  TPrintBandEvent = procedure (BandPrinter : TRPBandPrinter; Band : TRPSimpleBand;
    const ARect : TRPRect; DeltaY : TFloat) of object;

  {
    <Class>TRPBandPrinter
    <What>����Band�Ĵ�ӡ�Լ���ҳ�Ķ����ࡣ
    <Fields>
      FAllPrintedBandInfosInThePage - ��ҳ�Ѿ���ӡ��TPrintedBandInfo������б�
        ������ҳ��ɵ�ͷβ���ظ���ӡ����InternalPrintBand2���ɡ�
      FPrintedBandsInThePage - ��ҳ�Ѿ���ӡ��TBand������б�
        ��������ҳ��ɵ�ͷβ���ظ���ӡ����PrintBand���ɡ�

    <Properties>
      IsMoveEmptyGroup - ���һ��Groupû�пռ��ӡDetail����ô��HeaderҲ�Ƶ���һҳ��
      CurrentY - ��ǰҳ����һ��Band��ӡ��Y���ꡣ
      PageNumber - ����ҳ��������ʵ�ʵ�����ҳ����һ������ҳ���԰����������ҳ��
    <Methods>
      PrintBand - ��ӡָ����Band����������ɷ�ҳ����
      CanFitTheBand - �Ƿ���Ը�ҳ���㹻�Ŀռ��ӡ��Band��
        ������Ҫ����ΪFooterBandsԤ���ռ䡢����հ׼��Band�����Ƿ��д�ӡ�ȵ����⡣
      NewPageFor - Ϊָ����Band׼���µ�һҳ������Ҫ��ӡ��Ҫ��Header��
      NewPage - �����µĴ�ӡҳ��ע�ⲻ����ͷ��Band�Ĵ�ӡ��
      EndPage - ����һҳ�������ﴦ����������β���ͷ����еĴ�ӡ��
      InternalPrintBand - ��ӡָ����Band�������ƶ�����λ�á�
        ������Ҫ���Ƿ����еĴ�ӡλ�á����еĴ�ӡλ�á�
      InternalPrintBand2 - ��ָ��λ�úʹ�С��ӡ��Band����������CurrentY��
      IsOnlyPrintedHeaders - ����ڸ�ҳ�Ͻ�����ӡ�˸�Band��Ӧ��ͷ�����ṩ�Ƿ�ǿ�Ʒ�ҳ�����ݡ�
      GetExtraDetailBandHeight - �����ڿ���IsMoveEmptyGroupʱ����Ҫ���⿼�ǵĴ�С����CanFitTheBand���á�
      GetGroupColumnHeight - ������Ҫ��ӡ�ķ����еĸ߶ȡ���InternalPrintBand��EndPage���á�
    <Event>
      -
  }
  TRPBandPrinter = class(TObject)
  private
    FHeight: TFloat;
    FCurrentY: TFloat;
    FPageNumber: Integer;
    FLastPrintBand : TRPSimpleBand;
    FOnPrintBand: TPrintBandEvent;
    FPrintedBandsInThePage : TList; // ��ҳ�Ѿ���ӡ��TBand������б���������ҳ��ɵ�ͷβ���ظ���ӡ��
    FAllPrintedBandInfosInThePage : TObjectList; // ������ҳ��ɵ�ͷβ���ظ���ӡ�� ����TPrintedBandInfo����
    FIsMoveEmptyGroup: Boolean;
    FReport: TRPReport;

  protected
    procedure   NewPage;
    procedure   NewPageFor(Band : TRPSimpleBand);
    function    CanFitTheBand(Band : TRPSimpleBand; var BandHeight:TFloat):Boolean;
    procedure   EndPage;
    procedure   InternalPrintBand(Band : TRPSimpleBand; BandHeight:TFloat);
    procedure   InternalPrintBand2(Band : TRPSimpleBand; const ARect : TRPRect; DeltaY : TFloat);
    function    IsOnlyPrintedHeaders(Band : TRPSimpleBand): Boolean;
    function    GetExtraDetailBandHeight(Band : TRPSimpleBand): TFloat;
    function    GetGroupColumnHeight(Band : TRPGroupBand): TFloat;
    function    IsAtFirst(Band : TRPSimpleBand) : Boolean;
  public
    constructor Create(AReport : TRPReport);
    Destructor  Destroy;override;
    procedure   Init;
    procedure   PrintBand(Band : TRPSimpleBand);
    property    Report : TRPReport read FReport;
    property    Height : TFloat read FHeight write FHeight;
    property    PageNumber : Integer read FPageNumber;
    property    CurrentY : TFloat read FCurrentY write FCurrentY;
    property    OnPrintBand : TPrintBandEvent read FOnPrintBand write FOnPrintBand;
    property    IsMoveEmptyGroup : Boolean read FIsMoveEmptyGroup write FIsMoveEmptyGroup;
  end;

  TPrintBandEventEx = procedure (BandPrinter : TRPBandPrinter; Band : TRPSimpleBand;
    const ARect : TRPRect; DeltaY : TFloat;
    Report : TRPReport; const PhysicalRect : TRPRect) of object;

  TNewPageEvent = procedure (Report : TRPReport) of object;
  TOnReportEngineErrorEvent = procedure (Report : TRPReport; ErrorCode : Integer; const ErrorMsg:string) of object;

  TRPPrintingInfo = class
    Report : TRPReport;
    PrintStack : TRPPrintBandsStack;
    BandPrinter : TRPBandPrinter;
  end;

  {
    <Class>TRPReport
    <What>
    <Properties>
      PageWidth   - ҳ����
      PageHeight  - ҳ��߶�
      Margin      - ҳ����Χ�հף�����StaticMargin����
      StaticMargin - ҳ����Χ�̶��Ŀհף����ܹ�����ӡ����豸���������򡣴�ӡʱ������������ڿ��Դ�ӡ�����򣬲������ò��֡�
      Rows        - ��һҳ��Ϊ����
      Columns     - ��һҳ��Ϊ����
      ReportPerPage - readonly һҳ����Ϊ����С����
      ColumnSpace - ���еļ��
      RowSpace    - ���еļ��
      PageNumber  - readonly ��ǰҳ��(һҳ���԰������Report)
      ReportProcessor - ������ӿ�
      IsMoveEmptyGroup - ���յķ����Ƶ���һҳ
      OnPrintBand - �¼������߼�λ�����һ��Band
      OnPrintBandEx - �¼���������λ�����һ��Band
      OnNewPage - �¼�������һ������ҳ��ʱ�򱻴���
    <Methods>
      Print - ��ӡ����Ҫ��ӡ��ReportObject���ݸ�IReportProcessor�ӿڴ������ʵ�ʵĴ�ӡ��
    <Event>
      -
  }
  TRPReport = class(TRPGroupBand)
  private
    FPageHeight: TFloat;
    FOnPrintBand: TPrintBandEvent;
    FIsMoveEmptyGroup: Boolean;
    FColumns: Integer;
    FRows: Integer;
    FPageWidth: TFloat;
    FMargin: TRPMargin;
    FColumnSpace: TFloat;
    FRowSpace: TFloat;
    FOnPrintBandEx: TPrintBandEventEx;
    FReportPerPage : Integer;
    FPageNumber: Integer;
    FOnNewPage: TNewPageEvent;
    FReportProcessor: IReportProcessor;
    FStaticMargin: TRPMargin;
    FEnvironment: TRPDataEnvironment;
    FPrintingInfo : TRPPrintingInfo;
    FOnError: TOnReportEngineErrorEvent;
    FStartPage : Integer;
    FEndPage : Integer;
    FReportPageNumber: Integer;
    FPrintStopped : Boolean;
    FReportStatus: TReportStatus;
    procedure   SetColumns(const Value: Integer);
    procedure   SetRows(const Value: Integer);
    procedure   SetMargin(const Value: TRPMargin);
    procedure   SetStaticMargin(const Value: TRPMargin);
    procedure   SetReportStatus(const Value: TReportStatus);
  protected
    procedure   CalculateContentWidth; override;
    procedure   DoNewPage(BandPrinter : TRPBandPrinter);
    procedure   NewPhysicalPage;
    procedure   PrintBackGround;
    procedure   DoPrintBand(BandPrinter : TRPBandPrinter; Band : TRPSimpleBand;
      const ARect : TRPRect; DeltaY : TFloat);
    procedure   DoPrintBandEx(BandPrinter : TRPBandPrinter; Band : TRPSimpleBand;
      const ARect : TRPRect; DeltaY : TFloat; const PhysicalRect : TRPRect);
    procedure   BeginPrint;
    procedure   EndPrint;
    procedure   AbortPrint;
    procedure   Error(ErrorCode : Integer; const ErrorMsg:string);
    function    SkipPage : Boolean;
    function    StopPage : Boolean;
  public
    constructor Create(AParent : TRPGroupBand); override;
    Destructor  Destroy;override;
    procedure   Print(StartPage : Integer=0; EndPage : Integer=0);

    property    PageWidth : TFloat read FPageWidth write FPageWidth;
    property    PageHeight : TFloat read FPageHeight write FPageHeight;
    property    Rows : Integer read FRows write SetRows default 1;
    property    Columns : Integer read FColumns write SetColumns default 1;
    property    ReportPerPage : Integer read FReportPerPage;
    property    Margin : TRPMargin read FMargin write SetMargin;
    property    StaticMargin : TRPMargin read FStaticMargin write SetStaticMargin;
    property    ColumnSpace : TFloat read FColumnSpace write FColumnSpace;
    property    RowSpace : TFloat read FRowSpace write FRowSpace;
    property    PageNumber : Integer read FPageNumber;
    property    ReportPageNumber : Integer read FReportPageNumber;
    property    ReportProcessor : IReportProcessor read FReportProcessor write FReportProcessor;
    property    Environment : TRPDataEnvironment read FEnvironment write FEnvironment;

    property    IsMoveEmptyGroup : Boolean read FIsMoveEmptyGroup write FIsMoveEmptyGroup;
    property    OnPrintBand : TPrintBandEvent read FOnPrintBand write FOnPrintBand;
    property    OnPrintBandEx : TPrintBandEventEx read FOnPrintBandEx write FOnPrintBandEx;
    property    OnNewPage : TNewPageEvent read FOnNewPage write FOnNewPage;
    property    OnError : TOnReportEngineErrorEvent read FOnError write FOnError;
    property    ReportStatus : TReportStatus read FReportStatus;
  end;

procedure OpenReport(Report : TRPReport; const FileName:String);

procedure SaveReport(Report : TRPReport; const FileName:String);

{
  <Function>GetEvaluatedBandHeight
  <What>����ָ��Band�ĸ߶�
  ��SimpleBand����SimpleBand.Height��
  ��GroupBand���ض���Band��Height���ۼơ�
  <Params>
    -
  <Return>
  <Exception>
}
function  GetEvaluatedBandHeight(Band : TRPBand): TFloat;

const
  ECCannotCalcColumnHeight = 1;
  ESCannotCalcColumnHeight = 'Cannot calculate the height of the group column.';

implementation

uses SafeCode, TextUtils, KSStrUtils, LogFile;

const
  BandLeadingChar = '@';
  CommentChar = ';';
  LevelChar = '-';
  CaptionEntry = 'Caption';
  HeightEntry = 'Height';
  WidthEntry = 'Width';
  HeaderEntry = 'Header';
  FooterEntry = 'Footer';
  LefterEntry = 'Lefter';
  RighterEntry = 'Righter';
  TotalEntry = 'Total';
  ColumnsEntry = 'Columns';
  SpaceEntry = 'Space';
  ForceNewPageEntry = 'ForceNewPage';
  ControllerEntry = 'Controller';
  GroupIndexEntry = 'GroupIndex';
  FieldNameEntry = 'FieldName';

procedure OpenReport(Report : TRPReport; const FileName:String);
var
  Reader : TTextReader;
  ParentStack : TList;
  Line : String;
  CurrentBand : TRPBand;

  function ReadBandHead: TRPBand;
  var
    i,len,Level : integer;
    Parent : TRPGroupBand;
    BandType : String;
  begin
    len := Length(Line);
    Level := 0;
    for i:=2 to len do
    begin
      if Line[i]<>LevelChar then
        Break
      else
        Inc(Level);
    end;
    Assert((Level>0) and (Level<=ParentStack.Count));
    if Level>0 then
      Parent := TRPGroupBand(ParentStack[Level-1])
    else
      Parent := nil;
    BandType := UpperCase(Copy(Line,1+Level+1,len));
    if (BandType='TREPEATBAND') or (BandType='TRPREPEATBAND') then
      Result := TRPRepeatBand.Create(Parent)
    else if (BandType='TGROUPBAND') or (BandType='TRPGROUPBAND') then
      Result := TRPGroupBand.Create(Parent)
    else
      Result := TRPSimpleBand.Create(Parent);
    if Result is TRPGroupBand then
    begin
      ParentStack.Count := Level+1;
      ParentStack[Level]:=Result;
    end;
  end;

  procedure ReadBandProperty;
  var
    Len : Integer;
  begin
    Len := Length(Line);
    if StartWith(Line,CaptionEntry) then
      CurrentBand.Caption := Copy(Line,Length(CaptionEntry)+3,Len-Length(CaptionEntry)-3)
    else if StartWith(Line,HeightEntry) then
      CurrentBand.Height := StrToFloat(Copy(Line,Length(HeightEntry)+2,Len))
    else if StartWith(Line,WidthEntry) then
      CurrentBand.Width := StrToFloat(Copy(Line,Length(WidthEntry)+2,Len))
    else if StartWith(Line,HeaderEntry) then
      begin
        Assert(CurrentBand is TRPSimpleBand);
        Assert(CurrentBand.Parent.Header=nil);
        CurrentBand.Parent.Header := TRPSimpleBand(CurrentBand);
      end
    else if StartWith(Line,FooterEntry) then
      begin
        Assert(CurrentBand is TRPSimpleBand);
        Assert(CurrentBand.Parent.Footer=nil);
        CurrentBand.Parent.Footer := TRPSimpleBand(CurrentBand);
      end
    else if StartWith(Line,LefterEntry) then
      begin
        Assert(CurrentBand is TRPSimpleBand);
        Assert(CurrentBand.Parent.Lefter=nil);
        CurrentBand.Parent.Lefter := TRPSimpleBand(CurrentBand);
      end
    else if StartWith(Line,RighterEntry) then
      begin
        Assert(CurrentBand is TRPSimpleBand);
        Assert(CurrentBand.Parent.Righter=nil);
        CurrentBand.Parent.Righter := TRPSimpleBand(CurrentBand);
      end
    else if StartWith(Line,SpaceEntry) then
      begin
        Assert(CurrentBand is TRPSimpleBand);
        TRPSimpleBand(CurrentBand).IsSpace := True;
      end
    else if StartWith(Line,ForceNewPageEntry) then
      begin
        Assert(CurrentBand is TRPSimpleBand);
        TRPSimpleBand(CurrentBand).IsForceNewPage := True;
      end
    else if StartWith(Line,FieldNameEntry) then
      begin
        Assert(CurrentBand is TRPSimpleBand);
        TRPSimpleBand(CurrentBand).FieldName := Copy(Line,Length(FieldNameEntry)+3,Len-Length(FieldNameEntry)-3);
      end
    else if StartWith(Line,TotalEntry) then
      begin
        Assert(CurrentBand is TRPRepeatBand);
        TRPRepeatBand(CurrentBand).Total := StrToInt(Copy(Line,Length(TotalEntry)+2,Len));
      end
    else if StartWith(Line,ControllerEntry) then
      begin
        Assert(CurrentBand is TRPRepeatBand);
        TRPRepeatBand(CurrentBand).Browser.ControllerName := Copy(Line,Length(ControllerEntry)+3,Len-Length(ControllerEntry)-3);
      end
    else if StartWith(Line,GroupIndexEntry) then
      begin
        Assert(CurrentBand is TRPRepeatBand);
        TRPRepeatBand(CurrentBand).Browser.GroupingIndex := StrToInt(Copy(Line,Length(GroupIndexEntry)+2,Len));
      end
    else if StartWith(Line,ColumnsEntry) then
      begin
        Assert(CurrentBand is TRPRepeatBand);
        TRPRepeatBand(CurrentBand).Columns := StrToInt(Copy(Line,Length(ColumnsEntry)+2,Len));
      end;
  end;

begin
  Report.Clear;
  Reader := nil;
  ParentStack := nil;
  try
    Reader := TTextReader.Create(FileName);
    ParentStack := TList.Create;
    ParentStack.Add(Report);
    Reader.IsFilterLines := true;
    Reader.CommonChar := CommentChar;
    CurrentBand := nil;
    while not Reader.Eof do
    begin
      Line := Reader.Readln;
      if Line<>'' then
      begin
        if Line[1]=BandLeadingChar then
        begin
          if CurrentBand=nil then
            CurrentBand:=Report
          else
            CurrentBand:=ReadBandHead;
        end
        else if CurrentBand<>nil then
          ReadBandProperty;
      end;
    end;
    //ReadBand(Report);
  finally
    ParentStack.Free;
    Reader.Free;
  end;
end;

procedure SaveReport(Report : TRPReport; const FileName:String);
var
  Writer : TTextWriter;

  procedure WriteBand(Band : TRPBand; Level : Integer);
  var
    Head : String;
    i : integer;
  begin
    // write head
    Head := BandLeadingChar;
    for i:=1 to Level do
      Head := Head + LevelChar;
    Head := Head + Band.ClassName;
    Writer.Println(Head);

    // write common
    if Band.Height>0 then
      Writer.Println(Format('%s=%g',[HeightEntry,Band.Height]));
    if Band.Width>0 then
      Writer.Println(Format('%s=%g',[WidthEntry,Band.Width]));
    if Band.Caption<>'' then
      Writer.Println(Format('%s="%s"',[CaptionEntry,Band.Caption]));

    // write special
    if Band is TRPSimpleBand then
    begin
      if Band.Parent<>nil then
      begin
        if Band.Parent.Header=Band then
          Writer.Println(HeaderEntry);
        if Band.Parent.Footer=Band then
          Writer.Println(FooterEntry);
        if Band.Parent.Lefter=Band then
          Writer.Println(LefterEntry);
        if Band.Parent.Righter=Band then
          Writer.Println(RighterEntry);
      end;
      if TRPSimpleBand(Band).IsSpace then
        Writer.Println(SpaceEntry);
      if TRPSimpleBand(Band).IsForceNewPage then
        Writer.Println(ForceNewPageEntry);
    end
    else if Band is TRPRepeatBand then
    begin
      Writer.Println(Format('%s=%d',[TotalEntry,TRPRepeatBand(Band).Total]));
      if TRPRepeatBand(Band).Columns>1 then
        Writer.Println(Format('%s=%d',[ColumnsEntry,TRPRepeatBand(Band).Columns]));
      if TRPRepeatBand(Band).Browser.ControllerName<>'' then
        Writer.Println(Format('%s="%s"',[ControllerEntry,TRPRepeatBand(Band).Browser.ControllerName]));
      if TRPRepeatBand(Band).Browser.GroupingIndex>=0 then
        Writer.Println(Format('%s=%d',[GroupIndexEntry,TRPRepeatBand(Band).Browser.GroupingIndex]));
    end;


    // End this Band
    Writer.Println('');

    // write children
    if Band is TRPGroupBand then
      with TRPGroupBand(Band) do
      begin
        for i:=0 to FChildren.Count-1 do
          WriteBand(TRPBand(FChildren[i]),Level+1);
      end;
  end;

begin
  Writer := TTextWriter.Create(FileName);
  try
    WriteBand(Report,0);
  finally
    Writer.Free;
  end;
end;

{ TRPBand }

constructor TRPBand.Create(AParent: TRPGroupBand);
begin
  FParent := AParent;
  if FParent<>nil then
  begin
    FParent.FChildren.Add(self);
    FReport := FParent.Report;
  end;
end;

destructor TRPBand.Destroy;
begin
  if (FParent<>nil) and not FParent.FIsDetroying then
    FParent.FChildren.Extract(Self);
  FParent := nil;
  inherited;
end;

function TRPBand.BandIndex: Integer;
begin
  if Parent<>nil then
    Result:=-1
  else
  begin
    Result := Parent.FChildren.IndexOf(self);
    Assert(Result>=0);
  end;
end;

procedure TRPBand.Prepare;
begin

end;

procedure TRPBand.Reset;
begin

end;

{ TRPSimpleBand }

constructor TRPSimpleBand.Create(AParent: TRPGroupBand);
begin
  inherited;
  FIsAlignBottom := False;
  FIsForceNewPage := False;
  FIsForceEndPage := False;
  FNoNewPageAtFirst := False;
end;

destructor TRPSimpleBand.Destroy;
begin
  if FOwnObject and (FReportObject<>nil) then
    FreeAndNil(FReportObject);
  inherited;
end;

function TRPSimpleBand.GetIsAlignBottom: Boolean;
var
  TempBand : TRPGroupBand;
begin
  Result := FIsAlignBottom;
  if Result then
  begin
    TempBand := Parent;
    Assert(TempBand<>nil);
    Result := TempBand.Footer=Self;
    if Result then
    begin
      TempBand := TempBand.Parent;
      while TempBand<>nil do
      begin
        if TempBand.Footer<>nil then
        begin
          Result := false;
          Break;
        end;
        TempBand := TempBand.Parent;
      end;
    end;
  end;
end;

function TRPSimpleBand.IsGroupColumn: Boolean;
begin
  Result := (Parent<>nil) and ((Parent.Lefter=Self) or (Parent.Righter=Self));
end;

procedure TRPSimpleBand.Prepare;
begin
  inherited;
  if (Parent<>nil) and not IsGroupColumn  then
    Width := Parent.ContentBandWidth;
end;

procedure TRPSimpleBand.ProcessPrintStack(PrintStack: TRPPrintBandsStack;
  BandPrinter: TRPBandPrinter);
begin
  Assert(self=PrintStack.Pop);
  BandPrinter.PrintBand(self);
end;

{ TRPGroupBand }

procedure TRPGroupBand.CalculateContentWidth;
begin
  if Parent<>nil then
    Width := Parent.ContentWidth;
  FContentWidth := Width;
  if Parent<>nil then
    FContentX := Parent.FContentX
  else
    FContentX := 0;
  if FLefter<>nil then
  begin
    FContentWidth := FContentWidth-FLefter.Width;
    FContentX := FContentX + FLefter.Width;
  end;
  if FRighter<>nil then
    FContentWidth := FContentWidth-FRighter.Width;
  FContentBandWidth := FContentWidth;
end;

procedure TRPGroupBand.Clear;
begin
  FChildren.Clear;
  FFooter := nil;
  FHeader := nil;
  FLefter := nil;
  FRighter := nil;
  FLastBand := nil;
end;

constructor TRPGroupBand.Create(AParent: TRPGroupBand);
begin
  inherited;
  FChildren := TObjectList.Create;
  FIsDetroying := false;
end;

destructor TRPGroupBand.Destroy;
begin
  FIsDetroying := true;
  FChildren.Free;
  inherited;
end;

procedure TRPGroupBand.GetAllSimpleBands(SimpleBands: TList);
var
  i : integer;
  Band : TRPBand;
begin
  for i:=0 to FChildren.Count-1 do
  begin
    Band := TRPBand(FChildren[i]);
    if Band is TRPSimpleBand then
      SimpleBands.Add(Band)
    else if Band is TRPGroupBand then
      TRPGroupBand(Band).GetAllSimpleBands(SimpleBands);
  end;
end;

function TRPGroupBand.IsContainThis(Band: TRPBand): Boolean;
var
  ItsParent : TRPBand;
begin
  //Result := false;
  ItsParent := Band.Parent;
  while (ItsParent<>nil) and (ItsParent<>self) do
    ItsParent := ItsParent.Parent;
  Result := ItsParent=self;
end;

procedure TRPGroupBand.Prepare;
var
  i : integer;
  TempBand : TRPBand;
begin
  inherited;
  CalculateContentWidth;
  for i:=0 to FChildren.Count-1 do
    TRPBand(FChildren[i]).Prepare;

  // get last simple band contained by this band
  if FChildren.Count>0 then
    TempBand := TRPBand(FChildren.Last)
  else
    TempBand := nil;
  if TempBand is TRPGroupBand then
    FLastBand:= TRPGroupBand(TempBand).LastBand
  else
    FLastBand := TRPSimpleBand(TempBand);
  Assert(FLastBand<>nil);
end;

procedure TRPGroupBand.ProcessPrintStack(PrintStack: TRPPrintBandsStack;
  BandPrinter: TRPBandPrinter);
var
  i : integer;
begin
  if Self is TRPRepeatBand then
    Assert(self=PrintStack.Peek)
  else
    Assert(self=PrintStack.Pop);
  for i:=FChildren.Count-1 downto 0 do
  begin
    //TRPBand(FChildren[i]).Prepare;
    TRPBand(FChildren[i]).Reset;
    PrintStack.Push(TRPBand(FChildren[i]));
  end;
end;

{ TRPRepeatBand }

constructor TRPRepeatBand.Create(AParent: TRPGroupBand);
begin
  inherited;
  FColumns := 1;
  FBrowser := TRPDatasetBrowser.Create;

end;

destructor TRPRepeatBand.Destroy;
begin
  FBrowser.Free;
  inherited;
end;

procedure TRPRepeatBand.CalculateContentWidth;
begin
  inherited;
  Assert(FColumns>0);
  FContentBandWidth := FContentBandWidth / FColumns;
end;

function TRPRepeatBand.Eof: Boolean;
begin
  if Browser.Available then
    Result := FBrowser.Eof
  else
    Result := FCount>Total;
end;

procedure TRPRepeatBand.Prepare;
begin
  inherited;
  Assert(Report<>nil);
  Browser.Environment := Report.Environment;
  Browser.CheckController;
  if Browser.Controller<>nil then
    Browser.Controller.Init;
end;

procedure TRPRepeatBand.ProcessPrintStack(PrintStack: TRPPrintBandsStack;
  BandPrinter: TRPBandPrinter);
begin
  Inc(FCount);
  if Browser.Available then
    Browser.GotoNextData;
  if Eof then
    Assert(self=PrintStack.Pop)
  else
    inherited;
end;

procedure TRPRepeatBand.Reset;
begin
  inherited;
  FCount := 0;
  if Browser.Available then
    Browser.Init;
end;

{ TRPPrintBandsStack }

function TRPPrintBandsStack.Peek: TRPBand;
begin
  Result := TRPBand(Inherited Peek);
end;

function TRPPrintBandsStack.Pop: TRPBand;
begin
  Result := TRPBand(Inherited Pop);
end;

procedure TRPPrintBandsStack.Push(AItem: TRPBand);
begin
  Inherited Push(AItem);
end;

{ TRPBandPrinter }
procedure TRPBandPrinter.Init;
begin
  //FCurrentY := 0;
  FPageNumber := 0;
  FLastPrintBand := nil;
  //FPrintedBandsInThePage.Clear;
  NewPage;
end;

procedure TRPBandPrinter.InternalPrintBand(Band: TRPSimpleBand; BandHeight:TFloat);
var
  ARect : TRPRect;
  ColumnIndex : Integer;
  DeltaHeight : TFloat;
begin
  if Band.IsGroupColumn then
  begin
    // process group column
    if Band=Band.Parent.Lefter then
    begin
      // lefter
      ARect.Left := Band.Parent.ContentX-Band.Width;
      ARect.Right := Band.Parent.ContentX;
    end
    else
    begin
      // righter
      ARect.Left := Band.Parent.ContentX+Band.Parent.ContentWidth;
      ARect.Right := ARect.Left + Band.Width;
    end;
    ARect.Top := CurrentY-GetGroupColumnHeight(Band.Parent);
    ARect.Bottom := CurrentY;
    DeltaHeight := 0; // not forware page
  end
  else
  begin
    {
    // method1 for processing columns
    // bug : ������detail(TRPRepeatBand)���ݵ�ʱ��,
    // ���ColumnIndex<TRPRepeatBand(Band.Parent).Columns-1
    // û�в���!!!
    if Band.Parent is TRPRepeatBand then
    begin
      ColumnIndex := (TRPRepeatBand(Band.Parent).Count-1) mod TRPRepeatBand(Band.Parent).Columns;
      ARect.Left := Band.Parent.ContentX + ColumnIndex*Band.Width;
      if ColumnIndex=TRPRepeatBand(Band.Parent).Columns-1 then
        DeltaHeight := BandHeight // forware page
      else
        DeltaHeight := 0; // not forware page
    end
    else
    begin
      ARect.Left := Band.Parent.ContentX;
      DeltaHeight := BandHeight;
    end;
    }

    // method2 for processing columns
    // ÿ��һ��DetailBand��ʱ���в���
    // �����ڴ�ӡDetailBand��ǰ,���ColumnIndex>0
    // ����BandHeight
    if Band.Parent is TRPRepeatBand then
    begin
      ColumnIndex := (TRPRepeatBand(Band.Parent).Count-1) mod TRPRepeatBand(Band.Parent).Columns;
      ARect.Left := Band.Parent.ContentX + ColumnIndex*Band.Width;
      if ColumnIndex>0 then
      begin
        Assert(Band.Height=BandHeight);
        FCurrentY := FCurrentY - Band.Height; // move back!
      end;
    end
    else
    begin
      ARect.Left := Band.Parent.ContentX;
    end;
    DeltaHeight := BandHeight;
    // end method2

    if Band.IsAlignBottom then
      FCurrentY := Height-Band.Height;

    ARect.Top := CurrentY;
    ARect.Right := ARect.Left + Band.Width;
    ARect.Bottom := CurrentY + BandHeight;
  end;
  InternalPrintBand2(Band,ARect,DeltaHeight);
end;

procedure TRPBandPrinter.InternalPrintBand2(Band: TRPSimpleBand;
  const ARect: TRPRect; DeltaY: TFloat);
begin
  FAllPrintedBandInfosInThePage.Add(TRPPrintedBandInfo.Create(Band,ARect));
  // print this band
  if Assigned(FOnPrintBand) then
    FOnPrintBand(self,Band,ARect,DeltaY);
  FReport.DoPrintBand(self,Band,ARect,DeltaY);
  // move FCurrentY
  FCurrentY := FCurrentY + DeltaY;
end;

function  TRPBandPrinter.CanFitTheBand(Band : TRPSimpleBand; var BandHeight:TFloat):Boolean;
var
  FootersHeight : TFloat;
  TempBand : TRPGroupBand;
  ExtraDetailBandHeight : TFloat;
  ColumnIndex : Integer;
  ForceTheNewPage : Boolean;
begin
  Assert(Band.Parent<>nil);

  // process IsForceEndPage (FLastPrintBand)
  ForceTheNewPage := (FLastPrintBand<>nil) and FLastPrintBand.IsForceEndPage;
  if ForceTheNewPage then
    ForceTheNewPage := not Band.IsGroupColumn
      and (Band<>Band.Parent.Footer)
      and (FAllPrintedBandInfosInThePage.IndexOf(FLastPrintBand)<0);
  if ForceTheNewPage then
  begin
    Result := False;
    Exit;
  end;

  BandHeight:=Band.Height;
  // method2 for processing columns
  if (Band.Parent is TRPRepeatBand) then
  begin
    ColumnIndex := (TRPRepeatBand(Band.Parent).Count-1) mod TRPRepeatBand(Band.Parent).Columns;
    if ColumnIndex>0 then
    begin
      // has space for this band because it will move back to print!
      Result := true;
      Exit;
    end;
  end;
  // end method2

  // check need force a new page
  if Band.IsForceNewPage and not (Band.NoNewPageAtFirst and IsAtFirst(Band)) then
  begin
    // ���������ӡ��ͷ��������ҳ��fit���������ҳ��
    Result := IsOnlyPrintedHeaders(Band);
    Exit;
  end;

  ExtraDetailBandHeight := 0;

  // check IsMoveEmptyGroup
  if IsMoveEmptyGroup and (Band=Band.Parent.Header) then
    ExtraDetailBandHeight := GetExtraDetailBandHeight(Band);

  if (Band=Band.Parent.Footer) or Band.IsGroupColumn then
    Result := true // if it's a footer , then must be printed in this page!
  else
  begin
    // sum footer's height
    FootersHeight := 0;
    TempBand := Band.Parent;
    while TempBand<>nil do
    begin
      if TempBand.Footer<>nil then
        FootersHeight := FootersHeight + TempBand.Footer.Height;
      TempBand := TempBand.Parent;
    end;
    // have enough page space?
    Result := CurrentY+Band.Height+ExtraDetailBandHeight <= Height-FootersHeight+FloatDifference;
    if not Result and Band.IsSpace then
    begin
      Assert(Band<>Band.Parent.Header);
      // handle space band
      Result := true;
      BandHeight:=Height-FootersHeight-CurrentY;
    end;
  end;
end;

procedure TRPBandPrinter.EndPage;
{var
  TempBand : TRPGroupBand;
begin
  Assert(FLastPrintBand<>nil);
  TempBand := FLastPrintBand.Parent;
  while TempBand<>nil do
  begin
    if (TempBand.Footer<>nil) and (TempBand.Footer<>FLastPrintBand) then
      if (TempBand.FChildren.Count<=0) or (TempBand.FChildren[TempBand.FChildren.Count-1]<>FLastPrintBand) then
        InternalPrintBand(TempBand.Footer, TempBand.Footer.Height);
    TempBand := TempBand.Parent;
  end;
end;}

var
  LastBand : TRPBand;
  TempBand : TRPGroupBand;
  GroupColumnHeight : TFloat;
  ARect : TRPRect;
begin
  Assert(FAllPrintedBandInfosInThePage.Count>0);
  LastBand := TRPPrintedBandInfo(FAllPrintedBandInfosInThePage.Last).Band;
  Assert(LastBand<>nil);
  TempBand := LastBand.Parent;
  Assert(TempBand<>nil);
  if (TempBand.FChildren.Count>0) and (TempBand.FChildren.Last=LastBand) then
    // last group ended, go to the outter group
    TempBand := TempBand.Parent;
  // for each outter group, print their footer
  while TempBand<>nil do
  begin
    // add footer
    if (TempBand.Footer<>nil) then
      InternalPrintBand(TempBand.Footer, TempBand.Footer.Height);
    // add lefter and righter
    if (TempBand.Lefter<>nil) or (TempBand.Righter<>nil) then
    begin
      GroupColumnHeight := GetGroupColumnHeight(TempBand);
      if TempBand.Lefter<>nil then
      begin
        ARect.Left := TempBand.ContentX-TempBand.Lefter.Width;
        ARect.Top := FCurrentY-GroupColumnHeight;
        ARect.Right := TempBand.ContentX;
        ARect.Bottom := FCurrentY;
        InternalPrintBand2(TempBand.Lefter,ARect,0);
      end;
      if TempBand.Righter<>nil then
      begin
        ARect.Left := TempBand.ContentX+TempBand.ContentWidth;
        ARect.Top := FCurrentY-GroupColumnHeight;
        ARect.Right := ARect.Left + TempBand.Righter.Width;
        ARect.Bottom := FCurrentY;
        InternalPrintBand2(TempBand.Righter,ARect,0);
      end;
    end;
    TempBand := TempBand.Parent;
  end;
end;

procedure TRPBandPrinter.NewPageFor(Band: TRPSimpleBand);
var
  HeaderBandStack : TStack;
  TempBand : TRPGroupBand;
  HeaderBand : TRPSimpleBand;
begin
  NewPage;

  HeaderBandStack := TStack.Create;
  try
    // get headers
    TempBand := Band.Parent;
    while TempBand<>nil do
    begin
      if TempBand.Header<>nil then
        HeaderBandStack.Push(TempBand.Header);
      TempBand := TempBand.Parent;
    end;
    // print headers
    while HeaderBandStack.Count>0 do
    begin
      HeaderBand := TRPSimpleBand(HeaderBandStack.Pop);
      if HeaderBand<>Band then // need print this ��
        InternalPrintBand(HeaderBand,HeaderBand.Height);
    end;
  finally
    HeaderBandStack.Free;
  end;
end;

procedure TRPBandPrinter.PrintBand(Band: TRPSimpleBand);
var
  BandHeight : TFloat;
begin
  Assert(Band<>nil);
  // �ڿհ�ҳ�����ֹ��ҳ
  // if CanFitTheBand(Band,BandHeight) then
  if CanFitTheBand(Band,BandHeight) or (FAllPrintedBandInfosInThePage.Count=0) then
    InternalPrintBand(Band,BandHeight) // if fit this, print it
  else
  begin
    // finish this page
    EndPage;
    // new page for it
    NewPageFor(Band);
    // print it
    InternalPrintBand(Band,Band.Height);
  end;
  FLastPrintBand := Band;
  FPrintedBandsInThePage.Add(Band);
end;

constructor TRPBandPrinter.Create(AReport : TRPReport);
begin
  Assert(AReport<>nil);
  FReport := AReport;
  FPrintedBandsInThePage := TList.Create;
  FAllPrintedBandInfosInThePage := TObjectList.Create;
end;

destructor TRPBandPrinter.Destroy;
begin
  FAllPrintedBandInfosInThePage.Free;
  inherited;
end;

procedure TRPBandPrinter.NewPage;
begin
  Inc(FPageNumber);
  FCurrentY := 0;
  FPrintedBandsInThePage.Clear;
  FAllPrintedBandInfosInThePage.Clear;
  FReport.DoNewPage(Self);
end;

function TRPBandPrinter.IsOnlyPrintedHeaders(Band: TRPSimpleBand): Boolean;
var
  //TempList : TList;
  i : integer;
  TempBand : TRPGroupBand;
  PrintedBand : TRPBand;
begin
  Result := True;

  TempBand := Band.Parent;
  for i:=0 to FPrintedBandsInThePage.Count-1 do
  begin
    PrintedBand := TRPBand(FPrintedBandsInThePage[i]);
    if (TempBand=nil) or (PrintedBand=Band) then
      Result := false
    else
    begin
      // is PrintedBand a header?
      while (TempBand<>nil) do
      begin
        if PrintedBand=TempBand.Header then
          Break
        else
          TempBand := TempBand.Parent;
      end;
      if TempBand=nil then
        Result := false;
    end;
    if not Result then
      Break;
    Assert(TempBand<>nil);
    TempBand := TempBand.Parent;
  end;
end;

function GetEvaluatedBandHeight(Band : TRPBand): TFloat;
var
  i : integer;
begin
  if Band is TRPSimpleBand then
    Result := Band.Height
  else
    with TRPGroupBand(Band) do
    begin
      Result := 0;
      for i:=0 to FChildren.Count-1 do
        Result := Result + GetEvaluatedBandHeight(TRPBand(FChildren[i]));
    end;
end;

function TRPBandPrinter.GetExtraDetailBandHeight(Band: TRPSimpleBand): TFloat;
var
  ParentBand : TRPGroupBand;
  TempBand : TRPBand;
  //i : integer;
begin
  ParentBand := Band.Parent;
  Assert(ParentBand<>nil);
  Assert(ParentBand.FChildren.Count>0);
  Assert(ParentBand.FChildren[0]=Band);
  Result := 0;
  {
  for i:=1 to ParentBand.FChildren.Count-1 do
  begin
    TempBand := TRPBand(ParentBand.FChildren[i]);
    if TempBand=ParentBand.Footer then
      Break;
    // other wise
    if TempBand is TRPSimpleBand then
      Result := Result + TempBand.Height
    else
  end;
  }

  // �����С����Group�ĵ�һ������(��ȥͷβ)�Ĵ�С
  if ParentBand.FChildren.Count>1 then
  begin
    TempBand := TRPBand(ParentBand.FChildren[1]);
    if (TempBand<>ParentBand.Footer) then
      Result:=GetEvaluatedBandHeight(TempBand);
  end;
end;

function TRPBandPrinter.GetGroupColumnHeight(Band: TRPGroupBand): TFloat;
var
  i : integer;
  TempBand : TRPBand;
  StartIndex : Integer;
begin
  StartIndex := -1;
  for i:=FAllPrintedBandInfosInThePage.Count-1 downto 0 do
  begin
    TempBand := TRPPrintedBandInfo(FAllPrintedBandInfosInThePage[i]).Band;
    if Band.IsContainThis(TempBand) then
      if TempBand<>Band.LastBand then
        StartIndex := i
      else
        Break // reach previouse group of this kind.
    else
      Break; // out of this group (reach another kind of group)
  end;
  //Assert(StartIndex>=0);
  if StartIndex>=0 then
    Result := FCurrentY -
      TRPPrintedBandInfo(FAllPrintedBandInfosInThePage[StartIndex]).ARect.Top
  else
  begin
    // for bad setting. there are not any content bands.
    Result := 0;
    Report.Error(ECCannotCalcColumnHeight,ESCannotCalcColumnHeight);
  end;
end;


function TRPBandPrinter.IsAtFirst(Band: TRPSimpleBand): Boolean;
var
  AParent : TRPGroupBand;
begin
  Result := True;
  AParent := Band.Parent;
  while AParent<>nil do
  begin
    if AParent is TRPRepeatBand then
    begin
      Result := TRPRepeatBand(AParent).Count=1;
      Break;
    end;
    AParent := AParent.Parent;
  end;
end;

{ TRPReport }

constructor TRPReport.Create(AParent: TRPGroupBand);
begin
  inherited;
  if FReport=nil then
    FReport := self;
  FMargin := TRPMargin.Create;
  FStaticMargin := TRPMargin.Create;
  FRows := 1;
  FColumns := 1;
  FReportPerPage := Columns * Rows;
  FPrintingInfo := TRPPrintingInfo.Create;
  FPrintingInfo.Report := Self;
end;

destructor TRPReport.Destroy;
begin
  FPrintingInfo.Free;
  FMargin.Free;
  inherited;
end;

procedure TRPReport.CalculateContentWidth;
begin
  Assert(Columns>=1);
  Width := ( (PageWidth - (Margin.Left-StaticMargin.Left) - (Margin.Right-StaticMargin.Right))
    - (Columns-1) * ColumnSpace )
    / Columns;
  Height := ( (PageHeight - (Margin.Top-StaticMargin.Top) - (Margin.Bottom-StaticMargin.Bottom))
    - (Rows-1) * RowSpace)
    / Rows;
  inherited;
  //WriteLog(Format('PageContent = %g * %g',[Width,Height]),lcReport);
end;

procedure TRPReport.Print(StartPage : Integer=0; EndPage : Integer=0);
var
  Stack : TRPPrintBandsStack;
  BandPrinter : TRPBandPrinter;
  Band : TRPBand;
  BandDesc : String;
begin
  SetReportStatus(rsRunning);
  Stack := nil;
  BandPrinter := nil;
  FPrintStopped := False;
  try
    Prepare;
    Reset;

    FPageNumber := 0;
    FReportPageNumber := 0;
    FStartPage := StartPage;
    FEndPage := EndPage;
    //NewPhysicalPage;

    // create TRPPrintBandsStack
    Stack := TRPPrintBandsStack.Create;
    BandPrinter := TRPBandPrinter.Create(Self);
    BandPrinter.Height := Height;
    //BandPrinter.OnPrintBand := FOnPrintBand;
    BandPrinter.IsMoveEmptyGroup := IsMoveEmptyGroup;
    FPrintingInfo.PrintStack := Stack;
    FPrintingInfo.BandPrinter := BandPrinter;
    try
      BeginPrint;
      BandPrinter.Init;

      // push me
      Stack.Push(self);
      // pop a band, then call its ProcessPrintStack , until this Stack is empty
      while (Stack.Count>0) and not StopPage do
      begin
        Band := Stack.Peek;
        BandDesc := Band.ClassName+'.'+Band.Caption;
        Band.ProcessPrintStack(Stack,BandPrinter);
      end;
      SetReportStatus(rsDone);
      EndPrint;
    except
    {
      on EStopReport do
        EndPrint;
      on ECancelReport do
        AbortPrint;
    else
      begin
        AbortPrint;
        WriteException;
        raise;
      end;
    }
      on E : Exception do
      begin
        // �����˶�Message���жϣ���Ҫ����Ϊ���������safecall�����ⱻת��ΪEOLEException
        if (E is EStopReport) or
          SameText(E.Message,SStopReport) then
        begin
          // ��ֹ�������
          SetReportStatus(rsStopped);
          EndPrint;
        end
        else if (E is ECancelReport) or
          SameText(E.Message,SCancelReport) then
        begin
          // ȡ���������
          SetReportStatus(rsCancelled);
          AbortPrint;
        end
        else
        begin
          SetReportStatus(rsErrorStop);
          AbortPrint;
          //WriteException;
          raise;
        end;
      end;
    end;
  finally
    Stack.Free;
    BandPrinter.Free;
  end;
end;

procedure TRPReport.SetColumns(const Value: Integer);
begin
  CheckTrue(Value>=1,'Columns must be greate than 0');
  FColumns := Value;
  FReportPerPage := Columns * Rows;
end;

procedure TRPReport.SetRows(const Value: Integer);
begin
  CheckTrue(Value>=1,'Rows must be greate than 0');
  FRows := Value;
  FReportPerPage := Columns * Rows;
end;

procedure TRPReport.DoPrintBand(BandPrinter: TRPBandPrinter;
  Band: TRPSimpleBand; const ARect: TRPRect; DeltaY: TFloat);
var
  PhisicalRect : TRPRect;
  Index, ColumnIndex, RowIndex : Integer;
begin
  if SkipPage or StopPage then
    Exit;

  if Assigned(FOnPrintBand) then
    FOnPrintBand(BandPrinter,Band,ARect,DeltaY);

  // ����ʵ�ʵ�����λ��.  
  Index := (BandPrinter.PageNumber-1) mod ReportPerPage;
  RowIndex := Index div Columns;
  Assert((RowIndex>=0) and (RowIndex<Rows));
  ColumnIndex := Index mod Columns;
  PhisicalRect.Left := Margin.Left - StaticMargin.Left   // Device Context ��������ʼλ��
    + ColumnIndex * (Width + ColumnSpace)                // ����������
    + ARect.Left;                                        // ƫ��
  PhisicalRect.Right := PhisicalRect.Left + ARect.Right - ARect.Left;
  PhisicalRect.Top := Margin.Top - StaticMargin.Top      // Device Context ��������ʼλ��
    + RowIndex * (Height + RowSpace)                     // ����������
    + ARect.Top;                                         // ƫ��
  PhisicalRect.Bottom := PhisicalRect.Top + Arect.Bottom - ARect.Top;

  DoPrintBandEx(BandPrinter,Band,ARect,DeltaY,PhisicalRect);
end;

procedure TRPReport.DoPrintBandEx(BandPrinter: TRPBandPrinter;
  Band: TRPSimpleBand; const ARect: TRPRect; DeltaY: TFloat;
  const PhysicalRect: TRPRect);
begin
  if SkipPage or StopPage then
    Exit;
    
  if Assigned(FOnPrintBandEx) then
    FOnPrintBandEx(BandPrinter,Band,ARect,DeltaY,Self, PhysicalRect);
  if (FReportProcessor<>nil) and (Band.ReportObject<>nil) then
    FReportProcessor.ProcessReport(FPrintingInfo,Band.ReportObject, PhysicalRect);
end;

procedure TRPReport.DoNewPage(BandPrinter: TRPBandPrinter);
begin
  Assert(BandPrinter.PageNumber>0);
  FReportPageNumber := BandPrinter.PageNumber;
  if ((BandPrinter.PageNumber-1) mod ReportPerPage)=0 then
    NewPhysicalPage;
end;

procedure TRPReport.NewPhysicalPage;
var
  DoContinue : Boolean;
begin
  Inc(FPageNumber);

  if FReportProcessor<>nil then
  begin
    DoContinue := True;
    FReportProcessor.DoProgress(DoContinue);
    if not DoContinue then
      FPrintStopped := True;
  end;

  if SkipPage or StopPage then
    Exit;

  if Assigned(OnNewPage) then
    OnNewPage(self);
  if FReportProcessor<>nil then
    FReportProcessor.NewPage;
  PrintBackGround;
end;

procedure TRPReport.PrintBackGround;
begin

end;

procedure TRPReport.AbortPrint;
begin
  if FReportProcessor<>nil then
    FReportProcessor.AbortDoc;
end;

procedure TRPReport.BeginPrint;
begin
  if FReportProcessor<>nil then
    FReportProcessor.BeginDoc;
end;

procedure TRPReport.EndPrint;
begin
  if FReportProcessor<>nil then
    FReportProcessor.EndDoc;
end;

procedure TRPReport.SetMargin(const Value: TRPMargin);
begin
  FMargin.Assign(Value);
end;

procedure TRPReport.SetStaticMargin(const Value: TRPMargin);
begin
  FStaticMargin.Assign(Value);
end;

procedure TRPReport.Error(ErrorCode: Integer; const ErrorMsg: string);
begin
  if Assigned(FOnError) then
    FOnError(Self,ErrorCode,ErrorMsg);
end;

function TRPReport.SkipPage: Boolean;
begin
  Result := (FStartPage>0) and (FStartPage>FPageNumber);
end;

function TRPReport.StopPage: Boolean;
begin
  Result := ( (FEndPage>0) and (FEndPage<FPageNumber) )
    or FPrintStopped;
end;

procedure TRPReport.SetReportStatus(const Value: TReportStatus);
begin
  FReportStatus := Value;
  if FReportProcessor<>nil then
    FReportProcessor.SetStatus(Value);
end;

{ TRPPrintedBandInfo }

constructor TRPPrintedBandInfo.Create(ABand: TRPSimpleBand;
  const ItsRect: TRPRect);
begin
  FBand := ABand;
  FARect := ItsRect;
end;

end.
