program ProtectingEyes;

uses
    Forms,
    windows,
    main in '..\src\main.pas' {frmmain},
    tx in '..\src\tx.pas' {frmtx},
    mythread in '..\src\mythread.pas';

var
    Mutex: THandle;

{$R *.res}

begin
    Mutex := CreateMutex(nil, False, '��������ר����� V1.0');
    if GetLastError <> ERROR_ALREADY_EXISTS then begin
        Application.Initialize;
        Application.Title := '��������ר�����';
        Application.CreateForm(Tfrmmain, frmmain);
        Application.ShowMainForm := false;
        Application.Run;


    end

    else
        Application.MessageBox('Ӧ�ó����Ѿ�����,�������г���Ķ��������', '����', mb_ok + mb_iconwarning);
    ReleaseMutex(Mutex);

end.

