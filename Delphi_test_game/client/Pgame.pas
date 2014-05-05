unit Pgame;

interface

uses
  SysUtils, messages, Windows, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, ComCtrls, RzPrgres, RzPanel, RzCmboBx, Dialogs,
  RzButton, RzLabel, RzEdit, RzListVw, Animate, GIFCtrl,
  PcardClass, PRenameCard, PGmProtect, IdTCPConnection, IdTCPClient,
  ImgList;
type
  TReNameCard = class(TCard);
  TFgame = class(TForm)
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Bevel13: TBevel;
    Bevel14: TBevel;
    Bevel15: TBevel;
    Bevel16: TBevel;
    Bevel17: TBevel;
    Bevel18: TBevel;
    Bevel19: TBevel;
    Bevel20: TBevel;
    Bevel2: TBevel;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    RzBitBtn3: TRzBitBtn;
    RzComboBox1: TRzComboBox;
    BTsendCard: TRzBitBtn;
    BtPass: TRzBitBtn;
    ChoseMoney: TRzComboBox;
    Bevel21: TBevel;
    Bevel22: TBevel;
    Bevel23: TBevel;
    Bevel24: TBevel;
    RzGroupBox1: TRzGroupBox;
    lbCurrPlayer: TRzLabel;
    RxGifTip: TRxGIFAnimator;
    RzBitBtn6: TRzBitBtn;
    RzBitBtn7: TRzBitBtn;
    TurnTimer: TTimer;
    Lbup: TRzLabel;
    LbDown: TRzLabel;
    LbLeft: TRzLabel;
    LbRight: TRzLabel;
    RzBitBtn4: TRzBitBtn;
    Rzlistplayer: TRzListView;
    Showmemo: TRzRichEdit;
    RzProgressBar1: TRzProgressBar;
    RzLabel1: TRzLabel;
    GroupTabuserList: TRzGroupBox;
    GroupShow: TRzGroupBox;
    Imgup: TImage;
    ImgRight: TImage;
    ImgDown: TImage;
    imgLeft: TImage;
    ImageList1: TImageList;
    Image1: TImage;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RzBitBtn1Click(Sender: TObject);
    procedure RzBitBtn2Click(Sender: TObject);
    procedure RzBitBtn3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure RzComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzBitBtn7Click(Sender: TObject);
    procedure RzBitBtn6Click(Sender: TObject);
    procedure TurnTimerTimer(Sender: TObject);
    procedure BtPassClick(Sender: TObject);
    procedure ChoseMoneyChange(Sender: TObject);
    procedure ChoseMoneySelect(Sender: TObject);
    procedure BTsendCardClick(Sender: TObject);
    procedure ChoseMoneyKeyPress(Sender: TObject; var Key: Char);
    procedure RzBitBtn4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTurnBeginTime: TTime;
    JPGParth: string;
  public
    GMyGame: TTSPCard;
    procedure GameCreate;
    procedure GameBeging(IrandomPlayerIndex: Byte);
    procedure GameFree;
    procedure TalktoEveryBady(Icon: TIdTcpClient; Ibuff: RCTS_Chat); //����
    procedure AddShow(Icontent: string); //�����ʾ
    function GetPostBelve(Ipostion: sPlayerPostion; ICount: Byte): TBevel; //��ȡ���
    procedure ShowCard(IValue: PROneCard; Ipst: sPlayerPostion; IPos: Byte); //���˿˻��Ƴ���
    procedure SHowGifTip(IBevel: TBevel); //�� ������ʾ
    procedure SHowButtom(IState: boolean); //�ֵ���ǰ��� ��ʾ/���ذ�ť
    function TurnSelf(ISelfIdx: byte): boolean; //�ж��Ƿ��ֵ��Լ���
    function CurrIsPassUser: boolean; //�Ƿ��Ƿ������û�
    procedure TakeTimeBegin(Iplayer: PRplayer); //��ʱ��ʼ
    procedure SetCurrLable(Iplayer: PRplayer); //���õ�ǰ�����Ϣ
    procedure LookValue(Sender: TObject); //�쿴�Լ���ͷ��
    procedure SendCards(Ibuff: RSTC_PlayerSendCards); //��ҳ���
    procedure ShowNext; //������һ��
    procedure ShowName(IPost: sPlayerPostion; Iplayer: PRplayer); //�����ֺ�ͷ��
    procedure VisibleName(Ipost: sPlayerPostion); //�������ֺ�ͷ��
    procedure PlayerWined(Iidx: byte); //���Ӯ�������
    procedure AddMoney(ICon: TIdTCPClient); //�ӷ�
    procedure ShowRule; //��ʾ����
  end;

var
  Fgame: TFgame;
  CardHandle: TList;

implementation

uses Pmain, DateUtils;

{$R *.dfm}

procedure TFgame.Button4Click(Sender: TObject);
begin
  if Fmain.Tabing then begin
    Fmain.LeaveTab(Fmain.GameClient);
    Fmain.GetTabList(Fmain.GameClient);
    Close;
    Fmain.Show;
  end;
end;

procedure TFgame.Button5Click(Sender: TObject);
begin
  if Fmain.Tabing then begin
    Fmain.ReadyGame(Fmain.GameClient, not Fmain.Readying);
    Fmain.Readying := not Fmain.Readying;
  end;
end;

procedure TFgame.RzBitBtn1Click(Sender: TObject);
begin
  TButton(Sender).Visible := False;
  if Fmain.Tabing then begin
    Fmain.ReadyGame(Fmain.GameClient, not Fmain.Readying);
  end;
end;

procedure TFgame.RzBitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFgame.RzBitBtn3Click(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do begin
    FileName := '��ѡ��һ��Ҫ��Ϊ������Bmp����JpgͼƬ';
    Filter := '*.*';
    if Execute then begin
      if FileExists(FileName) then
        Image1.Picture.LoadFromFile(FileName);
      Image1.SendToBack;
    end;
  end; // with
end;

procedure TFgame.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not RzBitBtn2.Enabled then begin
    if MessageDlg('����Ϸ���˳��ǻ����𹫷ߵ�...,ȷ��Ҫ������', mtWarning, [mbYes, mbNo], 0) = Mryes then
     Fgame.GameFree;
    CanClose := True;
  end
  else begin
    CanClose := True;
  end;
end;

procedure TFgame.GameBeging(IrandomPlayerIndex: Byte);
var
  I, n: Integer;
begin
Try
  GMyGame.RandomBeginPlayer(IrandomPlayerIndex);
  //��ʼ���� ��2��
  for I := 0 to 1 do begin // Iterate                          //��ʼ����
    for n := 0 to High(GMyGame.PlayerArr) do begin // Iterate
      ShowCard(GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].InCard(GMyGame.GetOneCard),
        GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].Postion,
        GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].CurrCardCount);
      GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].PlayerInfo^.TotMoney :=
        GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].PlayerInfo^.TotMoney - 1;
      Sleep(100);
      GMyGame.NextPlayer;
    end; // for
  end; // for
Except
 Application.MessageBox('��Ϸ�����ʼ������','����');
End;  
  for I := 0 to High(GMyGame.PlayerArr) do begin // Iterate
    GMyGame.PlayerArr[i].PlayerInfo^.PassCurrGame := False; //��ʼ�� ����״̬
    ShowName(GMyGame.PlayerArr[i].Postion, GMyGame.PlayerArr[i].PlayerInfo);
  end; // for
  SHowGifTip(GetPostBelve(GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].Postion, 6)); //����������ʾ
  RxGifTip.Visible := True; //��ʾ��ʾ
  RzGroupBox1.Visible := True; //��ʾ��
  SetCurrLable(GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].PlayerInfo); //��ʾ��ǰ�û��ͶĽ�
  if TurnSelf(Fmain.PlayerIdxIntab) then //����ֵ��Լ�������ť
    SHowButtom(True);
  RzBitBtn2.Enabled := False;
  FTurnBeginTime := time;
  TurnTimer.Enabled := True;
  Refresh; //ˢ��һ�´���

end;

procedure TFgame.GameCreate;
var
  I: Integer;
  Ltep: PRPlayer;
  Lteparr: Tlist;
begin
Try
  Lteparr := TList.Create;
  for I := 0 to High(Fmain.GTabPlayerArr) do begin // Iterate
    Ltep := @Fmain.GTabPlayerArr[i];
    Lteparr.Add(Ltep);
  end; // for
  GMyGame := TTSPCard.Create(Fmain.GTabPlayerArrCount,
    [Lteparr[0], Lteparr[1], Lteparr[2], Lteparr[3]]);
  Lteparr.Free;
  GMyGame.SetPlayerPostion(Fmain.PlayerIdxIntab);
  ShowRule;
except
Application.MessageBox('��Ϸ��������������','��ù');
end;
end;

procedure TFgame.GameFree;
var
  I: Integer;
begin
  for I := CardHandle.Count - 1 downto 0 do begin // Iterate
    TReNameCard(CardHandle.Items[i]).Free;
    CardHandle.Delete(i);
  end;
  for I := 0 to High(GMyGame.PlayerArr) do // Iterate
    VisibleName(GMyGame.PlayerArr[i].Postion);
  RzGroupBox1.Visible := False;
  RzProgressBar1.Visible := False;
  RxGifTip.Visible := False;
  RxGifTip.Animate:=False;
  SHowButtom(False);
  lbCurrPlayer.Tag := 0;
  TurnTimer.Enabled := False;
  RzBitBtn1.Visible := True;
  RzBitBtn2.Enabled:=True;
  FreeAndNil(GMyGame);
end;

function TFgame.GetPostBelve(Ipostion: sPlayerPostion; ICount: Byte): TBevel;
var
  I, n: Integer;
  Ltep: string;
begin
  Result := nil;
  Ltep := inttostr(ord(Ipostion) + 1) + inttostr(ICount);
  n := strtoint(Ltep);
  for I := 0 to Fgame.ComponentCount - 1 do begin // Iterate
    if Fgame.Components[i].Tag = n then begin
      Result := Fgame.Components[i] as TBevel;
      Break;
    end;
  end; // for
end;

procedure TFgame.ShowCard(IValue: PROneCard; Ipst: sPlayerPostion; IPos: Byte);
var
  Ltep: TBevel;
  LShowCard: TReNameCard;
begin
  Ltep := GetPostBelve(Ipst, IPos);
  LShowCard := TReNameCard.Create(self);
  LShowCard.Hide;
  LshowCard.Parent := Self;
  LShowCard.Top := Ltep.Top + 8;
  LShowCard.Left := Ltep.Left + 8;
  LShowCard.Tag := Ltep.Tag;
  LShowCard.OnClick := LookValue;
  LShowCard.Suit := TCardSuit(Ord(IValue^.Kind));
  LShowCard.Value := IValue^.Value;
  LShowCard.Show;
  CardHandle.Add(LShowCard);
  if copy(inttostr(Ltep.Tag), 2, 1) = '0' then LShowCard.ShowDeck := True;
end;


procedure TFgame.LookValue(Sender: TObject);
begin
  if TReNameCard(Sender).Tag = 10 then
    TReNameCard(Sender).ShowDeck := not TReNameCard(Sender).ShowDeck;
end;

procedure TFgame.FormCreate(Sender: TObject);
begin
  CardHandle := TList.Create;
  JPGParth := ExtractFilePath(Application.ExeName) + 'CardPic\'
end;

procedure TFgame.SHowGifTip(IBevel: TBevel);
begin
  RxGifTip.Top := IBevel.Top;
  RxGifTip.Left := IBevel.Left;
end;

procedure TFgame.SHowButtom(IState: boolean);
begin
  ChoseMoney.Visible := IState;
  BTsendCard.Visible := IState;
  BtPass.Visible := IState;
  Application.ProcessMessages;
end;

function TFgame.TurnSelf(ISelfIdx: byte): boolean;
begin
  Result := False;
  if GMyGame.CurrPlayerIndex = ISelfIdx then
    Result := True;
end;

procedure TFgame.RzComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Lbuff: RCTS_Chat;
begin
  if Key = VK_RETURN then begin
    if TComboBox(Sender).Items.Add(TComboBox(Sender).Text) > 10 then
      TComboBox(Sender).Items.Delete(0);
    Lbuff.TabID := Fmain.TabID;
    Lbuff.PlayerID := Fmain.PlayerIdxIntab;
    Lbuff.Content := TComboBox(Sender).Text;
    Fmain.SendHead(Fmain.GameClient, Cmid_CTS_Chat);
    TalktoEveryBady(Fmain.GameClient, Lbuff);
    TComboBox(Sender).Text := '';
  end;
end;

procedure TFgame.RzBitBtn7Click(Sender: TObject);
begin
  RxGifTip.Animate := not RxGifTip.Animate;
end;

procedure TFgame.RzBitBtn6Click(Sender: TObject);
begin
  RxGifTip.Visible := not RxGifTip.Visible;
end;

procedure TFgame.TakeTimeBegin(Iplayer: PRplayer);
begin
  TurnTimer.Enabled := True;
  FTurnBeginTime := Time;
  RzProgressBar1.Percent := 0;
end;

procedure TFgame.SetCurrLable(Iplayer: PRplayer);
begin
  lbCurrPlayer.Caption := Format('�ֵ����<%s>������' + #13 +
    ' ������ѡ���ע��' + '��ע������' + #13 + '�������(���Գ���������^_^)' + #13
    + '��ʱ���������ƾ����Զ�����' + #13 + '��ǰ�ۼƶĽ�%dWӮ�˾�������'
    , [Iplayer^.Name, lbCurrPlayer.Tag]);
end;

function TFgame.CurrIsPassUser: boolean;
begin
  Result := GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].PlayerInfo^.PassCurrGame;
end;

procedure TFgame.TurnTimerTimer(Sender: TObject);
begin
  RzProgressBar1.Percent := SecondsBetween(time, FTurnBeginTime) * 100 div 30;
  if SecondsBetween(Time, FTurnBeginTime) > 30 then begin
    RzProgressBar1.Percent := 0;
    GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].PlayerInfo^.PassCurrGame := True;
    ShowNext; // ��ʾ��һ�û�
  end;
end;

procedure TFgame.SendCards(Ibuff: RSTC_PlayerSendCards);
begin
  ShowCard(GMyGame.PlayerArr[Ibuff.PlayerIdx].InCard(GMyGame.GetOneCard), //������һͼ
    GMyGame.PlayerArr[Ibuff.PlayerIdx].Postion, GMyGame.PlayerArr[Ibuff.PlayerIdx].CurrCardCount);
  GMyGame.PlayerArr[Ibuff.PlayerIdx].PlayerInfo^.TotMoney := GMyGame.PlayerArr[Ibuff.PlayerIdx].PlayerInfo^.TotMoney - Ibuff.Scores;
  lbCurrPlayer.Tag := lbCurrPlayer.Tag + Ibuff.Scores;
  GMyGame.LastMoney := Ibuff.Scores;
  ShowNext; //׼����һ��
end;

procedure TFgame.ShowNext;
begin
  if GMyGame.NeedCheckWin then begin
    PlayerWined(GMyGame.CheckGameWined);
  end
  else begin
    TurnTimer.Enabled := False;
    RzProgressBar1.Percent := 0;
    FTurnBeginTime := Time;
    repeat
      GMyGame.NextPlayer;
    until not CurrIsPassUser; //��һ�û�
    ChoseMoney.Text := Inttostr(GMyGame.LastMoney); //�������Ͼ�ͬ����Ǯ
    BTsendCard.Caption := '��';
    if TurnSelf(Fmain.PlayerIdxIntab) then
      SHowButtom(true); //����ֵ��Լ��ͰѰ�ť���Ƴ���
    SetCurrLable(GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].PlayerInfo); //��ʾ��ǰ�û��ͶĽ�
    SHowGifTip(GetPostBelve(GMyGame.PlayerArr[GMyGame.CurrPlayerIndex].Postion, 6)); //��ʾ��ʾ��ǰ�û�
    TurnTimer.Enabled := True;
  end;
end;

procedure TFgame.SHowName(IPost: sPlayerPostion; Iplayer: PRplayer);
begin
  case IPost of //
    sdown: begin
        LbDown.Caption := Iplayer^.Name;
        ImgDown.Picture.LoadFromFile(JPGParth + 'down.bmp');
        ImgDown.Visible:=True;
      end;
    sright: begin
        LbRight.Caption := Iplayer^.Name;
        ImgRight.Picture.LoadFromFile(JPGParth + 'right.bmp');
        ImgRight.Visible:=True;
      end;
    sup: begin
        Lbup.Caption := Iplayer^.Name;
        Imgup.Picture.LoadFromFile(JPGParth + 'up.bmp');
        Imgup.Visible:=True;
      end;
    sleft: begin
        LbLeft.Caption := Iplayer^.Name;
        imgLeft.Picture.LoadFromFile(JPGParth + 'left.bmp');
        imgLeft.Visible:=True;
      end;
  end; // case
end;

procedure TFgame.BtPassClick(Sender: TObject);
var
  Lbuff: RSTC_PlayerPass;
begin
  Fmain.SendHead(Fmain.GameClient, Cmid_STC_UserPass);
  Lbuff.TabID := Fmain.TabID;
  Lbuff.PLayerIdx := GMyGame.CurrPlayerIndex;
  Fmain.GameClient.WriteBuffer(Lbuff, sizeof(Lbuff));
end;

procedure TFgame.ChoseMoneyChange(Sender: TObject);
begin
  BTsendCard.Caption := '��ע';
end;

procedure TFgame.ChoseMoneySelect(Sender: TObject);
begin
  if Strtoint(ChoseMoney.Text) < GMyGame.LastMoney then
    Application.MessageBox('�Բ��𣬲���ѡ����ϼҸ�С�ĶĽ�,������ѡ��Ľ�', '˵��');
  ChoseMoney.Text := inttostr(GMyGame.LastMoney);
end;

procedure TFgame.BTsendCardClick(Sender: TObject);
var
  Lbuff: RSTC_PlayerSendCards;
begin
  SHowButtom(False);
  Fmain.SendHead(Fmain.GameClient, Cmid_STC_UserSendCards);
  Lbuff.TabID := Fmain.TabID;
  Lbuff.PlayerIdx := GMyGame.CurrPlayerIndex;
  Lbuff.Scores := Strtoint(ChoseMoney.text);
  Fmain.GameClient.WriteBuffer(Lbuff, Sizeof(Lbuff));
end;

procedure TFgame.ChoseMoneyKeyPress(Sender: TObject; var Key: Char);
begin
  key := #0;
end;

procedure TFgame.PlayerWined(Iidx: byte);
var
  I: Integer;
begin
  for I := 0 to CardHandle.Count - 1 do // Iterate
    if TReNameCard(CardHandle.Items[i]).ShowDeck then
      TReNameCard(CardHandle.Items[i]).ShowDeck := False;
  TurnTimer.Enabled := False;
  showmessage(Format('Ӯ�� �ǳ�: %s ID: %d',
    [GMyGame.PlayerArr[Iidx].PlayerInfo^.Name, Iidx]));
  RzBitBtn2.Visible := True;
  GMyGame.PlayerArr[Iidx].PlayerInfo^.TotMoney :=
    GMyGame.PlayerArr[Iidx].PlayerInfo^.TotMoney + lbCurrPlayer.Tag;
  AddMoney(Fmain.GameClient);
  GameFree;
end;

procedure TFgame.RzBitBtn4Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Fgame.ComponentCount - 1 do // Iterate
    if Fgame.Components[i] is TBevel then
      (Fgame.Components[i] as TBevel).Visible := not (Fgame.Components[i] as TBevel).Visible;
end;

procedure TFgame.Timer1Timer(Sender: TObject);
begin
  RzProgressBar1.Percent := RzProgressBar1.Percent + 5;
end;

procedure TFgame.TalktoEveryBady(Icon: TIdTcpClient; Ibuff: RCTS_Chat);
begin
  Icon.WriteBuffer(Ibuff, sizeof(Ibuff));
end;

procedure TFgame.AddShow(Icontent: string);
begin
  if Showmemo.Lines.Add(Icontent) > 500 then Showmemo.Clear;
  SendMessage(Showmemo.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TFgame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Fmain.Tabing then begin
    Fmain.LeaveTab(Fmain.GameClient);
  end;
end;

procedure TFgame.AddMoney(ICon: TIdTCPClient);
var
  I: Integer;
  Lbuff: RCTS_UseWin;
begin
  for I := 0 to high(GMyGame.PlayerArr) - 1 do    // Iterate
    GMyGame.PlayerArr[i].PlayerInfo^.ReadGame:=False;
  Fmain.SendHead(Fmain.GameClient, Cmid_CTS_Userwin);
  Lbuff.TabId := Fmain.TabID;
  Lbuff.PlayIdx := Fmain.PlayerIdxIntab;
  Lbuff.AddScore := lbCurrPlayer.Tag;
  LbCurrPlayer.Tag := 0;
  ICon.WriteBuffer(Lbuff, Sizeof(Lbuff));
end;

procedure TFgame.VisibleName(Ipost: sPlayerPostion);
begin
  case IPost of //
    sdown: begin
        LbDown.Caption := '';
        ImgDown.Visible:=False;
      end;
    sright: begin
        LbRight.Caption := '';
        ImgRight.Visible:=False;
      end;
    sup: begin
        Lbup.Caption := '';
        Imgup.Visible:=False;
      end;
    sleft: begin
        LbLeft.Caption := '';
        imgLeft.Visible:=False;
      end;
  end; // case
end;

procedure TFgame.ShowRule;
var
  S: Pchar;
begin
  S := Pchar('�ȽϹ���: ͬ��˳>��֧(4��ͬ���Ĵ�1��������)>��«(3��ͬ����һ��)>ͬ��>˳��>3��>2��>����>ɢ��' +
    '�����ͬ����������Ƚϸ���������');
  AddShow(S);
end;

end.

