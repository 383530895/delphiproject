unit BDACore;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>BDACore
   <What>Ϊ��֧�ֶ�IDispatch��ʵ�ֶ�׼����
   <Written By> Huang YanLai (������)
   <History>
**********************************************}

interface

uses windows,ActiveX,ComObj;

const
  BDATypeLibName = 'BasicDataAccess.tlb';

{
  <Function>getBDATypeLib
  <What>Ϊ��֧�ֶ�IDispatch��ʵ�ֶ�׼����
  <Params>
    -
  <Return>
  <Exception>
}
function getBDATypeLib : ITypeLib;

resourcestring
  SCannotFindTypeLib = '�����ҵ�COM���Ϳ��ļ�(BasicDataAccess.tlb)';

implementation

uses BasicDataAccess_TLB, RegSvrUtils, SysUtils, KSStrUtils;

var
  StdBDA: ITypeLib = nil;

function getBDATypeLib : ITypeLib;
begin
  result := StdBDA;
end;

procedure InitTypeLib;
var
  R : HResult;
  TypeLibFile : string;
  ModuleName : array[0..MAX_PATH-1] of Char;
begin
  R := LoadRegTypeLib(LIBID_BasicDataAccess, 1, 0, 0, StdBDA);
  if not Succeeded(R) then
  begin
    TypeLibFile := BDATypeLibName;
    // ������ļ����ڵ�ǰĿ¼���棬ʹ��ģ������Ŀ¼������ļ�
    if not FileExists(TypeLibFile) then
    begin
      FillChar(ModuleName,SizeOf(ModuleName),0);
      GetModuleFileName(hInstance,@ModuleName,SizeOf(ModuleName)-1);
      TypeLibFile := string(PChar(@ModuleName));
      TypeLibFile := AddPathAndName(ExtractFilePath(TypeLibFile),BDATypeLibName);
    end;
    //MessageBox(0,PChar(TypeLibFile),'Debug',MB_OK	or MB_ICONINFORMATION or MB_APPLMODAL);
    RegisterComServer(TypeLibFile, rtTypeLib, raReg);
    if not Succeeded(LoadRegTypeLib(LIBID_BasicDataAccess, 1, 0, 0, StdBDA)) then
      raise Exception.Create(SCannotFindTypeLib);
  end;
end;

initialization
  InitTypeLib;

end.
