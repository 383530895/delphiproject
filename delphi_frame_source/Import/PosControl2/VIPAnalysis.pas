unit VIPAnalysis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  BASE1,
  Secu_Interface, globalparams, TeEngine, Series, TeeProcs, Chart, DBChart,
  Grids, DBGrids, Mask;

type
  TVIPAnalysisForm = class(TBase1Form)
    PanelTitle: TPanel;
    Image1: TImage;
    BitBtnClose: TBitBtn;
    Label1: TLabel;
    startdate: TMaskEdit;
    Label2: TLabel;
    enddate: TMaskEdit;
    RadioGroup1: TRadioGroup;
    DBGridDt: TDBGrid;
    DBChart1: TDBChart;
    Series1: TPieSeries;
    Series2: TPieSeries;
    BitBtn10: TBitBtn;
    BitBtn13: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);
  private
    { Private declarations }
    MdSecuGradeInfo: TMdSecuGrade;
  public
    { Public declarations }
    procedure enter(InstID: Integer; Mid: Integer; Info: string);override;
  end;

var
  VIPAnalysisForm: TVIPAnalysisForm;

implementation

{$R *.DFM}
//=================================================================
procedure TVIPAnalysisForm.enter(InstID: Integer; Mid: Integer; Info: string);
begin  {���ñ�FORM��config}
if (GP_HIDEFORMTITLE) then
  begin
    Caption:=PanelTitle.Caption;
    PanelTitle.Hide;
  end
else
  begin
    Caption:='';
    PanelTitle.Visible:=true;
  end;
//ȡ�õ�ǰ�û��ڱ�ģ���Ȩ����Ϣ��
//GetCurrentMdGrade(Mid, MdSecuGradeInfo);
//������������ǰ�û��ڱ�ģ��û�а�ȫȨ����Ϣ�Ļ�... ...
//if not(MdSecuGradeInfo.recordexist) then ... ...
//�Ա�ģ��İ�ť�����Զ����á�
//ButtonConfigure(Mid, Base2Form);}
//���������ݿ�ǼǱ����̵ĵ�ǰλ�û�״����
//DenotePosition('����ģ��xxx');
//���ñ�ģ���Config

showmodal;

//���������ݿ�ǼǱ����̵ĵ�ǰλ�û�״����
//DenotePosition('����������');
end;
//-----------------------------------------------------------------
procedure TVIPAnalysisForm.FormCreate(Sender: TObject);
begin
  inherited;
  MdSecuGradeInfo:=TMdSecuGrade.Create;

//��ģ���д��Form̧ͷ
  {Caption:=Caption+'--'+ModuleName;}
end;
//-----------------------------------------------------------------
procedure TVIPAnalysisForm.FormDestroy(Sender: TObject);
begin
  inherited;
  MdSecuGradeInfo.Free;
end;
//-----------------------------------------------------------------
procedure TVIPAnalysisForm.BitBtnCloseClick(Sender: TObject);
begin
  inherited;
  Close;  // FORM.
end;






end.
