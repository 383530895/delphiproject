unit Unit1;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, OleServer, COMOBJ, IniFiles, StrUtils, DateUtils, ShellAPI,
    Menus, RzTray, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, DB,
    uDoorController, ExtCtrls, DBAccess, Ora, MemDS, OraSmart, Buttons;


type
    TForm1 = class(TForm)
        btnConfigOne: TButton;
        Text1: TMemo;
        btnExit: TButton;
        EditSN: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        EditIP1: TEdit;
        EditIP2: TEdit;
        EditIP3: TEdit;
        EditIP4: TEdit;
        Label6: TLabel;
        EditMask1: TEdit;
        EditMask2: TEdit;
        EditMask3: TEdit;
        EditMask4: TEdit;
        Label7: TLabel;
        EditGateway1: TEdit;
        EditGateway2: TEdit;
        EditGateway3: TEdit;
        EditGateway4: TEdit;
        btnManualRecord: TButton;
        btnConfigDev: TButton;
        btnInitPrivilege: TButton;
        btnMonitorDevice: TButton;
        btnDownload: TButton;
        btnDeletePrivilege: TButton;
        Edit2: TEdit;
        Label9: TLabel;
        Label10: TLabel;
        Edit3: TEdit;
        btnGetPrivilege: TButton;
        btnSyncTIme: TButton;
        btnCleanPrivilege: TButton;
        btnAddPriv: TButton;
        Timer1: TTimer;
        btnAutoGet: TButton;
        OraSession1: TOraSession;
        btnSyncData: TButton;
        OraQuery1: TOraQuery;
        btnAutoSync: TButton;
        btnStopTask: TButton;
        btnUploadData: TButton;
        Timer2: TTimer;
        btnAutoUpload: TButton;
        Timer3: TTimer;
        Timer4: TTimer;
        Label8: TLabel;
        TimerLabel8: TTimer;
        Label11: TLabel;
        IdUDPClient1: TIdUDPClient;
        BitBtn1: TBitBtn;
        Label12: TLabel;
        edtStuempno: TEdit;
        RzTrayIcon1: TRzTrayIcon;
        PopupMenu1: TPopupMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        Button1: TButton;
        cbDevice: TComboBox;
        N5: TMenuItem;
        btnAlwaysOpen: TButton;
        Button2: TButton;
        edtDelay: TEdit;
        Label13: TLabel;
        Label14: TLabel;
        Button3: TButton;
        btnConnectDevice: TButton;
        procedure btnConfigOneClick(Sender: TObject);
        procedure btnExitClick(Sender: TObject);
        procedure btnConfigDevClick(Sender: TObject);
        procedure btnInitPrivilegeClick(Sender: TObject);
        procedure btnMonitorDeviceClick(Sender: TObject);
        procedure btnDownloadClick(Sender: TObject);
        procedure btnSyncTImeClick(Sender: TObject);
        procedure btnGetPrivilegeClick(Sender: TObject);
        procedure btnDeletePrivilegeClick(Sender: TObject);
        procedure btnCleanPrivilegeClick(Sender: TObject);
        procedure btnAddPrivClick(Sender: TObject);
        procedure btnManualRecordClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure btnAutoGetClick(Sender: TObject);
        procedure btnSyncDataClick(Sender: TObject);
        procedure btnAutoSyncClick(Sender: TObject);
        procedure btnStopTaskClick(Sender: TObject);
        procedure btnAutoUploadClick(Sender: TObject);
        procedure Timer2Timer(Sender: TObject);
        procedure btnUploadDataClick(Sender: TObject);
        procedure Timer3Timer(Sender: TObject);
        procedure Timer4Timer(Sender: TObject);
        procedure TimerLabel8Timer(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure BitBtn1Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure N5Click(Sender: TObject);
        procedure btnAlwaysOpenClick(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure btnConnectDeviceClick(Sender: TObject);
    private
        { Private declarations }
        procedure getData(dataType: integer);
        procedure syncData(syncType: integer);
        procedure insertDataToYKT(recordFilename: string);
        procedure uploadDataToYKT();
        procedure buttonConfig(opType: integer);
    public
        { Public declarations }
    end;

    TDownCardThread = class(TThread)
    private
        AMemo: TMemo;
        ACardPhyID: array[0..32] of char;
    protected
        procedure Execute; override;
        procedure downCardPhyID;
    public
        constructor Create(memo: Tmemo);
    end;

var
    Form1: TForm1;
    syncfilename: string;
    datafilename: string;


procedure configDevice();
procedure connectDevice();
procedure initPrivilege();
function verifyUser(iType: integer; sParam: string): boolean;
procedure syncGetData();


implementation

uses FormWait, AES;
{$R *.dfm}

constructor TDownCardThread.Create(memo: Tmemo);
begin
    inherited Create(false);
    AMemo := memo;
    FreeOnTerminate := true;
end;

procedure TDownCardThread.downCardPhyID();
begin
    AMemo.Lines.Add(ACardPhyID);
end;

procedure TDownCardThread.Execute();
var
    devList, cardList, downList: TStringList;
    ip: string;
    i, devSN: integer;
    time1: tdatetime;
begin
    time1 := Now();
    Synchronize(downCardPhyID);
    sleep(downinternal);

    cardList := TStringList.Create;
    cardList.LoadFromFile(ExtractFilePath(paramstr(0)) + CARDLISTFILE);

    downList := TStringList.Create;
    for i := 0 to cardList.Count - 1 do begin
        if (Pos(',1', cardList[i]) > 0) then begin
            downList.Add(cardHexToNo(copy(cardList[i], 3, (Pos(',1', cardList[i]) - 3))));
        end;
    end;
    //��С�������򿨺�
    downList.CustomSort(NumBerSort);

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        downloadAllCardByOne(devSN, ip, 1, downList);
    end;

    downList.Free;
    cardList.Free;

    AMemo.lines.Add(format('�����豸Ȩ�޳�ʼ�����--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));
end;

procedure TForm1.btnConfigOneClick(Sender: TObject);
var
    strCmd: WideString; //Ҫ���͵�ָ��֡
    strFuncData: WideString; //Ҫ���͵Ĺ��ܼ�����
    strFrame: WideString; //���ص�����
    ret: Integer; //�����ķ���ֵ
    controllerSN: Integer; //���������к�

    //ˢ����¼����
    cardId: Integer; //����
    status: Integer; //״̬
    swipeDate: WideString; //����ʱ��

    strRunDetail: WideString; //������Ϣ

    recIndex: Integer; //��¼������
    errorNo: Integer; //���Ϻ�

    //����Ȩ������
    doorIndex: Integer; //�ź�
    cardno: array[0..2] of integer; //3������
    privilege: WideString; //Ȩ��
    privilegeIndex: Integer; //Ȩ��������
    cardIndex: Integer; //��������

    timeseg: WideString; //ʱ��

    //����ʵʱ���
    watchIndex: Integer; //���������
    recCnt: Integer; //ˢ����¼����

    wudp: Variant; //WComm_Operate����
    ipAddr: WideString;
    strMac: WideString;
    strHexNewIP: WideString; //New IP (ʮ������)
    strHexMask: WideString; //����(ʮ������)
    strHexGateway: WideString; //����(ʮ������)

    startLoc: Integer;

begin
    //.NET������ͨ�Ų��� (�������controllerSN����)
    controllerSN := StrToInt64(EditSN.Text); //����ʹ�õ�.NET ������
    ipAddr := ''; //Ϊ��, ��ʾ�㲥����ʽ

    Text1.Text := '������ͨ��' + '-' + IntToStr(controllerSN) + '-.NET';

    //��������
    wudp := CreateOleObject('WComm_UDP.WComm_Operate');

    //��ȡ����״̬��Ϣ
    strFuncData := '8110' + wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) ��ʾ��0����¼, Ҳ�����¼�¼
    strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '��ȡ������Ϣʧ��';
        Exit;
    end
    else begin
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '��ȡ������Ϣ�ɹ�';
        //��������Ϣ����ϸ����
        //�������ĵ�ǰʱ��
        strRunDetail := '';
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '�豸���к�S/N: ' + Chr(9) + IntToStr(wudp.GetSNFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '�豸ʱ��:      ' + Chr(9) + wudp.GetClockTimeFromRunInfo(strFrame);
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'ˢ����¼��:    ' + Chr(9) + IntToStr(wudp.GetCardRecordCountFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'Ȩ����:        ' + Chr(9) + IntToStr(wudp.GetPrivilegeNumFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + Chr(13) + Chr(10) + '�����һ��ˢ����¼: ' + Chr(9);
        swipeDate := wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
        if swipeDate <> '' then begin
            strRunDetail := strRunDetail + Chr(13) + Chr(10) + '����: ' + IntToStr(cardId) + Chr(9) + ' ״̬:' + Chr(9) + IntToStr(status) + '(' + wudp.NumToStrHex(status, 1) + ')' + Chr(9) + 'ʱ��:' + Chr(9) + swipeDate;
        end;
        strRunDetail := strRunDetail + Chr(13) + Chr(10);

        //�ŴŰ�ť״̬
        //Bitλ  7   6   5   4   3   2   1   0
        //˵��   �Ŵ�4   �Ŵ�3   �Ŵ�2   �Ŵ�1   ��ť4   ��ť3   ��ť2   ��ť1
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '�Ŵ�״̬  1���Ŵ� 2���Ŵ� 3���Ŵ� 4���Ŵ�';
        strRunDetail := strRunDetail + Chr(13) + Chr(10);
        strRunDetail := strRunDetail + '          ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 1) = 1 then
            strRunDetail := strRunDetail + '   ��   '
        else
            strRunDetail := strRunDetail + '   ��   ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 2) = 1 then
            strRunDetail := strRunDetail + '   ��   '
        else
            strRunDetail := strRunDetail + '   ��   ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 3) = 1 then
            strRunDetail := strRunDetail + '   ��   '
        else
            strRunDetail := strRunDetail + '   ��   ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 4) = 1 then
            strRunDetail := strRunDetail + '   ��   '
        else
            strRunDetail := strRunDetail + '   ��   ';

        strRunDetail := strRunDetail + Chr(13) + Chr(10);
        //��ť״̬
        //Bitλ  7   6   5   4   3   2   1   0
        //˵��   �Ŵ�4   �Ŵ�3   �Ŵ�2   �Ŵ�1   ��ť4   ��ť3   ��ť2   ��ť1
        strRunDetail := strRunDetail + '��ť״̬  1�Ű�ť 2�Ű�ť 3�Ű�ť 4�Ű�ť';
        strRunDetail := strRunDetail + Chr(13) + Chr(10);
        strRunDetail := strRunDetail + '          ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 1) = 1 then
            strRunDetail := strRunDetail + ' �ɿ�   '
        else
            strRunDetail := strRunDetail + ' ����   ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 2) = 1 then
            strRunDetail := strRunDetail + ' �ɿ�   '
        else
            strRunDetail := strRunDetail + ' ����   ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 3) = 1 then
            strRunDetail := strRunDetail + ' �ɿ�   '
        else
            strRunDetail := strRunDetail + ' ����   ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 4) = 1 then
            strRunDetail := strRunDetail + ' �ɿ�   '
        else
            strRunDetail := strRunDetail + ' ����   ';

        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '����״̬:' + Chr(9);
        errorNo := wudp.GetErrorNoFromRunInfo(strFrame);
        if errorNo = 0 then
            strRunDetail := strRunDetail + ' �޹���  '
        else begin
            strRunDetail := strRunDetail + ' �й���  ';
            if (errorNo and 1) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + 'ϵͳ����1';
            if (errorNo and 2) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + 'ϵͳ����2';
            if (errorNo and 4) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + 'ϵͳ����3[�豸ʱ���й���], ��У��ʱ�Ӵ���';
            if (errorNo and 8) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + 'ϵͳ����4';
        end;
        Text1.Text := Text1.Text + strRunDetail;
    end;

    //��ѯ��������IP����
    //��ȡ����������Ϣָ��
    strCmd := wudp.CreateBstrCommand(controllerSN, '0111'); //����ָ��֡ ��ȡ����������Ϣָ��
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        Exit;
    end
    else begin
        strRunDetail := '';

        //'MAC
        startLoc := 11;

        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'MAC:' + chr(9) + chr(9) + (copy(strFrame, startLoc, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 2, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 4, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 6, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 8, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 10, 2));

        strMac := copy(strFrame, startLoc, 12);

        //IP
        startLoc := 23;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'IP:' + chr(9) + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 6, 2))));

        //Subnet Mask
        startLoc := 31;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '��������:' + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 6, 2))));


        //Default Gateway
        startLoc := 39;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '����:' + chr(9) + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 6, 2))));

        //TCP Port
        startLoc := 47;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'PORT:' + chr(9) + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2)) + (copy(strFrame, startLoc, 2))));
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + strRunDetail + Chr(13) + Chr(10);
    end;

    if (Application.MessageBox('�Ƿ���������IP�� ', '����IP', MB_YESNO) = IDYES) then begin
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '��ʼIP��ַ����: ' + Chr(13) + Chr(10); // + 'IP 192.168.168.90/Mask 255.255.255.0/Gateway 192.168.168.254: Port 60000';

        application.ProcessMessages;

        //�µ�IP����: (MAC����) IP��ַ: 192.168.168.90; ����: 255.255.255.0; ����: 192.168.168.254; �˿�: 60000
        strHexNewIP := wudp.NumToStrHex(EditIP1.Text, 1) + wudp.NumToStrHex(EditIP2.Text, 1) + wudp.NumToStrHex(EditIP3.Text, 1) + wudp.NumToStrHex(EditIP4.Text, 1);
        strHexMask := wudp.NumToStrHex(EditMask1.Text, 1) + wudp.NumToStrHex(EditMask2.Text, 1) + wudp.NumToStrHex(EditMask3.Text, 1) + wudp.NumToStrHex(EditMask4.Text, 1);
        strHexGateway := wudp.NumToStrHex(EditGateway1.Text, 1) + wudp.NumToStrHex(EditGateway2.Text, 1) + wudp.NumToStrHex(EditGateway3.Text, 1) + wudp.NumToStrHex(EditGateway4.Text, 1);

        strCmd := wudp.CreateBstrCommand(controllerSN, 'F211' + strMac + strhexnewip + strhexmask + strhexgateway + '60EA'); // ����ָ��֡ ��ȡ����������Ϣָ��
        ShowMessage('aaaaa=' + strCmd);
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            Exit;
        end
        else begin
            Text1.Text := Text1.Text + Chr(13) + Chr(10) + 'IP��ַ�������...Ҫ�ȴ�3����, ���Ժ�';
            application.ProcessMessages;
            Sleep(DEVICE_INTERNAL); //����3����ʱ
            ret := Application.MessageBox('IP��ַ�������', '', MB_OK)
        end;
    end;



    //�����µ�IP��ַ����ͨ��
    ipAddr := EditIP1.Text + '.' + EditIP2.Text + '.' + EditIP3.Text + '.' + EditIP4.Text;
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '�����µ�IP��ַ����ͨ��' + ipAddr;

    //У׼������ʱ��
    strCmd := wudp.CreateBstrCommandOfAdjustClockByPCTime(controllerSN); //����ָ��֡
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        Exit
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + 'У׼������ʱ��ɹ�';


    //Զ�̿�1����
    strCmd := wudp.CreateBstrCommand(controllerSN, '9D10' + '01'); //����ָ��֡
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        Exit
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + 'Զ�̿��ųɹ�';


    //��ȡ��¼
    recIndex := 1;
    while true do begin
        strFuncData := '8D10' + wudp.NumToStrHex(recIndex, 4); // wudp.NumToStrHex(recIndex,4) ��ʾ��recIndex����¼
        strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡ 8D10Ϊ��ȡ��¼ָ��
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            //�û��ɿ�������
            Text1.Text := Text1.Text + Chr(13) + Chr(10) + '��ȡ��¼����';
            Exit;
        end
        else begin
            swipeDate := wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
            if swipeDate <> '' then begin
                strRunDetail := '����: ' + IntToStr(cardId) + Chr(9) + ' ״̬:' + Chr(9) + IntToStr(status) + '(' + wudp.NumToStrHex(status, 1) + ')' + Chr(9) + 'ʱ��:' + Chr(9) + swipeDate;
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + strRunDetail;
                recIndex := recIndex + 1; //��һ����¼
            end
            else begin
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + '��ȡ��¼���. �ܹ���ȡ��¼�� =' + IntToStr(recIndex - 1);
                break;
            end;
        end;
        application.ProcessMessages
    end;


    //ɾ������ȡ�ļ�¼
    if (recIndex > 1) then {//ֻ����ȡ�˼�¼�Ž���ɾ��} begin
        strFuncData := '8E10' + wudp.NumToStrHex(recIndex - 1, 4);
        strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            //�û��ɿ�������

            Text1.Text := Text1.Text + Chr(13) + Chr(10) + 'ɾ����¼ʧ��';
            Exit;
        end
        else
            Text1.Text := Text1.Text + Chr(13) + Chr(10) + 'ɾ����¼�ɹ�';
    end;

    //����Ȩ�޲���(1.�����Ȩ��)
    strCmd := wudp.CreateBstrCommand(controllerSN, '9310'); //����ָ��֡
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        //�û��ɿ�������
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '���Ȩ��ʧ��';
        Exit;
    end
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '���Ȩ�޳ɹ�';


    //����Ȩ�޲���(2.�����Ȩ��)
    //Ȩ�޸�ʽ: ���ţ�2��+���ţ�1��+�źţ�1��+����ʼ�����գ�2��+����ֹ�����գ�2��+ ����ʱ�������ţ�1��+���루3��+���ã�4����0��䣩
    //����Ȩ�ް�: �ȷ�1����(����С���ȷ�), �ٷ�2����(����С���ȷ�)
    //�˰�����Ȩ����Ϊ: ����Ч�ڴ�(2007-8-14 ��2020-12-31), ����Ĭ��ʱ��1(����ʱ����Ч), ȱʡ����(1234), ����ֵ��00���
    //���������� 07217564 [9C4448]��342681[B9A603]��25409969[F126FE]Ϊ�����ֱ����ͨ����������2���š�
    //ʵ��ʹ�ð����޸�

    //!!!!!!!ע��:  �˴�������ֱ�Ӱ���С�������и�ֵ��. ʵ��ʹ����Ҫ���㷨ʵ������
    cardno[0] := 6848134;
    cardno[1] := 7217564;
    cardno[2] := 25409969;
    privilegeIndex := 1;
    for doorIndex := 0 to 1 do
        for cardIndex := 0 to 2 do begin
            privilege := '';
            privilege := wudp.CardToStrHex(cardno[cardIndex]); //����
            privilege := privilege + wudp.NumToStrHex(doorIndex + 1, 1); //�ź�
            privilege := privilege + wudp.MSDateYmdToWCDateYmd('2007-8-14'); //��Ч��ʼ����
            privilege := privilege + wudp.MSDateYmdToWCDateYmd('2020-12-31'); //��Ч��ֹ����
            privilege := privilege + wudp.NumToStrHex(1, 1); //ʱ��������
            privilege := privilege + wudp.NumToStrHex(123456, 3); //�û�����
            privilege := privilege + wudp.NumToStrHex(0, 4); //����4�ֽ�(��0���)
            if (Length(privilege) <> (16 * 2)) then
                //���ɵ�Ȩ�޲�����Ҫ��, ���һ����һָ����д���ÿ�������Ƿ���ȷ
                Exit;
            strFuncData := '9B10' + wudp.NumToStrHex(privilegeIndex, 2) + privilege;
            strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡
            strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ

            if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
                //û���յ�����,
                //ʧ�ܴ������... (��ErrCode����Է�������)
                //�û��ɿ�������
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + '���Ȩ��ʧ��';
                Exit;
            end
            else
                privilegeIndex := privilegeIndex + 1;
        end;
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '���Ȩ���� := ' + IntToStr(privilegeIndex - 1);


    //���Ϳ���ʱ��
    //����Ҫ�趨��ʱ�� [ע��0,1ʱ��Ϊϵͳ�̶���,��������Ч��, �����趨��ʱ��һ���2��ʼ]
    //�˰����趨ʱ��2: ��2007-8-1��2007-12-31��
    // ����1��5������7:30-12:30, 13:30-17:30, 19:00-21:00ͨ��, ����ʱ�䲻����
    timeseg := '';
    timeseg := timeseg + wudp.NumToStrHex($1F, 1); //���ڿ���
    timeseg := timeseg + wudp.NumToStrHex(0, 1); // ��һ����ʱ��(0--��ʾ��)
    timeseg := timeseg + wudp.NumToStrHex(0, 2); // ����2�ֽ�(0���)
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('07:30:00'); // ��ʼʱ����1
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('12:30:00'); // ��ֹʱ����1
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('13:30:00'); // ��ʼʱ����2
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('17:30:00'); // ��ֹʱ����2
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('19:00:00'); // ��ʼʱ����3
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('21:00:00'); // ��ֹʱ����3
    timeseg := timeseg + wudp.MSDateYmdToWCDateYmd('2007-8-1'); // ��ʼ����
    timeseg := timeseg + wudp.MSDateYmdToWCDateYmd('2007-12-31'); // ��ֹ����
    timeseg := timeseg + wudp.NumToStrHex(0, 4); // ����4�ֽ�(0���)
    if (Length(timeseg) <> (24 * 2)) then
        //���ɵ�ʱ�β�����Ҫ��, ���һ����һָ����д���ÿ�������Ƿ���ȷ
        Exit;

    strFuncData := '9710' + wudp.NumToStrHex(2, 2) + timeseg;
    strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        //�û��ɿ�������
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '���ʱ��ʧ��';
        Exit;
    end
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '���ʱ�γɹ�';


    // ʵʱ���
    // ��ȡ����״̬��ʵ�ּ�صĹؼ�ָ� �ڽ��м��ʱ, �ȶ�ȡ���¼�¼����λ�ļ�¼. ��ȡ�����µļ�¼�� ͬʱ���Ի�ȡ��ˢ����¼����
    // ��ʱ�Ϳ����ö�ȡ��ˢ����¼����1��䵽Ҫ��ȡ�����¼�¼����λ�ϣ�ȥ��ȡ����״̬�� �Ա��ȡ��һ����¼��
    // �����ȡ�����µ�ˢ����¼�� �Ϳ��Խ�����λ��1�� ���򱣳�����λ���䡣 �����Ϳ���ʵ�����ݵ�ʵʱ��ء�
    // ����ͨ�Ų��ϵĴ�����ʱ�ɶԴ���ͨ�Ų�ȡ��ʱ400-500������Ϊ����������һ�Σ��ٽ��ղ������ݣ� ����Ϊ�豸��PC����Ĳ���ͨ�š�
    watchIndex := 0; //ȱʡ��0, ��ʾ����ȡ���һ����¼
    recCnt := 0; //��ؼ�¼����
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '��ʼʵʱ���......(��ˢ��3��)';
    Text1.SelStart := Length(Text1.Text); //��ʾ�¼��������
    application.ProcessMessages;
    while (recCnt < 3) do {//������ ����3����ֹͣ} begin
        strFuncData := '8110' + wudp.NumToStrHex(watchIndex, 3); //wudp.NumToStrHex(watchIndex,3) ��ʾ��watchIndex����¼, �����0��ȡ����һ����¼
        strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //����ָ��, ����ȡ������Ϣ
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            Exit
        else begin
            swipeDate := wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
            if swipeDate <> '' then {//�м�¼ʱ} begin
                strRunDetail := '����: ' + wudp.CardToStrHex(cardId) + Chr(9) + ' ״̬:' + Chr(9) + IntToStr(status) + '(' + wudp.NumToStrHex(status, 1) + ')' + Chr(9) + 'ʱ��:' + Chr(9) + swipeDate + ',strFrame=[' + strFrame + ']';
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + strRunDetail;
                Text1.SelStart := Length(Text1.Text); //��ʾ�¼��������
                if watchIndex = 0 then //����յ���һ����¼
                    watchIndex := wudp.GetCardRecordCountFromRunInfo(strFrame) + 1 //ָ��(�ܼ�¼��+1), Ҳ�����´�ˢ���Ĵ洢����λ
                else
                    watchIndex := watchIndex + 1; //ָ����һ����¼λ
                recCnt := recCnt + 1; //��¼����
            end;
        end;
        application.ProcessMessages;
    end;
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '��ֹͣʵʱ���';
    Text1.SelStart := Length(Text1.Text); //��ʾ�¼��������
end;

procedure TForm1.btnExitClick(Sender: TObject);
begin
    halt(1);
end;

procedure configDevice();
var
    time1: tdatetime;
    fileHandle: integer;
begin
    if (fileExists(INITDEVSID)) then begin
        DeleteFile(INITDEVSID);
    end;
    fileHandle := FileCreate(INITDEVSID);
    fileclose(fileHandle);

    time1 := Now();
    initDevices();
    Form1.Text1.lines.AddStrings(WorkingDeviceArray);

    Form1.Text1.lines.Add(format('��ʼ������������--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));
    DeleteFile(INITDEVSID);
    Form1.cbDevice.Items.Clear;
    Form1.cbDevice.Items.Add('-');
    if (WorkingDeviceArray.Count > 0) then begin
        Form1.buttonConfig(2);
        Form1.cbDevice.Items.AddStrings(WorkingDeviceArray);
    end
    else begin
        Form1.Text1.lines.Add('δ���ӵ��κ��豸�������������[��һ�豸����]��������һ����');
    end;
end;

procedure TForm1.btnConfigDevClick(Sender: TObject);
begin
    with TFromWaitThread.Create(configDevice, '�������ӿ����������Ժ�...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
end;



procedure TForm1.btnInitPrivilegeClick(Sender: TObject);
begin
    with TFromWaitThread.Create(initPrivilege, '���������·�Ȩ�ޣ����Ժ�...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
end;

procedure TForm1.btnMonitorDeviceClick(Sender: TObject);
begin
    text1.Lines.Add(monitorDevice(StrToInt64(EditSN.Text)));
end;

procedure TForm1.btnDownloadClick(Sender: TObject);
var
    devList, cardList, doorList: TStringList;
    ip, cardphyid: string;
    i, j, devSN, doorIndex: integer;
    time1: TDateTime;
    fileHandle: integer;
begin
    if (fileExists(DOWNPRIVSID)) then begin
        DeleteFile(DOWNPRIVSID);
    end;
    fileHandle := FileCreate(DOWNPRIVSID);
    FileClose(fileHandle);

    time1 := Now();
    syncData(2);
    cardList := TStringList.Create;
    //cardList.LoadFromFile(ExtractFilePath(paramstr(0)) + syncfilename);
    if (syncfilename <> '') then
        cardList.LoadFromFile(syncfilename);

    doorList := TStringList.Create;
    doorList.Delimiter := ',';
    doorList.DelimitedText := c10doorno;

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;

        for doorIndex := 0 to doorList.Count - 1 do begin
            for j := 0 to cardList.Count - 1 do begin
                cardphyid := copy(cardList[j], 3, (Pos(',1', cardList[j]) - 3));
                iTryAgain := 0;
                if (Pos(',1', cardList[j]) > 0) then begin
                    addOrModifyPrivilege(devSN, ip, cardphyid, StrToInt(doorList[doorIndex]));
                end
                else begin
                    deletePrivilege(devSN, ip, cardphyid, StrToInt(doorList[doorIndex]));
                end;
                sleep(downinternal);
            end;
        end;
    end;
    doorList.Free;
    cardList.Free;
    DeleteFile(DOWNPRIVSID);

    text1.Lines.Add('�����豸Ȩ�������·���ɣ��ȴ���һ�������·�');
    Text1.lines.Add(format('Ȩ�������·����--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));

end;

procedure TForm1.btnSyncTImeClick(Sender: TObject);
var
    i, devSN: integer;
    ip: string;
    devList: TStrings;
    time1: tdatetime;
begin
    time1 := Now();
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //getDeviceStatus(devSN);
        if (verifyDevClock(devSN, ip)) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',ʱ��У׼�ɹ�');
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',ʱ��У׼ʧ��');
        end;
    end;
    Text1.lines.Add(format('�豸ʱ��У׼���--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));

end;

procedure TForm1.btnGetPrivilegeClick(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //devPrivilegeCount := getPrivilegeCount(devSN, ip);
        if (getDeviceStatus(devSN)) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',Ȩ�޸���=' + devPrivilegeCount);
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',Ȩ�޶�ȡʧ��');
        end;
        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',��¼����=' + devRecordCount);
        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',�豸ʱ��=' + devClock);

    end;
    text1.Lines.Add('�����豸Ȩ�޶�ȡ���');
end;

procedure TForm1.btnDeletePrivilegeClick(Sender: TObject);
var
    i, devSN, doorNo, iPos: integer;
    ip: WideString;
    devList: TStrings;
    cardphyid: string;
    //    tempSQL: string;
begin
    if (edtStuempno.Text <> '') then begin
        verifyUser(1, edtStuempno.Text);
    end
    else if ((trim(edit2.Text) <> '') and (Length(edit2.Text) = 8)) then begin
        if (verifyUser(2, UpperCase(trim(edit2.Text)))) then begin
            if (cbDevice.Text = '-') or (cbDevice.Text = '') then begin
                for i := 0 to WorkingDeviceArray.Count - 1 do begin
                    devList := TStringList.Create;
                    devList.Delimiter := ',';
                    devList.DelimitedText := WorkingDeviceArray[i];
                    devSN := StrToInt64(devList[0]);
                    ip := devList[1];
                    devList.Free;

                    cardphyid := copy(Edit2.text, 3, 6);
                    doorNo := StrToInt(Edit3.Text);
                    iTryAgain := 0;
                    if (deletePrivilege(devSN, ip, cardphyid, doorNo)) then begin
                        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ��ɾ���ɹ�');
                    end
                    else begin
                        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ�޶�ȡʧ��');
                    end;
                end;
            end
            else begin
                iPos := Pos(',', cbDevice.Text);
                devSN := StrToInt64(copy(cbDevice.Text, 1, iPos - 1));
                ip := copy(cbDevice.Text, iPos + 1, length(cbDevice.Text) - iPos);
                cardphyid := copy(Edit2.text, 3, 6);
                doorNo := StrToInt(Edit3.Text);
                if (deletePrivilege(devSN, ip, cardphyid, doorNo)) then begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ��ɾ���ɹ�');
                end
                else begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ��ɾ��ʧ��');
                end;
            end;
        end
        else begin
            text1.Lines.Add('�����š�����ȷ��');
            text1.Lines.Add(format('δ�ҵ�����Ϣ�����顾����=%s����ѧ����=%s���Ƿ���ȷ��', [edit2.Text, trim(edtStuempno.Text)]));
        end;
    end
    else begin
        text1.Lines.Add('��ѧ���š�����ȷ��');
        text1.Lines.Add(format('δ�ҵ�����Ϣ�����顾����=%s����ѧ����=%s���Ƿ���ȷ��', [edit2.Text, trim(edtStuempno.Text)]));
    end;

    text1.Lines.Add('Ȩ��ɾ�����');
end;

procedure TForm1.btnCleanPrivilegeClick(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    if (Application.MessageBox('�Ƿ��������ͨ����Ȩ�������� ', '���Ȩ��', MB_YESNO) = IDYES) then begin
        for i := 0 to WorkingDeviceArray.Count - 1 do begin
            devList := TStringList.Create;
            devList.Delimiter := ',';
            devList.DelimitedText := WorkingDeviceArray[i];
            devSN := StrToInt64(devList[0]);
            ip := devList[1];
            devList.Free;

            if (cleanPrivilege(devSN, ip)) then begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',Ȩ����ճɹ�');
            end
            else begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',Ȩ�����ʧ��');
            end;
        end;

        text1.Lines.Add('Ȩ��������');
    end;

end;

procedure TForm1.btnAddPrivClick(Sender: TObject);
var
    i, devSN, doorNo, iPos: integer;
    ip: WideString;
    devList: TStrings;
    cardphyid: string;
    //    tempSQL: string;
begin
    if (edtStuempno.Text <> '') then begin
        verifyUser(1, edtStuempno.Text);
    end
    else if ((trim(edit2.Text) <> '') and (Length(edit2.Text) = 8)) then begin
        verifyUser(2, UpperCase(trim(edit2.Text)));
        if (cbDevice.Text = '-') or (cbDevice.Text = '') then begin
            for i := 0 to WorkingDeviceArray.Count - 1 do begin
                devList := TStringList.Create;
                devList.Delimiter := ',';
                devList.DelimitedText := WorkingDeviceArray[i];
                devSN := StrToInt64(devList[0]);
                ip := devList[1];
                devList.Free;

                cardphyid := copy(Edit2.text, 3, 6);
                doorNo := StrToInt(Edit3.Text);
                iTryAgain := 0;
                if (addOrModifyPrivilege(devSN, ip, cardphyid, doorNo)) then begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ����ӳɹ�');
                end
                else begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ�����ʧ��');
                end;
            end;
        end
        else begin
            iPos := Pos(',', cbDevice.Text);
            devSN := StrToInt64(copy(cbDevice.Text, 1, iPos - 1));
            ip := copy(cbDevice.Text, iPos + 1, length(cbDevice.Text) - iPos);
            cardphyid := copy(Edit2.text, 3, 6);
            doorNo := StrToInt(Edit3.Text);
            if (addOrModifyPrivilege(devSN, ip, cardphyid, doorNo)) then begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ����ӳɹ�');
            end
            else begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����=[' + cardphyid + '],Ȩ�����ʧ��');
            end;
        end;
    end
    else begin
        text1.Lines.Add('�����š���ѧ���š�����ȷ��');
        text1.Lines.Add(format('δ�ҵ�����Ϣ�����顾����=%s����ѧ����=%s���Ƿ���ȷ��', [edit2.Text, trim(edtStuempno.Text)]));
    end;

    text1.Lines.Add('Ȩ��������');

end;

procedure TForm1.btnManualRecordClick(Sender: TObject);
begin
    with TFromWaitThread.Create(syncGetData, '�����ֹ���ȡ���������Ժ�...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    getData(2);
    Text1.Lines.Add(format('�´���ȡ��¼��ʱ��Ϊ��%s����ȴ�...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnAutoGetClick(Sender: TObject);
begin
    timer1.Interval := c10interval * 60 * 1000;
    timer1.Enabled := true;
    btnAutoGet.Enabled := false;
    N2.Enabled := false;
    Text1.Lines.Add(format('�´���ȡ��¼��ʱ��Ϊ��%s����ȴ�...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnSyncDataClick(Sender: TObject);
begin
    syncData(1);
end;

procedure tform1.getData(dataType: integer);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
    time1: tdatetime;
    fileHandle: integer;
begin
    datafilename := FormatDateTime('yyyymmddHHmmss', Now());
    if (fileExists(GETDATASID)) then begin
        DeleteFile(GETDATASID);
    end;
    filehandle := FileCreate(GETDATASID);
    FileClose(fileHandle);

    time1 := Now();

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;

        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',����ȡ��¼��=[' + IntToStr(getRecordCount(devSN, ip)) + '],��ʼ��ȡ...');
        getRecord(devSN, ip);

        //text1.Lines.AddStrings(DeviceRecords);
        if (DeviceRecords.Count > 0) then begin
            DeviceRecords.SaveToFile(ExtractFilePath(paramstr(0)) + '..\data\'
                + IntToStr(devSN) + '-' + datafilename + '.txt');
        end;

        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',���׼�¼��=[' + IntToStr(DeviceRecords.Count) + '],��¼��ȡ���');
        DeviceRecords.Clear;
    end;
    if dataType = 1 then begin
        text1.Lines.Add('��¼�ֹ���ȡ���');
    end
    else if dataType = 2 then begin
        text1.Lines.Add('��¼�Զ���ȡ���');
    end;
    DeleteFile(GETDATASID);
    datafilename := '';

    Text1.lines.Add(format('ˢ����¼��ȡ--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));

end;

procedure tform1.syncData(syncType: integer);
var
    lastdealtime, newdealtime: string;
    yktServer: string;
    yktUser: string;
    yktPass: string;
    yktCardSQL: string;
    time1: TDatetime;
    syncdataList: TStringList;
    fileHandle: integer;
begin
    if (fileExists(SYNCDATASID)) then begin
        DeleteFile(SYNCDATASID);
    end;
    fileHandle := FileCreate(SYNCDATASID);
    FileClose(fileHandle);

    time1 := Now();
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);

    lastdealtime := iniConfig.readstring('yczn', 'lastdeal', '0');

    APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
    if APP_DEBUGMODE then begin
        yktServer := iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb');
        yktUser := iniConfig.readstring('ykt', 'user', 'ykt_cur');
        yktPass := iniConfig.readstring('ykt', 'pass', 'kingstar');
        iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(yktServer), CryptKey));
        iniConfig.WriteString('ykt', 'user', EncryptString(Trim(yktUser), CryptKey));
        iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(yktPass), CryptKey));
        iniConfig.WriteBool('yczn', 'debug', false);
    end
    else begin
        yktServer := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
        yktUser := trim(DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur'), CryptKey));
        yktPass := trim(DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar'), CryptKey));
    end;

    yktCardSQL := Format(iniConfig.readstring('ykt', 'cardsql', 'select * from ykt_cur.V_CUSTCARDINFO where cardupdtime>%s order by cardupdtime desc'), [lastdealtime]);

    if (syncType = 1) then begin
        syncfilename := ExtractFilePath(paramstr(0)) + CARDLISTFILE;
    end
    else if (syncType = 2) then begin
        syncfilename := ExtractFilePath(paramstr(0)) + FormatDateTime('yyyymmddHHmmss', Now()) + '.txt';
    end
    else begin
        syncfilename := ExtractFilePath(paramstr(0)) + CARDLISTFILE;
    end;

    syncdataList := TStringList.Create;

    OraSession1.Server := yktServer;
    OraSession1.Username := yktUser;
    OraSession1.Password := yktPass;

    if OraSession1.Connected = false then
        OraSession1.Connect;
    OraQuery1.close;
    OraQuery1.SQL.Clear;
    OraQuery1.SQL.Add('select max(cardupdtime) as cardupdtime  from ykt_cur.V_CUSTCARDINFO');
    OraQuery1.ExecSQL;
    OraQuery1.First;
    newdealtime := OraQuery1.FieldByName('cardupdtime').AsString;
    OraQuery1.close;


    OraQuery1.SQL.Clear;
    OraQuery1.SQL.Add(yktCardSQL);
    OraQuery1.ExecSQL;
    //ShowMessage(IntToStr(OraQuery1.RecordCount));
    while not OraQuery1.Eof do begin
        syncdataList.Add(OraQuery1.FieldByName('cardid').AsString + ',' + OraQuery1.FieldByName('cardstatus').AsString);
        //Text1.lines.Add('����=[' + OraQuery1.FieldByName('cardid').AsString + '],��ȡ���');
        OraQuery1.Next;
    end;
    OraQuery1.Close;

    if (syncdataList.Count > 0) then begin
        syncdataList.SaveToFile(syncfilename);
    end
    else begin
        syncfilename := '';
    end;
    syncdataList.Free;

    Text1.lines.Add('ykt���ݳ�ȡ���,���ͬ��ʱ�䣺' + newdealtime);
    iniConfig.WriteString('yczn', 'lastdeal', newdealtime);
    //iniConfig.Free;
    DeleteFile(SYNCDATASID);
    Text1.lines.Add(format('ykt���ݳ�ȡ--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));

end;

procedure tform1.insertDataToYKT(recordFilename: string);
var
    recFile, recInfo: TStringList;
    yktServer: string;
    yktUser: string;
    yktPass: string;
    tempSQL: string;
    i: integer;
    eventInfo: string;
begin
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
    APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
    if APP_DEBUGMODE then begin
        yktServer := iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb');
        yktUser := iniConfig.readstring('ykt', 'user', 'ykt_cur');
        yktPass := iniConfig.readstring('ykt', 'pass', 'kingstar');
        iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(yktServer), CryptKey));
        iniConfig.WriteString('ykt', 'user', EncryptString(Trim(yktUser), CryptKey));
        iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(yktPass), CryptKey));
        iniConfig.WriteBool('yczn', 'debug', false);
    end
    else begin
        yktServer := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
        yktUser := trim(DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur'), CryptKey));
        yktPass := trim(DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar'), CryptKey));
    end;

    //iniConfig.Free;

    recFile := TStringList.create;
    recFile.LoadFromFile(ExtractFilePath(paramstr(0)) + '..\data\' + recordFilename);

    OraSession1.Server := yktServer;
    OraSession1.Username := yktUser;
    OraSession1.Password := yktPass;
    if OraSession1.Connected = false then
        OraSession1.Connect;

    recInfo := TStringList.create;
    recInfo.Delimiter := ',';

    for i := 0 to recFile.Count - 1 do begin
        tempSQL := 'insert into ykt_cur.t_doordtl (TRANSDATE, TRANSTIME, DEVICEID,DEVPHYID, DEVSEQNO,'
            + ' COLDATE, COLTIME, CARDNO, CARDPHYID,SHOWCARDNO, STUEMPNO, CUSTID, CUSTNAME, TRANSMARK,SYSID) values'
            + ' (%s,%s,%s,''%s'',%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)';
        recInfo.DelimitedText := recFile[i];

        eventInfo := '-9999';
        if (recInfo[4] = '0') then begin
            eventInfo := '8800';
        end
        else if (recInfo[4] = '144') then begin
            eventInfo := '8801';
            //edit2.Text := '45' + recInfo[1];
            if (Pos('[' + recInfo[1] + ']', text1.text) <= 0) then begin
                if (verifyUser(2, recInfo[1])) then begin
                    btnDeletePrivilegeClick(btnDeletePrivilege);
                    btnAddPrivClick(btnAddPriv);
                end;
            end;
        end
        else begin
            eventInfo := recInfo[4];
        end;
        tempSQL := Format(tempSQL, [
            'to_char(to_date(''' + recInfo[2] + ''',''yyyy-mm-dd''),''yyyymmdd'')',
                'to_char(to_date(''' + recInfo[3] + ''',''hh24:mi:ss''),''hh24miss'')',
                'nvl((select deviceid from ykt_cur.t_device where devphyid=''' + recInfo[0] + ''' and status=''1''),0)',
                recInfo[0],
                'to_number(to_char(sysdate,''yyyymmddhh24miss'')||''' + IntToStr(i) + ''')',
                'to_char(sysdate,''yyyymmdd'')',
                'to_char(sysdate,''hh24miss'')',
                'nvl((select cardno from ykt_cur.t_card where cardphyid like ''%' + recInfo[1] + ''' and status=''1'' and rownum<2),0)',
                'nvl((select cardphyid from ykt_cur.t_card where cardphyid like ''%' + recInfo[1] + ''' and status=''1'' and rownum<2),0)',
                'nvl((select showcardno from ykt_cur.t_card where cardphyid like ''%' + recInfo[1] + ''' and status=''1'' and rownum<2),0)',
                'nvl((select b.stuempno from ykt_cur.t_card a, ykt_cur.t_customer b where a.custid=b.custid and a.cardphyid like ''%' + recInfo[1] + ''' and a.status=''1'' and rownum<2),0)',
                'nvl((select b.CUSTID from ykt_cur.t_card a, ykt_cur.t_customer b where a.custid=b.custid and a.cardphyid like ''%' + recInfo[1] + ''' and a.status=''1'' and rownum<2),0)',
                'nvl((select b.CUSTNAME from ykt_cur.t_card a, ykt_cur.t_customer b where a.custid=b.custid and a.cardphyid like ''%' + recInfo[1] + ''' and a.status=''1'' and rownum<2),0)',
                eventInfo,
                'nvl((select sysid from ykt_cur.t_device where devphyid=''' + recInfo[0] + ''' and status=''1''),0)'
                ]);
        Text1.Lines.Add(tempSQL);

        try
            OraQuery1.close;
            OraQuery1.SQL.Clear;
            OraQuery1.SQL.Add(tempSQL);
            OraQuery1.ExecSQL;
        except
            writeLog('Error:' + tempSQL);
        end;
    end;
    recInfo.Free;
    recFile.free;

    MoveFile(PAnsiChar(ExtractFilePath(paramstr(0)) + '..\data\' + recordFilename), PChar(ExtractFilePath(paramstr(0)) + '..\data\bak\' + recordFilename));
end;

procedure TForm1.btnAutoSyncClick(Sender: TObject);
begin
    timer3.Interval := c10interval * 60 * 1000;
    if APP_DEBUGMODE = true then
        timer3.Interval := 5000;
    timer3.Enabled := true;
    btnAutoSync.Enabled := false;
    N1.Enabled := false;
    TimerLabel8.Enabled := true;
    Label8.Caption := IntToStr(c10interval * 60);
    Text1.Lines.Add(format('�´�ͬ��������ʱ��Ϊ��%s����ȴ�...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnStopTaskClick(Sender: TObject);
begin
    timer1.enabled := false;
    timer2.enabled := false;
    timer3.enabled := false;
    btnAutoSync.Enabled := true;
    btnAutoGet.Enabled := true;
    btnAutoUpload.Enabled := true;
    N1.Enabled := true;
    N2.Enabled := true;
    N3.Enabled := true;
end;

procedure TForm1.uploadDataToYKT();
var
    FileAttrs, i: Integer;
    sr: TSearchRec;
    uploadList: TStringList;
    time1: TDatetime;
    fileHandle: integer;
begin
    if (fileExists(UPLOADDATASID)) then begin
        DeleteFile(UPLOADDATASID);
    end;
    fileHandle := FileCreate(UPLOADDATASID);
    FileClose(fileHandle);
    time1 := Now();

    uploadList := TStringList.Create;

    FileAttrs := 0;
    FileAttrs := FileAttrs + faAnyFile;
    if FindFirst(ExtractFilePath(paramstr(0)) + '..\data\*', FileAttrs, sr) = 0 then begin
        repeat
            if (sr.Attr and FileAttrs) = sr.Attr then begin
                if ((sr.Name = '.') or (sr.Name = '..') or ((Sr.Attr and faDirectory) <> 0)) then Continue;
                if (fileExists(GETDATASID)) then begin
                    if (Pos(datafilename, sr.Name) > 0) then begin
                        Continue;
                    end;
                end;

                uploadList.Add(sr.Name);
            end;
        until FindNext(sr) <> 0;
        FindClose(sr);
    end;
    //Text1.Lines.AddStrings(uploadList);

    for i := 0 to uploadList.Count - 1 do begin
        insertDataToYKT(uploadList[i]);
    end;

    uploadList.Free;
    DeleteFile(UPLOADDATASID);
    Text1.lines.Add(format('ykt�����ϴ�����--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));
end;

procedure TForm1.btnAutoUploadClick(Sender: TObject);
begin
    timer2.Interval := c10interval * 60 * 1000;
    timer2.Enabled := true;
    btnAutoUpload.Enabled := false;
    N3.Enabled := false;
    Text1.Lines.Add(format('�´��Զ��ϴ���ʱ��Ϊ��%s����ȴ�...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
    uploadDataToYKT();
    Text1.Lines.Add(format('�´��Զ��ϴ���ʱ��Ϊ��%s����ȴ�...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnUploadDataClick(Sender: TObject);
begin
    uploadDataToYKT();
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
    btnDownloadClick(btnDownload);
    //syncData(2);
    Text1.Lines.Add(format('�´��·�Ȩ�޵�ʱ��Ϊ��%s����ȴ�...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
    btnSyncTImeClick(btnSyncTIme);
    Text1.Lines.Add(format('�´�У׼�豸ʱ�ӵ�ʱ��Ϊ��%s����ȴ�...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), 60))]));
end;

procedure TForm1.TimerLabel8Timer(Sender: TObject);
begin
    if (StrToInt(Label8.Caption) > 0) then
        Label8.Caption := IntToStr(StrToInt(Label8.Caption) - 1);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    temp: string;
begin
    buttonConfig(1);
    Label8.Caption := '';

    try
        if iniConfig = nil then
            iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
        APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
        if APP_DEBUGMODE then begin
            iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb')), CryptKey));
            iniConfig.WriteString('ykt', 'user', EncryptString(Trim(iniConfig.readstring('ykt', 'user', 'ykt_cur')), CryptKey));
            iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(iniConfig.readstring('ykt', 'pass', 'kingstar')), CryptKey));
            iniConfig.WriteBool('yczn', 'debug', false);
        end
        else begin
            temp := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
            temp := DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur1'), CryptKey);
            temp := DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar1'), CryptKey);
        end;
        iniConfig.Free;
        iniConfig := nil;
    except
        ShowMessage('���ݿ����������⣬����ϵ����Ա��');
    end;
end;

procedure TForm1.buttonConfig(opType: integer);
var
    i: integer;
begin
    case opType of
        1: begin
                for i := 0 to form1.ControlCount - 1 do begin
                    if (form1.Controls[i] is TButton) and (form1.Controls[i].Name <> 'btnConfigDev')
                        and (form1.Controls[i].Name <> 'btnConfigOne')
                        and (form1.Controls[i].Name <> 'btnConnectDevice')
                        and (form1.Controls[i].Name <> 'btnExit') then begin
                        form1.Controls[i].Enabled := false;
                    end;
                end;
            end;
        2: begin
                for i := 0 to form1.ControlCount - 1 do begin
                    if (form1.Controls[i] is TButton) then begin
                        form1.Controls[i].Enabled := true;
                    end;
                end;
                btnConfigDev.Enabled := false;
            end;

        3: Caption := 'Out of range';
    end;
end;


procedure TForm1.BitBtn1Click(Sender: TObject);
begin
    IdUDPClient1.Broadcast('7E39C70111000000000000000000000000000000000000000000000000000012010D', 60000);
    Text1.Lines.Add(IdUDPClient1.ReceiveString(-1));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    i: integer;
    tmp: string;
begin
    tmp := 'aaa1dd,bbbbc';
    i := Pos(',', tmp);
    text1.Lines.Add(tmp + '---------' + copy(tmp, 1, i - 1));
    text1.Lines.Add(tmp + '---------' + copy(tmp, i + 1, length(tmp) - i));
    text1.Lines.Add('123456[aaa]');
    text1.Lines.Add(tmp + '---------' + copy(tmp, i + 1, length(tmp) - i));
    text1.Lines.Add(tmp + '---------' + copy(tmp, i + 1, length(tmp) - i));
    if (Pos('[aaa1]', text1.text) > 0) then begin
        ShowMessage('yes.');
    end else begin
        ShowMessage('no.');

    end;

end;

procedure TForm1.N5Click(Sender: TObject);
begin
    ShellExecute(Handle,
        nil,
        'Explorer.exe',
        PChar(Format('/e,/select,%s', [ExtractFilePath(Application.ExeName)])),
        nil,
        SW_NORMAL);
end;

procedure TForm1.btnAlwaysOpenClick(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    //devAlwaysOpen
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //doorNo := StrToInt(Edit3.Text);
        if (devAlwaysOpen(devSN, ip, 1, StrToInt(edtDelay.Text))) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],always open�ɹ�');
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],always openʧ��');
        end;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    //devAlwaysOpen
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //doorNo := StrToInt(Edit3.Text);
        if (devAlwaysOpen(devSN, ip, 3, StrToInt(edtDelay.Text))) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],readcard open�ɹ�');
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],readcard openʧ��');
        end;
    end;

end;

procedure TForm1.btnConnectDeviceClick(Sender: TObject);
begin
    with TFromWaitThread.Create(connectDevice, '�������ӿ����������Ժ�...') do begin
        FreeOnTerminate := True;
        Resume;
    end;

end;

procedure connectDevice();
var
    time1: tdatetime;
    fileHandle: integer;
begin
    if (fileExists(INITDEVSID)) then begin
        DeleteFile(INITDEVSID);
    end;
    fileHandle := FileCreate(INITDEVSID);
    fileclose(fileHandle);

    time1 := Now();
    connectDevices();
    Form1.Text1.lines.AddStrings(WorkingDeviceArray);

    Form1.Text1.lines.Add(format('��ʼ������������--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));
    DeleteFile(INITDEVSID);
    Form1.cbDevice.Items.Clear;
    Form1.cbDevice.Items.Add('-');
    if (WorkingDeviceArray.Count > 0) then begin
        Form1.buttonConfig(2);
        Form1.cbDevice.Items.AddStrings(WorkingDeviceArray);
    end
    else begin
        Form1.Text1.lines.Add('δ���ӵ��κ��豸�������������[��һ�豸����]��������һ����');
    end;
end;


procedure initPrivilege();
var
    //devList: TStringList;
    cardList, downList: TStringList;
    ip: string;
    i, devSN: integer;
    time1: tdatetime;
    iPos: integer;
begin
    time1 := Now();
    cardList := TStringList.Create;
    cardList.LoadFromFile(ExtractFilePath(paramstr(0)) + CARDLISTFILE);

    downList := TStringList.Create;
    for i := 0 to cardList.Count - 1 do begin
        if (Pos(',1', cardList[i]) > 0) then begin
            downList.Add(cardHexToNo(copy(cardList[i], 3, (Pos(',1', cardList[i]) - 3))));
        end;
    end;
    //��С�������򿨺�
    downList.CustomSort(NumBerSort);

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        iPos := Pos(',', WorkingDeviceArray[i]);
        devSN := StrToInt64(copy(WorkingDeviceArray[i], 1, iPos - 1));
        ip := copy(WorkingDeviceArray[i], iPos + 1, length(WorkingDeviceArray[i]) - iPos);
        //downloadAllCardByOne(devSN, ip, 1, downList);
        downloadAllCard(devSN, ip, 1, downList);
    end;

    {
    for i := 0 to downList.Count - 1 do begin
        for j := 0 to WorkingDeviceArray.Count - 1 do begin
            devList := TStringList.Create;
            devList.Delimiter := ',';
            devList.DelimitedText := WorkingDeviceArray[j];
            devSN := StrToInt64(devList[0]);
            ip := devList[1];
            devList.Free;
            //downloadAllCardByOneCard(devSN, ip, 1, downList[i]);
            deletePrivilege(devSN,ip,cardnoToHex(StrToInt64(downList[i])),1);

            if (addOrModifyPrivilege(devSN, ip, downList[i], 1) = true) then begin
                Text1.lines.Add('������[' + IntToStr(devSN) + '],����=[' + cardNoToHex(StrToInt64(downList[j])) + ']���Ȩ�޳ɹ�');
                //Sleep(downinternal);
                if (form1.Text1.Lines.Count = 200) then begin
                    form1.Text1.Lines.Clear;
                end;
            end
            else begin
                Text1.lines.Add('������[' + IntToStr(devSN) + '],����=[' + cardNoToHex(StrToInt(downList[j])) + ']���Ȩ��ʧ��');
                writelog('������[' + IntToStr(devSN) + '],����=[' + cardNoToHex(StrToInt(downList[j])) + ']���Ȩ��ʧ��');
                writeCardList('45' + cardNoToHex(StrToInt(downList[j])) + ',1');
            end;
        end;
    end;
    }

    downList.Free;
    cardList.Free;

    Form1.Text1.lines.Add(format('�����豸Ȩ�޳�ʼ�����--�ķ�ʱ�䣺%d ��', [SecondsBetween(time1, now)]));
end;

{
iType: ���鷽����1��ʾ��ѧ���ţ�2��ʾ�������ŵĺ�6λ���8λ
sParam ������ֵ
}

function verifyUser(iType: integer; sParam: string): boolean;
var
    yktServer, yktUser, yktPass: string;
    tempSQL: string;
begin
    result := false;
    //
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
    APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
    if APP_DEBUGMODE then begin
        yktServer := iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb');
        yktUser := iniConfig.readstring('ykt', 'user', 'ykt_cur');
        yktPass := iniConfig.readstring('ykt', 'pass', 'kingstar');
        iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(yktServer), CryptKey));
        iniConfig.WriteString('ykt', 'user', EncryptString(Trim(yktUser), CryptKey));
        iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(yktPass), CryptKey));
        iniConfig.WriteBool('yczn', 'debug', false);
    end
    else begin
        yktServer := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
        yktUser := trim(DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur'), CryptKey));
        yktPass := trim(DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar'), CryptKey));
    end;

    //iniConfig.Free;

    Form1.OraSession1.Server := yktServer;
    Form1.OraSession1.Username := yktUser;
    Form1.OraSession1.Password := yktPass;
    if Form1.OraSession1.Connected = false then
        Form1.OraSession1.Connect;

    try
        Form1.OraQuery1.close;
        Form1.OraQuery1.SQL.Clear;
        if (iType = 1) then begin
            tempSQL := 'select cardphyid from ykt_cur.v_custcardinfo where cardstatus=1 and stuempno='''
                + trim(sParam) + '''  ';
        end
        else if (iType = 2) then begin
            tempSQL := 'select cardphyid from ykt_cur.v_custcardinfo where cardstatus=1 and cardphyid like ''%'
                + UpperCase(trim(sParam)) + '''  ';
        end
        else begin
            tempSQL := 'select cardphyid from ykt_cur.v_custcardinfo where cardstatus=1 and stuempno='''
                + trim(sParam) + '''  ';
        end;

        Form1.OraQuery1.SQL.Add(tempSQL);
        Form1.OraQuery1.ExecSQL;
        if (Form1.OraQuery1.RecordCount > 0) then begin
            Form1.OraQuery1.First;
            Form1.edit2.Text := Form1.OraQuery1.FieldByName('cardphyid').AsString;
            result := true;
        end
        else begin
            Form1.text1.Lines.Add('ѧ��[' + trim(sParam) + ']' + '��У԰�������ڻ��ѹ�ʧ��');
            Form1.edit2.Text := '';
        end;
        Form1.OraQuery1.Close;
    except
        writeLog('Error:' + tempSQL);
        Form1.text1.Lines.Add('���ݿ��ѯʧ�ܣ�����ϵϵͳ����Ա��');
        Form1.edit2.Text := '';
    end;

end;

procedure syncGetData;
begin
    form1.getData(1);
end;

end.

