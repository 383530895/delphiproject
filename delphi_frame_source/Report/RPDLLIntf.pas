unit RPDLLIntf;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDLLIntf
   <What>������һ����ӡ����Ķ�̬���ӿ�Ľӿں���
   <Written By> Huang YanLai (������)
   <History>
**********************************************}

interface

uses RPDBCB;

const
  // ���������Ϣ
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

const
  DLLName = 'RPCBDLL.DLL';

function  NewReportInfo : TReportInfoHandle; stdcall; external DLLName;

procedure FreeReportInfo(Handle : TReportInfoHandle); stdcall; external DLLName;

function  LoadFromFile(Handle : TReportInfoHandle; FileName : PChar):Integer; stdcall; external DLLName;

function  BingDataset(Handle : TReportInfoHandle; DatasetName : PChar; DatasetRecord : PDatasetRecord):Integer; stdcall; external DLLName;

function  Print(Handle : TReportInfoHandle):Integer; stdcall; external DLLName;

function  Preview(Handle : TReportInfoHandle):Integer; stdcall; external DLLName;

function  SetVariant(Handle : TReportInfoHandle; Name,Value : PChar):Integer; stdcall; external DLLName;

function  Clear(Handle : TReportInfoHandle):Integer; stdcall; external DLLName;

function  PrintToFile(Handle : TReportInfoHandle; FormatFileName, OuputFileName : PChar):Integer; stdcall; external DLLName;

end.
