{*********************************************}
{  TeeChart Standard Series Types             }
{  Copyright (c) 1995-2003 by David Berneda   }
{  All Rights Reserved                        }
{                                             }
{   TCustomSeries                             }
{     TLineSeries                             }
{      THorizLineSeries                       }
{     TAreaSeries                             }
{      THorizAreaSeries                       }
{     TPointSeries                            }
{   TCustomBarSeries                          }
{     TBarSeries                              }
{     THorizBarSeries                         }
{   TCircledSeries                            }
{     TPieSeries                              }
{   TFastLineSeries                           }
{                                             }
{*********************************************}
unit Series;
{$I TeeDefs.inc}

interface

Uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     {$IFDEF CLX}
     QGraphics, QForms, Types,
     {$ELSE}
     Graphics, Forms,
     {$ENDIF}
     TeEngine, Chart, SysUtils, Classes, TeCanvas, TeeProcs;

Const PiDegree : Double = Pi/180.0;
      Tee_PieShadowColor = TColor($A0A0A0);

Type
  TCustomLineSeries=class(TChartSeries)
  protected
    Function GetLinePen:TChartPen;
  public
    property LinePen:TChartPen read GetLinePen write SetPen;
  end;

  TCustomSeries=class;

  TSeriesClickPointerEvent=Procedure( Sender:TCustomSeries;
                                      ValueIndex:Integer;
                                      X, Y: Integer) of object;

  TCustomSeriesStack=(cssNone,cssOverlap,cssStack,cssStack100);

  TOnGetPointerStyle=Function( Sender:TChartSeries;
                               ValueIndex:Integer):TSeriesPointerStyle of object;

  TCustomSeries=Class(TCustomLineSeries)
  private
    FAreaBrush          : TChartBrush;
    FAreaColor          : TColor;
    FAreaLinesPen       : TChartPen;
    FClickableLine      : Boolean;
    FColorEachLine      : Boolean;
    FDark3D             : Boolean;
    FDrawArea           : Boolean;
    FDrawLine           : Boolean;
    FInvertedStairs     : Boolean;
    FLineHeight         : Integer;
    FOutLine            : TChartHiddenPen;
    FPointer            : TSeriesPointer;
    FStacked            : TCustomSeriesStack;
    FStairs             : Boolean;
    FTransparency       : TTeeTransparency;

    { events }
    FOnClickPointer     : TSeriesClickPointerEvent;
    FOnGetPointerStyle  : TOnGetPointerStyle;

    { internal }
    BottomPos      : Integer;
    OldBottomPos   : Integer;
    OldX           : Integer;
    OldY           : Integer;
    OldColor       : TColor;
    tmpDark3DRatio : Double;
    Function CalcStackedPos(ValueIndex:Integer; Value:Double):Integer;
    Function GetAreaBrush:TBrushStyle;
    Function GetLineBrush:TBrushStyle;
    Procedure InternalCalcMargin(SameSide,Horizontal:Boolean; var A,B:Integer);
    Function PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double;
    Procedure SetAreaBrush(Value:TChartBrush);
    Procedure SetAreaBrushStyle(Value:TBrushStyle);
    Procedure SetAreaColor(Value:TColor);
    Procedure SetAreaLinesPen(Value:TChartPen);
    procedure SetColorEachLine(const Value: Boolean);
    Procedure SetDark3D(Value:Boolean);
    Procedure SetDrawArea(Value:Boolean);
    Procedure SetGradient(Value:TChartGradient);
    Procedure SetInvertedStairs(Value:Boolean);
    Procedure SetLineBrush(Value:TBrushStyle);
    Procedure SetLineHeight(Value:Integer);
    procedure SetOutLine(const Value: TChartHiddenPen);
    Procedure SetPointer(Value:TSeriesPointer);
    Procedure SetStacked(Value:TCustomSeriesStack);
    Procedure SetStairs(Value:Boolean);
    procedure SetTransparency(const Value: TTeeTransparency);
  protected
    FGradient : TChartGradient;
    Procedure CalcHorizMargins(Var LeftMargin,RightMargin:Integer); override;
    Procedure CalcVerticalMargins(Var TopMargin,BottomMargin:Integer); override;
    Procedure CalcZOrder; override;
    Function ClickedPointer( ValueIndex,tmpX,tmpY:Integer;
                             x,y:Integer):Boolean; virtual;
    Procedure DrawAllValues; override; { 5.02 }
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Procedure DrawPointer(AX,AY:Integer; AColor:TColor; ValueIndex:Integer); virtual;
    procedure DrawValue(ValueIndex:Integer); override;
    Function GetAreaBrushColor(AColor:TColor):TColor;
    class Function GetEditorClass:String; override;
    property Gradient:TChartGradient read FGradient write SetGradient; { 5.03 }
    procedure LinePrepareCanvas(tmpCanvas:TCanvas3D; tmpColor:TColor);
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;

    property Stacked:TCustomSeriesStack read FStacked write SetStacked default cssNone;
    property Transparency:TTeeTransparency read FTransparency write SetTransparency default 0;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Function CalcYPos(ValueIndex:Integer):Integer; override;
    Function Clicked(x,y:Integer):Integer; override;
    Function GetOriginPos(ValueIndex:Integer):Integer; virtual;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;

    property AreaBrush:TBrushStyle read GetAreaBrush write SetAreaBrushStyle
                                        default bsSolid;
    property AreaChartBrush:TChartBrush read FAreaBrush write SetAreaBrush;
    property AreaColor:TColor read FAreaColor write SetAreaColor default clTeeColor;
    property AreaLinesPen:TChartPen read FAreaLinesPen write SetAreaLinesPen;
    property ClickableLine:Boolean read FClickableLine write FClickableLine default True;
    property ColorEachLine:Boolean read FColorEachLine write SetColorEachLine default True;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    property DrawArea:Boolean read FDrawArea write SetDrawArea default False;
    property InvertedStairs:Boolean read FInvertedStairs write SetInvertedStairs default False;
    property LineBrush:TBrushStyle read GetLineBrush write SetLineBrush default bsSolid;
    property LineHeight:Integer read FLineHeight write SetLineHeight default 0;
    property OutLine:TChartHiddenPen read FOutLine write SetOutLine;
    property Pointer:TSeriesPointer read FPointer write SetPointer;
    property Stairs:Boolean read FStairs write SetStairs default False;
    { events }
    property OnClickPointer:TSeriesClickPointerEvent read FOnClickPointer
                                                     write FOnClickPointer;
  published
    { events }
    property OnGetPointerStyle:TOnGetPointerStyle read FOnGetPointerStyle
                                                  write FOnGetPointerStyle;

  end;

  TLineSeries=Class(TCustomSeries)
  protected
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                   Var BrushStyle:TBrushStyle); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure Assign(Source:TPersistent); override;
  published
    property Active;
    property ColorEachLine;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property Depth;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;  { after parentchart }
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Stacked;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property Brush;
    property ClickableLine;
    property Dark3D;
    property InvertedStairs;
    property LineBrush;
    property LineHeight;
    property LinePen;
    property OutLine; { 5.02 }
    property Pointer;
    property Stairs;
    property XValues;
    property YValues;
  end;

  THorizLineSeries=class(TLineSeries)
  public
    Constructor Create(AOwner: TComponent); override;
  end;

  TPointSeries=Class(TCustomSeries)
  private
    Procedure SetFixed;
  protected
    class Function CanDoExtra : Boolean; virtual;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    class Function GetEditorClass:String; override;
    Procedure PrepareForGallery(IsEnabled:Boolean); override;
    Procedure SetColorEachPoint(Value:Boolean); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure Assign(Source:TPersistent); override;
  published
    property Active;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property Depth;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;  { after parentchart }
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Stacked;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property ClickableLine;
    property Pointer;
    property XValues;
    property YValues;
   { events }
    property OnClickPointer;
  end;

  TMultiArea=(maNone,maStacked,maStacked100);

  TAreaSeries=Class(TCustomSeries)
  private
    FUseOrigin : Boolean;
    FOrigin    : Double;
    Function GetMultiArea:TMultiArea;
    Procedure SetMultiArea(Value:TMultiArea);
    Procedure SetOrigin(Const Value:Double);
    Procedure SetUseOrigin(Value:Boolean);
  protected
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override; // 5.03
    class Function GetEditorClass:String; override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                   Var BrushStyle:TBrushStyle); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure Assign(Source:TPersistent); override;
    Function DrawSeriesForward(ValueIndex:Integer):Boolean; override;
    Function GetOriginPos(ValueIndex:Integer):Integer; override;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;
  published
    property Active;
    property ColorEachLine;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property Depth;
    property Gradient; { 5.03 }
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;  { after parentchart }
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property AreaBrush;
    property AreaChartBrush;
    property AreaColor;
    property AreaLinesPen;
    property ClickableLine;
    property Dark3D;
    property DrawArea;
    property InvertedStairs;
    property LinePen;
    property MultiArea:TMultiArea read GetMultiArea write SetMultiArea default maNone;
    property Pointer;
    property Stairs;
    property Transparency; { 5.02 }
    property UseYOrigin:Boolean read FUseOrigin write SetUseOrigin default False;
    property XValues;
    property YOrigin:Double read FOrigin write SetOrigin;
    property YValues;
   { events }
    property OnClickPointer;
  end;

  THorizAreaSeries=class(TAreaSeries)
  protected
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Function NumSampleValues:Integer; override;
  end;

  TMultiBar=(mbNone,mbSide,mbStacked,mbStacked100,mbSideAll,mbSelfStack);

  TCustomBarSeries=class;

  TBarStyle=( bsRectangle,bsPyramid,bsInvPyramid,
              bsCilinder,bsEllipse,bsArrow,bsRectGradient,bsCone,bsBevel);

  TGetBarStyleEvent=Procedure( Sender:TCustomBarSeries; ValueIndex:Integer;
                               Var TheBarStyle:TBarStyle) of object;

  TBarSeriesGradient=class(TCustomTeeGradient)
  private
    FRelative: Boolean;
    procedure SetRelative(const Value: Boolean);
  published
    property Balance;
    property Direction nodefault;
    property MidColor;
    property Relative:Boolean read FRelative write SetRelative default False;
    property StartColor;
    property Visible default True; { 5.02 }
  end;

  TCustomBarSeries=class(TChartSeries)
  private
    FAutoBarSize     : Boolean;
    FAutoMarkPosition: Boolean;
    FBarStyle        : TBarStyle;
    FBarWidthPercent : Integer;
    FBevelSize       : Integer;
    FConePercent     : Integer;
    FDark3D          : Boolean;
    FGradient        : TBarSeriesGradient;
    FMultiBar        : TMultiBar;
    FOffsetPercent   : Integer;
    FSideMargins     : Boolean;
    FStackGroup      : Integer;
    FTransparency    : TTeeTransparency;
    FUseOrigin       : Boolean;
    FOrigin          : Double;
    { events }
    FOnGetBarStyle   : TGetBarStyleEvent;

    { internal }
    FBarBounds     : TRect;
    INumBars       : Integer;
    IMaxBarPoints  : Integer;
    IOrderPos      : Integer;
    IPreviousCount : Integer;

    Procedure CalcGradientColor(ValueIndex:Integer);
    Function CreateBlend:TTeeBlend;
    Procedure DrawBevel;
    Function GetBarBrush:TChartBrush;
    Function GetBarPen:TChartPen;
    Function GetBarStyle(ValueIndex:Integer):TBarStyle;
    Procedure SetAutoBarSize(Value:Boolean);
    Procedure SetAutoMarkPosition(Value:Boolean);
    Procedure SetBarWidthPercent(Value:Integer);
    Procedure SetOffsetPercent(Value:Integer);
    Procedure SetBarStyle(Value:TBarStyle);
    procedure SetBevelSize(const Value: Integer);
    procedure SetConePercent(const Value: Integer);
    Procedure SetDark3d(Value:Boolean);
    Procedure SetGradient(Value:TBarSeriesGradient);
    Procedure SetMultiBar(Value:TMultiBar);
    Procedure SetOrigin(Const Value:Double);
    Procedure SetOtherBars(SetOthers:Boolean);
    Procedure SetSideMargins(Value:Boolean);
    Procedure SetStackGroup(Value:Integer);
    procedure SetTransparency(const Value: TTeeTransparency);
    Procedure SetUseOrigin(Value:Boolean);

    Procedure BarGradient(ValueIndex:Integer; R:TRect);
    Procedure InternalApplyBarMargin(Var MarginA,MarginB:Integer);
    Function InternalGetOriginPos(ValueIndex:Integer; DefaultOrigin:Integer):Integer;
    Function MaxMandatoryValue(Const Value:Double):Double;
    Function MinMandatoryValue(Const Value:Double):Double;
  protected
    IBarSize         : Integer; { 5.01 }
    FCustomBarSize   : Integer;

    Procedure CalcZOrder; override;
    class procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    Procedure DoBeforeDrawChart; override;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    class Function GetEditorClass:String; override;
    Function InternalCalcMarkLength(ValueIndex:Integer):Integer; virtual; abstract;
    Function InternalClicked(ValueIndex:Integer; P:TPoint):Boolean; virtual; abstract;
    Procedure PrepareForGallery(IsEnabled:Boolean); override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                   Var BrushStyle:TBrushStyle); override;
    Procedure SetCustomBarSize(Value:Integer); { 5.01 BCB cannot if private }
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
    class Function SubGalleryStack:Boolean; virtual;

    property Transparency:TTeeTransparency read FTransparency write SetTransparency default 0;
  public
    NormalBarColor : TColor;

    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Function AddBar(Const AValue:Double; Const ALabel:String; AColor:TColor):Integer;
    Function ApplyBarOffset(Position:Integer):Integer;
    Procedure Assign(Source:TPersistent); override;
    Function BarMargin:Integer; {virtual; 4.02 }
    Procedure BarRectangle(BarColor:TColor; ALeft,ATop,ARight,ABottom:Integer);
    Function CalcMarkLength(ValueIndex:Integer):Integer;
    Function Clicked(x,y:Integer):Integer; override;
    Function NumSampleValues:Integer; override;
    Function PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double; virtual;
    Procedure SetPenBrushBar(BarColor:TColor);

    property BarBounds:TRect read FBarBounds;
    property ConePercent:Integer read FConePercent write SetConePercent
                                default 0;
  published
    property Active;
    property BarBrush:TChartBrush read GetBarBrush write SetBrush;
    property BarPen:TChartPen read GetBarPen write SetPen;
    property BevelSize:Integer read FBevelSize write SetBevelSize default 1;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property Depth;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property AutoBarSize:Boolean read FAutoBarSize write SetAutoBarSize default False;
    property AutoMarkPosition:Boolean read FAutoMarkPosition write SetAutoMarkPosition default True;
    property BarStyle:TBarStyle read FBarStyle write SetBarStyle
                                default bsRectangle;
    property BarWidthPercent:Integer read FBarWidthPercent
                                     write SetBarWidthPercent default 70;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    property Gradient:TBarSeriesGradient read FGradient write SetGradient;
    property MultiBar:TMultiBar read FMultiBar write SetMultiBar default mbSide;
    property OffsetPercent:Integer read FOffsetPercent
                                   write SetOffsetPercent default 0;
    property SideMargins:Boolean read FSideMargins write SetSideMargins default True;
    property StackGroup:Integer read FStackGroup write SetStackGroup default 0;
    property UseYOrigin:Boolean read FUseOrigin write SetUseOrigin default True;
    property YOrigin:Double read FOrigin write SetOrigin;

    { inherited published }
    property XValues;
    property YValues;
    { events }
    property OnGetBarStyle:TGetBarStyleEvent read FOnGetBarStyle write
                                             FOnGetBarStyle;
  end;

  TBarSeries=class(TCustomBarSeries)
  protected
    Procedure CalcHorizMargins(Var LeftMargin,RightMargin:Integer); override;
    Procedure CalcVerticalMargins(Var TopMargin,BottomMargin:Integer); override;
    procedure DrawValue(ValueIndex:Integer); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Function InternalCalcMarkLength(ValueIndex:Integer):Integer; override;
    Function InternalClicked(ValueIndex:Integer; P:TPoint):Boolean; override;
    Function MoreSameZOrder:Boolean; override;
  public
    Constructor Create(AOwner:TComponent); override;

    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Function CalcYPos(ValueIndex:Integer):Integer; override;
    Procedure DrawBar(BarIndex,StartPos,EndPos:Integer); virtual;
    Function DrawSeriesForward(ValueIndex:Integer):Boolean; override;
    Function GetOriginPos(ValueIndex:Integer):Integer;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;

    property BarWidth:Integer read IBarSize;
  published
    property CustomBarWidth:Integer read FCustomBarSize
                                    write SetCustomBarSize default 0;
  end;

  THorizBarSeries=class(TCustomBarSeries)
  protected
    Procedure CalcHorizMargins(Var LeftMargin,RightMargin:Integer); override;
    Procedure CalcVerticalMargins(Var TopMargin,BottomMargin:Integer); override;
    procedure DrawValue(ValueIndex:Integer); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Function InternalCalcMarkLength(ValueIndex:Integer):Integer; override;
    Function InternalClicked(ValueIndex:Integer; P:TPoint):Boolean; override;
  public
    Constructor Create(AOwner:TComponent); override;

    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Function CalcYPos(ValueIndex:Integer):Integer; override;
    Procedure DrawBar(BarIndex,StartPos,EndPos:Integer); virtual;
    Function DrawSeriesForward(ValueIndex:Integer):Boolean; override;
    Function GetOriginPos(ValueIndex:Integer):Integer;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;

    property BarHeight:Integer read IBarSize;
  published
    property CustomBarHeight:Integer read FCustomBarSize
                                     write SetCustomBarSize default 0;
  end;

  TCircledSeries=class(TChartSeries)
  private
    FCircleBackColor : TColor;
    FCircled         : Boolean;
    FCircleGradient  : TChartGradient;
    FCustomXRadius   : Integer;
    FCustomYRadius   : Integer;
    FRotationAngle   : Integer;
    FXRadius         : Integer;
    FYRadius         : Integer;

    { internal }
    IBack3D         : TView3DOptions;
    FCircleWidth    : Integer;
    FCircleHeight   : Integer;
    FCircleXCenter  : Integer;
    FCircleYCenter  : Integer;
    FCircleRect     : TRect;
    IRotDegree      : Double;

    procedure SetCircleBackColor(Value:TColor);
    Procedure SetCircled(Value:Boolean);
    procedure SetCircleGradient(const Value: TChartGradient);
    procedure SetCustomXRadius(Value:Integer);
    procedure SetCustomYRadius(Value:Integer);
    procedure SetOtherCustomRadius(IsXRadius:Boolean; Value:Integer);
  protected
    Procedure AdjustCircleRect;
    Function CalcCircleBackColor:TColor;
    Procedure CalcRadius;
    Procedure DoBeforeDrawValues; override;
    Procedure DrawCircleGradient; virtual;
    Function HasBackColor:Boolean;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                   Var BrushStyle:TBrushStyle); override;
    Procedure SetActive(Value:Boolean); override;
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;
    Procedure SetParentProperties(EnableParentProps:Boolean); dynamic;
    Procedure SetRotationAngle(const Value:Integer);

    property CircleGradient:TChartGradient read FCircleGradient write SetCircleGradient;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Procedure AngleToPos( Const Angle,AXRadius,AYRadius:Double;
                          Var X,Y:Integer);
    Procedure Assign(Source:TPersistent); override;
    Function AssociatedToAxis(Axis:TChartAxis):Boolean; override;
    Function PointToAngle(x,y:Integer):Double;
    Procedure Rotate(const Angle:Integer);
    Function UseAxis:Boolean; override;

    { read only properties }
    property CircleBackColor:TColor read FCircleBackColor
                                    write SetCircleBackColor default clTeeColor;
    property CircleHeight:Integer read FCircleHeight;
    property CircleRect:TRect read FCircleRect;
    property CircleWidth:Integer read FCircleWidth;
    property CircleXCenter:Integer read FCircleXCenter;
    property CircleYCenter:Integer read FCircleYCenter;
    property RotationAngle:Integer read FRotationAngle write SetRotationAngle
                                   default 0;
    property XRadius:Integer read FXRadius;
    property YRadius:Integer read FYRadius;
  published
    property ColorSource;
    property Cursor;
    property Marks;
    property ParentChart;
    property DataSource;
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property Circled:Boolean read FCircled write SetCircled default False;
    property CustomXRadius:Integer read FCustomXRadius write SetCustomXRadius default 0;
    property CustomYRadius:Integer read FCustomYRadius write SetCustomYRadius default 0;
  end;

  TPieAngle=Packed Record
    StartAngle : Double;
    MidAngle   : Double;
    EndAngle   : Double;
  end;

  TPieAngles=Array of TPieAngle;

  TExplodedSlices=class(TList)
  private
    Procedure Put(Index,Value:Integer);
    Function Get(Index:Integer):Integer;
  public
    OwnerSeries : TChartSeries;
    property Value[Index:Integer]:Integer read Get write Put; default;
  end;

  TPieOtherStyle=(poNone,poBelowPercent,poBelowValue);

  TPieOtherSlice=class(TPersistent)
  private
    FColor    : TColor;
    FLegend   : TChartLegend;
    FStyle    : TPieOtherStyle;
    FText     : String;
    FValue    : Double;
    FOwner    : TChartSeries;

    function GetLegend: TChartLegend;
    Function GetText:String;
    Function IsTextStored:Boolean;
    procedure SetColor(Value:TColor);
    procedure SetLegend(const Value: TChartLegend);
    procedure SetStyle(Value:TPieOtherStyle);
    procedure SetText(Const Value:String);
    procedure SetValue(Const Value:Double);
  public
    Constructor Create(AOwner:TChartSeries);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
  published
    property Color:TColor read FColor write SetColor default clTeeColor;
    property Legend:TChartLegend read GetLegend write SetLegend;
    property Style:TPieOtherStyle read FStyle write SetStyle default poNone;
    property Text:String read GetText write SetText stored IsTextStored;
    property Value:Double read FValue write SetValue;
  end;

  TPieShadow=class(TTeeShadow) { 5.02 }
  published
    property Color default Tee_PieShadowColor;
  end;

  TPieSeries=Class(TCircledSeries)
  private
    FAngleSize        : Integer;
    FAutoMarkPosition : Boolean;
    FDark3D           : Boolean;
    FDarkPen          : Boolean;
    FDonutPercent     : Integer;
    FExplodedSlice    : TExplodedSlices; { <-- Exploded slice % storage }
    FExplodeBiggest   : Integer;
    FOtherSlice       : TPieOtherSlice;
    FShadow           : TPieShadow;
    FUsePatterns      : Boolean;

    ISortedSlice      : Array of Integer;

    Procedure CalcExplodeBiggest;
    Procedure CalcExplodedOffset( ValueIndex:Integer;
                                  Var OffsetX,OffsetY:Integer);
    Function CompareSlice(A,B:Integer):Integer;
    Procedure DisableRotation;
    Function GetPiePen:TChartPen;
    Function GetPieValues:TChartValueList;
    Procedure PreparePiePen(ValueIndex:Integer);
    procedure RemoveOtherSlice;
    Procedure SetAngleSize(Value:Integer);
    Procedure SetAutoMarkPosition(Value:Boolean);
    Procedure SetDark3D(Value:Boolean);
    procedure SetExplodeBiggest(Value:Integer);
    procedure SetOtherSlice(Value:TPieOtherSlice);
    Procedure SetPieValues(Value:TChartValueList);
    Procedure SetShadow(Value:TPieShadow);
    procedure SetUsePatterns(Value:Boolean);
    Function SliceBrushStyle(ValueIndex:Integer):TBrushStyle;
    Procedure SwapSlice(a,b:Integer);
    procedure SetDarkPen(const Value: Boolean);
  protected
    FAngles    : TPieAngles;
    IniX       : Integer;
    IniY       : Integer;
    EndX       : Integer;
    EndY       : Integer;
    IsExploded : Boolean;
    Procedure AddSampleValues(NumValues:Integer); override;
    Procedure CalcAngles;
    Procedure CalcExplodedRadius(ValueIndex:Integer; Var AXRadius,AYRadius:Integer);
    Procedure ClearLists; override;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    procedure DoBeforeDrawChart; override;
    procedure DrawAllValues; override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Procedure DrawPie(ValueIndex:Integer); virtual;
    procedure DrawValue(ValueIndex:Integer); override;
    Procedure GalleryChanged3D(Is3D:Boolean); override;
    class Function GetEditorClass:String; override;
    Procedure PrepareForGallery(IsEnabled:Boolean); override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                   Var BrushStyle:TBrushStyle); override;
    procedure SetDonutPercent(Value:Integer);
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
    procedure WriteData(Stream: TStream); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Function AddPie(Const AValue:Double; Const ALabel:String='';
                    AColor:TColor=clTeeColor):Integer;
    Procedure Assign(Source:TPersistent); override;
    Function BelongsToOtherSlice(ValueIndex:Integer):Boolean;
    Function CalcClickedPie(x,y:Integer):Integer;
    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Procedure CheckOrder; override;
    Function Clicked(x,y:Integer):Integer; override;
    Function CountLegendItems:Integer; override;
    Function LegendToValueIndex(LegendIndex:Integer):Integer; override;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;
    Function NumSampleValues:Integer; override;
    procedure SwapValueIndex(a,b:Integer); override;

    property Angles:TPieAngles read FAngles;
    property DonutPercent:Integer read FDonutPercent write SetDonutPercent;
    property ExplodedSlice:TExplodedSlices read FExplodedSlice;
  published
    property Active;
    property AngleSize:Integer read FAngleSize write SetAngleSize default 360;
    property AutoMarkPosition:Boolean read FAutoMarkPosition write SetAutoMarkPosition default True;
    property CircleBackColor;
    property ColorEachPoint default True;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    property DarkPen:Boolean read FDarkPen write SetDarkPen default False;
    property ExplodeBiggest:Integer read FExplodeBiggest write SetExplodeBiggest default 0;
    property OtherSlice:TPieOtherSlice read FOtherSlice write SetOtherSlice;
    property PiePen:TChartPen read GetPiePen write SetPen;
    property PieValues:TChartValueList read GetPieValues write SetPieValues;
    property RotationAngle;
    property Shadow:TPieShadow read FShadow write SetShadow; { 5.02 }
    property UsePatterns:Boolean read FUsePatterns write SetUsePatterns default False;
  end;

  TFastLineSeries=class(TCustomLineSeries)
  private
    FAutoRepaint    : Boolean;
    FDrawAll        : Boolean;
    FFastPen        : Boolean;
    FIgnoreNulls    : Boolean; // 6.0
    FInvertedStairs : Boolean; // 6.0
    FStairs         : Boolean; // 6.0

    {$IFNDEF CLX}
    DCPEN        : HGDIOBJ;
    {$ENDIF}

    { internal }
    OldX         : Integer;
    OldY         : Integer;
    Procedure CalcPosition(ValueIndex:Integer; var x,y:Integer);
    procedure DoMove(X,Y:Integer);
    Procedure SetDrawAll(Const Value:Boolean);
    procedure SetFastPen(const Value: Boolean);
    procedure SetIgnoreNulls(const Value: Boolean);
    procedure SetInvertedStairs(const Value: Boolean);
    procedure SetStairs(const Value: Boolean);
  protected
    Procedure CalcHorizMargins(Var LeftMargin,RightMargin:Integer); override;
    Procedure CalcVerticalMargins(Var TopMargin,BottomMargin:Integer); override;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    procedure DrawAllValues; override;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    procedure DrawValue(ValueIndex:Integer); override;
    class Function GetEditorClass:String; override;
    procedure PrepareCanvas;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                   Var BrushStyle:TBrushStyle); override;
    Procedure SetPen(Const Value:TChartPen); override;
    Procedure SetSeriesColor(AColor:TColor); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure Assign(Source:TPersistent); override;
    Function Clicked(x,y:Integer):Integer; override;
    Procedure NotifyNewValue(Sender:TChartSeries; ValueIndex:Integer); override;
    property FastPen:Boolean read FFastPen write SetFastPen default False;
  published
    property Active;
    property Cursor;
    property Depth;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property AutoRepaint:Boolean read FAutoRepaint write FAutoRepaint default True;
    property DrawAllPoints:Boolean read FDrawAll write SetDrawAll default True; { 5.02 }
    property IgnoreNulls:Boolean read FIgnoreNulls write SetIgnoreNulls default True;
    property InvertedStairs:Boolean read FInvertedStairs write SetInvertedStairs default False;
    property LinePen;
    property Stairs:Boolean read FStairs write SetStairs default False;
    property XValues;
    property YValues;
  end;

Const
  bsCylinder=bsCilinder;  { <-- better spelling... }

{ calls RegisterTeeSeries for each "standard" series type
  (line,bar,pie,fastline,horizbar,area,point and horizline) }
Procedure RegisterTeeStandardSeries;

Procedure TeePointerDrawLegend(Pointer:TSeriesPointer; AColor:TColor;
                               Const Rect:TRect; DrawPen:Boolean);

implementation

Uses Math, TeeConst;

Function GetDefaultPattern(PatternIndex:Integer):TBrushStyle;
Const MaxDefaultPatterns = 6;
      PatternPalette     : Array[1..MaxDefaultPatterns] of TBrushStyle=
	( bsHorizontal,
	  bsVertical,
	  bsFDiagonal,
	  bsBDiagonal,
	  bsCross,
	  bsDiagCross
	);
Begin
  result:=PatternPalette[1+(PatternIndex mod MaxDefaultPatterns)];
End;

{ TCustomLineSeries }
Function TCustomLineSeries.GetLinePen:TChartPen;
Begin
  result:=Pen;
end;

{ TCustomSeries }
Constructor TCustomSeries.Create(AOwner: TComponent);
Begin
  inherited;
  ClickableLine:=True;
  FColorEachLine:=True;
  DrawBetweenPoints:=True;
  FPointer:=TSeriesPointer.Create(Self);

  FAreaLinesPen:=CreateChartPen;
  FOutLine:=TChartHiddenPen.Create(CanvasChanged);
  FAreaBrush:=TChartBrush.Create(CanvasChanged);
  FAreaColor:=clTeeColor;
  FDark3D:=True;
  FGradient:=TChartGradient.Create(CanvasChanged);
end;

Destructor TCustomSeries.Destroy;
Begin
  FGradient.Free;
  FAreaBrush.Free;
  FAreaLinesPen.Free;
  FOutLine.Free;
  FreeAndNil(FPointer);
  inherited;
end;

Procedure TCustomSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                  APosition:TSeriesMarkPosition);
begin
  Marks.ZPosition:=StartZ;
  if YMandatory then Marks.ApplyArrowLength(APosition);
  inherited;
end;

Function TCustomSeries.ClickedPointer( ValueIndex,tmpX,tmpY:Integer;
                                       x,y:Integer):Boolean;
var tmpStyle : TSeriesPointerStyle;
begin
  if Assigned(FOnGetPointerStyle) then
     tmpStyle:=FOnGetPointerStyle(Self,ValueIndex)
  else
     tmpStyle:=Pointer.Style;

  result:=(tmpStyle<>psNothing) and
          (Abs(tmpX-X)<FPointer.HorizSize) and
          (Abs(tmpY-Y)<FPointer.VertSize);
end;

Procedure TCustomSeries.Assign(Source:TPersistent);
begin
  if Source is TCustomSeries then
  With TCustomSeries(Source) do
  begin
    Self.ClickableLine   :=ClickableLine;
    Self.AreaChartBrush  :=FAreaBrush;
    Self.FAreaColor      :=FAreaColor;
    Self.AreaLinesPen    :=AreaLinesPen;
    Self.FColorEachLine  :=ColorEachLine;
    Self.FDark3D         :=FDark3D;
    Self.FDrawArea       :=FDrawArea;
    Self.FDrawLine       :=FDrawLine;
    Self.FInvertedStairs :=FInvertedStairs;
    Self.FLineHeight     :=FLineHeight;
    Self.Pointer         :=FPointer;
    Self.FStacked        :=FStacked;
    Self.FStairs         :=FStairs;
    Self.OutLine         :=OutLine;
    Self.FTransparency   :=FTransparency;
    Self.Gradient        :=FGradient;
  end;
  inherited;
end;

Function TCustomSeries.Clicked(x,y:Integer):Integer;
var OldXPos  : Integer;
    OldYPos  : Integer;
    tmpX     : Integer;
    tmpY     : Integer;
    P        : TPoint;

    Function CheckPointInLine:Boolean;

      Function PointInVertLine(x0,y0,y1:Integer):Boolean;
      begin
        result:=PointInLine(P,x0,y0,x0,y1);
      end;

      Function PointInHorizLine(x0,y0,x1:Integer):Boolean;
      begin
        result:=PointInLine(P,x0,y0,x1,y0);
      end;

    begin
      With ParentChart do
      if View3D then
         result:=PointInPolygon( P,[ TeePoint(tmpX,tmpY),
                                     TeePoint(tmpX+SeriesWidth3D,tmpY-SeriesHeight3D),
                                     TeePoint(OldXPos+SeriesWidth3D,OldYPos-SeriesHeight3D),
                                     TeePoint(OldXPos,OldYPos) ])
      else
         if Stairs then
         begin
            if FInvertedStairs then result:= PointInVertLine(OldXPos,OldYPos,tmpY) or
                                             PointInHorizLine(OldXPos,tmpY,tmpX)
                               else result:= PointInHorizLine(OldXPos,OldYPos,tmpX) or
                                             PointInVertLine(tmpX,OldYPos,tmpY);
         end
         else
            result:=PointInLine(P,tmpX,tmpY,OldXPos,OldYPos)
    end;

var t : Integer;
begin
  if Assigned(ParentChart) then ParentChart.Canvas.Calculate2DPosition(X,Y,StartZ);

  result:=inherited Clicked(x,y);

  if (result=TeeNoPointClicked) and
     (FirstValueIndex>-1) and (LastValueIndex>-1) then
  begin
    OldXPos:=0;
    OldYPos:=0;
    OldBottomPos:=0;
    P.X:=X;
    P.Y:=Y;

    for t:=FirstValueIndex to LastValueIndex do
    begin
      if t>=Count then exit;  // prevent re-entrancy if series is cleared.

      tmpX:=CalcXPos(t);
      tmpY:=CalcYPos(t);

      if FPointer.Visible then
      begin
        if ClickedPointer(t,tmpX,tmpY,x,y) then
        begin
          if Assigned(FOnClickPointer) then FOnClickPointer(Self,t,x,y);
          result:=t;
          break;
        end;
      end;

      if (tmpX=X) and (tmpY=Y) then
      begin
        result:=t;
        break;
      end;

      if (t>FirstValueIndex) and ClickableLine then
         if CheckPointInLine or
            ( FDrawArea and
               PointInPolygon( P,[ TeePoint(OldXPos,OldYPos),
                                   TeePoint(tmpX,tmpY),
                                   TeePoint(tmpX,GetOriginPos(t)),
                                   TeePoint(OldXPos,GetOriginPos(t-1)) ] )
            ) then
         begin
           result:=t-1;
           break;
         end;

      OldXPos:=tmpX;
      OldYPos:=tmpY;
      OldBottomPos:=BottomPos;
    end;
  end;
end;

Procedure TCustomSeries.SetDrawArea(Value:Boolean);
Begin
  SetBooleanProperty(FDrawArea,Value);
end;

Procedure TCustomSeries.SetPointer(Value:TSeriesPointer);
Begin
  FPointer.Assign(Value);
end;

Procedure TCustomSeries.SetAreaLinesPen(Value:TChartPen);
Begin
  FAreaLinesPen.Assign(Value);
end;

Procedure TCustomSeries.SetLineHeight(Value:Integer);
Begin
  SetIntegerProperty(FLineHeight,Value);
end;

Procedure TCustomSeries.SetStairs(Value:Boolean);
Begin
  SetBooleanProperty(FStairs,Value);
end;

Procedure TCustomSeries.SetInvertedStairs(Value:Boolean);
Begin
  SetBooleanProperty(FInvertedStairs,Value);
end;

Procedure TCustomSeries.SetAreaColor(Value:TColor);
Begin
  SetColorProperty(FAreaColor,Value);
end;

Procedure TCustomSeries.SetAreaBrushStyle(Value:TBrushStyle);
Begin
  FAreaBrush.Style:=Value;
end;

Function TCustomSeries.GetLineBrush:TBrushStyle;
Begin
  result:=Brush.Style;
end;

Procedure TCustomSeries.SetLineBrush(Value:TBrushStyle);
Begin
  Brush.Style:=Value;
end;

type TPointerAccess=class(TSeriesPointer);

Procedure TeePointerDrawLegend(Pointer:TSeriesPointer; AColor:TColor;
                               Const Rect:TRect; DrawPen:Boolean);
var tmpHoriz : Integer;
    tmpVert  : Integer;
begin
  if Assigned(Pointer.ParentChart) then
  begin
    TPointerAccess(Pointer).PrepareCanvas(Pointer.ParentChart.Canvas,AColor);

    with TCustomChart(Pointer.ParentChart) do
    if not Legend.Symbol.DefaultPen then
    begin
      Canvas.AssignVisiblePen(Legend.Symbol.Pen); { use custom legend pen }
      DrawPen:=Legend.Symbol.Pen.Visible;
    end;

    With Rect do
    begin
      if DrawPen then
      begin
        tmpHoriz:=(Right-Left) div 3;
        tmpVert :=(Bottom-Top) div 3;
      end
      else
      begin
        tmpHoriz:=1+((Right-Left) div 2);
        tmpVert :=1+((Bottom-Top) div 2);
      end;

      Pointer.DrawPointer(Pointer.ParentChart.Canvas,
                          False, (Left+Right) div 2,(Top+Bottom) div 2,
                          Math.Min(Pointer.HorizSize,tmpHoriz),
                          Math.Min(Pointer.VertSize,tmpVert),AColor,Pointer.Style);
    end;
  end;
end;

Procedure TCustomSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);
Var tmpColor : TColor;

  Procedure DrawLine(DrawRectangle:Boolean);
  begin
    if TCustomChart(ParentChart).Legend.Symbol.DefaultPen then
       LinePrepareCanvas(ParentChart.Canvas,tmpColor);
    With ParentChart.Canvas do
    if DrawRectangle then Rectangle(Rect)
    else
    With Rect do DoHorizLine(Left,Right,(Top+Bottom) div 2);
  end;

begin
  if ValueIndex=TeeAllValues then tmpColor:=SeriesColor
                             else tmpColor:=LegendItemColor(ValueIndex); // 6.0

  if FPointer.Visible then
  begin
    if FDrawLine then DrawLine(False);
    TeePointerDrawLegend(Pointer,tmpColor,Rect,LinePen.Visible);
  end
  else
  if FDrawLine and (not FDrawArea) then
     DrawLine(ParentChart.View3D)
  else
     inherited
end;

procedure TCustomSeries.LinePrepareCanvas(tmpCanvas:TCanvas3D; tmpColor:TColor);
begin
  with tmpCanvas do
  begin
    if MonoChrome then tmpColor:=clWhite;

    if ParentChart.View3D then
    begin
      if Assigned(Self.Brush.Image.Graphic) then
         Brush.Bitmap:=Self.Brush.Image.Bitmap
      else
      begin
        Brush.Style:=LineBrush;
        Brush.Color:=tmpColor;
      end;

      AssignVisiblePen(LinePen);
    end
    else
    begin
      Brush.Style:=bsClear;
      AssignVisiblePenColor(LinePen,tmpColor);
    end;

    ParentChart.CheckPenWidth(tmpCanvas.Pen);
  end;
end;

Procedure TCustomSeries.SetParentChart(Const Value:TCustomAxisPanel);
begin
  inherited;
  if Assigned(FPointer) then FPointer.ParentChart:=Value;
end;

Function TCustomSeries.GetAreaBrushColor(AColor:TColor):TColor;
begin
  if ColorEachPoint or (FAreaColor=clTeeColor) then
     result:=AColor
  else
     result:=FAreaColor;
end;

procedure TCustomSeries.DrawValue(ValueIndex:Integer);
Var x : Integer;
    y : Integer;

  { calculate vertical pixel }
  Function CalcYPosLeftRight(Const YLimit:Double; AnotherIndex:Integer):Integer;
  var tmpPredValueX : Double;
      tmpPredValueY : Double;
      tmpDif        : Double;
  begin
    tmpPredValueX:=XValues.Value[AnotherIndex];
    tmpDif:=XValues.Value[ValueIndex]-tmpPredValueX;
    With ParentChart do
    if tmpDif=0 then result:=CalcYPos(AnotherIndex)
    else
    begin
      tmpPredValueY:=YValues.Value[AnotherIndex];
      result:=CalcYPosValue( 1.0*tmpPredValueY+(YLimit-tmpPredValueX)*
                             (YValues.Value[ValueIndex]-tmpPredValueY)/tmpDif );
    end;
  end;

var tmpColor    : TColor;
    IsLastValue : Boolean;

   Procedure InternalDrawArea(BrushColor:TColor);

     Function RectFromPoints(const P:TFourPoints):TRect;
     begin
       with result do
       begin
         Left  :=Math.Min(P[3].X,Math.Min(P[2].X,Math.Min(P[0].X,P[1].X)));
         Top   :=Math.Min(P[3].Y,Math.Min(P[2].Y,Math.Min(P[0].Y,P[1].Y)));
         Right :=Math.Max(P[3].X,Math.Max(P[2].X,Math.Max(P[0].X,P[1].X)));
         Bottom:=Math.Max(P[3].Y,Math.Max(P[2].Y,Math.Max(P[0].Y,P[1].Y)));
       end;

       if ParentChart.View3D then
          result:=ParentChart.Canvas.CalcRect3D(result,StartZ); { 5.03 }
     end;

   var tmpY      : Integer;
       tmpBottom : Integer;
       tmpR      : TRect;
       tmpBlend  : TTeeBlend;
       tmpP      : TFourPoints;
       tmpMax    : Integer;
       tmpMin    : Integer;
       tmpColor2 : TColor;
   begin
     With ParentChart do
     Begin
       tmpColor2:=AreaChartBrush.Color;
       if AreaChartBrush.Color=clTeeColor then tmpColor2:=SeriesColor;
       SetBrushCanvas(BrushColor,FAreaBrush,tmpColor2);

       if View3D and IsLastValue then { to-do: not always ! }
          if YMandatory then
             Canvas.RectangleZ(X,Y,BottomPos,StartZ,EndZ)
          else
             Canvas.RectangleY(X,Y,BottomPos,StartZ,EndZ);

       if Stairs then
       begin
         if FInvertedStairs then
         begin
           if YMandatory then tmpY:=Y
                         else tmpY:=X;
           tmpBottom:=BottomPos;
         end
         else
         begin
           if YMandatory then tmpY:=OldY
                         else tmpY:=OldX;
           tmpBottom:=OldBottomPos;
         end;

         if YMandatory then tmpR:=TeeRect(OldX,tmpBottom,X+1,tmpY)
                       else tmpR:=TeeRect(tmpBottom,OldY+1,tmpY+1,Y);

         With Canvas do
         begin
           if Transparency>0 then
              if View3D then
                 tmpBlend:=BeginBlending(RectFromRectZ(tmpR,StartZ),Transparency)  // 6.01
              else
                 tmpBlend:=BeginBlending(tmpR,Transparency)  // 6.01
           else
              tmpBlend:=nil;

           if View3D then
           begin
             RectangleWithZ(tmpR,StartZ);
             if SupportsFullRotation then RectangleWithZ(tmpR,EndZ);
           end
           else
           begin
             if FGradient.Visible then
             begin
               FGradient.Draw(Canvas,tmpR);  // 5.03
               if Pen.Style<>psClear then
               begin
                 Brush.Style:=bsClear;
                 Rectangle(tmpR);
               end;
             end
             else Rectangle(tmpR);
           end;

           if Transparency>0 then
              EndBlending(tmpBlend);
         end;


         if LinePen.Visible and (not AreaLinesPen.Visible) then
         begin
           Canvas.AssignVisiblePen(LinePen);
           if YMandatory then
              if InvertedStairs then
              begin
                Canvas.LineWithZ(OldX,Y,X,Y,StartZ);
                Canvas.LineWithZ(OldX,OldY,OldX,Y,StartZ);
              end
              else
              begin
                Canvas.LineWithZ(OldX,OldY,X,OldY,StartZ);
                Canvas.LineWithZ(X-1,OldY,X-1,Y,StartZ);
              end
           else
              if InvertedStairs then
              begin
                Canvas.LineWithZ(X,OldY,X,Y,StartZ);
                Canvas.LineWithZ(OldX,OldY,X,OldY,StartZ);
              end
              else
              begin
                Canvas.LineWithZ(OldX,OldY,OldX,Y,StartZ);
                Canvas.LineWithZ(OldX,Y,X,Y,StartZ);
              end;
         end;

       end
       else // not in "stairs" mode...
       With Canvas do
       begin

         if YMandatory then
         begin
           tmpP[0]:=TeePoint(OldX,OldBottomPos);
           tmpP[3]:=TeePoint(X,BottomPos);
         end
         else
         begin
           tmpP[0]:=TeePoint(OldBottomPos,OldY);
           tmpP[3]:=TeePoint(BottomPos,Y);
         end;

         tmpP[1]:=TeePoint(OldX,OldY);
         tmpP[2]:=TeePoint(X,Y);

         if Transparency>0 then
            tmpBlend:=Canvas.BeginBlending(RectFromPoints(tmpP),Transparency)
         else
            tmpBlend:=nil;

         if View3D then
         begin
           if FGradient.Visible then FGradient.Draw(Canvas,tmpP,StartZ)
                                else PlaneWithZ(tmpP,StartZ);
         end
         else // 5.02
         begin
           if FGradient.Visible then { 5.03 }
           begin
             ClipPolygon(Canvas,tmpP,4);

             tmpMax:=CalcPosValue(MandatoryValueList.MaxValue);
             tmpMin:=CalcPosValue(MandatoryValueList.MinValue);

             if YMandatory then tmpR:=TeeRect(OldX,tmpMax,X,tmpMin)
                           else tmpR:=TeeRect(tmpMin,OldY,tmpMax,Y);

             FGradient.Draw(Canvas,tmpR);
             UnClipRectangle;

             Brush.Style:=bsClear;

             if Pen.Style<>psClear then
                if YMandatory then DoVertLine(OldX,OldY,OldBottomPos)
                              else DoHorizLine(OldBottomPos,OldX,OldY);

           end
           else Polygon(tmpP);
         end;

         if Transparency>0 then
            Canvas.EndBlending(tmpBlend);

         if SupportsFullRotation then PlaneWithZ(tmpP,EndZ);

         if LinePen.Visible then
         begin
           AssignVisiblePen(LinePen);
           LineWithZ(OldX,OldY,X,Y,StartZ);
         end;
       end;
     end;
   end;

   Procedure DrawPoint(DrawOldPointer:Boolean);
   var tmpPoint     : TPoint;
       tmpOldP      : TPoint;
       tmpDifX      : Integer;
       P4           : TFourPoints;
       OldDarkColor : TColor;
       tmpDark3D    : Boolean;
   begin
     if ((x<>OldX) or (y<>OldY)) and (tmpColor<>clNone) then { <-- if not null }
     with ParentChart,Canvas do
     begin
       if View3D then
       Begin
         { 3D }
         if DrawArea or FDrawLine then
         Begin

           AssignVisiblePen(LinePen);
           if LinePen.Visible then CheckPenWidth(Pen);

           if ColorEachLine or DrawArea then
              OldDarkColor:=GetAreaBrushColor(tmpColor)
           else
              OldDarkColor:=SeriesColor;  // 6.01

           if Brush.Color<>OldDarkColor then
              Brush.Color:=OldDarkColor;

           if Brush.Style<>LineBrush then
              Brush.Style:=LineBrush;

           if Assigned(Self.Brush.Image.Graphic) then
              Brush.Bitmap:=Self.Brush.Image.Bitmap;

           tmpPoint.X:=X;
           tmpPoint.Y:=Y;
           tmpOldP.X :=OldX;
           tmpOldP.Y :=OldY;

           if Stairs then
           Begin
             if FInvertedStairs then { or LastValue=FirstValueIndex }
             begin
               if FDark3D then Brush.Color:=ApplyDark(Brush.Color,DarkColorQuantity);

               if YMandatory then
                  RectangleZ( tmpOldP.X,tmpOldP.Y, Y,StartZ,EndZ)
               else
                  RectangleY( tmpPoint.X, tmpPoint.Y,OldX,StartZ,EndZ);

               if FDark3D then Brush.Color:=OldDarkColor;

               if YMandatory then
                  RectangleY( tmpPoint.X, tmpPoint.Y,OldX,StartZ,EndZ)
               else
                  RectangleZ( X, tmpOldP.Y, Y, StartZ, EndZ);
             end
             else
             begin
               if YMandatory then
                  RectangleY( tmpOldP.X, tmpOldP.Y, X, StartZ, EndZ)
               else
                  RectangleZ( OldX, tmpOldP.Y, Y, StartZ, EndZ);

               if FDark3D then Brush.Color:=ApplyDark(Brush.Color,DarkColorQuantity);

               if YMandatory then
                  RectangleZ( tmpPoint.X,tmpPoint.Y, OldY,StartZ,EndZ)
               else
                  RectangleY( OldX, tmpPoint.Y, X,StartZ,EndZ);

               if FDark3D then Brush.Color:=OldDarkColor;
             end;
           end
           else
           begin
             if (FLineHeight>0) and (not FDrawArea) then
             begin
               P4[0]:=tmpPoint;
               P4[1]:=tmpOldP;
               P4[2].X:=tmpOldP.X;
               P4[2].Y:=tmpOldP.Y+FLineHeight;
               P4[3].X:=tmpPoint.X;
               P4[3].Y:=tmpPoint.Y+FLineHeight;
               PlaneFour3D(P4,StartZ,StartZ);
               if IsLastValue then
                  RectangleZ(tmpPoint.X,tmpPoint.Y,tmpPoint.Y+FLineHeight,StartZ,EndZ);
             end;

             tmpDark3D:=FDark3D and (not SupportsFullRotation);
             if tmpDark3D then
             begin
               tmpDifX:=tmpPoint.X-tmpOldP.X;
               if (tmpDifX<>0) and
                  (tmpDark3DRatio<>0) and
                  ((tmpOldP.Y-tmpPoint.Y)/tmpDifX > tmpDark3DRatio) then
               begin
                 Brush.Color:=ApplyDark(Brush.Color,DarkColorQuantity);
                 if (FLineHeight>0) and (not FDrawArea) then {special case}
                 begin
                   Inc(tmpPoint.Y,FLineHeight);
                   Inc(tmpOldP.Y,FLineHeight);
                 end;
               end;
             end;

             if Monochrome then Brush.Color:=clWhite;

             Plane3D(tmpPoint,tmpOldP,StartZ,EndZ);

             if tmpDark3D then Brush.Color:=OldDarkColor;
           end;
         end;
       end;

       if DrawArea then
       Begin { area }
         Brush.Color:=GetAreaBrushColor(tmpColor);

         if (FAreaLinesPen.Color=clTeeColor) or (not FAreaLinesPen.Visible) then
            AssignVisiblePenColor(FAreaLinesPen,tmpColor)
         else
            AssignVisiblePen(FAreaLinesPen);

         InternalDrawArea(Brush.Color);
       end
       else
       if (not View3D) and FDrawLine then
       Begin { line 2D }
         if ColorEachLine then LinePrepareCanvas(Canvas,tmpColor)
                          else LinePrepareCanvas(Canvas,SeriesColor);

         if Stairs then
         begin
           if FInvertedStairs then DoVertLine(OldX,OldY,Y)
                              else DoHorizLine(OldX,X,OldY);
           LineTo(X,Y);
         end
         else Line(OldX,OldY,X,Y);
       end;
     end;

     { pointers }
     if FPointer.Visible and DrawOldPointer then
     begin
       if OldColor<>clNone then { <-- if not null }
          DrawPointer(OldX,OldY,OldColor,Pred(ValueIndex));

       if IsLastValue and (tmpColor<>clNone) then {<-- if not null }
          DrawPointer(X,Y,tmpColor,ValueIndex);
     end;
   end;

var tmpFirst : Integer;
Begin
  With ParentChart.Canvas do
  Begin
    tmpColor:=ValueColor[ValueIndex];
    X:=CalcXPos(ValueIndex);
    Y:=CalcYPos(ValueIndex);

    if Pen.Color<>clBlack then { 5.02 }
       Pen.Color:=clBlack;

    if tmpColor<>Brush.Color then { 5.02 }
       Brush.Color:=tmpColor;

    if OldColor=clNone then { if null }
    begin
      OldX:=X;
      OldY:=Y;
    end;

    BottomPos:=GetOriginPos(ValueIndex);

    if DrawValuesForward then
    begin
      tmpFirst:=FirstValueIndex;
      IsLastValue:=ValueIndex=LastValueIndex;
    end
    else
    begin
      tmpFirst:=LastValueIndex;
      IsLastValue:=ValueIndex=FirstValueIndex;
    end;

    if ValueIndex=tmpFirst then { first point }
    Begin
      if FDark3D then
      With ParentChart do
         if SeriesWidth3D<>0 then
            tmpDark3DRatio:=Abs(SeriesHeight3D/SeriesWidth3D)
         else
            tmpDark3DRatio:=1;

      if (tmpFirst=FirstValueIndex) and (ValueIndex>0) then
      Begin  { previous point outside left }
        if FDrawArea then
        begin
          OldX:=CalcXPos(Pred(ValueIndex));
          OldY:=CalcYPos(Pred(ValueIndex));
          OldBottomPos:=GetOriginPos(Pred(ValueIndex));
        end
        else
        begin
          if GetHorizAxis.Inverted then OldX:=ParentChart.ChartRect.Right
                                   else OldX:=ParentChart.ChartRect.Left;

          if Stairs Then
             OldY:=CalcYPos(Pred(ValueIndex))
          else
          // fix 6.0 (from Kayhan YAL�IN kayhan.yalcin@finnet.gen.tr)
          if not GetVertAxis.Logarithmic then
             OldY:=CalcYPosLeftRight(GetHorizAxis.CalcPosPoint(OldX),Pred(ValueIndex))
          else
          begin
            OldX:=CalcXPos(Pred(ValueIndex));
            OldY:=CalcYPos(Pred(ValueIndex));
          end;

        end;

        if not IsNull(Pred(ValueIndex)) then DrawPoint(False);
      end;

      if IsLastValue and FPointer.Visible then
         DrawPointer(X,Y,tmpColor,ValueIndex);

      if SupportsFullRotation and FDrawArea and ParentChart.View3D then
         RectangleZ(X,Y,BottomPos,StartZ,EndZ);
    end
    else DrawPoint(True);

    OldX:=X;
    OldY:=Y;
    OldBottomPos:=BottomPos;
    OldColor:=tmpColor;
  end;
end;

Procedure TCustomSeries.DrawPointer(AX,AY:Integer; AColor:TColor; ValueIndex:Integer);
var tmpStyle : TSeriesPointerStyle;
begin
  TPointerAccess(FPointer).PrepareCanvas(ParentChart.Canvas,AColor);
  if Assigned(FOnGetPointerStyle) then tmpStyle:=FOnGetPointerStyle(Self,ValueIndex)
                                  else tmpStyle:=FPointer.Style;
  FPointer.Draw(AX,AY,AColor,tmpStyle);
end;

class Function TCustomSeries.GetEditorClass:String;
Begin
  result:='TCustomSeriesEditor'; { <-- dont translate ! }
end;

Procedure TCustomSeries.InternalCalcMargin(SameSide,Horizontal:Boolean; var A,B:Integer);
var tmp : Integer;
begin
  if Horizontal then
     TPointerAccess(FPointer).CalcHorizMargins(A,B)
  else
     TPointerAccess(FPointer).CalcVerticalMargins(A,B);

  if FDrawLine then
  begin
    if Stairs then
    begin
      A:=Math.Max(A,LinePen.Width);
      B:=Math.Max(B,LinePen.Width);
    end;

    if OutLine.Visible then { 5.02 }
    begin
      A:=Math.Max(A,OutLine.Width);
      B:=Math.Max(B,OutLine.Width);
    end;
  end;

  if Marks.Visible and SameSide then
  begin
    tmp:=Marks.Callout.Length+Marks.Callout.Distance;
    if YMandatory then A:=Math.Max(B,tmp)
                  else B:=Math.Max(A,tmp);
  end;
end;

Procedure TCustomSeries.CalcHorizMargins(Var LeftMargin,RightMargin:Integer);
begin
  inherited;
  InternalCalcMargin(not YMandatory,True,LeftMargin,RightMargin);
end;

Procedure TCustomSeries.CalcVerticalMargins(Var TopMargin,BottomMargin:Integer);
begin
  inherited;
  InternalCalcMargin(YMandatory,False,TopMargin,BottomMargin);

  if (LineHeight>0) and (not DrawArea) and ParentChart.View3D then
     if LineHeight>BottomMargin then BottomMargin:=LineHeight;
end;

Procedure TCustomSeries.SetDark3D(Value:Boolean);
begin
  SetBooleanProperty(FDark3D,Value);
end;

Procedure TCustomSeries.CalcZOrder;
Begin
  if FStacked=cssNone then inherited
                      else IZOrder:=ParentChart.MaxZOrder;
End;

Function TCustomSeries.PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double;
var t         : Integer;
    tmpSeries : TChartSeries;
    tmp       : Double;
Begin
  result:=0;
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
  Begin
    tmpSeries:=Series[t];
    if (not SumAll) and (tmpSeries=Self) then Break
    else
    With tmpSeries do
    if Active and SameClass(Self) and (Count>ValueIndex) then
    begin
      tmp:=GetOriginValue(ValueIndex);
      if tmp>0 then result:=result+tmp;
    end;
  end;
end;

Function TCustomSeries.CalcStackedPos(ValueIndex:Integer; Value:Double):Integer;

  Function AxisPosition:Integer;
  begin
    if YMandatory then result:=GetVertAxis.IEndPos
                  else result:=GetHorizAxis.IEndPos
  end;

var tmp : Double;
begin
  Value:=Value+PointOrigin(ValueIndex,False);
  if FStacked=cssStack then
     result:=Math.Min(AxisPosition,CalcPosValue(Value))
  else
  begin
    tmp:=PointOrigin(ValueIndex,True);
    if tmp<>0 then result:=CalcPosValue(Value*100.0/tmp)
              else result:=AxisPosition;
  end;
end;

Function TCustomSeries.GetOriginPos(ValueIndex:Integer):Integer;
Begin
  if (FStacked=cssNone) or (FStacked=cssOverlap) then
     if YMandatory then
     begin
       with GetVertAxis do
       if Inverted then result:=IStartPos else result:=IEndPos;
     end
     else
     begin
       with GetHorizAxis do
       if Inverted then result:=IEndPos else result:=IStartPos;
     end
  else
     result:=CalcStackedPos(ValueIndex,0);
end;

Function TCustomSeries.MaxXValue:Double;
var t : Integer;
Begin
  if YMandatory then result:=inherited MaxXValue
  else
  begin
    if FStacked=cssStack100 then result:=100
    else
    begin
      result:=inherited MaxXValue;
      if FStacked=cssStack then
      for t:=0 to Count-1 do
          result:=Math.Max(result,PointOrigin(t,False)+XValues.Value[t]);
    end;
  end;
end;

Function TCustomSeries.MinXValue:Double;
Begin
  if (not YMandatory) and (FStacked=cssStack100) then
     result:=0
  else
     result:=inherited MinXValue;
end;

Function TCustomSeries.MaxYValue:Double;
var t : Integer;
Begin
  if not YMandatory then result:=inherited MaxYValue
  else
  begin
    if FStacked=cssStack100 then result:=100
    else
    begin
      result:=inherited MaxYValue;
      if FStacked=cssStack then
      for t:=0 to Count-1 do
          result:=Math.Max(result,PointOrigin(t,False)+YValues.Value[t]);
    end;
  end;
end;

Function TCustomSeries.MinYValue:Double;
Begin
  if YMandatory and (FStacked=cssStack100) then
     result:=0
  else
     result:=inherited MinYValue;
end;

Function TCustomSeries.CalcXPos(ValueIndex:Integer):Integer;
Begin
  if (YMandatory) or (FStacked=cssNone) or (FStacked=cssOverlap) then
     result:=inherited CalcXPos(ValueIndex)
  else
     result:=CalcStackedPos(ValueIndex,XValues.Value[ValueIndex]);
end;

Function TCustomSeries.CalcYPos(ValueIndex:Integer):Integer;
Begin
  if (not YMandatory) or (FStacked=cssNone) or (FStacked=cssOverlap) then
     result:=inherited CalcYPos(ValueIndex)
  else
     result:=CalcStackedPos(ValueIndex,YValues.Value[ValueIndex]);
end;

procedure TCustomSeries.SetStacked(Value: TCustomSeriesStack);

  Procedure SetOther;
  var t : Integer;
  Begin
    if Assigned(ParentChart) then
    with ParentChart do
    for t:=0 to SeriesCount-1 do
      if Self is Series[t].ClassType then
         TCustomSeries(Series[t]).FStacked:=FStacked;
  end;

Begin
  if Value<>FStacked then
  Begin
    FStacked:=Value;
    SetOther;
    Repaint;
  end;
end;

function TCustomSeries.GetAreaBrush: TBrushStyle;
begin
  result:=FAreaBrush.Style;
end;

procedure TCustomSeries.SetAreaBrush(Value: TChartBrush);
begin
  FAreaBrush.Assign(Value);
end;

procedure TCustomSeries.SetColorEachLine(const Value: Boolean);
begin
  SetBooleanProperty(FColorEachLine,Value);
end;

procedure TCustomSeries.SetOutLine(const Value: TChartHiddenPen);
begin
  FOutLine.Assign(Value);
end;

procedure TCustomSeries.DrawAllValues;
var tmpPen   : TChartPen;
    tmpColor : TColor;
begin
  if OutLine.Visible then { 5.02 }
  begin
    tmpPen:=TChartPen.Create(nil);
    try
      tmpPen.Assign(LinePen);
      LinePen.Assign(OutLine);
      tmpColor:=SeriesColor;
      SeriesColor:=OutLine.Color;
      LinePen.Width:=LinePen.Width+OutLine.Width+2;
      inherited;
      LinePen.Assign(tmpPen);
      SeriesColor:=tmpColor;
    finally
      tmpPen.Free;
    end;
  end;
  inherited;
end;

procedure TCustomSeries.SetTransparency(const Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    Repaint;
  end;
end;

procedure TCustomSeries.SetGradient(Value: TChartGradient);
begin
  FGradient.Assign(Value);
end;

{ TLineSeries }
Constructor TLineSeries.Create(AOwner: TComponent);
Begin
  inherited;
  FDrawLine:=True;
  AllowSinglePoint:=False;
  FPointer.Visible:=False;
end;

Procedure TLineSeries.PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                           Var BrushStyle:TBrushStyle);
Begin
  ParentChart.Canvas.AssignVisiblePen(LinePen);
  BrushStyle:=LineBrush;
end;

Procedure TLineSeries.Assign(Source:TPersistent);
begin
  inherited;
  if not (Source is Self.ClassType) then FPointer.Visible:=False;
  FDrawArea:= False;
  FDrawLine:= True;
end;

class Procedure TLineSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TLineSeries(ASeries) do
  Case Index of
    1: Stairs:=True;
    2: Pointer.Visible:=True;
    3: LineHeight:=5;
    4: LineBrush:=bsClear;
    5: ColorEachPoint:=True;
    6: Marks.Visible:=True;
    7: Pen.Visible:=False;
  end;
end;

class Procedure TLineSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Stairs);
  AddSubChart(TeeMsg_Points);
  AddSubChart(TeeMsg_Height);
  AddSubChart(TeeMsg_Hollow);
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_NoBorder);
end;

{ THorizLineSeries }
Constructor THorizLineSeries.Create(AOwner: TComponent);
begin
  inherited;
  SetHorizontal;
  CalcVisiblePoints:=False; { avoid bug first point and scroll }
  XValues.Order:=loNone;
  YValues.Order:=loAscending;
end;

{ TPointSeries }
Constructor TPointSeries.Create(AOwner: TComponent);
Begin
  inherited;
  SetFixed;
  Marks.Callout.Length:=0;
end;

Procedure TPointSeries.Assign(Source:TPersistent);
begin
  inherited;
  SetFixed;
end;

Procedure TPointSeries.SetFixed;
begin
  FPointer.Visible :=True;
  FDrawArea        :=False;
  FDrawLine        :=False;
  ClickableLine    :=False;
end;

class Function TPointSeries.GetEditorClass:String;
begin
  result:='TSeriesPointerEditor'; { <-- do not translate }
end;

Procedure TPointSeries.PrepareForGallery(IsEnabled:Boolean);
var tmp : Integer;
begin
  inherited;
  With ParentChart do
  begin
    if Width<50 then tmp:=4
                else tmp:=6;
    Pointer.HorizSize:=tmp;
    Pointer.VertSize:=tmp;
    if (SeriesCount>1) and (Self=Series[1]) then Pointer.Style:=psTriangle;
  end;
end;

Procedure TPointSeries.SetColorEachPoint(Value:Boolean);
begin
  inherited;
  if Value then Pointer.Color:=clTeeColor;
end;

class Procedure TPointSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_Hollow);
  AddSubChart(TeeMsg_NoBorder);
  AddSubChart(TeeMsg_Gradient);
  if CanDoExtra then
  begin
    AddSubChart(TeeMsg_Point2D);
    AddSubChart(TeeMsg_Triangle);
    AddSubChart(TeeMsg_Star);
    AddSubChart(TeeMsg_Circle);
    AddSubChart(TeeMsg_DownTri);
    AddSubChart(TeeMsg_Cross);
    AddSubChart(TeeMsg_Diamond);
  end;
end;

class Procedure TPointSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TPointSeries(ASeries) do
  Case Index of
    1: ColorEachPoint:=True;
    2: Marks.Visible:=True;
    3: Pointer.Brush.Style:=bsClear;
    4: Pointer.Pen.Visible:=False;
    5: Pointer.Gradient.Visible:=True;
  else
  if CanDoExtra then
    Case Index of
      6: Pointer.Draw3D:=False;
      7: Pointer.Style:=psTriangle;
      8: Pointer.Style:=psStar;
      9: With Pointer do
         begin
           Style:=psCircle;
           HorizSize:=8;
           VertSize:=8;
         end;
     10: Pointer.Style:=psDownTriangle;
     11: Pointer.Style:=psCross;
     12: Pointer.Style:=psDiamond;
    end;
  end;
end;

class function TPointSeries.CanDoExtra: Boolean;
begin
  result:=True;
end;

{ TAreaSeries }
Constructor TAreaSeries.Create(AOwner: TComponent);
Begin
  inherited;
  FDrawArea:=True;
  AllowSinglePoint:=False;
  FPointer.Visible:=False;
end;

Procedure TAreaSeries.PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                           Var BrushStyle:TBrushStyle);
Begin
  BackColor:=GetAreaBrushColor(ParentChart.Canvas.Brush.Color);
  ParentChart.Canvas.AssignVisiblePen(FAreaLinesPen);
  BrushStyle:=FAreaBrush.Style;
end;

Procedure TAreaSeries.Assign(Source:TPersistent);
begin
  inherited;
  FDrawArea:=True;
  FDrawLine:=True;
  if (Source is Self.ClassType) or (Self is Source.ClassType) then
  With TAreaSeries(Source) do
  begin
    Self.FUseOrigin :=UseYOrigin;
    Self.FOrigin    :=YOrigin;
  end
  else FPointer.Visible:=False;
end;

class Function TAreaSeries.GetEditorClass:String;
Begin
  result:='TAreaSeriesEditor'; { <-- dont translate ! }
end;

function TAreaSeries.GetMultiArea: TMultiArea;
begin
  Case Stacked of
    cssStack: result:=maStacked;
    cssStack100: result:=maStacked100;
  else
    result:=maNone;
  end;
end;

Procedure TAreaSeries.SetMultiArea(Value:TMultiArea);
Begin
  if Value<>MultiArea then
  Case Value of
    maNone      : Stacked:=cssNone;
    maStacked   : Stacked:=cssStack;
    maStacked100: Stacked:=cssStack100;
  end;
End;

class Procedure TAreaSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Stairs);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Hollow);
  AddSubChart(TeeMsg_NoLines);
//  AType.NumGallerySeries:=2;
  AddSubChart(TeeMsg_Stack);
  AddSubChart(TeeMsg_Stack100);
//  AType.NumGallerySeries:=1;
  AddSubChart(TeeMsg_Points);
  AddSubChart(TeeMsg_Gradient);
end;

class Procedure TAreaSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TAreaSeries(ASeries) do
  Case Index of
    1: Stairs:=True;
    2: Marks.Visible:=True;
    3: ColorEachPoint:=True;
    4: AreaBrush:=bsClear;
    5: AreaLinesPen.Visible:=False;
    6: MultiArea:=maStacked;
    7: MultiArea:=maStacked100;
    8: Pointer.Visible:=True;
    9: Gradient.Visible:=True;
  end;
end;

Function TAreaSeries.DrawSeriesForward(ValueIndex:Integer):Boolean;
begin
  if MultiArea=maNone then
     result:=inherited DrawSeriesForward(ValueIndex)
  else
  if YMandatory then result:=(not GetVertAxis.Inverted)
                else result:=(not GetHorizAxis.Inverted);
end;

procedure TAreaSeries.SetOrigin(const Value: Double);
begin
  SetDoubleProperty(FOrigin,Value)
end;

procedure TAreaSeries.SetUseOrigin(Value: Boolean);
begin
  SetBooleanProperty(FUseOrigin,Value)
end;

function TAreaSeries.MaxXValue: Double;
begin
  result:=inherited MaxXValue;
  if (not YMandatory) and UseYOrigin and (result<YOrigin) then result:=YOrigin;
end;

function TAreaSeries.MinXValue: Double;
begin
  result:=inherited MinXValue;
  if (not YMandatory) and UseYOrigin and (result>YOrigin) then result:=YOrigin;
end;

function TAreaSeries.MaxYValue: Double;
begin
  result:=inherited MaxYValue;
  if YMandatory and UseYOrigin and (result<YOrigin) then result:=YOrigin;
end;

function TAreaSeries.MinYValue: Double;
begin
  result:=inherited MinYValue;
  if YMandatory and UseYOrigin and (result>YOrigin) then result:=YOrigin;
end;

function TAreaSeries.GetOriginPos(ValueIndex: Integer): Integer;
begin
  if UseYOrigin then result:=CalcPosValue(YOrigin)
                else result:=inherited GetOriginPos(ValueIndex);
end;

procedure TAreaSeries.DrawLegendShape(ValueIndex: Integer;
  const Rect: TRect);
begin
  if FGradient.Visible then
     FGradient.Draw(ParentChart.Canvas,Rect)
  else
     inherited;
end;

{ THorizAreaSeries }
Constructor THorizAreaSeries.Create(AOwner: TComponent);
begin
  inherited;
  SetHorizontal;
//  CalcVisiblePoints:=False; { avoid bug first point and scroll }
  XValues.Order:=loNone;
  YValues.Order:=loAscending;
  FGradient.Direction:=gdRightLeft;
end;

procedure THorizAreaSeries.DrawMark(ValueIndex: Integer; const St: String;
  APosition: TSeriesMarkPosition);
var DifH : Integer;
    DifW : Integer;
begin
  With APosition do
  begin
    DifH:=Height div 2;

    DifW:=Marks.Callout.Length+Marks.Callout.Distance;

    LeftTop.Y:=ArrowTo.Y-DifH;

    Inc(LeftTop.X,DifW+(Width div 2));

    Inc(ArrowTo.X,DifW);

    ArrowFrom.Y:=ArrowTo.Y;
    Inc(ArrowFrom.X,Marks.Callout.Distance);
  end;

  inherited;
end;

function THorizAreaSeries.NumSampleValues: Integer;
begin
  result:=10;
end;

{ TBarSeriesGradient }
procedure TBarSeriesGradient.SetRelative(const Value: Boolean);
begin
  if Relative<>Value then
  begin
    FRelative:=Value;
    Changed(Self);
  end;
end;

{ TCustomBarSeries }
Constructor TCustomBarSeries.Create(AOwner:TComponent);
Begin
  inherited;
  FBarWidthPercent:=70;
  FBarStyle:=bsRectangle;

  FGradient:=TBarSeriesGradient.Create(CanvasChanged);
  FGradient.Visible:=True; { 5.02 }

  FBevelSize:=1;
  FUseOrigin:=True;
  FMultiBar:=mbSide;
  FAutoMarkPosition:=True;
  Marks.Visible:=True;
  Marks.Callout.Length:=20;
  FDark3D:=True;
  FSideMargins:=True;
end;

Destructor TCustomBarSeries.Destroy;
begin
  FGradient.Free;
  inherited;
end;

Procedure TCustomBarSeries.CalcZOrder;
Var t         : Integer;
    tmpZOrder : Integer;
Begin
  if FMultiBar=mbNone then inherited
  else
  begin
    tmpZOrder:=-1;
    With ParentChart do
    for t:=0 to SeriesCount-1 do
    if Series[t].Active then
    begin
      if Series[t]=Self then break
      else
      if SameClass(Series[t]) then
      Begin
        tmpZOrder:=Series[t].ZOrder;
        break;
      end;
    end;
    if tmpZOrder=-1 then inherited
                    else IZOrder:=tmpZOrder;
  end;
End;

Function TCustomBarSeries.NumSampleValues:Integer;
var t : Integer;
Begin
  result:=6; { default number of BarSeries random sample values }
  if Assigned(ParentChart) and (ParentChart.SeriesCount>1) then
     for t:=0 to ParentChart.SeriesCount-1 do
     if (ParentChart[t]<>Self) and
        (ParentChart[t] is TCustomBarSeries) and
        (ParentChart[t].Count>0) then
     begin
       result:=ParentChart[t].Count;
       break;
     end;
end;

Procedure TCustomBarSeries.SetBarWidthPercent(Value:Integer);
Begin
  SetIntegerProperty(FBarWidthPercent,Value);
end;

Procedure TCustomBarSeries.SetOffsetPercent(Value:Integer);
Begin
  SetIntegerProperty(FOffsetPercent,Value);
End;

Procedure TCustomBarSeries.SetCustomBarSize(Value:Integer);
Begin
  SetIntegerProperty(FCustomBarSize,Value);
end;

Procedure TCustomBarSeries.SetParentChart(Const Value:TCustomAxisPanel);
begin
  inherited;
  SetOtherBars(False);
end;

Procedure TCustomBarSeries.SetBarStyle(Value:TBarStyle);
Begin
  if FBarStyle<>Value then
  begin
    FBarStyle:=Value;
    Repaint;
  end;
end;

{ If more than one bar series exists in chart,
  which position are we? the first, the second, the third? }
Procedure TCustomBarSeries.DoBeforeDrawChart;
var Groups : Array of Integer;

  Function NewGroup(AGroup:Integer):Boolean;
  var t : Integer;
  begin
    for t:=0 to Length(Groups)-1 do
    if Groups[t]=AGroup then
    begin
      result:=False;
      exit;
    end;
    SetLength(Groups,Length(Groups)+1);
    Groups[Length(Groups)-1]:=AGroup;
    result:=True;
  end;

var t    : Integer;
    Stop : Boolean;
    tmp  : Integer;
begin
  inherited;

  IOrderPos:=1;
  IPreviousCount:=0;
  INumBars:=0;
  IMaxBarPoints:=TeeAllValues;
  Groups:=nil;
  Stop:=False;

  With ParentChart do
  for t:=0 to SeriesCount-1 do
  if Series[t].Active and SameClass(Series[t]) then
  begin
    Stop:=Stop or (Series[t]=Self);
    tmp:=Series[t].Count;

    if (IMaxBarPoints=TeeAllValues) or (tmp>IMaxBarPoints) then
    begin
       IMaxBarPoints:=tmp;
       if FSideMargins then Inc(IMaxBarPoints);
    end;

    Case FMultiBar of
      mbNone: INumBars:=1;
      mbSide,
      mbSideAll: begin
                   Inc(INumBars);
                   if not Stop then Inc(IOrderPos);
                 end;
      mbStacked,
      mbStacked100: if NewGroup(TCustomBarSeries(Series[t]).FStackGroup) then
                    begin
                      Inc(INumBars);
                      if not Stop then Inc(IOrderPos);
                    end;
      mbSelfStack: INumBars:=1;
    end;
    if not Stop then Inc(IPreviousCount,tmp);
  end;

  for t:=0 to Length(Groups)-1 do
  if Groups[t]=FStackGroup then
  begin
    IOrderPos:=t+1;
    break;
  end;
  Groups:=nil;

  { this should be after calculating INumBars }
  if ParentChart.MaxPointsPerPage>0 then
     IMaxBarPoints:=ParentChart.MaxPointsPerPage;
end;

Function TCustomBarSeries.CalcMarkLength(ValueIndex:Integer):Integer;
Begin
  if (Count>0) and Marks.Visible then
  Begin
    ParentChart.Canvas.AssignFont(Marks.Font);
    result:=Marks.Callout.Length+InternalCalcMarkLength(ValueIndex);
    With Marks.Frame do if Visible then Inc(result,2*Width);
  end
  else result:=0;
end;

Procedure TCustomBarSeries.SetUseOrigin(Value:Boolean);
Begin
  SetBooleanProperty(FUseOrigin,Value);
End;

Procedure TCustomBarSeries.SetSideMargins(Value:Boolean);
Begin
  SetBooleanProperty(FSideMargins,Value);
  SetOtherBars(True);
end;

Procedure TCustomBarSeries.SetDark3d(Value:Boolean);
Begin
  SetBooleanProperty(FDark3d,Value);
End;

Procedure TCustomBarSeries.PrepareForGallery(IsEnabled:Boolean);
Begin
  inherited;
  BarWidthPercent:=85;
  MultiBar:=mbNone;
end;

Procedure TCustomBarSeries.SetOrigin(Const Value:Double);
Begin
  SetDoubleProperty(FOrigin,Value);
End;

Function TCustomBarSeries.Clicked(x,y:Integer):Integer;
var t : Integer;
    P : TPoint;
Begin
  if (FirstValueIndex>-1) and (LastValueIndex>-1) then
  begin
    P:=TeePoint(X,Y);
    for t:=FirstValueIndex to Min(LastValueIndex,Count-1) do
    if InternalClicked(t,P) then
    begin
      result:=t;
      exit;
    end;
  end;

  result:=TeeNoPointClicked;
end;

Procedure TCustomBarSeries.SetOtherBars(SetOthers:Boolean);
var t : Integer;
Begin
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
    if SameClass(Series[t]) then
       With TCustomBarSeries(Series[t]) do
       begin
         if SetOthers then
         begin
           FMultiBar:=Self.FMultiBar;
           FSideMargins:=Self.FSideMargins;
         end
         else
         begin
           Self.FMultiBar:=FMultiBar;
           Self.FSideMargins:=FSideMargins;
           break;
         end;
         CalcVisiblePoints:=FMultiBar<>mbSelfStack;
       end;
end;

Procedure TCustomBarSeries.SetMultiBar(Value:TMultiBar);
Begin
  if Value<>FMultiBar then
  Begin
    FMultiBar:=Value;
    SetOtherBars(True);
    Repaint;
  end;
End;

Function TCustomBarSeries.InternalGetOriginPos(ValueIndex:Integer; DefaultOrigin:Integer):Integer;
Var tmp      : Double;
    tmpValue : Double;
Begin
  tmpValue:=PointOrigin(ValueIndex,False);
  Case FMultiBar of
    mbStacked,
    mbSelfStack: result:=CalcPosValue(tmpValue);
    mbStacked100:
      begin
        tmp:=PointOrigin(ValueIndex,True);
        if tmp<>0 then result:=CalcPosValue(tmpValue*100.0/tmp)
                  else result:=0;
      end;
  else
    if FUseOrigin then result:=CalcPosValue(tmpValue)
                  else result:=DefaultOrigin;
  end;
end;

Function TCustomBarSeries.PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double;

  Function InternalPointOrigin:Double;
  var t         : Integer;
      tmpSeries : TChartSeries;
      tmp       : Double;
      tmpValue  : Double;
  Begin
    result:=0;
    tmpValue:=MandatoryValueList.Value[ValueIndex];

    if Assigned(ParentChart) then
    with ParentChart do
    for t:=0 to SeriesCount-1 do
    Begin
      tmpSeries:=Series[t];

      if (not SumAll) and (tmpSeries=Self) then Break
      else
      With tmpSeries do
      if Active and SameClass(Self) and (Count>ValueIndex)
         and (TCustomBarSeries(tmpSeries).StackGroup=Self.StackGroup) then
      begin
        tmp:=GetOriginValue(ValueIndex);
        if tmpValue<0 then
        begin
          if tmp<0 then result:=result+tmp;
        end
        else
          if tmp>0 then result:=result+tmp; { 5.01 }
      end;
    end;
  end;

var t : Integer;
begin
  if (FMultiBar=mbStacked) or
     (FMultiBar=mbStacked100) then
    result:=InternalPointOrigin
  else
  if FMultiBar=mbSelfStack then
  begin
    result:=0;
    for t:=0 to ValueIndex-1 do result:=result+MandatoryValueList.Value[t];
  end
  else
    result:=FOrigin;
End;

Procedure TCustomBarSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);
begin
  if Assigned(BarBrush.Image.Graphic) then
     ParentChart.Canvas.Brush.Bitmap:=BarBrush.Image.Bitmap;
  inherited;
end;

Procedure TCustomBarSeries.PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                                Var BrushStyle:TBrushStyle);
Begin
  ParentChart.Canvas.AssignVisiblePen(BarPen);
  BrushStyle:=BarBrush.Style;
  if BarBrush.Color=clTeeColor then BackColor:=ParentChart.Color
                               else BackColor:=BarBrush.Color;
end;

Procedure TCustomBarSeries.SetPenBrushBar(BarColor:TColor);
var tmpBack : TColor;
Begin
  With ParentChart do
  begin
    Canvas.AssignVisiblePen(BarPen);
    if BarBrush.Color=clTeeColor then tmpBack:=Color
                                 else tmpBack:=BarBrush.Color;
    SetBrushCanvas(BarColor,BarBrush,tmpBack);
  end;
end;

Procedure TCustomBarSeries.BarRectangle( BarColor:TColor;
                                         ALeft,ATop,ARight,ABottom:Integer);
begin
  With ParentChart.Canvas do
  begin
    if Brush.Style=bsSolid then
    Begin
      if (ARight=ALeft) or (ATop=ABottom) then
      Begin
        Pen.Color:=Brush.Color;
        if Pen.Style=psClear then Pen.Style:=psSolid;
        Line(ALeft,ATop,ARight,ABottom);
      end
      else
      if (Abs(ARight-ALeft)<Pen.Width) or
         (Abs(ABottom-ATop)<Pen.Width) then
      Begin
        Pen.Color:=Brush.Color;
        if Pen.Style=psClear then Pen.Style:=psSolid;
        Brush.Style:=bsClear;
      end;
    end;

    Rectangle(ALeft,ATop,ARight,ABottom);
  end;
End;

Function TCustomBarSeries.GetBarStyle(ValueIndex:Integer):TBarStyle;
Begin
  result:=FBarStyle;
  if Assigned(FOnGetBarStyle) then FOnGetBarStyle(Self,ValueIndex,result);
end;

Function TCustomBarSeries.GetBarBrush:TChartBrush;
begin
  result:=Brush;
end;

Function TCustomBarSeries.GetBarPen:TChartPen;
begin
  result:=Pen;
end;

Procedure TCustomBarSeries.SetGradient(Value:TBarSeriesGradient);
begin
  FGradient.Assign(Value);
end;

class Function TCustomBarSeries.GetEditorClass:String;
Begin
  result:='TBarSeriesEditor'; { <-- dont translate ! }
end;

Function TCustomBarSeries.BarMargin:Integer;
Begin
  result:=IBarSize;
  if FMultiBar<>mbSideAll then result:=result*INumBars;
  if not SideMargins then result:=result div 2;
end;

Function TCustomBarSeries.ApplyBarOffset(Position:Integer):Integer;
Begin
  result:=Position;
  if OffsetPercent<>0 then Inc(result,Round(OffsetPercent*IBarSize*0.01));
end;

Procedure TCustomBarSeries.SetAutoMarkPosition(Value:Boolean);
Begin
  SetBooleanProperty(FAutoMarkPosition,Value);
end;

Procedure TCustomBarSeries.SetAutoBarSize(Value:Boolean);
Begin
  SetBooleanProperty(FAutoBarSize,Value);
end;

Procedure TCustomBarSeries.Assign(Source:TPersistent);
begin
  if Source is TCustomBarSeries then
  With TCustomBarSeries(Source) do
  begin
    Self.FAutoMarkPosition:=FAutoMarkPosition;
    Self.FBarWidthPercent:=FBarWidthPercent;
    Self.FBarStyle       :=FBarStyle;
    Self.FBevelSize      :=FBevelSize;
    Self.FCustomBarSize  :=FCustomBarSize;
    Self.FDark3d         :=FDark3D;
    Self.Gradient        :=FGradient;
    Self.FMultiBar       :=FMultiBar;
    Self.FOffsetPercent  :=FOffsetPercent;
    Self.FOrigin         :=FOrigin;
    Self.FSideMargins    :=FSideMargins;
    Self.FStackGroup     :=FStackGroup;
    Self.FTransparency   :=FTransparency;
    Self.FUseOrigin      :=FUseOrigin;
  end;
  inherited;
end;

Function TCustomBarSeries.AddBar( Const AValue:Double;
                                  Const ALabel:String; AColor:TColor):Integer;
begin
  result:=Add(AValue,ALabel,AColor);
end;

Procedure TCustomBarSeries.BarGradient(ValueIndex:Integer; R:TRect);
var P : TFourPoints;
begin
  CalcGradientColor(ValueIndex);

  if ParentChart.View3D then
  begin
    if ParentChart.View3DOptions.Orthogonal then
    begin
      if BarPen.Visible then
      begin
        Inc(R.Left);
        Inc(R.Top);
        Dec(R.Right,BarPen.Width-1);
        Dec(R.Bottom,BarPen.Width-1);
      end;
      R:=ParentChart.Canvas.CalcRect3D(R,StartZ);
    end
    else
    begin
      if BarPen.Visible then
      begin
        Inc(R.Left,BarPen.Width);
        Inc(R.Top,BarPen.Width);
        Dec(R.Right,BarPen.Width);
        Dec(R.Bottom,BarPen.Width);
      end;
      P:=ParentChart.Canvas.FourPointsFromRect(R,StartZ);
      Gradient.Draw(ParentChart.Canvas,P);
      exit;
    end;
  end
  else
  if BarPen.Visible then
  begin
    Inc(R.Left);
    Inc(R.Top);
    Dec(R.Right,BarPen.Width);
    Dec(R.Bottom,BarPen.Width);
  end;

  Gradient.Draw(ParentChart.Canvas,R);
end;

Function TCustomBarSeries.MaxMandatoryValue(Const Value:Double):Double;
var t   : Integer;
    tmp : Double;
begin
  if FMultiBar=mbStacked100 then result:=100
  else
  begin
    result:=Value;

    if FMultiBar=mbSelfStack then result:=MandatoryValueList.Total
    else
    if FMultiBar=mbStacked then
    for t:=0 to Count-1 do
    Begin
      tmp:=PointOrigin(t,False)+MandatoryValueList.Value[t];
      if tmp>result then result:=tmp;
    end;

    if FUseOrigin and (result<FOrigin) then result:=FOrigin;
  end;
end;

Function TCustomBarSeries.MinMandatoryValue(Const Value:Double):Double;
var t   : Integer;
    tmp : Double;
begin
  if FMultiBar=mbStacked100 then result:=0
  else
  begin
    result:=Value;

    if (FMultiBar=mbStacked) or (FMultiBar=mbSelfStack) then
    for t:=0 to Count-1 do
    Begin
      tmp:=PointOrigin(t,False)+MandatoryValueList.Value[t];
      if tmp<result then result:=tmp;
    end;

    if FUseOrigin and (result>FOrigin) then result:=FOrigin;
  end;
end;

Procedure TCustomBarSeries.InternalApplyBarMargin(Var MarginA,MarginB:Integer);

  Procedure CalcBarWidth;
  Var tmpAxis : TChartAxis;
      tmp     : Integer;
  begin
    if FCustomBarSize<>0 then IBarSize:=FCustomBarSize
    else
    if IMaxBarPoints>0 then
    Begin
      if YMandatory then tmpAxis:=GetHorizAxis
                    else tmpAxis:=GetVertAxis;

      With ParentChart,tmpAxis do
      if FAutoBarSize then
         tmp:=Round(IAxisSize/(2.0+Maximum-Minimum))
      else
      begin
        // if SideMargins then Inc(IMaxBarPoints);
        tmp:=IAxisSize div IMaxBarPoints;
      end;

      IBarSize:=Round((FBarWidthPercent*0.01)*tmp) div INumBars;
      if (IBarSize mod 2)=1 then Inc(IBarSize);
    end
    else IBarSize:=0;
  end;

var tmp : Integer;
begin
  CalcBarWidth;
  tmp:=BarMargin;
  Inc(MarginA,tmp);
  Inc(MarginB,tmp);
end;

Procedure TCustomBarSeries.CalcGradientColor(ValueIndex:Integer);
var tmpRatio : Double;
    tmp      : Double;
    T0,T1,T2 : Byte;
    RGB      : TRGBTriple;
begin
  if Gradient.Relative then { 5.02 }
  begin
    with MandatoryValueList do
    begin
      if UseYOrigin then tmp:=YOrigin else tmp:=MinValue;
      tmpRatio:=(Value[ValueIndex]-tmp)/(MaxValue-tmp);
    end;

    T0:=Byte(Gradient.StartColor);
    T1:=Byte(Gradient.StartColor shr 8);
    T2:=Byte(Gradient.StartColor shr 16);

    RGB:=RGBValue(NormalBarColor);

    Gradient.EndColor:=
         (( T0 + Round(tmpRatio*(RGB.rgbtRed-T0))) or
         (( T1 + Round(tmpRatio*(RGB.rgbtGreen-T1)) ) shl 8) or
         (( T2 + Round(tmpRatio*(RGB.rgbtBlue-T2)) ) shl 16));

  end
  else Gradient.EndColor:=NormalBarColor;
end;

class Procedure TCustomBarSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
var tmp : TChartSeries;
begin
  With TCustomBarSeries(ASeries) do
  Case Index of
     0: ;
     1: ColorEachPoint:=True;
     2: BarStyle:=bsPyramid;
     3: BarStyle:=bsEllipse;
     4: BarStyle:=bsInvPyramid;
     5: BarStyle:=bsRectGradient;
  else
  begin
    if Assigned(ParentChart) and
       (ParentChart.SeriesCount=1) then
    begin
      FillsampleValues(2);
      tmp:=ParentChart.AddSeries(TChartSeriesClass(ClassType));
      tmp.Name:=GetNewSeriesName(ParentChart.Owner);
      tmp.Title:=''; { <-- force broadcast event to ChartListBox and others }
      tmp.FillsampleValues(2);
      tmp.Marks.Visible:=False;
      (tmp as TCustomBarSeries).BarWidthPercent:=BarWidthPercent;
      Marks.Visible:=False;
      SetSubGallery(tmp,Index);
    end;

    if not SubGalleryStack then { 5.01 }
       Inc(Index,3);

    Case Index of
       6: MultiBar:=mbStacked;
       7: MultiBar:=mbStacked100;
       8: MultiBar:=mbSelfStack;
       9: MultiBar:=mbSide;
      10: MultiBar:=mbSideAll;
    else inherited;
    end;
  end;
  end;
end;

class Procedure TCustomBarSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Pyramid);
  AddSubChart(TeeMsg_Ellipse);
  AddSubChart(TeeMsg_InvPyramid);
  AddSubChart(TeeMsg_Gradient);

  if SubGalleryStack then { 5.01 }
  begin
    AddSubChart(TeeMsg_Stack);
    AddSubChart(TeeMsg_Stack100);
    AddSubChart(TeeMsg_SelfStack);
  end;

  AddSubChart(TeeMsg_Sides);
  AddSubChart(TeeMsg_SideAll);
end;

procedure TCustomBarSeries.SetStackGroup(Value: Integer);
begin
  SetIntegerProperty(FStackGroup,Value);
end;

procedure TCustomBarSeries.SetConePercent(const Value: Integer);
begin
  SetIntegerProperty(FConePercent,Value);
end;

class function TCustomBarSeries.SubGalleryStack: Boolean;
begin
  result:=True; { 5.01 }
end;

function TCustomBarSeries.CreateBlend: TTeeBlend;
var R  : TRect;
    R1 : TRect;
    R2 : TRect;
begin
  if ParentChart.View3D then
  begin
    R1:=OrientRectangle(ParentChart.Canvas.CalcRect3D(FBarBounds,StartZ));
    R2:=OrientRectangle(ParentChart.Canvas.CalcRect3D(FBarBounds,EndZ));
    UnionRect(R,R1,R2);
  end
  else R:=FBarBounds;

  result:=ParentChart.Canvas.BeginBlending(R,Transparency);
end;

procedure TCustomBarSeries.SetTransparency(const Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    Repaint;
  end;
end;

procedure TCustomBarSeries.DrawBevel;
var tmpR : TRect;
begin
  if ParentChart.View3D and (not ParentChart.View3DOptions.Orthogonal) then
     exit;

  tmpR:=BarBounds;

  if BarPen.Visible then
  begin
    InflateRect(tmpR,-BarPen.Width,-BarPen.Width);

    if ParentChart.View3D and ParentChart.View3DOptions.Orthogonal then
    begin
      Inc(tmpR.Right);
      Inc(tmpR.Bottom);
    end;
  end;

  ParentChart.Canvas.Frame3D(tmpR,ApplyBright(NormalBarColor,DarkerColorQuantity),
                             ApplyDark(NormalBarColor,DarkColorQuantity),BevelSize);
end;

procedure TCustomBarSeries.SetBevelSize(const Value: Integer);
begin
  SetIntegerProperty(FBevelSize,Value);
end;

{ TBarSeries }
Constructor TBarSeries.Create(AOwner:TComponent);
begin
  inherited;
  FGradient.Direction:=gdTopBottom;
  MandatoryValueList.Name:=TeeMsg_ValuesBar;
end;

{ The horizontal Bar position is the "real" X pos +
  the BarWidth by our BarSeries order }
Function TBarSeries.CalcXPos(ValueIndex:Integer):Integer;
Begin
  if FMultiBar=mbSideAll then
     result:=GetHorizAxis.CalcXPosValue(IPreviousCount+ValueIndex)-(IBarSize shr 1)
  else
  if FMultiBar=mbSelfStack then
     result:=(inherited CalcXPosValue(MinXValue))-(IBarSize shr 1)
  else
  begin
    result:=inherited CalcXPos(ValueIndex);
    if FMultiBar<>mbNone then
       result:=result+Round(IBarSize*((IOrderPos-(INumBars*0.5))-1.0))
    else
       result:=result-(IBarSize shr 1);
  end;
  result:=ApplyBarOffset(result);
End;

Function TBarSeries.MaxXValue:Double;
Begin
  case FMultiBar of
    mbSideAll  : result:=IPreviousCount+Count-1;
    mbSelfStack: result:=MinXValue;
  else result:=inherited MaxXValue;
  end;
end;

Function TBarSeries.MinXValue:Double;
Begin
  if MultiBar=mbSelfStack then
     result:=ParentChart.SeriesList.IndexOf(Self)
  else
     result:=inherited MinXValue;
end;

Function TBarSeries.MaxYValue:Double;
Begin
  result:=MaxMandatoryValue(inherited MaxYValue);
end;

Function TBarSeries.MinYValue:Double;
Begin
  result:=MinMandatoryValue(inherited MinYValue);
end;

Procedure TBarSeries.CalcHorizMargins(Var LeftMargin,RightMargin:Integer);
begin
  inherited;
  InternalApplyBarMargin(LeftMargin,RightMargin);
end;

Procedure TBarSeries.CalcVerticalMargins(Var TopMargin,BottomMargin:Integer);
var tmp : Integer;
begin
  inherited;
  tmp:=CalcMarkLength(0);
  if tmp>0 then
  begin
    Inc(tmp);
    if FUseOrigin and (inherited MinYValue<FOrigin) then
       if GetVertAxis.Inverted then Inc(TopMargin,tmp) { 4.01 }
                               else Inc(BottomMargin,tmp);
    if (not FUseOrigin) or (inherited MaxYValue>FOrigin) then
       if GetVertAxis.Inverted then Inc(BottomMargin,tmp)
                               else Inc(TopMargin,tmp);
  end;
end;

Function TBarSeries.InternalCalcMarkLength(ValueIndex:Integer):Integer;
Begin
  result:=ParentChart.Canvas.FontHeight;
end;

type TSeriesMarksAccess=class(TSeriesMarks);

Procedure TBarSeries.DrawMark( ValueIndex:Integer; Const St:String;
                               APosition:TSeriesMarkPosition);
Var DifW : Integer;
    DifH : Integer;
Begin
  With APosition do
  begin
    DifW:=IBarSize div 2;
    DifH:=Marks.Callout.Length+Marks.Callout.Distance;

    if ArrowFrom.Y>GetOriginPos(ValueIndex) then
    begin
      DifH:=-DifH-Height;
      Inc(ArrowFrom.Y,Marks.Callout.Distance);
    end
    else
      Dec(ArrowFrom.Y,Marks.Callout.Distance);

    Inc(LeftTop.X,DifW);
    Dec(LeftTop.Y,DifH);
    Inc(ArrowTo.X,DifW);
    Dec(ArrowTo.Y,DifH);
    Inc(ArrowFrom.X,DifW);
  end;

  if AutoMarkPosition then
     TSeriesMarksAccess(Marks).AntiOverlap(FirstValueIndex,ValueIndex,APosition);

  inherited;
end;

Procedure TBarSeries.DrawBar(BarIndex,StartPos,EndPos:Integer);
Var tmpMidX : Integer;
    tmp     : TBarStyle;
Begin
  SetPenBrushBar(NormalBarColor);

  tmp:=GetBarStyle(BarIndex);

  With ParentChart,Canvas,BarBounds do
  begin
    tmpMidX:=(Left+Right) div 2;

    if View3D then
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel      : Cube(Left,Right,StartPos,EndPos,StartZ,EndZ,FDark3D);
      bsPyramid    : Pyramid(True,Left,StartPos,Right,EndPos,StartZ,EndZ,FDark3D);
      bsInvPyramid : Pyramid(True,Left,EndPos,Right,StartPos,StartZ,EndZ,FDark3D);
      bsCylinder   : Cylinder(True,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D);
      bsEllipse    : EllipseWithZ(Left,Top,Right,Bottom,MiddleZ);
      bsArrow      : Arrow(True, TeePoint(tmpMidX,EndPos),
                               TeePoint(tmpMidX,StartPos),
                               Right-Left,(Right-Left) div 2,MiddleZ);
      bsCone       : Cone(True,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D,ConePercent);
    end
    else
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel,
      bsCylinder   : BarRectangle(NormalBarColor,Left,Top,Right,Bottom);
      bsPyramid,
      bsCone       : Polygon([ TeePoint(Left,EndPos),
                               TeePoint(tmpMidX,StartPos),
                               TeePoint(Right,EndPos) ]);
      bsInvPyramid : Polygon([ TeePoint(Left,StartPos),
                               TeePoint(tmpMidX,EndPos),
                               TeePoint(Right,StartPos) ]);
      bsEllipse    : Ellipse(BarBounds);
      bsArrow      : Arrow(True, TeePoint(tmpMidX,EndPos),
                                 TeePoint(tmpMidX,StartPos),
                                 Right-Left,(Right-Left) div 2,MiddleZ);
    end;

    if tmp=bsRectGradient then
       BarGradient(BarIndex,TeeRect(Left,StartPos,Right,EndPos))
    else
    if tmp=bsBevel then DrawBevel;
  end;
end;

procedure TBarSeries.DrawValue(ValueIndex:Integer);
var tmpBlend : TTeeBlend;  // Transparency
Begin
  inherited;
  NormalBarColor:=ValueColor[ValueIndex];

  if NormalBarColor<>clNone then { if not null }
  With BarBounds do
  Begin
    Left:=CalcXPos(ValueIndex);

    if (BarWidthPercent=100) and (FCustomBarSize=0) then
    begin
      if GetHorizAxis.Inverted then
         if ValueIndex>0 then
            Right:=CalcXPos(Pred(ValueIndex))
         else
            Right:=Left+IBarSize+1
      else
         if ValueIndex<Count-1 then
            Right:=CalcXPos(Succ(ValueIndex))
         else
            Right:=Left+IBarSize+1
    end
    else
       Right:=Left+IBarSize+1;  // 5.02

    Top   :=CalcYPos(ValueIndex);
    Bottom:=GetOriginPos(ValueIndex);

    if not BarPen.Visible then
    begin
      if Bottom>Top then Inc(Bottom) else Inc(Top);
      Inc(Right);
    end;

    if Transparency>0 then
       tmpBlend:=CreateBlend
    else
       tmpBlend:=nil;

    if Bottom>Top then DrawBar(ValueIndex,Top,Bottom)
                  else DrawBar(ValueIndex,Bottom,Top);

    if Transparency>0 then
       ParentChart.Canvas.EndBlending(tmpBlend);
  end;
end;

Function TBarSeries.CalcYPos(ValueIndex:Integer):Integer;
var tmp      : Double;
    tmpValue : Double;
Begin
  Case FMultiBar of
    mbNone,mbSide,mbSideAll: result:=inherited CalcYPos(ValueIndex)
  else
  begin
    tmpValue:=YValues.Value[ValueIndex]+PointOrigin(ValueIndex,False);
    if (FMultiBar=mbStacked) or (FMultiBar=mbSelfStack) then
       result:=CalcYPosValue(tmpValue)
    else
    begin
      tmp:=PointOrigin(ValueIndex,True);
      if tmp<>0 then result:=CalcYPosValue(tmpValue*100.0/tmp)
                else result:=0;
    end;
  end;
  end;
End;

Function TBarSeries.GetOriginPos(ValueIndex:Integer):Integer;
Begin
  result:=InternalGetOriginPos(ValueIndex,GetVertAxis.IEndPos);
end;

Function TBarSeries.InternalClicked(ValueIndex:Integer; P:TPoint):Boolean;
var tmpX : Integer;

  Function InTriangle(Y1,Y2:Integer):Boolean;
  var TriP : TTrianglePoints;
  begin
    if ParentChart.View3D then
    begin
      with ParentChart.Canvas do
      begin
        TriP[0]:=Calculate3DPosition(tmpX,Y1,StartZ);
        TriP[1]:=Calculate3DPosition(tmpX+(IBarSize div 2),Y2,MiddleZ);
        TriP[2]:=Calculate3DPosition(tmpX+IBarSize,Y1,StartZ);
      end;
      result:=PointInPolygon(P,TriP);
    end
    else result:=PointInTriangle(P,tmpX,tmpX+IBarSize,Y1,Y2);
  end;

var tmpY : Integer;
    endY : Integer;

  Function OtherClicked:Boolean;
  begin
    if BarStyle=bsEllipse then
       result:=PointInEllipse(P,tmpX,tmpY,tmpX+IBarSize,endY)
    else
       result:=(P.Y>=tmpY) and (P.Y<=endY);
  end;

begin
  result:=False;
  tmpX:=CalcXPos(ValueIndex);

  if (not ParentChart.View3D) and
     ((P.X<tmpX) or (P.X>(tmpX+IBarSize))) then exit;

  tmpY:=CalcYPos(ValueIndex);
  endY:=GetOriginPos(ValueIndex);
  if endY<tmpY then SwapInteger(tmpY,endY);

  Case BarStyle of
   bsInvPyramid: result:=InTriangle(tmpY,endY);
      bsPyramid,
      bsCone   : result:=InTriangle(endY,tmpY);
   else
     if ParentChart.View3D then
     begin
       ParentChart.Canvas.Calculate2DPosition(P.X,P.Y,StartZ);
       if ((P.X>=tmpX) and (P.X<=(tmpX+IBarSize))) then
          result:=OtherClicked;
     end
     else result:=OtherClicked;
   end;
end;

Function TBarSeries.MoreSameZOrder:Boolean;
begin
  if FMultiBar=mbSideAll then result:=False
                         else result:=inherited MoreSameZOrder;
end;

Function TBarSeries.DrawSeriesForward(ValueIndex:Integer):Boolean;
begin
  Case FMultiBar of
    mbNone,
    mbSide,
    mbSideAll: result:=inherited DrawSeriesForward(ValueIndex);
    mbStacked,
    mbSelfStack:
               begin
                 result:=YValues.Value[ValueIndex]>=YOrigin; { 5.01 }
                 if GetVertAxis.Inverted then result:=not result;
               end;
  else
    result:=(not GetVertAxis.Inverted);
  end;
end;

{ THorizBarSeries }
Constructor THorizBarSeries.Create(AOwner:TComponent);
begin
  inherited;
  SetHorizontal;
  XValues.Order:=loNone;
  YValues.Order:=loAscending;
  FGradient.Direction:=gdLeftRight;
  MandatoryValueList.Name:=TeeMsg_ValuesBar;
end;

Procedure THorizBarSeries.CalcHorizMargins(Var LeftMargin,RightMargin:Integer);
var tmp : Integer;
begin
  inherited;
  tmp:=CalcMarkLength(TeeAllValues);
  if tmp>0 then Inc(tmp);
  if (FUseOrigin and (inherited MinXValue<FOrigin)) then
     Inc(LeftMargin,tmp);
  if (not FUseOrigin) or (inherited MaxXValue>FOrigin) then
     if GetHorizAxis.Inverted then Inc(LeftMargin,tmp)
                              else Inc(RightMargin,tmp);
end;

Procedure THorizBarSeries.CalcVerticalMargins(Var TopMargin,BottomMargin:Integer);
begin
  inherited;
  InternalApplyBarMargin(TopMargin,BottomMargin);
end;

Function THorizBarSeries.CalcXPos(ValueIndex:Integer):Integer;
var tmp      : Double;
    tmpValue : Double;
Begin
  if (FMultiBar=mbNone) or (FMultiBar=mbSide) or (FMultiBar=mbSideAll) then
     result:=inherited CalcXPos(ValueIndex)
  else
  begin
    tmpValue:=XValues.Value[ValueIndex]+PointOrigin(ValueIndex,False);
    if (FMultiBar=mbStacked) or (FMultiBar=mbSelfStack) then
       result:=CalcXPosValue(tmpValue)
    else
    begin
      tmp:=PointOrigin(ValueIndex,True);
      if tmp<>0 then result:=CalcXPosValue(tmpValue*100.0/tmp)
                else result:=0;
    end;
  end;
End;

Function THorizBarSeries.GetOriginPos(ValueIndex:Integer):Integer;
Begin
  result:=InternalGetOriginPos(ValueIndex,GetHorizAxis.IStartPos);
end;

{ The vertical Bar position is the "real" Y pos +
  the Barwidth by our BarSeries order }
Function THorizBarSeries.CalcYPos(ValueIndex:Integer):Integer;
Begin
  if FMultiBar=mbSideAll then
     result:=GetVertAxis.CalcYPosValue(IPreviousCount+ValueIndex)-(IBarSize shr 1)
  else
  if FMultiBar=mbSelfStack then
     result:=(inherited CalcYPosValue(MinYValue))-(IBarSize shr 1)
  else
  begin
    result:=inherited CalcYPos(ValueIndex);
    if FMultiBar<>mbNone then
       result:=result+Round(IBarSize*( ((INumBars*0.5)-(1+INumBars-IOrderPos)) ))
    else
       result:=result-(IBarSize shr 1);
  end;
  result:=ApplyBarOffset(result);
end;

Function THorizBarSeries.InternalClicked(ValueIndex:Integer; P:TPoint):Boolean;
var tmpY : Integer;

  Function InTriangle(X1,X2:Integer):Boolean;
  var TriP : TTrianglePoints;
  begin
    if ParentChart.View3D then
    begin
      with ParentChart.Canvas do
      begin
        TriP[0]:=Calculate3DPosition(X1,tmpY,StartZ);
        TriP[1]:=Calculate3DPosition(X2,tmpY+(IBarSize div 2),MiddleZ);
        TriP[2]:=Calculate3DPosition(X1,tmpY+IBarSize,StartZ);
      end;
      result:=PointInPolygon(P,TriP);
    end
    else result:=PointInHorizTriangle(P,tmpY,tmpY+IBarSize,X1,X2);
  end;

var tmpX : Integer;
    endX : Integer;

  Function OtherClicked:Boolean;
  begin
    if BarStyle=bsEllipse then
       result:=PointInEllipse(P,tmpX,tmpY,endX,tmpY+IBarSize)
    else
       result:=(P.X>=tmpX) and (P.X<=endX);
  end;

begin
  result:=False;

  tmpY:=CalcYPos(ValueIndex);

  if (not ParentChart.View3D) and
     ((P.Y<tmpY) or (P.Y>(tmpY+IBarSize))) then exit;

  tmpX:=CalcXPos(ValueIndex);
  endX:=GetOriginPos(ValueIndex);
  if endX<tmpX then SwapInteger(tmpX,endX);

  Case FBarStyle of
   bsInvPyramid: result:=InTriangle(endX,tmpX);
      bsPyramid,
      bsCone   : result:=InTriangle(tmpX,endX);
   else
     if ParentChart.View3D then
     begin
       ParentChart.Canvas.Calculate2DPosition(P.X,P.Y,StartZ);
       if ((P.Y>=tmpY) and (P.Y<=(tmpY+IBarSize))) then
          result:=OtherClicked;
     end
     else result:=OtherClicked;
  end;
end;

Function THorizBarSeries.MaxXValue:Double;
Begin
  result:=MaxMandatoryValue(inherited MaxXValue);
end;

Function THorizBarSeries.MinXValue:Double;
Begin
  result:=MinMandatoryValue(inherited MinXValue);
end;

Function THorizBarSeries.MaxYValue:Double;
Begin
  case FMultiBar of
    mbSideAll  : result:=IPreviousCount+Count-1;
    mbSelfStack: result:=MinYValue;
  else result:=inherited MaxYValue;
  end;
end;

Function THorizBarSeries.InternalCalcMarkLength(ValueIndex:Integer):Integer;
Begin
  if ValueIndex=TeeAllValues then result:=MaxMarkWidth
                             else result:=TSeriesMarksAccess(Marks).TextWidth(ValueIndex);
end;

Procedure THorizBarSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                    APosition:TSeriesMarkPosition);
Var DifH : Integer;
    DifW : Integer;
    tmp  : Boolean;
Begin
  With APosition do
  begin
    DifH:=IBarSize div 2;
    DifW:=Marks.Callout.Length+Marks.Callout.Distance;
    tmp:=ArrowFrom.X<GetOriginPos(ValueIndex);
    if tmp then DifW:=-DifW-Width;

    Inc(LeftTop.X,DifW+(Width div 2));
    Inc(LeftTop.Y,DifH+(Height div 2));
    Inc(ArrowTo.X,DifW);
    Inc(ArrowTo.Y,DifH);
    Inc(ArrowFrom.Y,DifH);

    if tmp then
       Dec(ArrowFrom.X,Marks.Callout.Distance)
    else
       Inc(ArrowFrom.X,Marks.Callout.Distance);
  end;

  inherited;
end;

Procedure THorizBarSeries.DrawBar(BarIndex,StartPos,EndPos:Integer);
Var tmpMidY : Integer;
    tmp     : TBarStyle;
Begin
  SetPenBrushBar(NormalBarColor);

  tmp:=GetBarStyle(BarIndex);

  With ParentChart,Canvas,BarBounds do
  begin
    tmpMidY:=(Top+Bottom) div 2;

    if View3D then
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel      : Cube(StartPos,EndPos,Top,Bottom,StartZ,EndZ,FDark3D);
      bsPyramid    : Pyramid(False,StartPos,Top,EndPos,Bottom,StartZ,EndZ,FDark3D);
      bsInvPyramid : Pyramid(False,EndPos,Top,StartPos,Bottom,StartZ,EndZ,FDark3D);
      bsCylinder   : Cylinder(False,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D);
      bsEllipse    : EllipseWithZ(Left,Top,Right,Bottom,MiddleZ);
      bsArrow      : Arrow(True, TeePoint(StartPos,tmpMidY),
                                 TeePoint(EndPos,tmpMidY),
                                 Bottom-Top,
                                 (Bottom-Top) div 2,MiddleZ);
      bsCone       : Cone(False,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D,ConePercent);
    end
    else
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel,
      bsCylinder   : BarRectangle(NormalBarColor,Left,Top,Right,Bottom);
      bsPyramid,
      bsCone       : Polygon([ TeePoint(StartPos,Top),
                               TeePoint(EndPos,tmpMidY),
                               TeePoint(StartPos,Bottom) ]);
      bsInvPyramid : Polygon([ TeePoint(EndPos,Top),
                               TeePoint(StartPos,tmpMidY),
                               TeePoint(EndPos,Bottom) ]);
      bsEllipse    : Ellipse(BarBounds);
      bsArrow      : Arrow(True, TeePoint(StartPos,tmpMidY),
                                 TeePoint(EndPos,tmpMidY),
                                 Bottom-Top,
                                 (Bottom-Top) div 2,MiddleZ);
    end;

    if tmp=bsRectGradient then
       BarGradient(BarIndex,TeeRect(StartPos,Top,EndPos,Bottom))
    else
    if tmp=bsBevel then DrawBevel;
  end;
end;

procedure THorizBarSeries.DrawValue(ValueIndex:Integer);
var tmpBlend : TTeeBlend;
Begin
  inherited;
  NormalBarColor:=ValueColor[ValueIndex];

  if NormalBarColor<>clNone then  { <-- if not null }
  With BarBounds do
  Begin
    Top:=CalcYPos(ValueIndex);

    if (BarWidthPercent=100) and (FCustomBarSize=0) then
    begin
      if GetVertAxis.Inverted then
         if ValueIndex<Count-1 then
            Bottom:=CalcYPos(Succ(ValueIndex))
         else
            Bottom:=Top+IBarSize+1
      else
         if ValueIndex>0 then
            Bottom:=CalcYPos(Pred(ValueIndex))
         else
            Bottom:=Top+IBarSize+1
    end
    else
       Bottom:=Top+IBarSize+1;  // 5.02

    Right:=CalcXPos(ValueIndex);
    Left:=GetOriginPos(ValueIndex);

    if not BarPen.Visible then
    begin
      if Right>Left then Inc(Right)
      else
      begin
        Inc(Left);
        Dec(Right);
      end;
      Inc(Bottom); // 5.02
    end;

    if Transparency>0 then
       tmpBlend:=CreateBlend
    else
       tmpBlend:=nil; 

    if Right>Left then DrawBar(ValueIndex,Left,Right)
                  else DrawBar(ValueIndex,Right,Left);

    if Transparency>0 then
       ParentChart.Canvas.EndBlending(tmpBlend);
  end;
end;

Function THorizBarSeries.DrawSeriesForward(ValueIndex:Integer):Boolean;
begin
  Case FMultiBar of
    mbNone   : result:=inherited DrawSeriesForward(ValueIndex);
    mbSide,
    mbSideAll: result:=False;
    mbStacked,
    mbSelfStack:
               begin
                 result:=MandatoryValueList.Value[ValueIndex]>=0; { 5.01 }
                 if GetHorizAxis.Inverted then result:=not result;
               end;
  else
    result:=not GetHorizAxis.Inverted;
  end;
end;

function THorizBarSeries.MinYValue: Double;
begin
  if MultiBar=mbSelfStack then
     result:=ParentChart.SeriesList.IndexOf(Self)
  else
     result:=inherited MinYValue;
end;

{ TCircledSeries }
Constructor TCircledSeries.Create(AOwner: TComponent);
begin
  inherited;
  CalcVisiblePoints:=False; { always draw all points }
  XValues.Name:=TeeMsg_ValuesAngle;
  FCircleBackColor:=clTeeColor;
  FCircleGradient:=TChartGradient.Create(CanvasChanged);
end;

Destructor TCircledSeries.Destroy;
begin
  FCircleGradient.Free;
  SetParentProperties(True);
  FreeAndNil(IBack3D);
  inherited;
end;

procedure TCircledSeries.SetCircled(Value:Boolean);
var t : Integer;
Begin
  SetBooleanProperty(FCircled,Value);
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
    if Self is Series[t].ClassType then
      With TCircledSeries(Series[t]) do
      begin
        FCircled:=Value;
        if not (csLoading in ComponentState) then
        begin
          FCustomXRadius:=0;
          FCustomYRadius:=0;
        end;
      end;
end;

Procedure TCircledSeries.SetRotationAngle(const Value:Integer);
Begin
  SetIntegerProperty(FRotationAngle,Value mod 360);
  IRotDegree:=FRotationAngle*PiDegree;
end;

procedure TCircledSeries.SetOtherCustomRadius(IsXRadius:Boolean; Value:Integer);
var t : Integer;
Begin
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
  With TCircledSeries(Series[t]) do
    if Self is ClassType then
       if IsXRadius then FCustomXRadius:=Value
                    else FCustomYRadius:=Value;
end;

Function TCircledSeries.UseAxis:Boolean;
begin
  result:=False;
end;

procedure TCircledSeries.SetCustomXRadius(Value:Integer);
Begin
  SetIntegerProperty(FCustomXRadius,Value);
  SetOtherCustomRadius(True,Value);
End;

procedure TCircledSeries.SetCustomYRadius(Value:Integer);
Begin
  SetIntegerProperty(FCustomYRadius,Value);
  SetOtherCustomRadius(False,Value);
End;

Procedure TCircledSeries.SetParentProperties(EnableParentProps:Boolean);
begin
  if Assigned(ParentChart) then
  With ParentChart do
  if (not (csDestroying in ComponentState)) and
     (not Canvas.SupportsFullRotation) and
      Assigned(View3DOptions) then
  begin
    if EnableParentProps and
      ((not Active) or (csDestroying in Self.ComponentState)) { 5.02 }
         then
    begin
      View3DOptions.Assign(IBack3D);
      FreeAndNil(IBack3D);
    end
    else
    if not Assigned(IBack3D) then
    begin
      IBack3D:=TView3DOptions.Create(ParentChart);
      IBack3D.Assign(View3DOptions);
      With View3DOptions do
      begin
        Orthogonal:=False;
        Rotation:=360;
        Elevation:=315;
        Perspective:=0;
        Tilt:=0;
      end;
    end;
  end;
end;

Procedure TCircledSeries.SetParentChart(Const Value:TCustomAxisPanel);
Begin
  if Value=nil then
     SetParentProperties(True);

  if Value<>ParentChart then
  begin
    inherited;
    if Assigned(ParentChart) then SetParentProperties(False);
  end;
end;

Procedure TCircledSeries.Rotate(const Angle:Integer);
Begin
  RotationAngle:=(RotationAngle+Angle) mod 360;
End;

Function TCircledSeries.AssociatedToAxis(Axis:TChartAxis):Boolean;
Begin
  result:=True;
end;

Procedure TCircledSeries.AdjustCircleRect;
Begin
  with FCircleRect do
  Begin
    if Odd(Right-Left) then Dec(Right);
    if Odd(Bottom-Top) then Dec(Bottom);
    if (Right-Left)<4 then Right:=Left+4;
    if (Bottom-Top)<4 then Bottom:=Top+4;
    FCircleWidth  :=Right-Left;
    FCircleHeight :=Bottom-Top;
  end;
  RectCenter(FCircleRect,FCircleXCenter,FCircleYCenter);
End;

type TSeriesAccess=class(TChartSeries);

Procedure TCircledSeries.DoBeforeDrawValues;

  Procedure CalcCircledRatio;

    Function AdjustRatio(Const ARatio:Double; ACanvas:TCanvas3D):Double;
    Var tmpRatio : Double;
        tmpH     : Integer;
        tmpW     : Integer;
    begin
      result:=ARatio;
      {$IFDEF CLX}
      tmpW:=Screen.Width;
      tmpH:=Screen.Height;
      {$ELSE}
      tmpW:=GetDeviceCaps(ACanvas.Handle,HORZSIZE);
      tmpH:=GetDeviceCaps(ACanvas.Handle,VERTSIZE);
      {$ENDIF}
      if tmpH<>0 then
      begin
        tmpRatio:=(1.0*tmpW/tmpH);
        if tmpRatio<>0 then result:=1.0*ARatio/tmpRatio;
      end;
    end;

  Var Ratio : Double;
      Dif   : Integer;
  Begin
    Ratio:=AdjustRatio(Screen.Width/Screen.Height,ParentChart.Canvas);
    CalcRadius;
    if Round(Ratio*FYRadius)<FXRadius then
    Begin
      dif:=(FXRadius-Round(Ratio*FYRadius));
      Inc(FCircleRect.Left,Dif);
      Dec(FCircleRect.Right,Dif);
    end
    else
    Begin
      dif:=(FYRadius-Round(1.0*FXRadius/Ratio));
      Inc(FCircleRect.Top,Dif);
      Dec(FCircleRect.Bottom,Dif);
    end;
    AdjustCircleRect;
  end;

  Procedure AdjustCircleMarks;
  Var tmpH     : Integer;
      tmpW     : Integer;
      tmpFrame : Integer;
  begin
    tmpFrame:=Marks.Callout.Length;
    With Marks.Frame do if Visible then Inc(tmpFrame,2*Width);
    With ParentChart do
    Begin
      Canvas.AssignFont(Marks.Font);
      tmpH:=Canvas.FontHeight+tmpFrame;
      Inc(FCircleRect.Top,tmpH);
      Dec(FCircleRect.Bottom,tmpH);
      tmpW:=MaxMarkWidth+Canvas.TextWidth(TeeCharForHeight)+tmpFrame;
      Inc(FCircleRect.Left,tmpW);
      Dec(FCircleRect.Right,tmpW);
      AdjustCircleRect;
    end;
  end;

  Procedure CheckOtherSeriesMarks; // 5.03
  var t : Integer;
  begin
    if Assigned(ParentChart) then
    with ParentChart do
    for t:=0 to SeriesCount-1 do
      if Self is Series[t].ClassType then
         if Series[t].Marks.Visible then
         begin
           if t>SeriesList.IndexOf(Self) then
              TSeriesAccess(Series[t]).DoBeforeDrawValues;

           Self.FCircleRect:=TCircledSeries(Series[t]).CircleRect;
           AdjustCircleRect;
           CalcRadius;
           break;
         end;
  end;

begin
  inherited;
  FCircleRect:=ParentChart.ChartRect;
  AdjustCircleRect;

  if Marks.Visible then AdjustCircleMarks
                   else CheckOtherSeriesMarks;

  if FCircled then CalcCircledRatio;
  CalcRadius;
end;

Procedure TCircledSeries.CalcRadius;
Begin
  if CustomXRadius<>0 then
  Begin
    FXRadius:=CustomXRadius;
    FCircleWidth:=2*FXRadius;
  end
  else FXRadius:=FCircleWidth shr 1;

  if CustomYRadius<>0 then
  begin
    FYRadius:=CustomYRadius;
    FCircleHeight:=2*FYRadius;
  end
  else FYRadius:=FCircleHeight shr 1;

  With FCircleRect do
  begin
    Left  :=FCircleXCenter-FXRadius;
    Right :=FCircleXCenter+FXRadius;
    Top   :=FCircleYCenter-FYRadius;
    Bottom:=FCircleYCenter+FYRadius;
  end;
end;

procedure TCircledSeries.SetCircleBackColor(Value:TColor);
begin
  SetColorProperty(FCircleBackColor,Value);
end;

Procedure TCircledSeries.AngleToPos( Const Angle,AXRadius,AYRadius:Double;
                                     Var X,Y:Integer);
var tmpSin : Extended;
    tmpCos : Extended;
Begin
  SinCos(IRotDegree+Angle,tmpSin,tmpCos);
  X:=FCircleXCenter+Round(AXRadius*tmpCos);
  Y:=FCircleYCenter-Round(AYRadius*tmpSin);
end;

Function TCircledSeries.CalcCircleBackColor:TColor;
begin
  result:=FCircleBackColor;
  if result=clTeeColor then
     if ParentChart.Printing then result:=clWhite
     else
     With (ParentChart as TCustomChart).BackWall do
        if not Transparent then result:=Color;

  if result=clTeeColor then result:=ParentChart.Color;
end;

Procedure TCircledSeries.PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                              Var BrushStyle:TBrushStyle);
Begin
  BackColor:=CalcCircleBackColor;
end;

Function TCircledSeries.PointToAngle(x,y:Integer):Double;
begin
  if (x-FCircleXCenter)=0 then
  begin
    if y>FCircleYCenter then result:=-0.5*Pi{1.5*pi}
                        else result:=0.5*Pi;
  end
  else
  if (FXRadius=0) or (FYRadius=0) then result:=0 // 6.01
  else
    result:=ArcTan2( ((FCircleYCenter-y)/FYRadius),
                     ((x-FCircleXCenter)/FXRadius));

  if result<0 then result:=2.0*Pi+result;
  result:=result-IRotDegree;
  if result<0 then result:=2.0*Pi+result;
end;

Procedure TCircledSeries.Assign(Source:TPersistent);
begin
  if Source is TCircledSeries then
  With TCircledSeries(Source) do
  begin
    Self.FCircled         := FCircled;
    Self.FRotationAngle   := FRotationAngle;
    Self.FCustomXRadius   := CustomXRadius;
    Self.FCustomYRadius   := CustomYRadius;
    Self.FCircleBackColor := FCircleBackColor;
    Self.CircleGradient   := FCircleGradient;
  end;
  inherited;
end;

Procedure TCircledSeries.SetActive(Value:Boolean);
begin
  inherited;
  SetParentProperties(not Active);
end;

function TCircledSeries.HasBackColor: Boolean;
begin
  result:=(CircleBackColor<>clTeeColor) and (CircleBackColor<>clNone);
end;

procedure TCircledSeries.SetCircleGradient(const Value: TChartGradient);
begin
  FCircleGradient.Assign(Value);
end;

procedure TCircledSeries.DrawCircleGradient;
var tmpR : TRect;
begin
  if (not ParentChart.View3D) or ParentChart.View3DOptions.Orthogonal then
  begin
    tmpR.Left:=1+CircleXCenter-(CircleWidth div 2);
    tmpR.Top:=1+CircleYCenter-(CircleHeight div 2);
    tmpR.Right:=tmpR.Left+CircleWidth;
    tmpR.Bottom:=tmpR.Top+CircleHeight;

    if ParentChart.View3D then tmpR:=ParentChart.Canvas.CalcRect3D(tmpR,EndZ);
    ClipEllipse(ParentChart.Canvas,tmpR);
    CircleGradient.Draw(ParentChart.Canvas,tmpR);
    ParentChart.Canvas.UnClipRectangle;
  end;
end;

{ TExplodedSlices }
Function TExplodedSlices.Get(Index:Integer):Integer;
begin
  if (Index<Count) and Assigned(Items[Index]) then
     result:=Integer(Items[Index])
  else
     result:=0
end;

Procedure TExplodedSlices.Put(Index,Value:Integer);
begin
  While Index>=Count do Add(nil);
  if Get(Index)<>Value then
  begin
    Items[Index]:=Pointer(Value);
    OwnerSeries.Repaint;
  end;
end;

{ TPieOtherSlice }
Constructor TPieOtherSlice.Create(AOwner:TChartSeries);
begin
  inherited Create;
  FOwner:=AOwner;
  FColor:=clTeeColor;
end;

Procedure TPieOtherSlice.Assign(Source:TPersistent);
begin
  if Source is TPieOtherSlice then
  With TPieOtherSlice(Source) do
  begin
    Self.FColor:=FColor;
    if Assigned(FLegend) then Self.Legend:=Legend
                         else FreeAndNil(Self.FLegend);
    Self.FStyle:=FStyle;
    Self.FText :=FText;
    Self.FValue:=FValue;
  end;
end;

Function TPieOtherSlice.IsTextStored:Boolean;
begin
  result:=FText<>'';
end;

procedure TPieOtherSlice.SetColor(Value:TColor);
begin
  TSeriesAccess(FOwner).SetColorProperty(FColor,Value);
end;

procedure TPieOtherSlice.SetStyle(Value:TPieOtherStyle);
begin
  if FStyle<>Value then
  begin
    FStyle:=Value;
    FOwner.Repaint;
  end;
end;

procedure TPieOtherSlice.SetText(Const Value:String);
begin
  if FText<>Value then
  begin
    FText:=Value;
    FOwner.Repaint;
  end;
end;

procedure TPieOtherSlice.SetValue(Const Value:Double);
begin
  TSeriesAccess(FOwner).SetDoubleProperty(FValue,Value);
end;

function TPieOtherSlice.GetText: String;
begin
  if FText='' then result:=TeeMsg_PieOther
              else result:=FText;
end;

function TPieOtherSlice.GetLegend: TChartLegend;
begin
  if not Assigned(FLegend) then
  begin
    FLegend:=TChartLegend.Create(FOwner.ParentChart);
    FLegend.Visible:=False;
    FLegend.Series:=FOwner;
  end;
  result:=FLegend;
end;

procedure TPieOtherSlice.SetLegend(const Value: TChartLegend);
begin
  if Assigned(Value) then
  begin
   Legend.Assign(Value);
   FLegend.Series:=FOwner;
  end
  else FreeAndNil(FLegend);
end;

destructor TPieOtherSlice.Destroy;
begin
  FLegend.Free;
  inherited;
end;

{ TPieSeries }
Const TeePieBelongsToOther = -1;
      TeePieOtherFlag      = MaxLongint;

Constructor TPieSeries.Create(AOwner: TComponent);
begin
  inherited;
  FAngleSize:=360;
  FAutoMarkPosition:=True;

  FExplodedSlice:=TExplodedSlices.Create;
  FExplodedSlice.OwnerSeries:=Self;
  FOtherSlice:=TPieOtherSlice.Create(Self);

  FShadow:=TPieShadow.Create(CanvasChanged);
  FShadow.Color:=Tee_PieShadowColor;

  XValues.Name:='';
  YValues.Name:=TeeMsg_ValuesPie;
  Marks.Visible:=True;
  Marks.Callout.Length:=8;
  FDark3D:=True;
  ColorEachPoint:=True;
  IUseSeriesColor:=False;
  IUseNotMandatory:=False;
end;

Destructor TPieSeries.Destroy;
begin
  FAngles:=nil;
  FreeAndNil(FExplodedSlice);
  FShadow.Free;
  FreeAndNil(FOtherSlice);
  inherited;
end;

Function TPieSeries.CalcXPos(ValueIndex:Integer):Integer;
begin
  if XValues.Value[ValueIndex]=TeePieOtherFlag then  { do not try to calc }
     result:=0
  else
     result:=inherited CalcXPos(ValueIndex);
end;

Function TPieSeries.NumSampleValues:Integer;
Begin
  result:=8;
End;

Procedure TPieSeries.ClearLists;
begin
  inherited;
  if Assigned(FExplodedSlice) then FExplodedSlice.Clear;
end;

Procedure TPieSeries.PreparePiePen(ValueIndex:Integer);
begin
  with ParentChart.Canvas do
  if FDarkPen then
     AssignVisiblePenColor(PiePen,ApplyDark(ValueColor[ValueIndex],DarkerColorQuantity))
  else
     AssignVisiblePen(PiePen);
end;

Function TPieSeries.SliceBrushStyle(ValueIndex:Integer):TBrushStyle;
begin
  if UsePatterns or ParentChart.Monochrome then
     result:=GetDefaultPattern(ValueIndex)
  else
     result:=bsSolid;
end;

Procedure TPieSeries.PrepareLegendCanvas( ValueIndex:Integer; Var BackColor:TColor;
                                          Var BrushStyle:TBrushStyle);
Begin
  inherited;
  PreparePiePen(ValueIndex);
  BrushStyle:=SliceBrushStyle(ValueIndex);
end;

Procedure TPieSeries.GalleryChanged3D(Is3D:Boolean);
begin
  inherited;
  DisableRotation;
  Circled:=not ParentChart.View3D;
end;

Procedure TPieSeries.AddSampleValues(NumValues:Integer);
var PieSampleStr : Array[0..7] of String;
    t : Integer;
Begin
  PieSampleStr[0]:=TeeMsg_PieSample1;
  PieSampleStr[1]:=TeeMsg_PieSample2;
  PieSampleStr[2]:=TeeMsg_PieSample3;
  PieSampleStr[3]:=TeeMsg_PieSample4;
  PieSampleStr[4]:=TeeMsg_PieSample5;
  PieSampleStr[5]:=TeeMsg_PieSample6;
  PieSampleStr[6]:=TeeMsg_PieSample7;
  PieSampleStr[7]:=TeeMsg_PieSample8;

  for t:=0 to NumValues-1 do
      Add( 1+System.Random(ChartSamplesMax), { <-- Value }
           PieSampleStr[t mod 8]);      { <-- Label }
end;

Function TPieSeries.CalcClickedPie(x,y:Integer):Integer;
Var tmpAngle : Double;
    tmpDist  : Double;
    tmpOffX  : Integer;
    tmpOffY  : Integer;
Begin
  if Length(FAngles)>0 then
  begin
    if Assigned(ParentChart) then
       ParentChart.Canvas.Calculate2DPosition(x,y,ParentChart.Width3D); { 5.03 }

    tmpAngle:=PointToAngle(x,y);

    tmpDist:=TeeDistance(x-CircleXCenter,y-CircleYCenter);

    for result:=0 to Count-1 do
      With FAngles[result] do
      if (tmpAngle>=StartAngle) and (tmpAngle<=EndAngle) then
      begin
        CalcExplodedOffset(result,tmpOffX,tmpOffY);

        if tmpDist<=TeeDistance(XRadius+Abs(tmpOffX),YRadius+Abs(tmpOffY)) then
  //      if (Abs(x-CircleXCenter)<=(XRadius+tmpOffX)) and
  //         (Abs(y-CircleYCenter)<=(YRadius+tmpOffY)) then

            Exit;
      end;
  end;

  result:=TeeNoPointClicked;
end;

Function TPieSeries.Clicked(x,y:Integer):Integer;
begin
  result:=inherited Clicked(x,y);
  if result=TeeNoPointClicked then result:=CalcClickedPie(x,y);
end;

Function TPieSeries.CountLegendItems:Integer;
var t : Integer;
begin
  result:=0;
  for t:=0 to Count-1 do
  if BelongsToOtherSlice(t) then Inc(result);
  if (not Assigned(OtherSlice.FLegend)) or (ILegend<>OtherSlice.FLegend) then
     result:=Count-result;
end;

Function TPieSeries.LegendToValueIndex(LegendIndex:Integer):Integer;
var Num : Integer;
    t   : Integer;
    tmp : Boolean;
    tmpIsOther : Boolean;
begin
  result:=LegendIndex;
  Num:=-1;

  tmpIsOther:=Assigned(OtherSlice.FLegend) and (ILegend=OtherSlice.FLegend);
  for t:=0 to Count-1 do
  begin
    tmp:=BelongsToOtherSlice(t);
    if (tmpIsOther and tmp) or ((not tmpIsOther) and (not tmp)) then
    begin
      Inc(Num);
      if Num=LegendIndex then
      begin
        result:=t;
        break;
      end;
    end;
  end;
end;

Function TPieSeries.BelongsToOtherSlice(ValueIndex:Integer):Boolean;
begin
  result:=XValues.Value[ValueIndex]=TeePieBelongsToOther;
end;

Procedure TPieSeries.CalcAngles;
const PiRatio=Pi*2.0/360.0;
Var tmpSumAbs : Double;
    AcumValue : Double;
    PiPortion : Double;
    t         : Integer;
    TotalAngle: Double;
Begin
  TotalAngle:=PiRatio*FAngleSize;
  AcumValue:=0;
  tmpSumAbs:=YValues.TotalAbs;
  if tmpSumAbs<>0 then PiPortion:=TotalAngle/tmpSumAbs
                  else PiPortion:=0;

  SetLength(FAngles,Count);
  for t:=0 to Count-1 do
  With FAngles[t] do
  Begin
    if t=0 then StartAngle:=0 else StartAngle:=FAngles[t-1].EndAngle;
    if tmpSumAbs<>0 then
    Begin
      if not BelongsToOtherSlice(t) then
         AcumValue:=AcumValue+Abs(YValues.Value[t]);
      if AcumValue=tmpSumAbs then EndAngle:=TotalAngle
                             else EndAngle:=AcumValue*PiPortion;
      { prevent small pie sectors }
      if (EndAngle-StartAngle)>TotalAngle then EndAngle:=StartAngle+TotalAngle;
    end
    else EndAngle:=TotalAngle;
    MidAngle:=(StartAngle+EndAngle)*0.5;
  end;
end;

Procedure TPieSeries.CalcExplodedRadius(ValueIndex:Integer; Var AXRadius,AYRadius:Integer);
var tmpExp : Double;
begin
  tmpExp:=1.0+FExplodedSlice[ValueIndex]*0.01;
  AXRadius:=Round(FXRadius*tmpExp);
  AYRadius:=Round(FYRadius*tmpExp);
end;

Procedure TPieSeries.DrawMark( ValueIndex:Integer; Const St:String;
                               APosition:TSeriesMarkPosition);
var tmpXRadius : Integer;
    tmpYRadius : Integer;
    tmp        : Double;
    tmpLength  : Integer;
Begin
  if not BelongsToOtherSlice(ValueIndex) then
  begin
    With ParentChart,FAngles[ValueIndex] do
    begin
      CalcExplodedRadius(ValueIndex,tmpXRadius,tmpYRadius);
      if Canvas.SupportsFullRotation then
      begin
        tmp:=MidAngle+Pi+0.5*Pi;
        Marks.ZPosition:=StartZ;
      end
      else
      begin
        tmp:=MidAngle;
        Marks.ZPosition:=EndZ;
      end;

      With APosition do
      begin
        ArrowFix:=True;
        tmpLength:=Marks.Callout.Length+Marks.Callout.Distance;

        AngleToPos( tmp,
                    tmpXRadius{+Canvas.TextWidth(TeeCharForHeight)}+tmpLength,
                    tmpYRadius{+Canvas.FontHeight}+tmpLength,
                    ArrowTo.X,ArrowTo.Y );

        tmpLength:=Marks.Callout.Distance;
        AngleToPos( tmp,tmpXRadius+tmpLength,tmpYRadius+tmpLength,ArrowFrom.X,ArrowFrom.Y );

        With ArrowTo do
        begin
          if X>FCircleXCenter then LeftTop.X:=X
                              else LeftTop.X:=X-Width;
          if Y>FCircleYCenter then LeftTop.Y:=Y
                              else LeftTop.Y:=Y-Height;
        end;

      end;
    end;

    if AutoMarkPosition then
       TSeriesMarksAccess(Marks).AntiOverlap(FirstValueIndex,ValueIndex,APosition);

    inherited;
  end;
end;

Function TPieSeries.CompareSlice(A,B:Integer):Integer;
Var TotalAngle : Double;
    TotalQuart : Double;

  Function GetAngleSlice(Index:Integer):Double;
  begin
    result:=FAngles[Index].MidAngle+IRotDegree;
    if result>TotalAngle then result:=result-TotalAngle;
    if result>TotalQuart then
    begin
      result:=result-TotalQuart;
      if result>Pi then result:=TotalAngle-result;
    end
    else result:=TotalQuart-result;
  end;

var tmpA : Double;
    tmpB : Double;
begin
  TotalAngle:=Pi*FAngleSize/180.0;
  TotalQuart:=(0.25*TotalAngle);

  tmpA:=GetAngleSlice(ISortedSlice[A]);
  tmpB:=GetAngleSlice(ISortedSlice[B]);

  if tmpA<tmpB then result:=-1 else
  if tmpA>tmpB then result:= 1 else result:= 0;
end;

Procedure TPieSeries.SwapSlice(a,b:Integer);
begin
  SwapInteger(ISortedSlice[a],ISortedSlice[b]);
end;

procedure TPieSeries.DrawAllValues;
Var t                : Integer;
    tmpCount         : Integer;
    MaxExploded      : Integer;
    MaxExplodedIndex : Integer;
    tmpOffX          : Integer;
    tmpOffY          : Integer;
begin
  if FExplodeBiggest>0 then CalcExplodeBiggest;

  MaxExplodedIndex:=-1;
  MaxExploded:=0;
  tmpCount:=Count-1;

  { calc biggest exploded index }
  for t:=0 to tmpCount do
  if FExplodedSlice[t]>MaxExploded then
  begin
    MaxExploded:=Round(FExplodedSlice[t]);
    MaxExplodedIndex:=t;
  end;

  { calc each slice angles }
  CalcAngles;

  { adjust circle rectangle }
  IsExploded:=MaxExplodedIndex<>-1;

  if IsExploded then
  begin
    CalcExplodedOffset(MaxExplodedIndex,tmpOffX,tmpOffY);
    InflateRect(FCircleRect,-Abs(tmpOffX) div 2,-Abs(tmpOffY) div 2);
    AdjustCircleRect;
    CalcRadius;
  end;

  { start xy pos }
  AngleToPos(0,FXRadius,FYRadius,iniX,iniY);

  FShadow.DrawEllipse(ParentChart.Canvas,CircleRect,EndZ-10);

  { exploded slices for 3D drawing, sort order... }
  if ParentChart.View3D and (IsExploded or (DonutPercent>0))
     and (not ParentChart.Canvas.SupportsFullRotation) then
  begin
    SetLength(ISortedSlice,tmpCount+1);
    for t:=0 to tmpCount do ISortedSlice[t]:=t;
    TeeSort(0,tmpCount,CompareSlice,SwapSlice);
    for t:=0 to tmpCount do
        DrawValue(ISortedSlice[t]);
    ISortedSlice:=nil;
  end
  else inherited;

  if Assigned(OtherSlice.FLegend) and
     OtherSlice.Legend.Visible then
  begin
    ILegend:=OtherSlice.Legend;
    try
      OtherSlice.Legend.DrawLegend;
    finally
      ILegend:=nil;
    end;
  end;
end;

Procedure TPieSeries.DrawPie(ValueIndex:Integer);
var tmpOffX : Integer;
    tmpOffY : Integer;
Begin
  CalcExplodedOffset(ValueIndex,tmpOffX,tmpOffY);

  With FAngles[ValueIndex] do
  with ParentChart,Canvas do { Draw pie slice }
  if View3D then
     Pie3D( FCircleXCenter+tmpOffX,
            FCircleYCenter-tmpOffY,
            FXRadius,FYRadius,
            StartZ,EndZ,
            StartAngle+IRotDegree,EndAngle+IRotDegree,
            FDark3D,
            IsExploded,
            FDonutPercent)
  else
  begin
    if FDonutPercent>0 then
       Donut( FCircleXCenter+tmpOffX,
              FCircleYCenter-tmpOffY,
              FXRadius,FYRadius,
              StartAngle+IRotDegree,EndAngle+IRotDegree,
              FDonutPercent)
    else
    begin
      AngleToPos(EndAngle,FXRadius,FYRadius,EndX,EndY);
      if ((IniX<>EndX) or (IniY<>EndY)) or (Count=1) or
         ( (Count>1) and (EndAngle-StartAngle>1) )  then { bug win32 api }
      begin
        {$IFDEF CLX}
        if ((IniX=EndX) and (IniY=EndY)) then
           With FCircleRect do
             Ellipse( Left + tmpOffX,Top   -tmpOffY,
                      Right+ tmpOffX,Bottom-tmpOffY)
        else
        {$ENDIF}
        With FCircleRect do
             Pie( Left + tmpOffX,Top   -tmpOffY,
                  Right+ tmpOffX,Bottom-tmpOffY,
                  IniX + tmpOffX,IniY  -tmpOffY,
                  EndX + tmpOffX,EndY  -tmpOffY);
        IniX:=EndX;
        IniY:=EndY;
      end;
    end;
  end;
end;

Procedure TPieSeries.CalcExplodedOffset( ValueIndex:Integer;
                                         Var OffsetX,OffsetY:Integer);
var tmpExp : Double;
    tmpSin : Extended;
    tmpCos : Extended;
    tmp    : Double;
begin
  OffsetX:=0;
  OffsetY:=0;

  if IsExploded then
  begin
    tmpExp:=FExplodedSlice[ValueIndex];

    if tmpExp>0 then
    begin { Apply exploded % to radius }
      With FAngles[ValueIndex] do
      if ParentChart.Canvas.SupportsFullRotation then tmp:=MidAngle+(Pi*FAngleSize/45.0)+Pi
                                                 else tmp:=MidAngle;
      SinCos(tmp+IRotDegree,tmpSin,tmpCos);
      tmpExp:=tmpExp*0.01;
      OffsetX:=Round(FXRadius*tmpExp*tmpCos);
      OffsetY:=Round(FYRadius*tmpExp*tmpSin);
    end;
  end;
end;

Procedure TPieSeries.CalcExplodeBiggest;
var tmp : Integer;
begin
  With YValues do tmp:=Locate(MaxValue);
  if tmp<>-1 then FExplodedSlice[tmp]:=FExplodeBiggest;
end;

Procedure TPieSeries.SetAngleSize(Value:Integer);
begin
  SetIntegerProperty(FAngleSize,Value);
end;

Procedure TPieSeries.SetAutoMarkPosition(Value:Boolean);
Begin
  SetBooleanProperty(FAutoMarkPosition,Value);
end;

procedure TPieSeries.SetDonutPercent(Value:Integer);
begin
  SetIntegerProperty(FDonutPercent,Value);
end;

procedure TPieSeries.SetExplodeBiggest(Value:Integer);
begin
  SetIntegerProperty(FExplodeBiggest,Value);
  CalcExplodeBiggest;
end;

procedure TPieSeries.SetOtherSlice(Value:TPieOtherSlice);
begin
  FOtherSlice.Assign(Value);
end;

Procedure TPieSeries.DrawValue(ValueIndex:Integer);
var tmpColor : TColor;
Begin
  if (CircleWidth>4) and (CircleHeight>4) then
  if not BelongsToOtherSlice(ValueIndex) then
  begin
    Brush.Style:=SliceBrushStyle(ValueIndex);

    if ParentChart.Monochrome then tmpColor:=clBlack
                              else tmpColor:=ValueColor[ValueIndex];

    { Set slice back color }
    ParentChart.SetBrushCanvas(tmpColor,Brush,CalcCircleBackColor);

    PreparePiePen(ValueIndex);

    DrawPie(ValueIndex);
  end;
end;

procedure TPieSeries.SetUsePatterns(Value:Boolean);
Begin
  SetBooleanProperty(FUsePatterns,Value);
end;

class Function TPieSeries.GetEditorClass:String;
Begin
  result:='TPieSeriesEditor'; { <-- dont translate ! }
end;

Function TPieSeries.GetPieValues:TChartValueList;
Begin
  result:=YValues;
end;

Function TPieSeries.GetPiePen:TChartPen;
begin
  result:=Pen;
end;

Procedure TPieSeries.SetDark3d(Value:Boolean);
Begin
  SetBooleanProperty(FDark3d,Value);
End;

Procedure TPieSeries.SetPieValues(Value:TChartValueList);
Begin
  SetYValues(Value);
end;

Procedure TPieSeries.SetShadow(Value:TPieShadow);
begin
  FShadow.Assign(Value)
end;

Function TPieSeries.MaxXValue:Double;
Begin
  result:=GetHorizAxis.Maximum;
End;

Function TPieSeries.MinXValue:Double;
Begin
  result:=GetHorizAxis.Minimum;
End;

Function TPieSeries.MaxYValue:Double;
Begin
  result:=GetVertAxis.Maximum;
End;

Function TPieSeries.MinYValue:Double;
Begin
  result:=GetVertAxis.Minimum;
End;

Procedure TPieSeries.DisableRotation;
begin
  With ParentChart.View3DOptions do
  begin
    Orthogonal:=False;
    Rotation:=0;
    Elevation:=305;
  end;
end;

Procedure TPieSeries.PrepareForGallery(IsEnabled:Boolean);
Begin
  inherited;
  FillSampleValues(8);
  ParentChart.Chart3DPercent:=75;
  Marks.Callout.Length:=0;
  Marks.DrawEvery:=1;
  DisableRotation;
  ColorEachPoint:=IsEnabled;
end;

Procedure TPieSeries.Assign(Source:TPersistent);
begin
  if Source is TPieSeries then
  With TPieSeries(Source) do
  begin
    Self.FAngleSize     :=FAngleSize;
    Self.FAutoMarkPosition:=FAutoMarkPosition;
    Self.FDark3d        :=FDark3D;
    Self.FDarkPen       :=FDarkPen;
    Self.FUsePatterns   :=FUsePatterns;
    Self.FExplodeBiggest:=FExplodeBiggest;
    Self.OtherSlice     :=FOtherSlice;
    Self.Shadow         :=FShadow;
  end;

  inherited;
  ColorEachPoint:=True;
end;

Function TPieSeries.AddPie( Const AValue:Double;
                            Const ALabel:String; AColor:TColor):Integer;
begin
  result:=Add(AValue,ALabel,AColor);
end;

procedure TPieSeries.RemoveOtherSlice;
var t : Integer;
begin
  { remove "other" slice, if exists... }
  for t:=0 to Count-1 do
  if XValues.Value[t]=TeePieOtherFlag then
  begin
    Delete(t);
    Break;
  end;
end;

procedure TPieSeries.WriteData(Stream: TStream);
begin
  RemoveOtherSlice;
  inherited;
end;

Procedure TPieSeries.CheckOrder;
begin
  XValues.Order:=loAscending;  // reset X order back to ascending
  Repaint;
  // do not call inherited. Simply repaint.
  // Pie series will already sort values at DoBeforeDrawChart method.
end;

procedure TPieSeries.DoBeforeDrawChart;
var t           : Integer;
    tmp         : Double;
    tmpValue    : Double;
    tmpHasOther : Boolean;
begin
  inherited;

  { re-order values }
  With PieValues do if Order<>loNone then Sort;

  RemoveOtherSlice;

  { reset X order... }
  XValues.FillSequence;

  { calc "Other" slice... }
  if (FOtherSlice.Style<>poNone) and (YValues.TotalABS>0) then
  Begin
    tmpHasOther:=False;
    tmpValue:=0;

    for t:=0 to Count-1 do
    begin
      tmp:=YValues.Value[t];
      if FOtherSlice.Style=poBelowPercent then tmp:=tmp*100.0/YValues.TotalAbs;
      if tmp<FOtherSlice.Value then
      begin
        tmpValue:=tmpValue+YValues.Value[t];
        XValues.Value[t]:=TeePieBelongsToOther; { <-- belongs to "other" }
        tmpHasOther:=True;
      end;
    end;

    { Add "Other" slice }
    if tmpHasOther then { 5.02 }
    begin
      AddXY(TeePieOtherFlag,tmpValue,FOtherSlice.Text,FOtherSlice.Color);
      With YValues do TotalABS:=TotalABS-tmpValue; { reset Y total }
    end;
  end;
end;

procedure TPieSeries.SwapValueIndex(a,b:Integer);
begin
  inherited;
  With FExplodedSlice do
  begin
    While Self.Count>Count do Put(Count,0);
    Exchange(a,b);
  end;
end;

class Procedure TPieSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TPieSeries(ASeries) do
  Case Index of
    1: UsePatterns:=True;
    2: ExplodeBiggest:=30;
    3: With Shadow do
       begin
         HorizSize:=10;
         VertSize:=10;
       end;
    4: begin
         Marks.Visible:=True;
         Clear;
         Add(30,'A');
         Add(70,'B');
       end;
    5: AngleSize:=180;
    6: Pen.Visible:=False;
    7: DarkPen:=True;
  end;
end;

class Procedure TPieSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Patterns);
  AddSubChart(TeeMsg_Exploded);
  AddSubChart(TeeMsg_Shadow);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_SemiPie);
  AddSubChart(TeeMsg_NoBorder);
  AddSubChart(TeeMsg_DarkPen);
end;

procedure TPieSeries.SetParentChart(const Value: TCustomAxisPanel);
begin
  inherited;
  if not (csDestroying in ComponentState) then
     if Assigned(OtherSlice) and Assigned(OtherSlice.FLegend) then
        OtherSlice.Legend.ParentChart:=Value;
end;

procedure TPieSeries.SetDarkPen(const Value: Boolean);
begin
  SetBooleanProperty(FDarkPen,Value);
end;

{ TFastLineSeries }
Constructor TFastLineSeries.Create(AOwner: TComponent);
Begin
  inherited;
  AllowSinglePoint:=False;
  DrawBetweenPoints:=True;
  FAutoRepaint:=True;
  FDrawAll:=True;
  FIgnoreNulls:=True;
End;

Procedure TFastLineSeries.CalcPosition(ValueIndex:Integer; var x,y:Integer);
begin
  X:=GetHorizAxis.CalcXPosValue(XValues.Value[ValueIndex]);
  Y:=GetVertAxis.CalcYPosValue(YValues.Value[ValueIndex]);
end;

{$IFNDEF CLX}
var TeeSetDCPenColor:function(DC: HDC; Color: COLORREF): COLORREF; stdcall;
{$ENDIF}

Procedure TFastLineSeries.NotifyNewValue(Sender:TChartSeries; ValueIndex:Integer);
{$IFNDEF TEEOCX}
var tmp   : Integer;
    {$IFNDEF CLX}
    tmpDC : TTeeCanvasHandle;
    {$ENDIF}
{$ENDIF}
begin
  if AutoRepaint then inherited
  {$IFNDEF TEEOCX}
  else
  begin
    if ValueIndex=0 then tmp:=0 else tmp:=Pred(ValueIndex);

    CalcPosition(tmp,OldX,OldY);

    With ParentChart,Canvas do
    begin
      {$IFDEF CLX}

      AssignVisiblePen(LinePen);

      {$ELSE}

      if FastPen then // 5.03
      begin
        tmpDC:=Handle;
        SelectObject(tmpDC,DCPEN);
        TeeSetDCPenColor(tmpDC,LinePen.Color);
      end
      else AssignVisiblePen(LinePen);

      {$ENDIF}

      if View3D then MoveTo3D(OldX,OldY,MiddleZ)
                else MoveTo(OldX,OldY);
    end;

    DrawValue(ValueIndex);
  end;
  {$ENDIF}
end;

class Function TFastLineSeries.GetEditorClass:String;
Begin
  result:='TFastLineSeriesEditor'; { <-- dont translate ! }
End;

procedure TFastLineSeries.PrepareCanvas;
Begin
  With ParentChart,Canvas do
  begin
    AssignVisiblePen(LinePen);
    CheckPenWidth(Pen);
    Brush.Style:=bsClear;
    BackMode:=cbmTransparent;
  end;
end;

procedure TFastLineSeries.DoMove(X,Y:Integer);
begin
  With ParentChart.Canvas do
  if ParentChart.View3D then MoveTo3D(X,Y,MiddleZ)
                        else MoveTo(X,Y);
end;

procedure TFastLineSeries.DrawAllValues;
var t   : Integer;
    tmp : Integer;
begin
  PrepareCanvas;

  tmp:=FirstValueIndex;

  if tmp>0 then CalcPosition(Pred(tmp),OldX,OldY)
           else CalcPosition(tmp,OldX,OldY);

  DoMove(OldX,OldY);

  if tmp>0 then DrawValue(tmp);

  for t:=Succ(tmp) to LastValueIndex do DrawValue(t)
end;

procedure TFastLineSeries.DrawValue(ValueIndex:Integer);
var X : Integer;
    Y : Integer;
begin
  CalcPosition(ValueIndex,X,Y);

  if X=OldX then
     if (not DrawAllPoints) or (Y=OldY) then exit;

  (*
  if DrawAllPoints then
  begin
    if (X=OldX) and (Y=OldY) then Exit;
  end
  else
    if X=OldX then Exit;
  *)

  if IgnoreNulls or (ValueColor[ValueIndex]<>clNone) then
  begin
    With ParentChart.Canvas do
    if ParentChart.View3D then
    begin
      if Stairs then
         if InvertedStairs then LineTo3D(OldX,Y,MiddleZ)
                           else LineTo3D(X,OldY,MiddleZ);
      LineTo3D(X,Y,MiddleZ);
    end
    else
    begin
      if Stairs then
         if InvertedStairs then LineTo(OldX,Y)
                           else LineTo(X,OldY);
      LineTo(X,Y);
    end;
  end
  else DoMove(X,Y);

  OldX:=X;
  OldY:=Y;
end;

Procedure TFastLineSeries.SetSeriesColor(AColor:TColor);
begin
  inherited;
  LinePen.Color:=AColor;
end;

Procedure TFastLineSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);
begin
  With Rect do ParentChart.Canvas.DoHorizLine(Left,Right,(Top+Bottom) div 2);
end;

Procedure TFastLineSeries.Assign(Source:TPersistent);
begin
  if Source is TFastLineSeries then
  with TFastLineSeries(Source) do
  begin
    Self.FAutoRepaint:=AutoRepaint;
    Self.FDrawAll:=DrawAllPoints;
    Self.FFastPen:=FastPen;
    Self.FIgnoreNulls:=IgnoreNulls;
    Self.FInvertedStairs:=InvertedStairs;
    Self.FStairs:=Stairs;
  end;
  inherited;
end;

Function TFastLineSeries.Clicked(x,y:Integer):Integer;
var t    : Integer;
    OldX : Integer;
    OldY : Integer;
    tmpX : Integer;
    tmpY : Integer;
    P    : TPoint;
begin
  result:=TeeNoPointClicked;
  if (FirstValueIndex>-1) and (LastValueIndex>-1) then
  begin
    if Assigned(ParentChart) then ParentChart.Canvas.Calculate2DPosition(X,Y,MiddleZ);
    OldX:=0;
    OldY:=0;
    P.X:=X;
    P.Y:=Y;
    for t:=FirstValueIndex to LastValueIndex do
    begin
      tmpX:=CalcXPos(t);
      tmpY:=CalcYPos(t);
      if (tmpX=X) and (tmpY=Y) then { clicked right on point }
      begin
        result:=t;
        break;
      end
      else
      if (t>FirstValueIndex) and PointInLine(P,tmpX,tmpY,OldX,OldY) then
      begin
        result:=t-1;
        break;
      end;
      OldX:=tmpX;
      OldY:=tmpY;
    end;
  end;
end;

Procedure TFastLineSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                    APosition:TSeriesMarkPosition);
begin
  Marks.ApplyArrowLength(APosition);
  inherited;
end;

class Procedure TFastLineSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_Dotted);
  AddSubChart(TeeMsg_Stairs);
end;

class Procedure TFastLineSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TFastLineSeries(ASeries) do
  Case Index of
     1: Marks.Visible:=True;
     2: LinePen.SmallDots:=True;
     3: Stairs:=True;
  end;
end;

procedure TFastLineSeries.SetPen(const Value: TChartPen);
begin
  inherited;
  SeriesColor:=LinePen.Color;
end;

procedure TFastLineSeries.SetDrawAll(const Value: Boolean);
begin
  SetBooleanProperty(FDrawAll,Value);
end;

procedure TFastLineSeries.SetFastPen(const Value: Boolean);
begin
  {$IFNDEF CLX}
  if Assigned(@TeeSetDCPenColor) then
  begin
    FFastPen:=Value;
    DCPEN:=GetStockObject(DC_PEN);
  end;
  {$ENDIF}
end;

procedure TFastLineSeries.SetIgnoreNulls(const Value: Boolean);
begin
  SetBooleanProperty(FIgnoreNulls,Value);
end;

procedure TFastLineSeries.SetInvertedStairs(const Value: Boolean);
begin
  SetBooleanProperty(FInvertedStairs,Value);
end;

procedure TFastLineSeries.SetStairs(const Value: Boolean);
begin
  SetBooleanProperty(FStairs,Value);
end;

procedure TFastLineSeries.CalcHorizMargins(var LeftMargin,
  RightMargin: Integer);
var tmp : Integer;
begin
  inherited;
  tmp:=Pen.Width-((Pen.Width-2) div 2);
  Inc(LeftMargin,tmp);
  Inc(RightMargin,tmp);
end;

procedure TFastLineSeries.CalcVerticalMargins(var TopMargin,
  BottomMargin: Integer);
var tmp : Integer;
begin
  inherited;
  tmp:=Pen.Width-((Pen.Width-2) div 2);
  Inc(TopMargin,tmp);
  Inc(BottomMargin,tmp);
end;

procedure TFastLineSeries.PrepareLegendCanvas(ValueIndex: Integer;
  var BackColor: TColor; var BrushStyle: TBrushStyle);
begin
  PrepareCanvas;
end;

Procedure RegisterTeeStandardSeries;
begin
  RegisterTeeSeries(TLineSeries,     @TeeMsg_GalleryLine,     @TeeMsg_GalleryStandard,2);
  RegisterTeeSeries(TBarSeries,      @TeeMsg_GalleryBar,      @TeeMsg_GalleryStandard,2);
  RegisterTeeSeries(THorizBarSeries, @TeeMsg_GalleryHorizBar, @TeeMsg_GalleryStandard,2);
  RegisterTeeSeries(TAreaSeries,     @TeeMsg_GalleryArea,     @TeeMsg_GalleryStandard,2);
  RegisterTeeSeries(TPointSeries,    @TeeMsg_GalleryPoint,    @TeeMsg_GalleryStandard,2);
  RegisterTeeSeries(TPieSeries,      @TeeMsg_GalleryPie,      @TeeMsg_GalleryStandard,1);
  RegisterTeeSeries(TFastLineSeries, @TeeMsg_GalleryFastLine, @TeeMsg_GalleryStandard,2);
  RegisterTeeSeries(THorizLineSeries,@TeeMsg_GalleryHorizLine,@TeeMsg_GalleryStandard,1);
  RegisterTeeSeries(THorizAreaSeries,@TeeMsg_GalleryHorizArea,@TeeMsg_GalleryStandard,1);
end;

{$IFNDEF CLX}
var TeeGDI32:THandle=0;   // 5.03

Procedure TryLoadSetDC;
begin
  TeeGDI32:=TeeLoadLibrary('gdi32.dll');
  if TeeGDI32<>0 then
     @TeeSetDCPenColor:=GetProcAddress(TeeGDI32,'SetDCPenColor');
end;

initialization
  TryLoadSetDC;
finalization
  if TeeGDI32<>0 then TeeFreeLibrary(TeeGDI32);
{$ENDIF}
end.

