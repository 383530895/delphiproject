unit Udm;

interface

uses
    SysUtils, Classes, DB, ADODB, Dialogs, DBAccess, Ora, IniFiles, MemDS;

type
    Tfrmdm = class(TDataModule)
        conn: TOraSession;
        qryImport: TOraQuery;
        qryQuery: TOraQuery;
        qrySpec: TOraQuery;
        qryArea: TOraQuery;
        qryDept: TOraQuery;
        qryType: TOraQuery;
        qryAdd: TOraQuery;
        qryFeeType: TOraQuery;
        procedure DataModuleCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmdm: Tfrmdm;

implementation

uses uCommon, TLoggerUnit, uGetPhotoSet;

{$R *.dfm}

procedure Tfrmdm.DataModuleCreate(Sender: TObject);
begin
    conn.Server := dburl;
    conn.Username := dbUid;
    conn.Password := dbPwd;

    if conn.Connected then
        conn.Disconnect;
    try
        conn.Connect;
    except
        on e: Exception do begin
            TLogger.GetInstance.Error('�������ݿ�ʧ��--[' + conn.Server + ']Err--' + e.Message);
            ShowMessage('���ݿ�����ʧ��--' + e.Message + '���������������ݿ�������硢�������Ƿ�������');
            frmGetPhotoSet := TfrmGetPhotoSet.Create(nil);
            frmGetPhotoSet.ShowModal;
            frmGetPhotoSet.Free;

        end;
    end;
end;

end.

