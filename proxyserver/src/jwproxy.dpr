program jwproxy;

uses
    Forms,
    main in 'main.pas' {Form1};

{$R *.RES}

begin
    Application.Initialize;
    Application.Title := '��ʹ��������';
    Application.CreateForm(TForm1, Form1);
    Application.Run;
end.

