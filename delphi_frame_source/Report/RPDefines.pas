unit RPDefines;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDefines
   <What>�ṩ��ӡ�����ӿڡ��������������͵ȵȵĶ��塣
   ��������Ԫ�����á�
   <Written By> Huang YanLai
   <See>��ӡ.mdl
   <History>
    0.l �ӿڶ�������PrintDevices.pas
**********************************************}

interface

uses Windows, SysUtils, Classes, Graphics;

const
  TenthMMPerInch = 254; // 1 inch Ӣ��=25.4 millimetres ���� = 254 * 0.1mm
  lcReport = 5;

type
  TFloat = Single; // ���帡��������,���ڱ�ʾ������(0.1mm)
  TLineStyles = class;

  // ���������С
  TRPSize = record
    Width, Height : TFloat;
  end;

  // ���������������
  TRPRect = record
    Left, Right, Top, Bottom : TFloat;
  end;

  TRPHAlign = (haLeft,haRight,haCenter); // �ı�ˮƽ���뷽ʽ
  TRPVAlign = (vaTop,vaBottom,vaCenter,vaMultiLine); // �ı���ֱ���뷽ʽ

  TRPTextFormatType = (  // �ı���ʽ������
    tfNone,       // ��
    tfNormal,     // ʹ��Format()
    tfFloat,      // ʹ��FormatFloat()
    tfDateTime    // ʹ��FormatDateTime()
    );

  {
    <Class>TTransform
    <What>�ṩ����任��������豸����������������꣨0.1mmΪ��λ���ı任
    <Properties>
      XPixesPerTenthMM - ����豸ˮƽ����ÿ0.1mm��������Ŀ
      YPixesPerTenthMM - ����豸��ֱ����ÿ0.1mm��������Ŀ
    <Methods>
      -
    <Event>
      -
  }
  TTransform = class(TObject)
  private
    FYPixesPerTenthMM: TFloat;
    FXPixesPerTenthMM: TFloat;
  protected

  public
    procedure InitFromDC(DC : THandle; OldMethod : Boolean=False);
    procedure InitFromCanvas(Canvas : TCanvas);
    procedure InitFromScreen(OldMethod : Boolean=False);
    property  XPixesPerTenthMM : TFloat read FXPixesPerTenthMM write FXPixesPerTenthMM;
    property  YPixesPerTenthMM : TFloat read FYPixesPerTenthMM write FYPixesPerTenthMM;
    function  Device2PhysicsX(DeviceValue : Integer):TFloat;
    function  Device2PhysicsY(DeviceValue : Integer):TFloat;
    function  Physics2DeviceX(PhysicsValue : TFloat): Integer;
    function  Physics2DeviceY(PhysicsValue : TFloat): Integer;
  end;

  TRPOrientation = (poPortrait, poLandscape);

  {
    <Interface>IBasicPrinter
    <What>��ӡ�����ӿڡ�����λ��ʹ�������ȵ�λ��0.1mm����
    ������
      1����ӡ�豸������
      2���Դ�ӡ���ĵ�����
      3��������ͼ����
    <Properties>
      -
    <Methods>
      -
  }
  { TODO :
������������С����
���߶δ�ϸ�������С���� }
  IBasicPrinter = interface
    function  GetPageNumber: Integer;
    function  GetWidth : TFloat;
    function  GetHeight: TFloat;
    function  GetFont: TFont;
    procedure SetFont(Value : TFont);
    function  GetPen: TPen;
    procedure SetPen(Value : TPen);
    function  GetBrush: TBrush;
    procedure SetBrush(Value : TBrush);

    procedure DrawLine(X1,Y1,X2,Y2 : TFloat);
    procedure DrawEllipse(X1,Y1,X2,Y2 : TFloat);
    procedure DrawRect(X1,Y1,X2,Y2 : TFloat);
    procedure DrawRoundRect(X1,Y1,X2,Y2,X3,Y3 : TFloat);
    procedure DrawArc(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : TFloat);
    procedure FillRect(X1,Y1,X2,Y2 : TFloat);
    procedure DrawGraphic(X1,Y1,X2,Y2 : TFloat; Graphic : TGraphic);
    procedure DrawGraphic2(X,Y : TFloat; Graphic : TGraphic);
    procedure DrawText(X,Y : TFloat; const Text:String);
    procedure DrawTextRect(X1,Y1,X2,Y2 : TFloat; const Text:String; Flags : Integer);
    function  CalcTextSize(const Text:String; IsMultiLine : Boolean; Width : TFloat):TRPSize;

    procedure BeginDoc(const Title:string='');
    procedure EndDoc;
    procedure AbortDoc;
    procedure NewPage;
    procedure GetPageSize(var AWidth,AHeight : TFloat);
    function  Printing: Boolean;
    function  Aborted : Boolean;

    function  GetPaperWidth : TFloat;
    function  GetPaperHeight : TFloat;
    function  GetPaperLeftMargin : TFloat;
    function  GetPaperTopMargin : TFloat;
    function  GetTitle : string;
    function  CanSetPaperSize : Boolean;
    procedure SetPaperSize(APaperWidth, APaperHeight : TFloat; AOrientation : TRPOrientation);
    procedure RestorePaperSize;

    property  PageNumber: Integer read GetPageNumber;
    property  Width : TFloat read GetWidth;
    property  Height: TFloat read GetHeight;
    property  Font : TFont read GetFont write SetFont;
    property  Pen : TPen read GetPen write SetPen;
    property  Brush : TBrush read GetBrush write SetBrush;

    property  PaperWidth : TFloat read GetPaperWidth;
    property  PaperHeight : TFloat read GetPaperHeight;
    property  PaperLeftMargin : TFloat read GetPaperLeftMargin;
    property  PaperTopMargin : TFloat read GetPaperTopMargin;
    property  Title : string read GetTitle;
  end;

  TReportStatus = (rsRunning, rsStopped, rsCancelled, rsErrorStop, rsDone);
  {
    <Interface>IReportProcessor
    <What>������ӿڣ����崦����ָ����λ���������ӡ��һ���������
    �����ṩһ���������Ļ�����
    <Properties>
      -
    <Methods>
      -
  }
  IReportProcessor = interface
    procedure BeginDoc;
    procedure EndDoc;
    procedure AbortDoc;
    procedure NewPage;
    procedure ProcessReport(ReportInfo, ReportedObject : TObject; const ARect : TRPRect);
    function  IsPrint(ReportInfo, ReportedObject : TObject; var ARect : TRPRect): Boolean;
    function  GetLineStyles : TLineStyles;
    function  FindField(const FieldName:string): TObject;
    function  GetVariantText(const FieldName:string; TextFormatType : TRPTextFormatType=tfNone; const TextFormat : string=''): string;
    property  LineStyles : TLineStyles read GetLineStyles;
    procedure DoProgress(var ContinuePrint : Boolean);
    function  GetStatus : TReportStatus;
    procedure SetStatus(Value: TReportStatus);
  end;

  {
    <Class>TLineStyle
    <What>����һ������
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TLineStyle = class(TCollectionItem)
  private
    FPen: TPen;
    procedure   SetPen(const Value: TPen);
  protected

  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
    procedure   Assign(Source : TPersistent) ; override;
  published
    property    Pen : TPen read FPen write SetPen;
  end;

  {
    <Class>TLineStyles
    <What>������Ҫ������
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TLineStyles = class(TOwnedCollection)
  private
    function    GetLineStyles(Index: Integer): TLineStyle;
  public
    constructor Create(AOwner: TPersistent);
    property    LineStyles[Index : Integer] : TLineStyle read GetLineStyles; default;
  end;

  {
    <Class>TRPFrame
    <What>�������α߿�
    ���������͵�����ֵ��־
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPFrame = class(TPersistent)
  private
    FOnChanged: TNotifyEvent;
    function    GetBorder(Index : Integer): Integer;
    procedure   SetBorder(Index, Value: Integer);
    procedure   Changed;
  public
    FBorders : Array[0..3] of Integer;
    constructor Create;
    procedure   Assign(Source: TPersistent); override;
    property    OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
  published
    // clockwise
    property    Top : Integer Index 0 read GetBorder write SetBorder default -1;
    property    Right : Integer Index 1 read GetBorder write SetBorder  default -1;
    property    Bottom : Integer Index 2 read GetBorder write SetBorder default -1;
    property    Left : Integer Index 3 read GetBorder write SetBorder default -1;
  end;

  {
    <Class>TRPMargin
    <What>������ӡҳ���ܵĿհ�
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPMargin = class(TPersistent)
  private
    FTop: TFloat;
    FLeft: TFloat;
    FRight: TFloat;
    FBottom: TFloat;
    FOnChanged: TNotifyEvent;
    procedure   Changed;
    procedure   SetBottom(const Value: TFloat);
    procedure   SetLeft(const Value: TFloat);
    procedure   SetRight(const Value: TFloat);
    procedure   SetTop(const Value: TFloat);
  public
    procedure   Assign(Source: TPersistent); override;
    property    OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
  published
    property    Left: TFloat read FLeft write SetLeft;
    property    Right: TFloat read FRight write SetRight;
    property    Top: TFloat read FTop write SetTop;
    property    Bottom: TFloat read FBottom write SetBottom;
  end;

  // ���� Controls.TAnchors �� Controls.TAnchorKind
  TRPAnchorKind = (rakLeft,  rakTop, rakRight, rakBottom);
  TRPAnchors = set of TRPAnchorKind; // ����һ������������������屨����Ƶ�λ�ù�ϵ

  // Ԥ�����ֽ�Ŵ�С
  TRPPaperSize = (Letter,
                  LetterSmall,
                  Tabloid,
                  Ledger,
                  Legal,
                  Statement,
                  Executive,
                  A3,
                  A4,
                  A4Small,
                  A5,
                  B4,
                  B5,
                  Folio,
                  Quarto,
                  qr10X14,
                  qr11X17,
                  Note,
                  Env9,
                  Env10,
                  Env11,
                  Env12,
                  Env14,
                  CSheet,
                  DSheet,
                  ESheet,
                  Custom);

  {
    <Class>EStopReport
    <What>��ֹ��ӡ��������󡣼̳���EAbort������ֹͣ��ӡ�������ӡ������ָ���Ĵ�ӡ��Χ��
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EStopReport = class(EAbort);
  {
    <Class>ECancelReport
    <What>ȡ����ӡ��������󡣼̳���EAbort������ȡ����ǰ��ӡ��
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  ECancelReport = class(EAbort);
  //ECancelReport = class(Exception);

{
  <Function>GetTextFlags
  <What>�������ֶ��뷽ʽ��Ӧ����ֵ��
  <Params>
    -
  <Return>
  <Exception>
}
function GetTextFlags(HAlign : TRPHAlign; VAlign : TRPVAlign): Integer;

{
  <Procedure>StopReport
  <What>������ֹͣ��ӡ�����⣨EStopReport����ʹ�ô�ӡ��ֹͣ��
  <Params>
    -
  <Exception>
}
procedure StopReport;

{
  <Procedure>CancelReport
  <What>������ȡ����ӡ�����⣨ECancelReport����ʹ�ô�ӡ��ȡ����
  <Params>
    -
  <Exception>
}
procedure CancelReport;

var
  ScreenTransform : TTransform; // ȫ�ֱ�����������Ļ�������С������任

const
  { Actual paper sizes for all the known paper types }
  RPPaperSizeMetrics : array[Letter..ESheet, 0..1] of TFloat =
      ((215.9, 279.4), { Letter }
       (215.9, 279.4), { Letter small }
       (279.4, 431.8), { Tabloid }
       (431.8, 279.4), { Ledger }
       (215.9, 355.6), { Legal }
       (139.7, 215.9), { Statement }
       (190.5, 254.0), { Executive }
       (297.0, 420.0), { A3 }
       (210.0, 297.0), { A4 }
       (210.0, 297.0), { A4 small }
       (148.0, 210.0), { A5 }
       (250.0, 354.0), { B4 }
       (182.0, 257.0), { B5 }
       (215.9, 330.2), { Folio }
       (215.0, 275.0), { Quarto }
       (254.0, 355.6), { 10X14 }
       (279.4, 431.8), { 11X17 }
       (215.9, 279.0), { Note }
       (98.43, 225.4), { Envelope #9 }
       (104.8, 241.3), { Envelope #10 }
       (114.3, 263.5), { Envelope #11 }
       (101.6, 279.4), { Envelope #12 - might be wrong !! }
       (127.0, 292.1), { Envelope #14 }
       (100.0, 100.0),
       (100.0, 100.0),
       (100.0, 100.0));

resourcestring
  SStopReport = '�жϱ������';
  SCancelReport = 'ȡ���������';

implementation

function GetTextFlags(HAlign : TRPHAlign; VAlign : TRPVAlign): Integer;
const
  HAligns: array[TRPHAlign] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VAligns: array[TRPVAlign] of Word = (DT_TOP or DT_SINGLELINE,
    DT_BOTTOM or DT_SINGLELINE,
    DT_VCENTER or DT_SINGLELINE,
    DT_WORDBREAK or DT_EDITCONTROL);
begin
  Result := HAligns[HAlign] or VAligns[VAlign];
end;

{ TTransform }

function TTransform.Device2PhysicsX(DeviceValue: Integer): TFloat;
begin
  Result := DeviceValue / FXPixesPerTenthMM;
end;

function TTransform.Device2PhysicsY(DeviceValue: Integer): TFloat;
begin
  Result := DeviceValue / FYPixesPerTenthMM;
end;

procedure TTransform.InitFromCanvas(Canvas: TCanvas);
begin
  InitFromDC(Canvas.Handle);
end;

procedure TTransform.InitFromDC(DC: THandle; OldMethod : Boolean=False);
begin
  if not OldMethod then
  begin
    // ����1
    // this only work for printers.
    // when metafile, it's a X Pixes Per "logic" 0.1mm
    // ����ʾ�����õ������߼��������ñ�������Ļ��ʾ�������Сƥ�䣬������Ļ��ʾ��ͼ�γߴ��ʵ�ʵĴ�
    XPixesPerTenthMM := GetDeviceCaps(DC, LogPixelsX) / TenthMMPerInch;
    YPixesPerTenthMM := GetDeviceCaps(DC, LogPixelsY) / TenthMMPerInch;
  end
  else
  begin
    // ����2
    // �õ����������������ʾ��ͼ�γߴ��ʵ�ʳߴ���ͬ�����������С��ƥ�䡣
    XPixesPerTenthMM := GetDeviceCaps(DC,HORZRES)/GetDeviceCaps(DC,HORZSIZE)/10;
    YPixesPerTenthMM := GetDeviceCaps(DC,VERTRES)/GetDeviceCaps(DC,VERTSIZE)/10;
  end;
end;

procedure TTransform.InitFromScreen(OldMethod : Boolean=False);
var
  Win : THandle;
  DC : THandle;
begin
  //Win := GetDesktopWindow;
  Win := 0;
  DC := GetDC(Win);
  try
    InitFromDC(DC,OldMethod);
  finally
    ReleaseDC(Win, DC);
  end;
end;

function TTransform.Physics2DeviceX(PhysicsValue: TFloat): Integer;
begin
  Result := Round(PhysicsValue * FXPixesPerTenthMM);
end;

function TTransform.Physics2DeviceY(PhysicsValue: TFloat): Integer;
begin
  Result := Round(PhysicsValue * FYPixesPerTenthMM);
end;


{ TLineStyle }

procedure TLineStyle.Assign(Source: TPersistent);
begin
  if Source is TLineStyle then
  begin
    Pen := TLineStyle(Source).Pen;
  end
  else
  inherited;

end;

constructor TLineStyle.Create(Collection: TCollection);
begin
  inherited;
  FPen := TPen.Create;
end;

destructor TLineStyle.Destroy;
begin
  FPen.Free;
  inherited;
end;

procedure TLineStyle.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

{ TLineStyles }

constructor TLineStyles.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TLineStyle);
end;

function TLineStyles.GetLineStyles(Index: Integer): TLineStyle;
begin
  Result := TLineStyle(Items[Index]);
end;

{ TRPFrame }

procedure TRPFrame.Assign(Source: TPersistent);
begin
  if Source is TRPFrame then
    FBorders := TRPFrame(Source).FBorders
  else
    inherited;
end;

procedure TRPFrame.Changed;
begin
  if Assigned(FOnChanged) then
    FOnChanged(self);
end;

constructor TRPFrame.Create;
begin
  FBorders[0]:=-1;
  FBorders[1]:=-1;
  FBorders[2]:=-1;
  FBorders[3]:=-1;
end;

function TRPFrame.GetBorder(Index: Integer): Integer;
begin
  Assert((Index>=0) and (Index<=3));
  Result := FBorders[Index];
end;

procedure TRPFrame.SetBorder(Index, Value: Integer);
begin
  Assert((Index>=0) and (Index<=3));
  if FBorders[Index]<>Value then
  begin
    FBorders[Index]:=Value;
    Changed;
  end;
end;

{ TRPMargin }

procedure TRPMargin.Assign(Source: TPersistent);
begin
  if Source is TRPMargin then
  begin
    FLeft := TRPMargin(Source).Left;
    FRight:= TRPMargin(Source).Right;
    FTop := TRPMargin(Source).Top;
    FBottom:= TRPMargin(Source).Bottom;
    Changed;
  end
  else
    inherited;
end;

procedure TRPMargin.Changed;
begin
  if Assigned(OnChanged) then
    OnChanged(Self);
end;

procedure TRPMargin.SetBottom(const Value: TFloat);
begin
  if FBottom <> Value then
  begin
    FBottom := Value;
    Changed;
  end;
end;

procedure TRPMargin.SetLeft(const Value: TFloat);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    Changed;
  end;
end;

procedure TRPMargin.SetRight(const Value: TFloat);
begin
  if FRight <> Value then
  begin
    FRight := Value;
    Changed;
  end;
end;

procedure TRPMargin.SetTop(const Value: TFloat);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    Changed;
  end;
end;

procedure StopReport;
begin
  raise EStopReport.Create(SStopReport);
end;

procedure CancelReport;
begin
  raise ECancelReport.Create(SCancelReport);
end;

initialization
  ScreenTransform := TTransform.Create;
  ScreenTransform.InitFromScreen;
finalization
  ScreenTransform.Free;

end.
