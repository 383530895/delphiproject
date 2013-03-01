unit SimpCtrls;

// %SimpCtrls : �̳�TLable,TSpeedButton����Caption������'\n'��ʾ����
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Buttons;

type
  // %TLabelX: �̳�TLable��Caption������'\n'��ʾ����
  TLabelX = class(TLabel)
  private
    function 	GetCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Caption : TCaption
    						read GetCaption write SetCaption;
  end;

  // %TSpeedButtonX: �̳�TSpeedButton��Caption������'\n'��ʾ����
  TSpeedButtonX = class(TSpeedButton)
  private
    function 	GetCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Caption : TCaption
    						read GetCaption write SetCaption;
  end;


implementation

uses CompUtils, KSStrUtils;

{ TLabelX }

function TLabelX.GetCaption: TCaption;
begin
  result := NormalToSpcCap(inherited Caption);
end;

procedure TLabelX.SetCaption(const Value: TCaption);
begin
  inherited Caption := SpcCapToNormal(value);
end;

{ TSpeedButtonX }

function TSpeedButtonX.GetCaption: TCaption;
begin
  result := NormalToSpcCap(inherited Caption);
end;

procedure TSpeedButtonX.SetCaption(const Value: TCaption);
begin
  inherited Caption := SpcCapToNormal(value);
end;

end.
