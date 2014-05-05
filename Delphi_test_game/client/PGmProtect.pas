unit PGmProtect;

interface
uses
  IdTCPServer;
type
  SGameKind = (SGKsh, SGKsk, SGKddz); //��Ϸ����
  PRWaiteTab = ^RWaiteTab;
  RWaiteTab = packed record
    TabID: Cardinal;
    TabKind: SGameKind;
    TabName: string[40];
    TabPlayerCount: Byte;
    TabMaxCount:Byte;
  end;
  PRPlayer = ^Rplayer;
  Rplayer = record //��ҽṹ
    Index: Byte; //�Լ�������
    ID: Cardinal; //id��
    Name: string[20]; //�س�
    Contenting: TIdPeerThread; //����
    ReadGame: boolean; //׼���ÿ�ʼ��Ϸ
    PassCurrGame: boolean; //�Ƿ�����˵�ǰ��Ϸ
    TotMoney: Integer; //�ܷ�
  end;
  RHead = packed record
    Cmid: Cardinal;
  end;
  RCTS_login = packed record
    Acc: string[20];
    psd: string[20];
  end;
  RCTS_Login_RESP = packed record
    Code: string[20];
  end;
  RCTS_CreateTab = packed record
    TabName: string[40];
    TabKind: SGameKind;
  end;
  RCTS_CreateTab_RESP = packed record
    tabid: Cardinal;
  end;
  RCTS_JoinTab = packed record
    TabID: Cardinal;
  end;
  RCTS_JoinTab_RESP = packed record
    TabId: Cardinal;
    PlayerINDEX: byte;
  end;
  RCTS_ReadyGame = packed record
    TabID: Cardinal;
    PlayerINDEX: byte;
    STate: boolean;
  end;
  RCTS_LeaveTab = packed record
    TabID: Cardinal;
    PlayerID: Byte;
  end;
  RCTS_Chat=Packed Record
    SendIdx:Cardinal;
    TabID:Cardinal;
    PlayerID:Byte;
    Content:string[128];
  end;
  RCTS_GetOnlinesUser=Packed Record
    Count:Integer;
  end;
  RCTS_UseWin=Packed Record
    TabId:Cardinal;
    PlayIdx:Byte;
    AddScore:Integer;
  end;
  RSTC_GiveCards = packed record
    CardsSize: Cardinal;
    Count: Byte;
    SupperState: boolean; //�Ƿ񴴽���С��
    LoopCount: Byte; //ѭ������
  end;
  RSTC_ReSetPalyerIDX = packed record
    NewIdx: Byte;
  end;
  RSTC_GiveWaiteTabList = packed record
    ListSize: Cardinal;
  end;
  sTabChange = (TabAdd, TabFree, TabAddPlayer, TabDeletePlayer);
  RSTC_TabChange = packed record
    Kind: sTabChange;
    Param: Cardinal;
    WaiteTab: RWaiteTab;
  end;
  RSTC_GiveTabPlayerList = packed record
    size: Cardinal;
    Count: Cardinal;
  end;
  sPlayerChange = (PlayerIn, PlayerOut, PlayerReady, PlayernotReady);
  RSTC_PlayerIO = packed record
    Kind: sPlayerChange;
    Idx: Byte;
    Player: Rplayer;
    State: boolean;
  end;
  RSTC_GiveBeginPlayerIdx = packed record
    Index: Byte;
  end;
  RSTC_PlayerSendCards = packed record
    TabID: Cardinal;
    PlayerIdx: Byte;
    SendCards: string[20]; //�Ƶ�����������|�ָ�
    Scores: Integer; //�µ�ע
  end;
  RSTC_PlayerPass = packed record
    TabID: Cardinal;
    PLayerIdx: byte;
  end;

  Function TranstrlGameState(Ikind:SGameKind):String;
const
  CappstateNormal = '����״̬';
  CappStateStop = '����ֹͣ״̬';
  CappStateTermintal = '�������״̬';

  CErrorCode = 99;
  Cmid_CTS_Login = 10001; //��½
  ClogRESP1 = '�ɹ���½';
  ClogRESP2 = '�û���������';
  ClogRESP3 = '�û��������������';

  Cmid_CTS_ReadyGame = 10002; //׼����ʼ��Ϸ
  CMid_CTS_DisConn = 10003; //�Ͽ�����
  CMid_CTS_JoinTab = 10004; //����Tab
  CMID_CTS_LeaveTab = 10005; //�뿪����
  CMID_CTS_CreateTab = 10006; //��������
  Cmid_CTS_Chat=10007; //����
  Cmid_CTS_GetOnlinesUser=10008;//��ȡ�����û�
  Cmid_CTS_Userwin=10009;//�û�Ӯ��+��

  Cmid_STC_GiveCards = 20001; //�����ƾ�
  CMID_STC_ReSetPlayerIDX = 20002; //��������������������ӵ�����iD��
  Cmid_STC_GiveWaiteTabList = 20003; //�����ڵȴ����ӵ��б�
  Cmid_STC_TabChange = 20004; //���Ӳ����䶯
  Cmid_STC_GiveTabPlayerList = 20005; //��tab�û��б�
  Cmid_STC_PlayerIO = 20006; //��ұ䶯
  Cmid_STC_GiveBeginPlayerIdx = 20007; //����ʼ��ҵ�����
  Cmid_STC_UserSendCards = 20008; //��ҳ���
  Cmid_STC_UserPass = 20009; //��ҷ���������

implementation
  Function TranstrlGameState(Ikind:SGameKind):String;
  Begin
    Case Ikind Of    //
      SGKsh:Result:='���';
      Else Result:='����ʶ������';
    End;    // case
  End;
end.
