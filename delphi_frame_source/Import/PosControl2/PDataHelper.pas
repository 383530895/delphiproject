unit PDataHelper;

(*************************************

      Data Help Utilities

        Create By HYL

**************************************)

interface

USES SysUtils,Classes,Controls,Forms;

type
  EDataHelper = class(Exception);
  TCustomFormClass = class of TCustomForm;

  {TCustomDataHelper }
  TCustomDataHelper = class;

  {TDataHelpManager �������е�TDataHelper}
  TDataHelpManager = class
  private
    class function AddDataHelper(DataHelper: TCustomDataHelper): boolean;
    class function RemoveDataHelper(DataHelper: TCustomDataHelper): boolean;
  public
    class function FindHelper(const HelpStr :string):TCustomDataHelper;
    class function ExecuteHelp(Sender : TObject;  //Ҫ�����ݰ����Ķ���
                const HelpStr :string;      //Ψһ��־���ݰ������ַ���
                var ATextValue : string;     //����
                AValues : TList;           //��������
                var DataHelper : TCustomDataHelper)       //�����ṩ���ݰ�����ʵ�ʶ���
                : integer;                  //�������ݰ�����ִ�����,0��ʾû���ҵ�DataHelper

  end;

  TCustomDataHelper = class(TComponent)
  private
    FHelpString: string;
    FTextValue: string;
    FExecResult: integer;
    FValues: TList;
    FHelpSender : TObject;
  public
    property    HelpSender : TObject read FHelpSender write FHelpSender;
    property    TextValue : string read FTextValue write FTextValue; //Ϊ��������ֵʹ��
    property    ExecResult : integer read FExecResult write FExecResult; //��¼Execute�ķ���ֵ
    property    Values : TList read FValues write FValues;
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    //property    HelpObject : TObject read FHelpObject;
    function    HelpObject : TObject; virtual; abstract; //���ش������ݰ�����ʵ�ʶ���
    property    HelpString : string read FHelpString write FHelpString;
    function    Execute(Sender : TObject;   //Ҫ�����ݰ����Ķ���
                    var ATextValue : string; //����
                    AValues : TList          //��������
                    ) : integer;               //�������ݰ�����ִ�����
                    virtual; abstract;
  end;

  TDataHelpEvent = procedure (Helper : TCustomDataHelper)  of object;
  {���FormClass<>nil:
    ִ��Executeʱ������FormClass����HelpForm��ģʽִ���Ժ��ͷ�HelpForm
   ����FHelpForm<>nil
    ִ��Executeʱ��ģʽִ��HelpForm����destroyʱ����OwnFormȷ���Ƿ��ͷ�HelpForm
  }
  TFormDataHelper = class(TCustomDataHelper)
  private
    FBeforeHelp: TDataHelpEvent;
    FAfterHelp: TDataHelpEvent;
  protected
    FFormClass : TCustomFormClass;
    FOwnForm: boolean;
    FHelpForm:  TCustomForm;
    procedure   DoBeforeHelp; virtual;
    procedure   DoAfterHelp; virtual;
  public
    constructor CreateByForm(AOwner : TComponent; const AHelpString : string; AForm : TCustomForm; AOwnForm : boolean);
    constructor CreateByClass(AOwner : TComponent; const AHelpString : string; AFormClass : TCustomFormClass);
    property    HelpForm : TCustomForm read FHelpForm write FHelpForm;
    property    OwnForm : boolean read FOwnForm;
    property    FormClass : TCustomFormClass read FFormClass write FFormClass;
    Destructor  Destroy;override;
    //property    HelpObject : TObject read FHelpObject;
    function    HelpObject : TObject; override;
    function    Execute(Sender : TObject;   //Ҫ�����ݰ����Ķ���
                    var ATextValue : string; //����
                    AValues : TList          //��������
                    ): integer;               //�������ݰ�����ִ�����
                    override;
    property    BeforeHelp : TDataHelpEvent read FBeforeHelp write FBeforeHelp;
    property    AfterHelp : TDataHelpEvent read FAfterHelp write FAfterHelp;
  published

  end;

  TSimpleDataHelper = class(TFormDataHelper)
  private

  protected

  public
    constructor Create(AOwner : TComponent); override;
  published
    property    HelpString;
    property    BeforeHelp;
    property    AfterHelp;
  end;

  //you must call Set FormClass or HelpForm before Execute
  TDynamicDataHelper = class(TFormDataHelper)
  private
    //FOnCreate: TNotifyEvent;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property    HelpString;
    property    BeforeHelp;
    property    AfterHelp;
    //property    OnCreate : TNotifyEvent read FOnCreate write FOnCreate;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples',[TSimpleDataHelper,TDynamicDataHelper]);
end;

{ TFormDataHelper }

procedure TFormDataHelper.DoAfterHelp;
begin
  if assigned(FAfterHelp) then
    FAfterHelp(self);
end;

procedure TFormDataHelper.DoBeforeHelp;
begin
  if assigned(FBeforeHelp) then
    FBeforeHelp(self);
end;

constructor TFormDataHelper.CreateByClass(AOwner : TComponent;
  const AHelpString: string;
  AFormClass: TCustomFormClass);
begin
  //assert(AFormClass<>nil);
  inherited Create(AOwner);
  //inherited Create(AHelpString);
  FHelpString := AHelpString;
  FFormClass:=AFormClass;
  FHelpForm:=nil;
  FOwnForm:=true;
end;

constructor TFormDataHelper.CreateByForm(AOwner : TComponent;
  const AHelpString: string;
  AForm: TCustomForm; AOwnForm: boolean);
begin
  assert(AForm<>nil);
  inherited Create(AOwner);
  //inherited Create(AHelpString);
  FHelpString := AHelpString;
  FFormClass:=nil;
  FHelpForm:=AForm;
  FOwnForm:=AOwnForm;
end;

destructor TFormDataHelper.Destroy;
begin
  if (FFormClass=nil) and (FOwnForm) then
    FHelpForm.free;
  inherited Destroy;
end;

function TFormDataHelper.Execute(Sender: TObject;
  var ATextValue : string;
  AValues : TList          //��������
  ): integer;
begin
  FHelpSender := Sender;
  FTextValue:=ATextValue;
  FValues := AValues;
  if FFormClass<>nil then
    try
      FHelpForm := FFormClass.Create(nil);
      DoBeforeHelp;
      result:=FHelpForm.ShowModal;
      ExecResult := result;
      DoAfterHelp;
    finally
      FHelpForm.free;
    end
  else
  begin
    DoBeforeHelp;
    result:=FHelpForm.ShowModal;
    ExecResult := result;
    DoAfterHelp;
  end;
  ATextValue := FTextValue;
end;

function TFormDataHelper.HelpObject: TObject;
begin
  result := FHelpForm;
end;

{ TSimpleDataHelper }

constructor TSimpleDataHelper.Create(AOwner: TComponent);
begin
  assert((AOwner<>nil)and(AOwner is TCustomForm));
  inherited CreateByForm(AOwner,AOwner.Name,AOwner as TCustomForm,false);
end;

{ TCustomDataHelper }

var
  DataHelpers : TList;

constructor TCustomDataHelper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not TDataHelpManager.AddDataHelper(self) then
    raise EDataHelper.Create('Cannot register Data helper');
end;

destructor TCustomDataHelper.Destroy;
begin
  TDataHelpManager.RemoveDataHelper(self);
  inherited Destroy;
end;

{ TDataHelpManager }

class function TDataHelpManager.AddDataHelper(
  DataHelper: TCustomDataHelper): boolean;
begin
  assert(DataHelper<>nil);
  result:=FindHelper(DataHelper.HelpString)=nil;
  if result then
    DataHelpers.Add(DataHelper);
end;

class function TDataHelpManager.RemoveDataHelper(
  DataHelper: TCustomDataHelper): boolean;
begin
  result := DataHelpers.Remove(DataHelper)>=0;
end;

class function TDataHelpManager.ExecuteHelp(Sender: TObject;
  const HelpStr: string;
  var ATextValue : string;
  AValues : TList;
  var DataHelper: TCustomDataHelper): integer;
begin
  DataHelper := FindHelper(HelpStr);
  if DataHelper<>nil then
    result:=DataHelper.Execute(sender,ATextValue,AValues)
  else
    result:=0;
end;

class function TDataHelpManager.FindHelper(
  const HelpStr: string): TCustomDataHelper;
var
  i : integer;
begin
  if HelpStr='' then
    result:=nil
  else
  begin
    for i:=0 to DataHelpers.Count-1 do
      if CompareText(
            TCustomDataHelper(DataHelpers[i]).HelpString,
            HelpStr)=0 then
      begin
        result:=TCustomDataHelper(DataHelpers[i]);
        exit;
      end;
    result:=nil;
  end;
end;

{ TDynamicDataHelper }

constructor TDynamicDataHelper.Create(AOwner: TComponent);
begin
  inherited CreateByClass(AOwner,'',nil);
  {if assigned(FOnCreate) then
    FOnCreate(self);}
end;


initialization
  DataHelpers:=TList.Create;

finalization
  DataHelpers.free;

end.
