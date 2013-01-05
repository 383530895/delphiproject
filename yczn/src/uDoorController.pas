unit uDoorController;

interface

uses Dialogs, Variants, SysUtils, OleServer, COMOBJ, ActiveX,
    Windows, Messages, Classes, Graphics, Controls, Forms,
    StdCtrls, DateUtils,
    IniFiles;
type
    DeviceArray = array of array of string;

const
    CryptKey = 'YKT54321'; //����������Կ
    Tag_Error = '[ERROR]';
    CONFIGFILE = 'device.ini';
    CARDLISTFILE = 'cardlist.txt';
    C10PORT = 60000;
    SYNCDATASID = 'syncdata.sid';
    GETDATASID = 'getdata.sid';
    DOWNPRIVSID = 'downpriv.sid';
    INITDEVSID = 'initdev.sid';
    UPLOADDATASID = 'uploaddata.sid';
    DEVICE_INTERNAL = 3000;
    RETRYTIMES = 5;
var
    v_wudp: Variant; //WComm_Operate����
    strFuncData: WideString; //Ҫ���͵Ĺ��ܼ�����
    strCmd: WideString; //Ҫ���͵�ָ��֡
    strFrame: WideString; //���ص�����
    strRunDetail: WideString; //������Ϣ
    swipeDate: WideString; //����ʱ��
    errorNo: Integer; //���Ϻ�
    devIpAddr: WideString; // �豸ip��ַ
    devIpAddrHex: WideString; // �豸ip��ַ16����
    devMacAddr: WideString; // �豸MAC��ַ
    devClock: WideString; //�豸��ǰʱ��
    devRecordCount: WideString; //�豸��ǰ��¼��
    devPrivilegeCount: WideString; // �豸��ǰȨ�޸���
    iniConfig: TInifile;
    IpRange: string;
    WorkingDeviceArray: TStringList;
    c10sn: string;
    c10ip: string;
    c10mask: string;
    c10gateway: string;
    c10interval: integer;
    c10doorno: string;
    datapackage: integer;
    DeviceRecords: TStringList;
    downinternal: integer;
    iTryAgain: integer;
    APP_DEBUGMODE : boolean;

procedure getWUDP();
function connectDev(devSN: WideString): WideString;
function connectDevByIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
procedure connectDevices();
function getIPbySN(devSN: WideString): WideString;
procedure getRecord(devSN: integer; devIP: WideString);
function deleteRecord(devSN: WideString; recno: Integer): boolean;
procedure initDevices();
function setDeviceIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
procedure writeLog(content: string);
procedure writeCardList(content: string);
procedure makeDir(dirString: string);
function getDeviceStatus(devSN: Integer): boolean;
function monitorDevice(controllerSN: Integer): string;
procedure downloadAllCard(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
procedure downloadAllCardByOne(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
function cardHexToNo(cardphyid: string): string;
function cardNoToHex(cardno: integer): string;
function cardYktToDev(cardphyid: string): string;
function NumberSort(List: TStringList; Index1, Index2: Integer): Integer;
function verifyDevClock(devSN: integer; devIP: WideString): boolean;
function getPrivilegeCount(devSN: Integer; devIP: WideString): Integer;
function getRecordCount(devSN: integer; devIP: WideString): integer;
function deletePrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
function cleanPrivilege(devSN: integer; devIP: WideString): boolean;
function addPrivilegeToLast(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
function addOrModifyPrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
function devAlwaysOpen(devSN: integer; devIP: WideString; devMode, devDelay: integer): boolean;


implementation

uses unit1;


function cleanPrivilege(devSN: integer; devIP: WideString): boolean;
begin
    strFuncData := '9310';
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + ',���Ȩ��ʧ��,ret=' + strFrame);
        result := false;
        exit;
    end;
    result := true;
end;

function addOrModifyPrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
begin
    strFuncData := '0711' + v_wudp.NumToStrHex(0, 2) //Ȩ��λ��
    + cardYktToDev(cardphyid) //����
    + v_wudp.NumToStrHex(doorNo, 1) //�ź�
    + v_wudp.MSDateYmdToWCDateYmd('2007-8-14') //��Ч��ʼ����
    + v_wudp.MSDateYmdToWCDateYmd('2020-12-31') //��Ч��ֹ����
    + v_wudp.NumToStrHex(1, 1) //ʱ��������
    + v_wudp.NumToStrHex(123456, 3) //�û�����
    + v_wudp.NumToStrHex(0, 4) //����4�ֽ�(��0���)
    ;

    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + ',����=[' + cardphyid + '],���Ȩ��ʧ��,ret=' + strFrame);
        iTryAgain := iTryAgain + 1;
        if (iTryAgain > RETRYTIMES) then begin
            result := false;
            exit;
        end
        else begin
            addOrModifyPrivilege(devSN, devIP, cardphyid, doorNo);
        end;
    end;
    result := true;
end;

function addPrivilegeToLast(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
begin
    strFuncData := '9B10' + v_wudp.NumToStrHex(getPrivilegeCount(devSN, devIP) + 1, 2) //Ȩ��λ��
    + cardYktToDev(cardphyid) //����
    + v_wudp.NumToStrHex(doorNo, 1) //�ź�
    + v_wudp.MSDateYmdToWCDateYmd('2007-8-14') //��Ч��ʼ����
    + v_wudp.MSDateYmdToWCDateYmd('2020-12-31') //��Ч��ֹ����
    + v_wudp.NumToStrHex(1, 1) //ʱ��������
    + v_wudp.NumToStrHex(123456, 3) //�û�����
    + v_wudp.NumToStrHex(0, 4) //����4�ֽ�(��0���)
    ;

    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + ',����=[' + cardphyid + '],���Ȩ��ʧ��,ret=' + strFrame);
        result := false;
        exit;
    end;

    result := true;

end;



//ɾ��һ����Ȩ��

function deletePrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
begin
    strFuncData := '0811' + v_wudp.NumToStrHex(0, 2) //��2���ֽ�
    + cardYktToDev(cardphyid)
        + v_wudp.NumToStrHex(doorno, 1)
        + v_wudp.NumToStrHex(0, 2) //��ʼ������  2�ֽ�
    + v_wudp.NumToStrHex(0, 2) //��ֹ������  2�ֽ�
    + v_wudp.NumToStrHex(1, 1) //ʱ��  1�ֽ�
    + v_wudp.NumToStrHex(0, 3) //����  3�ֽ�
    + v_wudp.NumToStrHex(0, 4) //����  4�ֽ�
    ;
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    writelog('devSN=' + IntToStr(devSN) + ',����=[' + cardphyid + '],ret=' + strFrame);
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('devSN=' + IntToStr(devSN) + ',����=[' + cardphyid + '],ɾ��Ȩ��ʧ��');
        iTryAgain := iTryAgain + 1;
        if (iTryAgain > RETRYTIMES) then begin
            result := false;
            exit;
        end
        else begin
            deletePrivilege(devSN, devIP, cardphyid, doorNo);
        end;

    end;
    result := true;
end;

function verifyDevClock(devSN: integer; devIP: WideString): boolean;
begin
    //У׼������ʱ��
    strCmd := v_wudp.CreateBstrCommandOfAdjustClockByPCTime(devSN); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog(IntToStr(devSN) + ',У׼ʱ��ʧ��');
        result := false;
        exit;
    end;
    result := true;
end;

function getPrivilegeCount(devSN: Integer; devIP: WideString): Integer;
var
    iCount: integer;
begin
    //getWUDP();
    //��ȡ����״̬��Ϣ
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) ��ʾ��0����¼, Ҳ�����¼�¼
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        iCount := -1;
        writelog(IntToStr(devSN) + ',��ȡȨ����ʧ��');
    end
    else begin
        iCount := v_wudp.GetPrivilegeNumFromRunInfo(strFrame);
    end;
    result := iCount;
end;


procedure writeLog(content: string);
var
    logFilename: string;
    F: Textfile;
begin
    makeDir(ExtractFilePath(paramstr(0)) + '..\log\');
    logFilename := ExtractFilePath(paramstr(0)) + '..\log\'
        + FormatDateTime('yyyymmdd', Now()) + '.txt';
    if fileExists(logFilename) then begin
        AssignFile(F, logFilename);
        Append(F);
    end
    else begin
        AssignFile(F, logFilename);
        ReWrite(F);
    end;
    Writeln(F, content);
    Flush(F);
    Closefile(F);

end;


procedure writeCardList(content: string);
var
    logFilename: string;
    F: Textfile;
begin
    makeDir(ExtractFilePath(paramstr(0)) + '..\log\');
    logFilename := ExtractFilePath(paramstr(0)) + '..\log\'
        + FormatDateTime('yyyymmdd', Now()) + '.err';
    if fileExists(logFilename) then begin
        AssignFile(F, logFilename);
        Append(F);
    end
    else begin
        AssignFile(F, logFilename);
        ReWrite(F);
    end;
    Writeln(F, content);
    Flush(F);
    Closefile(F);

end;

procedure makeDir(dirString: string);
begin
    if not DirectoryExists(dirString) then begin
        if not CreateDir(dirString) then
            raise Exception.Create('Cannot create ' + dirString);
    end;
end;

procedure getWUDP();
begin
    //��������
    if VarIsEmpty(v_wudp) then begin
        v_wudp := CreateOleObject('WComm_UDP.WComm_Operate');
    end;
end;

function connectDev(devSN: WideString): WideString;
var
    controllerSN: Integer; //���������к�
    startLocation: Integer; //��ʼƫ��λ��
begin
    getWUDP();
    strRunDetail := '';
    controllerSN := StrToInt64(devSN);

    //��ȡ����״̬��Ϣ
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) ��ʾ��0����¼, Ҳ�����¼�¼
    strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        strRunDetail := '�豸SN[' + devSN + ']��ȡ������Ϣʧ��';
    end
    else begin
        //��������Ϣ����ϸ����
        //�������ĵ�ǰʱ��
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '�豸���к�S/N: ' + Chr(9) + IntToStr(v_wudp.GetSNFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '�豸ʱ��:      ' + Chr(9) + v_wudp.GetClockTimeFromRunInfo(strFrame);
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'ˢ����¼��:    ' + Chr(9) + IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'Ȩ����:        ' + Chr(9) + IntToStr(v_wudp.GetPrivilegeNumFromRunInfo(strFrame));
        //strRunDetail := strRunDetail + Chr(13) + Chr(10) + Chr(13) + Chr(10) + '�����һ��ˢ����¼: ' + Chr(9);
        //swipeDate := v_wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);

        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '����״̬:' + Chr(9);
        errorNo := v_wudp.GetErrorNoFromRunInfo(strFrame);
        if errorNo <> 0 then begin
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
    end;
    //��ѯ��������IP����
    //��ȡ����������Ϣָ��
    strCmd := v_wudp.CreateBstrCommand(controllerSN, '0111'); //����ָ��֡ ��ȡ����������Ϣָ��
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        strRunDetail := Tag_Error + '��ȡ������[' + devSN + ']��Ϣʧ��';
    end
    else begin
        //IP
        startLocation := 23;
        strRunDetail := strRunDetail + IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;
    result := strRunDetail;
end;

function connectDevByIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
var
    ip: TStrings;
    sConfigIP, strHexNewIP: WideString; //New IP (ʮ������) ,�豸��MAC��ַ
    controllerSN: Integer; //���������к�
    startLocation: Integer;
begin
    getWUDP();
    controllerSN := StrToInt64(devSN);
    //�任ip
    ip := TStringList.Create;
    ip.Delimiter := '.';
    ip.DelimitedText := devIP;

    sConfigIP := ip[0] + ip[1] + ip[2] + ip[3];
    strHexNewIP := v_wudp.NumToStrHex(ip[0], 1)
        + v_wudp.NumToStrHex(ip[1], 1)
        + v_wudp.NumToStrHex(ip[2], 1)
        + v_wudp.NumToStrHex(ip[3], 1);

    ip.Free;

    devIpAddrHex := '';
    devIpAddr := '';
    //��ȡ����״̬��Ϣ
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) ��ʾ��0����¼, Ҳ�����¼�¼
    strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡

    strFrame := v_wudp.udp_comm(strCmd, devIpAddrHex, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('[' + devSN + ']��ȡ������Ϣʧ��,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        devClock := v_wudp.GetClockTimeFromRunInfo(strFrame);
        devRecordCount := IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
    end;
    //��ѯ��������IP����
    //��ȡ����������Ϣָ��
    strCmd := v_wudp.CreateBstrCommand(controllerSN, '0111'); //����ָ��֡ ��ȡ����������Ϣָ��
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('[' + devSN + ']��ȡ����������Ϣʧ��,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        //'MAC
        startLocation := 11;
        devMacAddr := copy(strFrame, startLocation, 12);
        //IP
        startLocation := 23;
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;

    //����IP��ַ
    application.ProcessMessages;

    result := true;
end;

function getIPbySN(devSN: WideString): WideString;
begin
    getWUDP();
    if getDeviceStatus(StrToInt64(devSN)) then begin
        result := devIpAddr;
    end;
end;

procedure getRecord(devSN: integer; devIP: WideString);
var
    recIndex: Integer;
    recCount: Integer;
    //    cardphyid: string;
    cardno: integer;
    recStatus: integer;
begin
    getWUDP();
    recCount := getRecordCount(devSN, devIP);

    DeviceRecords.Clear;

    if recCount > datapackage then recCount := datapackage;

    for recIndex := 1 to recCount do begin
        strFuncData := '8D10' + v_wudp.NumToStrHex(recIndex, 4); // wudp.NumToStrHex(recIndex,4) ��ʾ��recIndex����¼
        strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡ 8D10Ϊ��ȡ��¼ָ��
        strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            //�û��ɿ�������
            writelog(IntToStr(devSN) + ',' + devIP + ',��ȡ��¼����');
            Exit;
        end
        else begin
            swipeDate := v_wudp.GetSwipeDateFromRunInfo(strFrame, cardno, recStatus);
            if swipeDate <> '' then begin
                DeviceRecords.Add(IntToStr(devSN) + ',' + cardNoToHex(cardno) + ',' + swipeDate + ',' + IntToStr(recStatus));
            end;
        end;
        application.ProcessMessages;
    end;

    //ɾ������ȡ�ļ�¼ ,ֻ����ȡ�˼�¼�Ž���ɾ��
    if (recCount > 0) then begin
        strFuncData := '8E10' + v_wudp.NumToStrHex(recCount, 4);
        strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
        strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            //�û��ɿ�������
            writelog(IntToStr(devSN) + ',' + devIP + ',ɾ����¼ʧ��');
        end;
    end;
end;


function deleteRecord(devSN: WideString; recno: Integer): boolean;
begin
    getWUDP();
    //ɾ������ȡ�ļ�¼ ,ֻ����ȡ�˼�¼�Ž���ɾ��
    strFuncData := '8E10' + v_wudp.NumToStrHex(recno, 4);
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        //�û��ɿ�������
        result := false;
    end
    else begin
        result := true;
    end;
end;

procedure initDevices();
var
    //filename: string;
    //devicesString: string;
    deviceSnList, deviceIpList, tmpList: TStrings;
    //arrayDevice: DeviceArray;
    i: Integer;
    strHexMask: WideString; //����(ʮ������)
    strHexGateway: WideString; //����(ʮ������)
    //    strMac: WideString;
begin
    getWUDP();
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);


    c10sn := iniConfig.readstring('yczn', 'c10sn', '');
    c10ip := iniConfig.readstring('yczn', 'c10ip', '');
    c10mask := iniConfig.readstring('yczn', 'c10mask', '255.255.255.0');
    c10gateway := iniConfig.readstring('yczn', 'c10gateway', '');
    c10interval := iniConfig.ReadInteger('yczn', 'c10interval', 5);
    c10doorno := iniConfig.readstring('yczn', 'c10doorno', '1');
    datapackage := iniConfig.ReadInteger('yczn', 'datapackage', 500);
    downinternal := iniConfig.ReadInteger('yczn', 'downinternal', 300);


    //IpRange := iniConfig.readstring('yczn', 'iprange', '192.168.168.');
    //iniConfig.Free;

    //�任mask
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10mask;
    strHexMask := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);
    tmpList.Free;
    //�任gateway
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10gateway;

    strHexGateway := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);

    tmpList.Free;


    deviceSnList := TStringList.Create;
    deviceSnList.Delimiter := ',';
    deviceSnList.DelimitedText := c10sn;

    deviceIpList := TStringList.Create;
    deviceIpList.Delimiter := ',';
    deviceIpList.DelimitedText := c10ip;

    if (WorkingDeviceArray = nil) then
        WorkingDeviceArray := TStringList.Create;


    for i := 0 to deviceSnList.Count - 1 do begin
        writeLog(deviceSnList[i] + ',' + deviceIpList[i]);
        if (setDeviceIP(deviceSnList[i], deviceIpList[i], strHexMask, strHexGateway)) then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;
        if APP_DEBUGMODE then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;

    end;

    deviceSnList.Free;
    deviceIpList.Free;

    if DeviceRecords = nil then
        DeviceRecords := TStringList.Create;

    makeDir(ExtractFilePath(paramstr(0)) + '..\data');
    makeDir(ExtractFilePath(paramstr(0)) + '..\data\bak');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown\bak');


end;

procedure connectDevices();
var
    //filename: string;
    deviceSnList, deviceIpList, tmpList: TStrings;
    i: Integer;
    strHexMask: WideString; //����(ʮ������)
    strHexGateway: WideString; //����(ʮ������)
    //    strMac: WideString;
begin
    getWUDP();
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
    c10sn := iniConfig.readstring('yczn', 'c10sn', '');
    c10ip := iniConfig.readstring('yczn', 'c10ip', '');
    c10mask := iniConfig.readstring('yczn', 'c10mask', '255.255.255.0');
    c10gateway := iniConfig.readstring('yczn', 'c10gateway', '');
    c10interval := iniConfig.ReadInteger('yczn', 'c10interval', 5);
    c10doorno := iniConfig.readstring('yczn', 'c10doorno', '1');
    datapackage := iniConfig.ReadInteger('yczn', 'datapackage', 500);
    downinternal := iniConfig.ReadInteger('yczn', 'downinternal', 300);

    //�任mask
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10mask;
    strHexMask := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);
    tmpList.Free;
    //�任gateway
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10gateway;

    strHexGateway := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);

    tmpList.Free;


    deviceSnList := TStringList.Create;
    deviceSnList.Delimiter := ',';
    deviceSnList.DelimitedText := c10sn;

    deviceIpList := TStringList.Create;
    deviceIpList.Delimiter := ',';
    deviceIpList.DelimitedText := c10ip;

    if (WorkingDeviceArray = nil) then
        WorkingDeviceArray := TStringList.Create;


    for i := 0 to deviceSnList.Count - 1 do begin
        writeLog(deviceSnList[i] + ',' + deviceIpList[i]);
        if (connectDevByIP(deviceSnList[i], deviceIpList[i], strHexMask, strHexGateway)) then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;
        if APP_DEBUGMODE then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;

    end;

    deviceSnList.Free;
    deviceIpList.Free;

    if DeviceRecords = nil then
        DeviceRecords := TStringList.Create;

    makeDir(ExtractFilePath(paramstr(0)) + '..\data');
    makeDir(ExtractFilePath(paramstr(0)) + '..\data\bak');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown\bak');
end;

//��ʼ���豸���ӣ�������豸��ǰ��ʱ�䡢��¼����IP��ַ��MAC��ַ
function getDeviceStatus(devSN: integer): boolean;
var
    //controllerSN: Integer; //���������к�
    startLocation: Integer; //��ʼƫ��λ��
begin
    getWUDP();
    //controllerSN := StrToInt64(devSN);
    devIpAddrHex := '';
    devIpAddr := '';
    //��ȡ����״̬��Ϣ
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) ��ʾ��0����¼, Ҳ�����¼�¼
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡

    strFrame := v_wudp.udp_comm(strCmd, devIpAddrHex, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('[' + IntToStr(devSN) + ']��ȡ������Ϣʧ��,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        devClock := v_wudp.GetClockTimeFromRunInfo(strFrame);
        devRecordCount := IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
        devPrivilegeCount := IntToStr(v_wudp.GetPrivilegeNumFromRunInfo(strFrame));
    end;
    //��ѯ��������IP����
    //��ȡ����������Ϣָ��
    strCmd := v_wudp.CreateBstrCommand(devSN, '0111'); //����ָ��֡ ��ȡ����������Ϣָ��
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('[' + IntToStr(devSN) + ']��ȡ����������Ϣʧ��,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        //'MAC
        startLocation := 11;
        devMacAddr := copy(strFrame, startLocation, 12);
        //IP
        startLocation := 23;
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;
    result := true;
end;

function getRecordCount(devSN: integer; devIP: WideString): integer;
var
    recCount: integer;
begin
    getWUDP();
    recCount := 0;
    //��ȡ����״̬��Ϣ
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) ��ʾ��0����¼, Ҳ�����¼�¼
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('[' + IntToStr(devSN) + ']��ȡ������Ϣʧ��,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
    end
    else begin
        recCount := v_wudp.GetCardRecordCountFromRunInfo(strFrame);
    end;
    result := recCount;
end;

function setDeviceIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
var
    ip: TStrings;
    sConfigIP, strHexNewIP: WideString; //New IP (ʮ������) ,�豸��MAC��ַ
    controllerSN: Integer; //���������к�
    startLocation: Integer;
begin
    getWUDP();
    controllerSN := StrToInt64(devSN);
    //�任ip
    ip := TStringList.Create;
    ip.Delimiter := '.';
    ip.DelimitedText := devIP;

    sConfigIP := ip[0] + ip[1] + ip[2] + ip[3];
    strHexNewIP := v_wudp.NumToStrHex(ip[0], 1)
        + v_wudp.NumToStrHex(ip[1], 1)
        + v_wudp.NumToStrHex(ip[2], 1)
        + v_wudp.NumToStrHex(ip[3], 1);

    ip.Free;

    devIpAddrHex := '';
    devIpAddr := '';
    //��ȡ����״̬��Ϣ
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) ��ʾ��0����¼, Ҳ�����¼�¼
    strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡

    strFrame := v_wudp.udp_comm(strCmd, devIpAddrHex, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('[' + devSN + ']��ȡ������Ϣʧ��,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        devClock := v_wudp.GetClockTimeFromRunInfo(strFrame);
        devRecordCount := IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
    end;
    //��ѯ��������IP����
    //��ȡ����������Ϣָ��
    strCmd := v_wudp.CreateBstrCommand(controllerSN, '0111'); //����ָ��֡ ��ȡ����������Ϣָ��
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //û���յ�����,
        //ʧ�ܴ������... (��ErrCode����Է�������)
        writelog('[' + devSN + ']��ȡ����������Ϣʧ��,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        //'MAC
        startLocation := 11;
        devMacAddr := copy(strFrame, startLocation, 12);
        //IP
        startLocation := 23;
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;

    //����IP��ַ
    application.ProcessMessages;

    if (sConfigIP <> devIpAddr) then begin
        strCmd := v_wudp.CreateBstrCommand(controllerSN, 'F211' + devMacAddr + strHexNewIP + devMask + devGateWay + '60EA'); // ����ָ��֡ ��ȡ����������Ϣָ��
        strFrame := v_wudp.udp_comm(strCmd, '', C10PORT); //����ָ��, ����ȡ������Ϣ
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            result := false;
            writeLog(Tag_Error + '[' + devSN + ']' + '[' + strHexNewIP + ']IP��ַ����ʧ��,retcode=' + IntToStr(v_wudp.ErrCode));
            Exit;
        end
        else begin
            application.ProcessMessages;
            writeLog('[' + devSN + ']' + '[' + strHexNewIP + ']IP��ַ�������');
            Sleep(DEVICE_INTERNAL); //����3����ʱ
        end;
    end
    else begin
        writeLog('[' + devSN + ']' + '[' + sConfigIP + ']IP�����ã�����Ҫ������');
    end;
    result := true;
end;

function monitorDevice(controllerSN: Integer): string;
var
    ip: string;
    //strs: TStrings;
    watchIndex, cardId, recCnt: Integer;
    status: Integer; //״̬
begin
    recCnt := 0;
    watchIndex := 0;
    application.ProcessMessages;
    while true do begin
        strFuncData := '8110' + v_wudp.NumToStrHex(watchIndex, 3); //wudp.NumToStrHex(watchIndex,3) ��ʾ��watchIndex����¼, �����0��ȡ����һ����¼
        strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //����ָ��֡
        strFrame := v_wudp.udp_comm(strCmd, ip, C10PORT); //����ָ��, ����ȡ������Ϣ
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            Exit
        else begin
            swipeDate := v_wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
            {//�м�¼ʱ}
            if swipeDate <> '' then begin
                form1.Text1.Lines.Add('����: ' + cardNoToHex(cardId) + Chr(13) + Chr(10)
                    + '״̬:' + IntToStr(status) + '(' + v_wudp.NumToStrHex(status, 1)
                    + ')' + Chr(13) + Chr(10) + 'ʱ��:' + swipeDate + Chr(13) + Chr(10)
                    + 'strFrame=[' + strFrame + ']');

                if watchIndex = 0 then //����յ���һ����¼
                    watchIndex := v_wudp.GetCardRecordCountFromRunInfo(strFrame) + 1 //ָ��(�ܼ�¼��+1), Ҳ�����´�ˢ���Ĵ洢����λ
                else
                    watchIndex := watchIndex + 1; //ָ����һ����¼λ
                recCnt := recCnt + 1; //��¼����
            end;
        end;
        application.ProcessMessages;
        if recCnt > 3 then break;
    end;
    result := '��ֹͣʵʱ���';

end;



procedure downloadAllCardByOne(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
var
    j: integer;
    //time1: TDateTime;
begin
    //time1 := Now;
    //cleanPrivilege(devSN, devIP);
    for j := 0 to cardList.Count - 1 do begin
        if (addOrModifyPrivilege(devSN, devIP, cardList[j], doorNo) = true) then begin
            form1.Text1.lines.Add('[' + IntToStr(j) + ']' + '������[' + devIP + '],����=[' + cardList[j] + ']���Ȩ�޳ɹ�');
            Sleep(downinternal);
            if (form1.Text1.Lines.Count = 200) then begin
                form1.Text1.Lines.Clear;
            end;
        end
        else begin
            writelog('������[' + devIP + '],����=[' + cardList[j] + ']���Ȩ��ʧ��');
            writeCardList('45' + cardNoToHex(StrToInt(cardList[j])) + ',1');
        end;
    end;
end;

procedure downloadAllCard(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
var
    j, privilegeIndex: integer;
    //    cardno: string;
    //    status: Integer; //״̬
    privilege: WideString; //Ȩ��
    time1: TDateTime;
begin
    time1 := Now;

    //cleanPrivilege(devSN, devIP);
    privilegeIndex := 1;
    for j := 0 to cardList.Count - 1 do begin
        privilege := '';
        privilege := v_wudp.CardToStrHex(cardList[j]); //����
        privilege := privilege + v_wudp.NumToStrHex(doorNo, 1); //�ź�
        privilege := privilege + v_wudp.MSDateYmdToWCDateYmd('2007-8-14'); //��Ч��ʼ����
        privilege := privilege + v_wudp.MSDateYmdToWCDateYmd('2020-12-31'); //��Ч��ֹ����
        privilege := privilege + v_wudp.NumToStrHex(1, 1); //ʱ��������
        privilege := privilege + v_wudp.NumToStrHex(123456, 3); //�û�����
        privilege := privilege + v_wudp.NumToStrHex(0, 4); //����4�ֽ�(��0���)

        //���ɵ�Ȩ�޲�����Ҫ��, ���һ����һָ����д���ÿ�������Ƿ���ȷ
        if (Length(privilege) <> (16 * 2)) then begin
            writelog('������[' + devIP + '],����=[' + cardList[j] + ']���ɵ�Ȩ�޲�����Ҫ��');
            Exit;
        end;
        strFuncData := '9B10' + v_wudp.NumToStrHex(privilegeIndex, 2) + privilege;
        strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
        strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ

        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //û���յ�����,
            //ʧ�ܴ������... (��ErrCode����Է�������)
            //�û��ɿ�������
            form1.Text1.lines.Add('������[' + devIP + '],����=[' + cardList[j] + ']���Ȩ��ʧ��');
            writelog('������[' + devIP + '],����=[' + cardList[j] + ']���Ȩ��ʧ��');
            Exit;
        end
        else begin
            privilegeIndex := privilegeIndex + 1;

            form1.Text1.lines.Add('[' + IntToStr(privilegeIndex) + ']' + '������[' + devIP + '],����=[' + cardList[j] + ']���Ȩ�޳ɹ�');
            Sleep(downinternal);
            if (form1.Text1.Lines.Count = 200) then begin
                form1.Text1.Lines.Clear;
            end;
        end;
    end;
    writelog('������sn[' + IntToStr(devSN) + '],ip=[' + devIP + '],�����·�����=' + IntToStr(cardList.Count) + ',����ʱ�䣨�룩=' + IntToStr(SecondsBetween(time1, now)));

end;

function cardHexToNo(cardphyid: string): string;
begin
    result := IntToStr(StrToInt64('$' + copy(cardphyid, 1, 2)))
        + IntToStr(StrToInt64('$' + copy(cardphyid, 3, 4)));
end;

function cardNoToHex(cardno: integer): string;
var
    cardhex: string;
begin
    cardhex := v_wudp.CardToStrHex(cardno);
    result := copy(cardhex, 5, 2) + copy(cardhex, 3, 2) + copy(cardhex, 1, 2);
end;

function cardYktToDev(cardphyid: string): string;
begin
    result := copy(cardphyid, 5, 2) + copy(cardphyid, 3, 2) + copy(cardphyid, 1, 2);
end;


function NumberSort(List: TStringList; Index1, Index2: Integer): Integer;
var
    Value1, Value2: Integer;
begin
    Value1 := StrToInt(List[Index1]);
    Value2 := StrToInt(List[Index2]);
    if Value1 > Value2 then
        Result := 1
    else if Value1 < Value2 then
        Result := -1
    else
        Result := 0;
end;

function devAlwaysOpen(devSN: integer; devIP: WideString; devMode, devDelay: integer): boolean;
begin
    strFuncData := '8F10' + v_wudp.NumToStrHex(1, 1) //doorNo=1
    + v_wudp.NumToStrHex(devMode, 1) //control mode=1
    + v_wudp.NumToStrHex(devDelay*10, 1) //delay 3s
    ;

    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //����ָ��֡
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //����ָ��, ����ȡ������Ϣ
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + '],openʧ��,ret=' + strFrame);
        result := false;
        exit;
    end;
    result := true;

end;


end.

