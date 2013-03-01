unit RPDBCB;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDBCB
   <What>ʵ�ֱ�����Ҫ�����ݼ��Ļص���������
   <Written By> Huang YanLai (������)
   <History>
**********************************************}

interface

const
  // �����ֶ���������
  cdtInteger=0; // 32bits �з�������
  cdtFloat=1;   // double
  cdtString=2;  // PChar
  cdtDate=3;    // TDateTime
  cdtOther=4;
  cdtBinary=5;

type
  // ����������ݼ��Ļص��������͡�ע����÷�ʽ����stdcall�������ĵ�һ����������Dataset : Pointer
  TDBStdProc = procedure (Dataset : Pointer); stdcall;
  TDBFirstProc = TDBStdProc;
  TDBNextProc = TDBStdProc;
  TDBPriorProc = TDBStdProc;
  TDBLastProc = TDBStdProc;
  TDBBofProc = function (Dataset : Pointer):LongBool; stdcall;
  TDBEofProc = function (Dataset : Pointer):LongBool; stdcall;
  TDBFieldCount = function (Dataset : Pointer):Integer; stdcall;
  // FieldIndex ��0��ʼ
  // TDBGetFieldName����ʵ�ʳ��ȡ�������Buffer=nil�ĵ����Ȼ��ʵ�ʳ��ȣ�Ȼ��ΪBuffer�����ڴ棬����ٴε����������
  TDBGetFieldName = function (Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
  // Should return gfdtInteger(0),gfdtFloat(1),gfdtString,gfdtDate,gfdtOther,gfdtBinary for Datatype
  TDBGetFieldDataType = function (Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
  TDBGetInteger = function (Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
  TDBGetFloat = function (Dataset : Pointer; FieldIndex : Integer):Double; stdcall;
  // TDBGetString����ʵ�ʳ��ȡ�������Buffer=nil�ĵ����Ȼ��ʵ�ʳ��ȣ�Ȼ��ΪBuffer�����ڴ棬����ٴε����������
  TDBGetString = function  (Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
  TDBGetDateTime = function (Dataset : Pointer; FieldIndex : Integer):TDatetime; stdcall;

  {
    <record>
    <What>TDatasetRecord
    <Field>
      Dataset - ָ�룬������־���ݼ������ֵ�����ݵ�������ĺ����ĵ����С�
      First   - �����ݼ��Ĺ���ƶ�����ǰ�档���ú�BofӦ�÷���True��
      Next    - �����ݼ��Ĺ������ƶ�һ�С�
      Prior   - �����ݼ��Ĺ����ǰ�ƶ�һ�С�
      Last    - �����ݼ��Ĺ���ƶ�������档���ú�EofӦ�÷���True��
      Bof     - ���ݼ��Ĺ���Ƿ�����ǰ�档
      Eof     - ���ݼ��Ĺ���Ƿ�������档
      FieldCount  - �������ݼ����ֶ���Ŀ��
      GetFieldName - �������ݼ����ֶ����ơ�
      GetFieldDataType - �������ݼ����ֶ��������͡�
      GetInteger  - ����ֶε�����ֵ
      GetFloat    - ����ֶεĸ�����ֵ
      GetString   - ����ֶε�����ֵ
      GetDateTime - ����ֶε�����ֵ
  }
  TDatasetRecord = packed record
    Dataset : Pointer;
    First   : TDBFirstProc;
    Next    : TDBNextProc;
    Prior   : TDBPriorProc;
    Last    : TDBLastProc;
    Bof     : TDBBofProc;
    Eof     : TDBEofProc;
    FieldCount : TDBFieldCount;
    GetFieldName  : TDBGetFieldName;
    GetFieldDataType  : TDBGetFieldDataType;
    GetInteger    : TDBGetInteger;
    GetFloat      : TDBGetFloat;
    GetString     : TDBGetString;
    GetDateTime   : TDBGetDateTime;
  end;

  PDatasetRecord = ^TDatasetRecord;

implementation

end.
