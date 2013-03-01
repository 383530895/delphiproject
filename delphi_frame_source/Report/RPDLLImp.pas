unit RPDLLImp;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDLLImp
   <What>ʵ����һ����ӡ����Ķ�̬���ӿ�Ľӿں���
   <Written By> Huang YanLai (������)
   <History>
**********************************************}

interface

uses RPDBCB;

// ���������Ϣ
const
  RPEOK = 0;
  RPEError = -1;
  RPEHandleError = -2;
  RPELoad = -3;
  RPECreate = -4;
  RPBinding = -5;
  RPNotCreate = -6;
  RPOutputText = -7;

type
  TReportInfoHandle = Pointer;

{ ��׼�ĵ���˳��
  1��NewReportInfo
  2��LoadFromFile
  3��BingDataset
  4��SetVariant����ѡ��
  5��Print/Preview/PrintToFile
  6��FreeReportInfo
}
// ����������
function  NewReportInfo : TReportInfoHandle; stdcall;

// �ͷű�����
procedure FreeReportInfo(Handle : TReportInfoHandle); stdcall;

// ��ȡ�����ʽ�ļ�
function  LoadFromFile(Handle : TReportInfoHandle; FileName : PChar):Integer; stdcall;

// �����ݼ��ṹ�����ݼ��ṹ�����RPDBCB.pas�������߱���ʵ����Щ�ص�����
function  BingDataset(Handle : TReportInfoHandle; DatasetName : PChar; DatasetRecord : PDatasetRecord):Integer; stdcall;

// ��ӡ
function  Print(Handle : TReportInfoHandle):Integer; stdcall;

// Ԥ��
function  Preview(Handle : TReportInfoHandle):Integer; stdcall;

// ���ñ�����ֵ
function  SetVariant(Handle : TReportInfoHandle; Name,Value : PChar):Integer; stdcall;

// �������
function  Clear(Handle : TReportInfoHandle):Integer; stdcall;

// ��ӡ��ָ�����ļ�
function  PrintToFile(Handle : TReportInfoHandle; FormatFileName, OuputFileName : PChar):Integer; stdcall;

implementation

uses Classes, RPDBCBImp, RPDesignInfo, TextOutScripts, LogFile;

function  NewReportInfo : TReportInfoHandle; stdcall;
var
  RI : TReportInfo;
begin
  RI := TReportInfo.Create(nil);
  RI.NewDataEntriesClass(TRPCBDataEntries);
  Result := TReportInfoHandle(RI);
end;

procedure FreeReportInfo(Handle : TReportInfoHandle); stdcall;
begin
  if Handle<>nil then
    TReportInfo(Handle).Free;
end;

function  LoadFromFile(Handle : TReportInfoHandle; FileName : PChar):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    Result := RPEOK;
    try
      Result := RPELoad;
      TReportInfo(Handle).LoadFromFile(FileName);
      Result := RPECreate;
      TReportInfo(Handle).CreateReport;
      Result := RPEOK;
    except
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  BingDataset(Handle : TReportInfoHandle; DatasetName : PChar; DatasetRecord : PDatasetRecord):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TRPCBDataEntries(TReportInfo(Handle).DataEntries).AddRecord(DatasetName, DatasetRecord);
      Result := RPEOK;
    except
      Result := RPBinding;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  Print(Handle : TReportInfoHandle):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TReportInfo(Handle).Print;
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  Preview(Handle : TReportInfoHandle):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TReportInfo(Handle).Preview;
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  SetVariant(Handle : TReportInfoHandle; Name,Value : PChar):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      {
      if TReportInfo(Handle).Environment=nil then
        Result := RPNotCreate else
      begin
        TReportInfo(Handle).Environment.VariantValues.Values[Name]:=Value;
        Result := RPEOK;
      end;
      }
      TReportInfo(Handle).SetVariantValue(Name,Value);
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  Clear(Handle : TReportInfoHandle):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TReportInfo(Handle).Clear;
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  PrintToFile(Handle : TReportInfoHandle; FormatFileName, OuputFileName : PChar):Integer; stdcall;
var
  ScriptContext : TScriptContext;
begin
  if Handle<>nil then
  begin
    if TReportInfo(Handle).Environment=nil then
      Result := RPNotCreate else
    begin
      try
        ScriptContext := TScriptContext.Create(nil);
        try
          ScriptContext.Environment := TReportInfo(Handle).Environment;
          Result := RPELoad;
          ScriptContext.LoadScripts(string(FormatFileName));
          Result := RPOutputText;
          ScriptContext.Output(string(OuputFileName));
          Result := RPEOK;
        finally
          ScriptContext.Free;
        end;
      except
        Result := RPEError;
        WriteException;
      end;
    end;
  end else
    Result := RPEHandleError;
end;

initialization
  openLogFile('',true,false);
end.
