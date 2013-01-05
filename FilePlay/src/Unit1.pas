unit Unit1;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, CheckLst, Menus, OleCtnrs, ExtCtrls, MPlayer,
    OleServer, PowerPointXP, OleCtrls, WMPLib_TLB, RzPanel, RzTabs, RzSplit;

type
    TForm1 = class(TForm)
        OpenDialog1: TOpenDialog;
        PopupMenu1: TPopupMenu;
        N1: TMenuItem;
        Panel1: TPanel;
        Panel2: TPanel;
        Timer1: TTimer;
        PowerPointApplication1: TPowerPointApplication;
        WindowsMediaPlayer1: TWindowsMediaPlayer;
        RzPageControl1: TRzPageControl;
        TabSheet1: TRzTabSheet;
        TabSheet2: TRzTabSheet;
        TabSheet3: TRzTabSheet;
        TabSheet4: TRzTabSheet;
        TabSheet5: TRzTabSheet;
        RzPanel1: TRzPanel;
        Label1: TLabel;
        lblHint: TLabel;
        btnPlay: TButton;
        btnPause: TButton;
        btnStop: TButton;
        MediaPlayer1: TMediaPlayer;
        RzGroupBox1: TRzGroupBox;
        btnSelect: TButton;
        CheckListBox1: TCheckListBox;
        Splitter1: TSplitter;
        Image1: TImage;
        procedure btnSelectClick(Sender: TObject);
        procedure btnPlayClick(Sender: TObject);
        procedure N1Click(Sender: TObject);
        procedure CheckListBox1DblClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure btnPauseClick(Sender: TObject);
        procedure btnStopClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        procedure playFile();
    end;

    TTaskThread = class(TThread)
    private
        FFinished: boolean;
        FFilename: string;
        FExecuteTime: TLabel;
        procedure DoOpenFile;
    public
        procedure Execute; override;
        constructor Create(filename: string; executeTime: TLabel);
    end;

procedure SearchFile(path: string);
procedure EnumFileInQueue(path: PChar; sFileExt: string; fileList: TStringList);


var
    Form1: TForm1;
    task: TTaskThread;
    taskPos: integer;
    fileExt: string;
implementation

uses filectrl, Contnrs, StrUtils, UtilOffice;
{$R *.dfm}

constructor TTaskThread.create(filename: string; executeTime: TLabel);
begin
    inherited create(true);
    FFinished := false;
    FFilename := filename;
    FExecuteTime := executeTime;
end;

procedure TTaskThread.execute;
begin
    Synchronize(DoOpenFile);
end;

procedure TTaskThread.DoOpenFile;
begin
    if (fileExt = '.xls') then begin
        OpenExcel(FFilename);
    end else if (fileExt = '.doc') then begin
        OpenWord(FFilename);
    end else if (fileExt = '.ppt') then begin
        OpenPowerPoint(FFilename);
    end else if (fileExt = '.wmv') then begin
        //
    end
    else begin
        //returnValue := false;
    end;

end;

procedure TForm1.btnSelectClick(Sender: TObject);
var
    FileAttrs, i: Integer;
    strPath: string;
    dir: string;
    FileNameList: TStringList;
begin
    OpenDialog1.Title := 'OpenĿ¼';
    FileNameList := TStringList.Create;

    CheckListBox1.Items.clear;
    if (SelectDirectory('��ѡ���ļ������·��', '', strPath)) then begin
        EnumFileInQueue(PChar(strPath), '.*', FileNameList);
    end;

    CheckListBox1.Items.AddStrings(FileNameList);
    FileNameList.Free;
end;

procedure SearchFile(path: string);
var
    SearchRec: TSearchRec;
    found: integer;

begin

    found := FindFirst(path + '\*.* ', faAnyFile, SearchRec);
    while found = 0 do begin
        if (SearchRec.Name <> '.') and (SearchRec.name <> '..') and
            (SearchRec.Attr = faDirectory) then
            SearchFile(SearchRec.Name + '\*.*')
        else
            Form1.CheckListBox1.Items.Add(SearchRec.Name);
        found := FindNext(SearchRec);
    end;
    FindClose(SearchRec);

end;


procedure EnumFileInQueue(path: PChar; sFileExt: string; fileList: TStringList);
var
    searchRec: TSearchRec;
    found: Integer;
    tmpStr: string;
    curDir: string;
    dirs: TQueue;
    pszDir: PChar;
begin
    dirs := TQueue.Create; //����Ŀ¼����
    dirs.Push(path); //����ʼ����·�����
    pszDir := dirs.Pop;
    curDir := StrPas(pszDir); //����
    {��ʼ����,ֱ������Ϊ��(��û��Ŀ¼��Ҫ����)}
    while (True) do begin
        //����������׺,�õ�����'c:\*.*' ��'c:\windows\*.*'������·��
        tmpStr := curDir + '\*.*';
        //�ڵ�ǰĿ¼���ҵ�һ���ļ�����Ŀ¼
        found := FindFirst(tmpStr, faAnyFile, searchRec);
        while found = 0 do {//�ҵ���һ���ļ���Ŀ¼�� } begin
            //����ҵ����Ǹ�Ŀ¼
            if (searchRec.Attr and faDirectory) <> 0 then begin
                {�������Ǹ�Ŀ¼(C:\��D:\)�µ���Ŀ¼ʱ�����'.','..'��"����Ŀ¼"
                ����Ǳ�ʾ�ϲ�Ŀ¼���²�Ŀ¼�ɡ�����Ҫ���˵��ſ���}
                if (searchRec.Name <> '.') and (searchRec.Name <> '..') then begin
                    {���ڲ��ҵ�����Ŀ¼ֻ�и�Ŀ¼��������Ҫ�����ϲ�Ŀ¼��·��
                     searchRec.Name = 'Windows';
                     tmpStr:='c:\Windows';
                     �Ӹ��ϵ��һ�������
                    }
                    tmpStr := curDir + '\' + searchRec.Name;
                    {����������Ŀ¼��ӡ����������š�
                     ��ΪTQueue���������ֻ����ָ��,����Ҫ��stringת��ΪPChar
                     ͬʱʹ��StrNew������������һ���ռ�������ݣ������ʹ�Ѿ���
                     ����е�ָ��ָ�򲻴��ڻ���ȷ������(tmpStr�Ǿֲ�����)��}
                    dirs.Push(StrNew(PChar(tmpStr)));
                end;
            end
            else {//����ҵ����Ǹ��ļ� } begin
                {Result��¼�����������ļ���������������CreateThread�����߳�
                 �����ú����ģ���֪����ô�õ��������ֵ�������Ҳ�����ȫ�ֱ���}
               //���ҵ����ļ��ӵ�Memo�ؼ�
                if sFileExt = '.*' then
                    fileList.Add(curDir + '\' + searchRec.Name)
                else begin
                    if SameText(RightStr(curDir + '\' + searchRec.Name, Length(sFileExt)), sFileExt) then
                        fileList.Add(curDir + '\' + searchRec.Name);
                end;
            end;
            //������һ���ļ���Ŀ¼
            found := FindNext(searchRec);
        end;
        {��ǰĿ¼�ҵ������������û�����ݣ����ʾȫ���ҵ��ˣ�
          ������ǻ�����Ŀ¼δ���ң�ȡһ�������������ҡ�}
        if dirs.Count > 0 then begin
            pszDir := dirs.Pop;
            curDir := StrPas(pszDir);
            StrDispose(pszDir);
        end
        else
            break;
    end;
    //�ͷ���Դ
    dirs.Free;
    FindClose(searchRec);
end;


procedure TForm1.btnPlayClick(Sender: TObject);
begin
    btnPlay.Enabled := false;
    btnPause.Enabled := true;
    btnStop.Enabled := true;
    taskPos := CheckListBox1.Count - 1;
    playFile();
end;

procedure TForm1.playFile();
var
    i, k: integer;
    fileName: string;
    returnValue: boolean;
begin
    for I := taskPos downto 0 do begin
        lblHint.Caption := '10';
        if CheckListBox1.Checked[I] then begin
            taskPos := i - 1;
            fileName := CheckListBox1.Items.Strings[i];
            fileExt := ExtractFileExt(fileName);
            if (fileExt = '.xls') then begin
                task := TTaskThread.Create(fileName, lblHint);
                timer1.Enabled := true;
            end else if (fileExt = '.doc') then begin
                task := TTaskThread.Create(fileName, lblHint);
                task.Execute;
                timer1.Enabled := true;
            end else if (fileExt = '.ppt') then begin
                task := TTaskThread.Create(fileName, lblHint);
                task.Execute;
                timer1.Enabled := true;
            end else if (fileExt = '.wmv') then begin
                WindowsMediaPlayer1.Visible := true;
                WindowsMediaPlayer1.URL := fileName;
                WindowsMediaPlayer1.controls.play;
                WindowsMediaPlayer1.ControlInterface.stretchToFit := True;
                WindowsMediaPlayer1.ControlInterface.fullScreen := false;
                WindowsMediaPlayer1.Align := alClient;
                WindowsMediaPlayer1.Repaint;
                WindowsMediaPlayer1.Width := 100;
                WindowsMediaPlayer1.Height := 100;
                timer1.Enabled := true;
            end
            else begin
                returnValue := false;
            end;
            break;
        end;
        k := i;
    end;
    if k = 0 then begin
        btnStop.Enabled := false;
        btnPause.Enabled := false;
        btnPlay.Enabled := true;
    end;
end;


procedure TForm1.N1Click(Sender: TObject);
var
    sExt :string;
begin
    sExt := ExtractFileExt(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    if (sExt = '.xls') then begin
        OpenExcel(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    end else if (sExt = '.doc') then begin
        EditWord(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    end else if (sExt = '.ppt') then begin
        OpenPowerPoint(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    end else if (sExt = '.wmv') then begin
        ShowMessage('��֧�ֵ��ļ�����');
    end
    else begin
        ShowMessage(fileExt + ',��ʽ��֧��');
    end;

end;

procedure TForm1.CheckListBox1DblClick(Sender: TObject);
begin
    ShowMessage(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex])
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
    remains: integer;
begin
    remains := StrToInt(lblHint.Caption) - 1;
    if remains <= 0 then begin
        lblHint.Caption := '0';
        timer1.Enabled := false;

        if (fileExt = '.xls') then begin
            v_office.quit;
            task.Terminate;
        end else if (fileExt = '.doc') then begin
            v_office.quit;
            task.Terminate;
        end else if (fileExt = '.ppt') then begin
            PowerPointApplication1.Quit;
            PowerPointApplication1.Disconnect;
            task.Terminate;
        end else if (fileExt = '.wmv') then begin
            //mediaplayer1.stop;
            WindowsMediaPlayer1.controls.stop;
        end else begin
            ShowMessage(fileExt + '��ʽ��֧��');
        end;

        if taskPos >= 0 then begin
            playFile;
        end else begin
            btnStop.Enabled := false;
            btnPause.Enabled := false;
            btnPlay.Enabled := true;
        end;
    end else begin
        lblHint.Caption := IntToStr(remains);
    end;
end;

procedure TForm1.btnPauseClick(Sender: TObject);
begin
    if (btnPause.Caption = '��ͣ') then begin
        btnPause.Caption := '����';
        timer1.Enabled := false;
        if (fileExt = '.wmv') then begin
            WindowsMediaPlayer1.controls.pause;
        end;
    end else begin
        btnPause.Caption := '��ͣ';
        WindowsMediaPlayer1.controls.play;
        timer1.Enabled := true;
    end;
    btnPlay.Enabled := false;
    btnStop.Enabled := true;
    btnPause.Enabled := true;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
    btnPlay.Enabled := true;
    btnPause.Enabled := false;
    btnStop.Enabled := false;

    if (fileExt = '.xls') then begin
        v_office.quit;
    end else if (fileExt = '.doc') then begin
        v_office.quit;
    end else if (fileExt = '.ppt') then begin
        PowerPointApplication1.Quit;
        PowerPointApplication1.Disconnect;
    end else if (fileExt = '.wmv') then begin
        //mediaplayer1.stop;
        WindowsMediaPlayer1.controls.stop;
    end else begin
        //ShowMessage(fileExt + '��ʽ��֧��');
    end;
    timer1.Enabled := false;
    lblHint.Caption := '0';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    btnPlay.Enabled := true;
    btnStop.Enabled := false;
    btnPause.Enabled := false;
    try
        //Image1.Picture.RegisterFileFormat('jpg', 'Just a normal BMP File!', TBitmap);
        Image1.Picture.LoadFromFile(ExtractFilePath(paramstr(0)) + 'back.bmp');
        //Image1.Align := alClient;
        //WindowsMediaPlayer1.SendToBack;
        WindowsMediaPlayer1.Visible := false;
        Image1.BringToFront;
        //Image1.Refresh;
        //Panel2.Repaint;
    except
        ShowMessage('����ͼƬδ�ҵ����ļ���Ϊ��' + ExtractFilePath(paramstr(0)) + '\back.bmp');
        WindowsMediaPlayer1.Align := alClient;
        WindowsMediaPlayer1.BringToFront;
        WindowsMediaPlayer1.Realign;
        WindowsMediaPlayer1.Repaint;
        WindowsMediaPlayer1.Visible := true;
        Image1.SendToBack;
        Image1.Visible := false;
        //Panel2.Repaint;
        //Panel2.Realign;
    end;
end;

end.

