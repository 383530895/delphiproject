���������������Ŀ¼�ṹ
  MyLib\          �����������Ҫ����
  TestMyLib\      ��������Ĳ���(Ҳ����ʾ��)
  Example\        ���������ʾ��
  activeX\        �����ActiveX�ؼ���TypeLib���Լ���Ӧ������
    \ActiveMovie  ActiveMovie��ʹ�����Լ����װ
    \BookViewer   ���Կ�΢��ͼ��(*.001,*.002)�ĳ���
  import\         ����ĵ���������⣬�Լ��ҵ��޸Ļ��߶����װ
    \ImageLib     ��ʾ/����ͼ���ļ��Ŀ�(֧��BMP,GIF,JPEG,TIFF,PCX,PNG)
    \PosControl2  Pos�Ŀؼ�(��ҪRXLib�Լ�Delphi3.0)
    \dblib        ʹ��dblib����sqlserver��dblib���������Լ����װ
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Packages:
  User.dpk        ���������Ŀؼ��Լ�ʵ����ͺ���(Run-Time Only��User.BPL����λ��Path)
  dUser.dpk       ע��User.dpk��Delphi IDE,�������ʱWizard(Design-Time)
  CoolPkg.dpk        ����һЩ������۵Ŀؼ�(Run-Time Only��User.BPL����λ��Path)
  dCoolPkg.dpk       ע��Cool.dpk��Delphi IDE,�������ʱWizard(Design-Time)
  ImageLib.dpk    ��ʾ/����ͼ���ļ��Ŀؼ�(Run Time&Design Time)

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
��װ��ʽ
  1. ��װ��Delphi4��Update Pack 3,����delphi5
  2. ������������Ŀ¼������
  3. ��Delphi�д�MyLib\user.dpk, Compile (���������user.bpl�Զ�������delphi\bin)
  4. ��Delphi�д�MyLib\duser.dpk, Compile,Install
  5. ��Delphi�д�MyLib\CoolPkg.dpk,Compile (���������Coolpkg.bpl�Զ�������delphi\bin)
  6. ��Delphi�д�MyLib\dCoolPkg.dpk,Compile,Install
  7. ��Delphi�д�import\ImageLib\ImageLib.dpk,Compile,Install

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

�ر��Ƽ�:
    DebugMemory,LogFile,Safecode : ��д��ȷdelphi����Ĺ���


˵����

������Ƿ�ʽ��  (Unit),[Component]

User.dpk
(Ability Managers) : �����ؼ���Enable/Disable���ԵĹ���������Ȩ�޹���
    1. Ability Manager(����������) :     ����ؼ���Enable/Disable
    �������ԣ�Enable,Visible,VisibleOnEnabled,OnEnableChanged,OnVisibleChanged,AbilityProvider
    ��������: CheckEnabled,CheckVisible
    [TAbilityManager]
    [TSimpleAbilityManager] ����:MenuItem,Control
    [TGroupAbilityManager]  ����:MenuItems,Controls

    2.Authority Provider(Ȩ���ṩ��) :  �ṩȨ�ޱ�־
    �������ԣ�OnAuthorityChanged; ��������: GetAuthorityAsInteger,GetAuthorityAsString
    [TSimpleAuthorityProvider] ���ԣ�AuthorityAsInteger,AuthorityAsString
    [TDBAuthorityProvider]     ���ԣ�autoActive,Active,AuthorityQuery,UserID,DefaultAuthorityInteger,DefaultAuthorityString,SeperateChar

    3.Ability   Provider(�����ṩ��) :  �������������ߺ�Ȩ���ṩ�ߡ�
    ����Ȩ���ṩ���ṩ��Ȩ�ޱ�־���������㣬�������������ߵ�Enable/Disable��Ȼ������������Ӱ��ؼ���
    �������ԣ�AbilityManager,AuthorityProvider,OnAbilityChanged,DefaultEnabled

    [TAbilityProvider]  ����:ProviderType,AsInteger,AsString,OnCustomCalc

(AMovieUtils): ��װActiveMovie�ӿ�
    [TMovieWnd] ��ʾMovie�Ĵ���
        ���ԣ�AutoRewind:�Զ�����; Opened: ��/�ر�Movie; FileName;Interval;EnableTimer
        �¼���OnStateChanged;OnTimer;AfterOpen;OnPlayComplete;

(BkGround) : ���������ؼ���ʹ�����ϵĿؼ�͸��
    [TBackGround]:  Tiled,Picture,Transparent,OnFilterControl

(ClipbrdMon) : ���Ӽ��а�仯����� 

(ComboLists) : ��������������
    [TCustomCodeValues] : ����һϵ�е�Code-Value��(�����)
    [TCustomComboList] : ��������ʾTCustomCodeValues��Valueֵ������ʵ��Code
                  ���ܣ�ֱ��������룻����Value���������ж�λ������
    [TDBCodeValues] : ͨ��Query�����ݿ���Code-Value��
    [TComboList]
    [TDBComboBoxList] �������е�TComboList�����ݿⱣ��Code,�ؼ�����ʾ/ѡ��Value

(CompGroup) : �������֡�������ϡ�
    [TComponentGroup] ������� ���ԣ�Components
    [TAppearanceGroup] ����һ�����(���壬��ɫ)��������ϣ����ԣ�Components,Color,Font
    [TAppearanceProxy] ��۴�����FontDialog,ColorDialog,ProxyComponent������
        �û�������Ժ󣬳���FontDialog/ColorDialog,�޸���۴����Font/Color��Ȼ��ͨ����۴����޸�ProxyComponent��Font/Color
        ���ԣ�OnColorChanged,OnFontChanged,ProxyComponent,ColorDialog,FontDialog,ConfigColorOn,ConfigFontOn

(CompUtils) : �����׼�����ʹ�÷����Ĺ���

(ComWriUtils) : Components writers' utilities

(Container)
    [TContainerProxy] �����ʱ����TContainer��λ�ô�С�����ԣ�ContainerClassName

(DBListOne) : ������������Dataset��List,ComboBox
    [TDBListOne] ��������Dataset��Listbox,���ԣ�SelectText��DataField,DataSource
    [TDBComboList] ��������Dataset��ComboBox,���ԣ�DataField,DataSource,DropDownCount,DropDownWidth

(DebugMemory) : �����ڴ�й©

(Design) : ������ƿؼ�
    [TDesigner] : ��ƿؼ���������������Ŀؼ�����ʹ�����ı��С��λ��
        ����:Designed;PlaceCtrlCursor;NotDesignNewCtrl;FocusOnNewCtrl;
        ��������:DesignCtrl;PlaceNewCtrl
        �¼�:OnPlaceNewCtrl;OnDesignCtrlChanged;OnDelete;OnCtrlSizeMove

(DragMoveUtils) ��������϶��ı�ؼ���С/λ�õĹ���

(DrawUtils) ��ͼ����

(ExtDialogs) ��������ĶԻ���
    [TPenDialog]  ����Pen���ԵĶԻ���
        ���ԣ�Title,Pen
    [TOpenDialogEx] ����OpenDialog,�����ղؼй���
        ����: StartInFavorites;NewStyle;IsSaveDialog;TextCtrl;
    [TFolderDialog] ѡ��Ŀ¼�ĶԻ���
        ����: Folder;TextCtrl;

(extutils) �������ú���(�ļ������ַ�������ȵ�)

(FontStyles) : �������չʾ
    [TFontStyles] �����������壬������PopupMenu,MenuItem,ListBox����ʾ��Щ����
        ����: Styles;PopupMenu;MenuItem;ListBox

(GridEx) : ������StringGrid����չ
    [TStringGridEx] : ��StringGrid����չ�����ܣ�����ָ���̶����е����壻�������У����浽�ļ�
        ����: FixColFont,FixFont,TopLeftFont,WordWrap

(HotKeyMons) : ����ϵͳ�ȼ����
    [THotKeyMonitor] : ���Զ���һ��ϵͳ�ȼ������û������ȼ��Ժ󣬴����¼�
        ����: Active;ShortCut;Modifiers;OnHotKey

(IntfUtils) : ʵ�ֽӿڵĻ�����

(IPCUtils) : �������̼�ͨ�ŵĹ�����

(LibMessages) : ����MyLib�õ����Զ���Windows��Ϣ����

(LogFile) : дLog�ļ��Ĺ���

(MenuUtils) : �˵�����

(MovieViewer):����Movie
    [TMovieView] : ����Movie�Ŀؼ�
        ���ԣ�Active;CtrlVisible;AutoRewind;FileName;StateChanged;AfterOpen;OnPlayComplete

(PenCfgDlg) : ��������Pen���ԵĽ���
    [TdlgPenCfg] : ��������Pen���ԵĽ���

(RTFUtils) : RichEdit����
    [TRichView] : ֧���ı��е��ȵ�
    [THyperTextView]: ���ȵ���Ϣ�����ڸ����ļ���
    [THyperTextViewEx] : ͨ�����ӿ��еķ�ʽ�趨�м��

(Safecode) : ��д�ɿ���������ƶ��Ե��ж�

(ShellUtils) : ��װWin32��Shell�ӿ�
    [TTrayNotify] : ������ͼ��
        ���ԣ�Tip;ShowButton;Active;Icon;LeftPopup;RightPopup;OnLeftClick;OnRightClick;OnDblClick;OnMouseEvent
    [TMultiIcon]  : ����������ͼ��
        ���ԣ�ImageList,CurIndex,Animate,StartIndex,EndIndex,Interval
    [TShellFolder] : ��װIShellFolder�ӿڣ�������ListView����ʾ�������ļ�
        ���ԣ�Path,ListView,OnPathChanged,Sorted,Options,OnItemsChanged,
              Filtered,OnFilter,Mask,CanEnterSub
    [TFileOperation] : ��װSHFileOperation������ļ�����
        ���ԣ�Sources,Dests,Operation,Options,Title,Simple,Source,Dest

(SimpBmp) : ��װWindows��Bitmap,���ܱ�TBitmap�򵥣��ٶȿ�

(SimpCtrls) : �̳�TLable,TSpeedButton����Caption������'\n'��ʾ����
    [TLabelX]: �̳�TLable��Caption������'\n'��ʾ����
    [TSpeedButtonX]: �̳�TSpeedButton��Caption������'\n'��ʾ����

(StorageUtils) : ʹ��IniFile�Ĺ���

(TypUtils) : RunTime-Type-Information ����

*********************************************************

CoolPkg.dpk
(BtnLookCfgDLG) : ���ð�������۵Ľ���

(CoolCtrls) : ����������۵�Label,Button
    [TCoolLabel] : ��Lable���䣬����λͼ
    [TLabelOutlook]: ����TCoolLabelX�����
    [TCoolLabelX]: ��Lable���䣬�����TLabelOutlook����
    [TButtonOutlook] : ����TCoolButton�����
    [TPenExample] : ��ʾPen��Ч���Ŀؼ�
    [TAniButtonOutlook] : �趨TAniCoolButton�����
    [TAniCoolButton] : ���������������TAniButtonOutlook����

(ImageFXs) : ����Ч��ͼ��
    [TImageFX] : ����Ч��ͼ������Ч������TCustomFXPainter
    [TFXScalePainter] : ����������Ч��
    [TFXStripPainter] : ����������Ч��
    [TFXDualPainter]  : ˫�ߵ�����Ч��

(LabelLookCfgDLG) : ����Label����۵Ľ���

*********************************************************

ImageLib.dpk

(ImageLibX) :ImageLib�ĺ�������

(ImgLibObjs) : ��װImageLib
    [TILImage] : ��ʾͼ��Ŀؼ���(ʹ��TBitmap����HBitmap)
    [TILImageView] : ��ʾͼ��Ŀؼ���(ʹ��TSimpleBitmap����HBitmap)
