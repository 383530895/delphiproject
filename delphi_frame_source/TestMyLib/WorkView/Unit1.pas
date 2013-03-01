unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, WVCtrls, WorkViews, EditExts, UIncrementComboBox;

type
  TForm1 = class(TForm)
    WorkView1: TWorkView;
    WVEdit1: TWVEdit;
    Label1: TLabel;
    WVEdit2: TWVEdit;
    WVEdit3: TWVEdit;
    WVComboBox1: TWVComboBox;
    WVEdit4: TWVEdit;
    WVStringsMan1: TWVStringsMan;
    WVComboBox2: TWVComboBox;
    WVEdit5: TWVEdit;
    WVEdit6: TWVEdit;
    WVDigitalEdit1: TWVDigitalEdit;
    WVDigitalEdit2: TWVDigitalEdit;
    WVLabel1: TWVLabel;
    btnCancel: TButton;
    procedure WorkView1WorkFields0CheckValid(WorkField: TWVField);
    procedure WorkView1WorkFields1CheckValid(WorkField: TWVField);
    procedure WorkView1WorkFields2CheckValid(WorkField: TWVField);
    procedure WVStringsMan1GetStrings(const StringsName: String;
      Items: TStrings; var Handled: Boolean);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.WorkView1WorkFields0CheckValid(WorkField: TWVField);
begin
  WorkField.Valid := WorkField.Data.AsString<>'';
end;

procedure TForm1.WorkView1WorkFields1CheckValid(WorkField: TWVField);
begin
  WorkField.Valid := not WorkField.Data.IsEmpty and (WorkField.Data.AsInteger>0);
end;

procedure TForm1.WorkView1WorkFields2CheckValid(WorkField: TWVField);
begin
  WorkField.Valid := not WorkField.Data.IsEmpty;
end;

procedure TForm1.WVStringsMan1GetStrings(const StringsName: String;
  Items: TStrings; var Handled: Boolean);
begin
  if StringsName='�г�' then
  begin
    Items.Clear;
    Items.Add('1-�Ϻ�');
    Items.Add('2-����');
    Handled := True;
  end
  else if StringsName='����' then
  begin
    Items.Clear;
    Items.Add('1-�����');
    Items.Add('2-��Ԫ');
    Handled := True;
  end
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
  WorkView1.Reset;
end;

end.
