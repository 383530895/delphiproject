{**********************************************}
{   TeeChart BarJoin Series Editor             }
{   Copyright (c) 1999-2003 by David Berneda   }
{**********************************************}
unit TeeBarJoinEditor;
{$I TeeDefs.inc}

interface

uses {$IFNDEF LINUX}
     Windows, Messages,
     {$ENDIF}
     SysUtils, Classes,
     {$IFDEF CLX}
     QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls, QComCtrls,
     {$ELSE}
     Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
     {$ENDIF}
     TeeBarEdit, TeCanvas, TeePenDlg;

type
  TBarJoinEditor = class(TBarSeriesEditor)
    BJoin: TButtonPen;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$IFNDEF CLX}
{$R *.DFM}
{$ELSE}
{$R *.xfm}
{$ENDIF}

Uses MyPoint;

procedure TBarJoinEditor.FormShow(Sender: TObject);
begin
  inherited;
  if Tag<>0 then
     BJoin.LinkPen(TBarJoinSeries(Tag).JoinPen); { 5.01 }
end;

initialization
  RegisterClass(TBarJoinEditor);
end.
