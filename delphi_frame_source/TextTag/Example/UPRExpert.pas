unit UPRExpert;

interface

procedure Register;

implementation

uses Windows, SysUtils, Classes, ToolsAPI, Exptintf, ToolAPIUtils, UProjectReport;

type
  TKSProjectReport = class(TKSStandardExpert)
  private

  protected

  public
    procedure Execute; override;
  end;

resourcestring
  SAuthor = 'Huang Yanlai';
  SProduct = '�����ļ�����';

procedure Register;
begin
  RegisterLibraryExpert(TKSProjectReport.Create(SAuthor,SProduct));
end;

{ TKSProjectReport }

procedure TKSProjectReport.Execute;
begin
  ShowProjectReport;
end;

end.
