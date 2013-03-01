unit Safecode;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> Safecode
   <What> ��д�ɿ���������ƶ��Ե��ж�
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses Sysutils;

type
  // %EUnexpectedValue : һ������/���̷���һ�����ɹ��Ľ��ʱ������CheckXXX����������
  EUnexpectedValue = class(exception);

procedure RaiseUnexpectedValue(const Msg:string='');

// %CheckZero : #n must be 0, otherwise RaiseUnexpectedValue
procedure CheckZero(n:integer; const Msg:string='');

// %CheckZero : #n must not be 0, otherwise RaiseUnexpectedValue
procedure CheckNotZero(n:integer; const Msg:string='');

// %CheckTrue : #b must not be true, otherwise RaiseUnexpectedValue
procedure CheckTrue(b : boolean; const Msg:string='');

// %CheckObject : #obj must not be nil, otherwise RaiseUnexpectedValue
procedure CheckObject(obj : TObject; const Msg:string='');

// %CheckPtr : #Ptr must not be nil, otherwise RaiseUnexpectedValue
procedure CheckPtr(Ptr : Pointer; const Msg:string='');


type
  // %EInvalidParam : ������Ĳ�����Чʱ������
  EInvalidParam = class(Exception);
  // %EIndexOutOfRange : ����Խ��ʱ����
  EIndexOutOfRange = class(Exception);
  // %ECannotDo : ����ִ��ָ������ʱ����
  ECannotDo = class(Exception);

procedure RaiseInvalidParam;
procedure RaiseIndexOutOfRange;
procedure RaiseConvertError;
procedure RaiseCannotDo(const info:string);

// %CheckRange : ��(index<min) or (index>max)ʱ RaiseIndexOutOfRange
procedure CheckRange(index,min,max : integer);

resourcestring
  SUnexpectedError = 'An unexpected value that may be due to a unsuccessfal call';
  SOutOfRangeError = '%d out of range [%d,%d]';

implementation

procedure RaiseUnexpectedValue(const Msg:string='');
begin
  if Msg<>'' then
    raise EUnexpectedValue.create(msg)
  else
    raise EUnexpectedValue.create(
     SUnexpectedError);
end;

procedure CheckZero(n:integer; const Msg:string='');
begin
  if (n<>0) then RaiseUnexpectedValue(msg);
end;

procedure CheckNotZero(n:integer; const Msg:string='');
begin
  if (n=0) then RaiseUnexpectedValue(msg);
end;

procedure CheckTrue(b : boolean; const Msg:string='');
begin
  if not b then
    RaiseUnexpectedValue(msg);
end;

procedure CheckObject(obj : TObject; const Msg:string='');
begin
  if obj=nil then RaiseUnexpectedValue(msg);
end;

procedure CheckPtr(Ptr : Pointer; const Msg:string='');
begin
  if Ptr=nil then RaiseUnexpectedValue(msg);
end;

procedure RaiseInvalidParam;
begin
  raise EInvalidParam.create('Invalid Property Type');
end;

procedure RaiseIndexOutOfRange;
begin
  raise EIndexOutOfRange.create('Index out of range');
end;

procedure RaiseConvertError;
begin
  raise EConvertError.Create('A convert error!');
end;

procedure RaiseCannotDo(const info:string);
begin
  raise ECannotDo.Create(info);
end;

procedure CheckRange(index,min,max : integer);
begin
  if (index<min) or (index>max) then
    raise EIndexOutOfRange.CreateFmt(SOutOfRangeError,[Index,Min,Max]);
end;

end.
