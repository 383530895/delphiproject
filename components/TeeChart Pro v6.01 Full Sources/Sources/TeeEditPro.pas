{********************************************}
{    TeeChart Extended Series Editors        }
{   Copyright (c) 1996-2003 by David Berneda }
{********************************************}
unit TeeEditPro;
{$I TeeDefs.inc}

interface

Uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     {$IFDEF CLX}
     QControls, QGraphics, Types,
     {$ELSE}
     Controls, Graphics,
     {$ENDIF}
     Classes, Chart, TeEngine;

type
  // Custom Graphic class to support loading *.tee files into TImage
  // components, etc.
  TChartImage = class(TGraphic) { 5.03 }
  private
    FChart  : TChart;
    FCustom : Boolean;
    function GetChart: TChart;
    procedure SetChart(const Value: TChart);
  protected
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    {$IFNDEF CLX}
    function GetPalette: HPALETTE; override;
    {$ENDIF}
    function GetWidth: Integer; override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    procedure ReadData(Stream: TStream); override;
    procedure SetHeight(Value: Integer); override;
    procedure SetTransparent(Value: Boolean); override;
    procedure SetWidth(Value: Integer); override;
    procedure WriteData(Stream: TStream); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const Filename: String); override;
    procedure SaveToStream(Stream: TStream); override;
    {$IFNDEF CLX}
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
    {$ENDIF}
    procedure Assign(Source: TPersistent); override;
  published
    property Chart:TChart read GetChart write SetChart;
  end;

{ Show the user the dialog associated to the Series }
Procedure EditOneSeries(AOwner:TControl; ASeries:TChartSeries);

{ Show the user a "Save to..." dialog to save it to disk. }
Function SaveChartDialog(AChart:TCustomChart):String;

implementation

{ This unit should be "used" by your applications if showing the
  Chart Editor with "Extended" Series and Functions. }

uses SysUtils,
     {$IFDEF CLX}
     QForms, QDialogs,
     {$ELSE}
     Forms, Dialogs,
     {$ENDIF}
     EditChar, StatChar, TeeCandlEdi, TeeVolEd, TeeSurfEdit, TeePolarEditor,
     TeeErrBarEd, CurvFitt, TeeContourEdit, TeeConst, TeeProCo, TeeStore,
     TeeBezie, TeePo3DEdit, TeExport, TeeExport, TeeProcs,
     TeeCount, TeeCumu, TeeDonutEdit, TeeCursorEdit, TeeTriSurfEdit,
     MyPoint, Bar3D, BigCandl, ImaPoint, ImageBar, TeeImaEd, TeeRose,
     TeeBoxPlot, TeeHistoEdit, TeeTools, TeeColorLineEditor, TeeColorBandEdit,
     TeeAxisArrowEdit, TeeDrawLineEditor, TeeImageToolEdit, TeeAnnToolEdit,
     TeeBarJoinEditor, TeeLinePointEditor, TeeRotateToolEditor,
     TeeHighLowEdit, TeeClockEditor, TeeBoxPlotEditor, TeeWindRoseEditor,
     TeeColorGridEditor, TeeWaterFallEdit, TeeSmith, TeePyramid, TeePyramidEdit,
     TeeNearestToolEditor, TeeSmithEdit, TeeCalendarEditor, TeePageNumTool,
     TeeMapSeries, TeeMapSeriesEdit,
     TeeMarksTipToolEdit, TeeDragMarksEdit, TeeDragPoint,
     TeeFunnel, TeeFunnelEditor, TeeADXFuncEditor, TeeMovAveFuncEdit,
     TeeSpline, TeeSmoothFuncEdit, TeeTransposeTool, TeeEdiSeri,
     TeeCompressOHLC, TeeMACDFuncEdit, TeeBollingerEditor,
     TeeRMSFuncEdit, TeeExpAveFuncEdit, TeeGanttTool, TeeGridBandToolEdit,
     TeeCLVFunction, TeeOBVFunction, TeeCCIFunction, TeePVOFunction,
     TeePointFigure, TeeGaugeEditor, TeeTowerEdit, TeePenDlg,
     TeeVectorEdit, TeeSeriesAnimEdit, TeePieTool;

{$R TeeProBm.res}

type TTeeExportFormatAccess=class(TTeeExportFormat);

{ This method shows the "Save As..." dialog to save a Chart into a
  native *.tee file or a picture file, depending if exporting formats
  are registered (units like TeeBMP used in the application)
}
Function SaveChartDialog(AChart:TCustomChart):String;
var tmpDialog : TSaveDialog;
    tmp       : TStringList;
    t         : Integer;
begin
  result:='';
  tmpDialog:=TSaveDialog.Create(nil);
  With tmpDialog do
  try
    Filter:=TeeMsg_TeeFiles+' (*.'+TeeMsg_TeeExtension+')';
    {$IFNDEF CLX}
    Filter:=Filter+'|*.'+TeeMsg_TeeExtension;
    Options:=[ofHideReadOnly,ofOverwritePrompt];
    {$ENDIF}

    tmp:=TStringList.Create;
    try
      TeeFillPictureDialog(tmpDialog,AChart,tmp);

      DefaultExt:=TeeMsg_TeeExtension;
      if Execute then
      begin
        if FilterIndex=1 then // native save to *.tee file
           SaveChartToFile(AChart,FileName)
        else
        { search the selected exporting picture format and save to file }
        for t:=0 to tmp.Count-1 do
        with TTeeExportFormatAccess(tmp.Objects[t]) do
        if FileFilterIndex=tmpDialog.FilterIndex then
        begin
          SaveToFile(FileName); // 5.02
          break;
        end;

        result:=FileName;
      end;
    finally
      tmp.Free;
    end;
  finally
    Free;
  end;
end;

{ This method shows the Series editor dialog as a stand-alone window,
  just to edit one series. }
Procedure EditOneSeries(AOwner:TControl; ASeries:TChartSeries);
begin
  with TeeCreateForm(SeriesEditorForm(ASeries),AOwner) do
  try
    BorderIcons:=[biSystemMenu];
    Scaled:=False;
    Caption:=Format(TeeMsg_Editing,[ASeries.Name]);
    Tag:=Integer(ASeries);
    {$IFNDEF CLX}
    Height:=Height+GetSystemMetrics(SM_CYDLGFRAME)+GetSystemMetrics(SM_CYCAPTION);
    {$ENDIF}
    ShowModal;
  finally
    Free;
  end;
end;

{ TChartImage }

procedure TChartImage.Assign(Source: TPersistent);
begin
  if Assigned(Source) then
  if (Source is TChartImage) then
  begin
     if Assigned(TChartImage(Source).FChart) then
     Chart.Assign(TChartImage(Source).FChart)
  end
  else
     inherited;
end;

procedure TChartImage.Clear;
begin
  if FCustom then FChart.Free;
end;

constructor TChartImage.Create;
begin
  inherited;
  FCustom:=True;
end;

destructor TChartImage.Destroy;
begin
  if FCustom then FChart.Free;
  inherited;
end;

procedure TChartImage.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  Chart.Draw(ACanvas,Rect);
end;

function TChartImage.GetChart: TChart;
begin
  if not Assigned(FChart) then
  begin
    FChart:=TChart.Create(nil);
    FCustom:=True;
  end;
  result:=FChart
end;

function TChartImage.GetEmpty: Boolean;
begin
  result:=not Assigned(FChart);
end;

function TChartImage.GetHeight: Integer;
begin
  result:=Chart.Height;
end;

{$IFNDEF CLX}
function TChartImage.GetPalette: HPALETTE;
begin
  result:=0;
end;
{$ENDIF}

function TChartImage.GetWidth: Integer;
begin
  result:=Chart.Width;
end;

{$IFNDEF CLX}
procedure TChartImage.LoadFromClipboardFormat(AFormat: Word;
  AData: THandle; APalette: HPALETTE);
begin
end;
{$ENDIF}

procedure TChartImage.LoadFromStream(Stream: TStream);
begin
  ReadData(Stream);
end;

procedure TChartImage.ReadData(Stream: TStream);
begin
  Chart;
  LoadChartFromStream(TCustomChart(FChart),Stream);
end;

{$IFNDEF CLX}
procedure TChartImage.SaveToClipboardFormat(var AFormat: Word;
  var AData: THandle; var APalette: HPALETTE);
begin
end;
{$ENDIF}

procedure TChartImage.SaveToFile(const Filename: String);
begin
  SaveChartToFile(Chart,FileName);
end;

procedure TChartImage.SaveToStream(Stream: TStream);
begin
  WriteData(Stream);
end;

procedure TChartImage.SetChart(const Value: TChart);
begin
  FChart:=Value;
  FCustom:=False;
  Changed(Self);
end;

procedure TChartImage.SetHeight(Value: Integer);
begin
  Chart.Height:=Value;
end;

procedure TChartImage.SetTransparent(Value: Boolean);
begin
end;

procedure TChartImage.SetWidth(Value: Integer);
begin
  Chart.Width:=Value;
end;

procedure TChartImage.WriteData(Stream: TStream);
begin
  SaveChartToStream(Chart,Stream);
end;

{$IFNDEF TEEOCX}
initialization
  TPicture.RegisterFileFormat('tee','TeeChart',TChartImage);
finalization
  TPicture.UnRegisterGraphicClass(TChartImage);
{$ENDIF}
end.
