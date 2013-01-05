unit Ulogin;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Db, ADODB, ExtCtrls, RzButton;

type
    TloginForm = class(TForm)
        Panel1: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        edtpwd: TEdit;
        edtOper: TEdit;
        btnLogin: TRzBitBtn;
        btnExit: TRzBitBtn;
        Image1: TImage;
        procedure btnExitClick(Sender: TObject);
        procedure btnLoginClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    loginForm: TloginForm;

implementation

uses uCommon, Udm, AES;

{$R *.DFM}

procedure TloginForm.btnExitClick(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TloginForm.btnLoginClick(Sender: TObject);
var
    sqlstr: string;
    sBegin: string;
    sEnd: string;
begin
    sqlstr := qryOperSql(Trim(edtOper.Text), '');
    frmdm.qryQuery.close;
    frmdm.qryQuery.sql.clear;
    frmdm.qryQuery.sql.add(sqlstr);
    frmdm.qryQuery.Open;

    if (Trim(edtOper.Text) = '') then begin
        MessageDlg('����Ա�ʺŲ���Ϊ�գ�', mtError, [mbOk], 0);
        ModalResult := mrNone;
        edtOper.SetFocus;
        exit;
    end;

    if frmdm.qryQuery.IsEmpty then begin
        MessageDlg('�ò���Ա�ʺŲ����ڣ�����������', mtError, [mbOk], 0);
        edtOper.SetFocus;
        ModalResult := mrNone;
        exit;
    end;
    loginPwd := Trim(DecryptString(frmdm.qryQuery.FieldByName(lmtpwd).asstring, CryptKey));
    loginName := frmdm.qryQuery.FieldByName(lmtOperCode).asstring;
    if Trim(edtpwd.Text) <> loginPwd then begin
        MessageDlg('����Ա�����벻һ�£�����������', mtError, [mbOk], 0);
        edtOper.SetFocus;
        ModalResult := mrNone;
        exit;
    end;
    sBegin := frmdm.qryQuery.FieldByName(lmtBeginDate).asstring;
    sEnd := frmdm.qryQuery.FieldByName(lmtEndDate).asstring;
    loginLimit := frmdm.qryQuery.FieldByName(lmtLimit).asstring;

    if judgelimit(loginLimit, Mdl_ifUse) = False then begin
        MessageDlg('����Ա�˺��Ѿ�ͣ�ã�����ϵϵͳ����Ա', mtError, [mbOk], 0);
        edtOper.SetFocus;
        ModalResult := mrNone;
        Exit;
    end;
    close;

end;


end.
