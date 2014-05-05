{********************************************}
{  TeeChart Pro Charting Library             }
{  For Borland Delphi, C++ Builder & Kylix   }
{  Copyright (c) 1995-2003 by David Berneda  }
{  All Rights Reserved                       }
{********************************************}
unit TeEngine;
{$I TeeDefs.inc}

interface

uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     SysUtils, Classes,
     {$IFDEF CLX}
     QGraphics, QControls, QDialogs, Types,
     {$ELSE}
     Graphics, Controls,
     {$ENDIF}
     {$IFDEF TEETRIAL}
     TeeAbout,
     {$ENDIF}
     TeeProcs, TeCanvas;

Const ChartMarkColor   = clInfoBk (* $80FFFF *);  { default Series Mark back color }
      MinAxisIncrement :Double = 0.000000000001;  { <-- "double" for BCB }
      MinAxisRange     :Double = 0.0000000001;    { <-- "double" for BCB }
      TeeAllValues     = -1;

      {$IFDEF D6}
      clTeeColor       =TColor(clDefault);
      {$ELSE}
      clTeeColor       =TColor($20000000);
      {$ENDIF}

      ChartSamplesMax  = 1000;
      TeeAutoZOrder     = -1;
      TeeAutoDepth      = -1;
      TeeNoPointClicked = -1;

      TeeColumnSeparator: AnsiChar = #6;  // To separate columns in Legend
      TeeLineSeparator  : AnsiChar = #13; // To separate lines of text

var   TeeCheckMarkArrowColor : Boolean=False; // when True, the Marks arrow pen
                                              // color is changed if the point has
                                              // the same color.
      TeeRandomAtRunTime     : Boolean=False; // adds random values at run-time too

      clTeeGallery1:Integer = 1; // index of ColorPalette[] global variable
      clTeeGallery2:Integer = 4; // index of ColorPalette[] global variable

type
  TCustomAxisPanel=class;

  TCustomChartElement=class(TComponent)
  private
    FActive : Boolean;
    FBrush  : TChartBrush;
    FParent : TCustomAxisPanel;
    FPen    : TChartPen;
  protected
    Procedure CanvasChanged(Sender:TObject); virtual;
    Function CreateChartPen:TChartPen;
    class Function GetEditorClass:String; virtual;
    Procedure SetActive(Value:Boolean); virtual;
    Procedure SetBooleanProperty(Var Variable:Boolean; Value:Boolean);
    procedure SetBrush(const Value: TChartBrush);
    Procedure SetColorProperty(Var Variable:TColor; Value:TColor);
    Procedure SetDoubleProperty(Var Variable:Double; Const Value:Double);
    Procedure SetIntegerProperty(Var Variable:Integer; Value:Integer);
    Procedure SetParentChart(Const Value:TCustomAxisPanel); virtual;
    procedure SetParentComponent(AParent: TComponent); override;
    procedure SetPen(const Value: TChartPen); virtual;
    Procedure SetStringProperty(Var Variable:String; Const Value:String);
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    procedure Assign(Source:TPersistent); override;
    Function GetParentComponent: TComponent; override;
    Function HasParent:Boolean; override;
    Procedure Repaint;

    property Active:Boolean read FActive write SetActive default True;
    property Brush:TChartBrush read FBrush write SetBrush;
    property ParentChart:TCustomAxisPanel read FParent write SetParentChart stored False;
    property Pen:TChartPen read FPen write SetPen;

    // Alias for Active property.
    property Visible:Boolean read FActive write SetActive default True;
  end;

  TCustomChartSeries=class;

  TChartSeries=class;

  {$IFDEF TEEVALUESINGLE}
  TChartValue=Single;
  {$ELSE}
  {$IFDEF TEEVALUEDOUBLE}
  TChartValue=Double;
  {$ELSE}
  {$IFDEF TEEVALUEEXTENDED}
  TChartValue=Extended;
  {$ELSE}
  TChartValue=Double;  { <-- default }
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF TEEARRAY}
  TChartValues=Array of TChartValue;
  {$ELSE}
  PChartValue=^TChartValue;
  {$ENDIF}

  TChartListOrder=(loNone,loAscending,loDescending);

  TChartValueList=class(TPersistent)
  private
    FDateTime    : Boolean;
    {$IFNDEF TEEARRAY}
    FList        : TList;
    {$ENDIF}
    FMaxValue    : TChartValue;
    FMinValue    : TChartValue;
    {$IFDEF TEEMULTIPLIER}
    FMultiplier  : Double;  { obsolete }
    {$ENDIF}
    FName        : String;
    FOrder       : TChartListOrder;
    FOwner       : TChartSeries;
    FTempValue   : TChartValue;
    FTotal       : Double;
    FTotalABS    : Double;
    FValueSource : String;

    { internal }
    IDefDateTime : Boolean;

    Function CompareValueIndex(a,b:Integer):Integer;
    Function GetMaxValue:TChartValue;
    Function GetMinValue:TChartValue;
    Function GetTotal:Double;
    Function GetTotalABS:Double;
    function IsDateStored: Boolean;
    procedure SetDateTime(Const Value:Boolean);
    {$IFDEF TEEMULTIPLIER}
    Function IsMultiStored:Boolean;
    Procedure SetMultiplier(Const Value:Double); { obsolete }
    {$ELSE}
    procedure ReadMultiplier(Reader: TReader);
    {$ENDIF}
    Procedure SetValueSource(Const Value:String);
  protected
    IData       : TObject;
    Function AddChartValue(Const AValue:TChartValue):Integer; virtual;
    Procedure ClearValues; virtual;
    {$IFNDEF TEEMULTIPLIER}
    procedure DefineProperties(Filer: TFiler); override;
    {$ENDIF}
    Function GetValue(ValueIndex:Integer):TChartValue;
    Procedure InitDateTime(Value:Boolean);
    Procedure InsertChartValue(ValueIndex:Integer; Const AValue:TChartValue); virtual;
    Procedure RecalcStats;
    Procedure SetValue(ValueIndex:Integer; Const AValue:TChartValue);
  public
    {$IFDEF TEEARRAY}
    Value    : TChartValues;
    Count    : Integer;
    {$ENDIF}
    Modified : Boolean;
    Constructor Create(AOwner:TChartSeries; Const AName:String); virtual;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    {$IFNDEF TEEARRAY}
    Function Count:Integer; virtual;
    {$ENDIF}
    Procedure Delete(ValueIndex:Integer); overload; virtual;
    Procedure Delete(Start,Quantity:Integer); overload;
    {$IFDEF TEEARRAY}
    Procedure Exchange(Index1,Index2:Integer);
    {$ENDIF}
    Procedure FillSequence;
    Function First:TChartValue;
    Function Last:TChartValue;
    Function Locate(Const AValue:TChartValue):Integer;
    Function Range:TChartValue;
    Procedure Scroll; dynamic;
    Procedure Sort;

    property MaxValue:TChartValue read GetMaxValue;
    property MinValue:TChartValue read GetMinValue;
    property Owner:TChartSeries read FOwner;
    property TempValue:TChartValue read FTempValue write FTempValue;
    Function ToString(Index:Integer):String;
    property Total:Double read GetTotal;
    property TotalABS:Double read GetTotalABS write FTotalABS;
    {$IFDEF TEEARRAY}
    property Items[Index:Integer]:TChartValue read GetValue write SetValue; default;
    {$ELSE}
    property Value[Index:Integer]:TChartValue read GetValue write SetValue; default;
    {$ENDIF}
  published
    property DateTime:Boolean read FDateTime write SetDateTime stored IsDateStored;
    property Name:String read FName write FName;
    {$IFDEF TEEMULTIPLIER}
    property Multiplier:Double read FMultiplier write SetMultiplier stored IsMultiStored; { obsolete }
    {$ENDIF}
    property Order:TChartListOrder read FOrder write FOrder default loNone;
    property ValueSource:String read FValueSource write SetValueSource;
  end;

  TChartAxisTitle=class(TTeeCustomShape)
  private
    FAngle        : Integer;
    FCaption      : String;

    IDefaultAngle : Integer;
    Function IsAngleStored:Boolean;
    Procedure SetAngle(const Value:Integer);
    Procedure SetCaption(Const Value:String);
  public
    Procedure Assign(Source:TPersistent); override;
  published
    property Angle:Integer read FAngle write SetAngle stored IsAngleStored;
    property Caption:String read FCaption write SetCaption;
    property Font;
    property Visible default True;
  end;

  AxisException=class(Exception);

  TAxisLabelStyle=(talAuto,talNone,talValue,talMark,talText);
  TAxisLabelAlign=(alDefault,alOpposite);

  TAxisCalcPos=function(const Value:TChartValue):Integer of object;

  TChartSeriesList=class;

  TAxisGridPen=class(TDottedGrayPen)
  private
    FZ : Double;
    IDefaultZ : Double;
    FCentered: Boolean;
    function IsZStored:Boolean;
    procedure SetZ(const Value:Double);
    procedure SetCentered(const Value: Boolean);
  public
    // (pending to move Centered to "published" after removing Axis.GridCentered)
    property Centered:Boolean read FCentered write SetCentered default False;
  published
    property ZPosition:Double read FZ write SetZ stored IsZStored;
  end;

  TAxisTicks=Array of Integer;

  TChartAxis=class;

  TAxisItems=class;

  TAxisItem=class(TTeeCustomShape)
  private
    FValue : Double;
    FText  : String;

    IAxisItems : TAxisItems;
    procedure SetText(const Value: String);
    procedure SetValue(const Value: Double);
  public
    procedure Repaint;
  published
    property Bevel;
    property BevelWidth;
    property Color;
    property Font;
    property Gradient;
    property Shadow;
    property ShapeStyle;
    property Text:String read FText write SetText;
    property Transparency;
    property Transparent default True;
    property Value:Double read FValue write SetValue;
  end;

  TAxisItems=class(TList)
  private
    FFormat: TTeeShape;
    IAxis : TChartAxis;
    function Get(Index:Integer):TAxisItem;
  public
    Constructor Create(Axis:TChartAxis);
    Destructor Destroy; override;

    Function Add(const Value: Double):TAxisItem; overload;
    Function Add(const Value: Double; const Text:String):TAxisItem; overload;
    Procedure CopyFrom(Source:TAxisItems);
    Procedure Clear; override;

    property Format:TTeeShape read FFormat;
    property Item[Index:Integer]:TAxisItem read Get; default;
  end;

  // internal event, used at TGridBandTool class (only)
  TAxisDrawGrids=procedure(Sender:TChartAxis) of object;

  TChartAxis=class(TCollectionItem)
  private
    { scales }
    FAutomatic        : Boolean;
    FAutomaticMaximum : Boolean;
    FAutomaticMinimum : Boolean;
    FDesiredIncrement : Double;
    FMaximumValue     : Double;
    FMinimumValue     : Double;
    FLogarithmic      : Boolean;
    FLogarithmicBase  : Double; // 6.0
    FMaximumOffset    : Integer;
    FMinimumOffset    : Integer;

    { axis }
    FAxis             : TChartAxisPen;
    FPosAxis          : Integer;
    FZPosition        : Double;

    { title }
    FAxisTitle        : TChartAxisTitle;
    FTitleSize        : Integer;
    FPosTitle         : Integer;

    { grid }
    FGrid             : TAxisGridPen;

    { labels }
    FLabelsAlign      : TAxisLabelAlign;
    FLabelsAngle      : Integer;
    FItems            : TAxisItems;
    FLabelsOnAxis     : Boolean;
    FLabelsSeparation : Integer;
    FLabelsSize       : Integer;
    FLabelStyle       : TAxisLabelStyle;
    FLabelsExponent   : Boolean;
    FLabelsMultiLine  : Boolean;

    FPosLabels        : Integer;
    FAxisValuesFormat : String;
    FDateTimeFormat   : String;
    FExactDateTime    : Boolean;
    FRoundFirstLabel  : Boolean;

    { ticks }
    FMinorGrid        : TChartHiddenPen;

    FMinorTickCount   : Integer;
    FMinorTickLength  : Integer;
    FMinorTicks       : TDarkGrayPen;

    FTicks            : TDarkGrayPen;
    FTicksInner       : TDarkGrayPen;
    FTickInnerLength  : Integer;
    FTickLength       : Integer;
    FTickOnLabelsOnly : Boolean;

    { other }
    FInverted         : Boolean;
    FHorizontal       : Boolean;
    FOtherSide        : Boolean;
    FParentChart      : TCustomAxisPanel;
    FVisible          : Boolean;
    FStartPosition    : Double;
    FEndPosition      : Double;
    FPositionPercent  : Double;
    FPosUnits         : TTeeUnits;

    { internal }
    IAxisDateTime     : Boolean;
    IAxisLogSizeRange : TChartValue;
    IAxisSizeRange    : TChartValue;
    ICenterPos        : Integer;
    IDepthAxis        : Boolean;
    ILogMax           : Double;
    ILogMin           : Double;
    IMaximum          : Double;
    IMinimum          : Double;
    IRange            : TChartValue;
    IRangeLog         : Double;
    IRangeZero        : Boolean;
    ISeriesList       : TChartSeriesList;
    IZPos             : Integer;

    Procedure SetAutomatic(Value:Boolean);
    Procedure SetAutomaticMinimum(Value:Boolean);
    Procedure SetAutomaticMaximum(Value:Boolean);
    Procedure SetAutoMinMax(Var Variable:Boolean; Var2,Value:Boolean);
    Procedure SetAxis(Value:TChartAxisPen);
    procedure SetAxisTitle(Value:TChartAxisTitle);
    Procedure SetDateTimeFormat(Const Value:String);
    Procedure SetDesiredIncrement(Const Value:Double);
    Procedure SetExactDateTime(Value:Boolean);
    Procedure SetGrid(Value:TAxisGridPen);
    procedure SetGridCentered(Value:Boolean);
    Procedure SetInverted(Value:Boolean);
    Procedure SetLabels(Value:Boolean);
    Procedure SetLabelsAlign(Value:TAxisLabelAlign);
    Procedure SetLabelsAngle(const Value:Integer);
    Procedure SetLabelsFont(Value:TTeeFont);
    Procedure SetLabelsMultiLine(Value:Boolean);
    Procedure SetLabelsOnAxis(Value:Boolean);
    Procedure SetLabelsSeparation(Value:Integer);
    Procedure SetLabelsSize(Value:Integer);
    Procedure SetLabelStyle(Value:TAxisLabelStyle);
    Procedure SetLogarithmic(Value:Boolean);
    Procedure SetLogarithmicBase(const Value:Double);
    Procedure SetMaximum(Const Value:Double);
    Procedure SetMinimum(Const Value:Double);
    Procedure SetMinorGrid(Value:TChartHiddenPen);
    Procedure SetMinorTickCount(Value:Integer);
    Procedure SetMinorTickLength(Value:Integer);
    Procedure SetMinorTicks(Value:TDarkGrayPen);
    procedure SetStartPosition(Const Value:Double);
    procedure SetEndPosition(Const Value:Double);
    procedure SetPositionPercent(Const Value:Double);
    procedure SetPosUnits(const Value: TTeeUnits);
    procedure SetRoundFirstLabel(Value:Boolean);
    Procedure SetTickLength(Value:Integer);
    Procedure SetTickInnerLength(Value:Integer);
    Procedure SetTicks(Value:TDarkGrayPen);
    Procedure SetTicksInner(Value:TDarkGrayPen);
    procedure SetTickOnLabelsOnly(Value:Boolean);
    Procedure SetTitleSize(Value:Integer);
    Procedure SetValuesFormat(Const Value:String);
    Procedure SetVisible(Value:Boolean);

    Function ApplyPosition(APos:Integer; Const R:TRect):Integer;
    Function CalcDateTimeIncrement(MaxNumLabels:Integer):Double;
    Function CalcLabelsIncrement(MaxNumLabels:Integer):Double;
    Procedure CalcRect(Var R:TRect; InflateChartRectangle:Boolean);
    Function CalcZPos:Integer;
    Procedure DrawTitle(x,y:Integer);
    Function GetGridCentered:Boolean;
    Function GetLabels:Boolean;
    Function GetLabelsFont:TTeeFont;
    Function GetRectangleEdge(Const R:TRect):Integer;
    Procedure IncDecDateTime( Increment:Boolean;
                              Var Value:Double;
                              Const AnIncrement:Double;
                              tmpWhichDateTime:TDateTimeStep );
    Function LogXPosValue(Const Value:TChartValue):Integer;
    Function LogYPosValue(Const Value:TChartValue):Integer;
    Function InternalCalcDepthPosValue(Const Value:TChartValue):Integer;
    Procedure InternalCalcRange;
    Procedure InternalCalcPositions;
    Function InternalCalcSize( tmpFont:TTeeFont;
                               tmpAngle:Integer;
                               Const tmpText:String;
                               tmpSize:Integer):Integer;
    Function InternalLabelSize(Const Value:Double; IsWidth:Boolean):Integer;
    Procedure InternalSetMaximum(Const Value:Double);
    Procedure InternalSetMinimum(Const Value:Double);

    function IsAxisValuesFormatStored:Boolean;
    function IsLogBaseStored: Boolean;
    Function IsMaxStored:Boolean;
    Function IsMinStored:Boolean;
    Function IsPosStored:Boolean;
    Function IsStartStored:Boolean;
    Function IsEndStored:Boolean;
    Function IsCustom:Boolean;
    function IsZStored: Boolean;
    Procedure RecalcSizeCenter;
    procedure SetHorizontal(const Value: Boolean);
    procedure SetOtherSide(const Value: Boolean);
    procedure SetLabelsExponent(Value: Boolean);
    procedure SetZPosition(const Value: Double);
    Procedure SetCalcPosValue;
    procedure SetMaximumOffset(const Value: Integer);
    procedure SetMinimumOffset(const Value: Integer);
    Function XPosValue(Const Value:TChartValue):Integer;
    Function YPosValue(Const Value:TChartValue):Integer;
    Function XPosValueCheck(Const Value:TChartValue):Integer;
    Function YPosValueCheck(Const Value:TChartValue):Integer;
  protected
    IHideBackGrid : Boolean;
    OnDrawGrids   : TAxisDrawGrids;
    Tick          : TAxisTicks;

    Function AxisRect:TRect;
    Function InternalCalcLabelStyle:TAxisLabelStyle; virtual;
    Procedure InternalSetInverted(Value:Boolean);
    Function SizeLabels:Integer;
    Function SizeTickAxis:Integer;
  public
    IStartPos     : Integer;
    IEndPos       : Integer;
    IAxisSize     : Integer;
    CalcXPosValue : TAxisCalcPos;
    CalcYPosValue : TAxisCalcPos;
    CalcPosValue  : TAxisCalcPos;

    {$IFDEF D5}
    Constructor Create(Chart:TCustomAxisPanel); reintroduce; overload;
    {$ENDIF}
    Constructor Create(Collection:TCollection); {$IFDEF D5}overload;{$ENDIF} override;
    Destructor Destroy; override;

    Procedure AdjustMaxMin;
    Procedure AdjustMaxMinRect(Const Rect:TRect);
    procedure Assign(Source: TPersistent); override;
    Function CalcIncrement:Double;
    Function CalcLabelStyle:TAxisLabelStyle;
    Procedure CalcMinMax(Var AMin,AMax:Double);
    Function CalcPosPoint(Value:Integer):Double;
    Function CalcSizeValue(Const Value:Double):Integer;
    Function CalcXYIncrement(MaxLabelSize:Integer):Double;

    Procedure CustomDraw( APosLabels,APosTitle,APosAxis:Integer;
                          GridVisible:Boolean);
    Procedure CustomDrawMinMax( APosLabels,
                                APosTitle,
                                APosAxis:Integer;
                                GridVisible:Boolean;
                                Const AMinimum,AMaximum,AIncrement:Double);
    Procedure CustomDrawMinMaxStartEnd( APosLabels,
                                        APosTitle,
                                        APosAxis:Integer;
                                        GridVisible:Boolean;
                                        Const AMinimum,AMaximum,AIncrement:Double;
                                        AStartPos,AEndPos:Integer);
    Procedure CustomDrawStartEnd( APosLabels,APosTitle,APosAxis:Integer;
                                  GridVisible:Boolean; AStartPos,AEndPos:Integer);

    Function Clicked(x,y:Integer):Boolean;
    Procedure Draw(CalcPosAxis:Boolean);
    procedure DrawAxisLabel(x,y,Angle:Integer; Const St:String; Format:TTeeCustomShape=nil);
    Function IsDateTime:Boolean;
    Function LabelWidth(Const Value:Double):Integer;
    Function LabelHeight(Const Value:Double):Integer;
    Function LabelValue(Const Value:Double):String;
    Function MaxLabelsWidth:Integer;

    Procedure Scroll(Const Offset:Double; CheckLimits:Boolean);
    Procedure SetMinMax(AMin,AMax:Double);

    { public }
    property IsDepthAxis  : Boolean read IDepthAxis;
    property Items        : TAxisItems read FItems;
    property PosAxis      : Integer read FPosAxis;
    property PosLabels    : Integer read FPosLabels;
    property PosTitle     : Integer read FPosTitle;
    property ParentChart  : TCustomAxisPanel read FParentChart;
  published
    property Automatic:Boolean read FAutomatic write SetAutomatic default True;
    property AutomaticMaximum:Boolean read FAutomaticMaximum write SetAutomaticMaximum default True;
    property AutomaticMinimum:Boolean read FAutomaticMinimum write SetAutomaticMinimum default True;
    property Axis:TChartAxisPen read FAxis write SetAxis;
    property AxisValuesFormat:String read FAxisValuesFormat
                                     write SetValuesFormat stored IsAxisValuesFormatStored;
    property DateTimeFormat:String read FDateTimeFormat write SetDateTimeFormat;
    property ExactDateTime:Boolean read FExactDateTime write SetExactDateTime default True;
    property Grid:TAxisGridPen read FGrid write SetGrid;
    property GridCentered:Boolean read GetGridCentered write SetGridCentered default False;
    property Increment:Double read FDesiredIncrement write SetDesiredIncrement;
    property Inverted:Boolean read FInverted write SetInverted default False;

    property Horizontal : Boolean read FHorizontal write SetHorizontal stored IsCustom;
    property OtherSide  : Boolean read FOtherSide write SetOtherSide stored IsCustom;

    property Labels:Boolean read GetLabels write SetLabels default True;
    property LabelsAlign:TAxisLabelAlign read FLabelsAlign write SetLabelsAlign default alDefault;
    property LabelsAngle:Integer read FLabelsAngle write SetLabelsAngle default 0;
    property LabelsExponent:Boolean read FLabelsExponent write SetLabelsExponent default False;
    property LabelsFont:TTeeFont read GetLabelsFont write SetLabelsFont {stored IsFontStored};
    property LabelsMultiLine:Boolean read FLabelsMultiLine write SetLabelsMultiLine default False;
    property LabelsOnAxis:Boolean read FLabelsOnAxis write SetLabelsOnAxis default True;
    property LabelsSeparation:Integer read FLabelsSeparation
                                      write SetLabelsSeparation default 10;
    property LabelsSize:Integer read FLabelsSize write SetLabelsSize default 0;
    property LabelStyle:TAxisLabelStyle read FLabelStyle write SetLabelStyle default talAuto;

    property Logarithmic:Boolean read FLogarithmic write SetLogarithmic default False;
    property LogarithmicBase:Double read FLogarithmicBase write SetLogarithmicBase stored IsLogBaseStored;

    property Maximum:Double read FMaximumValue write SetMaximum stored IsMaxStored;
    property MaximumOffset:Integer read FMaximumOffset write SetMaximumOffset default 0;
    property Minimum:Double read FMinimumValue write SetMinimum stored IsMinStored;
    property MinimumOffset:Integer read FMinimumOffset write SetMinimumOffset default 0;

    property MinorGrid:TChartHiddenPen read FMinorGrid write SetMinorGrid;
    property MinorTickCount:Integer read FMinorTickCount write SetMinorTickCount default 3;
    property MinorTickLength:Integer read FMinorTickLength write SetMinorTickLength default 2;
    property MinorTicks:TDarkGrayPen read FMinorTicks write SetMinorTicks;
    property StartPosition:Double read FStartPosition write SetStartPosition
                                    stored IsStartStored;
    property EndPosition:Double read FEndPosition write SetEndPosition
                                    stored IsEndStored;
    property PositionPercent:Double read FPositionPercent write SetPositionPercent
                                    stored IsPosStored;
    property PositionUnits:TTeeUnits read FPosUnits write SetPosUnits default muPercent;
    property RoundFirstLabel:Boolean read FRoundFirstLabel write SetRoundFirstLabel default True;
    property TickInnerLength:Integer read FTickInnerLength write SetTickInnerLength default 0;
    property TickLength:Integer read FTickLength write SetTickLength default 4;
    property Ticks:TDarkGrayPen read FTicks write SetTicks;
    property TicksInner:TDarkGrayPen read FTicksInner write SetTicksInner;
    property TickOnLabelsOnly:Boolean read FTickOnLabelsOnly write SetTickOnLabelsOnly default True;
    property Title:TChartAxisTitle read FAxisTitle write SetAxisTitle;
    property TitleSize:Integer read FTitleSize write SetTitleSize default 0;
    property Visible:Boolean read FVisible write SetVisible default True;
    property ZPosition:Double read FZPosition write SetZPosition stored IsZStored;
  end;

  TChartDepthAxis=class(TChartAxis)
  protected
    Function InternalCalcLabelStyle:TAxisLabelStyle; override;
  published
    property Visible default False;
  end;

  TAxisOnGetLabel=Procedure( Sender:TChartAxis; Series:TChartSeries;
                             ValueIndex:Integer; Var LabelText:String) of object;

  TAxisOnGetNextLabel=Procedure( Sender:TChartAxis; LabelIndex:Integer;
                                 Var LabelValue:Double; Var Stop:Boolean) of object;

  TSeriesClick=procedure( Sender:TChartSeries;
                          ValueIndex:Integer;
                          Button:TMouseButton;
                          Shift: TShiftState;
                          X, Y: Integer) of object;

  TValueEvent=(veClear,veAdd,veDelete,veRefresh,veModify);

  THorizAxis = (aTopAxis,aBottomAxis,aBothHorizAxis,aCustomHorizAxis);
  TVertAxis  = (aLeftAxis,aRightAxis,aBothVertAxis,aCustomVertAxis);

  TChartClickedPartStyle=( cpNone,
                           cpLegend,
                           cpAxis,
                           cpSeries,
                           cpTitle,
                           cpFoot,
                           cpChartRect,
                           cpSeriesMarks,
                           cpSubTitle,
                           cpSubFoot );

  TChartClickedPart=Packed Record
    Part       : TChartClickedPartStyle;
    PointIndex : Integer;
    ASeries    : TChartSeries;
    AAxis      : TChartAxis;
  end;

  TChartSeriesList=class(TList)
  private
    FOwner : TCustomAxisPanel;
    procedure Put(Index:Integer; Value:TChartSeries);
    function Get(Index:Integer):TChartSeries;
  public
    property Items[Index:Integer]:TChartSeries read Get write Put; default;
    property Owner:TCustomAxisPanel read FOwner;
  end;

  TChartAxes=class(TList)
  private
    FChart    : TCustomAxisPanel;

    IFastCalc : Boolean;  // default False

    function Get(Index:Integer):TChartAxis;
    function GetBottomAxis:TChartAxis;
    function GetDepthAxis:TChartDepthAxis;
    function GetLeftAxis:TChartAxis;
    function GetRightAxis:TChartAxis;
    function GetTopAxis:TChartAxis;
    procedure SetFastCalc(const Value: Boolean);
    function GetBehind: Boolean;
    function GetVisible: Boolean;
    procedure SetBehind(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
  public
    procedure Clear; override;
    property Items[Index:Integer]:TChartAxis read Get; default;

    property Bottom:TChartAxis read GetBottomAxis;
    property Depth:TChartDepthAxis read GetDepthAxis;
    property Left:TChartAxis read GetLeftAxis;
    property Right:TChartAxis read GetRightAxis;
    property Top:TChartAxis read GetTopAxis;

    property Behind:Boolean read GetBehind write SetBehind;
    property FastCalc:Boolean read IFastCalc write SetFastCalc;
    property Visible:Boolean read GetVisible write SetVisible;
  end;

  TChartCustomAxes=class(TOwnedCollection)
  private
    Function Get(Index:Integer):TChartAxis;
    Procedure Put(Index:Integer; Const Value:TChartAxis);
  public
    property Items[Index:Integer]:TChartAxis read Get write Put; default;
  end;

  TTeeCustomDesigner=class(TObject)
  public
    Procedure Refresh; dynamic;
    Procedure Repaint; dynamic;
  end;

  TChartSeriesEvent=( seAdd, seRemove, seChangeTitle, seChangeColor, seSwap,
                      seChangeActive, seDataChanged);

  TChartChangePage=class(TTeeEvent);

  TChartToolEvent=(cteAfterDraw,cteBeforeDrawSeries,cteBeforeDraw); // 5.02
  TChartMouseEvent=(cmeDown,cmeMove,cmeUp);

  TTeeCustomTool=class(TCustomChartElement)
  protected
    Procedure ChartEvent(AEvent:TChartToolEvent); virtual;
    Procedure ChartMouseEvent( AEvent: TChartMouseEvent;
                               Button:TMouseButton;
                               Shift: TShiftState; X, Y: Integer); virtual;
    procedure SetParentChart(const Value: TCustomAxisPanel); override;
  public
    class Function Description:String; virtual;
  end;

  TTeeCustomToolClass=class of TTeeCustomTool;

  TChartTools=class(TList)
  private
    Owner : TCustomAxisPanel;
    Function Get(Index:Integer):TTeeCustomTool;
  public
    Function Add(Tool:TTeeCustomTool):TTeeCustomTool;
    procedure Clear; override;
    property Items[Index:Integer]:TTeeCustomTool read Get; default;
  end;

  // Base object for tools that have a Series property
  TTeeCustomToolSeries=class(TTeeCustomTool)
  private
    FSeries : TChartSeries;
  protected
    Function GetHorizAxis:TChartAxis;
    Function GetVertAxis:TChartAxis;
    class Function GetEditorClass:String; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetSeries(const Value: TChartSeries); virtual;
  public
    property Series:TChartSeries read FSeries write SetSeries;
  end;

  // Base object for tools that have an Axis property
  TTeeCustomToolAxis=class(TTeeCustomTool)
  private
    FAxis: TChartAxis;
    procedure ReadAxis(Reader: TReader);
    procedure WriteAxis(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    class Function GetEditorClass:String; override;
    procedure SetAxis(const Value: TChartAxis); virtual;
  public
    property Axis:TChartAxis read FAxis write SetAxis stored False;
  end;

  TTeeEventClass=class of TTeeEvent;

  TTeeSeriesEvent=class(TTeeEvent)
    Event  : TChartSeriesEvent;
    Series : TCustomChartSeries;
  end;

  TChartSeriesClass=class of TChartSeries;

  TCustomAxisPanel=class(TCustomTeePanelExtended)
  private
    { Private declarations }
    FAxes             : TChartAxes;
    FAxisBehind       : Boolean;
    FAxisVisible      : Boolean;
    FClipPoints       : Boolean;
    FCustomAxes       : TChartCustomAxes;
    FSeriesList       : TChartSeriesList;
    FDepthAxis        : TChartDepthAxis;
    FTopAxis          : TChartAxis;
    FBottomAxis       : TChartAxis;
    FLeftAxis         : TChartAxis;
    FRightAxis        : TChartAxis;
    FView3DWalls      : Boolean;

    FOnGetAxisLabel   : TAxisOnGetLabel;
    FOnGetNextAxisLabel:TAxisOnGetNextLabel;

    FOnPageChange     : TNotifyEvent;
    FOnBeforeDrawChart: TNotifyEvent;
    FOnBeforeDrawAxes : TNotifyEvent;
    FOnBeforeDrawSeries:TNotifyEvent;

    FPage             : Integer;
    FMaxPointsPerPage : Integer;
    FScaleLastPage    : Boolean;

    FMaxZOrder        : Integer;
    FSeriesWidth3D    : Integer;
    FSeriesHeight3D   : Integer;

    FTools            : TChartTools;

    InvertedRotation  : Boolean;
    Procedure BroadcastTeeEventClass(Event:TTeeEventClass);
    Procedure BroadcastToolEvent(AEvent:TChartToolEvent);
    Procedure CalcInvertedRotation;
    Procedure CheckOtherSeries(Dest,Source:TChartSeries);
    Function GetAxisSeriesMaxPoints(Axis:TChartAxis):TChartSeries;
    Function GetSeries(Index:Integer):TChartSeries;
    Procedure InternalAddSeries(ASeries:TCustomChartSeries);
    Function InternalMinMax(AAxis:TChartAxis; IsMin,IsX:Boolean):Double;
    Function NoActiveSeries(AAxis:TChartAxis):Boolean;
    Procedure SetAxisBehind(Value:Boolean);
    Procedure SetAxisVisible(Value:Boolean);
    Procedure SetBottomAxis(Value:TChartAxis);
    procedure SetClipPoints(Value:Boolean);
    Procedure SetCustomAxes(Value:TChartCustomAxes);
    Procedure SetDepthAxis(Value:TChartDepthAxis);
    Procedure SetLeftAxis(Value:TChartAxis);
    Procedure SetMaxPointsPerPage(Value:Integer);
    Procedure SetRightAxis(Value:TChartAxis);
    Procedure SetScaleLastPage(Value:Boolean);
    Procedure SetTopAxis(Value:TChartAxis);
    procedure SetView3DWalls(Value:Boolean);
    function IsCustomAxesStored: Boolean;
  protected
    { Protected declarations }
    LegendColor : TColor;
    LegendPen   : TChartPen;
    Procedure BroadcastSeriesEvent(ASeries:TCustomChartSeries; Event:TChartSeriesEvent);
    Procedure CalcWallsRect; virtual; abstract;
    Function CalcWallSize(Axis:TChartAxis):Integer; virtual; abstract;
    Function CheckMouseSeries(x,y:Integer):Boolean;
    procedure DoOnAfterDraw; virtual;
    procedure DoOnBeforeDrawAxes; virtual;
    procedure DoOnBeforeDrawChart; virtual;
    procedure DoOnBeforeDrawSeries; virtual;
    procedure DrawTitlesAndLegend(BeforeSeries:Boolean); virtual; abstract;
    Procedure DrawWalls; virtual; abstract;
    Function IsAxisVisible(Axis:TChartAxis):Boolean;
    Function MultiLineTextWidth(S:String; Var NumLines:Integer):Integer;
    procedure RemovedDataSource( ASeries: TChartSeries;
                                 AComponent: TComponent ); dynamic;
    Procedure SetPage(Value:Integer);
    Procedure GetChildren(Proc:TGetChildProc; Root:TComponent); override;
  public
    { Public declarations }
    Designer : TTeeCustomDesigner; { used only at Design-Time }
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    { public methods }
    procedure Assign(Source:TPersistent); override;
    Function ActiveSeriesLegend(ItemIndex:Integer):TChartSeries;
    Function AddSeries(ASeries:TChartSeries):TChartSeries; overload;  { 5.01 }
    Function AddSeries(ASeriesClass:TChartSeriesClass):TChartSeries; overload;
    Procedure CalcSize3DWalls;
    Procedure CheckDatasource(ASeries:TChartSeries); virtual;
    Function CountActiveSeries:Integer;
    Procedure ExchangeSeries(a,b:Integer); overload;
    Procedure ExchangeSeries(a,b:TCustomChartSeries); overload;
    Function FormattedValueLegend(ASeries:TChartSeries; ValueIndex:Integer):String; virtual;
    Procedure FreeAllSeries( SeriesClass:TChartSeriesClass=nil );
    Function GetAxisSeries(Axis:TChartAxis):TChartSeries;
    Function GetFreeSeriesColor(CheckBackground:Boolean=True):TColor;
    Function GetMaxValuesCount:Integer;
    Procedure InternalDraw(Const UserRectangle: TRect); override;
    Function IsFreeSeriesColor(AColor: TColor; CheckBackground: Boolean):Boolean; virtual; abstract;
    Function IsValidDataSource(ASeries: TChartSeries; AComponent: TComponent):Boolean; dynamic;
    Function MaxXValue(AAxis: TChartAxis):Double;
    Function MaxYValue(AAxis: TChartAxis):Double;
    Function MinXValue(AAxis: TChartAxis):Double;
    Function MinYValue(AAxis: TChartAxis):Double;
    Function MaxMarkWidth:Integer;
    Function MaxTextWidth:Integer;
    Function NumPages:Integer; dynamic;
    procedure PrintPages(FromPage: Integer=1; ToPage: Integer=0);
    Procedure RemoveSeries(ASeries: TCustomChartSeries);

    property Series[Index: Integer]:TChartSeries read GetSeries; default;
    Function SeriesCount:Integer;

    Function SeriesLegend(ItemIndex: Integer; OnlyActive: Boolean):TChartSeries;
    Function SeriesTitleLegend(SeriesIndex: Integer; OnlyActive: Boolean=False):String;

    { public properties }
    property Axes:TChartAxes read FAxes;
    property AxesList:TChartAxes read FAxes; // compatibility v4
    property CustomAxes:TChartCustomAxes read FCustomAxes write SetCustomAxes stored IsCustomAxesStored;
    property MaxZOrder:Integer read FMaxZOrder write FMaxZOrder;
    property SeriesWidth3D:Integer read FSeriesWidth3D;
    property SeriesHeight3D:Integer read FSeriesHeight3D;

    { to be published properties }
    property AxisBehind:Boolean read FAxisBehind write SetAxisBehind default True;
    property AxisVisible:Boolean read FAxisVisible write SetAxisVisible default True;
    property BottomAxis:TChartAxis read FBottomAxis write SetBottomAxis;
    property ClipPoints:Boolean read FClipPoints write SetClipPoints default True;
    property Color;
    property DepthAxis:TChartDepthAxis read FDepthAxis write SetDepthAxis;
    property LeftAxis:TChartAxis read FLeftAxis write SetLeftAxis;
    property MaxPointsPerPage:Integer read FMaxPointsPerPage write SetMaxPointsPerPage default 0;
    property Page:Integer read FPage write SetPage default 1;
    property RightAxis:TChartAxis read FRightAxis write SetRightAxis;
    property ScaleLastPage:Boolean read FScaleLastPage write SetScaleLastPage default True;
    property SeriesList:TChartSeriesList read FSeriesList;
    property Tools:TChartTools read FTools;
    property TopAxis:TChartAxis read FTopAxis write SetTopAxis;
    property View3DWalls:Boolean read FView3DWalls write SetView3DWalls default True;

    { to be published events }
    property OnBeforeDrawChart: TNotifyEvent read FOnBeforeDrawChart write FOnBeforeDrawChart;
    property OnBeforeDrawAxes:TNotifyEvent read FOnBeforeDrawAxes write FOnBeforeDrawAxes;
    property OnBeforeDrawSeries:TNotifyEvent read FOnBeforeDrawSeries write FOnBeforeDrawSeries;
    property OnGetAxisLabel:TAxisOnGetLabel read FOnGetAxisLabel write FOnGetAxisLabel;
    property OnGetNextAxisLabel:TAxisOnGetNextLabel read FOnGetNextAxisLabel
                                                    write FOnGetNextAxisLabel;
    property OnPageChange:TNotifyEvent read FOnPageChange write FOnPageChange;
  end;

  TSeriesMarkPosition=class
  public
    ArrowFrom : TPoint;
    ArrowFix  : Boolean;
    ArrowTo   : TPoint;
    Custom    : Boolean;
    Height    : Integer;
    LeftTop   : TPoint;
    Width     : Integer;
    Procedure Assign(Source:TSeriesMarkPosition);
    Function Bounds:TRect;
  end;

  TSeriesMarksPositions=class(TList)
  private
    Function Get(Index:Integer):TSeriesMarkPosition;
    Procedure Put(Index:Integer; APosition:TSeriesMarkPosition);
  public
    Procedure Automatic(Index:Integer);
    procedure Clear; override;
    Function ExistCustom:Boolean;
    property Position[Index:Integer]:TSeriesMarkPosition read Get
                                    write Put; default;
  end;

  TMarksItem=class(TTeeCustomShape)
  published
    property Bevel;
    property BevelWidth;
    property Color default ChartMarkColor;
    property Font;
    property Gradient;
    property Shadow;
    property ShapeStyle;
    property Transparency;
    property Transparent;
  end;

  TMarksItems=class(TList)
  private
    IMarks : TTeeCustomShape;
    ILoadingCustom : Boolean;
    function Get(Index:Integer):TMarksItem;
  public
    Procedure Clear; override;
    property Format[Index:Integer]:TMarksItem read Get; default;
  end;

  TSeriesMarksStyle=( smsValue,             { 1234 }
                      smsPercent,           { 12 % }
                      smsLabel,             { Cars }
                      smsLabelPercent,      { Cars 12 % }
                      smsLabelValue,        { Cars 1234 }
                      smsLegend,            { (Legend.Style) }
                      smsPercentTotal,      { 12 % of 1234 }
                      smsLabelPercentTotal, { Cars 12 % of 1234 }
                      smsXValue,            { 1..2..3.. or 21/6/1996 }
                      smsXY                 { 123 456 }
                      );

  TSeriesMarksGradient=class(TChartGradient)
  public
    Constructor Create(ChangedEvent:TNotifyEvent); override;
  published
    property Direction default gdRightLeft;
    property EndColor default clWhite;
    property StartColor default clSilver;
  end;

  TSeriesPointerStyle=( psRectangle,psCircle,psTriangle,psDownTriangle,
                        psCross,psDiagCross,psStar,psDiamond,psSmallDot,
                        psNothing,psLeftTriangle,psRightTriangle );

  TSeriesPointer=class(TTeeCustomShapeBrushPen)
  private
    FDark3D    : Boolean;
    FDraw3D    : Boolean;
    FGradient  : TTeeGradient;
    FHorizSize : Integer;
    FInflate   : Boolean;
    FSeries    : TChartSeries;
    FStyle     : TSeriesPointerStyle;
    FVertSize  : Integer;

    Procedure CheckPointerSize(Value:Integer);
    function GetColor: TColor;
    function GetStartZ:Integer;   // 6.01
    function GetMiddleZ:Integer;  // 6.01
    function GetEndZ:Integer;     // 6.01
    procedure SetColor(const Value: TColor);
    Procedure SetDark3D(Value:Boolean);
    Procedure SetDraw3D(Value:Boolean);
    procedure SetGradient(const Value: TTeeGradient);
    Procedure SetHorizSize(Value:Integer);
    Procedure SetInflate(Value:Boolean);
    Procedure SetStyle(Value:TSeriesPointerStyle);
    Procedure SetVertSize(Value:Integer);
  protected
    AllowChangeSize : Boolean;
    FullGradient    : Boolean;
    Procedure CalcHorizMargins(Var LeftMargin,RightMargin:Integer);
    Procedure CalcVerticalMargins(Var TopMargin,BottomMargin:Integer);
    Procedure Change3D(Value:Boolean);
    Procedure ChangeHorizSize(NewSize:Integer);
    Procedure ChangeStyle(NewStyle:TSeriesPointerStyle);
    Procedure ChangeVertSize(NewSize:Integer);
    Procedure PrepareCanvas; overload;
    Procedure PrepareCanvas(ACanvas:TCanvas3D; ColorValue:TColor); overload;
  public
    Constructor Create(AOwner:TChartSeries);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;

    Procedure Draw(P:TPoint); overload;
    Procedure Draw(X,Y:Integer); overload;
    Procedure Draw(px,py:Integer; ColorValue:TColor; AStyle:TSeriesPointerStyle); overload;
    Procedure DrawPointer( ACanvas:TCanvas3D;
                           Is3D:Boolean; px,py,tmpHoriz,tmpVert:Integer;
                           ColorValue:TColor; AStyle:TSeriesPointerStyle);

    property Color:TColor read GetColor write SetColor;
    property ParentSeries:TChartSeries read FSeries;
  published
    property Brush;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    Property Draw3D:Boolean read FDraw3D write SetDraw3D default True;
    property Gradient:TTeeGradient read FGradient write SetGradient; // 6.0
    Property HorizSize:Integer read FHorizSize write SetHorizSize default 4;
    property InflateMargins:Boolean read FInflate write SetInflate;
    property Pen;
    Property Style:TSeriesPointerStyle read FStyle write SetStyle;
    Property VertSize:Integer read FVertSize write SetVertSize default 4;
    Property Visible;
  end;

  TArrowHeadStyle=(ahNone,ahLine,ahSolid);

  TChartArrowPen=TWhitePen;

  TCallout=class(TSeriesPointer)
  private
    FArrow     : TChartArrowPen;
    FArrowHead : TArrowHeadStyle;
    FDistance  : Integer;
    FArrowHeadSize: Integer;

    procedure SetDistance(const Value: Integer);
    procedure SetArrow(const Value: TChartArrowPen);
    procedure SetArrowHead(const Value: TArrowHeadStyle);
    procedure SetArrowHeadSize(const Value: Integer);
  protected
    procedure Draw(AColor:TColor; AFrom,ATo:TPoint; Z:Integer); overload;
  public
    Constructor Create(AOwner:TChartSeries);
    Procedure Assign(Source:TPersistent); override;
    destructor Destroy; override;
  published
    property Arrow:TChartArrowPen read FArrow write SetArrow;
    property ArrowHead:TArrowHeadStyle read FArrowHead write SetArrowHead default ahNone;
    property ArrowHeadSize:Integer read FArrowHeadSize write SetArrowHeadSize default 8;
    property Distance:Integer read FDistance write SetDistance default 0;
    property Draw3D default False;
    property InflateMargins default True;
    property Style default psRectangle;
    property Visible default True;
  end;

  TMarksCallout=class(TCallout)
  private
    FLength : Integer;
    procedure SetLength(const Value:Integer);
  public
    constructor Create(AOwner: TChartSeries);
    Procedure Assign(Source:TPersistent); override;
  published
    property Length:Integer read FLength write SetLength;
    property Visible default False;
  end;

  TSeriesMarks=class(TTeeCustomShape)
  private
    FAngle       : Integer;
    FCallout     : TMarksCallout;
    FClip        : Boolean;
    FDrawEvery   : Integer;
    FItems       : TMarksItems;
    FMarkerStyle : TSeriesMarksStyle;
    FMultiLine   : Boolean;
    FParent      : TChartSeries;
    FPositions   : TSeriesMarksPositions;
    FZPosition   : Integer;

    function GetArrowLength: Integer;
    function GetArrowPen: TChartArrowPen;
    Function GetBackColor:TColor;
    function GetItem(Index:Integer):TMarksItem;
    Procedure InitShadow(AShadow:TTeeShadow);
    Procedure InternalDraw(Index:Integer; AColor:TColor; Const St:String; APosition:TSeriesMarkPosition);
    procedure ReadItems(Stream: TStream);
    Procedure SetAngle(Value:Integer);
    procedure SetCallout(const Value: TMarksCallout);
    Procedure SetArrowPen(const Value:TChartArrowPen);
    Procedure SetArrowLength(Value:Integer);
    Procedure SetBackColor(Value:TColor);
    Procedure SetClip(Value:Boolean);
    Procedure SetDrawEvery(Value:Integer);
    Procedure SetMultiline(Value:Boolean);
    Procedure SetStyle(Value:TSeriesMarksStyle);
    procedure WriteItems(Stream: TStream);
  protected
    Procedure AntiOverlap(First, ValueIndex:Integer; APosition:TSeriesMarkPosition);
    Procedure ConvertTo2D(APosition:TSeriesMarkPosition; var P:TPoint);
    procedure DefineProperties(Filer: TFiler); override;
    Function GetGradientClass:TChartGradientClass; override;
    Function MarkItem(ValueIndex:Integer):TTeeCustomShape;
    Function TextWidth(ValueIndex:Integer):Integer;
    Procedure UsePosition(Index:Integer; Var MarkPosition:TSeriesMarkPosition);
  public
    Constructor Create(AOwner:TChartSeries);
    Destructor Destroy; override;

    Procedure ApplyArrowLength(APosition:TSeriesMarkPosition);
    Procedure Assign(Source:TPersistent); override;
    procedure Clear;
    Function Clicked(X,Y:Integer):Integer;
    Procedure DrawText(Const R:TRect; Const St:String);

    property Item[Index:Integer]:TMarksItem read GetItem; default;
    property Items:TMarksItems read FItems;
    property ParentSeries:TChartSeries read FParent;
    property Positions:TSeriesMarksPositions read FPositions;
    procedure ResetPositions;
    property ZPosition : Integer read FZPosition write FZPosition;
  published
    property Angle:Integer read FAngle write SetAngle default 0;
    property Arrow:TChartArrowPen read GetArrowPen write SetArrowPen; // obsolete
    property ArrowLength:Integer read GetArrowLength write SetArrowLength; // obsolete
    property Callout:TMarksCallout read FCallout write SetCallout;  // 6.0
    property BackColor:TColor read GetBackColor write SetBackColor default ChartMarkColor;
    property Bevel;  { 5.01 }
    property BevelWidth;  { 5.01 }
    property Brush;
    property Clip:Boolean read FClip write SetClip default False;
    property Color default ChartMarkColor;
    property DrawEvery:Integer read FDrawEvery write SetDrawEvery default 1;
    property Font;
    property Frame;
    property Gradient;
    property MultiLine:Boolean read FMultiLine write SetMultiLine default False;
    property Shadow;
    property ShapeStyle;
    property Style:TSeriesMarksStyle read FMarkerStyle
                                     write SetStyle default smsLabel;
    property Transparency; { 5.01 }
    property Transparent;
    property Visible;
  end;

  TSeriesOnBeforeAdd=Function(Sender:TChartSeries):Boolean of object;
  TSeriesOnAfterAdd=Procedure(Sender:TChartSeries; ValueIndex:Integer) of object;
  TSeriesOnClear=Procedure(Sender:TChartSeries) of object;
  TSeriesOnGetMarkText=Procedure(Sender:TChartSeries; ValueIndex:Integer; Var MarkText:String) of object;

  TSeriesRecalcOptions=set of (rOnDelete, rOnModify, rOnInsert, rOnClear);

  TFunctionPeriodStyle=( psNumPoints, psRange );
  TFunctionPeriodAlign=( paFirst,paCenter,paLast );

  TTeeFunction=class(TComponent)
  private
    FPeriod      : Double;
    FPeriodStyle : TFunctionPeriodStyle;
    FPeriodAlign : TFunctionPeriodAlign;
    FParent      : TChartSeries;

    IUpdating    : Boolean;
    Procedure SetPeriod(Const Value:Double);
    Procedure SetParentSeries(AParent:TChartSeries);
    Procedure SetPeriodAlign(Value:TFunctionPeriodalign);
    Procedure SetPeriodStyle(Value:TFunctionPeriodStyle);
  protected
    CanUsePeriod     : Boolean;  // function uses Period property ?
    NoSourceRequired : Boolean;  // function requires source Series ?
    SingleSource     : Boolean;  // function allows more than one source ?
    HideSourceList   : Boolean;  // For single-source, allow select value-list ?

    Procedure AddFunctionXY(YMandatorySource:Boolean; const tmpX,tmpY:Double);
    Procedure CalculatePeriod( Source:TChartSeries;
                               Const tmpX:Double;
                               FirstIndex,LastIndex:Integer); virtual;
    Procedure CalculateAllPoints(Source:TChartSeries; NotMandatorySource:TChartValueList); virtual;
    Procedure CalculateByPeriod(Source:TChartSeries; NotMandatorySource:TChartValueList); virtual;
    Procedure DoCalculation( Source:TChartSeries;
                             NotMandatorySource:TChartValueList); virtual;
    class Function GetEditorClass:String; virtual;
    Procedure InternalSetPeriod(Const APeriod:Double);
    Function IsValidSource(Value:TChartSeries):Boolean; dynamic;
    class Procedure PrepareForGallery(Chart:TCustomAxisPanel); virtual;
    procedure SetParentComponent(Value: TComponent); override;
    Function ValueList(ASeries:TChartSeries):TChartValueList;
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure Assign(Source:TPersistent); override;

    procedure AddPoints(Source:TChartSeries); dynamic;
    procedure BeginUpdate;
    Function Calculate(SourceSeries:TChartSeries; First,Last:Integer):Double; virtual;
    Function CalculateMany(SourceSeriesList:TList; ValueIndex:Integer):Double; virtual;
    procedure EndUpdate;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    property ParentSeries:TChartSeries read FParent write SetParentSeries;
    Procedure ReCalculate;
  published
    property Period:Double read FPeriod write SetPeriod;
    property PeriodAlign:TFunctionPeriodAlign read FPeriodAlign
                                              write SetPeriodAlign default paCenter;
    property PeriodStyle:TFunctionPeriodStyle read FPeriodStyle
                                              write SetPeriodStyle default psNumPoints;
  end;

  TTeeMovingFunction=class(TTeeFunction)
  protected
    Procedure DoCalculation( Source:TChartSeries;
                             NotMandatorySource:TChartValueList); override;
  public
    Constructor Create(AOwner:TComponent); override;
  published
    property Period;
  end;

  TChartValueLists=class(TList)
  private
    Function Get(Index:Integer):TChartValueList;
  public
    Procedure Clear; override;
    property ValueList[Index:Integer]:TChartValueList read Get; default;
  end;

  TChartSeriesStyle=set of ( tssIsTemplate,
                             tssDenyChangeType,
                             tssDenyDelete,
                             tssDenyClone,
                             tssIsPersistent,
                             tssHideDataSource );

  TCustomChartSeries=class(TCustomChartElement)
  private
    FShowInLegend : Boolean;
    FTitle        : String;
    FIdentifier   : String;  { DecisionCube }
    FStyle        : TChartSeriesStyle; { DecisionCube }
    procedure ReadIdentifier(Reader: TReader);
    procedure WriteIdentifier(Writer: TWriter);
    procedure ReadStyle(Reader: TReader);
    procedure WriteStyle(Writer: TWriter);

    Procedure RepaintDesigner;
    Procedure SetShowInLegend(Value:Boolean);
    Procedure SetTitle(Const Value:String);
  protected
    InternalUse : Boolean;
    Procedure Added; dynamic;
    Procedure CalcHorizMargins(Var LeftMargin,RightMargin:Integer); virtual;
    Procedure CalcVerticalMargins(Var TopMargin,BottomMargin:Integer); virtual;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoBeforeDrawChart; virtual;
    Procedure GalleryChanged3D(Is3D:Boolean); dynamic;
    Procedure Removed; dynamic;
    Procedure SetActive(Value:Boolean); override;
  public
    Constructor Create(AOwner: TComponent); override;

    procedure Assign(Source:TPersistent); override;
    Function SameClass(tmpSeries:TChartSeries):Boolean;

    property ShowInLegend:Boolean read FShowInLegend write SetShowInLegend default True;
    property Title:String read FTitle write SetTitle;
    { DSS, hidden }
    property Identifier:String read FIdentifier write FIdentifier;
    property Style:TChartSeriesStyle read FStyle write FStyle default [];
  end;

  TSeriesRandomBounds=packed record
    tmpX,StepX,tmpY,MinY,DifY:Double;
  end;

  TTeeFunctionClass=class of TTeeFunction;

  TTeeSeriesType=class(TObject)
    SeriesClass      : TChartSeriesClass;
    FunctionClass    : TTeeFunctionClass;
    Description      : PString;
    GalleryPage      : PString;
    NumGallerySeries : Integer;
  end;

  TChartSubGalleryProc=Function(Const AName:String):TCustomAxisPanel of object;

  TLegendTextStyle=( ltsPlain,ltsLeftValue,ltsRightValue,
                     ltsLeftPercent,ltsRightPercent,ltsXValue,ltsValue,
                     ltsPercent,ltsXAndValue,ltsXAndPercent);

  TeeFormatFlags = (tfNoMandatory,tfColor,tfLabel,tfMarkPosition);
  TeeFormatFlag  = set of TeeFormatFlags;

  TLabelsList=class(TList)
  private
    Series : TChartSeries;
    Procedure DeleteLabel(ValueIndex:Integer);
    Function GetLabel(ValueIndex:Integer):String;
    Procedure SetLabel(ValueIndex:Integer; Const ALabel:String);
    Procedure InsertLabel(ValueIndex:Integer; Const ALabel:String);
  public
    procedure Assign(Source:TLabelsList);
    procedure Clear; override;
    Function IndexOfLabel(const ALabel:String; CaseSensitive:Boolean=True):Integer;
    property Labels[Index:Integer]:String read GetLabel write SetLabel; default;
  end;

  TChartSeries=class(TCustomChartSeries)
  private
    FColor              : TColor;
    FColorEachPoint     : Boolean;
    FColors             : TList;
    FColorSource        : String;
    FCursor             : TCursor;
    FDataSources        : TList;
    FDepth              : Integer;
    FFirstVisibleIndex  : Integer;
    FGetHorizAxis       : TChartAxis;
    FGetVertAxis        : TChartAxis;
    FLabelsSource       : String;
    FLastVisibleIndex   : Integer;
    FLinkedSeries       : TChartSeriesList;
    FMarks              : TSeriesMarks;
    FPercentFormat      : String;
    FTempDataSources    : TStringList;
    FValueFormat        : String;
    FValuesList         : TChartValueLists;
    FX                  : TChartValueList;
    FLabels             : TLabelsList;
    FY                  : TChartValueList;

    FHorizAxis          : THorizAxis;
    FCustomHorizAxis    : TChartAxis;
    FCustomVertAxis     : TChartAxis;
    FZOrder             : Integer;

    FVertAxis           : TVertAxis;
    FRecalcOptions      : TSeriesRecalcOptions;

    FTeeFunction        : TTeeFunction;

    { Private }
    IsMouseInside       : Boolean;
    ILabelOrder         : TChartListOrder;

    { Events }
    FAfterDrawValues    : TNotifyEvent;
    FBeforeDrawValues   : TNotifyEvent;
    FOnAfterAdd         : TSeriesOnAfterAdd;
    FOnBeforeAdd        : TSeriesOnBeforeAdd;
    FOnClearValues      : TSeriesOnClear;
    FOnClick            : TSeriesClick;
    FOnDblClick         : TSeriesClick;
    FOnGetMarkText      : TSeriesOnGetMarkText;
    FOnMouseEnter       : TNotifyEvent;
    FOnMouseLeave       : TNotifyEvent;

    Function CanAddRandomPoints:Boolean;
    Function CompareLabelIndex(a,b:Integer):Integer;
    Function GetDataSource:TComponent;
    Function GetZOrder:Integer;
    Procedure GrowColors;
    Procedure InternalAddDataSource(Value:TComponent);
    Function IsPercentFormatStored:Boolean;
    Function IsValueFormatStored:Boolean;
    procedure ReadCustomHorizAxis(Reader: TReader);
    procedure ReadCustomVertAxis(Reader: TReader);
    procedure ReadDataSources(Reader: TReader);
    Procedure RecalcGetAxis;
    Procedure RemoveAllLinkedSeries;
    Procedure SetColorSource(Const Value:String);
    Procedure SetCustomHorizAxis(Value:TChartAxis);
    Procedure SetCustomVertAxis(Value:TChartAxis);
    Procedure SetDataSource(Value:TComponent);
    procedure SetDepth(const Value: Integer);
    Procedure SetHorizAxis(const Value:THorizAxis);
    Procedure SetLabelsSource(Const Value:String);
    procedure SetMarks(Value:TSeriesMarks);
    Procedure SetPercentFormat(Const Value:String);
    Procedure SetValueColor(ValueIndex:Integer; AColor:TColor);
    Procedure SetValueFormat(Const Value:String);
    Procedure SetVertAxis(const Value:TVertAxis);
    Procedure SetXValue(Index:Integer; Const Value:Double);
    Procedure SetYValue(Index:Integer; Const Value:Double);
    Procedure SetZOrder(Value:Integer);
    procedure WriteCustomHorizAxis(Writer: TWriter);
    procedure WriteCustomVertAxis(Writer: TWriter);
    procedure WriteDataSources(Writer: TWriter);
    function GetXLabel(Index: Integer): String;
    procedure SetXLabel(Index: Integer; const Value: String);
  protected
    DontSaveData     : Boolean;
    ForceSaveData    : Boolean;
    ManualData       : Boolean;
    INumSampleValues : Integer;
    IUpdating        : Integer;
    IUseSeriesColor  : Boolean;
    IUseNotMandatory : Boolean;
    IZOrder          : Integer;
    ILegend          : TTeeCustomShape;
    IFirstDrawIndex  : Integer;

    Function AddChartValue(Source:TChartSeries; ValueIndex:Integer):Integer; virtual;
    Procedure Added; override;
    Procedure AddedValue(Source:TChartSeries; ValueIndex:Integer); virtual;
    Procedure AddLinkedSeries(ASeries:TChartSeries);
    Procedure AddSampleValues(NumValues:Integer); dynamic;
    Procedure AddValues(Source:TChartSeries); virtual;
    Procedure CalcFirstLastVisibleIndex;
    Procedure CalcZOrder; virtual;
    Function CheckMouse(x,y:Integer):Boolean;
    Procedure ClearLists; virtual;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); virtual;
    procedure DefineProperties(Filer: TFiler); override;
    Procedure DeletedValue(Source:TChartSeries; ValueIndex:Integer); virtual;
    procedure DoAfterDrawValues; virtual;
    procedure DoBeforeDrawValues; virtual;
    procedure DrawAllValues; virtual;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); virtual;
    Procedure DrawMark(ValueIndex:Integer; Const St:String; APosition:TSeriesMarkPosition); virtual;
    procedure DrawMarks;
    procedure DrawValue(ValueIndex:Integer); virtual;
    Function FirstInZOrder:Boolean;
    Procedure GetChildren(Proc:TGetChildProc; Root:TComponent); override;
    Function GetMarkText(ValueIndex:Integer):String;
    Function GetValueColor(ValueIndex:Integer):TColor; virtual;
    Function GetxValue(ValueIndex:Integer):Double; virtual;  { conflicts with c++ wingdi.h }
    Function GetyValue(ValueIndex:Integer):Double; virtual;  { conflicts with c++ wingdi.h }
    Function InternalColor(ValueIndex:Integer):TColor;
    Procedure Loaded; override;
    procedure Notification( AComponent: TComponent;
                            Operation: TOperation); override;
    Procedure NotifyNewValue(Sender:TChartSeries; ValueIndex:Integer); virtual;
    Procedure NotifyValue(ValueEvent:TValueEvent; ValueIndex:Integer); virtual;
    Function MoreSameZOrder:Boolean; virtual;
    Procedure PrepareForGallery(IsEnabled:Boolean); dynamic;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                   Var BrushStyle:TBrushStyle); virtual;
    procedure ReadData(Stream: TStream);
    Procedure Removed; override;
    Procedure RemoveLinkedSeries(ASeries:TChartSeries);
    Procedure SetChartValueList( AValueList:TChartValueList;
                                 Value:TChartValueList);
    Procedure SetColorEachPoint(Value:Boolean); virtual;
    Procedure SetHorizontal;
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;
    Procedure SetSeriesColor(AColor:TColor); virtual;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); virtual;
    Procedure SetXValues(Value:TChartValueList);
    Procedure SetYValues(Value:TChartValueList);
    procedure WriteData(Stream: TStream); dynamic;
  public
    CalcVisiblePoints     : Boolean;
    DrawBetweenPoints     : Boolean;
    AllowSinglePoint      : Boolean;
    HasZValues            : Boolean;
    StartZ                : Integer;
    MiddleZ               : Integer;
    EndZ                  : Integer;
    MandatoryValueList    : TChartValueList;
    NotMandatoryValueList : TChartValueList;
    YMandatory            : Boolean;

    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Function Add(Const AValue:Double; Const ALabel:String='';
                       AColor:TColor=clTeeColor):Integer; virtual;
    Function AddArray(Const Values:Array of TChartValue):Integer; overload;
    Function AddNull(Const Value:Double):Integer; overload;
    Function AddNull(Const ALabel:String=''):Integer; overload; virtual;
    Function AddNullXY(Const X,Y:Double; Const ALabel:String=''):Integer; virtual;
    Function AddX(Const AXValue:Double; Const ALabel:String='';
                         AColor:TColor=clTeeColor):Integer;
    Function AddXY(Const AXValue,AYValue:Double; Const ALabel:String='';
                         AColor:TColor=clTeeColor):Integer; virtual;
    Function AddY(Const AYValue:Double; Const ALabel:String='';
                         AColor:TColor=clTeeColor):Integer;

    procedure Assign(Source:TPersistent); override;
    procedure AssignFormat(Source:TChartSeries);

    Function AssociatedToAxis(Axis:TChartAxis):Boolean; virtual;
    Procedure BeginUpdate;
    Procedure CheckOrder; dynamic;
    Procedure Clear; virtual;
    Function Count:Integer;
    Function CountLegendItems:Integer; virtual;
    Procedure Delete(ValueIndex:Integer); overload; virtual;
    Procedure Delete(Start,Quantity:Integer); overload; virtual;
    Procedure EndUpdate;
    Procedure FillSampleValues(NumValues:Integer=0); dynamic;
    Function IsNull(ValueIndex:Integer):Boolean;
    Function IsValidSourceOf(Value:TChartSeries):Boolean; dynamic;
    Function IsValidSeriesSource(Value:TChartSeries):Boolean; dynamic;
    Function LegendToValueIndex(LegendIndex:Integer):Integer; virtual;
    Function LegendItemColor(LegendIndex:Integer):TColor; virtual;
    Function LegendString(LegendIndex:Integer; LegendTextStyle:TLegendTextStyle):String; virtual;
    property LinkedSeries:TChartSeriesList read FLinkedSeries;
    Function MaxXValue:Double; virtual;
    Function MaxYValue:Double; virtual;
    Function MaxZValue:Double; virtual;
    Function MinXValue:Double; virtual;
    Function MinYValue:Double; virtual;
    Function MinZValue:Double; virtual;
    Function NumSampleValues:Integer; dynamic;
    Function RandomBounds(NumValues:Integer):TSeriesRandomBounds;
    Procedure RemoveDataSource(Value:TComponent);
    Procedure SetNull(ValueIndex:Integer; Null:Boolean=True); // 6.0
    Procedure SortByLabels(Order:TChartListOrder=loAscending); // 6.0
    Function VisibleCount:Integer; { <-- Number of VISIBLE points (Last-First+1) }

    property ValuesList:TChartValueLists read FValuesList;
    property XValue[Index:Integer]:Double read GetxValue write SetXValue;
    property YValue[Index:Integer]:Double read GetyValue write SetYValue;

    property ZOrder:Integer read GetZOrder write SetZOrder default TeeAutoZOrder;
    Function MaxMarkWidth:Integer;

    Function CalcXPos(ValueIndex:Integer):Integer; virtual;
    Function CalcXPosValue(Const Value:Double):Integer;
    Function CalcXSizeValue(Const Value:Double):Integer;

    Function CalcYPos(ValueIndex:Integer):Integer; virtual;
    Function CalcYPosValue(Const Value:Double):Integer;
    Function CalcYSizeValue(Const Value:Double):Integer;

    Function CalcPosValue(Const Value:Double):Integer;

    Function XScreenToValue(ScreenPos:Integer):Double;
    Function YScreenToValue(ScreenPos:Integer):Double;

    Function XValueToText(Const AValue:Double):String;
    Function YValueToText(Const AValue:Double):String;

    Procedure ColorRange( AValueList:TChartValueList;
                          Const FromValue,ToValue:Double;
                          AColor:TColor);
    Procedure CheckDataSource;

    { Public Properties }
    property Labels:TLabelsList read FLabels;
    property XLabel[Index:Integer]:String read GetXLabel write SetXLabel;  // deprecated (obsolete)
    property ValueMarkText[Index:Integer]:String read GetMarkText;

    property ValueColor[Index:Integer]:TColor read GetValueColor write SetValueColor;
    property XValues:TChartValueList read FX write SetXValues;
    property YValues:TChartValueList read FY write SetYValues;

    Function GetYValueList(AListName:String):TChartValueList; virtual;
    property GetVertAxis:TChartAxis read FGetVertAxis;
    property GetHorizAxis:TChartAxis read FGetHorizAxis;
    Function MarkPercent(ValueIndex:Integer; AddTotal:Boolean=False):String;
    Function Clicked(x,y:Integer):Integer; overload; virtual;
    Function Clicked(P:TPoint):Integer; overload;
    Procedure RefreshSeries;
    property FirstValueIndex:Integer read FFirstVisibleIndex;
    property LastValueIndex:Integer read FLastVisibleIndex;
    Function GetOriginValue(ValueIndex:Integer):Double; virtual;
    Function GetMarkValue(ValueIndex:Integer):Double; virtual;
    Procedure AssignValues(Source:TChartSeries);
    Function DrawValuesForward:Boolean; virtual;
    Function DrawSeriesForward(ValueIndex:Integer):Boolean; virtual;
    procedure SwapValueIndex(a,b:Integer); dynamic;
    property RecalcOptions: TSeriesRecalcOptions read FRecalcOptions
                                                 write FRecalcOptions
                                       default [ rOnDelete,
                                                 rOnModify,
                                                 rOnInsert,
                                                 rOnClear];
    Function GetCursorValueIndex:Integer;
    Procedure GetCursorValues(Var XValue,YValue:Double);
    Procedure DrawLegend(ValueIndex:Integer; Const Rect:TRect); virtual;
    Function UseAxis:Boolean; virtual;
    procedure SetFunction(AFunction:TTeeFunction); virtual;

    property SeriesColor:TColor read FColor write SetSeriesColor default clTeeColor;  // deprecated

    { other }
    property DataSources:TList read FDataSources;
    property FunctionType:TTeeFunction read FTeeFunction write SetFunction;
    Procedure CheckOtherSeries(Source:TChartSeries);
    Procedure ReplaceList(OldList,NewList:TChartValueList);
    property CustomHorizAxis:TChartAxis read FCustomHorizAxis write SetCustomHorizAxis;
    property CustomVertAxis:TChartAxis read FCustomVertAxis write SetCustomVertAxis;

    { to be published }
    property Active;
    property Color:TColor read FColor write SetSeriesColor default clTeeColor;  // replaces SeriesColor
    property ColorEachPoint:Boolean read FColorEachPoint write SetColorEachPoint default False;
    property ColorSource:String read FColorSource write SetColorSource;
    property Cursor:TCursor read FCursor write FCursor default crDefault;
    property Depth:Integer read FDepth write SetDepth default TeeAutoDepth;
    property HorizAxis:THorizAxis read FHorizAxis write SetHorizAxis default aBottomAxis;
    property Marks:TSeriesMarks read FMarks write SetMarks;
    property ParentChart;
    { datasource below parentchart }
    property DataSource:TComponent read GetDataSource write SetDataSource;
    property PercentFormat:String read FPercentFormat write SetPercentFormat stored IsPercentFormatStored;
    property ShowInLegend;
    property Title;
    property ValueFormat:String read FValueFormat write SetValueFormat stored IsValueFormatStored;
    property VertAxis:TVertAxis read FVertAxis write SetVertAxis default aLeftAxis;
    property XLabelsSource:String read FLabelsSource write SetLabelsSource;

    { events }
    property AfterDrawValues:TNotifyEvent read FAfterDrawValues
                                           write FAfterDrawValues;
    property BeforeDrawValues:TNotifyEvent read FBeforeDrawValues
                                           write FBeforeDrawValues;
    property OnAfterAdd:TSeriesOnAfterAdd read FOnAfterAdd write FOnAfterAdd;
    property OnBeforeAdd:TSeriesOnBeforeAdd read FOnBeforeAdd write FOnBeforeAdd;
    property OnClearValues:TSeriesOnClear read FOnClearValues
                                          write FOnClearValues;
    property OnClick:TSeriesClick read FOnClick write FOnClick;
    property OnDblClick:TSeriesClick read FOnDblClick write FOnDblClick;
    property OnGetMarkText:TSeriesOnGetMarkText read FOnGetMarkText
                                                write FOnGetMarkText;
    property OnMouseEnter:TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave:TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

  ChartException=class(Exception);

  TTeeSeriesSource=class(TComponent)
  private
    FActive : Boolean;
    FSeries : TChartSeries;
    procedure SetSeries(const Value: TChartSeries);
  protected
    procedure Notification( AComponent: TComponent;
                            Operation: TOperation); override;
    procedure SetActive(const Value: Boolean); virtual;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    class Function Available(AChart:TCustomAxisPanel):Boolean; virtual;
    class Function Description:String; virtual; { bcos BCB, do not make abstract }
    class Function Editor:TComponentClass; virtual; { bcos BCB, do not make abstract }
    class Function HasNew:Boolean; virtual;
    class Function HasSeries(ASeries:TChartSeries):Boolean; virtual;

    Procedure Close; virtual;
    Procedure Load; virtual; abstract;
    Procedure Loaded; override;
    Procedure Open; virtual;
    Procedure Refresh;

    property Active:Boolean read FActive write SetActive default False;
    property Series:TChartSeries read FSeries write SetSeries;
  end;

  TTeeSeriesSourceClass=class of TTeeSeriesSource;

Var TeeAxisClickGap    : Integer=3;    { minimum pixels distance to trigger axis click }
    TeeDefaultCapacity : Integer=1000; { default TList.Capacity to speed-up Lists }

Function TeeSources: TList; { List of registered Series Source components }

Function SeriesTitleOrName(ASeries:TCustomChartSeries):String;
Procedure FillSeriesItems(AItems:TStrings; AChart:TCustomAxisPanel);

Procedure ShowMessageUser(Const S:String);

{ Returns if a Series has "X" values }
Function HasNoMandatoryValues(ASeries:TChartSeries):Boolean;

{ Returns True if ASeries has text labels }
Function HasLabels(ASeries:TChartSeries):Boolean;

{ Returns True if ASeries has colors }
Function HasColors(ASeries:TChartSeries):Boolean;

{ Returns set indicating Series contents (colors, labels, etc) }
Function SeriesGuessContents(ASeries:TChartSeries):TeeFormatFlag;

implementation

Uses {$IFDEF CLX}
     QPrinters,
     {$ELSE}
     Printers,
     {$ENDIF}
     {$IFDEF D6}
      {$IFNDEF CLX}
      Types,
      {$ENDIF}
     {$ENDIF}
     {$IFDEF TEEARRAY}
      {$IFOPT R+}
       {$IFDEF D6}
       RtlConsts,
       {$ELSE}
       Consts,
       {$ENDIF}
      {$ENDIF}
     {$ENDIF}
     {$IFNDEF D5}
     TypInfo,
     {$ENDIF}
     Math, TeeConst;

{ Returns a "good" value, bigger than "OldStep", as 2..5..10..etc }
Function TeeNextStep(Const OldStep:Double):Double;
Begin
  if OldStep >= 10 then result := 10*TeeNextStep(0.1*OldStep)
  else
  if OldStep < 1 then result := 0.1*TeeNextStep(OldStep*10)
  else
  if OldStep < 2 then result:=2 else
  if OldStep < 5 then result:=5 else result:=10
end;

{ Determine what a Series point is made of }
Function SeriesGuessContents(ASeries:TChartSeries):TeeFormatFlag;
begin
  if HasNoMandatoryValues(ASeries) then result:=[tfNoMandatory]
                                   else result:=[];
  if HasColors(ASeries) then result:=result+[tfColor];
  if HasLabels(ASeries) then result:=result+[tfLabel];
  if ASeries.Marks.Positions.ExistCustom then result:=result+[tfMarkPosition];
end;

{ TChartAxisTitle }
Procedure TChartAxisTitle.Assign(Source:TPersistent);
Begin
  if Source is TChartAxisTitle then
  With TChartAxisTitle(Source) do
  Begin
    Self.FAngle  :=FAngle;
    Self.FCaption:=FCaption;
  end;
  inherited;
end;

Function TChartAxisTitle.IsAngleStored:Boolean;
begin
  result:=FAngle<>IDefaultAngle;
end;

type TTeePanelAccess=class(TCustomTeePanel);

Procedure TChartAxisTitle.SetAngle(const Value:Integer);
Begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FAngle,Value mod 360); { 5.01 }
end;

Procedure TChartAxisTitle.SetCaption(Const Value:String);
Begin
  TTeePanelAccess(ParentChart).SetStringProperty(FCaption,Value);
end;

type TOwnedCollectionAccess=class(TOwnedCollection);

{ TChartAxis }
Constructor TChartAxis.Create(Collection:TCollection);
Begin
  FParentChart:=TCustomAxisPanel(TOwnedCollectionAccess(Collection).GetOwner);
  With ParentChart do
  if Axes.Count>=5 then inherited Create(Collection)
                   else inherited Create(nil);

  SetCalcPosValue;

  ISeriesList:=TChartSeriesList.Create;

  FItems:=TAxisItems.Create(Self);

  FLogarithmicBase:=10;
  FAutomatic:=True;
  FAutomaticMaximum:=True;
  FAutomaticMinimum:=True;
  FLabelsSeparation:=10; { % }
  FAxisValuesFormat:=TeeMsg_DefValueFormat;
  FLabelsAlign:=alDefault;
  FLabelStyle:=talAuto;
  FLabelsOnAxis:=True;

  FTickOnLabelsOnly:=True;

  FAxisTitle:=TChartAxisTitle.Create(ParentChart);
  FAxisTitle.IDefaultAngle:=0;

  FTicks:=TDarkGrayPen.Create(ParentChart.CanvasChanged);
  FTickLength:=4;

  FMinorTicks:=TDarkGrayPen.Create(ParentChart.CanvasChanged);
  FMinorTickLength :=2;
  FMinorTickCount  :=3;

  FTicksInner:=TDarkGrayPen.Create(ParentChart.CanvasChanged);
  FGrid:=TAxisGridPen.Create(ParentChart.CanvasChanged);
  FMinorGrid:=TChartHiddenPen.Create(ParentChart.CanvasChanged);

  FAxis:=TChartAxisPen.Create(ParentChart.CanvasChanged);

  FVisible         :=True;
  FRoundFirstLabel  :=True;
  FExactDateTime   :=True;
  FEndPosition     :=100;
  FParentChart.FAxes.Add(Self);
end;

Destructor TChartAxis.Destroy;

  Procedure ResetSeriesAxes;
  var t : Integer;
  begin
    With FParentChart do
    for t:=0 to SeriesCount-1 do
    With TChartSeries(Series[t]) do
    begin
      if CustomHorizAxis=Self then
      begin
        CustomHorizAxis:=nil;
        HorizAxis:=aBottomAxis;
      end;
      if CustomVertAxis=Self then
      begin
        CustomVertAxis:=nil;
        VertAxis:=aLeftAxis;
      end;
    end;
  end;

begin
  FMinorTicks.Free;
  FTicks.Free;
  FTicksInner.Free;
  FGrid.Free;
  FMinorGrid.Free;
  FAxis.Free;
  FAxisTitle.Free;
  FItems.Free;
  ResetSeriesAxes;
  ISeriesList.Free;
  FParentChart.FAxes.Remove(Self);
  Tick:=nil;
  inherited;
end;

Procedure TChartAxis.IncDecDateTime( Increment:Boolean;
                                           Var Value:Double;
                                           Const AnIncrement:Double;
                                           tmpWhichDateTime:TDateTimeStep);
begin
  TeeDateTimeIncrement( FExactDateTime and IAxisDateTime and
                        (tmpWhichDateTime>=dtHalfMonth),
                        Increment,
                        Value,
                        AnIncrement,
                        tmpWhichDateTime );
end;

{ An axis is "DateTime" if at least one Active Series with
  datetime values is associated to it }
Function TChartAxis.IsDateTime:Boolean;
Var tmpSeries : Integer;
Begin
  With ParentChart do
  for tmpSeries:=0 to SeriesCount-1 do
  With Series[tmpSeries] do
  if Active then
      if AssociatedToAxis(Self) then
      begin
        if Self.Horizontal then result:=FX.DateTime
                           else result:=FY.DateTime;
        Exit;
      end;
  result:=False;
end;

Procedure TChartAxis.SetTicks(Value:TDarkGrayPen);
Begin
  FTicks.Assign(Value);
end;

Procedure TChartAxis.SetMinorTicks(Value:TDarkGrayPen);
Begin
  FMinorTicks.Assign(Value);
end;

Procedure TChartAxis.SetTicksInner(Value:TDarkGrayPen);
Begin
  FTicksInner.Assign(Value);
end;

Procedure TChartAxis.SetGrid(Value:TAxisGridPen);
Begin
  FGrid.Assign(Value);
end;

Procedure TChartAxis.SetMinorGrid(Value:TChartHiddenPen);
Begin
  FMinorGrid.Assign(Value);
end;

Procedure TChartAxis.SetGridCentered(Value:Boolean);
Begin
  Grid.Centered:=Value;
end;

Procedure TChartAxis.SetAxis(Value:TChartAxisPen);
Begin
  FAxis.Assign(Value);
end;

Function TChartAxis.IsPosStored:Boolean;
begin
  result:=FPositionPercent<>0;
end;

Function TChartAxis.IsStartStored:Boolean;
begin
  result:=FStartPosition<>0;
end;

Function TChartAxis.IsEndStored:Boolean;
begin
  result:=FEndPosition<>100;
end;

Function TChartAxis.IsCustom:Boolean;
begin
  result:=ParentChart.Axes.IndexOf(Self)>4;
end;

procedure TChartAxis.SetHorizontal(const Value: Boolean);
begin
  ParentChart.SetBooleanProperty(FHorizontal,Value);
  SetCalcPosValue;
end;

procedure TChartAxis.SetOtherSide(const Value: Boolean);
begin
  ParentChart.SetBooleanProperty(FOtherSide,Value);
end;

Function TChartAxis.CalcPosPoint(Value:Integer):Double;

  Function InternalCalcPos(Const A,B:Double):Double;
  begin
    if (Horizontal and FInverted) or
       ((not Horizontal) and (not FInverted)) then result:=A
                                              else result:=B
  end;

var tmp : Double;
Begin
  if FLogarithmic then
  Begin
    if Value=IStartPos then result:=InternalCalcPos(IMaximum,IMinimum)
    else
    if Value=IEndPos then result:=InternalCalcPos(IMinimum,IMaximum)
    else
    begin
      tmp:=IRangeLog;
      if (tmp=0) or (IAxisSize=0) then result:=IMinimum // 5.03
      else
      begin
        if FInverted then tmp:=((IEndPos-Value)*tmp/IAxisSize)
                     else tmp:=((Value-IStartPos)*tmp/IAxisSize);
        if Horizontal then result:=Exp(ILogMin+tmp)
                      else result:=Exp(ILogMax-tmp);
      end;
    end;
  end
  else
  if IAxisSize>0 then
  begin
    if FInverted then tmp:=IEndPos-Value
                 else tmp:=Value-IStartPos;
    tmp:=tmp*IRange/IAxisSize;
    if Horizontal then result:=IMinimum+tmp
                  else result:=IMaximum-tmp;
  end
  else result:=0;
end;

Procedure TChartAxis.SetDateTimeFormat(Const Value:String);
Begin
  ParentChart.SetStringProperty(FDateTimeFormat,Value);
end;

procedure TChartAxis.SetAxisTitle(Value:TChartAxisTitle);
begin
  FAxisTitle.Assign(Value);
end;

procedure TChartAxis.SetStartPosition(Const Value:Double);
begin
  ParentChart.SetDoubleProperty(FStartPosition,Value);
end;

procedure TChartAxis.SetEndPosition(Const Value:Double);
begin
  ParentChart.SetDoubleProperty(FEndPosition,Value);
end;

procedure TChartAxis.SetPositionPercent(Const Value:Double);
begin
  ParentChart.SetDoubleProperty(FPositionPercent,Value);
end;

procedure TChartAxis.SetRoundFirstLabel(Value:Boolean);
begin
  ParentChart.SetBooleanProperty(FRoundFirstLabel,Value);
end;

Procedure TChartAxis.SetLabelsMultiLine(Value:Boolean);
begin
  ParentChart.SetBooleanProperty(FLabelsMultiLine,Value);
end;

Procedure TChartAxis.SetLabelsExponent(Value:Boolean);
begin
  ParentChart.SetBooleanProperty(FLabelsExponent,Value);
end;

procedure TChartAxis.SetZPosition(const Value: Double);
begin
  ParentChart.SetDoubleProperty(FZPosition,Value);
end;

procedure TChartAxis.SetTickOnLabelsOnly(Value:Boolean);
begin
  ParentChart.SetBooleanProperty(FTickOnLabelsOnly,Value);
end;

function TChartAxis.CalcDateTimeIncrement(MaxNumLabels:Integer):Double;
var TempNumLabels : Integer;
begin
  result:=Math.Max(FDesiredIncrement,DateTimeStep[Low(DateTimeStep)]);

  if (result>0) and (MaxNumLabels>0) then
  begin
    if (IRange/Result)>1000000 then Result:=IRange/1000000;

    Repeat
      TempNumLabels:=Round(IRange/result);
      if TempNumLabels>MaxNumLabels then
         if result<DateTimeStep[dtOneYear] then
         begin
            if result<DateTimeStep[dtOneSecond] then
               result:=TeeNextStep(result)  // less than one second
            else
               result:=NextDateTimeStep(result) // regular datetime steps
         end
         else
            result:=2.0*result;  // years

    Until (TempNumLabels<=MaxNumLabels){ or (result=DateTimeStep[dtOneYear])};

  end;
  result:=Math.Max(result,DateTimeStep[Low(DateTimeStep)]);
end;

{$IFNDEF D6}
function IsInfinite(const AValue: Double): Boolean;
begin
  Result := ((PInt64(@AValue)^ and $7FF0000000000000) = $7FF0000000000000) and
            ((PInt64(@AValue)^ and $000FFFFFFFFFFFFF) = $0000000000000000);
end;
{$ENDIF}

Function TChartAxis.CalcLabelsIncrement(MaxNumLabels:Integer):Double;

  procedure InternalCalcLabelsIncrement;

    Function AnySeriesHasLessThan(Num:Integer):Boolean;
    var t : Integer;
    begin
      result:=False;
      for t:=0 to ParentChart.SeriesCount-1 do
      with ParentChart[t] do
      if Active then
         if (YMandatory and Self.Horizontal) or
            ((not YMandatory) and (not Self.Horizontal)) then

           if AssociatedToAxis(Self) then
           begin
             result:=Count<=Num;
             if result then break;
           end;
    end;

  var TempNumLabels : Integer;
      tmp           : Double;
  begin
    TempNumLabels:=MaxNumLabels+1;

    if FDesiredIncrement<=0 then
    begin
      if IRange=0 then result:=1
      else
      begin
        result:=Abs(IRange)/Succ(MaxNumLabels);
        if AnySeriesHasLessThan(MaxNumLabels) then
           result:=Math.Max(1,result);
      end;
    end
    else result:=FDesiredIncrement;

    if LabelsSeparation>=0 then
    Repeat
      tmp:=IRange/result;

      if Abs(tmp)<MaxLongint then
      begin
        TempNumLabels:=Round(tmp);
        if TempNumLabels>MaxNumLabels then
           result:=TeeNextStep(result);
      end
      else result:=TeeNextStep(result);

    Until (TempNumLabels<=MaxNumLabels) or (result>IRange) or IsInfinite(result);

    if IsInfinite(result) then result:=IRange
                          else result:=Math.Max(result,MinAxisIncrement);
  end;

Begin
  if MaxNumLabels>0 then
  Begin
    if IAxisDateTime then result:=CalcDateTimeIncrement(MaxNumLabels)
                     else InternalCalcLabelsIncrement;
  end
  else
  if IAxisDateTime then result:=DateTimeStep[Low(DateTimeStep)]
                   else result:=MinAxisIncrement;
end;

Function TChartAxis.LabelWidth(Const Value:Double):Integer;
begin
  result:=InternalLabelSize(Value,True);
end;

Function TChartAxis.LabelHeight(Const Value:Double):Integer;
begin
  result:=InternalLabelSize(Value,False);
end;

Function TChartAxis.InternalLabelSize(Const Value:Double; IsWidth:Boolean):Integer;
var tmp      : Integer;
    tmpMulti : Boolean;
Begin
  result:=ParentChart.MultiLineTextWidth(LabelValue(Value),tmp);

  if IsWidth then
     tmpMulti:=(FLabelsAngle=90) or (FLabelsAngle=270)
  else
     tmpMulti:=(FLabelsAngle=0) or (FLabelsAngle=180);

  if tmpMulti then result:=ParentChart.Canvas.FontHeight*tmp;
end;

Function TChartAxis.IsMaxStored:Boolean;
Begin { dont store max property if automatic }
  result:=(not FAutomatic) and (not FAutomaticMaximum);
end;

Function TChartAxis.IsMinStored:Boolean;
Begin{ dont store min property if automatic }
  result:=(not FAutomatic) and (not FAutomaticMinimum);
end;

Function TChartAxis.CalcXYIncrement(MaxLabelSize:Integer):Double;
var tmp : Integer;
begin
  if MaxLabelSize>0 then
  begin
    if FLabelsSeparation>0 then
       Inc(MaxLabelSize,Round(0.01*FLabelsSeparation*MaxLabelSize));

    tmp:=Round((1.0*IAxisSize)/MaxLabelSize)
  end
  else tmp:=1;

  result:=CalcLabelsIncrement(tmp)
end;

Function TChartAxis.CalcIncrement:Double;
begin
  result:=CalcXYIncrement(Math.Max(InternalLabelSize(IMinimum,Horizontal),
                                   InternalLabelSize(IMaximum,Horizontal)));
end;

Procedure TChartAxis.AdjustMaxMinRect(Const Rect:TRect);
Var tmpMin : Double;
    tmpMax : Double;

  Procedure RecalcAdjustedMinMax(Pos1,Pos2:Integer);
  Var OldStart : Integer;
      OldEnd   : Integer;
  Begin
    OldStart :=IStartPos;
    OldEnd   :=IEndPos;
    Inc(IStartPos,Pos1);
    Dec(IEndPos,Pos2);
    IAxisSize:=IEndPos-IStartPos;
    tmpMin:=CalcPosPoint(OldStart);
    tmpMax:=CalcPosPoint(OldEnd);
  end;

Begin
  With ParentChart do
  begin
    with Rect do
    if Horizontal then ReCalcAdjustedMinMax(Left,Right)
                  else ReCalcAdjustedMinMax(Top,Bottom);
    InternalCalcPositions;
    IMaximum:=tmpMax;
    IMinimum:=tmpMin;
  end;
  if IMinimum>IMaximum then SwapDouble(IMinimum,IMaximum);
  InternalCalcRange;
end;

Procedure TChartAxis.CalcMinMax(Var AMin,AMax:Double);
Begin
  if FAutomatic or FAutomaticMaximum then
     AMax:=ParentChart.InternalMinMax(Self,False,Horizontal);
  if FAutomatic or FAutomaticMinimum then
     AMin:=ParentChart.InternalMinMax(Self,True,Horizontal);
end;

Procedure TChartAxis.InternalCalcRange;
begin
  IRange:=IMaximum-IMinimum;
  IRangeZero:=IRange=0;
  if IRangeZero then IAxisSizeRange:=0
                else IAxisSizeRange:=IAxisSize/IRange;

  if FLogarithmic then
  begin
    if IMinimum<=0 then ILogMin:=0 else ILogMin:=ln(IMinimum);
    if IMaximum<=0 then ILogMax:=0 else ILogMax:=ln(IMaximum);
    IRangeLog:=ILogMax-ILogMin;
    if IRangeLog=0 then IAxisLogSizeRange:=0
                   else IAxisLogSizeRange:=IAxisSize/IRangeLog;
  end;

  IZPos:=CalcZPos;
end;

Procedure TChartAxis.AdjustMaxMin;
Begin
  CalcMinMax(FMinimumValue,FMaximumValue);
  IMaximum:=FMaximumValue;
  IMinimum:=FMinimumValue;
  InternalCalcRange;
end;

procedure TChartAxis.Assign(Source: TPersistent);
Begin
  if Source is TChartAxis then
  With TChartAxis(Source) do
  Begin
    Self.FAxis.Assign(FAxis);
    Self.FItems.CopyFrom(FItems);
    Self.FLabelsAlign         :=FLabelsAlign;
    Self.FLabelsAngle         :=FLabelsAngle;
    Self.FLabelsExponent      :=FLabelsExponent;
    Self.FLabelsMultiLine     :=FLabelsMultiLine;
    Self.FLabelsSeparation    :=FLabelsSeparation;
    Self.FLabelsSize          :=FLabelsSize;
    Self.FLabelStyle          :=FLabelStyle;
    Self.FLabelsOnAxis        :=FLabelsOnAxis;
    Self.Ticks                :=FTicks;
    Self.TicksInner           :=FTicksInner;
    Self.FTitleSize           :=FTitleSize;
    Self.Grid                 :=FGrid;
    Self.MinorTicks           :=FMinorTicks;
    Self.MinorGrid            :=FMinorGrid;
    Self.FTickLength          :=FTickLength;
    Self.FMinorTickLength     :=FMinorTickLength;
    Self.FMinorTickCount      :=FMinorTickCount;
    Self.FTickInnerLength     :=FTickInnerLength;
    Self.FAxisValuesFormat    :=FAxisValuesFormat;
    Self.FDesiredIncrement    :=FDesiredIncrement;

    Self.FMaximumValue        :=FMaximumValue;
    Self.FMaximumOffset       :=FMaximumOffset;
    Self.FMinimumValue        :=FMinimumValue;
    Self.FMinimumOffset       :=FMinimumOffset;

    Self.FAutomatic           :=FAutomatic;
    Self.FAutomaticMaximum    :=FAutomaticMaximum;
    Self.FAutomaticMinimum    :=FAutomaticMinimum;
    Self.Title                :=FAxisTitle;
    Self.FDateTimeFormat      :=FDateTimeFormat;
    Self.GridCentered         :=GridCentered;
    Self.FLogarithmic         :=FLogarithmic;
    Self.FLogarithmicBase     :=FLogarithmicBase;
    Self.FInverted            :=FInverted;
    Self.FExactDateTime       :=FExactDateTime;
    Self.FRoundFirstLabel     :=FRoundFirstLabel;
    Self.FTickOnLabelsOnly    :=FTickOnLabelsOnly;
    Self.IDepthAxis           :=IDepthAxis;
    Self.FStartPosition       :=FStartPosition;
    Self.FEndPosition         :=FEndPosition;
    Self.FPositionPercent     :=FPositionPercent;
    Self.FPosUnits            :=FPosUnits;
    Self.FVisible             :=FVisible;

    Self.FHorizontal          :=FHorizontal;
    Self.FOtherSide           :=FOtherSide;
  end
  else inherited;
end;

Function TChartAxis.LabelValue(Const Value:Double):String;
var tmp : String;
Begin
  if IAxisDateTime then
  begin
    if Value>=0 then
    Begin
      if FDateTimeFormat='' then tmp:=DateTimeDefaultFormat(IRange)
                            else tmp:=FDateTimeFormat;
      DateTimeToString(result,tmp,Value);
    end
    else result:='';
  end
  else result:=FormatFloat(FAxisValuesFormat,Value);

  if Assigned(ParentChart.FOnGetAxisLabel) then
     ParentChart.FOnGetAxisLabel(TChartAxis(Self),nil,-1,Result);

  if FLabelsMultiLine then
     result:=ReplaceChar(result,' ',TeeLineSeparator);
end;

Function TChartAxis.InternalCalcLabelStyle:TAxisLabelStyle;
var t : Integer;
begin
  result:=talNone;
  for t:=0 to ParentChart.SeriesCount-1 do
  With ParentChart.Series[t] do
  if Active and AssociatedToAxis(Self) then
  begin
    result:=talValue;
    if (Horizontal and YMandatory) or
       ((not Horizontal) and (not YMandatory)) then
       if (FLabels.Count>0) and (FLabels.First<>nil) then
       begin
         result:=talText;
         break;
       end;
  end;
end;

Function TChartAxis.CalcLabelStyle:TAxisLabelStyle;
Begin
 if FLabelStyle=talAuto then result:=InternalCalcLabelStyle
                        else result:=FLabelStyle;
End;

Function TChartAxis.MaxLabelsWidth:Integer;

  Function MaxLabelsValueWidth:Integer;
  var tmp    : Double;
      tmpA   : Double;
      tmpB   : Double;
      OldGetAxisLabel : TAxisOnGetLabel;
      tmpNum : Integer;
  begin
    if (IsDateTime and FExactDateTime) or RoundFirstLabel then
    begin
      tmp:=CalcIncrement;
      tmpA:=tmp*Int(IMinimum/tmp);
      tmpB:=tmp*Int(IMaximum/tmp);
    end
    else
    begin
      tmpA:=IMinimum;
      tmpB:=IMaximum;
    end;

    With ParentChart do
    begin
      OldGetAxisLabel:=FOnGetAxisLabel;
      FOnGetAxisLabel:=nil;
      With Canvas do
           result:=TextWidth(' ')+
                   Math.Max(MultiLineTextWidth(LabelValue(tmpA),tmpNum),
                            MultiLineTextWidth(LabelValue(tmpB),tmpNum));
      FOnGetAxisLabel:=OldGetAxisLabel;
    end;
  end;

var t   : Integer;
    tmp : Integer;
begin
  if Items.Count=0 then
    Case CalcLabelStyle of
      talValue : result:=MaxLabelsValueWidth;
      talMark  : result:=ParentChart.MaxMarkWidth;
      talText  : result:=ParentChart.MaxTextWidth;
    else
    {talNone : } result:=0;
    end
  else
  begin
    result:=0;
    for t:=0 to Items.Count-1 do
    begin
      ParentChart.Canvas.AssignFont(Items[t].Font);
      result:=Max(result,ParentChart.MultiLineTextWidth(Items[t].Text,tmp));
    end;
  end;
end;

Function TChartAxis.GetLabels:Boolean;
begin
  result:=FItems.Format.Visible;
end;

Function TChartAxis.GetLabelsFont:TTeeFont;
begin
  result:=FItems.Format.Font;
end;

Procedure TChartAxis.SetLabels(Value:Boolean);
Begin
  FItems.Format.Visible:=Value;
end;

Procedure TChartAxis.SetLabelsFont(Value:TTeeFont);
begin
  FItems.Format.Font:=Value;
end;

Procedure TChartAxis.SetAutomatic(Value:Boolean);
Begin
  ParentChart.SetBooleanProperty(FAutomatic,Value);
  if not (csLoading in ParentChart.ComponentState) then
  begin
    FAutomaticMinimum:=Value;
    FAutomaticMaximum:=Value;
  end;
end;

Procedure TChartAxis.SetAutoMinMax(Var Variable:Boolean; Var2,Value:Boolean);
Begin
  ParentChart.SetBooleanProperty(Variable,Value);
  if Value then
  begin { if both are automatic, then Automatic should be True too }
    if Var2 then FAutomatic:=True;
  end
  else FAutomatic:=False;
end;

Procedure TChartAxis.SetAutomaticMinimum(Value:Boolean);
Begin
  SetAutoMinMax(FAutomaticMinimum,FAutomaticMaximum,Value);
end;

Procedure TChartAxis.SetAutomaticMaximum(Value:Boolean);
Begin
  SetAutoMinMax(FAutomaticMaximum,FAutomaticMinimum,Value);
end;

Function TChartAxis.IsAxisValuesFormatStored:Boolean;
begin
  result:=FAxisValuesFormat<>TeeMsg_DefValueFormat;
end;

Procedure TChartAxis.SetValuesFormat(Const Value:String);
Begin
  ParentChart.SetStringProperty(FAxisValuesFormat,Value);
end;

Procedure TChartAxis.SetInverted(Value:Boolean);
Begin
  ParentChart.SetBooleanProperty(FInverted,Value);
end;

Procedure TChartAxis.InternalSetInverted(Value:Boolean);
Begin
  FInverted:=Value;
end;

Procedure TChartAxis.SetLogarithmicBase(const Value:Double);
begin
//  if FLogarithmicBase<2 then raise AxisException.Create(TeeMsg_AxisLogBase);
  ParentChart.SetDoubleProperty(FLogarithmicBase,Value);
end;

Procedure TChartAxis.SetLogarithmic(Value:Boolean);
Begin
  if Value and IsDateTime then
     Raise AxisException.Create(TeeMsg_AxisLogDateTime);
  if Value then
  begin
    AdjustMaxMin;
    if ((IMinimum<0) or (IMaximum<0)) then
       Raise AxisException.Create(TeeMsg_AxisLogNotPositive);
  end;
  ParentChart.SetBooleanProperty(FLogarithmic,Value);
  SetCalcPosValue;
end;

Procedure TChartAxis.SetCalcPosValue;
begin
  if IDepthAxis then
  begin
    CalcXPosValue:=InternalCalcDepthPosValue;
    CalcYPosValue:=InternalCalcDepthPosValue;
  end
  else
  if Logarithmic then
  begin
    CalcXPosValue:=LogXPosValue;
    CalcYPosValue:=LogYPosValue;
  end
  else
  begin
    if ParentChart.Axes.IFastCalc then
    begin
      CalcXPosValue:=XPosValue;
      CalcYPosValue:=YPosValue;
    end
    else
    begin
      CalcXPosValue:=XPosValueCheck;
      CalcYPosValue:=YPosValueCheck;
    end;
  end;

  if Horizontal then CalcPosValue:=CalcXPosValue
                else CalcPosValue:=CalcYPosValue;
end;

Procedure TChartAxis.SetLabelsAlign(Value:TAxisLabelAlign);
Begin
  if FLabelsAlign<>Value then
  begin
    FLabelsAlign:=Value;
    ParentChart.Invalidate;
  end;
end;

Procedure TChartAxis.SetLabelsAngle(const Value:Integer);
Begin
  ParentChart.SetIntegerProperty(FLabelsAngle,Value mod 360);
end;

Procedure TChartAxis.SetLabelsSeparation(Value:Integer);
Begin
  if Value<0 then Raise AxisException.Create(TeeMsg_AxisLabelSep);
  ParentChart.SetIntegerProperty(FLabelsSeparation,Value);
end;

Procedure TChartAxis.SetLabelsSize(Value:Integer);
Begin
  ParentChart.SetIntegerProperty(FLabelsSize,Value);
end;

Procedure TChartAxis.SetTitleSize(Value:Integer);
Begin
  ParentChart.SetIntegerProperty(FTitleSize,Value);
end;

Procedure TChartAxis.SetLabelsOnAxis(Value:Boolean);
Begin
  ParentChart.SetBooleanProperty(FLabelsOnAxis,Value);
end;

Procedure TChartAxis.SetExactDateTime(Value:Boolean);
begin
  ParentChart.SetBooleanProperty(FExactDateTime,Value);
end;

Procedure TChartAxis.SetLabelStyle(Value:TAxisLabelStyle);
begin
  if FLabelStyle<>Value then
  begin
    FLabelStyle:=Value;
    ParentChart.Invalidate;
  end;
end;

Procedure TChartAxis.SetVisible(Value:Boolean);
Begin
  ParentChart.SetBooleanProperty(FVisible,Value);
end;

Procedure TChartAxis.SetDesiredIncrement(Const Value:Double);
Begin
  if Value<0 then Raise AxisException.Create(TeeMsg_AxisIncrementNeg);
  if IsDateTime then DateTimeToStr(Value);
  ParentChart.SetDoubleProperty(FDesiredIncrement,Value);
end;

Procedure TChartAxis.SetMinimum(Const Value:Double);
Begin
  if (not (csReading in ParentChart.ComponentState)) and
     (Value>FMaximumValue) then
       Raise AxisException.Create(TeeMsg_AxisMinMax);
  InternalSetMinimum(Value);
end;

Procedure TChartAxis.InternalSetMinimum(Const Value:Double);
Begin
  ParentChart.SetDoubleProperty(FMinimumValue,Value);
end;

Procedure TChartAxis.SetMaximum(Const Value:Double);
Begin
  if (not (csReading in ParentChart.ComponentState)) and
     (Value<FMinimumValue) then
       Raise AxisException.Create(TeeMsg_AxisMaxMin);
  InternalSetMaximum(Value);
end;

Procedure TChartAxis.SetMinMax(AMin,AMax:Double);
Begin
  FAutomatic:=False;
  FAutomaticMinimum:=False;
  FAutomaticMaximum:=False;
  if AMin>AMax then SwapDouble(AMin,AMax);
  InternalSetMinimum(AMin);
  InternalSetMaximum(AMax);
  if (FMaximumValue-FMinimumValue)<MinAxisRange then
     InternalSetMaximum(FMinimumValue+MinAxisRange);
end;

Procedure TChartAxis.InternalSetMaximum(Const Value:Double);
Begin
  ParentChart.SetDoubleProperty(FMaximumValue,Value);
end;

Procedure TChartAxis.SetTickLength(Value:Integer);
Begin
  ParentChart.SetIntegerProperty(FTickLength,Value);
end;

Procedure TChartAxis.SetMinorTickLength(Value:Integer);
Begin
  ParentChart.SetIntegerProperty(FMinorTickLength,Value);
end;

Procedure TChartAxis.SetMinorTickCount(Value:Integer);
Begin
  ParentChart.SetIntegerProperty(FMinorTickCount,Value);
End;

Procedure TChartAxis.SetTickInnerLength(Value:Integer);
Begin
  ParentChart.SetIntegerProperty(FTickInnerLength,Value);
end;

Procedure TChartAxis.DrawTitle(x,y:Integer);
var Old : Boolean;
begin
  With ParentChart,Canvas do
  begin
    AssignFont(FAxisTitle.Font);
    BackMode:=cbmTransparent;
    if IsDepthAxis then
    begin
      TextAlign:=TA_LEFT;
      TextOut3D(x,y,Width3D div 2,FAxisTitle.FCaption);
    end
    else
    begin
      Old:=FLabelsExponent;
      FLabelsExponent:=False;  // 5.02
      DrawAxisLabel(x,y,FAxisTitle.FAngle,FAxisTitle.FCaption);
      FLabelsExponent:=Old;
    end;
  end;
end;

// pending: cache into variable (for speed)
Function TChartAxis.CalcZPos:Integer;
begin
  if IDepthAxis then result:=ParentChart.ChartHeight
                else result:=ParentChart.Width3D;

  result:=Round(result*ZPosition*0.01); // 6.0
end;

procedure TChartAxis.DrawAxisLabel(x,y,Angle:Integer; Const St:String; Format:TTeeCustomShape=nil);
Const Aligns:Array[Boolean,Boolean] of Integer=(
              (TA_RIGHT +TA_TOP, TA_LEFT  +TA_TOP    ),    { vertical }
              (TA_CENTER+TA_TOP, TA_CENTER+TA_BOTTOM ) );  { horizontal }

Var tmpSt2 : String;
    tmpZ   : Integer;

  Procedure DrawExponentLabel;
  var tmpW : Integer;
      tmpH : Integer;
      i    : Integer;
      tmp  : String;
      tmpSub : String;
      Old  : Integer;
  begin
    i:=Pos('E',Uppercase(tmpSt2));
    With ParentChart.Canvas do
    if i=0 then TextOut3D(x,y,tmpZ,tmpSt2)
    else
    begin
      tmp:=Copy(tmpSt2,1,i-1);
      tmpSub:=Copy(tmpSt2,i+1,Length(tmpSt2)-1);
      tmpH:=FontHeight-1;
      Old:=Font.Size;
      if TextAlign=TA_LEFT then
      begin
        TextOut3D(x,y,tmpZ,tmp);
        tmpW:=TextWidth(tmp)+1;
        Font.Size:=Font.Size-(Font.Size div 4);
        TextOut3D(x+tmpW,y-(tmpH div 2)+2,tmpZ,tmpSub);
      end
      else
      begin
        Font.Size:=Font.Size-(Font.Size div 4);
        TextOut3D(x,y-(tmpH div 2)+2,tmpZ,tmpSub);
        tmpW:=TextWidth(tmpSub)+1;
        Font.Size:=Old;
        TextOut3D(x-tmpW,y,tmpZ,tmp);
      end;
      Font.Size:=Old;
    end;
  end;

  { Returns 1 + how many times "TeeLineSeparator #13" is found
    inside string St parameter }
  Function TeeNumTextLines(St:String):Integer;
  var i : Integer;
  begin
    result:=0;
    i:=AnsiPos(TeeLineSeparator,St);
    while i>0 do
    begin
      Inc(result);
      Delete(St,1,i);
      i:=AnsiPos(TeeLineSeparator,St);
    end;
    if St<>'' then Inc(result);
  end;

var Delta    : Integer;
    t        : Integer;
    n        : Integer;
    i        : Integer;
    tmp      : Double;
    tmpSt    : String;
    tmpH     : Integer;
    tmpD     : Integer;
    tmpAlign : TCanvasTextAlign;
    tmpAlign2: TCanvasTextAlign;
    tmpW     : Integer;
    tmpNum   : Integer;
    tmpSize  : Integer;
begin
  tmpH:=ParentChart.Canvas.FontHeight div 2;

  Case Angle of
 0,360: begin
          if Horizontal or (FLabelsAlign=alDefault) then
             tmpAlign:=Aligns[Horizontal,OtherSide]
          else
            if OtherSide then
            begin
              tmpAlign:=TA_RIGHT;
              Inc(X,SizeLabels);
            end
            else
            begin
              tmpAlign:=TA_LEFT;
              Dec(X,SizeLabels);
            end;
          if not Horizontal then Dec(Y,tmpH);
        end;
    90: begin
          if Horizontal then
          begin
            tmpAlign:=Aligns[False,OtherSide];
            Dec(X,tmpH);
          end
          else tmpAlign:=Aligns[True,not OtherSide];
        end;
   180: begin
          tmpAlign:=Aligns[Horizontal,not OtherSide];
          if not Horizontal then Inc(Y,tmpH);
        end;
   270: begin
          if Horizontal then
          begin
            tmpAlign:=Aligns[False,not OtherSide];
            Inc(X,tmpH);
          end
          else tmpAlign:=Aligns[True,OtherSide];
        end;
    45: begin // 5.03
          tmpAlign:=TA_LEFT;

          if Horizontal then
          begin
            if OtherSide then
            begin
              i:=Round(ParentChart.Canvas.TextWidth('Wj'));
              Dec(x,i);
              Dec(y,i);
            end
            else
            begin
              tmp:=Sin(Angle*TeePiStep);
              i:=Round(ParentChart.Canvas.TextWidth(St)*tmp);
              Dec(x,i);
              Inc(y,i);
            end;
          end;
        end;
   else
   begin
     tmpAlign:=TA_LEFT; { non-supported angles }
   end;
  end;

  tmpZ:=IZPos; // 6.0

  n:=TeeNumTextLines(St);
  Delta:=ParentChart.Canvas.FontHeight;
  if (Angle=180) or (Angle=270) then Delta:=-Delta;

  tmpD:=Round(Delta*n);
  if Horizontal then
  begin
    if Angle=0 then
       if OtherSide then y:=y-tmpD else y:=y-Delta
    else
    if Angle=180 then
       if OtherSide then y:=y-Delta else y:=y-tmpD
    else
    if (Angle=90) or (Angle=270) then
       x:=x-Round(0.5*Delta*(n+1));
  end
  else
    if (Angle=0) or (Angle=180) then
       y:=y-Round(0.5*Delta*(n+1))
    else
    if OtherSide then
    begin
       if Angle=90 then x:=x-Delta
                   else if Angle=270 then x:=x-tmpD
    end
    else
    if Angle=90 then x:=x-tmpD
                else if Angle=270 then x:=x-Delta;

    // 6.0
    if not Assigned(Format) then Format:=FItems.Format;

    with Format do
    if not Transparent then
    begin
      with ShapeBounds do
      begin
        tmpSize:=Self.ParentChart.Canvas.TextWidth('W') shr 1;

        Left:=x;
        Top:=y+Delta;

        tmpW:=Self.ParentChart.MultiLineTextWidth(St,tmpNum);
        tmpH:=ParentChart.Canvas.FontHeight*tmpNum;

        tmpAlign2:=tmpAlign;

        if tmpAlign2>=TA_BOTTOM then
        begin
          Dec(Top,tmpH);
          Dec(tmpAlign2,TA_BOTTOM);
        end;

        Bottom:=Top+tmpH;
        Right:=Left+tmpW;

        if tmpAlign2=TA_RIGHT then
        begin
          Right:=Left;
          Left:=Right-tmpW;
        end
        else
        if tmpAlign2=TA_CENTER then
        begin
          tmpW:=(Right-Left) div 2;
          Dec(Right,tmpW);
          Dec(Left,tmpW);
        end;

        Dec(Left,tmpSize);
        Inc(Right,tmpSize);
      end;

      if tmpZ<>0 then ShapeBounds:=ParentChart.Canvas.CalcRect3D(ShapeBounds,tmpZ);

      DrawRectRotated(ShapeBounds,FLabelsAngle,tmpZ);

      with ParentChart.Canvas do
      begin
        // trick
        Brush.Style:=bsSolid;
        Brush.Style:=bsClear;

        {$IFDEF CLX}
        BackMode:=cbmTransparent;
        {$ENDIF}
      end;
    end;

  ParentChart.Canvas.TextAlign:=tmpAlign;

  tmpSt:=St;
  for t:=1 to n do
  begin
    i:=AnsiPos(TeeLineSeparator,tmpSt);
    if i>0 then tmpSt2:=Copy(tmpSt,1,i-1) else tmpSt2:=tmpSt;
    if Angle=0 then
    begin
      y:=y+Delta;
      if FLabelsExponent then DrawExponentLabel
                         else ParentChart.Canvas.TextOut3D(X,Y,tmpZ,tmpSt2);
    end
    else
    begin
      if Angle=180 then y:=y+Delta
      else
      if (Angle=90) or (Angle=270) then x:=x+Delta;
      ParentChart.Canvas.RotateLabel3D(X,Y,tmpZ,tmpSt2,Angle);
    end;

    Delete(tmpSt,1,i);
  end;

  ParentChart.Canvas.TextAlign:=TA_LEFT;
end;

Procedure TChartAxis.Scroll(Const Offset:Double; CheckLimits:Boolean);
Begin
  if (not CheckLimits) or
     ( ((Offset>0) and (FMaximumValue<ParentChart.InternalMinMax(Self,False,Horizontal))) or
       ((Offset<0) and (FMinimumValue>ParentChart.InternalMinMax(Self,True,Horizontal)))
     ) then
  begin
    FAutomatic:=False;
    FAutomaticMaximum:=False;
    FMaximumValue:=FMaximumValue+Offset;
    FAutomaticMinimum:=False;
    FMinimumValue:=FMinimumValue+Offset;
    ParentChart.Invalidate;
  end;
end;

Function TChartAxis.InternalCalcDepthPosValue(Const Value:TChartValue):Integer;
begin
  if IRangeZero then result:=ICenterPos
  else
  if FInverted then result:=Round(IAxisSizeRange*(IMaximum-Value))
               else result:=Round(IAxisSizeRange*(Value-IMinimum));
end;

Function TChartAxis.LogXPosValue(Const Value:TChartValue):Integer;
begin
  if IRangeLog=0 then result:=ICenterPos
  else
  begin
    if Value<=0 then
       if FInverted then result:=IEndPos
                    else result:=IStartPos
    else
    begin
      if FInverted then result:=Round((ILogMax-ln(Value))*IAxisLogSizeRange)
                   else result:=Round((ln(Value)-ILogMin)*IAxisLogSizeRange);
      result:=IStartPos+result;
    end;
  end;
end;

Function TChartAxis.LogYPosValue(Const Value:TChartValue):Integer;
begin
  if IRangeLog=0 then result:=ICenterPos
  else
  begin
    if Value<=0 then
       if not FInverted then result:=IEndPos
                        else result:=IStartPos
    else
    begin
      if FInverted then result:=Round((ILogMax-ln(Value))*IAxisLogSizeRange)
                   else result:=Round((ln(Value)-ILogMin)*IAxisLogSizeRange);
      result:=IEndPos-result;
    end;
  end;
end;

// The following routines perform axis calculations WITH overflow checking
// to avoid Windows GDI limits on pixel coordinates.
// See below for faster routines.
//
// To switch between slow and fast, use Chart1.Axes.FastCalc property.

var TeeMaxPixelPos:Integer=0;

Function TChartAxis.XPosValueCheck(Const Value:TChartValue):Integer;
var tmp : Double;
begin
  if IRangeZero then result:=ICenterPos
  else
  begin
    tmp:=(Value-IMinimum)*IAxisSizeRange;
    if FInverted then tmp:=IEndPos-tmp
                 else tmp:=IStartPos+tmp;
    if tmp> TeeMaxPixelPos then result:=TeeMaxPixelPos
    else
    if tmp<-TeeMaxPixelPos then result:=-TeeMaxPixelPos
    else
       result:=Round(tmp);
  end;
end;

Function TChartAxis.YPosValueCheck(Const Value:TChartValue):Integer;
var tmp : Double;
begin
  if IRangeZero then result:=ICenterPos
  else
  begin
    tmp:=(Value-IMinimum)*IAxisSizeRange;
    if FInverted then tmp:=IStartPos+tmp
                 else tmp:=IEndPos-tmp;
    if tmp> TeeMaxPixelPos then result:= TeeMaxPixelPos
    else
    if tmp<-TeeMaxPixelPos then result:=-TeeMaxPixelPos
    else
       result:=Round(tmp);
  end;
end;

// The following routines perform axis calculations WITHOUT overflow checking.
// These are 5 to 10% faster than the above ones.
// See above for slower (with checking) routines.
//
// To switch between slow and fast, use Chart1.Axes.FastCalc property.

Function TChartAxis.XPosValue(Const Value:TChartValue):Integer;
begin
  if IRangeZero then result:=ICenterPos
  else
  begin
    {$IFNDEF TEENOASM}
    asm
      fld qword ptr [Value]
      fsub qword ptr [eax+IMinimum]
      fmul qword ptr [eax+IAxisSizeRange]
      sub esp, 8
      fistp qword ptr [esp]
      pop [result]
      pop ecx
    end;

    if Inverted then result:=IEndPos  -result
                else Inc(result,IStartPos);
    {$ELSE}
    if FInverted then
       result:=IEndPos  -Round( (Value-IMinimum)*IAxisSizeRange )
    else
       result:=IStartPos+Round( (Value-IMinimum)*IAxisSizeRange );
    {$ENDIF}
  end;
end;

Function TChartAxis.YPosValue(Const Value:TChartValue):Integer;
begin
  if IRangeZero then result:=ICenterPos
  else
  begin
    {$IFNDEF TEENOASM}
    asm
      fld qword ptr [Value]
      fsub qword ptr [eax+IMinimum]
      fmul qword ptr [eax+IAxisSizeRange]
      sub esp, 8
      fistp qword ptr [esp]
      pop [result]
      pop ecx
    end;

    if Inverted then Inc(result,IStartPos)
                else result:=IEndPos  -result;
    {$ELSE}
    if FInverted then
       result:=IStartPos+Round( (Value-IMinimum)*IAxisSizeRange )
    else
       result:=IEndPos  -Round( (Value-IMinimum)*IAxisSizeRange )
    {$ENDIF}
  end;
end;

Function TChartAxis.CalcSizeValue(Const Value:Double):Integer;
begin
  result:=0;
  if Value>0 then
    if FLogarithmic then
    Begin
      if IRangeLog<>0 then result:=Round(ln(Value)*IAxisLogSizeRange);
    end
    else
    if IRange<>0 then result:=Round(Value*IAxisSizeRange);
end;

Function TChartAxis.AxisRect:TRect;
Var tmpPos1 : Integer;
    Pos1    : Integer;
    tmpPos2 : Integer;
    Pos2    : Integer;
begin
  if IStartPos>IEndPos then
  begin
    tmpPos1:=IEndPos;
    tmpPos2:=IStartPos;
  end
  else
  begin
    tmpPos1:=IStartPos;
    tmpPos2:=IEndPos;
  end;

  if PosAxis>FPosLabels then
  begin
    Pos1:=FPosLabels;
    Pos2:=PosAxis+TeeAxisClickGap;
  end
  else
  begin
    Pos1:=PosAxis-TeeAxisClickGap;
    Pos2:=FPosLabels;
  end;

  if Horizontal then result:=TeeRect(tmpPos1,Pos1,tmpPos2,Pos2)
                else result:=TeeRect(Pos1,tmpPos1,Pos2,tmpPos2);
end;

Function TChartAxis.Clicked(x,y:Integer):Boolean;
var tmpR : TRect;
    tmpZ : Integer;
Begin
  result:=ParentChart.IsAxisVisible(Self);
  if result then
  begin
    if ParentChart.View3D then
    begin
      if OtherSide then tmpZ:=ParentChart.Width3D else tmpZ:=0;
      tmpR:=ParentChart.Canvas.CalcRect3D(AxisRect,tmpZ);
    end
    else tmpR:=AxisRect;

    result:=PointInRect(tmpR,x,y);

    // pending: DepthAxis and click hit detection with 3D rotation.
  end;
end;

Procedure TChartAxis.CustomDrawMinMaxStartEnd( APosLabels,
                                               APosTitle,
                                               APosAxis:Integer;
                                               GridVisible:Boolean;
                                               Const AMinimum,AMaximum,
                                                     AIncrement:Double;
                                               AStartPos,AEndPos:Integer);

  Procedure SetInternals;
  begin
    IMaximum :=FMaximumValue;
    IMinimum :=FMinimumValue;
    InternalCalcRange;
  end;

var OldMin       : Double;
    OldMax       : Double;
    OldIncrement : Double;
    OldAutomatic : Boolean;
begin
  OldMin      :=FMinimumValue;
  OldMax      :=FMaximumValue;
  OldIncrement:=FDesiredIncrement;
  OldAutomatic:=FAutomatic;
  try
    FAutomatic       :=False;
    FMinimumValue    :=AMinimum;
    FMaximumValue    :=AMaximum;
    FDesiredIncrement:=AIncrement;
    SetInternals;
    CustomDrawStartEnd(APosLabels,APosTitle,APosAxis,GridVisible,AStartPos,AEndPos);
  finally
    FMinimumValue    :=OldMin;
    FMaximumValue    :=OldMax;
    FDesiredIncrement:=OldIncrement;
    FAutomatic       :=OldAutomatic;
    SetInternals;
  end;
end;

Procedure TChartAxis.CustomDrawMinMax( APosLabels,
                                       APosTitle,
                                       APosAxis:Integer;
                                       GridVisible:Boolean;
                                       Const AMinimum,AMaximum,
                                       AIncrement:Double);
begin
  CustomDrawMinMaxStartEnd(APosLabels,APosTitle,APosAxis,GridVisible,
        AMinimum,AMaximum,AIncrement,IStartPos,IEndPos);
end;

Procedure TChartAxis.CustomDraw( APosLabels,APosTitle,APosAxis:Integer;
                                       GridVisible:Boolean);
begin
  InternalCalcPositions;
  CustomDrawStartEnd(APosLabels,APosTitle,APosAxis,GridVisible,IStartPos,IEndPos);
End;

Procedure TChartAxis.CustomDrawStartEnd( APosLabels,APosTitle,APosAxis:Integer;
                                         GridVisible:Boolean; AStartPos,AEndPos:Integer);
var OldGridVisible : Boolean;
    OldChange      : TNotifyEvent;
Begin
  FPosLabels:=APosLabels;
  FPosTitle :=APosTitle;
  FPosAxis  :=APosAxis;
  IStartPos :=AStartPos;
  IEndPos   :=AEndPos;
  RecalcSizeCenter;
  OldGridVisible:=FGrid.Visible;
  OldChange:=FGrid.OnChange;
  FGrid.OnChange:=nil;
  FGrid.Visible:=GridVisible;
  Draw(False);
  FGrid.Visible:=OldGridVisible;
  FGrid.OnChange:=OldChange;
end;

Procedure TChartAxis.RecalcSizeCenter;
begin
  IAxisSize:=IEndPos-IStartPos;
  ICenterPos:=(IStartPos+IEndPos) div 2;
  InternalCalcRange;
end;

Procedure TChartAxis.InternalCalcPositions;

  Procedure DoCalculation(AStartPos:Integer; ASize:Integer);
  begin
    IStartPos:=AStartPos+Round(0.01*ASize*FStartPosition);
    IEndPos:=AStartPos+Round(0.01*ASize*FEndPosition);
  end;

begin
  With ParentChart do
  if IsDepthAxis then DoCalculation(0,Width3D) else
  if Horizontal then DoCalculation(ChartRect.Left,ChartWidth)
                else DoCalculation(ChartRect.Top,ChartHeight);
  RecalcSizeCenter;
end;

Function TChartAxis.ApplyPosition(APos:Integer; Const R:TRect):Integer;
Var tmpSize : Integer;
begin
  result:=APos;
  if FPositionPercent<>0 then
  With R do
  begin
    if FPosUnits=muPercent then
    begin
      if Horizontal then tmpSize:=Bottom-Top else tmpSize:=Right-Left;
      tmpSize:=Round(0.01*FPositionPercent*tmpSize);
    end
    else tmpSize:=Round(FPositionPercent);  // pixels

    if OtherSide then tmpSize:=-tmpSize;
    if Horizontal then tmpSize:=-tmpSize;
    result:=APos+tmpSize;
  end;
end;

Function TChartAxis.GetRectangleEdge(Const R:TRect):Integer;
begin
  With R do
  if OtherSide then
     if Horizontal then result:=Top else result:=Right
  else
     if Horizontal then result:=Bottom else result:=Left;
end;

type TTeeMinorTickProc=Procedure(AMinorTickPos:Integer);

Procedure TChartAxis.Draw(CalcPosAxis:Boolean);
Var tmpValue    : Double;
    tmpNumTicks : Integer;

  Procedure DrawTicksGrid;

    Procedure DrawGridLine(tmp:Integer);
    var tmpZ : Integer;
    begin
      if (tmp>IStartPos) and (tmp<IEndPos) then
      With ParentChart,Canvas,ChartRect do
      begin
        if IsDepthAxis then
        begin
          VertLine3D(Left,Top,Bottom,tmp);
          HorizLine3D(Left,Right,Bottom,tmp);
        end
        else
        begin
          if View3D then
          begin
            if AxisBehind then
            begin
              if not IHideBackGrid then { 6.0 }
                 if Horizontal then VertLine3D(tmp,Top,Bottom,Width3D)
                               else HorizLine3D(Left,Right,tmp,Width3D);

              tmpZ:=Round(Width3D*Grid.ZPosition*0.01); // 6.0

              if (tmpZ<>Width3D) then
                 if Horizontal then ZLine3D(tmp,PosAxis,tmpZ,Width3D)
                               else ZLine3D(PosAxis,tmp,tmpZ,Width3D);
            end
            else
            if Horizontal then VertLine3D(tmp,Top,Bottom,0) // in-front grid
                          else HorizLine3D(Left,Right,tmp,0); // in-front grid
          end
          else
          if Horizontal then DoVertLine(tmp,Top+1,Bottom) { 5.02 (+1) }
                        else DoHorizLine(Left+1,Right,tmp); { 5.02 (+1) }
        end;
      end;
    end;

    Procedure DrawGrids;
    var t : Integer;
    begin
      if Assigned(OnDrawGrids) then OnDrawGrids(Self);

      if FGrid.Visible then
      begin
        With ParentChart,Canvas do
        begin
          if FGrid.Color=clTeeColor then
             AssignVisiblePenColor(FGrid,clGray)
          else
             AssignVisiblePen(FGrid);
          CheckPenWidth(Pen);
        end;

        for t:=0 to tmpNumTicks-1 do
          if Grid.Centered then
          begin
            if t>0 then DrawGridLine(Round(0.5*(Tick[t]+Tick[t-1])))
          end
          else DrawGridLine(Tick[t]);
      end;
    end;

    Var tmpWallSize : Integer;

    Procedure InternalDrawTick(tmp,Delta,tmpTickLength:Integer);
    Begin
      with ParentChart,Canvas do
      Begin
        if IsDepthAxis then
           HorizLine3D(PosAxis+Delta,PosAxis+Delta+tmpTickLength,ChartRect.Bottom,tmp)
        else
        if OtherSide then
        Begin
          if Horizontal then
             VertLine3D(tmp,PosAxis-Delta,PosAxis-Delta-tmpTickLength,IZPos)
          else
          begin
            Inc(Delta,tmpWallSize);
            HorizLine3D(PosAxis+Delta,PosAxis+Delta+tmpTickLength,tmp,IZPos)
          end;
        end
        else
        begin
          Inc(Delta,tmpWallSize);
          if Horizontal then
             if View3D then
                VertLine3D(tmp,PosAxis+Delta,PosAxis+Delta+tmpTickLength,IZPos)
             else
                DoVertLine(tmp,PosAxis+Delta,PosAxis+Delta+tmpTickLength)
          else
             if View3D then
                HorizLine3D(PosAxis-Delta,PosAxis-Delta-tmpTickLength,tmp,IZPos)
             else
                DoHorizLine(PosAxis-Delta,PosAxis-Delta-tmpTickLength,tmp);
        end;
      end;
    end;

    Procedure DrawAxisLine;
    var tmp  : Integer;
    begin
      With ParentChart,Canvas do
      if IsDepthAxis then
      begin
        tmp:=ChartRect.Bottom+CalcWallSize(BottomAxis)-IZPos;
        MoveTo3D(PosAxis,tmp,IStartPos);
        LineTo3D(PosAxis,tmp,IEndPos);
      end
      else
      begin
        if Horizontal then
           if OtherSide then
              // Top axis
              HorizLine3D(IStartPos,IEndPos,PosAxis,IZPos)
           else
              // Bottom axis
              HorizLine3D(IStartPos-CalcWallSize(LeftAxis),
                          IEndPos+CalcWallSize(RightAxis),
                          PosAxis+tmpWallSize,IZPos)
        else
        begin
          if OtherSide then tmp:=tmpWallSize
                       else tmp:=-tmpWallSize;
          VertLine3D(PosAxis+tmp,IStartPos,IEndPos+CalcWallSize(BottomAxis),IZPos);
        end;
      end;
    end;

    Procedure ProcessMinorTicks(IsGrid:Boolean);

      Procedure AProc(APos:Integer);
      begin
        if (APos>IStartPos) and (APos<IEndPos) then
           if IsGrid then DrawGridLine(APos)
                     else InternalDrawTick(APos,1,FMinorTickLength);
      end;

    var t           : Integer;
        tt          : Integer;
        tmpDelta    : Double;
        tmpValue    : Double;
        tmpInvCount : Double;
    begin
      tmpInvCount:=1.0/Succ(FMinorTickCount);

      if tmpNumTicks>1 then
      if not FLogarithmic then
      begin
        tmpDelta:=1.0*(Tick[1]-Tick[0])*tmpInvCount;
        for t:=1 to FMinorTickCount do
        begin
          AProc(Tick[0]-Round(t*tmpDelta));
          AProc(Tick[tmpNumTicks-1]+Round(t*tmpDelta));
        end;
      end;

      for t:=1 to tmpNumTicks-1 do
        if FLogarithmic then
        begin
          tmpValue:=CalcPosPoint(Tick[t-1]);
          tmpDelta:=((tmpValue*FLogarithmicBase)-tmpValue)*tmpInvCount;

          for tt:=1 to FMinorTickCount do
          begin
            tmpValue:=tmpValue+tmpDelta;
            if tmpValue<=IMaximum then AProc(CalcPosValue(tmpValue))
                                  else Break;
          end;
        end
        else
        begin
          tmpDelta:=1.0*(Tick[t]-Tick[t-1])*tmpInvCount;
          for tt:=1 to FMinorTickCount do AProc(Tick[t]-Round(tt*tmpDelta));
        end;
    end;

    Procedure ProcessTicks(APen:TChartPen; AOffset,ALength:Integer);
    var t : Integer;
    begin
      if APen.Visible then
      begin
        ParentChart.Canvas.AssignVisiblePen(APen);
        for t:=0 to tmpNumTicks-1 do
            InternalDrawTick(Tick[t],AOffset,ALength);
      end;
    end;

    Procedure ProcessMinor(APen:TChartPen; IsGrid:Boolean);
    begin
      if (tmpNumTicks>0) and APen.Visible then
      begin
        With ParentChart.Canvas do
        begin
          BackMode:=cbmTransparent; { 5.01 }
          Brush.Style:=bsClear;
          AssignVisiblePen(APen);
        end;
        ProcessMinorTicks(IsGrid);
      end;
    end;

  begin
    With ParentChart.Canvas do
    begin
      Brush.Style:=bsClear;
      BackMode:=cbmTransparent;
    end;

    tmpWallSize:=ParentChart.CalcWallSize(Self);

    if FAxis.Visible then
    begin
      ParentChart.Canvas.AssignVisiblePen(FAxis);
      DrawAxisLine;
    end;

    ProcessTicks(FTicks,1,FTickLength);
    DrawGrids;
    ProcessTicks(FTicksInner,-1,-FTickInnerLength);
    ProcessMinor(FMinorTicks,False);
    ProcessMinor(FMinorGrid,True);
    ParentChart.Canvas.BackMode:=cbmOpaque;
  end;

  Procedure AddTick(Const APos:Integer);
  begin
    SetLength(Tick,Length(Tick)+1);
    Tick[tmpNumTicks]:=APos;
    Inc(tmpNumTicks);
  end;

  Procedure DrawThisLabel(LabelPos:Integer; Const tmpSt:String; Format:TTeeCustomShape=nil);
  var tmpZ : Integer;
  begin
    if TickOnLabelsOnly then AddTick(LabelPos);

    With ParentChart,Canvas do
    Begin
      if Assigned(Format) then AssignFont(Format.Font)
                          else AssignFont(Items.Format.Font);

      // trick
      Brush.Style:=bsSolid;
      Brush.Style:=bsClear;

      {$IFDEF CLX}
      BackMode:=cbmTransparent;
      {$ENDIF}

      if IsDepthAxis then
      begin
        TextAlign:=ta_Left;
        if (View3DOptions.Rotation=360) or View3DOptions.Orthogonal then
           tmpZ:=LabelPos+(FontHeight div 2)
        else
           tmpZ:=LabelPos;

        TextOut3D(PosLabels,ChartRect.Bottom,tmpZ,tmpSt);
      end
      else
      if Horizontal then DrawAxisLabel(LabelPos,PosLabels,FLabelsAngle,tmpSt,Format)
                    else DrawAxisLabel(PosLabels,LabelPos,FLabelsAngle,tmpSt,Format);
    end;
  end;

  Var tmpLabelStyle : TAxisLabelStyle;

  Function GetAxisSeriesLabel(AIndex:Integer; Var AValue:Double;
                              Var ALabel:String):Boolean;
  var t : Integer;
  begin
    result:=False;
    for t:=0 to ISeriesList.Count-1 do
    With ISeriesList[t] do
    if (AIndex>=FFirstVisibleIndex) and (AIndex<=FLastVisibleIndex) then
    begin
      { even if the series has no text labels... 5.01 }
      Case tmpLabelStyle of
        talMark : ALabel:=ValueMarkText[AIndex];
        talText : ALabel:=Labels[AIndex];
      end;
      if Assigned(ParentChart.FOnGetAxisLabel) then
         ParentChart.FOnGetAxisLabel( TChartAxis(Self),ISeriesList[t],
                                      AIndex,ALabel);
      if ALabel<>'' then  // 5.02
      begin
        if Horizontal then AValue:=XValues.Value[AIndex]
                      else AValue:=YValues.Value[AIndex];
        result:=True;
        Break;
      end;
    end;
  end;

  Procedure AxisLabelsSeries;

    Procedure CalcFirstLastAllSeries(Var tmpFirst,tmpLast:Integer);
    var t : Integer;
    begin
      tmpFirst:=High(Integer); // 5.02
      tmpLast:=-1;
      for t:=0 to ISeriesList.Count-1 do
      With ISeriesList[t] do
      begin
        CalcFirstLastVisibleIndex;
        if (FFirstVisibleIndex<tmpFirst) and (FFirstVisibleIndex<>-1) then
           tmpFirst:=FFirstVisibleIndex;
        if (FLastVisibleIndex>tmpLast) then
           tmpLast:=FLastVisibleIndex;
      end;
    end;

    { Select all active Series that have "Labels" }
    Procedure CalcAllSeries;
    var t : Integer;
    begin
      ISeriesList.Clear;
      With ParentChart do
      for t:=0 to SeriesCount-1 do
      With Series[t] do
        if Active and AssociatedToAxis(Self) then
           ISeriesList.Add(Series[t]);
    end;

  var t            : Integer;
      tmp          : Integer;
      tmpNum       : Integer;
      tmpFirst     : Integer;
      tmpLast      : Integer;
      tmpSt        : String;
      tmpValue     : Double;
      OldPosLabel  : Integer;
      OldSizeLabel : Integer;
      tmpLabelSize : Integer;
      tmpDraw      : Boolean;
      tmpLabelW    : Boolean;
  begin
    ISeriesList.Clear;
    CalcAllSeries;
    CalcFirstLastAllSeries(tmpFirst,tmpLast);

    if tmpFirst<>High(Integer) then
    begin
      OldPosLabel :=-1;
      OldSizeLabel:= 0;
      tmpLabelW:=Horizontal;

      Case FLabelsAngle of
         90,270: tmpLabelW:=not tmpLabelW;
      end;

      for t:=tmpFirst to tmpLast do
      if GetAxisSeriesLabel(t,tmpValue,tmpSt) then
         if (tmpValue>=IMinimum) and (tmpValue<=IMaximum) then
         begin
          tmp:=Self.CalcPosValue(tmpValue);

          if not TickOnLabelsOnly then AddTick(tmp);

          if FItems.Format.Visible and (tmpSt<>'') then
          begin
            With ParentChart.Canvas do
            begin
              tmpLabelSize:=ParentChart.MultiLineTextWidth(tmpSt,tmpNum);
              if not tmpLabelW then tmpLabelSize:=FontHeight*tmpNum;
            end;

            if (FLabelsSeparation<>0) and (OldPosLabel<>-1) then
            begin
              Inc(tmpLabelSize,Trunc(0.02*tmpLabelSize*FLabelsSeparation));
              tmpLabelSize:=tmpLabelSize div 2;

              if tmp>=OldPosLabel then
                 tmpDraw:=(tmp-tmpLabelSize)>=(OldPosLabel+OldSizeLabel)
              else
                 tmpDraw:=(tmp+tmpLabelSize)<=(OldPosLabel-OldSizeLabel);
              if tmpDraw then
              begin
                DrawThisLabel(tmp,tmpSt);
                OldPosLabel:=tmp;
                OldSizeLabel:=tmpLabelSize;
              end;
            end
            else
            begin
              DrawThisLabel(tmp,tmpSt);
              OldPosLabel:=tmp;
              OldSizeLabel:=tmpLabelSize div 2;
            end;
          end;
         end;
    end;
    ISeriesList.Clear;
  end;

  var IIncrement       : Double;
      tmpWhichDateTime : TDateTimeStep;

  Procedure InternalDrawLabel(DecValue:Boolean);
  var tmp : Integer;
  Begin
    tmp:=CalcPosValue(tmpValue);
    if FLabelsOnAxis or ((tmp>IStartPos) and (tmp<IEndPos)) then
    begin
      if not TickOnLabelsOnly then AddTick(tmp);
      if FItems.Format.Visible then DrawThisLabel(tmp,LabelValue(tmpValue));
    end;
    if DecValue then IncDecDateTime(False,tmpValue,IIncrement,tmpWhichDateTime);
  end;

  Procedure DoDefaultLogLabels;
  var tmpValue2 : Double;
  begin
    if IMinimum<>IMaximum then
    begin
      if IMinimum<=0 then
      begin
        if IMinimum=0 then IMinimum:=0.1
                      else IMinimum:=MinAxisRange;
        tmpValue:=IMinimum;
      end
      else tmpValue:=Power(FLogarithmicBase,LogN(FLogarithmicBase,IMinimum));

      if MinorGrid.Visible then { 5.02 }
      begin
        tmpValue2:=tmpValue;
        if tmpValue2>=IMinimum then
           tmpValue2:=Power(FLogarithmicBase,LogN(FLogarithmicBase,IMinimum)-1);

        if tmpValue2<IMinimum then
           AddTick(CalcPosValue(tmpValue2));
      end;

      While tmpValue<=IMaximum do
      begin
        if tmpValue>=IMinimum then InternalDrawLabel(False);
        tmpValue:=tmpValue*FLogarithmicBase;
      end;

      { for minor grids only... }
      if MinorGrid.Visible and (tmpValue>IMaximum) then { 5.02 }
         AddTick(CalcPosValue(tmpValue));
    end;
  end;

  Procedure DoDefaultLabels;
  var tmp : Double;
      {$IFDEF TEEOCX}
      tmpInValue : Double;
      {$ENDIF}
  Begin
    tmpValue:=IMaximum/IIncrement;
    if Abs(IRange/IIncrement)<10000 then  { if less than 10000 labels... }
    Begin
      { calculate the maximum value... }
      if IAxisDateTime and FExactDateTime and
         (tmpWhichDateTime<>dtNone) and (tmpWhichDateTime>=dtOneDay) then
             tmpValue:=TeeRoundDate(IMaximum,tmpWhichDateTime)
      else
      if (FloatToStr(IMinimum)=FloatToStr(IMaximum)) or (not RoundFirstLabel) then
         tmpValue:=IMaximum
      else
         tmpValue:=IIncrement*Trunc(tmpValue);

      { adjust the maximum value to be inside "IMinimum" and "IMaximum" }
      While tmpValue>IMaximum do
            IncDecDateTime(False,tmpValue,IIncrement,tmpWhichDateTime);

      { Draw the labels... }
      if IRangeZero then
         InternalDrawLabel(False)  { Maximum is equal to Minimum. Draw one label }
      else
      begin
        { do the loop and draw labels... }
        if (Abs(IMaximum-IMinimum)<1e-10) or
           (FloatToStr(tmpValue)=FloatToStr(tmpValue-IIncrement)) then { fix zooming when axis Max=Min }
           InternalDrawLabel(False)
        else
        begin { draw labels until "tmpVale" is less than minimum }
          tmp:=(IMinimum-MinAxisIncrement)/(1.0+MinAxisIncrement);

          while tmpValue>=tmp do
          {$IFDEF TEEOCX}
          begin
            tmpInValue:=tmpValue;
            InternalDrawLabel(True);
            if (Abs((tmpInValue-IIncrement)-tmpValue)>1e-10) and
               (Abs((tmpInValue-IIncrement)-tmpValue)<1) then
              Break;
          end;
          {$ELSE}
          InternalDrawLabel(True);
          {$ENDIF}

        end;
      end;
    end;
  end;

  Procedure DoNotCustomLabels;
  begin
    if Logarithmic and (FDesiredIncrement=0) then DoDefaultLogLabels
                                             else DoDefaultLabels;
  end;

  Procedure DoCustomLabels;
  Const DifFloat = 0.0000001;
  var LabelIndex  : Integer;
      Stop        : Boolean;
      LabelInside : Boolean;
  Begin
    tmpValue:=IMinimum;
    Stop:=True;
    LabelIndex:=0;
    LabelInside:=False;
    Repeat
      ParentChart.FOnGetNextAxisLabel(TChartAxis(Self),LabelIndex,tmpValue,Stop);
      if Stop then
      Begin
        if LabelIndex=0 then DoNotCustomLabels;
        Exit;
      end
      else
      begin { Trick with doubles... }
        LabelInside:=(tmpValue>=(IMinimum-DifFloat)) and
                     (tmpValue<=(IMaximum+DifFloat));
        if LabelInside then InternalDrawLabel(False);
        Inc(LabelIndex);
      end;
    Until (not LabelInside) or (LabelIndex>2000) or Stop; { maximum 2000 labels... }
  end;

  Procedure DrawAxisTitle;
  begin
    if (FAxisTitle.Visible) and (FAxisTitle.FCaption<>'') then
    begin
      if IsDepthAxis then DrawTitle(PosTitle,ParentChart.ChartRect.Bottom)
      else
      if Horizontal then DrawTitle(ICenterPos,PosTitle)
                    else DrawTitle(PosTitle,ICenterPos);
    end;
  end;

  Procedure DepthAxisLabels;
  Var t     : Integer;
      tmp   : Integer;
      tmpSt : String;
  Begin
    if ParentChart.CountActiveSeries>0 then
      for t:=Trunc(IMinimum) to Trunc(IMaximum) do
      Begin
        tmp:=Self.CalcYPosValue(IMaximum-t-0.5);
        if not TickOnLabelsOnly then AddTick(tmp);

        if FItems.Format.Visible then
        begin
          With ParentChart do
          begin
            tmpSt:=SeriesTitleLegend(t,True);
            if Assigned(FOnGetAxisLabel) then
               FOnGetAxisLabel(TChartAxis(Self),nil,t,tmpSt);
          end;

          DrawThisLabel(tmp,tmpSt);
        end;
      end;
  end;

  Procedure DrawCustomLabels;
  var t : Integer;
      tmp : Integer;
      tmpItem : TAxisItem;
      tmpSt   : String;
  begin
    for t:=0 to Items.Count-1 do
    begin
      tmpItem:=Items[t];
      if (tmpItem.Value>=Minimum) and (tmpItem.Value<=Maximum) then
      begin
        tmp:=CalcPosValue(tmpItem.Value);
        if not TickOnLabelsOnly then AddTick(tmp);
        if tmpItem.Visible then
        begin
          tmpSt:=tmpItem.FText;
          if tmpSt='' then tmpSt:=LabelValue(tmpItem.Value);

          DrawThisLabel(tmp,tmpSt,tmpItem);
        end;
      end;
    end;
  end;

Begin
  With ParentChart,ChartRect do
  Begin
    IAxisDateTime:=IsDateTime;

    if CalcPosAxis then
       FPosAxis:=ApplyPosition(GetRectangleEdge(ChartRect),ChartRect);

    DrawAxisTitle;

    tmpNumTicks:=0;
    Tick:=nil;

    if Items.Count=0 then
    begin
      // Assign font before CalcIncrement !
      Canvas.AssignFont(FItems.Format.Font);
      IIncrement:=CalcIncrement;

      if IAxisDateTime and FExactDateTime and (FDesiredIncrement<>0) then
      begin
        tmpWhichDateTime:=FindDateTimeStep(FDesiredIncrement);
        if tmpWhichDateTime<>dtNone then
        While (IIncrement>DateTimeStep[tmpWhichDateTime]) and
              (tmpWhichDateTime<>dtOneYear) do
                  tmpWhichDateTime:=Succ(tmpWhichDateTime);
      end
      else tmpWhichDateTime:=dtNone;

      if ((IIncrement>0) or
         ( (tmpWhichDateTime>=dtHalfMonth) and (tmpWhichDateTime<=dtOneYear)) )
         and (IMaximum>=IMinimum) then
      Begin
        tmpLabelStyle:=CalcLabelStyle;
        Case tmpLabelStyle of
         talValue: if Assigned(FOnGetNextAxisLabel) then DoCustomLabels
                                                    else DoNotCustomLabels;
          talMark: AxisLabelsSeries;
          talText: if IsDepthAxis then DepthAxisLabels else AxisLabelsSeries;
        end;
      end;
    end
    else DrawCustomLabels;

    DrawTicksGrid;
  end;
end;

Function TChartAxis.SizeTickAxis:Integer;
begin
  if FAxis.Visible then result:=FAxis.Width+1
                   else result:=0;
  if FTicks.Visible then Inc(result,FTickLength);
  if FMinorTicks.Visible then
     result:=Math.Max(result,FMinorTickLength);
end;

Function TChartAxis.SizeLabels:Integer;
begin
  result:=InternalCalcSize(FItems.Format.Font,FLabelsAngle,'',FLabelsSize);
end;

Function TChartAxis.InternalCalcSize( tmpFont:TTeeFont;
                                      tmpAngle:Integer;
                                      Const tmpText:String;
                                      tmpSize:Integer):Integer;
Begin
  if tmpSize<>0 then result:=tmpSize
  else
  With ParentChart,Canvas do
  Begin
    AssignFont(tmpFont);
    if Horizontal then
    Case tmpAngle of
      0, 180: result:=FontHeight;
    else { optimized for speed }
      if tmpText='' then result:=MaxLabelsWidth
                    else result:=Canvas.TextWidth(tmpText);
    end
    else
    Case tmpAngle of
     90, 270: result:=FontHeight;
    else { optimized for speed }
      if tmpText='' then result:=MaxLabelsWidth
                    else result:=Canvas.TextWidth(tmpText);
    end;
  end;
end;

Procedure TChartAxis.CalcRect(Var R:TRect; InflateChartRectangle:Boolean);

  Procedure InflateAxisRect(Value:Integer);
  Begin
    With R do
    if Horizontal then
       if OtherSide then Inc(Top,Value) else Dec(Bottom,Value)
    else
       if OtherSide then Dec(Right,Value) else Inc(Left,Value);
  end;

  Function InflateAxisPos(Value:Integer; Amount:Integer):Integer;
  Begin
    result:=Value;
    if Horizontal then
       if OtherSide then Dec(result,Amount) else Inc(result,Amount)
    else
       if OtherSide then Inc(result,Amount) else Dec(result,Amount);
  end;

  Function CalcLabelsRect(tmpSize:Integer):Integer;
  begin
    InflateAxisRect(tmpSize);
    result:=GetRectangleEdge(R);
  end;

var tmp : Integer;
Begin
  IAxisDateTime:=IsDateTime;

  if InflateChartRectangle then
  begin
    if IsDepthAxis then
       FPosTitle:=R.Right
    else
       With FAxisTitle do
       if Visible and (Caption<>'') then
          FPosTitle:=CalcLabelsRect(InternalCalcSize(Font,FAngle,FCaption,FTitleSize));

    if FItems.Format.Visible then FPosLabels:=CalcLabelsRect(SizeLabels);

    tmp:=SizeTickAxis+ParentChart.CalcWallSize(Self);
    if tmp>0 then InflateAxisRect(tmp);
    FPosTitle:=ApplyPosition(FPosTitle,R);
    FPosLabels:=ApplyPosition(FPosLabels,R);
  end
  else
  begin
    FPosAxis:=ApplyPosition(GetRectangleEdge(R),R);
    FPosLabels:=InflateAxisPos(FPosAxis,SizeTickAxis);
    FPosTitle:=InflateAxisPos(FPosLabels,SizeLabels);
  end;
end;

{$IFDEF D5}
constructor TChartAxis.Create(Chart: TCustomAxisPanel);
begin
  Create(Chart.CustomAxes);
end;
{$ENDIF}

function TChartAxis.IsZStored: Boolean;
begin
  result:=(not IsDepthAxis) and
          (
            (OtherSide and (FZPosition<>100)) or
            ((not OtherSide) and (FZPosition<>0))
          );
end;

procedure TChartAxis.SetMaximumOffset(const Value: Integer);
begin
  ParentChart.SetIntegerProperty(FMaximumOffset,Value);
end;

procedure TChartAxis.SetMinimumOffset(const Value: Integer);
begin
  ParentChart.SetIntegerProperty(FMinimumOffset,Value);
end;

function TChartAxis.IsLogBaseStored: Boolean;
begin
  result:=LogarithmicBase<>10;
end;

function TChartAxis.GetGridCentered: Boolean;
begin
  result:=Grid.Centered;
end;

procedure TChartAxis.SetPosUnits(const Value: TTeeUnits);
begin
  if FPosUnits<>Value then
  begin
    FPosUnits:=Value;
    ParentChart.Invalidate;
  end;
end;

{ TChartDepthAxis }
function TChartDepthAxis.InternalCalcLabelStyle: TAxisLabelStyle;
var t : Integer;
begin
  result:=talText;
  With ParentChart do
  for t:=0 to SeriesCount-1 do
  With Series[t] do
  if Active then
     if HasZValues or (MinZValue<>MaxZValue) then
     begin
       result:=talValue;
       break;
     end;
end;

{ TSeriesMarksPosition }
Procedure TSeriesMarkPosition.Assign(Source:TSeriesMarkPosition);
begin
  ArrowFrom :=Source.ArrowFrom;
  ArrowTo   :=Source.ArrowTo;
  LeftTop   :=Source.LeftTop;
  Height    :=Source.Height;
  Width     :=Source.Width;
end;

Function TSeriesMarkPosition.Bounds:TRect;
begin
  result:={$IFDEF D6}Types.{$ELSE}Classes.{$ENDIF}Bounds(LeftTop.X,LeftTop.Y,Width,Height);
end;

{ TChartValueList }
Constructor TChartValueList.Create(AOwner:TChartSeries; Const AName:String);
Begin
  inherited Create;
  Modified:=True;
  {$IFDEF TEEMULTIPLIER}
  FMultiplier:=1;
  {$ENDIF}
  FOwner:=AOwner;
  FOwner.FValuesList.Add(Self);
  FName:=AName;
  {$IFNDEF TEEARRAY}
  FList:=TList.Create;
  {$ENDIF}
  ClearValues;
end;

Destructor TChartValueList.Destroy;
Begin
  {$IFDEF TEEARRAY}
  ClearValues;
  {$ELSE}
  FList.Free;
  {$ENDIF}
  inherited;
End;

Function TChartValueList.First:TChartValue;
Begin
  result:=Value[0]
end;

{$IFNDEF TEEARRAY}
Function TChartValueList.Count:Integer;
Begin
  result:=FList.Count; { <-- virtual }
end;
{$ENDIF}

Function TChartValueList.Last:TChartValue;
Begin
  result:=Value[Count-1]
end;

Procedure TChartValueList.Delete(ValueIndex:Integer);
Begin
  {$IFDEF TEEARRAY}
  System.Move(Value[ValueIndex+1],Value[ValueIndex],
              SizeOf(TChartValue)*Pred(Count-ValueIndex)); { 5.03 }
  Dec(Count);
  {$ELSE}
  Dispose(PChartValue(FList[ValueIndex]));
  FList.Delete(ValueIndex);
  {$ENDIF}
  Modified:=True;
end;

Procedure TChartValueList.Delete(Start,Quantity:Integer);
{$IFNDEF TEEARRAY}
var t : Integer;
{$ENDIF}
begin
  {$IFDEF TEEARRAY}
  System.Move(Value[Start+Quantity],Value[Start],
              SizeOf(TChartValue)*(Count-Start-Quantity));
  Dec(Count,Quantity);
  {$ELSE}
  for t:=1 to Quantity do Delete(Start);
  {$ENDIF}
  Modified:=True;
end;

Procedure TChartValueList.InsertChartValue(ValueIndex:Integer; Const AValue:TChartValue);
{$IFDEF TEEARRAY}
Var t   : Integer;
    tmp : Integer;
{$ELSE}
Var p   : PChartValue;
{$ENDIF}
Begin
{$IFDEF TEEARRAY}

  Inc(Count);
  tmp:=Length(Value);
  if Count>tmp then SetLength(Value,tmp+TeeDefaultCapacity);

  // IncrementArray; 5.02 (speed optimization)

  for t:=Pred(Count) downto Succ(ValueIndex) do Value[t]:=Value[t-1];

  Value[ValueIndex]:=AValue;
{$ELSE}
  New(p);
  p^:=AValue;
  FList.Insert(ValueIndex,p);  { <- virtual }
{$ENDIF}
  Modified:=True;
end;

Function TChartValueList.AddChartValue(Const AValue:TChartValue):Integer;

  {$IFDEF TEEARRAY}
  Procedure IncrementArray;
  var tmp : Integer;
  begin
    Inc(Count);
    tmp:=Length(Value);
    if Count>tmp then SetLength(Value,tmp+TeeDefaultCapacity);
  end;
  {$ENDIF}

Var t : Integer;
{$IFDEF TEEARRAY}
    tmp : Integer;
{$ELSE}
    p   : PChartValue;
{$ENDIF}
Begin
{$IFNDEF TEEARRAY}
  New(p);    { virtual }
  p^:=AValue;
{$ENDIF}
  if FOrder=loNone then
  begin
    {$IFDEF TEEARRAY}
    result:=Count;

    { IncrementArray (optimized) }
    Inc(Count);
    tmp:=Length(Value);
    if Count>tmp then
       SetLength(Value,tmp+TeeDefaultCapacity);

    Value[result]:=AValue;
    {$ELSE}
    result:=FList.Add(p)
    {$ENDIF}
  end
  else
  begin
    t:={$IFDEF TEEARRAY}Count{$ELSE}FList.Count{$ENDIF}-1;
    if (t=-1) or
       ( (FOrder=loAscending) and (AValue>={$IFDEF TEEARRAY}Value[t]{$ELSE}PChartValue(FList[t])^{$ENDIF}) ) or
       ( (FOrder=loDescending) and (AValue<={$IFDEF TEEARRAY}Value[t]{$ELSE}PChartValue(FList[t])^{$ENDIF}) ) then
    begin
      {$IFDEF TEEARRAY}
      result:=Count;
      IncrementArray;
      Value[result]:=AValue;
      {$ELSE}
      result:=FList.Add(p)
      {$ENDIF}
    end
    else
    Begin
      if FOrder=loAscending then
         While (t>=0) and ({$IFDEF TEEARRAY}Value[t]{$ELSE}PChartValue(FList[t])^{$ENDIF}>AValue) do Dec(t)
      else
         While (t>=0) and ({$IFDEF TEEARRAY}Value[t]{$ELSE}PChartValue(FList[t])^{$ENDIF}<AValue) do Dec(t);
      result:=t+1;
      {$IFDEF TEEARRAY}
      IncrementArray;
      for t:=Pred(Count) downto Succ(result) do Value[t]:=Value[t-1];
      Value[result]:=AValue;
      {$ELSE}
      FList.Insert(result,p);
      {$ENDIF}
    end;
  end;
  Modified:=True;
end;

{$IFDEF TEEMULTIPLIER}
Procedure TChartValueList.SetMultiplier(Const Value:Double);
Begin
  if Value<>FMultiplier then
  begin
    FMultiplier:=Value;
    Modified:=True;
    FOwner.NotifyValue(veRefresh,0);
    FOwner.Repaint;
  end;
end;
{$ENDIF}

Function TChartValueList.GetValue(ValueIndex:Integer):TChartValue;
begin
  {$IFDEF TEEARRAY}
  {$IFOPT R+}
  if (ValueIndex<0) or (ValueIndex>(Count-1)) then
     Raise ChartException.CreateFmt(SListIndexError,[ValueIndex]);
  {$ENDIF}
  result:=Value[ValueIndex]{$IFDEF TEEMULTIPLIER}*FMultiplier{$ENDIF};
  {$ELSE}
  result:=PChartValue(FList[ValueIndex])^{$IFDEF TEEMULTIPLIER}*FMultiplier{$ENDIF};
  {$ENDIF}
end;

Function TChartValueList.Locate(Const AValue:TChartValue):Integer;
Begin
  for result:=0 to Count-1 do
      if Value[result]=AValue then Exit;

  result:=-1;
end;

Procedure TChartValueList.SetValue(ValueIndex:Integer; Const AValue:TChartValue);
begin
  {$IFDEF TEEARRAY}
  {$IFOPT R+}
  if (ValueIndex<0) or (ValueIndex>(Count-1)) then
     Raise ChartException.CreateFmt(SListIndexError,[ValueIndex]);
  {$ENDIF}
  Value[ValueIndex]:=AValue;
  {$ELSE}
  PChartValue(FList[ValueIndex])^:=AValue;
  {$ENDIF}
  Modified:=True;
  FOwner.NotifyValue(veModify,ValueIndex);
end;

Function TChartValueList.GetMaxValue:TChartValue;
begin
  if Modified then RecalcStats;
  result:=FMaxValue;
end;

Function TChartValueList.GetMinValue:TChartValue;
begin
  if Modified then RecalcStats;
  result:=FMinValue;
end;

Function TChartValueList.GetTotal:Double;
begin
  if Modified then RecalcStats;
  result:=FTotal;
end;

Function TChartValueList.GetTotalABS:Double;
begin
  if Modified then RecalcStats;
  result:=FTotalABS;
end;

Procedure TChartValueList.RecalcStats;
var t        : Integer;
    tmpValue : TChartValue;
Begin
  if Count>0 then
  begin
    tmpValue:=Value[0];
    FMinValue:=tmpValue;
    FMaxValue:=tmpValue;
    FTotal:=tmpValue;
    FTotalABS:=Abs(tmpValue);
    for t:=1 to Count-1 do
    Begin
      tmpValue:=Value[t];
      if tmpValue<FMinValue then FMinValue:=tmpValue else
      if tmpValue>FMaxValue then FMaxValue:=tmpValue;
      FTotal:=FTotal+tmpValue;
      FTotalABS:=FTotalABS+Abs(tmpValue);
    end;
  end
  else
  begin
    FMinValue:=0;
    FMaxValue:=0;
    FTotal:=0;
    FTotalABS:=0;
  end;
  Modified:=False;
end;

procedure TChartValueList.SetDateTime(Const Value:Boolean);
Begin
  FOwner.SetBooleanProperty(FDateTime,Value);
end;

Procedure TChartValueList.ClearValues;
{$IFNDEF TEEARRAY}
Var t : Integer;
{$ENDIF}
Begin
  {$IFDEF TEEARRAY}
  SetLength(Value,0);
  Count:=0;
  {$ELSE}
  for t:=0 to FList.Count-1 do Dispose(PChartValue(FList[t])); { virtual }
  FList.Clear;
  {$ENDIF}
  Modified:=True;
end;

Function TChartValueList.Range:TChartValue;
begin
  if Modified then RecalcStats;
  result:=FMaxValue-FMinValue;
end;

Procedure TChartValueList.Scroll;
var t      : Integer;
    tmpVal : {$IFDEF TEEARRAY}TChartValue{$ELSE}PChartValue{$ENDIF};
Begin
{$IFNDEF TEEARRAY}
  With FList do  { virtual }
{$ENDIF}
  if Count>0 then
  Begin
    {$IFDEF TEEARRAY}
    tmpVal:=Value[0];
    for t:=1 to Count-1 do Value[t-1]:=Value[t];
    Value[Count-1]:=tmpVal;
    {$ELSE}
    tmpVal:=Items[0];
    for t:=1 to Count-1 do Items[t-1]:=Items[t];
    Items[Count-1]:=tmpVal;
    {$ENDIF}
  end;
end;

Procedure TChartValueList.SetValueSource(Const Value:String);
Begin
  if FValueSource<>Value then
  begin
    FValueSource:=Value;
    FOwner.CheckDataSource;
  end;
end;

{$IFDEF TEEARRAY}
Procedure TChartValueList.Exchange(Index1,Index2:Integer);
var tmp : TChartValue;
begin
  {$IFOPT R+}
  if (Index1<0) or (Index1>(Count-1)) then
     Raise ChartException.CreateFmt(SListIndexError,[Index1]);
  if (Index2<0) or (Index2>(Count-1)) then
     Raise ChartException.CreateFmt(SListIndexError,[Index2]);
  {$ENDIF}
  tmp:=Value[Index1];
  Value[Index1]:=Value[Index2];
  Value[Index2]:=tmp;
  Modified:=True;
  FOwner.NotifyValue(veModify,Index1);
end;
{$ENDIF}

Procedure TChartValueList.FillSequence;
var t : Integer;
begin
  for t:=0 to Count-1 do Value[t]:=t;
{$IFDEF TEEARRAY}
  Modified:=True;
  FOwner.NotifyValue(veModify,0);
{$ENDIF}
end;

Function TChartValueList.CompareValueIndex(a,b:Integer):Integer;
var tmpA : TChartValue;
    tmpB : TChartValue;
begin
  tmpA:=Value[a];
  tmpB:=Value[b];
  if tmpA<tmpB then result:=-1 else
  if tmpA>tmpB then result:= 1 else result:= 0;
  if FOrder=loDescending then result:=-result;
end;

procedure TChartValueList.Sort;
begin
  if FOrder<>loNone then
     TeeSort(0,Count-1,CompareValueIndex,Owner.SwapValueIndex);
end;

Procedure TChartValueList.Assign(Source:TPersistent);
begin
  if Source is TChartValueList then
  With TChartValueList(Source) do
  begin
    Self.FOrder      :=FOrder;
    Self.FDateTime   :=FDateTime;
    {$IFDEF TEEMULTIPLIER}
    Self.FMultiplier :=FMultiplier;
    {$ENDIF}
    Self.FValueSource:=FValueSource;
  end;
end;

{$IFDEF TEEMULTIPLIER}
function TChartValueList.IsMultiStored: Boolean;
begin
  result:=FMultiplier<>1;
end;
{$ELSE}
procedure TChartValueList.ReadMultiplier(Reader: TReader);
begin
  if Reader.ReadFloat<>1 then
     ShowMessageUser('Error: Multiplier property is obsolete.'+#13+
                 'Modify TeeDefs.inc (enable Multiplier) and recompile.');
end;

procedure TChartValueList.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Multiplier',ReadMultiplier,nil,False);
end;
{$ENDIF}

function TChartValueList.ToString(Index: Integer): String;
begin
  result:=FloatToStr(Value[Index]);
end;

function TChartValueList.IsDateStored: Boolean;
begin
  result:=FDateTime<>IDefDateTime;
end;

procedure TChartValueList.InitDateTime(Value: Boolean);
begin
  FDateTime:=Value;
  IDefDateTime:=Value;
end;

{ TSeriesMarksPositions }
Procedure TSeriesMarksPositions.Put(Index:Integer; APosition:TSeriesMarkPosition);
begin
  While Index>=Count do Add(nil);
  if Items[Index]=nil then Items[Index]:=TSeriesMarkPosition.Create;
  With Position[Index] do
  begin
    Custom:=True;
    Assign(APosition);
  end;
end;

Function TSeriesMarksPositions.Get(Index:Integer):TSeriesMarkPosition;
begin
  if (Index<Count) and Assigned(Items[Index]) then
     result:=TSeriesMarkPosition(Items[Index])
  else
     result:=nil
end;

Procedure TSeriesMarksPositions.Automatic(Index:Integer);
begin
  if (Index<Count) and Assigned(Items[Index]) then Position[Index].Custom:=False;
end;

procedure TSeriesMarksPositions.Clear;
var t : Integer;
begin
  for t:=0 to Count-1 do Position[t].Free;
  inherited;
end;

Function TSeriesMarksPositions.ExistCustom:Boolean;
var t : Integer;
begin
  result:=False;
  for t:=0 to Count-1 do
  if Assigned(Position[t]) and Position[t].Custom then
  begin
    result:=True;
    Exit;
  end;
end;

{ TSeriesMarksGradient }
Constructor TSeriesMarksGradient.Create(ChangedEvent: TNotifyEvent);
begin
  inherited;
  Direction:=gdRightLeft;
  EndColor:=clWhite;
  StartColor:=clSilver;
end;

{ TSeriesMarksItems }
function TMarksItems.Get(Index:Integer):TMarksItem;
var tmp : TMarksItem;
begin
  while Index>(Count-1) do Add(nil);

  if not Assigned(Items[Index]) then
  begin
    tmp:=TMarksItem.Create(IMarks.ParentChart);
    tmp.Color:=ChartMarkColor;
    TSeriesMarks(IMarks).InitShadow(tmp.Shadow);
    Items[Index]:=tmp;
  end;

  result:=Items[Index];
end;

procedure TMarksItems.Clear;
var t : Integer;
begin
  for t:=0 to Count-1 do TMarksItem(Items[t]).Free;
  inherited;
  IMarks.Repaint;
end;

type TShadowAccess=class(TTeeShadow);

{ TSeriesMarks }
Constructor TSeriesMarks.Create(AOwner:TChartSeries);
Begin
  inherited Create(nil);
  FParent         := AOwner;
  FMarkerStyle    := smsLabel;
  FCallout        := TMarksCallout.Create(FParent);
  FDrawEvery      := 1;
  FPositions      := TSeriesMarksPositions.Create;
  FItems          := TMarksItems.Create;
  FItems.IMarks   := Self;

  { inherited }
  Color           := ChartMarkColor;
  Visible         := False;

  InitShadow(Shadow);
end;

Destructor TSeriesMarks.Destroy;
begin
  FCallout.Free;
  FPositions.Free;
  FItems.Free;
  inherited;
end;

Procedure TSeriesMarks.InitShadow(AShadow:TTeeShadow);
Begin
  with TShadowAccess(AShadow) do
  begin
    Color:=clGray;
    DefaultColor:=clGray;
    Size:=1;
    DefaultSize:=1;
  end;
end;

Procedure TSeriesMarks.Assign(Source:TPersistent);
var t : Integer;
Begin
  if Source is TSeriesMarks then
  With TSeriesMarks(Source) do
  Begin
    Self.FAngle      :=FAngle;
    Self.Callout     :=Callout;
    Self.FClip       :=FClip;
    Self.FDrawEvery  :=FDrawEvery;
    Self.FMarkerStyle:=FMarkerStyle;
    Self.FMultiLine  :=FMultiLine;

    Self.Items.Clear;
    for t:=0 to Items.Count-1 do
        Self.Items[t].Assign(Items[t]);
  end;
  inherited;
end;

Function TSeriesMarks.GetBackColor:TColor;
begin
  result:=Color;
end;

function TSeriesMarks.GetItem(Index:Integer):TMarksItem;
begin
  result:=FItems[Index];
end;

Procedure TSeriesMarks.SetBackColor(Value:TColor);
begin
  Color:=Value;
end;

Procedure TSeriesMarks.ResetPositions;
var t : Integer;
begin
  for t:=0 to Positions.Count-1 do Positions.Position[t].Custom:=False;
  FParent.Repaint;
end;

Procedure TSeriesMarks.SetCallout(const Value:TMarksCallout);
begin
  FCallout.Assign(Value);
end;

Procedure TSeriesMarks.SetArrowLength(Value:Integer);
Begin
  Callout.Length:=Value;
end;

Procedure TSeriesMarks.SetDrawEvery(Value:Integer);
begin
  FParent.SetIntegerProperty(FDrawEvery,Value);
end;

Procedure TSeriesMarks.SetAngle(Value:Integer);
begin
  FParent.SetIntegerProperty(FAngle,Value);
end;

Procedure TSeriesMarks.SetMultiLine(Value:Boolean);
Begin
  FParent.SetBooleanProperty(FMultiLine,Value);
end;

Function TSeriesMarks.Clicked(X,Y:Integer):Integer;
begin
  if Assigned(FParent.ParentChart) then
     FParent.ParentChart.Canvas.Calculate2DPosition(x,y,ZPosition);

  with FPositions do
  for result:=0 to Count-1 do
  if (result mod FDrawEvery=0) and
     Assigned(Position[result]) and
     PointInRect(Position[result].Bounds,x,y) then Exit;

  result:=-1;
end;

Procedure TSeriesMarks.UsePosition( Index:Integer; Var MarkPosition:TSeriesMarkPosition);
var tmp : TSeriesMarkPosition;
    Old : TPoint;
begin
  with FPositions do
  begin
    while Index>=Count do Add(nil);

    if Items[Index]=nil then
    begin
      tmp:=TSeriesMarkPosition.Create;
      tmp.Custom:=False;
      Items[Index]:=tmp;
    end;

    tmp:=Position[Index];

    if tmp.Custom then
    begin
      if MarkPosition.ArrowFix then Old:=MarkPosition.ArrowFrom;
      MarkPosition.Assign(tmp);
      if MarkPosition.ArrowFix then MarkPosition.ArrowFrom:=Old;
    end
    else tmp.Assign(MarkPosition);
  end;
end;

Procedure TSeriesMarks.ApplyArrowLength(APosition:TSeriesMarkPosition);
var tmp : Integer;
begin
  tmp:=Callout.Length+Callout.Distance;
  With APosition do
  begin
    Dec(LeftTop.Y,tmp);
    Dec(ArrowTo.Y,tmp);
    Dec(ArrowFrom.Y,Callout.Distance);
  end;
end;

Procedure TSeriesMarks.SetStyle(Value:TSeriesMarksStyle);
Begin
  if FMarkerStyle<>Value then
  begin
    FMarkerStyle:=Value;
    FParent.Repaint;
  end;
end;

Procedure TSeriesMarks.SetClip(Value:Boolean);
Begin
  FParent.SetBooleanProperty(FClip,Value);
end;

Procedure TSeriesMarks.DrawText(Const R:TRect; Const St:String);
Var tmpNumRow    : Integer;
    tmpRowHeight : Integer;

  Procedure DrawTextLine(Const LineSt:String);
  var tmpP : TPoint;
      tmpY : Integer;
      tmp  : Extended;
      S,C  : Extended;
      tmpCenter: TPoint;
  begin
    RectCenter(R,tmpCenter.X,tmpCenter.Y);
    if Angle<>0 then
    begin
      tmp:=Angle*TeePiStep;
      SinCos(tmp,S,C);
      tmpY:=tmpNumRow*tmpRowHeight-(R.Bottom-tmpCenter.y);
      tmpP.X:=tmpCenter.x+Round(tmpY*S);
      if Angle=90 then Inc(tmpP.X,2);
      tmpP.Y:=tmpCenter.y+Round(tmpY*C);
    end
    else
    begin
      tmpP.x:=tmpCenter.x;
      tmpP.y:=R.Top+tmpNumRow*tmpRowHeight;
      if Pen.Visible then Inc(tmpP.y,Pen.Width);
    end;

    With FParent.ParentChart.Canvas do
    if Supports3DText then
       if Angle=0 then
          TextOut3D(tmpP.X,tmpP.Y,ZPosition,LineSt)
       else
          RotateLabel3D(tmpP.X,tmpP.Y,ZPosition,LineSt,FAngle)
    else
       if Angle=0 then
          TextOut(tmpP.X,tmpP.Y,LineSt)
       else
          RotateLabel(tmpP.X,tmpP.Y,LineSt,FAngle);
  end;

Var i     : Integer;
    tmpSt : String;
begin
  tmpNumRow:=0;
  tmpRowHeight:=FParent.ParentChart.Canvas.FontHeight;

  i:=AnsiPos(TeeLineSeparator,St);
  if i>0 then
  begin
    tmpSt:=St;
    Repeat
      DrawTextLine(Copy(tmpSt,1,i-1));
      tmpSt:=Copy(tmpSt,i+1,255);
      Inc(tmpNumRow);
      i:=AnsiPos(TeeLineSeparator,tmpSt);
    Until i=0;
    if tmpSt<>'' then DrawTextLine(tmpSt);
  end
  else DrawTextLine(St);
end;

Procedure TSeriesMarks.ConvertTo2D(APosition:TSeriesMarkPosition; var P:TPoint);
var tmpDifX   : Integer;
    tmpDifY   : Integer;
    tmpPos2D  : TPoint;
begin
  if ParentChart.View3D and (not ParentChart.Canvas.Supports3DText) then
  begin
    With APosition do
    begin
      tmpDifX:=ArrowTo.X-P.X;
      tmpDifY:=ArrowTo.Y-P.Y;
      tmpPos2D:=ParentChart.Canvas.Calculate3DPosition(ArrowTo,ZPosition);
    end;

    P:=TeePoint(tmpPos2D.X-tmpDifX,tmpPos2D.Y-tmpDifY);
  end;
end;

type TMarkItemAccess=class(TTeeCustomShape);

Procedure TSeriesMarks.InternalDraw( Index:Integer; AColor:TColor;
                                Const St:String; APosition:TSeriesMarkPosition);
var tmpBounds : TRect;
    tmpMark   : TTeeCustomShape;
begin
  UsePosition(Index,APosition);

  tmpMark:=MarkItem(Index);

  with FParent,ParentChart.Canvas do
  begin
    if Callout.Visible or Callout.Arrow.Visible then
       Callout.Draw(AColor,APosition.ArrowFrom,APosition.ArrowTo,ZPosition);

    if tmpMark.Transparent then
    begin
      Brush.Style:=bsClear;
      BackMode:=cbmTransparent;
    end
    else AssignBrush(tmpMark.Brush,tmpMark.Color);

    AssignVisiblePen(tmpMark.Pen);

    ConvertTo2D(APosition,APosition.LeftTop);

    tmpBounds:=APosition.Bounds;

    tmpMark.DrawRectRotated(APosition.Bounds,FAngle mod 360,Succ(ZPosition));

    Brush.Style:=bsClear;
    BackMode:=cbmTransparent;
    TextAlign:=TA_CENTER;

    tmpBounds:=APosition.Bounds;
    Inc(tmpBounds.Left,2);

    DrawText(tmpBounds,St);
  end;
end;

function TSeriesMarks.GetGradientClass: TChartGradientClass;
begin
  result:=TSeriesMarksGradient;
end;

Function TSeriesMarks.MarkItem(ValueIndex:Integer):TTeeCustomShape;
begin
  if FItems.Count>ValueIndex then
  begin
    result:=Item[ValueIndex];
    if not Assigned(result) then result:=Self;
  end
  else result:=Self;
end;

Procedure TSeriesMarks.AntiOverlap(First, ValueIndex:Integer; APosition:TSeriesMarkPosition);

  Function TotalBounds(ValueIndex:Integer; APosition:TSeriesMarkPosition):TRect;
  var P : TPoint;
      tmp: Integer;
  begin
    result:=APosition.Bounds;

    with MarkItem(ValueIndex) do
    begin
      if Pen.Visible then
      begin
        Inc(result.Right,Pen.Width);
        Inc(result.Bottom,Pen.Width);
      end;

      with Shadow do
      begin
        if HorizSize>0 then Inc(result.Right,HorizSize)
        else
        if HorizSize<0 then Dec(result.Left,HorizSize);

        if VertSize>0 then Inc(result.Bottom,VertSize)
        else
        if VertSize<0 then Dec(result.Top,VertSize);
      end;
    end;

    P:=result.TopLeft;
    ConvertTo2D(APosition,P);

    tmp:=result.Left-P.X;
    Dec(result.Left,tmp);
    Dec(result.Right,tmp);

    tmp:=result.Top-P.Y;
    Dec(result.Top,tmp);
    Dec(result.Bottom,tmp);
  end;

var tmpBounds : TRect;
    tmpDest   : TRect;
    t         : Integer;
    tmpR      : TRect;
    tmpH      : Integer;
begin
  tmpBounds:=TotalBounds(ValueIndex,APosition);

  for t:=First to ValueIndex-1 do
  if Assigned(Positions[t]) then
  begin
    tmpR:=TotalBounds(t,Positions[t]);

    if {$IFNDEF CLX}Windows.{$ENDIF}IntersectRect(tmpDest,tmpR,tmpBounds) then
    begin
      if tmpBounds.Top<tmpR.Top then
         tmpH:=tmpBounds.Bottom-tmpR.Top
      else
         tmpH:=tmpBounds.Top-tmpR.Bottom;

      Dec(APosition.LeftTop.Y,tmpH);
      Dec(APosition.ArrowTo.Y,tmpH);
    end;
  end;
end;

{ Returns the length in pixels for the ValueIndex th mark text.
  It checks if the Mark has multiple lines of text. }
function TSeriesMarks.TextWidth(ValueIndex: Integer): Integer; // 5.02
var tmpSt : String;
    i     : Integer;
begin
  result:=0;

  tmpSt:=ParentSeries.GetMarkText(ValueIndex);
  i:=AnsiPos(TeeLineSeparator,tmpSt);

  if i>0 then
  Repeat
    result:=Math.Max(result,ParentChart.Canvas.TextWidth(Copy(tmpSt,1,i-1)));
    tmpSt:=Copy(tmpSt,i+1,255);
    i:=AnsiPos(TeeLineSeparator,tmpSt);
  Until i=0;

  if tmpSt<>'' then
     result:=Math.Max(result,ParentChart.Canvas.TextWidth(tmpSt));
end;

function TSeriesMarks.GetArrowLength: Integer;
begin
  result:=Callout.Length;
end;

function TSeriesMarks.GetArrowPen: TChartArrowPen;
begin
  result:=Callout.Arrow;
end;

procedure TSeriesMarks.SetArrowPen(const Value: TChartArrowPen);
begin
  Callout.Arrow:=Value;
end;

procedure TSeriesMarks.Clear;
begin
  Positions.Clear;
  if not FItems.ILoadingCustom then FItems.Clear;
end;

type TReaderAccess=class(TReader);

{ internal. Loads series marks items from the DFM stream }
procedure TSeriesMarks.ReadItems(Stream: TStream);
var tmpCount : Integer;
    t        : Integer;
    Reader   : TReader;
    tmp      : TMarksItem;
begin
  Stream.Read(tmpCount,SizeOf(tmpCount));
  FItems.ILoadingCustom:=tmpCount>0;
  if FItems.ILoadingCustom then
  begin
    Reader:=TReader.Create(Stream,1024);
    for t:=0 to tmpCount-1 do
    begin
      tmp:=Items[t];
      Reader.ReadListBegin;
      while not Reader.EndOfList do TReaderAccess(Reader).ReadProperty(tmp);
      Reader.ReadListEnd;
    end;
    Reader.Free;
  end;
end;

type TWriterAccess=class(TWriter);
     {$IFNDEF D5}
     TPersistentAccess=class(TPersistent);
     {$ENDIF}

{$IFNDEF D5}
procedure WriteProperties(Writer:TWriter; Instance: TPersistent);
var
  I, Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
begin
  with Writer do
  begin
    Count := GetTypeData(Instance.ClassInfo)^.PropCount;
    if Count > 0 then
    begin
      GetMem(PropList, Count * SizeOf(Pointer));
      try
        GetPropInfos(Instance.ClassInfo, PropList);
        for I := 0 to Count - 1 do
        begin
          PropInfo := PropList^[I];
          if PropInfo = nil then break;
          if IsStoredProp(Instance, PropInfo) then
            TWriterAccess(Writer).WriteProperty(Instance, PropInfo);
        end;
      finally
        FreeMem(PropList, Count * SizeOf(Pointer));
      end;
    end;

    TPersistentAccess(Instance).DefineProperties(Writer);
  end;
end;
{$ENDIF}

{ internal. stores series marks items into the DFM stream }
procedure TSeriesMarks.WriteItems(Stream: TStream);
var tmpCount : Integer;
    t        : Integer;
    Writer   : TWriter;
begin
  tmpCount:=Items.Count;
  Stream.Write(tmpCount,SizeOf(tmpCount));
  Writer:=TWriter.Create(Stream,1024);
  for t:=0 to tmpCount-1 do
  begin
    Writer.WriteListBegin;
    if Assigned(Items[t]) then
       {$IFNDEF D5}
       WriteProperties(Writer,Items[t]);
       {$ELSE}
       TWriterAccess(Writer).WriteProperties(Items[t]);
       {$ENDIF}
    Writer.WriteListEnd;
  end;
  Writer.Free;
end;

procedure TSeriesMarks.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Items',ReadItems,WriteItems,Items.Count>0);
end;

{ TTeeFunction }
Constructor TTeeFunction.Create(AOwner: TComponent);
begin
  inherited;
  CanUsePeriod:=True;
  FPeriodAlign:=paCenter;
  FPeriodStyle:=psNumPoints;
end;

Procedure TTeeFunction.BeginUpdate;
begin
  IUpdating:=True;
end;

Procedure TTeeFunction.EndUpdate;
begin
  if IUpdating then
  begin
    IUpdating:=False;
    Recalculate;
  end;
end;

Procedure TTeeFunction.Recalculate;
begin
  if (not IUpdating) and Assigned(FParent) then FParent.CheckDataSource;
end;

Function TTeeFunction.Calculate(SourceSeries:TChartSeries; First,Last:Integer):Double;
begin
  result:=0; { abstract }
end;

Function TTeeFunction.ValueList(ASeries:TChartSeries):TChartValueList;
var tmp : String;
begin
  if Assigned(ParentSeries) then tmp:=ParentSeries.MandatoryValueList.ValueSource
                            else tmp:='';
  With ASeries do
  if tmp='' then result:=MandatoryValueList
            else result:=GetYValueList(tmp);
end;

Procedure TTeeFunction.CalculateAllPoints( Source:TChartSeries;
                                           NotMandatorySource:TChartValueList);
var tmpX : Double;
    tmpY : Double;
begin
  with ParentSeries do
  begin
    tmpY:=Calculate(Source,TeeAllValues,TeeAllValues);
    if not AllowSinglePoint then
    begin
      tmpX:=NotMandatorySource.MinValue;
      AddFunctionXY(Source.YMandatory,tmpX,tmpY);
      tmpX:=NotMandatorySource.MaxValue;
      AddFunctionXY(Source.YMandatory,tmpX,tmpY);
    end
    else { centered point }
    if (not Source.YMandatory) and (ParentSeries.YMandatory) then
    begin
      With NotMandatorySource do tmpX:=MinValue+0.5*Range;
      AddXY(tmpX,tmpY);
    end
    else
    begin
      With NotMandatorySource do tmpX:=MinValue+0.5*Range;
      if ParentSeries.YMandatory then
         AddFunctionXY(Source.YMandatory,tmpX,tmpY)
      else
         AddXY(tmpY,tmpX)
    end;
  end;
end;

Procedure TTeeFunction.CalculatePeriod( Source:TChartSeries;
                                        Const tmpX:Double;
                                        FirstIndex,LastIndex:Integer);
begin
  AddFunctionXY( Source.YMandatory, tmpX, Calculate(Source,FirstIndex,LastIndex) );
end;

Procedure TTeeFunction.CalculateByPeriod( Source:TChartSeries;
                                          NotMandatorySource:TChartValueList);
var tmpX     : Double;
    tmpCount : Integer;
    tmpFirst : Integer;
    tmpLast  : Integer;
    tmpBreakPeriod:Double;
    PosFirst : Double;
    PosLast  : Double;
    tmpStep  : TDateTimeStep;
    tmpCalc  : Boolean;
begin
  With ParentSeries do
  begin
    tmpFirst:=0;
    tmpCount:=Source.Count;
    tmpBreakPeriod:=NotMandatorySource.Value[tmpFirst];
    tmpStep:=FindDateTimeStep(FPeriod);
    Repeat
      PosLast:=0;
      if FPeriodStyle=psNumPoints then
      begin
        tmpLast:=tmpFirst+Round(FPeriod)-1;
        With NotMandatorySource do
        begin
          PosFirst:=Value[tmpFirst];
          if tmpLast<tmpCount then PosLast:=Value[tmpLast];
        end;
      end
      else
      begin
        tmpLast:=tmpFirst;
        PosFirst:=tmpBreakPeriod;
        GetHorizAxis.IncDecDateTime(True,tmpBreakPeriod,FPeriod,tmpStep);
        PosLast:=tmpBreakPeriod-(FPeriod*0.001);
        While tmpLast<(tmpCount-1) do
          if NotMandatorySource.Value[tmpLast+1]<tmpBreakPeriod then Inc(tmpLast)
                                                                else break;
      end;
      tmpCalc:=False;
      if tmpLast<tmpCount then
      begin
        { align periods }
        if FPeriodAlign=paFirst then tmpX:=PosFirst else
        if FPeriodAlign=paLast then tmpX:=PosLast else
                                    tmpX:=(PosFirst+PosLast)*0.5;
        if (FPeriodStyle=psRange) and (NotMandatorySource.Value[tmpFirst]<tmpBreakPeriod) then
           tmpCalc:=True;
        if (FPeriodStyle=psNumPoints) or tmpCalc then
           CalculatePeriod(Source,tmpX,tmpFirst,tmpLast)
        else
           AddFunctionXY( Source.YMandatory, tmpX, 0 );
      end;
      if (FPeriodStyle=psNumPoints) or tmpCalc then tmpFirst:=tmpLast+1;
    until tmpFirst>tmpCount-1;
  end;
end;

Procedure TTeeFunction.AddFunctionXY(YMandatorySource:Boolean; const tmpX,tmpY:Double);
begin
  if YMandatorySource then ParentSeries.AddXY(tmpX,tmpY)
                      else ParentSeries.AddXY(tmpY,tmpX)
end;

procedure TTeeFunction.AddPoints(Source:TChartSeries);

    Procedure CalculateFunctionMany;
    var t        : Integer;
        tmpX     : Double;
        tmpY     : Double;
        XList    : TChartValueList;
    begin
      XList:=Source.NotMandatoryValueList;

      // Find datasource with bigger number of points... 5.02
      with ParentSeries do
      for t:=0 to DataSources.Count-1 do
      if Assigned(DataSources[t]) and
         (TChartSeries(DataSources[t]).Count>Source.Count) then
      begin
        Source:=TChartSeries(DataSources[t]);
        XList:=Source.NotMandatoryValueList;
      end;

      // use source to calculate points...
      if Assigned(XList) then
      for t:=0 to Source.Count-1 do
      begin
        tmpX:=XList.Value[t];
        tmpY:=CalculateMany(ParentSeries.DataSources,t);
        if not Source.YMandatory then SwapDouble(tmpX,tmpY);
        ParentSeries.AddXY( tmpX,tmpY,Source.Labels[t]);
      end;
    end;

begin
  if not IUpdating then // 5.02
  if Assigned(Source) then
  With ParentSeries do
  begin
    if DataSources.Count>1 then
       CalculateFunctionMany
    else
    if Source.Count>0 then
       DoCalculation(Source,Source.NotMandatoryValueList);
  end;
end;

Procedure TTeeFunction.DoCalculation( Source:TChartSeries;
                                      NotMandatorySource:TChartValueList);
begin
  if FPeriod=0 then CalculateAllPoints(Source,NotMandatorySource)
               else CalculateByPeriod(Source,NotMandatorySource);
end;

Procedure TTeeFunction.SetParentSeries(AParent:TChartSeries);
begin
  if AParent<>FParent then
  begin
    if Assigned(FParent) then FParent.FTeeFunction:=nil;
    AParent.SetFunction(Self);
  end;
end;

Function TTeeFunction.CalculateMany(SourceSeriesList:TList; ValueIndex:Integer):Double;
begin
  result:=0;
end;

Procedure TTeeFunction.Assign(Source:TPersistent);
begin
  if Source is TTeeFunction then
  With TTeeFunction(Source) do
  begin
    Self.FPeriod     :=FPeriod;
    Self.FPeriodStyle:=FPeriodStyle;
    Self.FPeriodAlign:=FPeriodAlign;
  end;
end;

Procedure TTeeFunction.InternalSetPeriod(Const APeriod:Double);
begin
  FPeriod:=APeriod;
end;

Procedure TTeeFunction.SetPeriod(Const Value:Double);
begin
  if Value<0 then Raise ChartException.Create(TeeMsg_FunctionPeriod);
  if FPeriod<>Value then
  begin
    FPeriod:=Value;
    Recalculate;
  end;
end;

Procedure TTeeFunction.SetPeriodAlign(Value:TFunctionPeriodalign);
begin
  if Value<>FPeriodAlign then
  begin
    FPeriodAlign:=Value;
    Recalculate;
  end;
end;

Procedure TTeeFunction.SetPeriodStyle(Value:TFunctionPeriodStyle);
begin
  if Value<>FPeriodStyle then
  begin
    FPeriodStyle:=Value;
    Recalculate;
  end;
end;

function TTeeFunction.GetParentComponent: TComponent;
begin
  result:=FParent;
end;

procedure TTeeFunction.SetParentComponent(Value: TComponent);
begin
  if Assigned(Value) then ParentSeries:=TChartSeries(Value);
end;

function TTeeFunction.HasParent: Boolean;
begin
  result:=True;
end;

Function TTeeFunction.IsValidSource(Value:TChartSeries):Boolean;
Begin
  result:=True; { abstract }
end;

{ TeeMovingFunction }
Constructor TTeeMovingFunction.Create(AOwner:TComponent);
begin
  inherited;
  InternalSetPeriod(1);
  SingleSource:=True;
end;

// Calls "Calculate" function for each group of Period points.
// ie: When Period=10, calls:
//   Calculate(0,9) Calculate(1,10) Calculate(2,11)... etc
Procedure TTeeMovingFunction.DoCalculation( Source:TChartSeries;
                                      NotMandatorySource:TChartValueList);
Var t : Integer;
    P : Integer;
begin
  P:=Round(FPeriod);
  for t:=P-1 to Source.Count-1 do
      AddFunctionXY( Source.YMandatory, NotMandatorySource.Value[t], Calculate(Source,t-P+1,t));
end;

class function TTeeFunction.GetEditorClass: String;
begin
  result:='TTeeFunctionEditor'; // Default editor  // 6.0
end;

type TSeriesAccess=class(TChartSeries);

class Procedure TTeeFunction.PrepareForGallery(Chart:TCustomAxisPanel);
var t : Integer;
begin
  for t:=0 to Chart.SeriesCount-1 do
      TSeriesAccess(Chart[t]).PrepareForGallery(True);
end;

{ TCustomChartElement }
Constructor TCustomChartElement.Create(AOwner: TComponent);
begin
  inherited;
  FActive:=True;
  FBrush:=TChartBrush.Create(CanvasChanged);
  FPen:=CreateChartPen;
end;

Destructor TCustomChartElement.Destroy;
begin
  FPen.Free;
  FBrush.Free;
  {$IFNDEF D5}
  Destroying;
  {$ENDIF}
  ParentChart:=nil;
  inherited;
end;

procedure TCustomChartElement.Assign(Source:TPersistent);
Begin
  if Source is TCustomChartElement then
  With TCustomChartElement(Source) do
  begin
    Self.FActive:= FActive;
    Self.Brush  := FBrush;
    Self.Pen    := FPen;
    Self.Tag    := Tag;
  end
  else inherited;
end;

Procedure TCustomChartElement.CanvasChanged(Sender:TObject);
Begin
  Repaint;
end;

Function TCustomChartElement.CreateChartPen:TChartPen;
begin
  result:=TChartPen.Create(CanvasChanged);
end;

{ Returns the Form class name that allows editing our properties }
class Function TCustomChartElement.GetEditorClass:String;
Begin
  result:='';
end;

procedure TCustomChartElement.SetBrush(const Value: TChartBrush);
begin
  FBrush.Assign(Value);
end;

procedure TCustomChartElement.SetPen(const Value: TChartPen);
begin
  FPen.Assign(Value);
end;

Procedure TCustomChartElement.Repaint;
Begin
  if Assigned(FParent) then FParent.Invalidate;
end;

Procedure TCustomChartElement.SetActive(Value:Boolean);
Begin
  SetBooleanProperty(FActive,Value);
end;

{ Changes the Parent property }
Procedure TCustomChartElement.SetParentChart(Const Value:TCustomAxisPanel);
begin
  FParent:=Value;
  {$IFDEF TEETRIAL}
  if Assigned(TeeAboutBoxProc) and not (csDesigning in ComponentState) then TeeAboutBoxProc;
  {$ENDIF}
end;

{ Changes the Variable parameter with the Value and repaints if different }
Procedure TCustomChartElement.SetBooleanProperty(Var Variable:Boolean; Value:Boolean);
Begin
  if Variable<>Value then
  begin
    Variable:=Value;   Repaint;
  end;
end;

{ Changes the Variable parameter with the Value and repaints if different }
Procedure TCustomChartElement.SetColorProperty(Var Variable:TColor; Value:TColor);
Begin
  if Variable<>Value then
  begin
    Variable:=Value; Repaint;
  end;
end;

{ Changes the Variable parameter with the Value and repaints if different }
Procedure TCustomChartElement.SetDoubleProperty(Var Variable:Double; Const Value:Double);
begin
  if Variable<>Value then
  begin
    Variable:=Value; Repaint;
  end;
end;

{ Changes the Variable parameter with the Value and repaints if different }
Procedure TCustomChartElement.SetIntegerProperty(Var Variable:Integer; Value:Integer);
Begin
  if Variable<>Value then
  begin
    Variable:=Value;   Repaint;
  end;
end;

{ Changes the Variable parameter with the Value and repaints if different }
Procedure TCustomChartElement.SetStringProperty(Var Variable:String; Const Value:String);
Begin
  if Variable<>Value then
  begin
    Variable:=Value;   Repaint;
  end;
end;

{ Internal. VCL mechanism to define parentship between chart and series. }
function TCustomChartElement.GetParentComponent: TComponent;
begin
  result:=FParent;
end;

{ Internal. VCL mechanism to define parentship between chart and series. }
procedure TCustomChartElement.SetParentComponent(AParent: TComponent);
begin
  if AParent is TCustomAxisPanel then ParentChart:=TCustomAxisPanel(AParent);
end;

{ Internal. VCL mechanism to define parentship between chart and series. }
function TCustomChartElement.HasParent: Boolean;
begin
  result:=True;
end;

{ TCustomChartSeries }
Constructor TCustomChartSeries.Create(AOwner: TComponent);
begin
  inherited;
  FShowInLegend:=True;
end;

Procedure TCustomChartSeries.Added; { virtual }
begin
end;

{ copy basic properties from one series to self }
procedure TCustomChartSeries.Assign(Source:TPersistent);
Begin
  if Source is TCustomChartSeries then
  With TCustomChartSeries(Source) do
  begin
    Self.FShowInLegend := FShowInLegend;
    Self.FTitle        := FTitle;
    Self.FStyle        := FStyle;
    Self.FIdentifier   := FIdentifier;
  end;
  inherited;
end;

{ Internal. Used in Decision Graph component. }
procedure TCustomChartSeries.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Identifier',ReadIdentifier,WriteIdentifier,Identifier<>'');  { <-- don't translate }
  Filer.DefineProperty('Style',ReadStyle,WriteStyle,Style<>[]);  { <-- don't translate }
end;

{ Internal. Used in Decision Graph component. }
procedure TCustomChartSeries.ReadIdentifier(Reader: TReader);
begin
  Identifier:=Reader.ReadString;
end;

{ Internal. Used in Decision Graph component. }
procedure TCustomChartSeries.WriteIdentifier(Writer: TWriter);
begin
  Writer.WriteString(Identifier);
end;

{ Internal. Used in Decision Graph component. }
procedure TCustomChartSeries.ReadStyle(Reader: TReader);
var tmp : Integer;
begin
  tmp:=Reader.ReadInteger;
  FStyle:=[];
  if (tmp and 1)=1 then FStyle:=FStyle+[tssIsTemplate];
  if (tmp and 2)=2 then FStyle:=FStyle+[tssDenyChangeType];
  if (tmp and 4)=4 then FStyle:=FStyle+[tssDenyDelete];
  if (tmp and 8)=8 then FStyle:=FStyle+[tssDenyClone];
  if (tmp and 16)=16 then FStyle:=FStyle+[tssIsPersistent];
  if (tmp and 32)=32 then FStyle:=FStyle+[tssHideDataSource];
end;

{ Internal. Used in Decision Graph component (Decision Cube components). }
procedure TCustomChartSeries.WriteStyle(Writer: TWriter);
var tmp : Integer;
begin
  tmp:=0;
  if tssIsTemplate     in FStyle then Inc(tmp);
  if tssDenyChangeType in FStyle then Inc(tmp,2);
  if tssDenyDelete     in FStyle then Inc(tmp,4);
  if tssDenyClone      in FStyle then Inc(tmp,8);
  if tssIsPersistent   in FStyle then Inc(tmp,16);
  if tssHideDataSource in FStyle then Inc(tmp,32);
  Writer.WriteInteger(tmp);
end;

{ Returns the number of pixels for horizontal margins }
Procedure TCustomChartSeries.CalcHorizMargins(Var LeftMargin,RightMargin:Integer);
begin
  LeftMargin:=0; RightMargin:=0;  { abstract }
end;

{ Returns the number of pixels for vertical margins }
Procedure TCustomChartSeries.CalcVerticalMargins(Var TopMargin,BottomMargin:Integer);
begin
  TopMargin:=0; BottomMargin:=0;  { abstract }
end;

procedure TCustomChartSeries.DoBeforeDrawChart;
begin
end;

{ Called when the Gallery "3D" option is changed. }
Procedure TCustomChartSeries.GalleryChanged3D(Is3D:Boolean);
begin
  ParentChart.View3D:=Is3D;
end;

Procedure TCustomChartSeries.Removed;
begin
  FParent:=nil;
end;

{ Returns True when the tmpSeries parameter is of the same class }
Function TCustomChartSeries.SameClass(tmpSeries:TChartSeries):Boolean;
begin
  result:=( (Self is tmpSeries.ClassType) or (tmpSeries is Self.ClassType));
end;

{ Tells the design-time Series Designer window to repaint }
Procedure TCustomChartSeries.RepaintDesigner;
begin
  if Assigned(ParentChart) and Assigned(ParentChart.Designer) then
     ParentChart.Designer.Repaint;
end;

{ show / hide Series }
Procedure TCustomChartSeries.SetActive(Value:Boolean);
Begin
  inherited;
  if Assigned(ParentChart) then ParentChart.BroadcastSeriesEvent(Self,seChangeActive);
  RepaintDesigner;
end;

Procedure TCustomChartSeries.SetShowInLegend(Value:Boolean);
Begin
  SetBooleanProperty(FShowInLegend,Value);
end;

{ change the Series "Title" (custom text) }
Procedure TCustomChartSeries.SetTitle(Const Value:String);
Begin
  SetStringProperty(FTitle,Value);
  if Assigned(ParentChart) then ParentChart.BroadcastSeriesEvent(Self,seChangeTitle);
  RepaintDesigner;
end;

{ TChartValueLists }
Procedure TChartValueLists.Clear;
var t : Integer;
begin
  for t:=0 to Count-1 do ValueList[t].Free;
  inherited;
end;

Function TChartValueLists.Get(Index:Integer):TChartValueList;
begin
   result:=List^[Index];
end;

{ TChartSeries }
Constructor TChartSeries.Create(AOwner: TComponent);
begin
  inherited;
  FZOrder:=TeeAutoZOrder;
  FDepth:=TeeAutoDepth;
  FHorizAxis:=aBottomAxis;
  FVertAxis:=aLeftAxis;
  FValuesList:=TChartValueLists.Create;

  FX:=TChartValueList.Create(Self,TeeMsg_ValuesX);
  FX.FOrder:=loAscending;
  NotMandatoryValueList:=FX;

  FY:=TChartValueList.Create(Self,TeeMsg_ValuesY);
  MandatoryValueList:=FY;
  YMandatory:=True;

  FLabels:=TLabelsList.Create;
  FLabels.Series:=Self;

  FColor :=clTeeColor;
  FCursor:=crDefault;
  FMarks :=TSeriesMarks.Create(Self);
  FValueFormat      :=TeeMsg_DefValueFormat;
  FPercentFormat    :=TeeMsg_DefPercentFormat;
  FDataSources      :=TList.Create;
  FLinkedSeries     :=TChartSeriesList.Create;
  FRecalcOptions    := [rOnDelete,rOnModify,rOnInsert,rOnClear];

  FFirstVisibleIndex:=-1;
  FLastVisibleIndex :=-1;
  AllowSinglePoint  :=True;
  CalcVisiblePoints :=True;
  IUseSeriesColor   :=True;
  IUseNotMandatory  :=True;
end;

{ Frees all properties }
Destructor TChartSeries.Destroy;
Var t : Integer;
Begin
  if Assigned(FTeeFunction)
     {$IFDEF CLX}
     and (not (csDestroying in FTeeFunction.ComponentState))
     {$ENDIF}
     then
        FreeAndNil(FTeeFunction);

  RemoveAllLinkedSeries;

  if Assigned(DataSource) and (DataSource.Owner=Self) then
     DataSource.Free; { 5.02 }

  FreeAndNil(FDataSources);

  if Assigned(FLinkedSeries) then // 5.02
  for t:=0 to FLinkedSeries.Count-1 do
      FLinkedSeries[t].RemoveDataSource(Self);

  Clear;
  FreeAndNil(FLinkedSeries);
  FValuesList.Free;
  FColors.Free;
  FLabels.Free;
  FreeAndNil(FMarks);  // 5.01

  inherited;
end;

{ Returns True when in design-mode or when we want random sample
  points for the series at run-time. }
Function TChartSeries.CanAddRandomPoints:Boolean;
begin
  result:=TeeRandomAtRunTime or (csDesigning in ComponentState);
end;

{ Called when the series is added into a Chart series list. }
Procedure TChartSeries.Added;
begin
  inherited;
  if FColor=clTeeColor then SeriesColor:=FParent.GetFreeSeriesColor;
  RecalcGetAxis;
  CheckDataSource;
end;

{ Called when the series is removed from a Chart series list. }
Procedure TChartSeries.Removed;
begin
  if Cursor=FParent.Cursor then { restore cursor }
     FParent.Cursor:=FParent.OriginalCursor;
  RemoveAllLinkedSeries;
  inherited;
end;

{ internal. Called by Chart. Raises OnMouseEnter or OnMouseLeave events, and
  changes Cursor. Returns True if Clicked and Cursor <> crDefault. }
Function TChartSeries.CheckMouse(x,y:Integer):Boolean;
begin
  result:=False;

  if (Cursor<>crDefault) or Assigned(FOnMouseEnter)
                         or Assigned(FOnMouseLeave) then
  begin
    if Clicked(X,Y)<>-1 then { <-- mouse is over a Series value ! }
    Begin
      if Cursor<>crDefault then ParentChart.Cursor:=Cursor;

      if not IsMouseInside then
      begin
        IsMouseInside:=True;
        if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
      end;

      result:=True;
    end
    else
    begin
      if IsMouseInside then
      begin
        IsMouseInside:=False;
        if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
      end;
    end;
  end;
end;

{ internal. VCL streaming mechanism. Stores the Function, if any. }
Procedure TChartSeries.GetChildren(Proc:TGetChildProc; Root:TComponent);
begin
  inherited;
  if Assigned(FunctionType) then Proc(FunctionType);
end;

{ Sets the chart that will contain and display the series }
Procedure TChartSeries.SetParentChart(Const Value:TCustomAxisPanel);
Begin
  if FParent<>Value then
  Begin
    if Assigned(FParent) then FParent.RemoveSeries(Self);

    inherited;

    if Assigned(FMarks) then
    begin
      FMarks.ParentChart:=FParent;  // 5.01
      FMarks.Callout.ParentChart:=FParent;
    end;

    if Assigned(FParent) then FParent.InternalAddSeries(Self);
  end;
end;

{ Associates the series to a function }
procedure TChartSeries.SetFunction(AFunction:TTeeFunction);
begin
  if FTeeFunction<>AFunction then
  begin
    FTeeFunction.Free;

    { set new function }
    FTeeFunction:=AFunction;

    if Assigned(FTeeFunction) then
    begin
      FTeeFunction.FParent:=Self;
      ManualData:=False;
    end;

    { force recalculation (add points using function or clear) }
    CheckDataSource;
  end;
end;

// When the data source is destroyed, sets it to nil.
procedure TChartSeries.Notification( AComponent: TComponent;
                                     Operation: TOperation);
begin
  inherited;
  if Operation=opRemove then
     if AComponent=FTeeFunction then FTeeFunction:=nil
     else
      { if "AComponent" is the same as series datasource,
        then set datasource to nil }
     if AComponent=DataSource then SetDataSource(nil);
end;

{ Hidden properties. Defines them to store / load from the DFM stream }
procedure TChartSeries.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('DataSources',ReadDataSources,WriteDataSources,FDataSources.Count > 1);  { <-- don't translate }
  Filer.DefineProperty('CustomHorizAxis', ReadCustomHorizAxis,
                                          WriteCustomHorizAxis,Assigned(FCustomHorizAxis));  { <-- don't translate }
  Filer.DefineProperty('CustomVertAxis', ReadCustomVertAxis,
                                          WriteCustomVertAxis,Assigned(FCustomVertAxis));  { <-- don't translate }

  Filer.DefineBinaryProperty('Data',ReadData,WriteData,
                   ForceSaveData or (ManualData and (not DontSaveData)));
end;

procedure TChartSeries.ReadData(Stream: TStream);

  Function ReadLabel:String;
  Var L : Byte;
  begin
    L:=0;
    { read the label length }
    Stream.Read(L, SizeOf(L));
    { read the label contents }
    SetString(Result, nil, L);
    Stream.Read(Pointer(Result)^, L);
  end;

Var tmpFormat       : TeeFormatFlag;
    ValuesListCount : Integer;
    NotYMandatory   : Boolean;

  Procedure ReadSeriesPoint(Index:Integer);
  Var tmpFloat : Double;
      Ax       : Double;
      Ay       : Double;
      AColor   : TColor;
      ALabel   : String;
      tt       : Integer;
      tmp      : TSeriesMarkPosition;
  begin
    { read the "X" value if exists }
    if tfNoMandatory in tmpFormat then Stream.Read(AX,Sizeof(AX))
                                  else AX:=Index; { 5.01 }
    { read the "Y" value }
    Stream.Read(AY,Sizeof(AY));
    { Swap X <--> Y if necessary... }
    if NotYMandatory then SwapDouble(AX,AY);

    { read the Color value if exists }
    if tfColor in tmpFormat then Stream.Read(AColor,Sizeof(AColor))
                            else AColor:=clTeeColor;
    { read the Label value if exists }
    if tfLabel in tmpFormat then ALabel:=ReadLabel
                            else ALabel:='';

    { read the rest of lists values }
    for tt:=2 to ValuesListCount-1 do
    begin
      Stream.Read(tmpFloat,SizeOf(tmpFloat));
      ValuesList[tt].TempValue:=tmpFloat;
    end;
    { add the new point }
    AddXY(AX,AY,ALabel,AColor);  { 5.01 }

    if tfMarkPosition in tmpFormat then
    begin
      tmp:=TSeriesMarkPosition.Create;
      With tmp,Stream do
      begin
        Read(ArrowFrom,SizeOf(ArrowFrom));
        Read(ArrowFix,SizeOf(ArrowFix));
        Read(ArrowTo,SizeOf(ArrowTo));
        Read(Custom,SizeOf(Custom));
        Read(Height,SizeOf(Height));
        Read(LeftTop,SizeOf(LeftTop));
        Read(Width,SizeOf(Width));
      end;
      Marks.Positions.Add(tmp);
    end;
  end;

Var tmpCount : Integer;
    t        : Integer;
begin
  { empty the Series }
  Clear;
  { read the point flags }
  Stream.Read(tmpFormat,SizeOf(tmpFormat));
  { read the number of points }
  Stream.Read(tmpCount,Sizeof(tmpCount));
  { read each point }
  NotYMandatory:=MandatoryValueList<>YValues;
  ValuesListCount:=ValuesList.Count;

  BeginUpdate;  // 6.01
  try
    for t:=0 to tmpCount-1 do ReadSeriesPoint(t);
  finally
    EndUpdate;
  end;

  ManualData:=True;
end;

{ internal. Loads data sources from the DFM stream }
procedure TChartSeries.ReadDataSources(Reader: TReader);
begin
  Reader.ReadListBegin;
  FTempDataSources:=TStringList.Create;
  With FTempDataSources do
  begin
    Clear;
    while not Reader.EndOfList do Add(Reader.ReadString);
  end;
  Reader.ReadListEnd;
end;

procedure TChartSeries.WriteData(Stream: TStream);

  Procedure WriteLabel(Const AString:String);
  Var L : Byte;
  begin
    L:=Length(AString);
    Stream.Write(L,SizeOf(L));
    Stream.Write(PChar(AString)^,L);
  end;

Var tmpFormat      : TeeFormatFlag;
    tmpNoMandatory : TChartValueList;

  Procedure WriteSeriesPoint(Index:Integer);
  Var tmpFloat : Double;
      tt       : Integer;
      tmpColor : TColor;
  begin
    { write the "X" point value, if exists }
    if tfNoMandatory in tmpFormat then
    begin
      tmpFloat:=tmpNoMandatory.Value[Index];
      Stream.Write(tmpFloat,Sizeof(tmpFloat));
    end;
    { write the "Y" point value }
    tmpFloat:=MandatoryValueList.Value[Index];
    Stream.Write(tmpFloat,Sizeof(tmpFloat));

    { write the Color point value, if exists }
    if tfColor in tmpFormat then
    begin
      tmpColor:=InternalColor(Index);
      Stream.Write(tmpColor,Sizeof(tmpColor));
    end;

    { write the Label point value, if exists }
    if tfLabel in tmpFormat then WriteLabel(Labels[Index]);
    { write the rest of values (always) }
    for tt:=2 to ValuesList.Count-1 do
    begin
      tmpFloat:=ValuesList[tt].Value[Index];
      Stream.Write(tmpFloat,SizeOf(tmpFloat));
    end;
    if tfMarkPosition in tmpFormat then
    begin
      With Marks.Positions[Index],Stream do
      begin
        Write(ArrowFrom,SizeOf(ArrowFrom));
        Write(ArrowFix,SizeOf(ArrowFix));
        Write(ArrowTo,SizeOf(ArrowTo));
        Write(Custom,SizeOf(Custom));
        Write(Height,SizeOf(Height));
        Write(LeftTop,SizeOf(LeftTop));
        Write(Width,SizeOf(Width));
      end;
    end;
  end;

var t   : Integer;
    tmp : Integer;
begin
  { write the "flag" containing the format of a point }
  tmpFormat:=SeriesGuessContents(Self);
  Stream.Write(tmpFormat,SizeOf(tmpFormat));
  { write all points. pre-calculate tmpNoMandatory }
  tmpNoMandatory:=NotMandatoryValueList;
  { write the number of points }
  tmp:=Count;
  Stream.Write(tmp,Sizeof(tmp));
  for t:=0 to tmp-1 do WriteSeriesPoint(t);
end;

{ internal. stores data sources into the DFM stream }
procedure TChartSeries.WriteDataSources(Writer: TWriter);
var t : Integer;
begin
  With Writer do
  begin
    WriteListBegin;
    With DataSources do
    for t:=0 to Count-1 do WriteString(TComponent(Items[t]).Name);
    WriteListEnd;
  end;
end;

{ Returns True (the default), when visible points in the series
  should be drawn in ascending order. }
Function TChartSeries.DrawValuesForward:Boolean;
begin
  if YMandatory then
  begin
    result:=not GetHorizAxis.Inverted;
    if ParentChart.InvertedRotation then result:=not result;
  end
  else
     result:=not GetVertAxis.Inverted;
end;

{ Returns True (the default), when several series sharing the
  same Z order should be drawn in ascending order (the same order
  the series have inside the SeriesList. }
Function TChartSeries.DrawSeriesForward(ValueIndex:Integer):Boolean;
begin
  result:=not ParentChart.InvertedRotation; { abstract }
end;

{ Calls DrawValue for all points that are visible. }
procedure TChartSeries.DrawAllValues;
Var t : Integer;
Begin
  if DrawValuesForward then { normal "left to right" order }
     for t:=FFirstVisibleIndex to FLastVisibleIndex do DrawValue(t)
  else { "right to left" }
     for t:=FLastVisibleIndex downto FFirstVisibleIndex do DrawValue(t);
End;

{ tell the Chart to refresh series data using Series.DataSource(s) }
Procedure TChartSeries.CheckDataSource;
begin
  if (IUpdating=0) and Assigned(FParent) then FParent.CheckDataSource(Self);
end;

{ Change the "source" (ie: Table Field name) associated
  to series points colors. }
Procedure TChartSeries.SetColorSource(Const Value:String);
Begin
  if FColorSource<>Value then
  Begin
    FColorSource:=Value;
    CheckDataSource;
  end;
end;

{ Change the "source" (ie: Table Field name) associated
  to series text labels. }
Procedure TChartSeries.SetLabelsSource(Const Value:String);
Begin
  if FLabelsSource<>Value then
  Begin
    FLabelsSource:=Value;
    CheckDataSource;
  end;
end;

{ Returns the point index that is under the XY screen mouse position. }
{ Returns -1 if no points are found under XY }
Function TChartSeries.GetCursorValueIndex:Integer;
Begin
  result:=Clicked(ParentChart.GetCursorPos);
end;

{ Returns the X and Y values that correspond to the mouse
  screen position. }
Procedure TChartSeries.GetCursorValues(Var XValue,YValue:Double);
Begin
  With ParentChart.GetCursorPos do { mouse XY position }
  begin
    { convert XY pixel position to axis scales }
    XValue:=GetHorizAxis.CalcPosPoint(X);
    YValue:=GetVertAxis.CalcPosPoint(Y);
  end;
end;

{ Returns the data source component.
  It is the first component in the DataSources list. }
Function TChartSeries.GetDataSource:TComponent;
begin
  if Assigned(FDataSources) and (DataSources.Count>0) then
     result:=DataSources[0]
  else
     result:=nil;
end;

{ add the Value component as datasource. if Value is a Series,
  add ourselves to Value list of "linked" series }
Procedure TChartSeries.InternalAddDataSource(Value:TComponent);
var Old : Boolean;
begin
  if Assigned(Value) then
  begin
    DataSources.Add(Value);
    ManualData:=False;

    if Value is TChartSeries then
       TChartSeries(Value).AddLinkedSeries(Self)
    else
    begin
      Value.FreeNotification(Self);

      { set ourselves as the Series for Value DataSource }
      if Value is TTeeSeriesSource then
      with TTeeSeriesSource(Value) do
      begin
        if FSeries<>Self then
        begin
          Old:=Active;
          Close;

          if Value.Owner=FSeries then
          begin
            FSeries.RemoveComponent(Value);
            Self.InsertComponent(Value);
          end;
          {$IFDEF D5}
          if Assigned(FSeries) then
             FSeries.RemoveFreeNotification(Value);
          {$ENDIF}
          FSeries:=Self;
          FSeries.FreeNotification(Value);

          if Old then Open;
        end;
      end;
    end;
  end;
end;

{ When this series is a datasource for other series,
  this method tells the other series to remove the reference to itself. }
Procedure TChartSeries.RemoveAllLinkedSeries;
var t : Integer;
begin
  if Assigned(FDataSources) then
     for t:=0 to DataSources.Count-1 do
     if Assigned(DataSources[t]) and (TComponent(DataSources[t]) is TChartSeries) then
        TChartSeries(DataSources[t]).RemoveLinkedSeries(Self);
end;

{ Replaces the DataSource for the series. }
Procedure TChartSeries.SetDataSource(Value:TComponent);

  Procedure ClearDataSources;
  begin
    RemoveAllLinkedSeries;
    DataSources.Clear;
    if not ManualData then Clear;
  end;

  Procedure InternalRemoveDataSource;
  Begin
    {$IFNDEF TEEOCX}
    if not (csDestroying in ComponentState) then { 5.02 }
    {$ENDIF}
    begin
      if Assigned(FParent) and
         Assigned(DataSource) then
           FParent.RemovedDataSource(Self,DataSource);

      ClearDataSources;

      CheckDataSource;
    end;
  end;

  Procedure InternalSetDataSource;
  Begin
    if not Assigned(FParent) then
       raise ChartException.Create(TeeMsg_SeriesSetDataSource)
    else
    if FParent.IsValidDataSource(Self,Value) then
    Begin
      if DataSources.IndexOf(Value)=-1 then
      begin
        if Value is TChartSeries then CheckOtherSeries(TChartSeries(Value));
        if not (csLoading in ComponentState) then ClearDataSources;

        InternalAddDataSource(Value);
        CheckDataSource;
      end;
    end
    else
      Raise ChartException.CreateFmt(TeeMsg_SeriesInvDataSource,[Value.Name]);
  end;

Begin
  if Assigned(Value) then InternalSetDataSource
                     else InternalRemoveDataSource;
end;

Function TChartSeries.IsValidSourceOf(Value:TChartSeries):Boolean;
Begin
  result:=Value<>Self; { abstract }
end;

Function TChartSeries.IsValidSeriesSource(Value:TChartSeries):Boolean;
Begin
  result:=(not Assigned(FTeeFunction)) or FTeeFunction.IsValidSource(Value); { abstract }
end;

{ Returns the value list that has the AListName parameter. }
Function TChartSeries.GetYValueList(AListName:String):TChartValueList;
Var t : Integer;
Begin
  AListName:=AnsiUppercase(AListName);
  for t:=2 to FValuesList.Count-1 do
  if AListName=AnsiUpperCase(FValuesList[t].Name) then
  Begin
    result:=FValuesList[t];
    exit;
  end;
  result:=FY;
end;

Procedure TChartSeries.CheckOtherSeries(Source:TChartSeries);
Begin
  if Assigned(FParent) then FParent.CheckOtherSeries(Self,Source);
end;

{ Replaces the colors for points in the value list that
  have values between FromValue and ToValue. }
Procedure TChartSeries.ColorRange( AValueList:TChartValueList;
                                   Const FromValue,ToValue:Double; AColor:TColor);
var t        : Integer;
    tmpValue : Double;
begin
  for t:=0 to AValueList.Count-1 do
  Begin
    tmpValue:=AValueList.Value[t];
    if (tmpValue>=FromValue) and (tmpValue<=ToValue) and (not IsNull(t)) then
        ValueColor[t]:=AColor;
  end;
  Repaint;
end;

{ Returns the point index that is under the X Y pixel screen position. }
Function TChartSeries.Clicked(x,y:Integer):Integer;
begin
  Result:=TeeNoPointClicked; { abstract, no point clicked }
end;

Function TChartSeries.Clicked(P:TPoint):Integer;
begin
  result:=Clicked(P.X,P.Y);
end;

{ Obtains pointers to the associated axes.
  This is done to optimize speed (cache) when locating the
  associated axes. }
Procedure TChartSeries.RecalcGetAxis;
Begin
  if Assigned(FParent) then
  begin
    { horizontal axis }
    FGetHorizAxis:=FParent.FBottomAxis;
    Case FHorizAxis of
      aTopAxis        : FGetHorizAxis:=FParent.FTopAxis;
      aCustomHorizAxis: if Assigned(FCustomHorizAxis) then FGetHorizAxis:=FCustomHorizAxis;
    end;

    { vertical axis }
    FGetVertAxis:=FParent.LeftAxis;
    Case FVertAxis of
      aRightAxis     : FGetVertAxis:=FParent.FRightAxis;
      aCustomVertAxis: if Assigned(FCustomVertAxis) then FGetVertAxis:=FCustomVertAxis;
    end;
  end
  else
  begin
    FGetHorizAxis:=nil;
    FGetVertAxis:=nil;
  end;
end;

{ internal. read custom horizontal axis from DFM stream }
procedure TChartSeries.ReadCustomHorizAxis(Reader: TReader);
begin
  CustomHorizAxis:=FParent.CustomAxes[Reader.ReadInteger];
end;

{ internal. read custom vertical axis from DFM stream }
procedure TChartSeries.ReadCustomVertAxis(Reader: TReader);
begin
  CustomVertAxis:=FParent.CustomAxes[Reader.ReadInteger];
end;

{ internal. store custom horizontal axis into DFM stream }
procedure TChartSeries.WriteCustomHorizAxis(Writer: TWriter);
begin
  Writer.WriteInteger(FCustomHorizAxis.Index);
end;

{ internal. store custom vertical axis into DFM stream }
procedure TChartSeries.WriteCustomVertAxis(Writer: TWriter);
begin
  Writer.WriteInteger(FCustomVertAxis.Index);
end;

{ change the series horizontal axis }
Procedure TChartSeries.SetHorizAxis(const Value:THorizAxis);
Begin
  if FHorizAxis<>Value then
  begin
    FHorizAxis:=Value;
    if (HorizAxis<>aCustomHorizAxis) and (not (csLoading in ComponentState)) then
       FCustomHorizAxis:=nil;
    RecalcGetAxis;
    Repaint;
  end;
end;

{ change the series vertical axis }
Procedure TChartSeries.SetVertAxis(const Value:TVertAxis);
Begin
  if FVertAxis<>Value then
  begin
    FVertAxis:=Value;
    if (VertAxis<>aCustomVertAxis) and (not (csLoading in ComponentState)) then
       FCustomVertAxis:=nil;
    RecalcGetAxis;
    Repaint;
  end;
end;

Procedure TChartSeries.SetChartValueList( AValueList:TChartValueList;
                                          Value:TChartValueList);
Begin
  AValueList.Assign(Value);
  Repaint;
end;

Procedure TChartSeries.SetXValues(Value:TChartValueList);
Begin
  SetChartValueList(FX,Value);
end;

Procedure TChartSeries.SetYValues(Value:TChartValueList);
Begin
  SetChartValueList(FY,Value);
end;

{ Calculates the range of points that are visible.
  This depends on the series associated vertical and horizontal axis
  scales (minimum and maximum).  }
Procedure TChartSeries.CalcFirstLastVisibleIndex;

  Function CalcMinMaxValue(A,B,C,D:Integer):Double;
  begin
    if YMandatory then
    With GetHorizAxis do
         if Inverted then result:=CalcPosPoint(C)
                     else result:=CalcPosPoint(A)
    else
    With GetVertAxis do
         if Inverted then result:=CalcPosPoint(B)
                     else result:=CalcPosPoint(D);
  end;

Var tmpMin       : Double;
    tmpMax       : Double;
    tmpLastIndex : Integer;
Begin
  FFirstVisibleIndex:=-1;
  FLastVisibleIndex:=-1;

  if Count>0 then
  Begin
    tmpLastIndex:=Count-1;

    if CalcVisiblePoints and (NotMandatoryValueList.Order<>loNone) then
    begin

      { NOTE: The code below does NOT use a "divide by 2" (bubble)
              algorithm because the tmpMin value might not have any
              correspondence with a Series point.
              When the Series point values are "floating" (not integer)
              the "best" solution is to do a lineal all-traverse search.

              However, this code can still be optimized.
              It will be revisited for next coming releases.
      }


      With ParentChart.ChartRect do
           tmpMin:=CalcMinMaxValue(Left,Top,Right,Bottom);

      FFirstVisibleIndex:=0;
      While NotMandatoryValueList.Value[FFirstVisibleIndex]<tmpMin do
      Begin
        Inc(FFirstVisibleIndex);
        if FFirstVisibleIndex>tmpLastIndex then
        begin
          FFirstVisibleIndex:=-1;
          break;
        end;
      end;

      if FFirstVisibleIndex>=0 then
      Begin
        With ParentChart.ChartRect do
             tmpMax:=CalcMinMaxValue(Right,Bottom,Left,Top);

        if NotMandatoryValueList.Last<=tmpMax then
           FLastVisibleIndex:=tmpLastIndex
        else
        Begin
          FLastVisibleIndex:=FFirstVisibleIndex;
          While NotMandatoryValueList.Value[FLastVisibleIndex]<tmpMax do
          begin
            Inc(FLastVisibleIndex);
            if FLastVisibleIndex>tmpLastIndex then
            begin
              FLastVisibleIndex:=tmpLastIndex;
              break;
            end;
          end;

          if (not DrawBetweenPoints) and
             (NotMandatoryValueList.Value[FLastVisibleIndex]>tmpMax) then
                Dec(FLastVisibleIndex);
        end;
      end;
    end
    else
    begin
      FFirstVisibleIndex:=0;
      FLastVisibleIndex:=tmpLastIndex;
    end;
  end;
end;

procedure TChartSeries.DrawValue(ValueIndex:Integer);
begin { nothing }
end;

Function TChartSeries.IsValueFormatStored:Boolean;
Begin
  result:=FValueFormat<>TeeMsg_DefValueFormat;
end;

Function TChartSeries.IsPercentFormatStored:Boolean;
Begin
  result:=FPercentFormat<>TeeMsg_DefPercentFormat;
end;

Procedure TChartSeries.DeletedValue(Source:TChartSeries; ValueIndex:Integer);
Begin
  Delete(ValueIndex);
end;

Function TChartSeries.AddChartValue(Source:TChartSeries; ValueIndex:Integer):Integer;
var t    : Integer;
    tmp  : Integer;
    tmpX : Double;
    tmpY : Double;
begin
  With Source do
  begin
    tmpX:=FX.Value[ValueIndex];
    tmpY:=FY.Value[ValueIndex];
  end;
  { if we are adding values from (for example) an Horizontal Bar series... }
  if Self.YMandatory<>Source.YMandatory then SwapDouble(tmpX,tmpY);
  { pending: if ...FY.Order<>loNone then (inverted) }
  result:=FX.AddChartValue(tmpX);
  FY.InsertChartValue(result,tmpY);
  { rest of lists... }
  tmp:=Source.ValuesList.Count-1;
  for t:=2 to FValuesList.Count-1 do
  begin
    if t<=tmp then tmpY:=Source.FValuesList[t].Value[ValueIndex]
              else tmpY:=0;
    FValuesList[t].InsertChartValue(result,tmpY);
  end;
end;

{ Called when a new value is added to the series. }
Procedure TChartSeries.AddedValue(Source:TChartSeries; ValueIndex:Integer);
Var tmpIndex : Integer;
Begin
  tmpIndex:=AddChartValue(Source,ValueIndex);

  if Assigned(Source.FColors) then
     if Source.FColors.Count>ValueIndex then
     begin
       if not Assigned(FColors) then GrowColors;
       FColors.Insert(tmpIndex,Source.FColors[ValueIndex]);
     end;

  if Source.FLabels.Count>ValueIndex then
     Labels.InsertLabel(tmpIndex,Source.Labels[ValueIndex]);

  NotifyNewValue(Self,tmpIndex);
end;

Function TChartSeries.LegendToValueIndex(LegendIndex:Integer):Integer;
begin
  result:=LegendIndex;
end;

{ Returns the formatted string corresponding to the LegendIndex
  point. The string is used to show at the Legend.
  Uses the LegendTextStyle property to do the appropiate formatting.
}
Function TChartSeries.LegendString( LegendIndex:Integer;
                                    LegendTextStyle:TLegendTextStyle ):String;
var ValueIndex : Integer;

  Function CalcXValue:String;
  Var tmpAxis : TChartAxis;
  begin
    tmpAxis:=GetHorizAxis;
    if Assigned(tmpAxis) then
       result:=tmpAxis.LabelValue(XValues.Value[ValueIndex])
    else
       result:=FormatFloat(ValueFormat,XValues.Value[ValueIndex])
  end;

Var tmpValue : Double;

  Function ValueToStr:String;
  begin
    if MandatoryValueList.DateTime then
       DateTimeToString(result,DateTimeDefaultFormat(tmpValue),tmpValue)
    else
       result:=FormatFloat(ValueFormat,tmpValue);
  end;

  Function CalcPercentSt:String;
  begin
    With MandatoryValueList do
    if TotalAbs=0 then result:=FormatFloat(PercentFormat,100)
                  else result:=FormatFloat(PercentFormat,100.0*tmpValue/TotalAbs);
  end;

begin
  ValueIndex:=LegendToValueIndex(LegendIndex);
  result:=Labels[ValueIndex];
  if LegendTextStyle<>ltsPlain then
  begin
    tmpValue:=GetMarkValue(ValueIndex);
    Case LegendTextStyle of
      ltsLeftValue   : begin
                         if result<>'' then result:=TeeColumnSeparator+result;
                         result:=ValueToStr+result;
                       end;
      ltsRightValue  : begin
                         if result<>'' then result:=result+TeeColumnSeparator;
                         result:=result+ValueToStr;
                       end;
      ltsLeftPercent : begin
                         if result<>'' then result:=TeeColumnSeparator+result;
                         result:=CalcPercentSt+result;
                       end;
      ltsRightPercent: begin
                         if result<>'' then result:=result+TeeColumnSeparator;
                         result:=result+CalcPercentSt;
                       end;
      ltsXValue      : result:=CalcXValue;
      ltsValue       : result:=ValueToStr;
      ltsPercent     : result:=CalcPercentSt;
      ltsXandValue   : result:=CalcXValue+TeeColumnSeparator+ValueToStr;
      ltsXandPercent : result:=CalcXValue+TeeColumnSeparator+CalcPercentSt;
    end;
  end;
end;

{ Clears and adds all points values from Source series. }
procedure TChartSeries.AddValues(Source:TChartSeries);
var t : Integer;
begin
  BeginUpdate;  { before Clear }
  Clear;
  if FunctionType=nil then { "Copy Function", copy values... }
  begin
    if IsValidSourceOf(Source) then
       for t:=0 to Source.Count-1 do AddedValue(Source,t)
  end
  else
  begin
    XValues.DateTime:=Source.XValues.DateTime;
    YValues.DateTime:=Source.YValues.DateTime;
    FunctionType.AddPoints(Source); { calculate function }
  end;
  EndUpdate; { propagate changes... }
end;

{ Copies (adds) all values from Source series. }
Procedure TChartSeries.AssignValues(Source:TChartSeries);
begin
  AddValues(Source);
end;

{ Notifies all series and tools that data (points) has changed. }
Procedure TChartSeries.RefreshSeries;
Begin
  NotifyValue(veRefresh,0);
  if Assigned(ParentChart) then
     ParentChart.BroadcastSeriesEvent(Self,seDataChanged);
End;

{ Returns True if there are more series that share the same Z order.
  For example: Stacked Bars. }
Function TChartSeries.MoreSameZOrder:Boolean;
Var tmpSeries : TChartSeries;
    t         : Integer;
Begin
  if FParent.ApplyZOrder then  { fix 4.02 }
  for t:=0 to FParent.SeriesCount-1 do
  Begin
    tmpSeries:=FParent.Series[t];
    if tmpSeries<>Self then
    With tmpSeries do
    if FActive and (not HasZValues) and (ZOrder=Self.ZOrder) then
    Begin
      result:=True;
      exit;
    end;
  end;
  result:=False;
End;

{ Returns True if the series is the first one with the same Z order.
  Some series allow sharing the same Z order (example: Stacked Bars). }
Function TChartSeries.FirstInZOrder:Boolean;
Var tmpSeries : TChartSeries;
    t         : Integer;
Begin
  if FActive then
  begin
    result:=True;
    for t:=0 to FParent.SeriesCount-1 do
    Begin
     tmpSeries:=FParent.Series[t];
     if tmpSeries=Self then break
     else
       With tmpSeries do
       if FActive and (ZOrder=Self.ZOrder) then
       Begin
         result:=False;
         break;
       end;
    end;
  end
  else result:=False;
end;

{ Calls the BeforeDrawValues event. }
procedure TChartSeries.DoBeforeDrawValues;
Begin
  if Assigned(FBeforeDrawValues) then FBeforeDrawValues(Self);
end;

{ Calls the AfterDrawValues event. }
procedure TChartSeries.DoAfterDrawValues;
Begin
  if Assigned(FAfterDrawValues) then FAfterDrawValues(Self);
end;

{ Draws all Marks for all points in the series that are visible. }
procedure TChartSeries.DrawMarks;
Var t         : Integer;
    St        : String;
    tmpWidth  : Integer;
    tmpW      : Integer;
    tmpH      : Integer;
    APosition : TSeriesMarkPosition;
    tmpMark   : TTeeCustomShape;
Begin
  APosition:=TSeriesMarkPosition.Create;

  With FParent,FMarks do
  for t:=FFirstVisibleIndex to FLastVisibleIndex do
  if (t mod FDrawEvery)=0 then
  if not IsNull(t) then
  Begin
    St:=GetMarkText(t);
    if St<>'' then
    Begin
      tmpMark:=FMarks.MarkItem(t);

      if tmpMark.Visible then
      begin
        Canvas.AssignFont(tmpMark.Font);

        if View3D and (not Canvas.Supports3DText) and
           View3DOptions.ZoomText and (View3DOptions.Zoom<>100) then
           With Canvas.Font do
                Size:=Math.Max(1,Round(0.01*View3DOptions.Zoom*Size));

        tmpW:=MultiLineTextWidth(St,tmpH)+Canvas.TextWidth(TeeCharForHeight);
        tmpH:=tmpH*Canvas.FontHeight;

        Canvas.AssignVisiblePen(tmpMark.Pen);

        if tmpMark.Pen.Visible then
        Begin
          tmpWidth:=2*tmpMark.Pen.Width;
          Inc(tmpW,tmpWidth);
          Inc(tmpH,tmpWidth);
        end
        else Inc(tmpH);

        With APosition do
        begin
          Width:=tmpW;
          Height:=tmpH;
          ArrowTo.X:=CalcXPos(t);
          ArrowTo.Y:=CalcYPos(t);
          ArrowFrom:=ArrowTo;
          LeftTop.X:=ArrowTo.X-(tmpW div 2);
          LeftTop.Y:=ArrowTo.Y-tmpH+1;
        end;

        DrawMark(t,St,APosition);
      end;
    end;
  end;

  APosition.Free;
end;

{ Draws a point Mark using the APosition coordinates. }
Procedure TChartSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                 APosition:TSeriesMarkPosition);
Begin
  FMarks.InternalDraw(ValueIndex,ValueColor[ValueIndex],St,APosition);
end;

{ Triggers the OnAfterAdd event when a new point is added. }
Procedure TChartSeries.NotifyNewValue(Sender:TChartSeries; ValueIndex:Integer);
Begin
  if Assigned(FOnAfterAdd) then FOnAfterAdd(Sender,ValueIndex);
  NotifyValue(veAdd,ValueIndex);
  if FActive then Repaint;
end;

{ Returns True is the ValueIndex point in the Series is Null. }
Function TChartSeries.IsNull(ValueIndex:Integer):Boolean;
begin
  result:=ValueColor[ValueIndex]=clNone;
end;

{ Adds a new Null (missing) point to the series, with specified Value. }
Function TChartSeries.AddNull(Const Value:Double):Integer;
begin
  result:=Add(Value,'',clNone);
end;

{ Adds a new Null (missing) point to the series.
  The ALabel parameter is optional. }
Function TChartSeries.AddNull(Const ALabel:String):Integer;
begin
  result:=Add(0,ALabel,clNone);
end;

{ Adds a new Null (missing) point to the Series with the specified X and
  Y values.
  The ALabel parameter is optional. }
Function TChartSeries.AddNullXY(Const X,Y:Double; Const ALabel:String):Integer;
begin
  result:=AddXY(X,Y,ALabel,clNone);
end;

{ Adds the Values array parameter into the series. }
Function TChartSeries.AddArray(Const Values:Array of TChartValue):Integer;
var t : Integer;
begin
  BeginUpdate;
  try
    result:=High(Values)-Low(Values)+1;
    for t:=Low(Values) to High(Values) do Add(Values[t]);
  finally
    EndUpdate;
  end;
end;

{ Adds a new point to the Series.
  The ALabel and AColor parameters are optional. }
Function TChartSeries.Add(Const AValue:Double; Const ALabel:String; AColor:TColor):Integer;
Begin
  if YMandatory then { 5.02 speed opt. }
     result:=AddXY(FX.Count, AValue, ALabel, AColor )
  else
     result:=AddXY(AValue, FY.Count, ALabel, AColor );
end;

Function TChartSeries.AddX(Const AXValue:Double; Const ALabel:String; AColor:TColor):Integer;
Begin
  result:=AddXY(AXValue,FX.Count,ALabel,AColor);
end;

Function TChartSeries.AddY(Const AYValue:Double; Const ALabel:String; AColor:TColor):Integer;
Begin
  result:=AddXY(FX.Count,AYValue,ALabel,AColor);
end;

{ Adds a new point into the Series. }
Function TChartSeries.AddXY( Const AXValue,AYValue:Double;
                             Const ALabel:String; AColor:TColor):Integer;
var t : Integer;
Begin
  FX.TempValue:=AXValue;
  FY.TempValue:=AYValue;
  if (not Assigned(FOnBeforeAdd)) or FOnBeforeAdd(Self) then
  Begin
    result:=FX.AddChartValue(FX.TempValue);
    FY.InsertChartValue(result,FY.TempValue);

    for t:=2 to ValuesList.Count-1 do
        With ValuesList[t] do InsertChartValue(result,TempValue);

    if Assigned(FColors) then
       FColors.Insert(result,Pointer(AColor))
    else
    if AColor<>clTeeColor then
    begin
      GrowColors;
      FColors.Insert(result,Pointer(AColor));
    end;

    if (ALabel<>'') or (FLabels.Count>0) then { speed opt. 5.02 }
       Labels.InsertLabel(result,ALabel);

    if IUpdating=0 then { 5.02 }
       NotifyNewValue(Self,result);
  end
  else result:=-1;
end;

Function TChartSeries.Count:Integer; { <-- Total number of points in the series }
Begin
  result:=FX.Count;
end;

{ Virtual. Returns the number of points to show at the Legend.
  Some series override this function to return other values. }
Function TChartSeries.CountLegendItems:Integer;
begin
  result:=Count
end;

{ Returns the number of points that are inside the axis limits. (visible) }
Function TChartSeries.VisibleCount:Integer;
Begin
  result:=FLastVisibleIndex-FFirstVisibleIndex+1;
end;

{ Returns the string showing a "percent" value for a given point.
  For example: "25%"
  The optional "AddTotal" parameter, when True, returns for example:
    "25% of 1234".
}
Function TChartSeries.MarkPercent(ValueIndex:Integer; AddTotal:Boolean=False):String;
var tmp  : Double;
    tmpF : String;
Begin
  With MandatoryValueList do
  Begin
    if TotalAbs<>0 then tmp:=100.0*Abs(GetMarkValue(ValueIndex))/TotalAbs
                   else tmp:=100;
    result:=FormatFloat(FPercentFormat,tmp);
    if AddTotal then
    begin
      if Marks.MultiLine then tmpF:=TeeMsg_DefaultPercentOf2
                         else tmpF:=TeeMsg_DefaultPercentOf;
      FmtStr(result,tmpF,[result,FormatFloat(FValueFormat,TotalAbs)]);
    end;
  end;
end;

Function TChartSeries.GetOriginValue(ValueIndex:Integer):Double;
begin
  result:=GetMarkValue(ValueIndex);
end;

Function TChartSeries.GetMarkValue(ValueIndex:Integer):Double;
begin
  result:=MandatoryValueList.Value[ValueIndex];
end;

{ Returns the string corresponding to the Series Mark text
  for a given ValueIndex point.
  The Mark text depends on the Marks.Style property. }
Function TChartSeries.GetMarkText(ValueIndex:Integer):String;

  Function LabelOrValue(ValueIndex:Integer):String;
  Begin
    result:=Labels[ValueIndex];
    if result='' then result:=FormatFloat(FValueFormat,GetMarkValue(ValueIndex));
  End;

  Function GetAXValue:String;
  begin
    if not Assigned(GetHorizAxis) then
       result:=FormatFloat(FValueFormat,NotMandatoryValueList.Value[ValueIndex])
    else
       result:=GetHorizAxis.LabelValue(NotMandatoryValueList.Value[ValueIndex]);
  end;

  Function GetAYValue:String;
  begin
    result:=FormatFloat(FValueFormat,GetMarkValue(ValueIndex));
  end;

var tmp : Char;
Begin
  With FMarks do
  begin
    if MultiLine then tmp:=TeeLineSeparator else tmp:=' ';
    Case FMarkerStyle of
      smsValue:        result:=GetAYValue;
      smsPercent:      result:=MarkPercent(ValueIndex);
      smsLabel:        result:=LabelOrValue(ValueIndex);
      smsLabelPercent: result:=LabelOrValue(ValueIndex)+tmp+MarkPercent(ValueIndex);
      smsLabelValue:   result:=LabelOrValue(ValueIndex)+tmp+GetAYValue;
      smsLegend:       result:=Self.ParentChart.FormattedValueLegend(Self,ValueIndex);
      smsPercentTotal: result:=MarkPercent(ValueIndex,True);
 smsLabelPercentTotal: result:=LabelOrValue(ValueIndex)+tmp+MarkPercent(ValueIndex,True);
      smsXValue:       result:=GetAXValue;
      smsXY:           result:=GetAXValue+tmp+GetAYValue;
    else
      result:='';
    end;
  end;
  if Assigned(FOnGetMarkText) then FOnGetMarkText(Self,ValueIndex,result);
end;

Procedure TChartSeries.SetValueFormat(Const Value:String);
Begin
  SetStringProperty(FValueFormat,Value);
end;

Procedure TChartSeries.SetPercentFormat(Const Value:String);
Begin
  SetStringProperty(FPercentFormat,Value);
end;

{ Changes visual properties appropiate to show the series at
  the gallery. }
Procedure TChartSeries.PrepareForGallery(IsEnabled:Boolean);
begin
  inherited;
  FillSampleValues(4);
  With Marks do
  begin
    Visible:=False;
    Font.Size:=7;
    Callout.Length:=4;
    DrawEvery:=2;
  end;

  FColorEachPoint:=False;
  if IsEnabled then
     if ParentChart.SeriesList.IndexOf(Self)=0 then
        SeriesColor:=ColorPalette[clTeeGallery1]
     else
        SeriesColor:=ColorPalette[clTeeGallery2]
  else
     SeriesColor:=clSilver;
end;

Function TChartSeries.NumSampleValues:Integer;
Begin
  result:=25;  { default number or random values at design time }
end;

{ Calculates appropiate random limits used to add sample
  values (FillSampleValues method).
}
Function TChartSeries.RandomBounds(NumValues:Integer):TSeriesRandomBounds;
Var MinX : Double;
    MaxX : Double;
    MaxY : Double;
Begin
  result.MinY:=0;
  MaxY:=ChartSamplesMax;
  if Assigned(FParent) and (FParent.GetMaxValuesCount>0) then
  begin
    result.MinY:=FParent.MinYValue(GetVertAxis);
    MaxY:=FParent.MaxYValue(GetVertAxis);
    if MaxY=result.MinY then
       if MaxY=0 then MaxY:=ChartSamplesMax
                 else MaxY:=2.0*result.MinY;
    MinX:=FParent.MinXValue(GetHorizAxis);
    MaxX:=FParent.MaxXValue(GetHorizAxis);
    if MaxX=MinX then
       if MaxX=0 then MaxX:=NumValues-1
                 else MaxX:=2.0*MinX;
    if not YMandatory then
    begin
      SwapDouble(MinX,result.MinY);
      SwapDouble(MaxX,MaxY);
    end;
  end
  else
  begin
    if XValues.DateTime then
    begin
      MinX:=Date;
      MaxX:=MinX+NumValues-1;
    end
    else
    begin
      MinX:=0;
      MaxX:=NumValues-1;
    end;
  end;

  result.StepX:=MaxX-MinX;
  if NumValues>1 then result.StepX:=result.StepX/(NumValues-1);
  result.DifY:=MaxY-result.MinY;
  if result.DifY>MaxLongint then result.DifY:=MaxLongint else
  if result.DifY<-MaxLongint then result.DifY:=-MaxLongint;
  result.tmpY:=result.MinY+System.Random(Round(result.DifY));
  result.tmpX:=MinX;
end;

Procedure TChartSeries.AddSampleValues(NumValues:Integer);
var t    : Integer;
    tmpH : Integer;
begin
  With RandomBounds(NumValues) do
  begin
    tmpH:=Round(DifY) div 4;
    for t:=1 to NumValues do
    begin
      tmpY:=Abs(tmpY+System.Random(tmpH)-(tmpH div 2));
      if YMandatory then AddXY(tmpX,tmpY)
                    else AddXY(tmpY,tmpX);
      tmpX:=tmpX+StepX;
    end;
  end;
end;

// Sorts all points in the series using the Labels list.
// Warning: non-mandatory values (X) are modified (they are not preserved).
Procedure TChartSeries.SortByLabels(Order:TChartListOrder=loAscending);
begin
  if Order<>loNone then
  begin
    ILabelOrder:=Order;
    TeeSort(0,Count-1,CompareLabelIndex,SwapValueIndex);
    ILabelOrder:=loNone;
    NotMandatoryValueList.FillSequence;  // force set X values (lost them)
    Repaint;
  end;
end;

{ Sorts all points in the series if the Order property is used.
  By default, Series.XValues.Order is set to "ascending". }
Procedure TChartSeries.CheckOrder;
begin
  if MandatoryValueList.Order<>loNone then
  begin
    MandatoryValueList.Sort;
    // If NotMand list has a ValueSource, do not call FillSequence
    if NotMandatoryValueList.ValueSource='' then { 5.02 }
       NotMandatoryValueList.FillSequence;
    Repaint;
  end;
end;

{ Adds random point to the series. Used at design-time to
  show sample values. }
procedure TChartSeries.FillSampleValues(NumValues:Integer=0);
begin
  if NumValues<0 then
     Raise ChartException.Create(TeeMsg_FillSample)
  else
  if NumValues=0 then
  begin
    NumValues:=INumSampleValues;
    if NumValues=0 then NumValues:=NumSampleValues;
  end;

  Clear;
  BeginUpdate;
  RandSeed:=Random(7774444); { 5.01 }
  AddSampleValues(NumValues);
  CheckOrder;
  EndUpdate;
  ManualData:=False;
end;

procedure TChartSeries.AssignFormat(Source:TChartSeries);
var t : Integer;
begin
  With TChartSeries(Source) do
  begin
    Self.DataSource:=nil;

    if Self.YMandatory=YMandatory then { 5.02 }
    begin
      Self.FX.Assign(FX);
      Self.FY.Assign(FY);
    end
    else
    begin
      Self.FY.Assign(FX);
      Self.FX.Assign(FY);
    end;

    Self.FLabelsSource:=FLabelsSource;
    Self.FColorSource :=FColorSource;

    { other lists }
    for t:=2 to Math.Min(Self.ValuesList.Count-1,ValuesList.Count-1) do
        Self.ValuesList.ValueList[t].Assign(ValuesList[t]);

    Self.Marks           := FMarks;
    Self.FColor          := FColor;
    Self.FColorEachPoint := FColorEachPoint;
    Self.FValueFormat    := FValueFormat;
    Self.FPercentFormat  := FPercentFormat;
    Self.FHorizAxis      := FHorizAxis;
    Self.FVertAxis       := FVertAxis;
    Self.FRecalcOptions  := FRecalcOptions;
    Self.FCursor         := FCursor;
    Self.FDepth          := FDepth;

    Self.RecalcGetAxis; { 5.01 }
  end;
end;

procedure TChartSeries.Assign(Source:TPersistent);

  Procedure SelfSetDataSources(Value:TList);
  var t : Integer;
  begin
    DataSources.Clear;
    for t:=0 to Value.Count-1 do
        InternalAddDataSource(TComponent(Value[t]));
  end;

  Procedure AssignColors;
  var t : Integer;
  begin
    With TChartSeries(Source) do
    if Assigned(FColors) then
    begin
      if Assigned(Self.FColors) then Self.FColors.Clear
                                else Self.FColors:=TList.Create;
      for t:=0 to FColors.Count-1 do Self.FColors.Add(FColors[t]);
    end
    else Self.FColors.Free;
  end;

Begin
  if Source is TChartSeries then
  begin
    inherited;

    AssignFormat(TChartSeries(Source));

    With TChartSeries(Source) do
    begin
      if Assigned(FunctionType) and (Self.FunctionType=nil) then
         FunctionType.ParentSeries:=Self;

      Self.ManualData:=ManualData; // 5.03

      if DataSource=nil then
      begin
        if not (csDesigning in ComponentState) then
        begin
          AssignColors;
          Self.Labels.Assign(Labels);
          Self.AssignValues(TChartSeries(Source));
        end;
      end
      else SelfSetDataSources(DataSources); { <-- important !!! }

      Self.CheckDataSource;
    end;
  end
  else inherited;
end;

Procedure TChartSeries.SetColorEachPoint(Value:Boolean);
//var t : Integer;
Begin
  SetBooleanProperty(FColorEachPoint,Value);
{  if not FColorEachPoint then
  begin
    for t:=0 to Count-1 do if IsNull(t) then exit;
    FreeAndNil(FColors);
  end;}
end;

{ This method replaces a value list with a new one. }
Procedure TChartSeries.ReplaceList(OldList,NewList:TChartValueList);
var t : Integer;
begin
  t:=FValuesList.IndexOf(NewList);
  if t<>-1 then FValuesList.Delete(t);
  t:=FValuesList.IndexOf(OldList);
  if t<>-1 then
  begin
    NewList.Name:=OldList.Name;
    if OldList=FX then
    begin
      FX:=NewList;
      NotMandatoryValueList:=NewList; { 5.01 }
    end
    else
    if OldList=FY then
    begin
      FY:=NewList;
      MandatoryValueList:=NewList; { 5.01 }
    end;
    FValuesList[t].Free;
    FValuesList.Items[t]:=NewList;
  end;
end;

{ Returns an X value. }
Function TChartSeries.GetxValue(ValueIndex:Integer):Double; { "x" in lowercase for BCB }
Begin
  result:=FX.Value[ValueIndex]
end;

{ Returns an Y value. }
Function TChartSeries.GetyValue(ValueIndex:Integer):Double; { "y" in lowercase for BCB }
Begin
  result:=FY.Value[ValueIndex]
end;

{ Changes an Y value. Tells the chart to repaint. }
Procedure TChartSeries.SetYValue(Index:Integer; Const Value:Double);
Begin
  FY.Value[Index]:=Value;
  {$IFDEF TEEARRAY}
  FY.Modified:=True;
  {$ENDIF}
  Repaint;
end;

{ Changes an X value. Tells the chart to repaint. }
Procedure TChartSeries.SetXValue(Index:Integer; Const Value:Double);
Begin
  FX.Value[Index]:=Value;
  {$IFDEF TEEARRAY}
  FX.Modified:=True;
  {$ENDIF}
  Repaint;
end;

Function TChartSeries.InternalColor(ValueIndex:Integer):TColor;
Begin
  if Assigned(FColors) and (FColors.Count>ValueIndex) then
     result:=TColor(FColors[ValueIndex])
  else
     result:=clTeeColor;
end;

{ Returns the color for a given "ValueIndex" point.
  If the "ColorEachPoint" property is used (True) then
  returns a color from the color palette. }
Function TChartSeries.GetValueColor(ValueIndex:Integer):TColor;
Begin
  result:=InternalColor(ValueIndex);
  if result=clTeeColor then
     if FColorEachPoint then result:=GetDefaultColor(ValueIndex)
                        else result:=FColor;

  {if Assigned(FColors) and (FColors.Count>ValueIndex) then
  begin
    result:=TColor(FColors[ValueIndex]);
    if result=clTeeColor then
       if FColorEachPoint then result:=GetDefaultColor(ValueIndex)
                          else result:=FColor;
  end
  else
  if FColorEachPoint then result:=GetDefaultColor(ValueIndex)
                     else result:=FColor;
  }
end;

{ Creates the color list and adds the default color (clTeeColor)
  for all the points in the series. }
Procedure TChartSeries.GrowColors;
var t : Integer;
begin
  FColors:=TList.Create;
  for t:=0 to Count-1 do FColors.Add(Pointer(clTeeColor));
end;

{ Sets the AColor parameter into the color list.
  It is optimized to prevent allocating memory when all the
  colors are the default (clTeeColor). }
Procedure TChartSeries.SetValueColor(ValueIndex:Integer; AColor:TColor);
Begin
  if not Assigned(FColors) then
     if AColor=clTeeColor then Exit
                          else GrowColors;
  FColors[ValueIndex]:=Pointer(AColor);
  Repaint;
end;

{ Clears (empties) all lists of values, colors and labels. }
Procedure TChartSeries.ClearLists;
var t : Integer;
Begin
  { Values }
  for t:=0 to FValuesList.Count-1 do FValuesList[t].ClearValues;

  { Colors }
  FreeAndNil(FColors);

  { Labels }
  Labels.Clear;

  { Marks.Positions }
  if Assigned(FMarks) then FMarks.Clear;
end;

{ Removes all points.
  Triggers all events and notifications and repaints. }
Procedure TChartSeries.Clear;
begin
  ClearLists;
  if Assigned(FOnClearValues) then FOnClearValues(Self);
  NotifyValue(veClear,0);
  if FActive and Assigned(FParent) and
    (not (csDestroying in FParent.ComponentState)) then Repaint;
end;

{ Returns True is the series is associated to Axis parameter.
  Associated means either the horizontal or vertical axis of the Legend
  includes the Axis parameter. }
Function TChartSeries.AssociatedToAxis(Axis:TChartAxis):Boolean;
Begin
  result:=UseAxis and (
         (Axis.Horizontal and ((FHorizAxis=aBothHorizAxis) or (GetHorizAxis=Axis))) or
         ((not Axis.Horizontal) and ((FVertAxis=aBothVertAxis) or (GetVertAxis=Axis)))
        );
end;

{ Draws a rectangle at the Legend that corresponds to the ValueIndex
  point position. If the point color is the same as the Legend
  background color (color conflict),
  then an alternative color is used. }
Procedure TChartSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);
var OldColor : TColor;
begin
  With FParent,Canvas do
  begin
    Rectangle(Rect);  { <-- rectangle }
    if Brush.Color=LegendColor then  { <-- color conflict ! }
    Begin
      OldColor:=Pen.Color;
      if Brush.Color=clBlack then Pen.Color:=clWhite;
      Brush.Style:=bsClear;
      Rectangle(Rect);  { <-- frame rectangle }
      Pen.Color:=OldColor;
    end;
  end;
end;

{ Virtual. Returns the color of the corresponding position in
  the Legend. By default the color the the same as the point color.
  Other series (Surface, etc) return a color from the "palette". }
Function TChartSeries.LegendItemColor(LegendIndex:Integer):TColor;
begin
  result:=ValueColor[LegendIndex];
end;

{ For a given ValueIndex point in the series, paints it at the Legend. }
Procedure TChartSeries.DrawLegend(ValueIndex:Integer; Const Rect:TRect);
Var tmpBack  : TColor;
    OldStyle : TBrushStyle;
    tmpStyle : TBrushStyle;
    tmpColor : TColor;
    OldStyleChanged,
    Old      : Boolean;
Begin
  if (ValueIndex<>-1) or (not ColorEachPoint) then
  begin
    Old:=FParent.AutoRepaint;
    FParent.AutoRepaint:=False;

    { set brush color }
    if ValueIndex=-1 then tmpColor:=SeriesColor
                     else tmpColor:=LegendItemColor(ValueIndex);

    FParent.Canvas.Brush.Color:=tmpColor;

    { if not empty brush... }
    if tmpColor<>clNone then
    begin
      { set background color and style }
      tmpBack:=FParent.LegendColor;
      tmpStyle:=Self.Brush.Style;

      // By default, set current Series.Pen
      FParent.Canvas.AssignVisiblePen(Pen);

      // Give Series opportunity to change pen & brush
      PrepareLegendCanvas(ValueIndex,tmpBack,tmpStyle);

      // After calling PrepareLegendCanvas, set custom symbol pen, if any...
      if Assigned(FParent.LegendPen) then
         FParent.Canvas.AssignVisiblePen(FParent.LegendPen);

      { if back color is "default", use Legend back color }
      if tmpBack=clTeeColor then
      begin
        tmpBack:=FParent.LegendColor;
        if tmpBack=clTeeColor then tmpBack:=FParent.Color;
      end;

      OldStyleChanged:=False;
      OldStyle:=bsSolid;

      { if brush has no bitmap, set brush style }
      With Self.Brush do
      if Style<>tmpStyle then
      begin
        if (not Assigned(Bitmap)) or Bitmap.Empty then { 5.01 }
        begin
          OldStyle:=Style;
          OldStyleChanged:=True;
          Style:=tmpStyle;
        end;
      end;

      { final setting }
      With FParent do SetBrushCanvas(Canvas.Brush.Color,Self.Brush,tmpBack);

      { draw shape }
      DrawLegendShape(ValueIndex,Rect);

      if OldStyleChanged then Self.Brush.Style:=OldStyle;
    end;

    FParent.AutoRepaint:=Old;
  end;
End;

Procedure TChartSeries.PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                            Var BrushStyle:TBrushStyle);
begin { abstract }
end;

{ Calculates the correct "Z" order for the series }
Procedure TChartSeries.CalcZOrder;
Begin
  if FZOrder=TeeAutoZOrder then
  begin
    if FParent.View3D then
    begin
      Inc(FParent.FMaxZOrder);
      IZOrder:=FParent.FMaxZOrder;
    end
    else IZOrder:=0;
  end
  else FParent.FMaxZOrder:=Math.Max(FParent.FMaxZOrder,ZOrder);
End;

Function TChartSeries.CalcXPosValue(Const Value:Double):Integer;
Begin
  result:=GetHorizAxis.CalcXPosValue(Value);
end;

{ Returns the axis value for a given horizontal ScreenPos pixel position }
Function TChartSeries.XScreenToValue(ScreenPos:Integer):Double;
Begin
  result:=GetHorizAxis.CalcPosPoint(ScreenPos);
end;

Function TChartSeries.CalcXSizeValue(Const Value:Double):Integer;
Begin
  result:=GetHorizAxis.CalcSizeValue(Value);
end;

Function TChartSeries.CalcYPosValue(Const Value:Double):Integer;
Begin
  result:=GetVertAxis.CalcYPosValue(Value);
end;

Function TChartSeries.CalcPosValue(Const Value:Double):Integer;
Begin
  if YMandatory then result:=CalcYPosValue(Value)
                else result:=CalcXPosValue(Value);
end;

Function TChartSeries.XValueToText(Const AValue:Double):String;
Begin
  result:=GetHorizAxis.LabelValue(AValue);
end;

Function TChartSeries.YValueToText(Const AValue:Double):String;
begin
  result:=GetVertAxis.LabelValue(AValue);
end;

{ Returns the axis value for a given vertical ScreenPos pixel position }
Function TChartSeries.YScreenToValue(ScreenPos:Integer):Double;
Begin
  result:=GetVertAxis.CalcPosPoint(ScreenPos);
end;

Function TChartSeries.CalcYSizeValue(Const Value:Double):Integer;
Begin
  result:=GetVertAxis.CalcSizeValue(Value);
end;

Function TChartSeries.CalcXPos(ValueIndex:Integer):Integer;
Begin
  result:=GetHorizAxis.CalcXPosValue(XValues.Value[ValueIndex]);
end;

Function TChartSeries.CalcYPos(ValueIndex:Integer):Integer;
begin
  result:=GetVertAxis.CalcYPosValue(YValues.Value[ValueIndex]);
end;

{ Removes a point in the series }
Procedure TChartSeries.Delete(ValueIndex:Integer);
Var t : Integer;
Begin
  if ValueIndex<Count then
  begin
    { Values }
    for t:=0 to FValuesList.Count-1 do
        FValuesList[t].Delete(ValueIndex);

    { Color }
    if Assigned(FColors) and (FColors.Count>ValueIndex) then
       FColors.Delete(ValueIndex);

    { Label }
    if Labels.Count>ValueIndex then
       Labels.DeleteLabel(ValueIndex);

    { Marks Position and Item }
    With FMarks do
    begin
      if FPositions.Count>ValueIndex then
         FPositions.Delete(ValueIndex);

      if FItems.Count>ValueIndex then
         FItems.Delete(ValueIndex);
    end;

    { notify deletion }
    NotifyValue(veDelete,ValueIndex);

    { Repaint chart }
    if FActive then Repaint;
  end
  else Raise ChartException.CreateFmt(TeeMsg_SeriesDelete,[ValueIndex,Count-1]);
end;

Procedure TChartSeries.Delete(Start,Quantity:Integer);
var t : Integer;
begin
  if Start<Count then
  begin
    {$IFDEF TEEARRAY}
    { Values }
    for t:=0 to ValuesList.Count-1 do ValuesList[t].Delete(Start,Quantity);

    { Color }
    if Assigned(FColors) then
    begin
      if FColors.Count>Start then
         for t:=Start to Start+Quantity-1 do
             FColors.Delete(Start);
      if FColors.Count=0 then FreeAndNil(FColors);
    end;

    { Label }
    if FLabels.Count>Start then
      for t:=Start to Start+Quantity-1 do
          Labels.DeleteLabel(Start);

    { Marks.Position }
    With FMarks.FPositions do
    if Count>Start then
      for t:=Start to Start+Quantity-1 do
       Delete(Start);

    { notify deletion }
    NotifyValue(veDelete,-1);
    { Repaint chart }
    if Active then Repaint;

    {$ELSE}
    for t:=1 to Quantity do Delete(Start);
    {$ENDIF}
  end;
end;

{ Exchanges one point with another.
  Also the point color and point label, with safe checking. }
procedure TChartSeries.SwapValueIndex(a,b:Integer);
var t : Integer;
begin
  for t:=0 to FValuesList.Count-1 do
      FValuesList[t].{$IFNDEF TEEARRAY}FList.{$ENDIF}Exchange(a,b);
  if Assigned(FColors) then FColors.Exchange(a,b);
  if FLabels.Count>0 then FLabels.Exchange(a,b); // 5.01
end;

procedure TChartSeries.SetMarks(Value:TSeriesMarks);
begin
  FMarks.Assign(Value);
end;

Procedure TChartSeries.SetSeriesColor(AColor:TColor);
Begin
  SetColorProperty(FColor,AColor);
  if Assigned(ParentChart) then ParentChart.BroadcastSeriesEvent(Self,seChangeColor);
  RepaintDesigner;
end;

Function TChartSeries.MaxXValue:Double;
Begin
  result:=FX.MaxValue;
end;

Function TChartSeries.MaxYValue:Double;
Begin
  result:=FY.MaxValue;
end;

Function TChartSeries.MinXValue:Double;
Begin
  result:=FX.MinValue;
end;

Function TChartSeries.MinYValue:Double;
Begin
  result:=FY.MinValue;
end;

Function TChartSeries.MaxZValue:Double;
begin
  result:=ZOrder;
end;

Function TChartSeries.MinZValue:Double;
begin
  result:=ZOrder;
end;

{ Returns the length in pixels of the longest visible Mark text }
Function TChartSeries.MaxMarkWidth:Integer;
var t : Integer;
Begin
  result:=0;
  for t:=0 to Count-1 do
  if Marks.MarkItem(t).Visible then
     result:=Math.Max(result,Marks.TextWidth(t));
end;

Procedure TChartSeries.AddLinkedSeries(ASeries:TChartSeries);
Begin
  if FLinkedSeries.IndexOf(ASeries)=-1 then FLinkedSeries.Add(ASeries);
end;

Procedure TChartSeries.RemoveDataSource(Value:TComponent);
begin
  DataSources.Remove(Value);
  CheckDataSource;
end;

Procedure TChartSeries.SetNull(ValueIndex:Integer; Null:Boolean=True); // 6.0
begin
  if Null then
     ValueColor[ValueIndex]:=clNone   // set point to null
  else
     ValueColor[ValueIndex]:=clTeeColor; // back to default (non-null) color
end;

Procedure TChartSeries.RemoveLinkedSeries(ASeries:TChartSeries);
Begin
  if Assigned(FLinkedSeries) then FLinkedSeries.Remove(ASeries);
end;

Procedure TChartSeries.BeginUpdate;
begin
  Inc(IUpdating);
end;

Procedure TChartSeries.EndUpdate;
begin
  if IUpdating>0 then
  begin
    Dec(IUpdating);
    if IUpdating=0 then RefreshSeries;
  end;
end;

{ This method is called whenever the series points are added,
  deleted, modified, etc. }
Procedure TChartSeries.NotifyValue(ValueEvent:TValueEvent; ValueIndex:Integer);
var t : Integer;
Begin
  if (IUpdating=0) and Assigned(FLinkedSeries) then
    for t:=0 to FLinkedSeries.Count-1 do
    With FLinkedSeries[t] do
    Case ValueEvent of
      veClear  : if rOnClear in FRecalcOptions then Clear;
      veDelete : if rOnDelete in FRecalcOptions then
                    if FunctionType=nil then DeletedValue(Self,ValueIndex);
      veAdd    : if rOnInsert in FRecalcOptions then
                    if FunctionType=nil then AddedValue(Self,ValueIndex);
      veModify : if rOnModify in FRecalcOptions then AddValues(Self);
      veRefresh: AddValues(Self);
    end;
end;

Function TChartSeries.UseAxis:Boolean;
begin
  result:=True;
end;

Procedure TChartSeries.Loaded;
var t : Integer;
begin
  inherited;
  { when the DataSource has multiple Series, load them... }
  if Assigned(FTempDataSources) then
  begin
    if FTempDataSources.Count>0 then
    begin
      DataSources.Clear;
      for t:=0 to FTempDataSources.Count-1 do
          InternalAddDataSource( Owner.FindComponent(FTempDataSources[t]) );
    end;
    FTempDataSources.Free;
  end;

  { finally, gather points from datasource after loading }
  CheckDatasource;
end;

Procedure TChartSeries.SetCustomHorizAxis(Value:TChartAxis);
begin
  FCustomHorizAxis:=Value;
  if Assigned(Value) then FHorizAxis:=aCustomHorizAxis
                     else FHorizAxis:=aBottomAxis;
  RecalcGetAxis;
  Repaint;
end;

Function TChartSeries.GetZOrder:Integer;
begin
  if FZOrder=TeeAutoZOrder then result:=IZOrder
                           else result:=FZOrder;
end;

Procedure TChartSeries.SetZOrder(Value:Integer);
begin
  SetIntegerProperty(FZOrder,Value);
  if FZOrder=TeeAutoZOrder then IZOrder:=0 else IZOrder:=FZOrder;
end;

Procedure TChartSeries.SetCustomVertAxis(Value:TChartAxis);
begin
  FCustomVertAxis:=Value;
  if Assigned(Value) then FVertAxis:=aCustomVertAxis
                     else FVertAxis:=aLeftAxis;
  RecalcGetAxis;
  Repaint;
end;

class procedure TChartSeries.CreateSubGallery(AddSubChart: TChartSubGalleryProc);
begin
  AddSubChart(TeeMsg_Normal);
end;

class procedure TChartSeries.SetSubGallery(ASeries: TChartSeries;
  Index: Integer);
begin
end;

procedure TChartSeries.SetDepth(const Value: Integer);
begin
  SetIntegerProperty(FDepth,Value);
end;

{ Tells the series to swap X and Y values }
procedure TChartSeries.SetHorizontal;
begin
  MandatoryValueList:=XValues;
  NotMandatoryValueList:=YValues;
  YMandatory:=False;
end;

function TChartSeries.CompareLabelIndex(a, b: Integer): Integer;
var tmpA : String;
    tmpB : String;
begin
  tmpA:=Labels[a];
  tmpB:=Labels[b];
  if tmpA<tmpB then result:=-1 else
  if tmpA>tmpB then result:= 1 else result:= 0;
  if ILabelOrder=loDescending then result:=-result;
end;

function TChartSeries.GetXLabel(Index: Integer): String;
begin
  result:=Labels[Index];
end;

procedure TChartSeries.SetXLabel(Index: Integer; const Value: String);
begin
  Labels[Index]:=Value;
end;

{ TChartSeriesList }
procedure TChartSeriesList.Put(Index:Integer; Value:TChartSeries);
begin
  inherited Items[Index]:=Value;
end;

function TChartSeriesList.Get(Index:Integer):TChartSeries;
begin
  result:=TChartSeries(List^[Index]);
end;

{ TChartAxes }
procedure TChartAxes.Clear;
begin
  While Count>0 do Items[0].Free;
  inherited;
end;

function TChartAxes.Get(Index:Integer):TChartAxis;
begin
  result:=TChartAxis(List^[Index]);
end;

function TChartAxes.GetDepthAxis:TChartDepthAxis;
begin
  result:=FChart.DepthAxis;
end;

function TChartAxes.GetLeftAxis:TChartAxis;
begin
  result:=FChart.LeftAxis;
end;

function TChartAxes.GetTopAxis:TChartAxis;
begin
  result:=FChart.TopAxis;
end;

function TChartAxes.GetRightAxis:TChartAxis;
begin
  result:=FChart.RightAxis;
end;

function TChartAxes.GetBottomAxis:TChartAxis;
begin
  result:=FChart.BottomAxis;
end;

procedure TChartAxes.SetFastCalc(const Value: Boolean);
var t: Integer;
begin
  IFastCalc:=Value;
  for t:=0 to Count-1 do Items[t].SetCalcPosValue;
end;

function TChartAxes.GetBehind: Boolean;
begin
  result:=FChart.AxisBehind;
end;

function TChartAxes.GetVisible: Boolean;
begin
  result:=FChart.AxisVisible;
end;

procedure TChartAxes.SetBehind(const Value: Boolean);
begin
  FChart.AxisBehind:=Value;
end;

procedure TChartAxes.SetVisible(const Value: Boolean);
begin
  FChart.AxisVisible:=Value;
end;

{ TChartCustomAxes }
function TChartCustomAxes.Get(Index: Integer):TChartAxis;
begin
  result:=TChartAxis(inherited Items[Index]);
end;

procedure TChartCustomAxes.Put(Index:Integer; Const Value:TChartAxis);
begin
  Items[Index].Assign(Value);
end;

{ TTeeCustomDesigner }
Procedure TTeeCustomDesigner.Refresh;
begin
end;

Procedure TTeeCustomDesigner.Repaint;
begin
end;

{ TTeeCustomTool }
procedure TTeeCustomTool.ChartEvent(AEvent: TChartToolEvent);
begin
end;

Procedure TTeeCustomTool.ChartMouseEvent(AEvent: TChartMouseEvent;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

class function TTeeCustomTool.Description: String;
begin
  result:='';
end;

procedure TTeeCustomTool.SetParentChart(const Value: TCustomAxisPanel);
begin
  if Assigned(ParentChart) then
  begin
    ParentChart.Tools.Remove(Self);
    if not Assigned(Value) then ParentChart.Repaint;
  end;
  inherited;
  if Assigned(ParentChart) then
     TList(ParentChart.Tools).Add(Self);
end;

{ TChartTools }
Function TChartTools.Add(Tool:TTeeCustomTool):TTeeCustomTool;
begin
  Tool.ParentChart:=Owner;
  result:=Tool;
end;

procedure TChartTools.Clear;
begin
  While Count>0 do Items[0].Free;
  inherited;
end;

function TChartTools.Get(Index: Integer): TTeeCustomTool;
begin
  result:=TTeeCustomTool(List^[Index]);
end;

{ TTeeCustomToolSeries }
class function TTeeCustomToolSeries.GetEditorClass: String;
begin
  result:='TSeriesToolEditor';
end;

Function TTeeCustomToolSeries.GetHorizAxis:TChartAxis;
begin
  if Assigned(FSeries) then result:=FSeries.GetHorizAxis
                       else result:=ParentChart.BottomAxis;
end;

Function TTeeCustomToolSeries.GetVertAxis:TChartAxis;
begin
  if Assigned(FSeries) then result:=FSeries.GetVertAxis
                       else result:=ParentChart.LeftAxis;
end;

procedure TTeeCustomToolSeries.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and Assigned(FSeries) and (AComponent=FSeries) then
     Series:=nil;
end;

procedure TTeeCustomToolSeries.SetSeries(const Value: TChartSeries);
begin
  if FSeries<>Value then
  begin
    {$IFDEF D5}
    if Assigned(FSeries) then FSeries.RemoveFreeNotification(Self);
    {$ENDIF}
    FSeries:=Value;
    if Assigned(FSeries) then FSeries.FreeNotification(Self);
  end;
end;

{ TTeeCustomToolAxis }
procedure TTeeCustomToolAxis.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('AxisID',ReadAxis,WriteAxis,Assigned(Axis));
end;

class function TTeeCustomToolAxis.GetEditorClass: String;
begin
  result:='TAxisToolEditor';
end;

procedure TTeeCustomToolAxis.ReadAxis(Reader: TReader);
begin
  Axis:=ParentChart.Axes[Reader.ReadInteger];
end;

procedure TTeeCustomToolAxis.SetAxis(const Value: TChartAxis);
begin
  if FAxis<>Value then
  begin
    FAxis:=Value;
    if Assigned(FAxis) then ParentChart:=FAxis.ParentChart
                       else ParentChart:=nil;
    Repaint;
  end;
end;

procedure TTeeCustomToolAxis.WriteAxis(Writer: TWriter);
begin
  Writer.WriteInteger(ParentChart.Axes.IndexOf(Axis));
end;

{ TCustomAxisPanel }
Constructor TCustomAxisPanel.Create(AOwner: TComponent);
begin
  inherited;
  AutoRepaint :=False;

  FTools:=TChartTools.Create;
  FTools.Owner:=Self;

  FAxisBehind:=True;
  FAxisVisible:=True;

  FSeriesList:=TChartSeriesList.Create;
  FSeriesList.FOwner:=Self;
  FView3DWalls:=True;

  FClipPoints:=True;

  { create FIRST the collections... }
  FAxes:=TChartAxes.Create;
  FAxes.FChart:=Self;

  FCustomAxes:=TChartCustomAxes.Create(Self,TChartAxis);

  { Create axes... }
  FBottomAxis:=TChartAxis.Create(FCustomAxes);
  with FBottomAxis do
  begin
    FHorizontal:=True;
    SetCalcPosValue;
  end;

  FTopAxis:=TChartAxis.Create(FCustomAxes);
  With FTopAxis do
  begin
    FHorizontal:=True;
    FOtherSide:=True;
    FZPosition:=100; { 100% }
    SetCalcPosValue;
    FGrid.FZ:=100;
    FGrid.IDefaultZ:=100;
  end;

  FLeftAxis:=TChartAxis.Create(FCustomAxes);
  With FLeftAxis.FAxisTitle do
  begin
    FAngle:=90;
    IDefaultAngle:=90;
  end;

  FRightAxis:=TChartAxis.Create(FCustomAxes);
  With FRightAxis do
  begin
    FAxisTitle.FAngle:=270;
    FAxisTitle.IDefaultAngle:=270;
    FOtherSide:=True;
    FZPosition:=100; { 100% }
    FGrid.FZ:=100;
    FGrid.IDefaultZ:=100;
  end;

  FDepthAxis:=TChartDepthAxis.Create(FCustomAxes);
  With FDepthAxis do
  begin
    FVisible:=False;
    IDepthAxis:=True;
    SetCalcPosValue;
    FOtherSide:=True;
  end;

  { Paging default values }
  FPage:=1;
  FScaleLastPage:=True;
  AutoRepaint :=True;
end;

Destructor TCustomAxisPanel.Destroy;
Begin
  FreeAllSeries;
  FAxes.Free;
  FCustomAxes.Free;
  FSeriesList.Free;
  Designer.Free;
  FTools.Free;
  inherited;
end;

procedure TCustomAxisPanel.BroadcastTeeEventClass(Event: TTeeEventClass);
begin
  BroadcastTeeEvent(Event.Create).Free;
end;

{ Changes the current page to Value }
Procedure TCustomAxisPanel.SetPage(Value:Integer);
var tmp : Integer;
Begin
  { Allow "Page" to be into: >= 1 , <= NumPages }
  tmp:=NumPages;
  if Value>tmp then Value:=tmp;
  if Value<1 then Value:=1;
  if FPage<>Value then
  begin
    SetIntegerProperty(FPage,Value);
    BroadcastTeeEventClass(TChartChangePage);
    { Trigged "changed page" event }
    if Assigned(FOnPageChange) then FOnPageChange(Self);
  end;
end;

Procedure TCustomAxisPanel.SetScaleLastPage(Value:Boolean);
Begin
  SetBooleanProperty(FScaleLastPage,Value);
End;

{ Returns the number of series that are Active (visible). }
Function TCustomAxisPanel.CountActiveSeries:Integer;
var t : Integer;
Begin
  result:=0;
  for t:=0 to SeriesCount-1 do if SeriesList[t].Active then Inc(result);
end;

{ Calculates the number of pages. This only applies
  when the MaxPointsPerPage property is used.
  If it is not used (is zero), then returns 1 (one page only).
}
Function TCustomAxisPanel.NumPages:Integer;

  Function CalcNumPages(AAxis:TChartAxis):Integer;
  var tmp       : Integer;
      t         : Integer;
      FirstTime : Boolean;
  Begin
    { By default, one single page }
    result:=1;
    { Calc max number of points for all active series
      associated to "AAxis" axis }
    tmp:=0;
    FirstTime:=True;
    for t:=0 to SeriesCount-1 do
    With Series[t] do
    if FActive and AssociatedToAxis(AAxis) then
       if FirstTime or (Count>tmp) then
       begin
         tmp:=Count;
         FirstTime:=False;
       end;

    { If there are points... divide into pages... }
    if tmp>0 then
    Begin
      result:=tmp div FMaxPointsPerPage;
      { extra page for remaining points... }
      if (tmp mod FMaxPointsPerPage)>0 then Inc(result);
    end;
  end;

Begin
  if (FMaxPointsPerPage>0) and (SeriesCount>0) then
  begin
    if Series[0].YMandatory then
       result:=Math.Max(CalcNumPages(FTopAxis),CalcNumPages(FBottomAxis))
    else
       result:=Math.Max(CalcNumPages(FLeftAxis),CalcNumPages(FRightAxis));
  end
  else result:=1;
End;

{ Sends pages to the printer. This only applies when the
  Chart has more than one page (MaxPointsPerPage property).
  If no parameters are passed, all pages are printed.
  If only one page exists, then it's printed. }
procedure TCustomAxisPanel.PrintPages(FromPage, ToPage: Integer);
var tmpOld : Integer;
    t      : Integer;
    R      : TRect;
begin
  if Name<>'' then Printer.Title:=Name; { 5.01 }
  Printer.BeginDoc;
  try
    if ToPage=0 then ToPage:=NumPages;
    if FromPage=0 then FromPage:=1;
    tmpOld:=Page;
    try
      R:=ChartPrintRect;
      for t:=FromPage to ToPage do
      begin
        Page:=t;
        PrintPartial(R);
        if t<ToPage then Printer.NewPage;
      end;
    finally
      Page:=tmpOld;
    end;
    Printer.EndDoc;
  except
    on Exception do
    begin
      Printer.Abort;
      if Printer.Printing then Printer.EndDoc;
      Raise;
    end;
  end;
end;

Procedure TCustomAxisPanel.SetMaxPointsPerPage(Value:Integer);
var tmp : Integer;
Begin
  if Value<0 then Raise ChartException.Create(TeeMsg_MaxPointsPerPage)
             else
             begin
               SetIntegerProperty(FMaxPointsPerPage,Value);
               tmp:=NumPages;
               if FPage>tmp then Page:=tmp;
               BroadcastTeeEventClass(TChartChangePage);
             end;
end;

{ Destroys and removes all Series in Chart. The optional parameter
  defines a series class (for example: TLineSeries) to remove only
  the series of that class. }
Procedure TCustomAxisPanel.FreeAllSeries( SeriesClass:TChartSeriesClass=nil );
var t   : Integer;
    tmp : TCustomChartSeries;
begin
  t:=0;
  While t<SeriesCount do
  begin
    tmp:=Series[t];
    if (not Assigned(SeriesClass)) or (tmp is SeriesClass) then
    begin
      tmp.ParentChart:=nil;
      tmp.Free;
    end
    else Inc(t);
  end;
end;

{ Steps to determine if an axis is Visible:

  1) The global Chart.AxisVisible property is True... and...
  2) The Axis Visible property is True... and...
  3) At least there is a Series Active and associated to the axis and
     the Series has the "UseAxis" property True.
}
Function TCustomAxisPanel.IsAxisVisible(Axis:TChartAxis):Boolean;
var t : Integer;
Begin
  result:=FAxisVisible and Axis.FVisible;
  if result then { if still visible... }
     if Axis.IsDepthAxis then result:=View3D
     else
     for t:=0 to SeriesCount-1 do
       With Series[t] do
       if FActive then
         if UseAxis then
         begin
           result:=AssociatedToAxis(Axis);
           if result then exit;
         end
         else
         begin
           result:=False;
           exit;
         end;
end;

{ This function returns the longest width in pixels for a given "S" string.
  It also considers multi-line strings, returning in the NumLines
  parameter the count of lines. }
Function TCustomAxisPanel.MultiLineTextWidth(S:String; Var NumLines:Integer):Integer;

  Procedure CalcString(Const St:String);
  begin
    result:=Math.Max(result,Canvas.TextWidth(St));
    Inc(NumLines);
  end;

var i : Integer;
begin
  result:=0;
  NumLines:=0;
  i:=AnsiPos(TeeLineSeparator,s);
  While i>0 do
  begin
    CalcString(Copy(s,1,i-1));
    Delete(s,1,i);
    i:=AnsiPos(TeeLineSeparator,s);
  end;
  if s<>'' then CalcString(s);
end;

{ Returns if no series are active (visible) and associated to
  the Axis parameter }
Function TCustomAxisPanel.NoActiveSeries(AAxis:TChartAxis):Boolean;
var t : Integer;
begin
  for t:=0 to SeriesCount-1 do
  With Series[t] do
  if Active and AssociatedToAxis(AAxis) then
  begin
    result:=False;
    Exit;
  end;
  result:=True;
end;

{ Calculates the minimum or maximum for the Axis parameter.
  This function is used internally. }
Function TCustomAxisPanel.InternalMinMax(AAxis:TChartAxis; IsMin,IsX:Boolean):Double;
var t             : Integer;
    tmpCount      : Integer;
    FirstTime     : Boolean;
    tmpPagingAxis : Boolean;
    tmp           : Double;
    tmpSeries     : TChartSeries;
    tmpFirstPoint : Integer;
    tmpLastPoint  : Integer;
    tmpNumPoints  : Integer;
    tt            : Integer;
    tmpList       : TChartValueList;
Begin
  if AAxis.IsDepthAxis then
  begin
    if AAxis.CalcLabelStyle=talValue then
    begin
      result:=0;
      FirstTime:=True;
      for tt:=0 to SeriesCount-1 do
      With Series[tt] do
      if Active then
      begin
        if IsMin then tmp:=MinZValue else tmp:=MaxZValue;
        if FirstTime or
          ( IsMin and (tmp<result) ) or
          ( (Not IsMin) and (tmp>result) ) then
        begin
          FirstTime:=False;
          result:=tmp;
        end;
      end;
    end
    else
    if IsMin then result:=-0.5 else result:=MaxZOrder+0.5;
  end
  else
  begin
    result:=0;
    tmpSeries:=GetAxisSeries(AAxis);
    if Assigned(tmpSeries) then
    begin
      if tmpSeries.YMandatory then tmpPagingAxis:=IsX
                              else tmpPagingAxis:=not IsX;
    end
    else tmpPagingAxis:=IsX;

    if (FMaxPointsPerPage>0) and tmpPagingAxis then
    Begin
      tmpSeries:=GetAxisSeriesMaxPoints(AAxis);

      if Assigned(tmpSeries) and (tmpSeries.Count>0) then
      Begin
        tmpCount:=tmpSeries.Count;

        tmpFirstPoint:=(FPage-1)*FMaxPointsPerPage;
        if tmpCount<=tmpFirstPoint then
           tmpFirstPoint:=Math.Max(0,(tmpCount div FMaxPointsPerPage)-1)*FMaxPointsPerPage;

        tmpLastPoint:=tmpFirstPoint+FMaxPointsPerPage-1;
        if tmpCount<=tmpLastPoint then
           tmpLastPoint:=tmpFirstPoint+(tmpCount mod FMaxPointsPerPage)-1;

        if IsX then tmpList:=tmpSeries.XValues
               else tmpList:=tmpSeries.YValues;

        if IsMin then result:=tmpList.Value[tmpFirstPoint]
        else
        Begin
          result:=tmpList.Value[tmpLastPoint];
          if not FScaleLastPage then
          begin
            tmpNumPoints:=tmpLastPoint-tmpFirstPoint+1;
            if tmpNumPoints<FMaxPointsPerPage then
            begin
              tmp:=tmpList.Value[tmpFirstPoint];
              result:=tmp+FMaxPointsPerPage*(result-tmp)/tmpNumPoints;
            end;
          end;
        end;
      end;
    end
    else
    begin
      FirstTime:=True;
      for t:=0 to SeriesCount-1 do
      With Series[t] do
      if (FActive or NoActiveSeries(AAxis)) and (Count>0) then
      Begin
        if (      IsX  and ((HorizAxis=aBothHorizAxis) or (GetHorizAxis=AAxis)) ) or
           ( (Not IsX) and ((VertAxis=aBothVertAxis) or (GetVertAxis =AAxis)) )  then
        Begin
          if IsMin then
             if IsX then tmp:=MinXValue else tmp:=MinYValue
          else
             if IsX then tmp:=MaxXValue else tmp:=MaxYValue;
          if FirstTime or
           ( IsMin and (tmp<result) ) or
           ( (Not IsMin) and (tmp>result) ) then
          Begin
            result:=tmp;
            FirstTime:=False;
          end;
        end;
      end;
    end;
  end;
end;

{ Calculate the Maximum value of horizontal (X) Axis }
Function TCustomAxisPanel.MaxXValue(AAxis:TChartAxis):Double;
Begin
  result:=InternalMinMax(AAxis,False,True);
end;

{ Calculate the Maximum value of vertical (Y) Axis }
Function TCustomAxisPanel.MaxYValue(AAxis:TChartAxis):Double;
Begin
  result:=InternalMinMax(AAxis,False,False);
end;

{ Calculate the Minimum value of horizontal (X) Axis }
Function TCustomAxisPanel.MinXValue(AAxis:TChartAxis):Double;
Begin
  result:=InternalMinMax(AAxis,True,True);
end;

{ Calculate the Minimum value of vertical (Y) Axis }
Function TCustomAxisPanel.MinYValue(AAxis:TChartAxis):Double;
Begin
  result:=InternalMinMax(AAxis,True,False);
end;

{ When the Legend style is "series", returns the series that
  corresponds to the Legend "ItemIndex" position.
  The "OnlyActive" parameter, when False takes into account all series,
  regardless if they are visible (active) or not. }
Function TCustomAxisPanel.SeriesLegend(ItemIndex:Integer; OnlyActive:Boolean):TChartSeries;
var t   : Integer;
    tmp : Integer;
begin
  tmp:=0;
  for t:=0 to SeriesCount-1 do
  With Series[t] do
  if ShowInLegend and ((not OnlyActive) or Active) then
     if tmp=ItemIndex then
     begin
       result:=Series[t];
       exit;
     end
     else Inc(tmp);
  result:=nil;
end;

{ Returns the Active series (visible) that corresponds to the
  ItemIndex position in the Legend }
Function TCustomAxisPanel.ActiveSeriesLegend(ItemIndex:Integer):TChartSeries;
begin
  result:=SeriesLegend(ItemIndex,True);
end;

{ Returns the string corresponding to the SeriesIndex th series for Legend }
Function TCustomAxisPanel.SeriesTitleLegend(SeriesIndex:Integer; OnlyActive:Boolean):String;
var tmpSeries : TChartSeries;
Begin
  if OnlyActive then tmpSeries:=ActiveSeriesLegend(SeriesIndex)
                else tmpSeries:=SeriesLegend(SeriesIndex,False);
  if Assigned(tmpSeries) then result:=SeriesTitleOrName(tmpSeries)
                         else result:='';
end;

{ Returns the width in pixels for the longest "Label" of all series,
  regardless if the series is active (visible) or not. }
Function TCustomAxisPanel.MaxTextWidth:Integer;
var t  : Integer;
    tt : Integer;
    tmp: Integer;
Begin
  result:=0;
  for t:=0 to SeriesCount-1 do
  With Series[t] do
       for tt:=0 to Labels.Count-1 do
           result:=Math.Max(result,MultiLineTextWidth(Labels[tt],tmp));
end;

{ Returns the longest width in pixels for all the active (visible)
  series marks. }
Function TCustomAxisPanel.MaxMarkWidth:Integer;
var t : Integer;
Begin
  result:=0;
  for t:=0 to SeriesCount-1 do
  With Series[t] do
       if Active then
          result:=Math.Max(result,MaxMarkWidth);
end;

{ Return the Index th series in SeriesList }
Function TCustomAxisPanel.GetSeries(Index:Integer):TChartSeries;
Begin
  result:=FSeriesList.List^[Index];
end;

type TView3DAccess=class(TView3DOptions);

{ Calculates internal parameters for the series Width and Height
  in 3D mode. }
Procedure TCustomAxisPanel.CalcSize3DWalls;
var tmpNumSeries : Integer;
    tmp          : Double;
Begin
  if View3D then
  Begin
    tmp:=0.001*Chart3DPercent;
    if not View3DOptions.Orthogonal then tmp:=tmp*2;
    FSeriesWidth3D :=Round(tmp*ChartWidth);

    tmp:=TView3DAccess(View3DOptions).CalcOrthoRatio;
    if tmp>1 then FSeriesWidth3D:=Round(FSeriesWidth3D/tmp);

    FSeriesHeight3D:=Round(FSeriesWidth3D*tmp);
    if ApplyZOrder then tmpNumSeries:=Math.Max(1,MaxZOrder+1)
                   else tmpNumSeries:=1;
    Height3D:=FSeriesHeight3D * tmpNumSeries;
    Width3D :=FSeriesWidth3D  * tmpNumSeries;
  end
  else
  begin
    FSeriesWidth3D :=0;
    FSeriesHeight3D:=0;
    Width3D        :=0;
    Height3D       :=0;
  end;
end;

{ Returns the number of series in the chart }
Function TCustomAxisPanel.SeriesCount:Integer;
begin
  result:=FSeriesList.Count;
end;

{ Triggers an event for all "tools" }
Procedure TCustomAxisPanel.BroadcastToolEvent(AEvent:TChartToolEvent);
var t : Integer;
begin
  for t:=0 to Tools.Count-1 do
  With Tools[t] do
  if Active then ChartEvent(AEvent);
end;

Procedure TCustomAxisPanel.CalcInvertedRotation;
begin
  InvertedRotation:=False;
  if View3D then
    if View3DOptions.Orthogonal then
    begin
      if View3DOptions.OrthoAngle>90 then
         InvertedRotation:=True;
    end
    else
    begin
      if View3DOptions.Rotation<270 then
         InvertedRotation:=True;
    end;
end;

{ Main drawing method. Draws everything. }
Procedure TCustomAxisPanel.InternalDraw(Const UserRectangle:TRect);

  { Draw one single Series }
  Procedure DrawSeries(TheSeries:TChartSeries);
  Var ActiveRegion : Boolean;

    { Create a clipping 3D region (cube) and apply it to Canvas }
    Procedure ClipRegionCreate;
    var tmpR : TRect;
    Begin
      if CanClip then
      begin
        tmpR:=ChartRect;
        Inc(tmpR.Bottom);
        Canvas.ClipCube(tmpR,0,Width3D);
        ActiveRegion:=True;
      end;
    end;

    { Remove the clipping region }
    Procedure ClipRegionDone;
    Begin
      if ActiveRegion then
      begin
        Canvas.UnClipRectangle;
        ActiveRegion:=False;
      end;
    end;

    { Draw one single point (ValueIndex) for all Series }
    Procedure DrawAllSeriesValue(ValueIndex:Integer);

      { If the ASeries parameter has the same "Z" order than the current
        series, draw the point }
      Procedure TryDrawSeries(ASeries:TChartSeries);
      begin
        With ASeries do
         if FActive and (ZOrder=TheSeries.ZOrder) and (ValueIndex<Count) then
            DrawValue(ValueIndex)
      end;

    var t    : Integer;
        tmp1 : Integer;
        tmp2 : Integer;
    Begin
      tmp1:=SeriesList.IndexOf(TheSeries);
      tmp2:=SeriesCount-1;
      if ValueIndex<TheSeries.Count then
      begin
        if TheSeries.DrawSeriesForward(ValueIndex) then
           for t:=tmp1 to tmp2 do TryDrawSeries(Series[t])
        else
           for t:=tmp2 downto tmp1 do TryDrawSeries(Series[t])
      end
      else for t:=tmp1 to tmp2 do TryDrawSeries(Series[t])
    end;

    { Draw the "Marks" of the ASeries }
    Procedure DrawMarksSeries(ASeries:TChartSeries);
    begin
      if ASeries.Count>0 then
      With ASeries,FMarks do
      if Visible then
      Begin
        if FClip then ClipRegionCreate;
        DrawMarks;
        if FClip then ClipRegionDone;
      end;
    end;

  Var t        : Integer;
      tmpFirst : Integer;
      tmpLast  : Integer;
  Begin
    ActiveRegion:=False;  { <-- VERY IMPORTANT !!!! }

    With TheSeries do
    if View3D and MoreSameZOrder then
    Begin
      if FirstInZOrder then
      Begin
        tmpFirst:=-1;
        tmpLast :=-1;
        for t:=SeriesList.IndexOf(TheSeries) to SeriesCount-1 do
        With Series[t] do
        if Active and (ZOrder=TheSeries.ZOrder) then
        Begin
          CalcFirstLastVisibleIndex;
          if FFirstVisibleIndex<>-1 then
          Begin
            if tmpFirst=-1 then tmpFirst:=FFirstVisibleIndex
                           else tmpFirst:=Math.Max(tmpFirst,FFirstVisibleIndex);
            if tmpLast=-1 then tmpLast:=FLastVisibleIndex
                          else tmpLast:=Math.Max(tmpLast,FLastVisibleIndex);
            DoBeforeDrawValues;
            if ClipPoints and (not ActiveRegion) then ClipRegionCreate;
          end;
        end;

        { values }
        if tmpFirst<>-1 then
          if DrawValuesForward then
             for t:=tmpFirst to tmpLast do DrawAllSeriesValue(t)
          else
             for t:=tmpLast downto tmpFirst do DrawAllSeriesValue(t);

        { Region }
        ClipRegionDone;

        { Marks and DoAfterDrawValues }
        for t:=SeriesList.IndexOf(TheSeries) to SeriesCount-1 do
        With Series[t] do
        if Active and (ZOrder=TheSeries.ZOrder) and (FFirstVisibleIndex<>-1) then
        begin
          DrawMarksSeries(Series[t]);
          DoAfterDrawValues;
        end;
      end;
    end
    else
    begin
      CalcFirstLastVisibleIndex;
      if FFirstVisibleIndex<>-1 then
      begin
        DoBeforeDrawValues;
        if UseAxis and ClipPoints then ClipRegionCreate;
        DrawAllValues;
        ClipRegionDone;
        DrawMarksSeries(TheSeries);
        DoAfterDrawValues;
      end;
    end;
  end;

  { Calculate the "Z" order for all Series }
  Procedure SetSeriesZOrder;
  Var tmpSeries : Integer;
      tmpOk     : Boolean;
  begin
    FMaxZOrder:=0;
    tmpOk:=ApplyZOrder and View3D;

    if tmpOk then
    Begin
      FMaxZOrder:=-1;
      for tmpSeries:=0 to SeriesCount-1 do
          With Series[tmpSeries] do if FActive then CalcZOrder;
    end;

    { invert Z Orders }
    if not DepthAxis.Inverted then   // 6.01
    for tmpSeries:=0 to SeriesCount-1 do
    With Series[tmpSeries] do
    if FActive then
       if tmpOk then IZOrder:=MaxZOrder-ZOrder else IZOrder:=0;
  end;

  { Calculate the Start, End and Middle "Z" coordinates for all Series }
  Procedure SetSeriesZPositions;
  Var tmpSeries : Integer;
  begin
    for tmpSeries:=0 to SeriesCount-1 do
    With Series[tmpSeries] do
    if Active then
    begin
      StartZ :=IZOrder*SeriesWidth3D;
      if Depth=-1 then EndZ:=StartZ+SeriesWidth3D
                  else EndZ:=StartZ+Depth;
      MiddleZ:=(StartZ+EndZ) div 2;
      FMarks.ZPosition:=MiddleZ;
    end;
  end;

  { Draw all Axes (normal and custom) }
  Procedure DrawAllAxis;
  var t       : Integer;
      tmpAxis : TChartAxis;
  Begin
    if AxisVisible then
    begin
      DoOnBeforeDrawAxes;

      With FAxes do
      for t:=0 to Count-1 do
      begin
        tmpAxis:=FAxes[t];
        if IsAxisVisible(tmpAxis) then tmpAxis.Draw(True);
      end;
    end;
  end;

  procedure CalcAxisRect;

    Procedure RecalcPositions;
    var tmp : Integer;
    begin
      with FAxes do
      for tmp:=0 to Count-1 do Get(tmp).InternalCalcPositions;
    end;

  var tmpR : TRect;
      OldR : TRect;
      tmp  : Integer;
  Begin
    with FAxes do
    for tmp:=0 to Count-1 do Get(tmp).AdjustMaxMin;

    RecalcPositions;

    tmpR:=ChartRect;
    with FAxes do
    for tmp:=0 to Count-1 do
      if IsAxisVisible(Get(tmp)) then
      Begin
        OldR:=tmpR;
        Get(tmp).CalcRect(OldR,tmp<5);  { <-- inflate only for first 4 axes }
        {$IFDEF CLX}
        if IntersectRect(OldR,OldR,tmpR) then
        {$ELSE}
        if Windows.IntersectRect(OldR,tmpR,OldR) then
        {$ENDIF}
           tmpR:=OldR;
      end;

    ChartRect:=tmpR;

    RecalcWidthHeight;

    RecalcPositions;
  end;

  // Calculate all axis offsets
  Procedure CalcSeriesRect;

    // Calculate one axis offsets, according to series margins
    Procedure CalcSeriesAxisRect(Axis:TChartAxis);
    Var tmpR      : TRect;
        a         : Integer;
        b         : Integer;
        tmpSeries : Integer;
    Begin
      tmpR:=TeeRect(0,0,0,0);

      for tmpSeries:=0 to SeriesCount-1 do
      With Series[tmpSeries] do
      if Active then
         if AssociatedToAxis(Axis) then
            if Axis.Horizontal then
            begin
              CalcHorizMargins(a,b);
              With tmpR do
              begin
                if Axis.AutomaticMinimum then Left :=Math.Max(Left,a);
                if Axis.AutomaticMaximum then Right:=Math.Max(Right,b);
              end;
            end
            else
            begin
              CalcVerticalMargins(a,b);
              With tmpR do
              begin
                if Axis.AutomaticMaximum then Top   :=Math.Max(Top,a);
                if Axis.AutomaticMinimum then Bottom:=Math.Max(Bottom,b);
              end;
            end;

      // Apply offsets in pixels
      if Axis.Horizontal then
      begin
        Inc(tmpR.Left,Axis.MinimumOffset);
        Inc(tmpR.Right,Axis.MaximumOffset);
      end
      else
      begin
        Inc(tmpR.Top,Axis.MaximumOffset);
        Inc(tmpR.Bottom,Axis.MinimumOffset);
      end;

      Axis.AdjustMaxMinRect(tmpR);
    end;

  var t : Integer;
  begin
    for t:=0 to Axes.Count-1 do CalcSeriesAxisRect(Axes[t]);
  end;

Var t   : Integer;
    tmp : TRect;
    Old : Boolean;
Begin
  Old:=AutoRepaint;
  AutoRepaint:=False;

  tmp:=UserRectangle;

  CalcInvertedRotation;

  PanelPaint(tmp);

  BroadcastToolEvent(cteBeforeDraw); // 5.02

  DoOnBeforeDrawChart;

  for t:=0 to SeriesCount-1 do
  With Series[t] do if Active then DoBeforeDrawChart;

  if not InternalCanvas.SupportsFullRotation then DrawTitlesAndLegend(True);

  SetSeriesZOrder;
  CalcWallsRect;
  CalcAxisRect;
  SetSeriesZPositions;
  CalcSeriesRect;

  InternalCanvas.Projection(Width3D,ChartBounds,ChartRect);

  if InternalCanvas.SupportsFullRotation then
  begin
    tmp:=ChartRect;
    ChartRect:=ChartBounds;
    DrawTitlesAndLegend(True);
    ChartRect:=tmp;
  end;

  DrawWalls;

  if AxisBehind then DrawAllAxis;

  BroadcastToolEvent(cteBeforeDrawSeries);

  DoOnBeforeDrawSeries;

  if DepthAxis.Inverted then  // 6.01
  begin
     for t:=SeriesCount-1 downto 0 do
         if Series[t].Active then DrawSeries(Series[t])
  end
  else
     for t:=0 to SeriesCount-1 do
         if Series[t].Active then DrawSeries(Series[t]);

  if not AxisBehind then DrawAllAxis;

  DrawTitlesAndLegend(False);

  if Zoom.Active then DrawZoomRectangle;

  BroadcastToolEvent(cteAfterDraw);

  Canvas.ResetState;
  DoOnAfterDraw;
  AutoRepaint:=Old;
end;

procedure TCustomAxisPanel.DoOnBeforeDrawAxes;
Begin
  if Assigned(FOnBeforeDrawAxes) then FOnBeforeDrawAxes(Self);
end;

procedure TCustomAxisPanel.DoOnBeforeDrawChart;
Begin
  if Assigned(FOnBeforeDrawChart) then FOnBeforeDrawChart(Self);
end;

procedure TCustomAxisPanel.DoOnBeforeDrawSeries;
Begin
  if Assigned(FOnBeforeDrawSeries) then FOnBeforeDrawSeries(Self);
end;

procedure TCustomAxisPanel.DoOnAfterDraw;
Begin
  if Assigned(FOnAfterDraw) then FOnAfterDraw(Self);
end;

procedure TCustomAxisPanel.SetView3DWalls(Value:Boolean);
Begin
  SetBooleanProperty(FView3DWalls,Value);
end;

{ Internal for VCL streaming mechanism.
  Stores all Series in the DFM. }
Procedure TCustomAxisPanel.GetChildren(Proc:TGetChildProc; Root:TComponent);
var t : Integer;
begin
  inherited;
  for t:=0 to SeriesCount-1 do
      if not Series[t].InternalUse then Proc(Series[t]);
end;

{ Abstract virtual }
procedure TCustomAxisPanel.RemovedDataSource( ASeries: TChartSeries;
                                              AComponent: TComponent );
begin
  if (AComponent is TTeeSeriesSource) and (AComponent=ASeries.DataSource) then
     TTeeSeriesSource(AComponent).Series:=nil;
end;

procedure TCustomAxisPanel.SetClipPoints(Value:Boolean);
Begin
  SetBooleanProperty(FClipPoints,Value);
end;

Procedure TCustomAxisPanel.SetCustomAxes(Value:TChartCustomAxes);
begin
  FCustomAxes.Assign(Value);
end;

procedure TCustomAxisPanel.SetLeftAxis(Value:TChartAxis);
begin
  FLeftAxis.Assign(Value);
end;

procedure TCustomAxisPanel.SetDepthAxis(Value:TChartDepthAxis);
begin
  FDepthAxis.Assign(Value);
end;

procedure TCustomAxisPanel.SetRightAxis(Value:TChartAxis);
begin
  FRightAxis.Assign(Value);
end;

procedure TCustomAxisPanel.SetTopAxis(Value:TChartAxis);
begin
  FTopAxis.Assign(Value);
end;

procedure TCustomAxisPanel.SetBottomAxis(Value:TChartAxis);
begin
  FBottomAxis.Assign(Value);
end;

{ Deletes (not destroys) a given Series.
  Triggers a "removed series" event and repaints }
Procedure TCustomAxisPanel.RemoveSeries(ASeries:TCustomChartSeries);
var t : Integer;
Begin
  t:=SeriesList.IndexOf(ASeries);
  if t<>-1 then
  begin
    BroadcastSeriesEvent(ASeries,seRemove);
    ASeries.Removed;
    FSeriesList.Delete(t);
    Invalidate;
  end;
end;

{ Returns the first series that is Active (visible) and
  associated to a given Axis. }
Function TCustomAxisPanel.GetAxisSeries(Axis:TChartAxis):TChartSeries;
Var t : Integer;
Begin
  for t:=0 to SeriesCount-1 do
  begin
    result:=Series[t];
    With result do
    if (FActive or NoActiveSeries(Axis) ) and
       AssociatedToAxis(Axis) then Exit;
  end;
  result:=nil;
end;

// Returns the series that is Active (visible) and
// associated to a given Axis, and has maximum number of points.
// This function is only used when calculating min and max for axis
// when MaxPointsPerPage is > 0.  (Paging is activated)
Function TCustomAxisPanel.GetAxisSeriesMaxPoints(Axis:TChartAxis):TChartSeries;
Var t   : Integer;
    tmp : Integer;
    tmpSeries : TChartSeries;
Begin
  result:=nil;
  tmp:=-1;
  for t:=0 to SeriesCount-1 do
  begin
    tmpSeries:=Series[t];
    With tmpSeries do
    if (FActive or NoActiveSeries(Axis) ) and
       AssociatedToAxis(Axis) then
       if tmpSeries.Count>tmp then
       begin
         tmp:=tmpSeries.Count;
         result:=tmpSeries;
       end;
  end;
end;

Function TCustomAxisPanel.FormattedValueLegend(ASeries:TChartSeries; ValueIndex:Integer):String;
begin { virtual, overrided at TChart }
  result:='';
end;

{ Returns a color from the "color palette" global array that is
  not used by any series. ( SeriesColor ) }
Function TCustomAxisPanel.GetFreeSeriesColor(CheckBackground:Boolean=True):TColor;
var t : Integer;
    l : Integer;
Begin
  t:=0;
  l:=High(ColorPalette);
  Repeat
    result:=GetDefaultColor(t);
    Inc(t);
  Until (t>l) or IsFreeSeriesColor(result,CheckBackground);
end;

Function TCustomAxisPanel.AddSeries(ASeries:TChartSeries):TChartSeries;
begin
  ASeries.ParentChart:=Self;
  result:=ASeries;
end;

function TCustomAxisPanel.AddSeries(
  ASeriesClass: TChartSeriesClass): TChartSeries;
begin
  result:=AddSeries(ASeriesClass.Create(Owner));
end;

{ internal. Calls CheckMouse for all visible Series. }
Function TCustomAxisPanel.CheckMouseSeries(x,y:Integer):Boolean;
var t : Integer;
begin
  result:=False;
  for t:=SeriesCount-1 downto 0 do
  With Series[t] do
  if Active then
  begin
    result:=CheckMouse(x,y);
    if result then break;
  end;
end;

{ Triggers an event specific to Series }
Procedure TCustomAxisPanel.BroadcastSeriesEvent(ASeries:TCustomChartSeries;
                                                Event:TChartSeriesEvent);
var tmp : TTeeSeriesEvent;
begin
  tmp:=TTeeSeriesEvent.Create;
  try
    tmp.Event:=Event;
    tmp.Series:=ASeries;
    BroadcastTeeEvent(tmp);
  finally
    tmp.Free;
  end;
end;

Procedure TCustomAxisPanel.InternalAddSeries(ASeries:TCustomChartSeries);
Begin
  if SeriesList.IndexOf(ASeries)=-1 then
  begin
    with ASeries do
    begin
      FParent:=Self;
      Added;
    end;
    FSeriesList.Add(ASeries);
    BroadcastSeriesEvent(ASeries,seAdd);
    Invalidate;
  end;
end;

{ Returns the number of points of the Active (visible) Series
  that has more points. }
Function TCustomAxisPanel.GetMaxValuesCount:Integer;
var t         : Integer;
    FirstTime : Boolean;
Begin
  result:=0;
  FirstTime:=True;
  for t:=0 to SeriesCount-1 do
  with Series[t] do
  if Active and ( FirstTime or (Count>result) ) then
  begin
    result:=Count;
    FirstTime:=False;
  end;
end;

Procedure TCustomAxisPanel.SetAxisBehind(Value:Boolean);
Begin
  SetBooleanProperty(FAxisBehind,Value);
end;

Procedure TCustomAxisPanel.SetAxisVisible(Value:Boolean);
Begin
  SetBooleanProperty(FAxisVisible,Value);
end;

{ Prevents a circular relationship between series and
  series DataSource. Raises an exception. }
Procedure TCustomAxisPanel.CheckOtherSeries(Dest,Source:TChartSeries);
var t : Integer;
Begin
  if Assigned(Source) then
  if Source.DataSource=Dest then
     Raise ChartException.Create(TeeMsg_CircularSeries)
  else
     if Source.DataSource is TChartSeries then
     for t:=0 to Source.DataSources.Count-1 do
        CheckOtherSeries(Dest,TChartSeries(Source.DataSources[t]));
end;

{ Returns True when the AComponent is a valid DataSource for the ASeries
  parameter. }
Function TCustomAxisPanel.IsValidDataSource(ASeries:TChartSeries; AComponent:TComponent):Boolean;
Begin
  result:=(ASeries<>AComponent) and
          (AComponent is TChartSeries) and
          ASeries.IsValidSeriesSource(TChartSeries(AComponent));

  { check virtual "data source" }
  if not result then
     if AComponent is TTeeSeriesSource then
        result:=TTeeSeriesSource(AComponent).Available(Self);
end;

{ When ASeries has a DataSource that is another Series,
  calls the AddValues method to add (copy) all the points from
  the DataSource to the ASeries. }
Procedure TCustomAxisPanel.CheckDatasource(ASeries:TChartSeries);
Begin
  With ASeries do
  if not (csLoading in ComponentState) then
  begin
     if Assigned(DataSource) then
     begin
       if DataSource is TChartSeries then
          AddValues(TChartSeries(DataSource))
       else
       if DataSource is TTeeSeriesSource then { 5.02 }
          TTeeSeriesSource(DataSource).Refresh;
     end
     else
     if Assigned(FunctionType) then
     begin
       if FunctionType.NoSourceRequired then
       begin
         BeginUpdate;  { before Clear }
         Clear;
         FunctionType.AddPoints(nil); { calculate function }
         EndUpdate; { propagate changes... }
       end;
     end
     else
     if not ManualData then
        if CanAddRandomPoints then
           FillSampleValues(NumSampleValues)
        //else
           //Clear;
  end;
end;

{ Swaps one series with another in the series list.
  Triggers a series event (swap event) and repaints. }
Procedure TCustomAxisPanel.ExchangeSeries(a,b:Integer);
var tmpIndex : Integer;
begin
  SeriesList.Exchange(a,b);
  tmpIndex:=Series[a].ComponentIndex;
  Series[a].ComponentIndex:=Series[b].ComponentIndex;
  Series[b].ComponentIndex:=tmpIndex;
  BroadcastSeriesEvent(nil,seSwap);
  Invalidate;
end;

Procedure TCustomAxisPanel.ExchangeSeries(a,b:TCustomChartSeries);
begin
  ExchangeSeries(SeriesList.IndexOf(a),SeriesList.IndexOf(b));
end;

{ Copies all settings from one chart to self. }
Procedure TCustomAxisPanel.Assign(Source:TPersistent);
begin
  if Source is TCustomAxisPanel then
  With TCustomAxisPanel(Source) do
  begin
    Self.FAxisBehind       := FAxisBehind;
    Self.FAxisVisible      := FAxisVisible;
    Self.BottomAxis        := FBottomAxis;
    Self.FClipPoints       := ClipPoints;
    Self.CustomAxes        := FCustomAxes;
    Self.LeftAxis          := FLeftAxis;
    Self.DepthAxis         := FDepthAxis;
    Self.FMaxPointsPerPage := FMaxPointsPerPage;
    Self.FPage             := FPage;
    Self.RightAxis         := FRightAxis;
    Self.FScaleLastPage    := FScaleLastPage;
    Self.TopAxis           := FTopAxis;
    Self.FView3DWalls      := FView3DWalls;
  end;
  inherited;
end;

function TCustomAxisPanel.IsCustomAxesStored: Boolean;
begin
  result:=FCustomAxes.Count>0;
end;

{ TTeeSeriesSource }

{ Base abstract class for Series "datasources" }
Constructor TTeeSeriesSource.Create(AOwner: TComponent);
begin
  inherited;
  FActive:=False;
end;

Destructor TTeeSeriesSource.Destroy;
begin
  Close;
  inherited;
end;

procedure TTeeSeriesSource.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and Assigned(FSeries) and (AComponent=FSeries) then
     Series:=nil;
end;

procedure TTeeSeriesSource.SetSeries(const Value: TChartSeries);
var Old : TChartSeries; 
begin
  if FSeries<>Value then
  begin
    {$IFNDEF TEEOCX}
    Close;
    if Assigned(FSeries) then
    begin
      {$IFDEF D5}
      FSeries.RemoveFreeNotification(Self);
      {$ENDIF}
    end;
    {$ENDIF}

    Old:=FSeries;

    FSeries:=Value;

    if Assigned(FSeries) then
    begin
      FSeries.FreeNotification(Self);
      FSeries.DataSource:=Self;
    end
    else
    if Assigned(Old) then
       Old.DataSource:=nil;

    {$IFDEF TEEOCX}
    Close;
    {$ENDIF}
  end;
end;

{ Load data into Series or Clear Series }
procedure TTeeSeriesSource.SetActive(const Value: Boolean);
begin
  if FActive<>Value then
  begin
    if Assigned(FSeries) then
    begin
      if Value then
      begin
        { if True, load points into Series }
        if not (csLoading in ComponentState) then Load;
      end
      else
      if (not (csDestroying in ComponentState)) and
         (not (csDestroying in FSeries.ComponentState)) then
              FSeries.Clear; { remove Series points }
    end;
    FActive:=Value;
  end;
end;

procedure TTeeSeriesSource.Close;
begin { set Active property to False }
  if (not (csLoading in ComponentState)) and
     (not (csDestroying in ComponentState)) then
           Active:=False;
end;

procedure TTeeSeriesSource.Open;
begin { set Active property to True }
  Active:=True;
end;

Procedure TTeeSeriesSource.Refresh;
begin { close and re-open the datasource }
  if Active and (not (csLoading in ComponentState)) then  // 6.0
     Load; { 5.02 }
end;

{ after loading from DFM, and if Active, load data }
Procedure TTeeSeriesSource.Loaded;
begin
  inherited;
  Refresh;
end;

{ return True when the AChart parameter supports this datasource }
class function TTeeSeriesSource.Available(AChart: TCustomAxisPanel): Boolean;
begin
  result:=True;
end;

class Function TTeeSeriesSource.Description:String;
begin
  result:='';
end;

class Function TTeeSeriesSource.Editor:TComponentClass;
begin
  result:=nil;
end;

{ return True when Series DataSource is same class }
class function TTeeSeriesSource.HasSeries(ASeries: TChartSeries): Boolean;
begin
  result:=ASeries.DataSource.ClassNameIs(ClassName);
end;

{ returns True if this series source allows "New,Edit,Delete" buttons
  at Series DataSource editor dialog }
class function TTeeSeriesSource.HasNew: Boolean;
begin
  result:=False;
end;

{ Utility functions }

{ Returns the series Title (or series Name if Title is empty). }
Function SeriesTitleOrName(ASeries:TCustomChartSeries):String;
begin
  result:=ASeries.Title;
  if result='' then
  begin
    result:=ASeries.Name;
    if (result='') and Assigned(ASeries.ParentChart) then
       result:=TeeMsg_Series+TeeStr(1+ASeries.ParentChart.SeriesList.IndexOf(ASeries));
  end
end;

{ Adds all Series to the AItems parameter. }
Procedure FillSeriesItems(AItems:TStrings; AChart:TCustomAxisPanel);
var t : Integer;
begin
  With AChart do
  for t:=0 to SeriesCount-1 do
  if not Series[t].InternalUse then
      AItems.AddObject(SeriesTitleOrName(Series[t]),Series[t]);
end;

{ List of registered Series Source components }
var FTeeSources: TList;

Function TeeSources: TList;
begin
  if not Assigned(FTeeSources) then
     FTeeSources:=TList.Create;
  result:=FTeeSources;
end;

Procedure ShowMessageUser(Const S:String);
{$IFNDEF CLX}
var St : Array[0..1023] of Char;
{$ENDIF}
begin
  {$IFDEF CLX}
  ShowMessage(S);
  {$ELSE}
  MessageBox(0, StrPCopy(St,S),'',MB_OK or MB_ICONSTOP or MB_TASKMODAL);
  {$ENDIF}
end;

{ Returns if a Series has "X" values (or Y values for HorizBar series) }
Function HasNoMandatoryValues(ASeries:TChartSeries):Boolean;
var t        : Integer;
    tmpCount : Integer;
    tmp      : TChartValueList;
begin
  result:=False;
  With ASeries do
  if IUseNotMandatory and (Count>0) then
  begin
    tmp:=ASeries.NotMandatoryValueList;
    if (tmp.First=0) and (tmp.Last=Count-1) then
    begin
      tmpCount:=Math.Min(10000,Count-1);
      for t:=0 to tmpCount do
      if tmp.Value[t]<>t then
      begin
        result:=True;
        Exit;
      end;
    end
    else result:=True;
  end;
end;

{ Returns if a Series has Colors }
Function HasColors(ASeries:TChartSeries):Boolean;
var t        : Integer;
    tmpCount : Integer;
    tmpColor : TColor;
    tmpSeriesColor:TColor;
begin
  result:=False;
  With ASeries do
  begin
    tmpSeriesColor:=SeriesColor;
    tmpCount:=Math.Min(10000,Count-1);
    for t:=0 to tmpCount do
    begin
      tmpColor:=InternalColor(t);
//      tmpColor:=ValueColor[t];
      if (tmpColor<>clTeeColor) and
         (tmpColor<>tmpSeriesColor) then
      begin
        result:=True;
        exit;
      end;
    end;
  end;
end;

{ Returns if a Series has labels }
Function HasLabels(ASeries:TChartSeries):Boolean;
var t        : Integer;
    tmpCount : Integer;
begin
  result:=False;
  if ASeries.Labels.Count>0 then // 5.01
  begin
    tmpCount:=Math.Min(100,ASeries.Count-1);
    for t:=0 to tmpCount do
    if ASeries.Labels[t]<>'' then
    begin
      result:=True;
      Exit;
    end;
  end;
end;

{ TLabelsList }

{ Returns the label string for the corresponding point (ValueIndex).
  Returns an empty string is no labels exist. }
function TLabelsList.GetLabel(ValueIndex: Integer): String;
begin
  if (Count<=ValueIndex) or (List^[ValueIndex]=nil) then // 5.01
     result:=''
  else
     result:=PString(List^[ValueIndex])^;
end;

{ Replaces a Label into the labels list.
  Allocates the memory for the ALabel string parameter. }
function TLabelsList.IndexOfLabel(const ALabel: String; CaseSensitive:Boolean=True): Integer;
var t   : Integer;
    tmp : String;
begin
  if CaseSensitive then
  begin
    for t:=0 to Count-1 do
    if Labels[t]=ALabel then
    begin
      result:=t;
      exit;
    end;
  end
  else
  begin
    tmp:=UpperCase(ALabel);
    for t:=0 to Count-1 do
    if UpperCase(Labels[t])=tmp then
    begin
      result:=t;
      exit;
    end;
  end;

  result:=-1;
end;

procedure TLabelsList.SetLabel(ValueIndex: Integer; const ALabel: String);
var P : PString;
    t : Integer;
begin
  if (Count>ValueIndex) and Assigned(List^[ValueIndex]) then // 5.01
      Dispose(PString(List^[ValueIndex]));

  if ALabel='' then
  begin
    if Count>0 then List^[ValueIndex]:=nil { 5.01 }
  end
  else
  begin
    New(P);
    P^:=ALabel;
    if Count<=ValueIndex then { 5.01 }
       for t:=Count to ValueIndex do Add(nil);
    List^[ValueIndex]:=P;
  end;

  Series.Repaint;
end;

{ Allocates memory for the ALabel string parameter and inserts it
  into the labels list. }
Procedure TLabelsList.InsertLabel(ValueIndex:Integer; Const ALabel:String);

  Procedure InternalInsert(P:PString);
  begin
    // grow list
    while Count<ValueIndex do Add(nil); { 5.02 }

    // insert
    Insert(ValueIndex,P);
  end;

Var P : PString;
Begin
  if ALabel='' then
  begin
    if Count>0 then InternalInsert(nil); { 5.01 }
  end
  else
  begin
    New(P);
    P^:=ALabel;
    InternalInsert(P);
  end;
end;

procedure TLabelsList.Assign(Source: TLabelsList);
var t : Integer;
begin
  Clear;
  for t:=0 to Source.Count-1 do InsertLabel(t,Source[t]);
end;

procedure TLabelsList.Clear;
var t : Integer;
begin
  for t:=0 to Count-1 do
      if Assigned(List^[t]) then Dispose(PString(List^[t]));

  inherited;
end;

Procedure TLabelsList.DeleteLabel(ValueIndex:Integer);
Begin
  if Assigned(List^[ValueIndex]) then
     Dispose(PString(List^[ValueIndex])); { 5.01 }
  Delete(ValueIndex);
end;

{ TSeriesPointer }
Constructor TSeriesPointer.Create(AOwner:TChartSeries);
Begin
  if Assigned(AOwner) then ParentChart:=AOwner.ParentChart;

  inherited Create;
  AllowChangeSize:=True;

  FSeries:=AOwner;
  FInflate:=True;
  FHorizSize:=4;
  FVertSize:=4;
  FDark3D:=True;
  FDraw3D:=True;
  FStyle:=psRectangle;
  FGradient:=TChartGradient.Create(CanvasChanged);
end;

destructor TSeriesPointer.Destroy;
begin
  FGradient.Free;
  inherited;
end;

Procedure TSeriesPointer.ChangeStyle(NewStyle:TSeriesPointerStyle);
Begin
  FStyle:=NewStyle;
end;

Procedure TSeriesPointer.ChangeHorizSize(NewSize:Integer);
Begin
  FHorizSize:=NewSize;
End;

Procedure TSeriesPointer.ChangeVertSize(NewSize:Integer);
Begin
  FVertSize:=NewSize;
End;

Procedure TSeriesPointer.CheckPointerSize(Value:Integer);
begin
  if Value<1 then Raise ChartException.Create(TeeMsg_CheckPointerSize)
end;

Procedure TSeriesPointer.SetHorizSize(Value:Integer);
Begin
  CheckPointerSize(Value);
  if HorizSize<>Value then
  begin
    FHorizSize:=Value;
    Repaint;
  end;
end;

Procedure TSeriesPointer.SetInflate(Value:Boolean);
begin
  if FInflate<>Value then
  begin
    FInflate:=Value;
    Repaint;
  end;
end;

Procedure TSeriesPointer.SetVertSize(Value:Integer);
Begin
  CheckPointerSize(Value);
  if FVertSize<>Value then
  begin
    FVertSize:=Value;
    Repaint;
  end;
end;

Procedure TSeriesPointer.SetDark3D(Value:Boolean);
Begin
  if FDark3D<>Value then
  begin
    FDark3D:=Value;
    Repaint;
  end;
end;

Procedure TSeriesPointer.SetDraw3D(Value:Boolean);
Begin
  if FDraw3D<>Value then
  begin
    FDraw3D:=Value;
    Repaint;
  end;
end;

Procedure TSeriesPointer.Change3D(Value:Boolean);
Begin
  FDraw3D:=Value;
end;

Procedure TSeriesPointer.CalcHorizMargins(Var LeftMargin,RightMargin:Integer);
begin
  if Visible and FInflate then
  begin
    LeftMargin :=Math.Max(LeftMargin, HorizSize+1);
    RightMargin:=Math.Max(RightMargin,HorizSize+1);
  end;
end;

Procedure TSeriesPointer.CalcVerticalMargins(Var TopMargin,BottomMargin:Integer);
begin
  if Visible and FInflate then
  begin
    TopMargin   :=Math.Max(TopMargin,   VertSize+1);
    BottomMargin:=Math.Max(BottomMargin,VertSize+1);
  end;
end;

Procedure TSeriesPointer.SetStyle(Value:TSeriesPointerStyle);
Begin
  if FStyle<>Value then
  begin
    FStyle:=Value;
    Repaint;
  end;
end;

Procedure TSeriesPointer.PrepareCanvas;
begin
  PrepareCanvas(ParentChart.Canvas,Color);
end;

Procedure TSeriesPointer.PrepareCanvas(ACanvas:TCanvas3D; ColorValue:TColor);
var tmp : TColor;
Begin
  if Pen.Visible then
  begin
    if Pen.Color=clTeeColor then
       ACanvas.AssignVisiblePenColor(Pen,ColorValue) { use default point color }
    else
       ACanvas.AssignVisiblePen(Pen); { use fixed Pen.Color }
  end
  else
  if ACanvas.Pen.Style<>psClear then  // 5.02
     ACanvas.Pen.Style:=psClear;

  tmp:=Brush.Color;
  if tmp=clTeeColor then
     if Brush.Style=bsSolid then tmp:=ColorValue
                            else tmp:=clBlack;

  ACanvas.AssignBrushColor(Brush,tmp,ColorValue);
end;

Procedure TSeriesPointer.DrawPointer( ACanvas:TCanvas3D;
                                      Is3D:Boolean;
                                      px,py,tmpHoriz,tmpVert:Integer;
                                      ColorValue:TColor;
                                      AStyle:TSeriesPointerStyle);

Var PXMinus : Integer;
    PXPlus  : Integer;
    PYMinus : Integer;
    PYPlus  : Integer;

  Procedure DrawDiagonalCross;
  Begin
    with ACanvas do
    begin
      if Is3D then
      begin
        LineWithZ(PXMinus, PYMinus, PXPlus+1,PYPlus+1,GetStartZ);
        LineWithZ(PXPlus,  PYMinus, PXMinus-1,PYPlus+1,GetStartZ);
      end
      else
      begin
        Line(PXMinus, PYMinus, PXPlus+1,PYPlus+1);
        Line(PXPlus , PYMinus, PXMinus-1,PYPlus+1);
      end;
    end;
  end;

  Procedure DrawCross;
  Begin
    with ACanvas do
    begin
      if Is3D then
      begin
        VertLine3D(PX,PYMinus,PYPlus+1,GetStartZ);
        HorizLine3D(PXMinus,PXPlus+1,PY,GetStartZ);
      end
      else
      begin
        DoVertLine(PX,PYMinus,PYPlus+1);
        DoHorizLine(PXMinus,PXPlus+1,PY);
      end;
    end;
  end;

var PT : TTrianglePoints;

  Procedure CalcTriangle3D;
  begin
    PT[0]:=ACanvas.Calculate3DPosition(PT[0],GetStartZ);
    PT[1]:=ACanvas.Calculate3DPosition(PT[1],GetStartZ);
    PT[2]:=ACanvas.Calculate3DPosition(PT[2],GetStartZ);
  end;

  Procedure VertTriangle(DeltaY:Integer);
  begin
    if (not Draw3D) or (not Is3D) then
    begin
      PT[0]:=TeePoint(PXMinus,PY+DeltaY);
      PT[1]:=TeePoint(PXPlus,PY+DeltaY);
      PT[2]:=TeePoint(PX,PY-DeltaY);

      if Is3D then CalcTriangle3D;
    end;

    with ACanvas do
    if Is3D and Self.Draw3D then
       Pyramid( True, PXMinus,PY-DeltaY,PXPlus,PY+DeltaY,GetStartZ,GetEndZ,FDark3D)
    else
       Polygon(PT);
  end;

var PF : TFourPoints;

  Procedure DoGradient;
  var tmpR : TRect;
      tmpIsTri,
      tmpIsFour : Boolean;
  begin
    tmpR:=TeeRect(PXMinus+Pen.Width,PYMinus+Pen.Width,PXPlus,PYPlus);

    if not FullGradient then
       Gradient.EndColor:=ColorValue;

    if not ParentChart.View3DOptions.Orthogonal then
    if AStyle=psRectangle then
    begin
      Dec(tmpR.Right,Pen.Width);
      Dec(tmpR.Bottom,Pen.Width);
      PF:=ACanvas.FourPointsFromRect(tmpR,GetStartZ);
      Gradient.Draw(ACanvas,PF);
      exit;
    end;

    if Is3D then tmpR:=ACanvas.CalcRect3D(tmpR,GetStartZ);

    tmpIsFour:=False;
    tmpIsTri:=False;

    case AStyle of
      psRectangle: ACanvas.ClipRectangle(tmpR);
      psCircle   : ClipEllipse(ACanvas,tmpR);
      psDiamond  : tmpIsFour:=True;
      psLeftTriangle,
      psRightTriangle: tmpIsTri:=True;
      psTriangle,
      psDownTriangle: begin
                        if Draw3D then exit;
                        tmpIsTri:=True;
                      end;
    else
      exit;
    end;

    if tmpIsFour then
       Gradient.Draw(ACanvas,PF)
    else
    if tmpIsTri then
    begin
      ClipPolygon(ACanvas,PT,3);
      Gradient.Draw(ACanvas,RectFromPolygon(PT,3));
    end
    else
       Gradient.Draw(ACanvas,tmpR);

    ACanvas.UnClipRectangle;
  end;

  Procedure HorizTriangle(Left,Right:Integer);
  begin
    PT[0]:=TeePoint(Left,PY);
    PT[1]:=TeePoint(Right,PYPlus);
    PT[2]:=TeePoint(Right,PYMinus);

    if Is3D then CalcTriangle3D;

    ACanvas.Polygon(PT);
  end;

Begin
  PXMinus:=PX-tmpHoriz;
  PXPlus :=PX+tmpHoriz;
  PYMinus:=PY-tmpVert;
  PYPlus :=PY+tmpVert;

  with ACanvas do
    case AStyle of
    psRectangle: if Is3D then
                    if Self.FDraw3D then
                       Cube(PXMinus,PXPlus,PYMinus,PYPlus,GetStartZ,GetEndZ,FDark3D)
                    else
                       RectangleWithZ(TeeRect(PXMinus,PYMinus,PXPlus+1,PYPlus+1),GetStartZ)
                 else
                    Rectangle(PXMinus,PYMinus,PXPlus+1,PYPlus+1);

       psCircle: if Is3D then
                    if Self.FDraw3D and SupportsFullRotation then
                       Sphere(PX,PY,GetMiddleZ,tmpHoriz)
                    else
                       EllipseWithZ(PXMinus,PYMinus,PXPlus,PYPlus,GetStartZ)
                 else
                    Ellipse(PXMinus,PYMinus,PXPlus,PYPlus);

     psTriangle: VertTriangle( tmpVert);
 psDownTriangle: VertTriangle(-tmpVert);
 psLeftTriangle: HorizTriangle(PXMinus,PXPlus);
psRightTriangle: HorizTriangle(PXPlus,PXMinus);
        psCross: DrawCross;
    psDiagCross: DrawDiagonalCross;
         psStar: begin DrawCross; DrawDiagonalCross; end;
      psDiamond: begin
                   PF[0]:=TeePoint(PXMinus,PY);
                   PF[1]:=TeePoint(PX,PYMinus);
                   PF[2]:=TeePoint(PXPlus,PY);
                   PF[3]:=TeePoint(PX,PYPlus);

                   if Is3D then
                   begin
                     PF[0]:=Calculate3DPosition(PF[0],GetStartZ);
                     PF[1]:=Calculate3DPosition(PF[1],GetStartZ);
                     PF[2]:=Calculate3DPosition(PF[2],GetStartZ);
                     PF[3]:=Calculate3DPosition(PF[3],GetStartZ);
                   end;

                   Polygon(PF);
                 end;

     psSmallDot: if Is3D then Pixels3D[PX,PY,GetMiddleZ]:=Brush.Color
                         else Pixels[PX,PY]:=Brush.Color;
  end;

  if Gradient.Visible then DoGradient;
end;

Procedure TSeriesPointer.Draw(P:TPoint);
begin
  Draw(P.X,P.Y,Brush.Color,Style)
end;

Procedure TSeriesPointer.Draw(X,Y:Integer);
begin
  Draw(X,Y,Brush.Color,Style)
end;

Procedure TSeriesPointer.Draw(px,py:Integer; ColorValue:TColor; AStyle:TSeriesPointerStyle);
Begin
  DrawPointer(ParentChart.Canvas,ParentChart.View3D,px,py,FHorizSize,FVertSize,ColorValue,AStyle);
end;

Procedure TSeriesPointer.Assign(Source:TPersistent);
begin
  if Source is TSeriesPointer then
  With TSeriesPointer(Source) do
  begin
    Self.FDark3D    :=FDark3D;
    Self.FDraw3D    :=FDraw3D;
    Self.Gradient   :=Gradient;
    Self.FHorizSize :=FHorizSize;
    Self.FInflate   :=FInflate;
    Self.FStyle     :=FStyle;
    Self.FVertSize  :=FVertSize;
  end;
  inherited;
end;

procedure TSeriesPointer.SetGradient(const Value: TTeeGradient);
begin
  FGradient.Assign(Value);
end;

function TSeriesPointer.GetColor: TColor;
begin
  result:=Brush.Color;
end;

function TSeriesPointer.GetStartZ:Integer;   // 6.01
begin
  if Assigned(FSeries) then result:=FSeries.StartZ
                       else result:=0;
end;

function TSeriesPointer.GetMiddleZ:Integer;  // 6.01
begin
  if Assigned(FSeries) then result:=FSeries.MiddleZ
                       else result:=0;
end;

function TSeriesPointer.GetEndZ:Integer;     // 6.01
begin
  if Assigned(FSeries) then result:=FSeries.EndZ
                       else result:=0;
end;

procedure TSeriesPointer.SetColor(const Value: TColor);
begin
  Brush.Color:=Value;
end;

{ TCallout }
Constructor TCallout.Create(AOwner:TChartSeries);
begin
  inherited Create(AOwner);
  FArrow:=TChartArrowPen.Create(CanvasChanged);
  FInflate:=True;
  FullGradient:=True;
  FStyle:=psRectangle;
  Visible:=True;
  FDraw3D:=False;
  FArrowHeadSize:=8;
  Color:=clBlack;
end;

Destructor TCallout.Destroy;
begin
  FArrow.Free;
  inherited;
end;

Procedure TCallout.Assign(Source:TPersistent);
begin
  if Source is TCallout then
  with TCallout(Source) do
  begin
    Self.FDistance:=Distance;
    Self.Arrow:=Arrow;
    Self.FArrowHead:=FArrowHead;
    Self.FArrowHeadSize:=FArrowHeadSize;
  end;
  inherited;
end;

procedure TCallout.SetDistance(const Value: Integer);
begin
  if FDistance<>Value then
  begin
    FDistance:=Value;
    Repaint;
  end;
end;

procedure TCallout.SetArrow(const Value: TChartArrowPen);
begin
  FArrow.Assign(Value);
end;

procedure TCallout.Draw(AColor:TColor; AFrom,ATo:TPoint; Z:Integer);
Const ArrowColors : Array[Boolean] of TColor=(clBlack,clWhite);
var tmpFrom : TPoint;
    tmpCanvas : TCanvas3D;
begin
  tmpCanvas:=ParentChart.Canvas;

  if Arrow.Visible then
  begin
    tmpCanvas.Brush.Style:=bsClear;

    PrepareCanvas;

    if TeeCheckMarkArrowColor and
       ( (Arrow.Color=AColor) or (Arrow.Color=ParentChart.Color) ) then
       tmpCanvas.AssignVisiblePenColor(Arrow,ArrowColors[ParentChart.Color=clBlack])
    else
       tmpCanvas.AssignVisiblePen(Arrow);

    case ArrowHead of
      ahLine  : tmpCanvas.Arrow(False,ATo,AFrom,ArrowHeadSize,ArrowHeadSize,Z);
      ahSolid : tmpCanvas.Arrow(True,ATo,AFrom,ArrowHeadSize,ArrowHeadSize,Z);
    else
      if ParentChart.View3D then
         tmpCanvas.LineWithZ(AFrom,ATo,Z)
      else
         tmpCanvas.Line(AFrom,ATo);
    end;
  end;

  if (ArrowHead=ahNone) and Visible then
  begin
    PrepareCanvas;

    tmpFrom:=AFrom;

    if ParentChart.View3D then
       tmpFrom:=tmpCanvas.Calculate3DPosition(tmpFrom,Z);

    DrawPointer(tmpCanvas,
                ParentChart.View3D, // 6.01
                tmpFrom.X,tmpFrom.Y,
                HorizSize,VertSize,Color,Style);
  end;
end;

procedure TCallout.SetArrowHead(const Value: TArrowHeadStyle);
begin
  if FArrowHead<>Value then
  begin
    FArrowHead:=Value;
    Repaint;
  end;
end;

procedure TCallout.SetArrowHeadSize(const Value: Integer);
begin
  if FArrowHeadSize<>Value then
  begin
    FArrowHeadSize:=Value;
    Repaint;
  end;
end;

{ TMarksCallout }
Constructor TMarksCallout.Create(AOwner: TChartSeries);
begin
  inherited Create(AOwner);
  FLength:=8;
  Visible:=False;
  FArrow.Color:=clWhite;
end;

procedure TMarksCallout.Assign(Source: TPersistent);
begin
  if Source is TMarksCallout then
  With TMarksCallout(Source) do
  begin
    Self.FLength:=FLength;
  end;
  inherited;
end;

procedure TMarksCallout.SetLength(const Value: Integer);
begin
  ParentSeries.SetIntegerProperty(FLength,Value)
end;

{ TAxisGridPen }

function TAxisGridPen.IsZStored: Boolean;
begin
  result:=FZ<>IDefaultZ;
end;

procedure TAxisGridPen.SetCentered(const Value: Boolean);
begin
  if FCentered<>Value then
  begin
    FCentered:=Value;
    Changed;
  end;
end;

procedure TAxisGridPen.SetZ(const Value: Double);
begin
  if FZ<>Value then
  begin
    FZ:=Value;
    Changed;
  end;
end;

{ TAxisItem }
procedure TAxisItem.SetText(const Value: String);
begin
  if FText<>Value then
  begin
    FText:=Value;
    Repaint;
  end;
end;

procedure TAxisItem.Repaint;
begin
  IAxisItems.IAxis.ParentChart.Invalidate;
end;

procedure TAxisItem.SetValue(const Value: Double);
begin
  if FValue<>Value then
  begin
    FValue:=Value;
    Repaint;
  end;
end;

{ TAxisItems }
constructor TAxisItems.Create(Axis:TChartAxis);
begin
  inherited Create;
  IAxis:=Axis;
  FFormat:=TTeeShape.Create(IAxis.ParentChart);
  FFormat.Transparent:=True;
end;

Destructor TAxisItems.Destroy;
begin
  FFormat.Free;
  inherited;
end;

Function TAxisItems.Add(const Value: Double):TAxisItem;
begin
  result:=TAxisItem.Create(IAxis.ParentChart);
  result.IAxisItems:=Self;
  result.Transparent:=True;
  result.FValue:=Value;
  inherited Add(result);
end;

Function TAxisItems.Add(const Value: Double; const Text: String):TAxisItem;
begin
  result:=Add(Value);
  result.FText:=Text;
end;

procedure TAxisItems.CopyFrom(Source: TAxisItems);
var t : Integer;
begin
  Format.Assign(Source.Format);
  Clear;
  for t:=0 to Source.Count-1 do
      with Source[t] do Add(Value,Text);
end;

procedure TAxisItems.Clear;
var t : Integer;
begin
  for t:=0 to Count-1 do
      Item[t].Free;
  inherited;
  IAxis.ParentChart.Invalidate;
end;

function TAxisItems.Get(Index: Integer): TAxisItem;
begin
  result:=TAxisItem(inherited Items[Index]);
end;

initialization
  {$IFDEF D6}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TCustomChartElement, TControl);
  GroupDescendentsWith(TTeeFunction, TControl);
  GroupDescendentsWith(TTeeSeriesSource, TControl);
  {$ENDIF}

  {$IFDEF TEETRIAL}
  TeeIsTrial:=True;
  {$ENDIF}

  // See TChartAxis XPosValueCheck function...
  if IsWindowsNT then TeeMaxPixelPos:=$3FFFFFF
                 else TeeMaxPixelPos:=$7FFF;

  // Register basic classes
  RegisterClasses([ TChartAxisTitle,TChartAxis,TChartDepthAxis,TSeriesMarks ]);
finalization
  FreeAndNil(FTeeSources);
end.
