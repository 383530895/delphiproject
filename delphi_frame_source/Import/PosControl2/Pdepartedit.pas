unit Pdepartedit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TPdepartedit = class(TEdit)
  public
    constructor Create(AOwner: TComponent); override;
    function checkstate: integer;//�ֹ��Ϸ��Լ�麯����
                       // 0-�ɹ���1-ERN��ʶ���Ϸ���2-ERN�������ڿ���
    procedure validcheck;//ȫȨ����ʽ�ĺϷ����
  end;

procedure Register;

implementation

constructor TPdepartedit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     self.Font.Size := 9;
     self.Font.Name := '����';
     self.ParentFont := False;
end;
//=================================================================
function TPdepartedit.checkstate: integer;//�ֹ��Ϸ��Լ�麯����
                    // 0-�ɹ���1-ERN��ʶ���Ϸ���2-ERN�������ڿ���
begin
result:=0;
end;
//=================================================================
procedure TPdepartedit.validcheck;//ȫȨ����ʽ�ĺϷ����
begin
showmessage('TPdepartedit.validcheck is actived.');
end;
//=================================================================
procedure Register;
begin
  RegisterComponents('PosControl', [TPdepartedit]);
end;

end.
