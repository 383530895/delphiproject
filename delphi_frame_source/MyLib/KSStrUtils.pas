unit KSStrUtils;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>StrUtils
   <What>�ַ���������
   <Written By> Huang YanLai (������)
   <History>
**********************************************}

interface

uses SysUtils, Classes;

(******************************
  �ļ�������
*******************************)

{
  <Function>ExtractOnlyFileName
  <What>ȡ�����ļ������֣�������·���ͺ�׺
  <Params>
    -
  <Return>
  <Exception>
}
function ExtractOnlyFileName(const FileName:string):string;

{
  <Procedure>ParseFileName
  <What>���ļ����ֽ�Ϊ�ļ����ͺ�׺������
  <Params>
    FullName-��������
    FileName-�ļ����Ʋ��֣������ļ�·��(���FullName�������·��)
    Ext-�ļ���׺
  <Exception>
}
procedure ParseFileName(const FullName:string; var FileName,Ext:string);

{
  <Function>RelativeToFull
  <What>�����·��ת��Ϊʵ��·����
  <Params>
    Base-���·���Ĳ���·��
    Relative-��Ҫת����·��
  <Return>
    ���Relative��һ�����·�������������������ơ���һ���ַ�����'\'������ô����Base+Relative��
    ���򷵻�Relative
  <Exception>
}
function  RelativeToFull(const Base,Relative : string):string;

{
  <Function>AddPathAndName
  <What>����·�����ļ����ϳ��ļ�ȫ·�����ر�����'\'�ַ�
  if path like '*\'
    result := Path + FileName
  else
    result := Path + '\' + FileName
  <Params>
    -
  <Return>
  <Exception>
}
function  AddPathAndName(const Path,FileName: string): string;

{
  <Function>ExpandPath
  <What>��֤���ص��ַ����ǿ�����Ϊ·�����ӵ��ļ�����ǰ��
  <Params>
    -
  <Return>
  ���PathΪ�գ�����Ϊ�գ����򷵻�ֵ��Path(Path�����һ���ַ���'\')����Path+'\'
  <Exception>
}
function  ExpandPath(const Path : string) : string;

{
  <Function> ������ļ��������ȡ����
  <What>
  <Params>
    FileName - ��ʽ��'$(Alias)\path'
  <Return>
  <Exception>
}
function  getAliasFromFileName(const FileName:string): string;

{
  <Procedure>ParseAlias
  <What>�����ļ��������ر��������·�����֡�
  ���FileName����ȷ�ı�����ʽ'$(Alias)\path'�����ر�����·����
  �������Ϊ�գ�·����FileName��ͬ
  <Params>
    -
  <Exception>
}
procedure ParseAlias(const FileName:string; var Alias,path:string);

type
  {
    <Class>EAliasNotDefined
    <What>�Ҳ�������������
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EAliasNotDefined = class(Exception);

{
  <Procedure>RaiseAliasNotDefined
  <What>�׳�û�б���������
  <Params>
    -
  <Exception>
}
procedure RaiseAliasNotDefined(const Alias : string);

(******************************
  ���ִ���
*******************************)

{
  <Function>ValidString
  <What>����ַ����Ƿ�����������
  <Params>
    -
  <Return>
  <Exception>
}
function ValidString(const S:string): boolean;

{
  <Function>ValidPChar
  <What>����ַ����Ƿ�����������
  <Params>
    -
  <Return>
  <Exception>
}
function ValidPChar(S:pchar): boolean;

{
  <Procedure>CorrectString
  <What>ɾ���������
  <Params>
    -
  <Exception>
}
procedure CorrectString(const Source:string; var Dest:string);

{
  <Procedure>CorrectPchar
  <What>ɾ���������
  <Params>
    -
  <Exception>
}
procedure CorrectPchar(Source,Dest:pchar);

(******************************
  �ַ�������
*******************************)

{
  <Function>StringMarch
  <What>ȷ�������ַ��������Ƴ̶ȡ����ִ�Сд
  <Params>
    MatchCount - ����s1,s2ǰMatchCount���ַ���ͬ
  <Return>
    �����ȫ��ͬ������true������false
  <Exception>
}
function  StringMarch(S1,S2:pchar; var MatchCount : integer):boolean;

{
  <Function>StartWith
  <What>�ж��ַ����Ƿ���ĳ�ض��Ӵ���ͷ�������ִ�Сд��
  <Params>
    -
  <Return>
  <Exception>
}
function  StartWith(const Str,HeadStr:string): boolean;

{
  <Procedure>seperateStr
  <What>���ַ������ݷָ���ţ��ֽ�Ϊ�������
  <Params>
    str - ԭʼ�ַ���
    seperateChars - �����ָ���ַ�����һ������
    parts - ����ֽ��Ժ�ĸ������֣�һ��һ��
    delBlank - �Ƿ�ÿ�����������ߵĿհ�ɾ��
  <Exception>
}
procedure seperateStr(const str:string;
  const seperateChars : TSysCharset;
  parts:TStrings;
  delBlank:boolean=true);

{
  <Procedure>seperateStrByBlank
  <What>���ݿհ׷ָ��ַ���
  <Params>
    -
  <Exception>
}
procedure seperateStrByBlank(const str:string;
  parts:TStrings);

{
  <Function>IsNumberCode
  <What>���S�ǲ�����������ɵġ�(S='',return true)
  <Params>
    -
  <Return>
  <Exception>
}
function  IsNumberCode(const S:string) : Boolean;

{
  <Function>IsValidChars
  <What>����ַ��������
  <Params>
    ValidChars - ������ַ��ļ���
  <Return>
  <Exception>
}
function  IsValidChars(const S:string; ValidChars : TSysCharSet) : Boolean;

{
  <Function>ExpandLeft
  <What>���S�ĳ���С��Base����ô��Base����߲������S����߲���
  <Params>
    -
  <Return>
  <Exception>
}
function  ExpandLeft(const S,Base : string): string;

{
  <Function>SpcCapToNormal
  <What>������ת����ŵ��ַ�����ԭΪ��ͨ�ַ�����ת�����ֻ֧��'\n'
  <Params>
    -
  <Return>
  <Exception>
  <Example>
  convert '1\n\\2' to '1'#13#10'\2'
}
function SpcCapToNormal(const SpcCap : string): string;

{
  <Function>NormalToSpcCap
  <What>����ͨ�ַ���ת��Ϊ����ת����ŵ��ַ�����ת�����ֻ֧��'\n'
  <Params>
    -
  <Return>
  <Exception>
  <Example>
  convert '1'#13#10'\2' to '1\n\\2'
}
function NormalToSpcCap(const Normal: string): string;

implementation

function ExtractOnlyFileName(const FileName:string):string;
var
  Ext : string;
begin
  {result := ExtractFileName(FileName);
  Ext := ExtractFileExt(result);
  result := copy(result,1,length(result)-length(Ext));}
  ParseFileName(ExtractFileName(FileName),result,Ext);
end;

procedure ParseFileName(const FullName:string; var FileName,Ext:string);
begin
  {FileName:= ExtractFileName(FullName);
  Ext := ExtractFileExt(FileName);
  FileName:= copy(result,1,length(FileName)-length(Ext));}
  Ext := ExtractFileExt(FullName);
  FileName:= copy(FullName,1,length(FullName)-length(Ext));
end;

function  RelativeToFull(const Base,Relative : string):string;
var
  Drive : string;
begin
  result := Relative;
  if (Relative<>'') and (Base<>'') then
  begin
    Drive := ExtractFileDrive(Relative);
    if (Drive='') and (Relative[1]<>'\') then
      if Base[length(Base)]='\' then
        Result := Base+Relative
      else
        Result := Base+'\'+Relative
  end;
end;

function  AddPathAndName(const Path,FileName: string): string;
begin
  if path='' then
    Result := FileName
  else
  if path[length(path)]='\' then
    result := Path + FileName
  else
    result := Path + '\' + FileName;
end;

// FileName = $(Alias)\path
function  getAliasFromFileName(const FileName:string): string;
var
  I : integer;
begin
  result:='';
  if length(FileName)>2 then
    if (FileName[1]='$') and (FileName[2]='(') then
    begin
      I := pos(')',Filename);
      if I>0 then
      begin
        result := Copy(FileName,3,I-2-1);
      end
    end
end;

// ParseAlias
procedure ParseAlias(const FileName:string; var Alias,path:string);
var
  I : integer;
begin
  Alias:='';
  Path:=FileName;
  if length(FileName)>2 then
    if (FileName[1]='$') and (FileName[2]='(') then
    begin
      I := pos(')',Filename);
      if I>0 then
      begin
        Alias := Copy(FileName,3,I-2-1);
        Path := Copy(FileName,I+1,length(FileName)-I);
      end;
    end;
end;

procedure RaiseAliasNotDefined(const Alias : string);
begin
  raise EAliasNotDefined.Create('Alias('+Alias+ ') is not defined!');
end;

// ���s����������֣�����false
function ValidString(const S:string): boolean;
begin
  result := ValidPChar(pchar(S));
end;

function ValidPChar(S:pchar): boolean;
var
  ChineseCharCount : integer;
begin
  //result:=true;
  ChineseCharCount:=0;
  if S<>nil then
  begin
    while S^<>#0 do
    begin
      if S^>=#$80 then inc(ChineseCharCount)
      else if (ChineseCharCount mod 2)<>0 then
      begin
        result := false;
        exit;
      end;
      inc(S);
    end;
  end;
  result := (ChineseCharCount mod 2)=0;
end;

procedure CorrectString(const Source:string; var Dest:string);
begin
  setLength(Dest,length(Source));
  CorrectPchar(pchar(source),pchar(Dest));
  setLength(Dest,length(pchar(Dest)));
end;

procedure CorrectPchar(Source,Dest:pchar);
begin
  assert(Source<>nil);
  assert(Dest<>nil);
  while Source^<>#0 do
  begin
    if (source^>=#$80) then
    begin
      if (source+1)^>=#$80 then
      begin
        // total
        Dest^:=source^;
        inc(Dest);
        inc(Source);
        Dest^:=source^;
        inc(Dest);
        inc(Source);
      end
      else inc(Source);
    end
    else
    begin
      Dest^:=source^;
      inc(Dest);
      inc(Source);
    end;
  end;
  Dest^:=#0;
end;

// StringMarch ����S1,S2�����Ƴ̶ȡ�
//  MatchCount : s1,s2ǰMatchCount���ַ���ͬ(������#0)
//  result : true (��ȫ��ͬ)��false(��ͬ)
function  StringMarch(S1,S2:pchar; var MatchCount : integer):boolean;
begin
  result := false;
  if (s1=nil) or (s2=nil) then
  begin
    MatchCount:=0;
  end
  else
  begin
    MatchCount:=0;
    while (s1^<>#0) and (s2^<>#0) do
      if s1^=S2^ then
      begin
        inc(MatchCount);
        inc(s1);
        inc(s2);
      end
      else
      begin
        result := false;
        exit;
      end;
    if s1^=s2^ then result:=true;
  end;
end;

function  StartWith(const Str,HeadStr:string): boolean;
begin
  result := CompareText(Copy(Str,1,length(HeadStr)),HeadStr)=0;
end;

// seperate str by seperateChars
procedure seperateStr(const str:string;
  const seperateChars : TSysCharset;
  parts:TStrings;
  delBlank:boolean=true);
var
  S : string;
  I,L,K : integer;
begin
  parts.clear;
  L := length(str);
  K := 1;
  for I:=1 to L do
  begin
    if str[I] in seperateChars then
    begin
      S:=copy(str,K,I-K);
      if delBlank then S:=trim(S);
      parts.add(S);
      K:=I+1;
    end;
  end;
  if K<=L then
  begin
    //S:=copy(str,K,I-K);
    S:=copy(str,K,L-K+1);
    if delBlank then S:=trim(S);
    parts.add(S);
  end;
end;

procedure seperateStrByBlank(const str:string;
  parts:TStrings);
var
  S : string;
  I : integer;
begin
  parts.clear;
  S := trim(str);
  S:=StringReplace(S,#9,' ',[rfReplaceAll]);
  I := pos(' ',S);
  while I>0 do
  begin
    parts.add(copy(S,1,I-1));
    delete(S,1,I);
    S:=trim(S);
    I := pos(' ',S);
  end;
  if S<>'' then parts.add(S);
end;

// ���S�ǲ�����������ɵġ�(S='',return true)
function  IsNumberCode(const S:string): Boolean;
var
  P : Pchar;
begin
  Result := true;
  P := Pchar(S);
  while (P<>nil) and (P^<>#0) do
  begin
    if (P^<'0') or (P^>'9') then
    begin
      Result := false;
      break;
    end;
    Inc(P);
  end;
end;

// ���S�ĳ���С��Base����ô��Base����߲������S����߲���
function  ExpandLeft(const S,Base : string): string;
var
  len1,len2 : integer;
begin
  len1 := Length(Base);
  len2 := Length(S);
  if len2<Len1 then
    Result := Copy(Base,1,Len1-Len2)+S else
    Result := S;
end;

function  ExpandPath(const Path : string) : string;
begin
  if Path<>'' then
  begin
    if Path[Length(Path)]<>'\' then
      Result := Path+'\' else
      Result := Path;
  end else
    Result := Path;
end;

// ����ַ��������
function  IsValidChars(const S:string; ValidChars : TSysCharSet) : Boolean;
var
  P : PChar;
begin
  Result := true;
  P := PChar(S);
  while (P<>nil) and (P^<>#0) do
  begin
    if not (P^ in ValidChars) then
    begin
      Result := false;
      Break;
    end;
    Inc(P);
  end;
end;

function SpcCapToNormal(const SpcCap : string): string;
var
	PSpcCap : pchar;
  PResult,PResult2 : pchar;
begin
  if SpcCap='' then
  begin
    result := '';
    exit;
  end;
  SetLength(Result,length(SpcCap));
  PResult := pchar(Result);
  PResult2 := PResult;
	PSpcCap := pchar(SpcCap);
  if PSpcCap<>nil then
  begin
    while PSpcCap^<>#0 do
    begin
    	if PSpcCap[0]='\' then
      	if PSpcCap[1]='n' then
        begin
          PResult[0]:=#13;
          PResult[1]:=#10;
          inc(PSpcCap);
          inc(PResult);
        end
        else if PSpcCap[1]='\' then
        begin
          PResult[0]:='\';
          inc(PSpcCap);
        end
        else
        	//raise EConvertError.Create('SpcCapToNormal error!')
          PResult[0]:=PSpcCap[0]
      else
        PResult[0]:=PSpcCap[0];
      inc(PSpcCap);
      inc(PResult);
    end;
    PResult^:=#0;
  end;
  SetLength(Result,length(PResult2));
end;

function NormalToSpcCap(const Normal: string): string;
var
	PNormal,PResult,PResult2 : PChar;
begin
	if Normal='' then
  begin
    result := '';
    exit;
  end;
  SetLength(result,2*length(Normal));
  PNormal := pchar(normal);
  PResult := pchar(result);
  PResult2 := PResult;
  if PNormal<>nil then
  begin
    while PNormal^<>#0 do
    begin
    	if (PNormal[0]=#13) and (PNormal[1]=#10) then
      begin
          PResult[0]:='\';
          PResult[1]:='n';
          inc(PNormal);
          inc(PResult);
      end
      else if PNormal[0]='\' then
      begin
          PResult[0]:='\';
          PResult[1]:='\';
          inc(PResult);
      end
      else
        PResult[0]:=PNormal[0];
      inc(PNormal);
      inc(PResult);
    end;
    PResult^:=#0;
  end;
  SetLength(Result,length(PResult2));
end;

end.
