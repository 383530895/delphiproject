unit PStaffEdit;
//ԭ�򣺴��ڵ������ݱ�Ȼ����ȷ�ġ�
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  stdctrls, dbtables;

const
  PREFIXCODEWIDTH = 2;
  ERNCODEWIDTH = 4;

type
  TPStaffEdit = class(TCustomControl)
  private
    FPrefixEdit: TEdit;//ǰ׺�������ҪôΪ'', ҪôΪ�Ϸ�(�볤)�Ĵ���
    FErnEdit: TEdit;
    FNameEdit: TEdit;
    DBQuery: TQuery;

    FAutoCheck: boolean;//�Ƿ���onexitʱ�Զ����и�ʽ�������кϷ����
    FMustExist: boolean;//�Ϸ����ʱ�Ƿ�Ҫ��ǰERN�Ѵ���
    FSynchroSearch: boolean;//�Ƿ���OnChangeʱ�Զ����prefix��name��

    procedure linkevents;
    procedure unlinkevents;
    procedure checkwidth(width: integer);
    procedure settlewidth;//�������ӳ���ȷ�������������������
    function getmatchingprefix: boolean;
    function getmatchinginfo: boolean;

    procedure ErnOnChange(Sender: TObject);
    procedure ErnOnExit(Sender: TObject);

    function getdatabasename: string;
    procedure putdatabasename(alias: string);
    function getprefixwidth: integer;
    procedure putprefixwidth(width: integer);
    function geternwidth: integer;
    procedure puternwidth(width: integer);
    function getnamewidth: integer;
    procedure putnamewidth(width: integer);
    function getprefix: string;
    function getern: string;
    procedure putern(ern: string);
    function getstaffname: string;
    function getreadonly: boolean;
    function getfont: TFont;
    procedure putfont(fvalue: TFont);
    procedure putreadonly(bvalue: boolean);
    function getinnerern: string;
    procedure putinnerern(innerern: string);
    procedure putsynchrosearch(bvalue: boolean);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetFocus; override;
    function checkstate: integer;//�ֹ��Ϸ��Լ�麯����
               //-1:ֵ�գ�0-�ɹ���1-ERN��ʶ���Ϸ���2-ERN�������ڿ���
    procedure validcheck;//ȫȨ����ʽ�ĺϷ����
  published
    property Enabled;

    property DatabaseName: string
             read getdatabasename write putdatabasename;
    property PrefixWidth: integer
             read getprefixwidth write putprefixwidth default 21;
    property ErnWidth: integer
             read geternwidth write puternwidth default 37;
    property NameWidth: integer
             read getnamewidth write putnamewidth default 65;
    property Prefix: string read getprefix;
    property Ern: string read getern write putern;
    property StaffName: string read getstaffname;
    property Font: TFont read getfont write putfont;
    property ReadOnly: boolean read getreadonly write putreadonly;
    property AutoCheck: boolean read FAutoCheck write FAutoCheck;
    property MustExist: boolean read FMustExist write FMustExist;
    property InnerErn: string read getinnerern write putinnerern;
    property SynchroSearch: boolean
             read FSynchroSearch write putsynchrosearch;
    property TabOrder;
  end;

function formatern(var ern: string): boolean;

procedure Register;

implementation

uses base_delphi_utils, c_showmessage_util;
//=================================================================
function formatern(var ern: string): boolean;
begin
result:=identifilize(ern, ERNCODEWIDTH);
if result then ern:=UpperCase(ern);
end;
//=================================================================
function TPStaffEdit.checkstate: integer;//�ֹ��Ϸ��Լ�麯����
var  // -1:ֵ�գ�0-�ɹ���1-ERN��ʶ���Ϸ���2-ERN�������ڿ���
tstr: string;
tempbool: boolean;
begin
result:=0;
tstr:=trim(FErnEdit.Text);
if (tstr='') then  //���Ƿ��ֵ
  begin
    result:=-1;
    exit;
  end;
tempbool:=formatern(tstr);  //�и�ʽ�Ƿ�Ϸ�
if not(tempbool) then
  begin
    result:=1;
    exit;
  end;
FErnEdit.Text:=tstr;
tempbool:=getmatchinginfo;  //����Ӧ�����Ƿ��Ѵ���
//�˴���������ֱ������if���ڣ������ֲ������̻�����result:=2�ﵽexit;
//���ܴ����ڲ��Ż���
if not(tempbool) then
  begin
    result:=2;
    exit;
  end;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.checkwidth(width: integer);
begin
if (width<0) then
  begin
    showmessage('Width can''t be less than zero.');
    abort;
  end;
end;
//-----------------------------------------------------------------
constructor TPStaffEdit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     FPrefixEdit:=TEdit.Create(Self);
     FPrefixEdit.Parent:=Self;
     FPrefixEdit.TabStop:=false;
     FErnEdit:=TEdit.Create(Self);
     FErnEdit.Parent:=Self;
     FNameEdit:=TEdit.Create(Self);
     FNameEdit.Parent:=Self;
     FNameEdit.TabStop:=false;
     DBQuery:=TQuery.Create(Self);

     PrefixWidth:=21;
     ErnWidth:=37;
     NameWidth:=65;
     (inherited Font).Size:= 9;
     Height:=24;
//�Զ��幹��Font.Size��ȷ����Parent�仯����С���䣬�ʻ��������й̶���

FPrefixEdit.Color:=clSilver;
FPrefixEdit.ReadOnly:=true;
FErnEdit.MaxLength:=ERNCODEWIDTH;
FNameEdit.Color:=clSilver;
FNameEdit.ReadOnly:=true;
//color for ernedit needed ?
linkevents;
end;
//-----------------------------------------------------------------
destructor TPStaffEdit.Destroy;
begin
FPrefixEdit.Free;
FErnEdit.Free;
FNameEdit.Free;
DBQuery.Free;
inherited Destroy;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.ErnOnChange(Sender: TObject);
begin
if (FErnEdit.Modified) then
  begin
    FPrefixEdit.Text:='';
    FNameEdit.Text:='';
    if (FSynchroSearch) then  getmatchinginfo;
  end;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.ErnOnExit(Sender: TObject);
begin
if (FAutoCheck) then  validcheck;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getdatabasename: string;
begin
result:=DBQuery.DatabaseName;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getern: string;
begin
result:=FErnEdit.Text;
end;
//-----------------------------------------------------------------
function TPStaffEdit.geternwidth: integer;
begin
result:=FErnEdit.Width;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getfont: TFont;
begin
result:=(inherited Font);
end;
//-----------------------------------------------------------------
function TPStaffEdit.getinnerern: string;
begin
if (FPrefixEdit.Text='') then  result:=''
else  result:=FPrefixEdit.Text+FErnEdit.Text;
      //���ݡ�ԭ�򡱣����ڱض�����
end;
//-----------------------------------------------------------------
function TPStaffEdit.getmatchinginfo: boolean;
//���ǿ��ܷ������û������ڼ䣬ֻ�ܰ��н�����̽�Ը�ʽ��������Ӱ��ErnEdit
//�����ݡ�
var
tstr: string;
begin
FNameEdit.Text:='';
if (FPrefixEdit.Text='') then getmatchingprefix;
result:=(FPrefixEdit.Text<>'');//ǰ׺�Ƿ���ڼ�Ψһ������ǰERN�Ƿ����
if result then  //���Ƿ���ʵStaff��������Ա���������ҵ�NAME��
  begin
    DBQuery.Active:=false;
    DBQuery.SQL.Clear;
    tstr:='select cname from tbstaff '
         +'where Upper(ern)='''+InnerErn+''' ';
    DBQuery.SQL.Add(tstr);
    DBQuery.Open;
    if (DBQuery.RecordCount=1) then
      begin
        FNameEdit.Text:=DBQuery.fieldbyname('cname').asstring;
      end
    else if (DBQuery.RecordCount>1) then
      begin
        showmessage('TPStaffEdit.getmatchinginfo:'+#13
                   +'confusing InnerErn['+InnerErn+'].');
        abort;
      end;
    DBQuery.Active:=false;
  end;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getmatchingprefix: boolean;
//���ǿ��ܷ������û������ڼ䣬ֻ�ܰ��н�����̽�Ը�ʽ��������Ӱ��ErnEdit
//�����ݡ�
var
tempern, tstr: string;
begin
result:=false;
FPrefixEdit.Text:='';
tempern:=trim(FErnEdit.Text);
if (tempern='') then  exit;
if formatern(tempern) then
  begin
    DBQuery.Active:=false;
    DBQuery.SQL.Clear;
    tstr:='select prefix=substring(ern, 1, '+inttostr(PREFIXCODEWIDTH)+') '
         +'from tbstaff '
         +'where upper(stuff(ern, 1, '+inttostr(PREFIXCODEWIDTH)+', ''-''))=''-'+tempern+''' '
         +'  and deletetag=0';
    DBQuery.SQL.Add(tstr);
    DBQuery.Open;
    if (DBQuery.RecordCount=0) then  //��һ������Ƿ�����Ա��
      begin
        DBQuery.Active:=false;
        DBQuery.SQL.Clear;
        tstr:='select prefix=substring(ern, 1, '+inttostr(PREFIXCODEWIDTH)+') '
             +'from securityinfo '
             +'where upper(stuff(ern, 1, '+inttostr(PREFIXCODEWIDTH)
             +', ''-''))=''-'+tempern+''' ';
        DBQuery.SQL.Add(tstr);
        DBQuery.Open;
      end;
    if (DBQuery.RecordCount>0) then
      begin
        result:=true;
        FPrefixEdit.Text:=DBQuery.fieldbyname('prefix').asstring;
      end;
    DBQuery.Active:=false;
  end;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getstaffname: string;
begin
result:=FNameEdit.Text;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getnamewidth: integer;
begin
result:=FNameEdit.Width;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getprefix: string;
begin
result:=FPrefixEdit.Text;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getprefixwidth: integer;
begin
result:=FPrefixEdit.Width;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getreadonly: boolean;
begin
result:=FErnEdit.ReadOnly;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.linkevents;
begin
FErnEdit.OnChange:=ErnOnChange;
FErnEdit.OnExit:=ErnOnExit;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.Paint;
begin
FPrefixEdit.Height:=Height;
FErnEdit.Height:=Height;
FNameEdit.Height:=Height;
FNameEdit.Width:=Width-FPrefixEdit.Width-FErnEdit.Width+2;
inherited Paint;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putdatabasename(alias: string);
begin
DBQuery.Active:=false;
DBQuery.DatabaseName:=alias;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putern(ern: string);
begin
FErnEdit.Text:=ern;//�ȼ��ڽ������룬��OnChange��������Ӧ����
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.puternwidth(width: integer);
begin
checkwidth(width);
FErnEdit.Width:=width;
settlewidth;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putfont(fvalue: TFont);
begin
(inherited Font).Assign(fvalue);
Height:=FErnEdit.Height;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putinnerern(innerern: string);
var  //��������������OnChange�������Զ�ƥ��(��Ϊ����ִ�����в�ͬ)
tmpprefix, tmpname: string;
tempbool: boolean;
len: integer;
begin
innerern:=trim(innerern);
len:=Length(innerern);
if (len=0) then
  begin
    tmpprefix:='';
    tmpname:='';
  end
else if (len<=PREFIXCODEWIDTH) then
  begin
    showmessage('TPStaffEdit.putinnerern:'+#13
               +'invalid InnerErn['+innerern+'], ERN may be NULL.');
    abort;
  end
else
  begin
    tmpprefix:=Copy(innerern, 1, PREFIXCODEWIDTH);
    tempbool:=nformat(tmpprefix, PREFIXCODEWIDTH);
    if not(tempbool) then
      begin
        showmessage('TPStaffEdit.putinnerern:'+#13+innerern
                   +'''s prefix is invalid.');
        abort;
      end;
    tmpname:=
      UpperCase(Copy(innerern, PREFIXCODEWIDTH+1, len-PREFIXCODEWIDTH));
  end;

unlinkevents;
FPrefixEdit.Text:=tmpprefix;
FErnEdit.Text:=tmpname;
FNameEdit.Text:='';
if (FSynchroSearch) then getmatchinginfo;
linkevents;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putnamewidth(width: integer);
begin
checkwidth(width);
FNameEdit.Width:=width;
settlewidth;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putprefixwidth(width: integer);
begin
checkwidth(width);
FPrefixEdit.Width:=width;
settlewidth;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putreadonly(bvalue: boolean);
begin
FErnEdit.ReadOnly:=bvalue;
if bvalue then  FErnEdit.Color:=clSilver
else  FErnEdit.Color:=clWhite;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putsynchrosearch(bvalue: boolean);
begin
FSynchroSearch:=bvalue;
if (bvalue)and(FNameEdit.Text='') then  getmatchinginfo;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.SetFocus;
begin
FErnEdit.SetFocus; 
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.settlewidth;
begin
FErnEdit.Left:=FPrefixEdit.Left+FPrefixEdit.Width-1;
FNameEdit.Left:=FErnEdit.Left+FErnEdit.Width-1;
Width:=FNameEdit.Left+FNameEdit.Width;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.unlinkevents;
begin
FErnEdit.OnChange:=nil;
FErnEdit.OnExit:=nil;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.validcheck;//ȫȨ����ʽ�ĺϷ����
var
i: integer;
begin
i:=checkstate;
case i of
  -1: ;
  0: ;
  2: if (FMustExist) then
       begin
         c_showmessage('δ�ڿ�����������ǰ���빤�ŵļ�¼������');
         abort;
       end;
else begin
         c_showmessage('��ǰ���빤����Ч������');
         abort;
     end;
end;  // of case
end;
//=================================================================
procedure Register;
begin
  RegisterComponents('Samples', [TPStaffEdit]);
end;

end.
