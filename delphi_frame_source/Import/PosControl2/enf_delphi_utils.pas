unit enf_delphi_utils;
//Delphiƽ̨�Ķ��󼰹��ܵ��õĸĽ���, �������Ҫʹ�����Ƶ��Ա๦�ܵ���.
interface

uses Windows, SysUtils, classes, forms, dbtables,
Dialogs;

procedure dbfresh(DataSet: TDBDataSet);
procedure clear_associatedobjlist(list: TStrings);
function getappname: string;
procedure overwriteinicfg(objlist, sourcelist: TStringList);
function getwindir: string;
function getwinsysdir: string;
procedure ReadyQuery(dbqry: TQuery; sqlcmd: string);
procedure AbortWithMsg(msg: string);

implementation

//=====================================================================
procedure dbfresh(DataSet: TDBDataSet);
var
priornum, i: integer;
//Property RecNo�����Ժ�Ϊ-1���ʲ����á�
begin
DataSet.DisableControls;
priornum:=0;
if (DataSet.Active) then
  while not(DataSet.BOF) do
    begin
      DataSet.Prior;
      priornum:=priornum+1;
    end;  // of while & if
if (priornum>0) then Dec(priornum);  //��BOF�Ķ���΢�����λ��
DataSet.Close;
DataSet.Open;
for i:=1 to priornum do DataSet.Next;
DataSet.EnableControls;
end;
//---------------------------------------------------------------------
procedure clear_associatedobjlist(list: TStrings);
var
baseobj: TObject;
i: integer;
begin
for i:=0 to (list.Count-1) do
if assigned(list.Objects[i]) then
  begin
    baseobj:=list.Objects[i];
    baseobj.Free;
    list.Objects[i]:=nil;
  end;
end;
//----------------------------------------------------------------------
function getappname: string;
var
tstr: string;
i: integer;
begin
tstr:=application.ExeName;
tstr:=ExtractFileName(tstr);  //ȥ·��.
i:=Pos('.', tstr);  //ȥ��չ��.
result:=Copy(tstr, 1, i-1);
end;
//----------------------------------------------------------------------
procedure overwriteinicfg(objlist, sourcelist: TStringList);
//�������� NAME=VALUE ��INI����:
//ͬ��������ֵ���Ǿ�ֵ; ԭ�޵Ĳ����Ŀ������;
//���ⲻ��Ŀ�������������䶯.
var
i, k: integer;
tstr: string;
begin
for i:=0 to (sourcelist.Count-1) do
  begin
    tstr:=sourcelist.Strings[i];
    k:=Pos('=', tstr);
    if (k=0) then continue;  //Դ�����з� NAME=VALUE ��ʽ���ִ�������.
    tstr:=sourcelist.Names[i];
    k:=objlist.IndexOfName(tstr);
    if (k>=0) then  objlist.Values[tstr]:=sourcelist.Values[tstr]
    else objlist.Add(sourcelist.Strings[i]);
  end;  // of for
end;
//----------------------------------------------------------------------
function getwindir: string;
var
len, i: integer;
pch: PChar;
tstr: string;
begin
len:=32;  //�ȴӱ���ϵͳĿ¼����INI�ļ�.
pch:=AllocMem(len);
i:=GetWindowsDirectory(pch, len);
if (i>len) then
  begin
    len:=i;
    ReallocMem(pch, len);
    i:=GetWindowsDirectory(pch, len);
  end;
if (i=0)or(i>len) then
  begin
    result:='';
  end
else  //�ѳɹ��ػ�ȡϵͳĿ¼.
  begin
    tstr:=string(pch);
    if (tstr[i]<>'\') then  tstr:=tstr+'\';  //��֤�����ִ���'\'��β.
    result:=tstr;
  end;  // of else
FreeMem(pch);
end;
//----------------------------------------------------------------------
function getwinsysdir: string;
var
len, i: integer;
pch: PChar;
tstr: string;
begin
len:=32;  //�ȴӱ���ϵͳĿ¼����INI�ļ�.
pch:=AllocMem(len);
i:=GetSystemDirectory(pch, len);
if (i>len) then
  begin
    len:=i;
    ReallocMem(pch, len);
    i:=GetSystemDirectory(pch, len);
  end;
if (i=0)or(i>len) then
  begin
    result:='';
  end
else  //�ѳɹ��ػ�ȡϵͳĿ¼.
  begin
    tstr:=string(pch);
    if (tstr[i]<>'\') then  tstr:=tstr+'\';  //��֤�����ִ���'\'��β.
    result:=tstr;
  end;  // of else
FreeMem(pch);
end;
//----------------------------------------------------------------------
procedure ReadyQuery(dbqry: TQuery; sqlcmd: string);
begin
dbqry.Active:=false;
dbqry.SQL.Clear;
sqlcmd:=trim(sqlcmd);
if (sqlcmd<>'') then  dbqry.SQL.Add(sqlcmd);
end;
//----------------------------------------------------------------------
procedure AbortWithMsg(msg: string);
begin
Showmessage(msg);
Abort;
end;
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//----------------------------------------------------------------------

end.

{  ������������̫���ҽ�����ֲ���
procedure dbfresh(DataSet: TDBDataSet);
begin
DataSet.Close;
DataSet.Open;
end;
}

