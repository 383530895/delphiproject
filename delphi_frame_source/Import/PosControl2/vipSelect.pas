unit vipSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  BASE1,
  Secu_Interface, globalparams, PBitBtn, PImage, PLabelEdit, PLabelPanel,
  LookupControls, PLookupCombox, PBevel, Mask, ToolEdit, PDateEdit;

type
  TvipSelectForm = class(TBase1Form)
    PanelTitle: TPanel;
    PImagePosMark: TPImage;
    BitBtnClose: TPBitBtn;
    BitBtnOk: TPBitBtn;
    EditVipid: TPLabelEdit;
    EditIdcard: TPLabelEdit;
    chkSex: TCheckBox;
    chkStatus: TCheckBox;
    EditName: TPLabelEdit;
    Label1: TLabel;
    editBirthdate: TPDateEdit;
    PBevel1: TPBevel;
    cmbVipkind: TPLookupCombox;
    PalStatus: TPLabelPanel;
    PBevel2: TPBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure chkStatusClick(Sender: TObject);
    procedure chkSexClick(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
  private
    { Private declarations }
    MdSecuGradeInfo: TMdSecuGrade;
  public
    { Public declarations }
    procedure enter(InstID: Integer; Mid: Integer; Info: string);override;
  end;

var
  vipSelectForm: TvipSelectForm;

implementation

uses Vip;

{$R *.DFM}
//=================================================================
procedure TvipSelectForm.enter(InstID: Integer; Mid: Integer; Info: string);
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
DenotePosition('����ģ��'+Name);
//���ñ�ģ���Config...
showmodal;
//���������ݿ�ǼǱ����̵ĵ�ǰλ�û�״����
DenotePosition('����������');
end;
//-----------------------------------------------------------------
procedure TvipSelectForm.FormCreate(Sender: TObject);
begin
  inherited;
  MdSecuGradeInfo:=TMdSecuGrade.Create;
  Caption:=Caption+'--'+Name;//��ģ����д��Form̧ͷ
  chkSex.Tag := 0;
  chkStatus.Tag := 0;
  
end;
//-----------------------------------------------------------------
procedure TvipSelectForm.FormDestroy(Sender: TObject);
begin
  inherited;
  MdSecuGradeInfo.Free;
end;
//-----------------------------------------------------------------
procedure TvipSelectForm.BitBtnCloseClick(Sender: TObject);
begin
  inherited;
  Close;  // FORM.
end;




procedure TvipSelectForm.chkStatusClick(Sender: TObject);
begin
     inherited;
     chkStatus.Tag := 1;
end;

procedure TvipSelectForm.chkSexClick(Sender: TObject);
begin
     inherited;
     chkSex.Tag := 1;
end;

procedure TvipSelectForm.BitBtnOkClick(Sender: TObject);
var str,str1: string;
begin
  inherited;
  str := '';

  if EditVipid.EditText <> '' then
  begin
       str1 := trimright(EditVipid.EditText);
       str := str + ' and (Vipid like "' + str1 + '")';
  end;

  if EditIdcard.EditText <> '' then
  begin
       str1 := trimright(EditIdcard.EditText);
       str := str + ' and (Idcard like "' + str1 + '")';
  end;

  if EditName.EditText <> '' then
  begin
       str1 := trimright(EditName.EditText);
       str := str + ' and (Name like "' + str1 + '")';
  end;

  if  EditBirthdate.Text <> '  /  /    ' then
  begin
       str1 := trimright(EditBirthdate.Text);
       str := str + ' and (Birthdate = "' + str1 + '")';
  end;

  if chkSex.Tag <> 0 then
     if chkSex.Checked then
        str := str + ' and ( sex = 1 )'
     else
         str := str + ' and ( sex = 0) ';

  if chkStatus.Tag <> 0 then
     if chkStatus.Checked then
        str := str + ' and (Status = "0" )'
     else
         str := str + ' and (status = "1") ';

  if cmbVipkind.Text <> '' then
  begin
       str1 := trimright(cmbVipKind.Text);
       str := str + ' and (VipKind = "' + str1 + '")';
  end;

  VipForm.vip.close;
  VipForm.vip.ParamByName('@s3').asstring:=str;
  VipForm.vip.open;
  VipForm.ClientVip.data := VipForm.vipprovider.data;

end;

end.
