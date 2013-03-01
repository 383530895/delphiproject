unit MPDBs;

{ ����;���ݿ�״̬�����
}

interface

uses Windows, Messages, SysUtils, Classes, Graphics,
	Controls, Forms, Dialogs,DB,DBTables;

type
	TDBInteractState = (
  	isInactive, 	// 	�ǻ״̬
  	isBrowse,   	//  ���
    isUpdate,				//	�༭(�޸�)
    isInsert,			//	����(����)
    isQuery);			//	��ѯ(����)
{ ����Ԫ��
		���� : �л�����(���,�༭,����,��ѯ)
    ��� :
    �༭ : 	ȷ���޸� Update
    				ȡ��     CancelUpdate
    ���� : 	ȷ�ϲ��� Insert
    				ȡ��     CancelInsert
    ��ѯ : 	��ʼ��ѯ Query
    				ȡ��     CancelQuery
}
  TMulitState = class(TComponent)
  private
    FState: TDBInteractState;
    function 	GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetState(const Value: TDBInteractState);
  protected
    // �ύһ���������
    function 	InsertItem : boolean; virtual;
    // �ύһ���޸Ĳ���
    function 	UpdateItem : boolean; virtual;
    // �ύһ����ѯ����
    function 	QueryItems : boolean; virtual;
    // ��״̬�����仯ʱ,������
    procedure StateChanged(Old,New : TDBInteractState); virtual;
    // �������״̬ʱ,������
    procedure DoEnterBrowse;	virtual;
    // �������״̬ʱ,������
    procedure DoEnterInsert;	virtual;
    // �������״̬ʱ,������
    procedure DoEnterUpdate;	virtual;
    // �����ѯ״̬ʱ,������
    procedure DoEnterQuery;	virtual;
    // �˳����״̬ʱ,������
    procedure DoExitBrowse;	virtual;
    // �˳�����״̬ʱ,������
    procedure DoExitInsert;	virtual;
    // �˳�����״̬ʱ,������
    procedure DoExitUpdate;	virtual;
    // �˳���ѯ״̬ʱ,������
    procedure DoExitQuery;	virtual;
  public
    // �������״̬
    procedure EnterBrowse;	virtual;
    // �������״̬
    procedure EnterInsert;	virtual;
    // �������״̬
    procedure EnterUpdate;	virtual;
    // �����ѯ״̬
    procedure EnterQuery;	virtual;
    // �˳����״̬
    procedure ExitBrowse;	virtual;
    // �˳�����״̬
    procedure ExitInsert;	virtual;
    // �˳�����״̬
    procedure ExitUpdate;	virtual;
    // �˳���ѯ״̬
    procedure ExitQuery;	virtual;
  published
  	property 	DataSource : TDataSource
    						read GetDataSource write SetDataSource;
    property 	State : TDBInteractState
    						read FState write SetState;
  end;

implementation

{ TMulitState }

procedure TMulitState.EnterBrowse;
begin
  State := isBrowse;
end;

procedure TMulitState.EnterInsert;
begin
  State := isInsert;
end;

procedure TMulitState.EnterQuery;
begin
  State := isQuery;
end;

procedure TMulitState.EnterUpdate;
begin
  State := isUpdate;
end;

procedure TMulitState.ExitBrowse;
begin
  // nothing
end;

procedure TMulitState.ExitInsert;
begin
  EnterBrowse;
end;

procedure TMulitState.ExitQuery;
begin
  EnterBrowse;
end;

procedure TMulitState.ExitUpdate;
begin
  EnterBrowse;
end;

procedure TMulitState.DoEnterBrowse;
begin

end;

procedure TMulitState.DoEnterInsert;
begin

end;

procedure TMulitState.DoEnterQuery;
begin

end;

procedure TMulitState.DoEnterUpdate;
begin

end;

procedure TMulitState.DoExitBrowse;
begin

end;

procedure TMulitState.DoExitInsert;
begin

end;

procedure TMulitState.DoExitQuery;
begin

end;

procedure TMulitState.DoExitUpdate;
begin

end;



function TMulitState.GetDataSource: TDataSource;
begin

end;

function TMulitState.InsertItem: boolean;
begin

end;

function TMulitState.QueryItems: boolean;
begin

end;

procedure TMulitState.SetDataSource(const Value: TDataSource);
begin

end;

procedure TMulitState.SetState(const Value: TDBInteractState);
begin
  if FState <> Value then
  begin
    StateChanged(FState,Value);
    //FState := Value;
  end;
end;

procedure TMulitState.StateChanged(Old, New: TDBInteractState);
begin
  case Old of
    isBrowse : 	DoExitBrowse;
    isUpdate : 	DoExitUpdate;
    isInsert : 	DoExitInsert;
    isQuery  :  DoExitQuery;
  end;
  FState := New;
  case New of
  	isBrowse : 	DoEnterBrowse;
    isUpdate : 	DoEnterUpdate;
    isInsert : 	DoEnterInsert;
    isQuery  :  DoEnterQuery;
  end;
end;

function TMulitState.UpdateItem: boolean;
begin

end;

end.
