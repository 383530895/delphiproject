unit uGetPhotoSet;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls, inifiles, RzButton;

type
    TfrmGetPhotoSet = class(TForm)
        pnl1: TPanel;
        lbl1: TLabel;
        edtPath: TEdit;
        Label1: TLabel;
        edtPre: TEdit;
        Label2: TLabel;
        edtNativePath: TEdit;
        btnOK: TRzBitBtn;
        btnCancel: TRzBitBtn;
        procedure FormShow(Sender: TObject);
        procedure btnOKClick(Sender: TObject);
        procedure btnCancelClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmGetPhotoSet: TfrmGetPhotoSet;

implementation

uses uCommon, Ulogin, AES;

{$R *.dfm}

procedure TfrmGetPhotoSet.FormShow(Sender: TObject);
begin
    try
        edtPath.Text := dburl;
        edtPre.Text := dbUid;
        edtNativePath.Text := dbPwd;
    except
    end;
end;

procedure TfrmGetPhotoSet.btnOKClick(Sender: TObject);
var
    dbinifile: TIniFile;
begin
    if (edtPath.Text = '') or (edtPre.Text = '') or (edtNativePath.Text = '') then begin
        ShowMessage('����д����������Ϣ��');
        exit;
    end;
    if Application.MessageBox('�뱣֤������Ϣ����������ȷ�ԣ���ȷ��Ҫ������', PChar(Application.Title), MB_ICONQUESTION + MB_YESNO) = idno then
        Exit;
    if FileExists(apppath + sDbConfig) = false then begin
        Application.MessageBox('ϵͳ�����ļ��Ѿ����ƻ�������ϵͳ����Ա��ϵ��',
            'ϵͳ����', mb_ok + mb_iconerror);
        Application.Terminate;
    end;

    dbinifile := nil;
    try
        dbinifile := TIniFile.Create(apppath + sDbConfig);
        dbinifile.WriteString('database', 'dbServer', EncryptString(Trim(edtPath.Text), CryptKey));
        dbinifile.WriteString('database', 'dbUser', EncryptString(Trim(edtPre.Text), CryptKey));
        dbinifile.WriteString('database', 'dbPass', EncryptString(Trim(edtNativePath.Text), CryptKey));
        dburl := Trim(edtPath.Text);
        dbUid := Trim(edtPre.Text);
        dbPwd := Trim(edtNativePath.Text);
    finally
        dbinifile.Destroy;
    end;
    Application.MessageBox('���ݿ������ļ��Ѿ��������ã����ؽ�ϵͳ��',
        'ϵͳ��ʾ��', mb_ok + mb_iconerror);
    Application.Terminate;
end;

procedure TfrmGetPhotoSet.btnCancelClick(Sender: TObject);
begin
    Close;
end;

end.

