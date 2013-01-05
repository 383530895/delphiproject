unit UtilOffice;

interface

uses
    Comobj, SysUtils, Forms, Windows,Office2000;
var
    v_office: Variant;

function OpenExcel(strFileName: string): Boolean;
function OpenWord(strFileName: string): Boolean;
function EditWord(strFileName: string): Boolean;
function OpenPowerPoint(strFileName: string): Boolean;

implementation
uses unit1;

function OpenPowerPoint(strFileName: string): Boolean;
begin
    Result := True;
    try
        //v_office := CreateOleObject('PowerPoint.Application');
        form1.PowerPointApplication1.Connect;
        form1.PowerPointApplication1.Visible := 1;
        form1.PowerPointApplication1.Presentations.Open(strFileName, msofalse, msotrue, msotrue);

        with form1.PowerPointApplication1.Presentations.Item(1) do begin
            //SlideShowSettings.AdvanceMode := ppSlideShowUseSlideTimings;
            SlideShowSettings.LoopUntilStopped := msoTrue;
            SlideShowSettings.Run;
        end;
    except
        Application.MessageBox('��PowerPointʧ��', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
    //    v_office.Visible := True;
    //    v_office.Caption := '';
    //v_office.Presentations.Open(strFileName);
end;

function OpenExcel(strFileName: string): Boolean;
begin
    Result := True;
    try
        v_office := CreateOleObject('Excel.Application');
    except
        Application.MessageBox('��Excelʧ��', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
    v_office.Visible := True;
    v_office.Caption := '';
    v_office.WorkBooks.Open(strFileName); //�򿪹�����
    v_office.WorkSheets[1].Activate; //���õ�1��������Ϊ�������
end;

function OpenWord(strFileName: string): Boolean;
begin
    Result := True;
    try
        v_office := CreateOleObject('Word.Application');
        v_office.Visible := true;
        v_office.Caption := strFileName;
        v_office.Documents.Open(FileName := strFileName, ReadOnly := True);
        //FileName:=strFileName,ReadOnly:=True
    except
        Application.MessageBox('��Wordʧ��', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
end;


function EditWord(strFileName: string): Boolean;
begin
    Result := True;
    try
        v_office := CreateOleObject('Word.Application');
        v_office.Visible := true;
        v_office.Caption := strFileName;
        v_office.Documents.Open(FileName := strFileName, ReadOnly := false);
    except
        Application.MessageBox('��Wordʧ��', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
end;

end.

 