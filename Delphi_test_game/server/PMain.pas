unit PMain;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPServer, PGmProtect, PcardClass,
  StdCtrls;
type
  TTab = class //������
  private
    FId: Cardinal; //�Լ���id��
    FmaxCount: Byte; //�����������
    FGaming: boolean; //�Ƿ�����Ϸ��
    FGamekind: SGameKind; //����ɶ��Ϸ
    FTabName: string; //������
    FPlayerArr: Tlist; //��ҵ��б�
    FSendBuffPlayerArr: array of RPlayer; //����
    function GetPlayerCount: Byte;
    function GetSendBuffEntry: Pointer; //��ȡtab�û��Ľ����
    procedure GiveTabPlayerList(AThread: TIdPeerThread; IEntryPointer: Pointer; Isize: Integer); overload; //��ָ���û������б�
    procedure GiveTabPlayerList(IEntryPointer: Pointer; Isize: Integer); overload; //�������û�����
    procedure PlayerChange(IKind: sPlayerChange; IIdx: Byte; Iplayer: Prplayer; Istate: boolean = True); //�û�����
    procedure JoinTabRESP(Athread: TIdPeerThread; IPlayerIdx: byte);
  public
    property MaxCount: byte read FmaxCount write FmaxCount;
    property gameing: boolean read FGaming;
    property TabName: string read FTabName write FTabName;
    property id: Cardinal read Fid write Fid;
    property GameKind: SGameKind read FGamekind;
    property PlayerCount: Byte read GetPlayerCount;
    function InPlayer(IPplayer: PRPlayer): Byte; //�������
    procedure LeavePlayer(Iindex: byte; IsOut: boolean = false); //�뿪���
    function GetPlayer(Iindex: Byte): PRplayer; //��ȡ���ָ��
    procedure ReadyGame(IplayerIdx: Byte; IReadState: Boolean); //���׼������ȡ��׼����Ϸ
    function IsallReady: boolean; //�ж��Ƿ��������׼������
    procedure BeginGame; //��ʼ�������ӵ���Ϸ
    procedure GiveBeginPlayerIdx(Iidx: byte); //�������ʼ���������־�ſ�ʼ��Ϸ
    procedure PlayerCards(IBuff: RSTC_PlayerSendCards); //��ҳ���
    procedure PlayerPass(Ibuff: RSTC_PlayerPass); //�������
    procedure PlayerChat(Ibuff: RCTS_Chat); //�������
    procedure PlayerWin(Ibuff:RCTS_UseWin);//���ӮǮ
    constructor Create(ItabName: string; IGmKind: SGameKind; IId: Cardinal; ImaxPlayer: Byte = 4);
    destructor Destory;
  end;
  TGameTabMana = class //��Ϸ�ֹ�����
  private
    FGobleTabID: Cardinal; //��Ϸ���ӵ�ID��
  public
    FCurrTabCount: Cardinal; //���е���������
    FGameTabArr: TList; //�����б�
    property CurrTabCount: Cardinal read FCurrTabCount; //���е���������
    function GetaTabID: Cardinal; //����һ��tabiD
    function NewTab(ITabName: string; ISGkind: SGameKind): Cardinal; //����һ������
    procedure FreeTab(Iindex: Cardinal); //�ͷ�����
    function GetTab(IId: Cardinal): TTab; //��ȡ����
    constructor Create;
    destructor Destory;
  end;
type
  TFMain = class(TForm)
    GameServer: TIdTCPServer;
    Memo1: TMemo;
    procedure GameServerConnect(AThread: TIdPeerThread);
    procedure GameServerExecute(AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GameServerListenException(AThread: TIdListenerThread;
      AException: Exception);
    procedure GameServerDisconnect(AThread: TIdPeerThread);
    procedure GameServerException(AThread: TIdPeerThread;
      AException: Exception);
  private
    GBuffHead: RHead;
    GBuffLogin: RCTS_login;
    Lbuff: array of RWaiteTab; //����tab��buff
    LBuffCount: Cardinal; // ����tab�ļ���
    FOnlinesUserCount:Integer;//�����û�����
    Property OnlinesUserCount:Integer Read FOnlinesUserCount Write FOnlinesUserCount;
    function CanLoginIn(ILogin: RCTS_login): Boolean; //�ж��Ƿ�����ͻ��˵�½��
    procedure CreateTab(athread: TIdPeerThread);
    procedure JoinTab(Athread: TIdPeerThread);
    procedure ReadyGame(Athread: TIdPeerThread);
    procedure LeaveTab(athread: TIdPeerThread);
    procedure DisConn(Athread: TIdPeerThread);
    procedure PlayerSendCard(Athread: TIdPeerThread);
    procedure PlayerPass(Athread: TIdPeerThread);
    procedure PlayerChat(Athread: TIdPeerThread);
    Procedure GetOnlineUsersCount(Athread:TIdPeerThread);
    procedure PlayerWinMoney(Athread:TIdPeerThread);//�û�ӮǮ��
  public
    AppState: string;
    GameManage: TGameTabMana;
    WaitePlayerLIst: TList; //�ȴ���ҵ��б�
    procedure AddShow(IStr: string);
    procedure SendHead(AThread: TIdPeerThread; Iheadcmid: Smallint);
    procedure GiveCards(aThread: TIdPeerThread; TENtryPointer: Pointer; IRandomsArrSize: Integer; ICount: Byte); //���û��ƾ�
    function GetWaiteTabArrEntry(var ICount: Cardinal): Pointer; //��ȡ�ȴ��������б�Ľ����
    procedure GiveUserTabList(athread: TIdPeerThread; TENtryPointer: Pointer; ISize: Integer); //��������buff
    procedure TabChanged(athread: TIdPeerThread; Ikind: sTabChange; Iparam: Cardinal; IWaiteTab: PRWaiteTab); overload; //��һ�û������б����ı�
    procedure TabChanged(Ikind: sTabChange; Iparam: Cardinal; IWaiteTab: PRWaiteTab); overload; //�������й��û������б����ı�
  end;

var
  FMain: TFMain;

implementation

uses Math;

{$R *.dfm}

{ TGameTabMana }

constructor TGameTabMana.Create;
begin
  FGameTabArr := TList.Create;
end;

destructor TGameTabMana.Destory;
var
  I: Integer;
begin
  for I := 0 to FGameTabArr.Count - 1 do begin // Iterate
    TTab(FGameTabArr.Items[i]).Free;
  end; // for
  FGameTabArr.Free;
end;

procedure TGameTabMana.FreeTab(Iindex: Cardinal);
var
  Ltep: TTab;
begin
  Dec(FCurrTabCount);
  Ltep := GetTab(Iindex);
  FMain.TabChanged(TabFree, Ltep.id, nil);
  FGameTabArr.Delete(FGameTabArr.IndexOf(Ltep));
end;

function TGameTabMana.GetaTabID: Cardinal;
begin
  inc(FGobleTabID);
  Result := FGobleTabID;
end;

function TGameTabMana.GetTab(IId: Cardinal): TTab;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FGameTabArr.Count - 1 do begin // Iterate
    if TTab(FGameTabArr[i]).id = IId then begin
      Result := TTab(FGameTabArr[i]);
      Break;
    end;
  end; // for
end;

function TGameTabMana.NewTab(ITabName: string; ISGkind: SGameKind): Cardinal;
var
  LTab: TTab;
  LTep: PRWaiteTab;
begin
  inc(FCurrTabCount);
  LTab := TTab.Create(ITabName, ISGkind, GetaTabID);
  FGameTabArr.Add(LTab);
  Result := LTab.id;
  new(LTep); //�������й���û�����������
  LTep.TabID := LTab.id;
  LTep.TabKind := LTab.GameKind;
  LTep.TabName := LTab.TabName;
  LTep.TabPlayerCount := 0;
  FMain.TabChanged(TabAdd, LTep.tabid, LTep);
  Dispose(LTep);
end;

{ TTab }

procedure TTab.BeginGame;
var
  I, x: Integer;
  Test: array of byte;
begin
  FGaming := True; //�����Ӹ�Ϊ��Ϸ��
  Randomize;
  SetLength(Test, 52);
  for I := 0 to 51 do begin // Iterate
    repeat
      x := Random(51);
    until Test[x] = 0;
    Test[X] := i;
  end; // for
  for I := 0 to FPlayerArr.Count - 1 do begin // Iterate
    PRplayer(FPlayerArr[i]).TotMoney:=PRplayer(FPlayerArr[i]).TotMoney-2;
    FMain.GiveCards(PRplayer(FPlayerArr.Items[i]).Contenting,
      @test[0], 52 * Sizeof(byte), 52);
  end; // for
  GiveBeginPlayerIdx(Random(MaxCount-1) + 1);
end;

constructor TTab.Create(ItabName: string; Igmkind: SGameKind; Iid: Cardinal; ImaxPlayer: Byte);
begin
  MaxCount := ImaxPlayer;
  FGaming := False;
  FTabName := ItabName;
  FGamekind := IGmKind;
  FId := IId;
  FPlayerArr := TList.Create;
end;

destructor TTab.Destory;
begin
  FPlayerArr.Free;
end;

function TTab.GetPlayer(Iindex: Byte): PRplayer;
begin
  Result := PRplayer(FPlayerArr.Items[Iindex]);
end;

function TTab.GetSendBuffEntry: Pointer;
var
  I: Integer;
begin
  SetLength(FSendBuffPlayerArr, PlayerCount);
  for I := 0 to FPlayerArr.Count - 1 do begin // Iterate
    FSendBuffPlayerArr[i] := PRplayer(FPlayerArr.Items[i])^;
  end; // for
  Result := Pointer(FSendBuffPlayerArr);
end;

procedure TTab.GiveTabPlayerList(AThread: TIdPeerThread;
  IEntryPointer: Pointer; Isize: Integer);
var
  LBuff: RSTC_GiveTabPlayerList;
begin
  FMain.SendHead(AThread, Cmid_STC_GiveTabPlayerList);
  LBuff.size := Isize;
  LBuff.Count := PlayerCount;
  AThread.Connection.WriteBuffer(Lbuff, Sizeof(LBuff));
  AThread.Connection.WriteBuffer(IEntryPointer^, LBuff.size);
end;

procedure TTab.GiveTabPlayerList(IEntryPointer: Pointer; Isize: Integer);
var
  I: Integer;
  Lbuff: RSTC_GiveTabPlayerList;
begin
  for I := 0 to PlayerCount - 1 do begin // Iterate
    Lbuff.size := Isize;
    Lbuff.Count := PlayerCount;
    PRPlayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(Lbuff, sizeof(Lbuff));
    PRPlayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(IEntryPointer^, Lbuff.size);
  end; // for
end;

function TTab.InPlayer(IPplayer: PRPlayer): byte;
begin
  GiveTabPlayerList(IPplayer.Contenting, GetSendBuffEntry, sizeof(Rplayer) * PlayerCount); //����ҷ��ش�tab�������б�
  FMain.WaitePlayerLIst.Delete(FMain.WaitePlayerLIst.IndexOf(IPplayer)); //���й�����б����Ƴ�
  IPplayer.ReadGame := False; //��ʼ������ʱ���׼����Ϸ��״̬
  IPplayer.Index := id;
  Result := FPlayerArr.Add(IPplayer);
  IPplayer.ID := Result;
  PlayerChange(PlayerIn, 0, IPplayer); //֪֮ͨǰ���������
  JoinTabRESP(IPplayer.Contenting, Result);
  FMain.TabChanged(TabAddPlayer, id, nil);
end;

function TTab.IsallReady: boolean;
var
  I: Integer;
begin
  Result := True;
  if PlayerCount < MaxCount then begin
    Result := False;
    Exit;
  end;
  for I := 0 to PlayerCount - 1 do begin // Iterate
    if not PRplayer(FPlayerArr.Items[i]).ReadGame then begin
      Result := False;
      break;
    end;
  end; // for
end;

procedure TTab.LeavePlayer(Iindex: byte; IsOut: boolean = false);
var
  I: Integer;
  LBuff: RSTC_ReSetPalyerIDX;
begin
  FMain.TabChanged(TabDeletePlayer, id, nil);
  if not IsOut then
    FMain.WaitePlayerLIst.Add(FPlayerArr.Items[iindex]); //����Ҽ���ȴ��б�
  PRplayer(FPlayerArr.Items[Iindex]).ReadGame := False; //��ʼ����ͬ�⿪ʼ��Ϸ��״̬
  FPlayerArr.Delete(Iindex);
  PlayerChange(PlayerOut, Iindex, nil);
  for I := 0 to FPlayerArr.Count - 1 do begin // Iterate
    FMain.SendHead(PRplayer(FPlayerArr.Items[i]).Contenting,CMID_STC_ReSetPlayerIDX);
    LBuff.NewIdx := i;
    PRplayer(FPlayerArr.Items[i]).ID := i;
    PRplayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(lbuff, sizeof(LBuff));
  end; // for
  If FPlayerArr.Count=0 Then  Self.Free;    
end;

procedure TTab.PlayerChange(IKind: sPlayerChange; IIdx: Byte;
  Iplayer: Prplayer; Istate: boolean = True);
var
  I: Integer;
  Lbuff: RSTC_PlayerIO;
begin
  for I := 0 to PlayerCount - 1 do begin // Iterate
    FMain.SendHead(PRplayer(FPlayerArr.Items[i]).Contenting, Cmid_STC_PlayerIO);
    Lbuff.Kind := IKind;
    Lbuff.Idx := IIdx;
    if Iplayer <> nil then
      Lbuff.Player := Iplayer^;
    Lbuff.State := Istate;
    PRplayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(Lbuff, sizeof(Lbuff));
  end; // for
end;

procedure TTab.JoinTabRESP(Athread: TIdPeerThread; IPlayerIdx: byte);
var
  LResp: RCTS_JoinTab_RESP;
begin
  LResp.TabId := id;
  LResp.PlayerINDEX := IPlayerIdx;
  FMain.SendHead(Athread, CMid_CTS_JoinTab);
  Athread.Connection.WriteBuffer(lRESP, Sizeof(LResp));
end;


procedure TTab.ReadyGame(IplayerIdx: Byte; IReadState: Boolean);
var
  LtepState: sPlayerChange;
begin
  PRplayer(FPlayerArr.Items[IplayerIdx]).ReadGame := IReadState;
  if IReadState then LtepState := PlayerReady else LtepState := PlayernotReady;
  PlayerChange(LtepState, IplayerIdx, nil);
  if IReadState then //�����׼�������ǾͿ�ʼ��Ϸ
    if IsallReady then
      BeginGame;
end;

function TTab.GetPlayerCount: Byte;
begin
  Result := FPlayerArr.Count;
end;

procedure TTab.GiveBeginPlayerIdx(Iidx: byte);
var
  I: Integer;
  Lbuff: RSTC_GiveBeginPlayerIdx;
begin
  Lbuff.Index := Iidx;
  for I := 0 to FPlayerArr.Count - 1 do begin // Iterate
    FMain.SendHead(PRplayer(FPlayerArr.Items[i]).Contenting, Cmid_STC_GiveBeginPlayerIdx);
    PRplayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(Lbuff, Sizeof(Lbuff));
  end; // for
end;

procedure TTab.PlayerCards(IBuff: RSTC_PlayerSendCards);
var
  I: Integer;
begin
  PRplayer(FPlayerArr[IBuff.PlayerIdx]).TotMoney:=PRplayer(FPlayerArr[IBuff.PlayerIdx]).TotMoney-IBuff.Scores;
  for I := 0 to FPlayerArr.Count - 1 do begin // Iterate
    FMain.SendHead(PRplayer(FPlayerArr.Items[i]).Contenting, Cmid_STC_UserSendCards);
    PRplayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(IBuff, Sizeof(IBuff));
  end; // for
end;

procedure TTab.PlayerPass(Ibuff: RSTC_PlayerPass);
var
  I: Integer;
begin
  for I := 0 to FPlayerArr.Count - 1 do begin // Iterate
    FMain.SendHead(PRplayer(FPlayerArr.Items[i]).Contenting, Cmid_STC_UserPass);
    PRplayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(IBuff, Sizeof(IBuff));
  end; // for
end;

procedure TTab.PlayerChat(Ibuff: RCTS_Chat);
var
  I: Integer;
begin
  for I := 0 to FPlayerArr.Count - 1 do begin // Iterate
    FMain.SendHead(PRplayer(FPlayerArr.Items[i]).Contenting, Cmid_CTS_Chat);
    PRplayer(FPlayerArr.Items[i]).Contenting.Connection.WriteBuffer(IBuff, Sizeof(IBuff));
  end; // for
end;



procedure TTab.PlayerWin(Ibuff: RCTS_UseWin);
var
  I: Integer;
begin
  for I := 0 to  FPlayerArr.Count-1 do    // Iterate
    PRplayer(FPlayerArr[i]).ReadGame:=False;
  prPlayer(FPlayerArr.Items[Ibuff.PlayIdx]).TotMoney:=
    prPlayer(FPlayerArr.Items[Ibuff.PlayIdx]).TotMoney+Ibuff.AddScore;
end;

{ TFMain }

function TFMain.CanLoginIn(ILogin: RCTS_login): Boolean;
begin
  Result := True;
end;

procedure TFMain.GameServerConnect(AThread: TIdPeerThread);
var
  I: Integer;
  LTep: PRPlayer;
  LEntry: Pointer;
begin
  if AppState <> CappstateNormal then AThread.Connection.Disconnect;
  AddShow('�ͻ�����ͼ��¼...');
  Athread.Connection.ReadBuffer(GbuffHead, sizeof(GBuffHead));
  if GBuffHead.Cmid = Cmid_CTS_Login then
    Athread.Connection.ReadBuffer(Gbufflogin, Sizeof(GBuffLogin));
  if CanLoginIn(GBuffLogin) then begin
    AddShow('ͨ����֤');
      //����player�ļ�¼
    New(ltep);
    LTep^.Name := GBuffLogin.Acc;
    LTep^.Contenting := AThread;
    LTep^.TotMoney := 100;
    AThread.Data := Pointer(ltep);
    WaitePlayerLIst.Add(AThread.Data);
    AddShow('���ɹ������');
      //���û��������������б�
    AddShow('��ͻ��˷��Ϳ����������');
    LEntry := GetWaiteTabArrEntry(LBuffCount);
    GiveUserTabList(AThread, LEntry, LBuffCount * sizeof(RWaiteTab));
    OnlinesUserCount:=OnlinesUserCount+1;
    if WaitePlayerLIst.Count>0 then      
      For I := 0 To WaitePlayerLIst.Count - 1 Do     // Iterate
        GetOnlineUsersCount(PrPlayer(waitePlayerList.Items[i]).Contenting);
  end
  else begin
    AddShow('û��ͨ��Ӧ֤ �Ͽ�����');
    Athread.Connection.Disconnect;
  end;
end;

procedure TFMain.GameServerExecute(AThread: TIdPeerThread);
var
  LHead: RHead;
  Ltep: pointer;
begin
  if AppState <> CappstateNormal then Exit;
  with AThread do begin
    Connection.ReadBuffer(LHead, SizeOf(LHead));
    case LHead.Cmid of //
      CMid_CTS_JoinTab: JoinTab(AThread); //��������
      CMID_CTS_LeaveTab: LeaveTab(AThread);
      CMid_CTS_DisConn: begin
          SendHead(AThread, CMid_CTS_DisConn);
          AThread.Terminate;
        end;
      CMID_CTS_CreateTab: CreateTab(AThread);
      Cmid_CTS_ReadyGame: ReadyGame(AThread);
      Cmid_STC_GiveWaiteTabList: begin
          Ltep := GetWaiteTabArrEntry(LBuffCount);
          GiveUserTabList(AThread, Ltep, LBuffCount * sizeof(RWaiteTab))
        end;
      Cmid_STC_UserSendCards: PlayerSendCard(AThread);
      Cmid_STC_UserPass: PlayerPass(AThread);
      Cmid_CTS_Chat: PlayerChat(AThread);
      Cmid_CTS_GetOnlinesUser:GetOnlineUsersCount(AThread);
      Cmid_CTS_Userwin:PlayerWinMoney(AThread);
    end; // case
  end; // with
end;


procedure TFMain.JoinTab(Athread: TIdPeerThread);
var
  LBuff: RCTS_JoinTab;
  LTep: TTab;
begin
  with Athread do begin
    Connection.ReadBuffer(LBuff, SIZEOf(LBuff));
    LTep := GameManage.GetTab(LBuff.TabID);
    if LTep.PlayerCount + 1 <= LTep.MaxCount then begin
      LTep.InPlayer(Prplayer(Athread.Data));
      AddShow('�û�' + Prplayer(Athread.Data).Name + '������' + inttostr(LBuff.TabID) + '������');
    end;
  end; // with
end;

procedure TFMain.LeaveTab(athread: TIdPeerThread);
var
  Lbuff: RCTS_LeaveTab;
begin
  with Athread do begin
    Connection.ReadBuffer(LBuff, SIZEOf(LBuff));
    AddShow(Format('�û�%s���뿪������%d',
      [Prplayer(Athread.Data).Name, Lbuff.TabID]));
    GameManage.GetTab(LBuff.TabID).LeavePlayer(Lbuff.PlayerID);
    FMain.SendHead(athread, CMID_CTS_LeaveTab); //�����û����Ѿ��ɹ��뿪��
  end; // with
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  GameManage := TGameTabMana.Create;
  WaitePlayerLIst := TList.Create;
  AppState := CappstateNormal;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  GameServer.Free;
  WaitePlayerLIst.Free;
  GameManage.Free;
end;

procedure TFMain.GiveCards(aThread: TIdPeerThread; TENtryPointer: Pointer; IRandomsArrSize: Integer; ICount: Byte);
var
  Lbuff: RSTC_GiveCards;
begin
  FMain.SendHead(aThread, Cmid_STC_GiveCards);
  Lbuff.CardsSize := IRandomsArrSize;
  Lbuff.Count := ICount;
  aThread.Connection.WriteBuffer(lbuff, SIZEOF(Lbuff));
  aThread.Connection.WriteBuffer(tenTryPointer^, Lbuff.CardsSize);
end;

procedure TFMain.CreateTab(athread: TIdPeerThread);
var
  Lbuff: RCTS_CreateTab;
  LResp: RCTS_CreateTab_RESP;
begin
  with athread do begin
    athread.Connection.ReadBuffer(Lbuff, Sizeof(Lbuff));
    LResp.tabid := GameManage.NewTab(Lbuff.TabName, Lbuff.TabKind);
    AddShow('������Ϊ' + Lbuff.TabName + '������');
    GameManage.GetTab(LResp.tabid).InPlayer(PRplayer(athread.Data));
    SendHead(athread, CMID_CTS_CreateTab);
    Connection.WriteBuffer(lresp, sizeof(LResp));
  end; // with
end;

procedure TFMain.GiveUserTabList(athread: TIdPeerThread;
  TENtryPointer: Pointer; ISize: Integer);
var
  Lbuff: RSTC_GiveWaiteTabList;
begin
  SendHead(athread, Cmid_STC_GiveWaiteTabList);
  Lbuff.ListSize := ISize;
  aThread.Connection.WriteBuffer(lbuff, SIZEOF(Lbuff));
  aThread.Connection.WriteBuffer(tenTryPointer^, ISize);
end;

function TFMain.GetWaiteTabArrEntry(var Icount: Cardinal): Pointer;
var
  I: Integer;
begin
  if GameManage.FGameTabArr.Count = 0 then begin Result := nil; Exit; end;
  icount := 0;
  for I := 0 to GameManage.FGameTabArr.Count - 1 do begin // Iterate
    if not tTab(GameManage.FGameTabArr.Items[i]).gameing then begin
      inc(icount);
      SetLength(Lbuff, icount);
      Lbuff[icount - 1].TabID := tTab(GameManage.FGameTabArr.Items[i]).id;
      Lbuff[icount - 1].TabKind := tTab(GameManage.FGameTabArr.Items[i]).GameKind;
      Lbuff[icount - 1].TabName := tTab(GameManage.FGameTabArr.Items[i]).TabName;
      Lbuff[icount - 1].TabPlayerCount := tTab(GameManage.FGameTabArr.Items[i]).PlayerCount;
      Lbuff[icount - 1].TabMaxCount := tTab(GameManage.FGameTabArr.Items[i]).MaxCount;
    end;
  end; // for
  Result := Pointer(Lbuff);
end;

procedure TFMain.SendHead(AThread: TIdPeerThread; Iheadcmid: Smallint);
begin
  if not Assigned(AThread) then exit;
  GBuffHead.Cmid := Iheadcmid;
  AThread.Connection.WriteBuffer(GbuffHead, sizeof(GBuffHead));
end;

procedure TFMain.TabChanged(athread: TIdPeerThread; Ikind: sTabChange;
  Iparam: Cardinal; IWaiteTab: PRWaiteTab);
var
  Lbuff: RSTC_TabChange;
begin
  SendHead(athread, Cmid_STC_TabChange);
  Lbuff.Kind := Ikind;
  Lbuff.Param := Iparam;
  if Assigned(IWaiteTab) then
    Lbuff.WaiteTab := IwaiteTab^;
  athread.Connection.WriteBuffer(Lbuff, Sizeof(Lbuff));
end;

procedure TFMain.AddShow(IStr: string);
begin
  if Memo1.Lines.Add(datetimetostr(now) + ' :' + IStr) > 500 then
    Memo1.Clear;
end;

procedure TFMain.TabChanged(Ikind: sTabChange; Iparam: Cardinal; IWaiteTab: PRWaiteTab);
var
  I: Integer;
  Lbuff: RSTC_TabChange;
begin
  for I := 0 to WaitePlayerLIst.Count - 1 do begin // Iterate
    SendHead(PRPlayer(WaitePlayerLIst.Items[I]).Contenting, Cmid_STC_TabChange);
    Lbuff.Kind := Ikind;
    Lbuff.Param := Iparam;
    if Assigned(IWaiteTab) then
      Lbuff.WaiteTab := IwaiteTab^;
    PRPlayer(WaitePlayerLIst.Items[I]).Contenting.Connection.WriteBuffer(Lbuff, Sizeof(Lbuff));
  end; // for
end;

procedure TFMain.ReadyGame(Athread: TIdPeerThread);
var
  Lbuff: RCTS_ReadyGame;
begin
  Athread.Connection.ReadBuffer(Lbuff, Sizeof(Lbuff));
  GameManage.GetTab(Lbuff.TabID).ReadyGame(Lbuff.PlayerINDEX, Lbuff.STate);
  AddShow(Format('�û�%s������%d�Ͻ�״̬����Ϊ%s', [Prplayer(Athread.Data).Name,
    Lbuff.TabID, inttostr(Ord(Lbuff.STate))]));
end;

procedure TFMain.GameServerListenException(AThread: TIdListenerThread;
  AException: Exception);
begin
  AddShow(AException.Message);
end;

procedure TFMain.DisConn(Athread: TIdPeerThread);
var
  I: Integer;
begin
  OnlinesUserCount:=OnlinesUserCount-1;
  AddShow('�û�' + Prplayer(Athread.Data).Name + '�˳�������');
  i := WaitePlayerLIst.IndexOf(Athread.Data);
  if i > -1 then
    WaitePlayerLIst.Delete(i)
  else begin
    GameManage.GetTab(Prplayer(Athread.Data).Index).LeavePlayer(Prplayer(Athread.Data).ID, True);
  end;
  For I := 0 To WaitePlayerLIst.Count - 1 Do   // Iterate
  GetOnlineUsersCount(pRplayer(WaitePlayerLIst.Items[i]).Contenting);
  Dispose(Pointer(AThread.Data));
end;

procedure TFMain.GameServerDisconnect(AThread: TIdPeerThread);
begin
  DisConn(AThread);
end;

procedure TFMain.GameServerException(AThread: TIdPeerThread;
  AException: Exception);
begin
  if AThread.Connection.Connected then AThread.Connection.Disconnect;
end;

procedure TFMain.PlayerPass(Athread: TIdPeerThread);
var
  Lbuff: RSTC_PlayerPass;
begin
  Athread.Connection.ReadBuffer(Lbuff, sizeof(Lbuff));
  GameManage.GetTab(Lbuff.TabID).PlayerPass(Lbuff);
end;

procedure TFMain.PlayerSendCard(Athread: TIdPeerThread);
var
  Lbuff: RSTC_PlayerSendCards;
begin
  Athread.Connection.ReadBuffer(Lbuff, sizeof(Lbuff));
  GameManage.GetTab(Lbuff.TabID).PlayerCards(Lbuff);
end;

procedure TFMain.PlayerChat(Athread: TIdPeerThread);
var
  Lbuff: RCTS_Chat;
begin
  Athread.Connection.ReadBuffer(Lbuff, Sizeof(Lbuff));
  GameManage.GetTab(Lbuff.TabID).PlayerChat(Lbuff);
end;

procedure TFMain.GetOnlineUsersCount(Athread: TIdPeerThread);
Var
  Lbuff:RCTS_GetOnlinesUser;
begin
  Lbuff.Count:=OnlinesUserCount;
  SendHead(Athread,Cmid_CTS_GetOnlinesUser);
  Athread.Connection.WriteBuffer(Lbuff,Sizeof(Lbuff));
end;

procedure TFMain.PlayerWinMoney(Athread: TIdPeerThread);
var
  LBuff:RCTS_UseWin;
begin
  Athread.Connection.ReadBuffer(LBuff,Sizeof(LBuff));
  GameManage.GetTab(LBuff.TabId).PlayerWin(LBuff);
end;

end.

