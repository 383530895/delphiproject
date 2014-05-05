unit PcardClass;

interface
uses SysUtils, Contnrs, Dialogs, Classes, PGmProtect;

type
  SKind = (Fan, Xi, Red, Black, BigSupper, SmallSupper); //4�ֻ�ɫ+���+С��
  SWinCardKind = (SWCKsan, SWCKdui, SWCKtwodui, SWCKTree, SWCKsun, SWCKsamecolor,
    SWCKTreeandTwo, SWCKfourandone, SWCKsameCLSun);
  PRoneCard = ^ROneCard;
  ROneCard = packed record //�ƵĽṹ
    Kind: SKind;
    Value: Integer;
  end;
  TBaseCard = class
  private
    FtotCard: Byte; //������
    FCardArr: array of ROneCard; //һ�˿�����
    FCardStack: TStack; //��ǰ�ƾ�
    FCurrCardCount: Byte; //��ǰ������
    FRandomarr: array of Byte;
  public
    property TotCardCounts: byte read FtotCard write FtotCard;
    property CardCount: Byte read FCurrCardCount write FCurrCardCount; //��ǰ������
    procedure RandomArr(Icount: Byte); //ϴ����
    procedure CardStackPop; //��ϴ������д�����ƾ�
    function GetRandomArrEntry: pointer;
    function GetRandom(Ilength: byte): Pointer; //���ú������С����ⲿ��ȡ����
    procedure MakeCards(INeesSupper: boolean = True; ILoopCount: byte = 1); //�����ƾ� ����ѡ���Ƿ�Ҫ��С�� �� ����������
    function GetOneCard: PROneCard; //��һ����
    function TralsateCard(IOneCard: ROneCard): string; //ת���Ƶı�����ʽ
    function ResultCall(ICards: TList): string; //����һ����
    constructor Create;
    destructor Destory;
  end;
  sPlayerPostion = (sdown, sright, sup, sleft);
  TPlayer = class //�����
  private

    FCardArr: TList; //������ϵ���
    FPostion: sPlayerPostion; //��ҵ�λ��
    function GetCurrCardCount: Byte;
  public
    PlayerInfo: PRplayer; //��ҵ���Ϣ
    property CurrCardCount: Byte read GetCurrCardCount default 0; //���������
    property Cards: TList read FCardArr write FCardArr; //�������
    property Postion: sPlayerPostion read FPostion write FPostion; //��ҵ�λ��
    function InCard(Icard: PROneCard): PROneCard; //����
    function OutCard(Iindex: Integer): PROneCard; //����
    constructor Create(IInfo: PRplayer);
    destructor Destory;
  end;
  TZSYCard = class(TBaseCard) //������
  private
    FCurrPlayerIndex: Byte; // ��¼��ǰӦ�ó��Ƶ��û�
    FLastId: Byte; //��һ���û�
    FLastCards: TList; //���һ�ֵ��ƾ�
    FCurrCards: Tlist; //��ǰ���ƾ�
  protected
    property LastID: byte read FLastId write FLastId; //��һ���û�
    property LastCards: TList read FLastCards write FLastCards; //���һ�ֵ��ƾ�
  public
    property CurrCards: TList read FCurrCards write FCurrCards;
    property CurrSendPlayerIdx: Byte read FCurrPlayerIndex write FCurrPlayerIndex; //��¼��ǰӦ�ó��Ƶ��û�
    procedure NextPlayer;
    function CanPlayThisCard(IPlayer: TPlayer; IcardS: TList): boolean; //�Ƿ���Գ������
    function CheckWined(IPlayer: TPlayer): boolean; //����Ƿ��Ѿ�Ӯ��
    function RandomBeginPlayer(IplayerCount: Byte): Byte; //���һ����ʼ���Ƶ��û�
    constructor Create;
    destructor Destory;
  end;
  TTSPCard = class(TBaseCard) //���
  private
    FCurrPlayerIndex: Byte; // ��¼��ǰӦ�ó��Ƶ��û�
    FLastMoney: Integer; //��һ�ֵĶ�ע
    function CaseScKind(Icards: TList): SWinCardKind; //�����Ƶ�����
  public
    PlayerArr: array of TPlayer;
    property CurrPlayerIndex: Byte read FCurrPlayerIndex write FCurrPlayerIndex;
    property LastMoney: Integer read FLastMoney write FLastMoney default 0;
    procedure NextPlayer;
    function CheckGameWined: Byte; //�����Ϸ��Ӯ��
    function NeedCheckWin: boolean; //��һ�û�֮ǰ�ж��Ƿ���Ҫ�����Ӯ
    function CheckOutWined: Byte; //�û��˳���ʱ�����Ƿ�Ӯ�� ���Ӯ�˷���������
    function RandomBeginPlayer(IplayerCount: Byte): Byte; //���һ����ʼ���Ƶ��û�
    procedure SetPlayerPostion(IcurrIdx: Byte); //���ݵ�ǰ�û����� �趨λ��
    constructor Create(IPlayerCount: Byte; Iarr: array of PRplayer);
    destructor Destory;
  end;

implementation

{ TCard }

procedure TBaseCard.CardStackPop;
var
  I: Integer;
begin
  for I := 0 to Length(FRandomarr) - 1 do begin // Iterate
    FCardStack.Push(@FCardArr[FRandomarr[i]]);
  end; // for
end;

constructor TBaseCard.Create;
begin
  FCardStack := TStack.Create;
end;

destructor TBaseCard.Destory;
begin
  FCardStack.Free;
  FCardArr := nil;
  inherited;
end;

function TBaseCard.GetOneCard: PROneCard;
begin
  Dec(FCurrCardCount);
  Result := PROneCard(FCardStack.Pop);
end;

function TBaseCard.GetRandom(Ilength: byte): Pointer;
begin
  SetLength(FRandomarr, Ilength);
  Result := Pointer(FRandomarr);
end;

function TBaseCard.GetRandomArrEntry: pointer;
begin
  Result := @FRandomarr;
end;

procedure TBaseCard.MakeCards(INeesSupper: boolean = True; ILoopCount: byte = 1);
var
  j, L, M: Integer;
  LKind: SKind;
begin
  FtotCard := 0;
  for M := 1 to ILoopCount do begin // Iterate
    for L := 0 to 3 do begin // Iterate
      LKind := Skind(L);
      for J := 1 to 13 do begin // Iterate
        Inc(FtotCard);
        SetLength(FCardArr, FtotCard);
        FCardArr[FtotCard - 1].Kind := LKind;
        FCardArr[FtotCard - 1].Value := J;
      end; // for
    end; // for
    if INeesSupper then begin
      Inc(FtotCard, 1);
      SetLength(FCardArr, FtotCard);
      FCardArr[FtotCard - 1].Kind := BigSupper;
      FCardArr[FtotCard - 1].Value := 17;
      Inc(FtotCard, 1);
      SetLength(FCardArr, FtotCard);
      FCardArr[FtotCard - 1].Kind := SmallSupper;
      FCardArr[FtotCard - 1].Value := 16;
    end;
  end; // for
end;

procedure TBaseCard.RandomArr(Icount: Byte);
var
  i, X: Integer;
begin
  Randomize;
  SetLength(FRandomarr, Icount);
  for I := 0 to Icount do begin // Iterate
    repeat
      x := Random(Icount);
    until FRandomarr[x] = 0;
    FRandomarr[X] := i;
  end; // for
  FCurrCardCount := Length(FCardArr);
end;

function TBaseCard.ResultCall(ICards: TList): string;
var
  I: Integer;
begin
  for I := 0 to ICards.Count - 1 do begin // Iterate
    Result := Result + '<' + inttostr(i) + '>' + TralsateCard(PROneCard(ICards.Items[i])^);
  end; // for
end;

function TBaseCard.TralsateCard(IOneCard: ROneCard): string;
var
  LTep: string;
begin
  case IOneCard.Kind of //
    Black: ltep := '����';
    Red: Ltep := '����';
    Xi: LTep := '÷��';
    Fan: Ltep := '����';
    BigSupper: LTep := '���';
    SmallSupper: LTep := 'С��';
  end; // case
  case IOneCard.Value of //
    1: LTep := LTep + 'A';
    2: LTep := LTep + '2';
    3: LTep := LTep + '3';
    4: LTep := LTep + '4';
    5: LTep := LTep + '5';
    6: LTep := LTep + '6';
    7: LTep := LTep + '7';
    8: LTep := LTep + '8';
    9: LTep := LTep + '9';
    10: LTep := LTep + '10';
    11: LTep := LTep + 'J';
    12: LTep := LTep + 'Q';
    13: LTep := LTep + 'K';
  end; // case
  Result := LTep;
end;

{ TZSYCard }

procedure TZSYCard.NextPlayer;
begin
  FCurrPlayerIndex := FCurrPlayerIndex + 1;
  if FCurrPlayerIndex > 3 then FCurrPlayerIndex := 0;
end;

function TZSYCard.CanPlayThisCard(IPlayer: TPlayer; IcardS: TList): boolean;
begin
  Result := False;
end;

function TZSYCard.CheckWinEd(IPlayer: TPlayer): boolean;
begin
  Result := IPlayer.CurrCardCount = 0; //�ж��Ƿ�Ӯ��
end;

constructor TZSYCard.Create;
begin
  inherited Create;
  FLastCards := TList.Create;
  FCurrCards := TList.Create;
end;

destructor TZSYCard.Destory;
var
  I: Integer;
begin
  for I := 0 to FLastCards.Count - 1 do begin // Iterate
    Dispose(FLastCards.Items[i]);
  end; // for
  FLastCards.Free;
  FCurrCards.free;
end;

function TZSYCard.RandomBeginPlayer(IplayerCount: Byte): Byte;
begin
  Randomize;
  FCurrPlayerIndex := random(IplayerCount);
  Result := FCurrPlayerIndex;
end;

{ TPlayer }

constructor TPlayer.Create(IInfo: PRplayer);
begin
  PlayerInfo := IInfo;
  FCardArr := TList.Create;
end;

destructor TPlayer.Destory;
begin
  FCardArr.Free;
end;

function TPlayer.GetCurrCardCount: Byte;
begin
  Result := Cards.Count;
end;

function TPlayer.InCard(Icard: PROneCard): PROneCard; //����
begin
  FCardArr.Add(Icard);
  Result := Icard;
end;

function TPlayer.OutCard(Iindex: Integer): PROneCard; //����
begin
  Result := Cards.Items[Iindex];
  Cards.Delete(Iindex);
end;

{ TTSPCard }

function composit(Ilist: TList): TList; //������
var
  Lnum, Lnt: Integer;
  Lmin: Integer;
begin
  Result := TList.Create;
  Lnum := 0;
  Lmin := PRoneCard(Ilist.Items[0]).Value; //
  Result.Add(Ilist.Items[0]);
  while Lnum < Ilist.Count - 1 do begin
    inc(Lnum);
    if PRoneCard(Ilist.Items[Lnum]).Value = 1 then
      PRoneCard(Ilist.Items[Lnum]).Value := 14;
    if PRoneCard(Ilist.Items[Lnum]).Value <= Lmin then begin
      Lmin := pRoneCard(Ilist.Items[Lnum]).Value;
      Result.Insert(0, Ilist.Items[Lnum]);
    end
    else begin
      Lnt := 0;
      repeat
        if pRoneCard(Ilist.Items[Lnum]).Value >
          PRoneCard(Result.Items[Lnt]).Value then
          Inc(Lnt)
        else Break;
      until Lnt = Result.Count;
      Result.Insert(Lnt, Ilist.Items[Lnum]);
    end;
  end;
  Ilist.Free;
end;

function SameCardCount(Ivalue: Byte; Icards: TList): Byte; //����ͬ��ֵ������
var
  I: Integer;
begin
  result := 0;
  for I := 0 to Icards.Count - 1 do begin // Iterate
    if Ivalue = Pronecard(Icards.Items[i]).Value then inc(Result);
  end; // for
end;

function SameCardMaxCount(icards: TList): Byte; //����ͬ����������
var
  i: Integer;
  Ltep: Byte;
  Lthen: Byte;
begin
  Ltep := Pronecard(icards.Items[0]).Value;
  Result := SameCardCount(Ltep, icards);
  for i := 1 to icards.Count - 1 do begin
    if Ltep = Pronecard(icards.Items[i]).Value then Continue //�����ͬ�����ƾ�����
    else begin
      Ltep := Pronecard(icards.Items[i]).Value; //ȡ�ò�ֵͬ
        Lthen := SameCardCount(Ltep, icards); //��ȡ����
      if Lthen > Result then Result := Lthen; //��������
    end;
  end;
end;

function IsSameColor(Icards: TList): Boolean; //�����Ƿ���ͬ��
var
  I: Integer;
  Ltep: SKind;
begin
  result := True;
  Ltep := Pronecard(Icards.Items[0]).Kind;
  for I := 1 to Icards.Count - 1 do // Iterate
    if Ltep <> Pronecard(Icards.Items[i]).Kind then begin
      Result := False;
      Break;
    end;
end;

function IsSun(Icards: TList): Boolean; //�Ƿ���˳��
var
  I: Integer;
  Ltep: Byte;
begin
  result := True;
  Ltep := Pronecard(Icards.Items[0]).Value;
  for I := 1 to Icards.Count - 1 do // Iterate
    if Ltep + 1 <> Pronecard(Icards.Items[i]).Value then begin
      Result := False;
      Break;
    end;
end;

function GetMaxvalue(Icard: Tlist): Byte; //��ȡ���ֵ
begin
  Result := Pronecard(Icard.Items[Icard.Count-1]).Value; //��Ϊ�Ѿ��Ź������������һ�������
end;

function GetMaxColor(Ivalue:byte;Icard: Tlist): SKind;
var
  I: Integer;
begin
  result := Pronecard(Icard.Items[0]).Kind;
  for I := 0 to Icard.Count - 1 do begin // Iterate
    If Ivalue=Pronecard(Icard.Items[i]).Value Then
    if ord(Pronecard(Icard.Items[i]).Kind) > ord(Result) then
      Result := Pronecard(Icard.Items[i]).Kind;
  end; // for
end;

Function GetMinCount(Icard:TList):Byte;//��ȡ��С������
Var
  I: Integer;
  n:byte;
Begin
  n :=SameCardCount(Pronecard(Icard.Items[0]).Value,Icard);
  For I := 1 To Icard.Count - 1 Do Begin    // Iterate
    If n<SameCardCount(Pronecard(Icard.Items[i]).Value,Icard) Then
     n:=SameCardCount(Pronecard(Icard.Items[i]).Value,Icard);
  End;    // for
  Result:=n;
End;

function TTSPCard.CaseScKind(Icards: TList): SWinCardKind;
begin
  if IsSameColor(Icards) then begin
    if IsSun(Icards) then
      Result := SWCKsameCLSun
    else Result := SWCKsamecolor;
  end
  else if SameCardMaxCount(Icards) = 4 then Result := SWCKfourandone
  else if (SameCardMaxCount(Icards) = 3) then begin
    if GetMinCount(Icards) = 2 then Result := SWCKTreeandTwo
    else Result := SWCKTree
  end
  else if SameCardMaxCount(Icards) = 2 then begin
    if GetMinCount(Icards) = 2 then
      Result := SWCKtwodui
    else Result := SWCKdui
  end
  else Result := SWCKsan;
end;

function TTSPCard.CheckGameWined: Byte;
Var
  I,x,n: Integer;
  Ltep,Lnext:SWinCardKind;
  LmaxOne,LmaxTwo:Byte;
begin
  X:=0;
  For I := 0 To length(PlayerArr) - 1 Do Begin    // Iterate
    If PlayerArr[i].PlayerInfo^.PassCurrGame Then Continue
    Else x:=i;
  End;    // for
  Result:=x;
  n:=x;
  PlayerArr[X].FCardArr:=composit(PlayerArr[X].FCardArr);
  Ltep:=CaseScKind(PlayerArr[X].FCardArr);
  For I := n+1 To length(PlayerArr) - 1 Do Begin    // Iterate
    PlayerArr[i].FCardArr:=composit(PlayerArr[i].FCardArr);
    Lnext:=CaseScKind(PlayerArr[i].FCardArr);
    If Ltep=Lnext Then Begin //�����ͬ������
      LmaxOne:=GetMaxvalue(PlayerArr[i].FCardArr);
      LmaxTwo:=GetMaxvalue(PlayerArr[X].FCardArr);
      if LmaxOne>LmaxTwo then begin
         Result:=i;
         x:=i;
      end
      Else Begin
        If LmaxOne=LmaxTwo Then Begin
          If Ord(GetMaxColor(LmaxOne,PlayerArr[i].FCardArr))>ord(GetMaxColor(LmaxTwo,PlayerArr[X].FCardArr)) Then
           Result:=i;
           x:=i;
        End;
      End;
    End;
  End;    // for
end;

function TTSPCard.CheckOutWined: Byte;
var
  I, N: Integer;
  Cur: Byte;
begin
  Result := 250;
  Cur:=0;
  n := 0;
  for I := 0 to High(PlayerArr) do begin // Iterate
    if PlayerArr[i].PlayerInfo^.PassCurrGame then inc(n)
    else Cur := i;
  end; // for
  if n = 3 then Result := Cur;
end;


constructor TTSPCard.Create(IPlayerCount: Byte; Iarr: array of PRplayer);
var
  I: Integer;
begin
  inherited Create;
  SetLength(PlayerArr, IPlayerCount);
  for I := 0 to IPlayerCount - 1 do begin // Iterate
    PlayerArr[i] := TPlayer.Create(Iarr[i]);
  end; // for

end;

destructor TTSPCard.Destory;
var
  I: Integer;
begin
  for I := 0 to Length(PlayerArr) - 1 do begin // Iterate
    PlayerArr[i].Free;
  end; // for
end;

function TTSPCard.NeedCheckWin: boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to High(PlayerArr) do begin // Iterate
    if PlayerArr[i].PlayerInfo^.PassCurrGame then Continue;
    if PlayerArr[i].CurrCardCount <> 5 then begin
      Result := False;
      Break;
    end;
  end; // for
end;

procedure TTSPCard.NextPlayer;
begin
  FCurrPlayerIndex := FCurrPlayerIndex + 1;
  if FCurrPlayerIndex > 3 then FCurrPlayerIndex := 0;
end;

function TTSPCard.RandomBeginPlayer(IplayerCount: Byte): Byte;
begin
  FCurrPlayerIndex := IplayerCount;
  Result := FCurrPlayerIndex;
end;

procedure TTSPCard.SetPlayerPostion(IcurrIdx: Byte);
var
  I, n, x: Integer;
begin
  for I := 0 to Length(PlayerArr) - 1 do begin // Iterate //��ȡ��ʼ�������
    if PlayerArr[i].PlayerInfo.ID = IcurrIdx then
      break;
  end; // for
  x := i;
  n := 0;
  repeat
    PlayerArr[x].Postion := sPlayerPostion(n); //����λ��
    inc(n); //����λ������
    inc(x); //��һ����
    if X > high(Playerarr) then X := 0; //��������������ƾʹ�ͷ
  until n > 3; //���������λ�þ��Ƴ�
end;

end.

