unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,declaredll,strutils, ComCtrls;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  port,baud:integer;



implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
//����д��
{
����֧�֣�
��վ��
}
var
    i:byte;
    j:char;
    mylen:byte;
    status:byte;//��ŷ���ֵ
    myareano:byte;//����
    authmode:byte;//�������ͣ���A�����B����
    myctrlword:byte;//������
	  mypicckey:array[0..5] of byte;//����
    mypiccserial:array[0..3] of byte;//�����к�
    mypiccdata:array[0..47] of byte;//�����ݻ���
    thistime:TDate;
    Year,Month,Day:Word;

    strls:string;

begin

   //������ָ��,�����ֵĺ�����鿴����˾��վ�ṩ�Ķ�̬��˵��
   myctrlword := BLOCK0_EN + BLOCK1_EN;

    //ָ������
    myareano := 9;//ָ��Ϊ��9��
    //��������ģʽ
    authmode := 1;//����0��ʾ��A������֤���Ƽ���A������֤

    //ָ������
    mypicckey[0] := $ff;
    mypicckey[1] := $ff;
    mypicckey[2] := $ff;
    mypicckey[3] := $ff;
    mypicckey[4] := $ff;
    mypicckey[5] := $ff;

    //��һ�飺AB,����7λ������û�оͲ���
    //�Ա�0��ʾŮ��1��ʾ�У���ʱ�䣨2008-10-22�����ĸ��ֽ�, 9���ֽ�,1���ֽ�


    //��ȡ��һ��
    //AB
    if (Length(Edit1.Text) <> 2) then
    begin
      ShowMessage('��һ���ַ���ֻ��Ϊ2��Ӣ�Ļ�1������');
      Edit1.SelectAll();
      Edit1.SetFocus();
      exit;
    end;
    mypiccdata[0] := byte(Edit1.Text[1]);
    mypiccdata[1] := byte(Edit1.Text[2]);

    //����
    mylen := Length(Edit2.Text);
    if (mylen > 14) then
    begin
      ShowMessage('�ڶ����ַ�����ͨ����14��Ӣ�Ļ�7������');
      Edit2.SelectAll();
      Edit2.SetFocus();
      exit;
    end;
    for i := 1 to mylen do
    begin
      mypiccdata[i+1] := byte(Edit2.Text[i]);
    end;
    for i := (mylen+1) to 11 do
    begin
      mypiccdata[i+1] := 0;
    end;
    //��ȡ�ڶ���

    //�Ա�
    if ComboBox1.Text = '��' then
    begin
      mypiccdata[0+16] := 1;
    end
    else
    begin
      mypiccdata[0+16] := 0;
    end;
    //����
    //thistime.
     thistime:= DateTimePicker1.Date;
     DecodeDate(thistime,Year,Month,Day);
     mypiccdata[1+16]:= StrToInt('$' + IntToStr(Year-2000));
     mypiccdata[2+16]:= StrToInt('$' + IntToStr(Month));
     mypiccdata[3+16]:= StrToInt('$' + IntToStr(Day));;

    //���֤

    mylen := Length(Edit3.Text);
    if (NOT((mylen = 15) or (mylen = 18))) then
    begin
      ShowMessage('���֤�ַ���ֻ����15λ��18λ��');
      Edit3.SelectAll();
      Edit3.SetFocus();
      exit;
    end;

    if(mylen = 15) then
    begin
      for i := 1 to 15 do
      begin
        j := Edit3.Text[i];
        if not((j>='0') and (j<='9') or (j>='a') and (j<='f')or (j>='A') and (j<='F')) then
        begin
          ShowMessage('���֤�ַ�����ʽ����');
          Edit3.SelectAll();
          Edit3.SetFocus();
          exit;
        end;

      end;
      mypiccdata[4+16] := 0;
      for i := 0 to 6 do
      begin
        mypiccdata[5+16+i] := StrToInt('$' + copy(Edit3.Text,1+i*2,2));
      end;
      mypiccdata[5+16+7]  :=  StrToInt('$' + copy(Edit3.Text,1+7*2,1) + '0');

    end
    else
    begin
      for i := 1 to 17 do
      begin
        j := Edit3.Text[i];
        if not((j>='0') and (j<='9') or (j>='a') and (j<='f')or (j>='A') and (j<='F')) then
        begin
          ShowMessage('���֤�ַ�����ʽ����');
          Edit3.SelectAll();
          Edit3.SetFocus();
          exit;
        end;

      end;

      mypiccdata[4+16] := 1;
      for i := 0 to 7 do
      begin
        mypiccdata[5+16+i] := StrToInt('$' + copy(Edit3.Text,1+i*2,2));
      end;
      mypiccdata[5+16+8]  :=  StrToInt('$' + copy(Edit3.Text,1+8*2,1) + '0');
      mypiccdata[5+16+9]  :=  byte(Edit3.Text[2+8*2]);


    end;



    //����


    status := piccwriteex(myctrlword,@mypiccserial,myareano,authmode,@mypicckey,@mypiccdata);
        //�������趨�ϵ㣬Ȼ��鿴mypiccserial��mypiccdata��
        //������ piccreadex�����ɶ��������кŵ� mypiccserial�����������ݵ�mypiccdata��
        //������Ա�����Լ�����Ҫ����mypiccserial��mypiccdata �е������ˡ�



        //�����غ���

        case status of
          0:
            begin
            pcdbeep(50);
            ShowMessage('д���ɹ�');
            end;

          8: ShowMessage('�뽫�����ڸ�Ӧ��');


        else
          begin
          ShowMessage('��д��û���߻���������û��װ');
          end;
        end;

        //���ؽ���
        {
        #define ERR_REQUEST 8//Ѱ������
        #define ERR_READSERIAL 9//�����������
        #define ERR_SELECTCARD 10//ѡ������
        #define ERR_LOADKEY 11//װ���������
        #define ERR_AUTHKEY 12//������֤����
        #define ERR_READ 13//��������
        #define ERR_WRITE 14//д������

        #define ERR_NONEDLL 21//û�ж�̬��
        #define ERR_DRIVERORDLL 22//��̬������������쳣
        #define ERR_DRIVERNULL 23//��������������δ��װ
        #define ERR_TIMEOUT 24//������ʱ��һ���Ƕ�̬��û�з�ӳ
        #define ERR_TXSIZE 25//������������
        #define ERR_TXCRC 26//���͵�CRC��
        #define ERR_RXSIZE 27//���յ���������
        #define ERR_RXCRC 28//���յ�CRC��
        }
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.Edit4Change(Sender: TObject);
var
  i:integer;
  j:char;
  isok:boolean;
  len:integer;
  strchar:array[0..200] of byte;//�����ݻ���
  edc:byte;//У��ͻ���
  edc0:byte;//У��ͻ���

  str0:string;//��ſ���
  str1:string;//��һ��
  str2:string;//�ڶ���
  str3:string;//������
  str4:string;//���Ŀ�
  cardhao:Longword;//����
  pointer:integer;


begin
  //30 310CE24A 4142 4 D5C5C8FD 1 081021 1 44010519880808586580A
  if Length(Edit4.Text)>28 then//�ַ�����С����
  begin
    //У���Ƿ�Ϊ��Ч���ַ�����Чʱ������ת��
    isok := true;
    for i := 1 to Length(Edit4.Text) do
    begin
      j := Edit4.Text[i];
      if not((j>='0') and (j<='9') or (j>='a') and (j<='f')or (j>='A') and (j<='F')) then
      begin
        isok := false;

      end;
    end;

    if not isok then
    begin

      exit;
    end;

    //Ч�鳤���Ƿ���ȷ
    len := StrToInt('$' + copy(Edit4.Text,1,2));
    if len <> (Length(Edit4.Text)-4) then
    begin
        //ShowMessage('1');
        exit;
    end;
    //��У��
    edc0 := StrToInt('$' + copy(Edit4.Text,Length(Edit4.Text)-1,2));
    edc  := 0;
    for i := 3 to Length(Edit4.Text)-2 do
    begin
      edc := edc xor byte(Edit4.Text[i]);
    end;

    if edc <> edc0 then
    begin
       //ShowMessage('1');
       exit;

    end;
    //4294967295 | A | | VIP�ͻ�#2008-10-19 |
    //ת����ָ�����ַ�
    //1---����
    cardhao := StrToInt('$' + copy(Edit4.Text,3,8));
    str1 := '0000000000' + IntToStr(cardhao);
    str0 := copy(str1,length(str1)-9,10);

    //2---�����һ��
    SetLength(str1,2);
    for i := 1 to 2 do
    begin
      str1[i] := char(StrToInt('$' + copy(Edit4.Text,9+2*i,2)));
    end;
    //ShowMessage(str1);

    //3---����ڶ���
    pointer := 15;
    len :=  StrToInt('$' + copy(Edit4.Text,pointer,1));
    SetLength(str2,len);

    for i := 1 to len do
    begin
      str2[i] := char(StrToInt('$' + copy(Edit4.Text,pointer-1+2*i,2)));
    end;
    str2 := str2 + '#';
    pointer := pointer+1+2*len;
    if copy(Edit4.Text,pointer,1) = '0' then
    begin
      str2 := str2 + 'Ů#';
    end
    else
    begin
      str2 := str2 + '��#';
    end;

    str2:= str2 + '20'+ copy(Edit4.Text,pointer+1,2) + '-' +  copy(Edit4.Text,pointer+3,2) + '-' + copy(Edit4.Text,pointer+5,2);

    //4---���������֤
    pointer := pointer +7;

    if (copy(Edit4.Text,pointer,1) = '0') then
    begin //15λ���֤
      str3 := copy(Edit4.Text,pointer+1,15);
    end
    else
    begin//18λ���֤
      str3 := copy(Edit4.Text,pointer+1,17);
      SetLength(str3,18);
      str3[18] := char(StrToInt('$' + copy(Edit4.Text,pointer+1+17,2)));
    end;

   //showmessage(str3);
    //1234567890 | A | ����#��#1980-11-25 | VIP�ͻ�#2008-10-19 |
    Edit4.Text :=str0 + '|'+ str1 + '|'+ str2 + '|'+str3 + '|';

  end;




end;

end.
