unit base_delphi_utils;
//�Ա�ľ��ж��ع��ܵĵ��ù��߰�.
interface

uses SysUtils, Dialogs, registry, Windows;

function strtochar( const sstr: string ): char;
function countsubstring( const str: string; const substr: string )
                       : integer;
function nformat( var str:string; len:integer ) : boolean ;
function identifilize( var str:string; len:integer ) : boolean ;
function dateformat( var str:string; const separator:string ): boolean ;
procedure logicalexplink( var objectexp:string; const optype:char;
                          const appendexp:string );//�ַ��͵�.
procedure switchtolongyear(var tstr:string; const separator:string);
procedure switchtoshortyear(var tstr:string; const separator:string);
function gethostname: string;
function getusername: string;
function milliseconddiff(starttime: Tdatetime; endtime: Tdatetime)
                        : integer;

implementation

//====================================================================
{
function AsciiValue( ch: char ): Byte;
var
b: Byte;
p: Pointer;
begin
p:=@b;
PChar(p)^:=ch;
result:=b;
end;
//--------------------------------------------------------------------
function AsciiChar( code: Byte ): char;
var
b: Byte;
p: Pointer;
begin
b:=code;
p:=@b;
result:=PChar(p)^;
end;
//--------------------------------------------------------------------
}
function strtochar( const sstr: string ): char;
begin
if (sstr='') then      //��sstrΪ��ʱ,����#0.
  result:=#0
else                //���򷵻�sstr�ĵ�һ���ַ�.
  result:=sstr[1];
end;
//--------------------------------------------------------------------
function countsubstring( const str: string; const substr: string )
                       : integer;
var
i, len : integer;
stemp: string;
begin
if substr='' then   //��substrΪ��,���� -1 (��Ϊʧ��)
  begin
    result:=-1;
    exit;
  end;
stemp:=str;
len:=length(substr);
result:=0;
i:=pos(substr, stemp);
while (i<>0) do
  begin
    result:=result+1;
    delete(stemp,1,i+len-1);  //���������ǰ�Ӵ�(���ص�����).
    i:=pos(substr, stemp);
  end;
end;
//--------------------------------------------------------------------
function nformat( var str:string; len:integer ) : boolean ;
var
i, l :integer;
ch:string;
allnumflag:boolean;
begin
str:=trim(str);     //Ԥ��ȥ��Ŀ�괮��ǰ���ո�ͺ�׺�ո�.
l:=length(str);
if (len<=0) then len:=l;  //��len����<=0ʱ, ��Ҫ��Ϊ----"��Ȼ����"
if l>len then       //Ŀ�괮����,��Ϊ���Ϸ�.
  begin
    result:=false;
    exit;
  end;
if l>0 then         //Ŀ�괮������,�򲹳�ǰ����.
   for i:=l+1 to len do str:= '0' + str
else                //Ŀ�괮Ϊ�մ�,��Ϊ���Ϸ�.
   begin
     result:=false;
     exit;
   end;
allnumflag:=true;   //���¼��Ŀ�괮�Ƿ�Ϊȫ���ִ�.
l:=1;
while allnumflag and (l<=len) do
  begin
    ch:=copy(str,l,1);
    allnumflag:=( (ch>='0') and (ch<='9') );
    l:=l+1;
  end;
result:=allnumflag;
end;
//--------------------------------------------------------------------
function dateformat( var str:string; const separator:string ): boolean ;
label invalid;
var    // eg. '02/28/1997'
month, day, year, i: integer;
resultstring, stemp, spart: string;
btemp: boolean;
begin
stemp:=str;
i:=countsubstring(stemp, separator);
if i<>2 then goto invalid;    //Ŀ�괮������separator��������2,�طǷ�.

i:=pos(separator, stemp);     //��ȡ�·�,������Ϸ���.
spart:=copy(stemp, 1, i-1);
btemp:=nformat(spart, 2);
if not(btemp)or(spart='') then goto invalid;
month:=strtoint(spart);
if (month<1) or (month>12) then goto invalid;
resultstring:=spart + separator;//�Ϸ�:�򽫾��淶�����·�ֵ
delete(stemp, 1, i);            //     ת����resultstring.

i:=pos(separator, stemp);     //��ȡ����,����������Ϸ���.
spart:=copy(stemp, 1, i-1);
btemp:=nformat(spart, 2);
if not(btemp)or(spart='') then goto invalid;
day:=strtoint(spart);
if (day<1) or (day>31) then goto invalid;
resultstring:=resultstring+spart+separator;//�����Ϸ�:�򽫾��淶����
delete(stemp, 1, i);                       //����ֵת����resultstring.

spart:=stemp;       //��ȡ���,������Ϸ���.
btemp:=nformat(spart, 4);
if not(btemp)or(spart='') then goto invalid;
year:=strtoint(spart);
resultstring:=resultstring+spart;       //�Ϸ�:�򽫾��淶�������ֵ(4λ)
stemp:='';                              //    ת����resultstring.

if (month=2) then   //�ٴβ�����ƽ,��������������(�����ڶ���ʱ)�ĺϷ���.
  begin
    if day>29 then goto invalid;
    if ((year mod 4)<>0)or(((year mod 100)=0)and((year mod 400)<>0)) then
        if day>28 then goto invalid;
  end
else if (month=4)or(month=6)or(month=9)or(month=11) then
  begin
    if day>30 then goto invalid;
  end;

  str:=resultstring;
  result:=true;
  exit;
invalid:
  str:=resultstring+stemp;
  result:=false;
  exit;
end;
//---------------------------------------------------------------------
function identifilize( var str:string; len:integer ) : boolean ;
var      // ʹ�����ִ�'�����ʶ��'��, �Ծ߱�'Ψһ��ʶ'������.
i, l :integer;
begin
str:=trim(str);     //Ԥ��ȥ��Ŀ�괮��ǰ���ո�ͺ�׺�ո�.
l:=length(str);
i:=pos(' ', str);
result:=((l>0)and(l<=len)and(i=0));
//Ŀ�괮������Ϊ�մ����ں��ո�,��Ϊ���Ϸ�.
if (result) then  for i:=l+1 to len do str:=str+' ';
//�����涨����,�򲹺�׺�ո�,�Ա�֤������ĸ�ʽ��.
end;
//---------------------------------------------------------------------
procedure logicalexplink( var objectexp:string; const optype:char;
                          const appendexp:string );
var anotherexp: string;
begin
objectexp:=trim(objectexp);   //������С�ִ�"���".
anotherexp:=trim(appendexp);
if (anotherexp='') then       //���Ӵ�Ϊ�մ�,��Ŀ�괮������(�淶)����.
  begin
    if (objectexp<>'') then objectexp:='(' + objectexp + ')';
    exit;
  end;
if (objectexp='') then        //Ŀ�괮ԭΪ�մ�,��ȡ�淶��Ĵ��Ӵ�
  begin                       //    Ϊ��������.
    objectexp:='(' + anotherexp + ')';
    exit;
  end;
case optype of      //�����Էǿ�,�� optype �����߼����.
  '&': objectexp:='((' + objectexp + ')AND(' + anotherexp + '))';//��
  '|': objectexp:='((' + objectexp + ')OR(' + anotherexp + '))'; //��
  '~': objectexp:='(NOT(' + anotherexp + '))';                     //��
  '^': objectexp:='((' + objectexp + ')XOR(' + anotherexp + '))' //���
  else    // optype �쳣.
    begin
      showmessage('LogicalExpLink error: optype mismatch.');
      abort;
    end;
end;  // of case
end;
//------------------------------------------------------------------
procedure switchtolongyear(var tstr:string; const separator:string);
var       // ������������'���'������'yy'��ʽת��Ϊ'yyyy',���������.
i, j: integer;
stemp: string;
begin
stemp:=tstr;
i:=pos(separator, stemp);  // ��һ��separator
if i=0 then exit;          // ԭ�ִ���separator(�ش�),��ԭ������.
delete(stemp, i, 1);
i:=pos(separator, stemp);  // �ڶ���separator
if i=0 then exit;          // ԭ�ִ�����һ��separator(�ش�),��ԭ������.
stemp:=trim( copy(tstr,i+2,length(tstr)-i-2+1) );
j:=length(stemp);
case j of         //����'���'�ִ���ĩ 2λ.
  1    : stemp:='0'+stemp;
  2    : ;
  else exit;    //'���'�ִ����� =0(�մ�)�� >2(�ѱ���Ϊ'yyyy'��Ƿ�
                  // ����),��ԭ������.
end;  // of case
delete(tstr, i+2, length(tstr)-i-2+1);
stemp:=copy(formatdatetime('yyyy',now), 1, 2)+stemp;
tstr:=tstr+stemp;
end;
//------------------------------------------------------------------
procedure switchtoshortyear(var tstr:string; const separator:string);
var       // ������������'���'������'yyyy'��ʽת��Ϊ'yy',���������.
i, j: integer;  //һ���㷨������, tstr������Ϊ�Ϸ���'mm/dd/yyyy'��ʽ.
stemp: string;
begin
stemp:=tstr;
i:=pos(separator, stemp);  // ��һ��separator
if i=0 then exit;          // ԭ�ִ���separator(�ش�),��ԭ������.
delete(stemp, i, 1);
i:=pos(separator, stemp);  // �ڶ���separator
if i=0 then exit;          // ԭ�ִ�����һ��separator(�ش�),��ԭ������.
stemp:=trim( copy(tstr,i+2,length(tstr)-i-2+1) );
j:=length(stemp);
if (j<=2) then exit;//'���'�ִ�Ϊ�ջ� 1<=����<=2(�ѱ���Ϊ'yy'),��ԭ������.
stemp:=copy(stemp, j-1, 2);// һ��ȡ'���'�ִ������2λ��Ϊ'yy'.
delete(tstr, i+2, length(tstr)-i-2+1);
tstr:=tstr+stemp;
end;
//------------------------------------------------------------------
function gethostname: string;
var
reg: TRegistry;
tstr: string;
boolvar: boolean;
begin
result:='';
reg:=TRegistry.Create;
reg.RootKey:=HKEY_LOCAL_MACHINE;

tstr:='\System\CurrentControlSet\control\ComputerName\ComputerName';
boolvar:=reg.OpenKey(tstr, false);
if (boolvar) then
  begin
    boolvar:=reg.ValueExists('ComputerName');
    if (boolvar) then  result:=reg.ReadString('ComputerName');
  end;
reg.Free;
end;
//------------------------------------------------------------------
function getusername: string;
var
reg: TRegistry;
tstr: string;
boolvar: boolean;
begin
result:='';
reg:=TRegistry.Create;
reg.RootKey:=HKEY_LOCAL_MACHINE;

tstr:='\Network\Logon';
boolvar:=reg.OpenKey(tstr, false);
if (boolvar) then
  begin
    boolvar:=reg.ValueExists('username');
    if (boolvar) then  result:=result+reg.ReadString('username');
  end;
reg.Free;
end;
//------------------------------------------------------------------
function milliseconddiff(starttime: Tdatetime; endtime: Tdatetime)
                        : integer;
var
days: integer;
sta_hh, sta_mi, sta_ss, sta_ms: Word;
end_hh, end_mi, end_ss, end_ms: Word;
begin
DecodeTime(starttime, sta_hh, sta_mi, sta_ss, sta_ms);
DecodeTime(endtime  , end_hh, end_mi, end_ss, end_ms);
days:=trunc(endtime)-trunc(starttime);
result:=(((days*24+end_hh-sta_hh)*60+(end_mi-sta_mi))*60
         +(end_ss-sta_ss))*1000+(end_ms-sta_ms);
end;
//------------------------------------------------------------------
end.
