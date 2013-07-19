unit TeeJapanese;
{$I TeeDefs.inc}

interface

Uses Classes;

Var TeeJapaneseLanguage:TStringList=nil;

Procedure TeeSetJapanese;
Procedure TeeCreateJapanese;

implementation

Uses SysUtils, TeeTranslate, TeeConst, TeeProCo {$IFNDEF D5},TeCanvas{$ENDIF};

Procedure TeeJapaneseConstants;
begin
  { TeeConst }
  TeeMsg_Copyright          :='(C) 1997-2003 by David Berneda';
  TeeMsg_LegendFirstValue   :='�ŏ��̖}��̒l��0���傫���Ȃ���΂Ȃ�܂���B';
  TeeMsg_LegendColorWidth   :='�}��̐F�̕���0%���傫���Ȃ���΂Ȃ�܂���B';
  TeeMsg_SeriesSetDataSource:='�L���ȃf�[�^�\�[�X��ParentChart������܂���B';
  TeeMsg_SeriesInvDataSource:='�����ȃf�[�^�\�[�X: %s';
  TeeMsg_FillSample         :='FillSampleValues�̒l��0���傫���Ȃ���΂Ȃ�܂���B';
  TeeMsg_AxisLogDateTime    :='���t���Ԏ���ΐ����ɂ��邱�Ƃ͂ł��܂���B';
  TeeMsg_AxisLogNotPositive :='�ΐ����̍ŏ��l�ƍő�l��0�ȏ�łȂ���΂Ȃ�܂���B';
  TeeMsg_AxisLabelSep       :='�����x���Ԃ̋����̊���(%)��0���傫���Ȃ���΂Ȃ�܂���B';
  TeeMsg_AxisIncrementNeg   :='���̑����ʂ�0�ȏ�łȂ���΂Ȃ�܂���B';
  TeeMsg_AxisMinMax         :='���̍ŏ��l�͍ő�l�ȉ��łȂ���΂Ȃ�܂���B';
  TeeMsg_AxisMaxMin         :='���̍ő�l�͍ŏ��l�ȏ�łȂ���΂Ȃ�܂���B';
  TeeMsg_AxisLogBase        :='�ΐ����̊��2�ȏ�ɂ��Ă��������B';
  TeeMsg_MaxPointsPerPage   :='1�y�[�W������̍ő�|�C���g����0���傫�����Ă��������B';
  TeeMsg_3dPercent          :='3D�̃p�[�Z���g�� %d ���� %d �̊Ԃɂ��Ă��������B';
  TeeMsg_CircularSeries     :='�~�n��̈ˑ��͋�����܂���B';
  TeeMsg_WarningHiColor     :='�\���F����16k�F�������͂���ȏ�𐄏��������܂��B';

  TeeMsg_DefaultPercentOf   :='%s of %s';
  TeeMsg_DefaultPercentOf2  :='%s'+#13+'of %s';
  TeeMsg_DefPercentFormat   :='##0.## %';
  TeeMsg_DefValueFormat     :='#,##0.###';
  TeeMsg_DefLogValueFormat  :='#.0 "x10" E+0';

  TeeMsg_AxisTitle          :='���̃^�C�g��';
  TeeMsg_AxisLabels         :='���̃��x��';
  TeeMsg_RefreshInterval    :='�X�V�Ԋu��0����60�̊ԂłȂ���΂Ȃ�܂���B';
  TeeMsg_SeriesParentNoSelf :='�n���ParentChart�́uSelf�v�ł͂���܂���I';
  TeeMsg_GalleryLine        :='���{��';
  TeeMsg_GalleryPoint       :='�U�z�}';
  TeeMsg_GalleryArea        :='��';
  TeeMsg_GalleryBar         :='�c�_';
  TeeMsg_GalleryHorizBar    :='���_';
  TeeMsg_GalleryPie         :='�~';
  TeeMsg_GalleryCircled     :='�~';
  TeeMsg_GalleryFastLine    :='�܂��';
  TeeMsg_GalleryHorizLine   :='�����{��';

  TeeMsg_PieSample1         :='Cars';
  TeeMsg_PieSample2         :='Phones';
  TeeMsg_PieSample3         :='Tables';
  TeeMsg_PieSample4         :='Monitors';
  TeeMsg_PieSample5         :='Lamps';
  TeeMsg_PieSample6         :='Keyboards';
  TeeMsg_PieSample7         :='Bikes';
  TeeMsg_PieSample8         :='Chairs';

  TeeMsg_GalleryLogoFont    :='�l�r �o�S�V�b�N';
  TeeMsg_Editing            :='%s �̕ҏW';

  TeeMsg_GalleryStandard    :='�W��';
  TeeMsg_GalleryExtended    :='�g��';
  TeeMsg_GalleryFunctions   :='�֐�';

  TeeMsg_EditChart          :='�`���[�g�̕ҏW(&D)...';
  TeeMsg_PrintPreview       :='����v���r���[(&P)...';
  TeeMsg_ExportChart        :='�`���[�g�̃G�N�X�|�[�g(&X)...';
  TeeMsg_CustomAxes         :='�J�X�^����...';

  TeeMsg_InvalidEditorClass :='%s: �����ȃG�f�B�^�N���X: %s';
  TeeMsg_MissingEditorClass :='%s: �G�f�B�^�_�C�A���O������܂���B';

  TeeMsg_GalleryArrow       :='���';

  TeeMsg_ExpFinish          :='����(&F)';
  TeeMsg_ExpNext            :='����(&N) >';

  TeeMsg_GalleryGantt       :='�K���g';

  TeeMsg_GanttSample1       :='Design';
  TeeMsg_GanttSample2       :='Prototyping';
  TeeMsg_GanttSample3       :='Development';
  TeeMsg_GanttSample4       :='Sales';
  TeeMsg_GanttSample5       :='Marketing';
  TeeMsg_GanttSample6       :='Testing';
  TeeMsg_GanttSample7       :='Manufac.';
  TeeMsg_GanttSample8       :='Debugging';
  TeeMsg_GanttSample9       :='New Version';
  TeeMsg_GanttSample10      :='Banking';

  TeeMsg_ChangeSeriesTitle  :='�n��̃^�C�g����ύX����';
  TeeMsg_NewSeriesTitle     :='�n��̐V�����^�C�g��:';
  TeeMsg_DateTime           :='���t�Ǝ���';
  TeeMsg_TopAxis            :='�㎲';
  TeeMsg_BottomAxis         :='����';
  TeeMsg_LeftAxis           :='����';
  TeeMsg_RightAxis          :='�E��';

  TeeMsg_SureToDelete       :='%s ���폜���܂����H';
  TeeMsg_DateTimeFormat     :='���t���ԏ���(&M):';
  TeeMsg_Default            :='�f�t�H���g: ';
  TeeMsg_ValuesFormat       :='�l�̏���(&M):';
  TeeMsg_Maximum            :='�ő�';
  TeeMsg_Minimum            :='�ŏ�';
  TeeMsg_DesiredIncrement   :='�v�]������ %s';

  TeeMsg_IncorrectMaxMinValue:='�������Ȃ��l�̗��R: %s';
  TeeMsg_EnterDateTime      :='���� [����] [hh:mm:ss]';

  TeeMsg_SureToApply        :='�ύX��K�p���܂����H';
  TeeMsg_SelectedSeries     :='(�I�����ꂽ�n��)';
  TeeMsg_RefreshData        :='�f�[�^�̍X�V(&R)';

  TeeMsg_DefaultFontSize    :='9';
  TeeMsg_DefaultEditorSize  :='439';
  TeeMsg_DefaultEditorHeight:='439';

  TeeMsg_FunctionAdd        :='�a';
  TeeMsg_FunctionSubtract   :='����';
  TeeMsg_FunctionMultiply   :='��';
  TeeMsg_FunctionDivide     :='��';
  TeeMsg_FunctionHigh       :='�ő�';
  TeeMsg_FunctionLow        :='�ŏ�';
  TeeMsg_FunctionAverage    :='���ϒl';

  TeeMsg_GalleryShape       :='�V�F�[�v';
  TeeMsg_GalleryBubble      :='�A';
  TeeMsg_FunctionNone       :='�R�s�[';

  TeeMsg_None               :='(�Ȃ�)';

  TeeMsg_PrivateDeclarations:='{ Private declarations }';
  TeeMsg_PublicDeclarations :='{ Public declarations }';

  TeeMsg_DefaultFontName    :='�l�r �o�S�V�b�N';

  TeeMsg_CheckPointerSize   :='�|�C���^�[�̃T�C�Y��0���傫�����Ă��������B';
  TeeMsg_About              :='�o�[�W�������(&A)...';

  tcAdditional              :='Additional';
  tcDControls               :='Data Controls';
  tcQReport                 :='QReport';

  TeeMsg_DataSet            :='�f�[�^�Z�b�g';
  TeeMsg_AskDataSet         :='�ް����(&D):';

  TeeMsg_SingleRecord       :='�P�ꃌ�R�[�h';
  TeeMsg_AskDataSource      :='�ް����(&D):';

  TeeMsg_Summary            :='�T�}���[';

  TeeMsg_FunctionPeriod     :='�֐��̃s���I�h��0�ȏ�ɂ��Ă��������B';

  TeeMsg_TeeChartWizard     :='TeeChart �E�B�U�[�h';
  TeeMsg_WizardTab          :='�Ɩ�';

  TeeMsg_ClearImage         :='�N���A(&R)';
  TeeMsg_BrowseImage        :='�Q��(&R)...';

  TeeMsg_WizardSureToClose  :='TeeChart �E�B�U�[�h���I�����Ă���낵���ł����H';
  TeeMsg_FieldNotFound      :='�t�B�[���h %s �����݂��܂���B';

  TeeMsg_DepthAxis          :='����';
  TeeMsg_PieOther           :='���̑�';
  TeeMsg_ShapeGallery1      :='abc';
  TeeMsg_ShapeGallery2      :='123';
  TeeMsg_ValuesX            :='X';
  TeeMsg_ValuesY            :='Y';
  TeeMsg_ValuesPie          :='�~';
  TeeMsg_ValuesBar          :='�_';
  TeeMsg_ValuesAngle        :='�p�x';
  TeeMsg_ValuesGanttStart   :='�J�n';
  TeeMsg_ValuesGanttEnd     :='�Ō�';
  TeeMsg_ValuesGanttNextTask:='�������';
  TeeMsg_ValuesBubbleRadius :='���a';
  TeeMsg_ValuesArrowEndX    :='EndX';
  TeeMsg_ValuesArrowEndY    :='EndY';
  TeeMsg_Legend             :='�}��';
  TeeMsg_Title              :='�^�C�g��';
  TeeMsg_Foot               :='�t�b�^�[';
  TeeMsg_Period             :='�s���I�h�͈̔�';
  TeeMsg_PeriodRange        :='�s���I�h�͈̔�';
  TeeMsg_CalcPeriod         :='�S�Ă� %s ���v�Z:';
  TeeMsg_SmallDotsPen       :='�����ȓ_';

  TeeMsg_InvalidTeeFile     :='*.tee �t�@�C���̃`���[�g�͖����ł��B';
  TeeMsg_WrongTeeFileFormat :='*.tee �t�@�C���̌`�����Ԉ���Ă��܂��B';

  {$IFDEF D5}
  TeeMsg_ChartAxesCategoryName   := '�`���[�g�̎�';
  TeeMsg_ChartAxesCategoryDesc   := '�`���[�g�̎��̃v���p�e�B�ƃC�x���g';
  TeeMsg_ChartWallsCategoryName  := '�`���[�g�̕�';
  TeeMsg_ChartWallsCategoryDesc  := '�`���[�g�̕ǂ̃v���p�e�B�ƃC�x���g';
  TeeMsg_ChartTitlesCategoryName := '�`���[�g�̃^�C�g��';
  TeeMsg_ChartTitlesCategoryDesc := '�`���[�g�̃^�C�g���̃v���p�e�B�ƃC�x���g';
  TeeMsg_Chart3DCategoryName     := '�`���[�g��3D';
  TeeMsg_Chart3DCategoryDesc     := '�`���[�g��3D�̃v���p�e�B�ƃC�x���g';
  {$ENDIF}

  TeeMsg_CustomAxesEditor       := '�J�X�^��';
  TeeMsg_Series                 := '�n��';
  TeeMsg_SeriesList             := '�n��...';

  TeeMsg_PageOfPages            := '�y�[�W %d / %d';
  TeeMsg_FileSize               := '%d �o�C�g';

  TeeMsg_First  := '�擪';
  TeeMsg_Prior  := '�O��';
  TeeMsg_Next   := '����';
  TeeMsg_Last   := '����';
  TeeMsg_Insert := '�}��';
  TeeMsg_Delete := '�폜';
  TeeMsg_Edit   := '�ҏW';
  TeeMsg_Post   := '�o�^';
  TeeMsg_Cancel := '�L�����Z��';

  TeeMsg_All    := '(�S��)';
  TeeMsg_Index  := '�C���f�b�N�X';
  TeeMsg_Text   := '�e�L�X�g';

  TeeMsg_AsBMP        :='�r�b�g�}�b�v(&B)';
  TeeMsg_BMPFilter    :='�r�b�g�}�b�v (*.bmp)|*.bmp';
  TeeMsg_AsEMF        :='���^�t�@�C��(&M)';
  TeeMsg_EMFFilter    :='�g�����^�t�@�C�� (*.emf)|*.emf|���^�t�@�C�� (*.wmf)|*.wmf';
  TeeMsg_ExportPanelNotSet := '�p�l���̃v���p�e�B���G�N�X�|�[�g�`���ɐݒ肳��Ă��܂���B';

  TeeMsg_Normal    := '�W��';
  TeeMsg_NoBorder  := '�g�Ȃ�';
  TeeMsg_Dotted    := '�_��';
  TeeMsg_Colors    := '�F����';
  TeeMsg_Filled    := '�h��ׂ�';
  TeeMsg_Marks     := '�}�[�J�t';
  TeeMsg_Stairs    := '�K�i';
  TeeMsg_Points    := '�|�C���g';
  TeeMsg_Height    := '3D����';
  TeeMsg_Hollow    := '������';
  TeeMsg_Point2D   := '2D�|�C���g';
  TeeMsg_Triangle  := '�O�p�`';
  TeeMsg_Star      := '��';
  TeeMsg_Circle    := '�~';
  TeeMsg_DownTri   := '�|���O�p�`';
  TeeMsg_Cross     := '������';
  TeeMsg_Diamond   := '�H�`';
  TeeMsg_NoLines   := '���Ȃ�';
  TeeMsg_Stack     := '�ςݏd��';
  TeeMsg_Stack100  := '�S����';
  TeeMsg_Pyramid   := '�l�p��';
  TeeMsg_Ellipse   := '�ȉ~';
  TeeMsg_InvPyramid:= '�|���l�p��';
  TeeMsg_Sides     := '���u';
  TeeMsg_SideAll   := '���� �n��';
  TeeMsg_Patterns  := '�p�^�[��';
  TeeMsg_Exploded  := '�ő啪��';
  TeeMsg_Shadow    := '�e';
  TeeMsg_SemiPie   := '���~';
  TeeMsg_Rectangle := '�����`';
  TeeMsg_VertLine  := '������';
  TeeMsg_HorizLine := '������';
  TeeMsg_Line      := '����';
  TeeMsg_Cube      := '������';
  TeeMsg_DiagCross := '�΂ߌ�����';

  TeeMsg_CanNotFindTempPath    := '�e���|�����t�H���_��������܂���';
  TeeMsg_CanNotCreateTempChart := '�e���|�����t�@�C�����쐬�ł��܂���';
  TeeMsg_CanNotEmailChart      := '�`���[�g�����[���ő��M�ł��܂���B Mapi �G���[: %d';

  TeeMsg_SeriesDelete := '�n��̍폜: ValueIndex %d ���͈͊O (0 �` %d).';

  { 5.02 }
  TeeMsg_AskLanguage  :='����(&L)...';

  { 5.03 }
  TeeMsg_Gradient := '����ް���';

  { TeeProCo }
  TeeMsg_GalleryPolar       :='��';
  TeeMsg_GalleryCandle      :='�L�����h��';
  TeeMsg_GalleryVolume      :='�{�����[��';
  TeeMsg_GallerySurface     :='�T�[�t�F�X';
  TeeMsg_GalleryContour     :='������';
  TeeMsg_GalleryBezier      :='�x�W�F';
  TeeMsg_GalleryPoint3D     :='3D �U�z';
  TeeMsg_GalleryRadar       :='���[�_�[';
  TeeMsg_GalleryDonut       :='�h�[�i�c';
  TeeMsg_GalleryCursor      :='�J�[�\��';
  TeeMsg_GalleryBar3D       :='3D �o�[';
  TeeMsg_GalleryBigCandle   :='�ޯ�޷�����';
  TeeMsg_GalleryLinePoint   :='ײ��߲��';
  TeeMsg_GalleryHistogram   :='�q�X�g�O����';
  TeeMsg_GalleryWaterFall   :='�����̫��';
  TeeMsg_GalleryWindRose    :='�����}';
  TeeMsg_GalleryClock       :='���v';
  TeeMsg_GalleryColorGrid   :='�װ��د��';
  TeeMsg_GalleryBoxPlot     :='�c�ޯ����ۯ�';
  TeeMsg_GalleryHorizBoxPlot:='���ޯ����ۯ�';
  TeeMsg_GalleryBarJoin     :='�o�[ �W���C��';
  TeeMsg_GallerySmith       :='�X�~�X';
  TeeMsg_GalleryPyramid     :='�s���~�b�h';
  TeeMsg_GalleryMap         :='�}�b�v';

  TeeMsg_PolyDegreeRange     :='�������̎����� 1 ���� 20 �̊Ԃɂ��Ă��������B';
  TeeMsg_AnswerVectorIndex   :='AnswerVector�v���p�e�B�̃C���f�b�N�X�l�� 1 ���� %d �̊Ԃɂ��Ă��������B';
  TeeMsg_FittingError        :='��Ԃ������ł��܂���B';
  TeeMsg_PeriodRange         :='�s���I�h��0�ȏ�ɐݒ肵�Ă��������B';
  TeeMsg_ExpAverageWeight    :='�w�����ϒl�̏d�݂�0��1�ɐݒ肵�Ă��������B';
  TeeMsg_GalleryErrorBar     :='�G���[�o�[';
  TeeMsg_GalleryError        :='�G���[';
  TeeMsg_GalleryHighLow      :='High-Low';
  TeeMsg_FunctionMomentum    :='�^����';
  TeeMsg_FunctionMomentumDiv :='���^����';
  TeeMsg_FunctionExpAverage  :='�w�����ϒl';
  TeeMsg_FunctionMovingAverage:='�ړ����ϒl';
  TeeMsg_FunctionExpMovAve   :='�w���ړ����ϒl';
  TeeMsg_FunctionRSI         :='R.S.I.';
  TeeMsg_FunctionCurveFitting:='�n��g�ݍ��킹';
  TeeMsg_FunctionTrend       :='�g�����h';
  TeeMsg_FunctionExpTrend    :='�w���g�����h';
  TeeMsg_FunctionLogTrend    :='�ΐ��g�����h';
  TeeMsg_FunctionCumulative  :='�ݐ�';
  TeeMsg_FunctionStdDeviation:='�W���΍�';
  TeeMsg_FunctionBollinger   :='Bollinger';
  TeeMsg_FunctionRMS         :='�덷��2��';
  TeeMsg_FunctionMACD        :='MACD';
  TeeMsg_FunctionStochastic  :='�m��';
  TeeMsg_FunctionADX         :='ADX';

  TeeMsg_FunctionCount       :='�v�Z';
  TeeMsg_LoadChart           :='TeeChart���J��...';
  TeeMsg_SaveChart           :='TeeChart��ۑ�...';
  TeeMsg_TeeFiles            :='TeeChart Pro �t�@�C��';

  TeeMsg_GallerySamples      :='���̑�';
  TeeMsg_GalleryStats        :='���v';

  TeeMsg_CannotFindEditor    :='�n���ҏW����t�H�[�� %s ��������܂���B';


  TeeMsg_CannotLoadChartFromURL:='�G���[�R�[�h: %d URL: %s ����`���[�g���_�E�����[�h���Ă��܂��B';
  TeeMsg_CannotLoadSeriesDataFromURL:='�G���[�R�[�h: %d URL: %s ����n��̃f�[�^���_�E�����[�h���Ă��܂��B';

  TeeMsg_Test                :='�e�X�g...';

  TeeMsg_ValuesDate          :='���t';
  TeeMsg_ValuesOpen          :='�n�l';
  TeeMsg_ValuesHigh          :='���l';
  TeeMsg_ValuesLow           :='���l';
  TeeMsg_ValuesClose         :='�I�l';
  TeeMsg_ValuesOffset        :='�̾��';
  TeeMsg_ValuesStdError      :='�W���װ';

  TeeMsg_Grid3D              :='3D�O���b�h';

  TeeMsg_LowBezierPoints     :='�x�W�F�̃|�C���g����1���傫�Ȓl��ݒ肵�Ă��������B';

  { TeeCommander component... }

  TeeCommanMsg_Normal   := '�W��';
  TeeCommanMsg_Edit     := '�ҏW';
  TeeCommanMsg_Print    := '���';
  TeeCommanMsg_Copy     := '�R�s�[';
  TeeCommanMsg_Save     := '�ۑ�';
  TeeCommanMsg_3D       := '3D';

  TeeCommanMsg_Rotating := '��]: %d� �p: %d�';
  TeeCommanMsg_Rotate   := '��]';

  TeeCommanMsg_Moving   := '�����I�t�Z�b�g: %d �����I�t�Z�b�g: %d';
  TeeCommanMsg_Move     := '�ړ�';

  TeeCommanMsg_Zooming  := '�Y�[��: %d %%';
  TeeCommanMsg_Zoom     := '�Y�[��';

  TeeCommanMsg_Depthing := '3D: %d %%';
  TeeCommanMsg_Depth    := '�[��';

  TeeCommanMsg_Chart    :='�`���[�g';
  TeeCommanMsg_Panel    :='�p�l��';

  TeeCommanMsg_RotateLabel:='%s ���h���b�O����Ɖ�]';
  TeeCommanMsg_MoveLabel  :='%s ���h���b�O����ƈړ�';
  TeeCommanMsg_ZoomLabel  :='%s ���h���b�O����ƃY�[��';
  TeeCommanMsg_DepthLabel :='%s ���h���b�O�����3D�����T�C�Y';

  TeeCommanMsg_NormalLabel:='�ް�(ϳ���������ׯ��) ��۰�(ϳ��E������ׯ��)';
  TeeCommanMsg_NormalPieLabel:='�~�̈�̋敪���h���b�O����ƕ���';

  TeeCommanMsg_PieExploding := '�敪: %d ����: %d %%';

  TeeMsg_TriSurfaceLess:='�|�C���g�̐���4�ȏ�ɂ��Ă��������B';
  TeeMsg_TriSurfaceAllColinear:='���꒼����ɂ���f�[�^�|�C���g�̑S��';
  TeeMsg_TriSurfaceSimilar:='�ގ������|�C���g�͎��s�ł��܂���B';
  TeeMsg_GalleryTriSurface:='��̪�(�O�p)';

  TeeMsg_AllSeries := '�S�Ă̌n��';
  TeeMsg_Edit      := '�ҏW';

  TeeMsg_GalleryFinancial    :='���Z';

  TeeMsg_CursorTool    := '�J�[�\��';
  TeeMsg_DragMarksTool := '�h���b�O�}�[�J';
  TeeMsg_AxisArrowTool := '�����';
  TeeMsg_DrawLineTool  := '�h���[���C��';
  TeeMsg_NearestTool   := '�ߖT�_';
  TeeMsg_ColorBandTool := '�J���[�o���h';
  TeeMsg_ColorLineTool := '�J���[���C��';
  TeeMsg_RotateTool    := '��]';
  TeeMsg_ImageTool     := '�C���[�W';
  TeeMsg_MarksTipTool  := '�}�[�J�`�b�v';
  Teemsg_AnnotationTool:= '�A�m�e�[�V����';

  TeeMsg_CantDeleteAncestor  := '�e�N���X�͍폜�ł��܂���B';

  TeeMsg_Load	         := '�Ǎ�...';
  TeeMsg_DefaultDemoTee  := 'http://www.steema.com/demo.tee';
  TeeMsg_NoSeriesSelected:= '�n�񂪑I������Ă��܂���B';

  { TeeChart Actions }
  TeeMsg_CategoryChartActions  := 'Chart';
  TeeMsg_CategorySeriesActions := 'Chart Series';

  TeeMsg_Action3D               := '3D(&3)';
  TeeMsg_Action3DHint           := '�؂�ւ� 2D / 3D';
  TeeMsg_ActionSeriesActive     := '�L��(&A)';
  TeeMsg_ActionSeriesActiveHint := '�\�� / ��\�� �n��';
  TeeMsg_ActionEditHint         := '�`���[�g�̕ҏW';
  TeeMsg_ActionEdit             := '�ҏW(&E)...';
  TeeMsg_ActionCopyHint         := '�N���b�v�{�[�h�փR�s�[';
  TeeMsg_ActionCopy             := '�R�s�[(&C)';
  TeeMsg_ActionPrintHint        := '�`���[�g�̈���v���r���[';
  TeeMsg_ActionPrint            := '���(&P)...';
  TeeMsg_ActionAxesHint         := '�\�� / ��\�� ��';
  TeeMsg_ActionAxes             := '��(&A)';
  TeeMsg_ActionGridsHint        := '�\�� / ��\�� �O���b�h';
  TeeMsg_ActionGrids            := '�O���b�h(&G)';
  TeeMsg_ActionLegendHint       := '�\�� / ��\�� �}��';
  TeeMsg_ActionLegend           := '�}��(&L)';
  TeeMsg_ActionSeriesEditHint   := '�n��̕ҏW';
  TeeMsg_ActionSeriesMarksHint  := '�\�� / ��\�� �n��̃}�[�J';
  TeeMsg_ActionSeriesMarks      := '�}�[�J(&M)';
  TeeMsg_ActionSaveHint         := '�`���[�g�̕ۑ�';
  TeeMsg_ActionSave             := '�ۑ�(&S)...';

  TeeMsg_CandleBar              := '����';
  TeeMsg_CandleNoOpen           := '�n�l�Ȃ�';
  TeeMsg_CandleNoClose          := '�I�l�Ȃ�';
  TeeMsg_NoLines                := '���Ȃ�';
  TeeMsg_NoHigh                 := '���l�Ȃ�';
  TeeMsg_NoLow                  := '���l�Ȃ�';
  TeeMsg_ColorRange             := '�F�͈�';
  TeeMsg_WireFrame              := '���C���[';
  TeeMsg_DotFrame               := '�_';
  TeeMsg_Positions              := '���x���ʒu';
  TeeMsg_NoGrid                 := '��د�ނȂ�';
  TeeMsg_NoPoint                := '�߲�ĂȂ�';
  TeeMsg_NoLine                 := '���Ȃ�';
  TeeMsg_Labels                 := '���x���t';
  TeeMsg_NoCircle               := '�O�~�Ȃ�';
  TeeMsg_Lines                  := '�����t';
  TeeMsg_Border                 := '�g�t';

  TeeMsg_SmithResistance      := '��R';
  TeeMsg_SmithReactance       := 'ر��ݽ';

  TeeMsg_Column  := '��';

  { 5.01 }
  TeeMsg_Separator            :='���ڰ�';
  TeeMsg_FunnelSegment        :='������ ';
  TeeMsg_FunnelSeries         :='�t�@�l��';
  TeeMsg_FunnelPercent        :='0.00 %';
  TeeMsg_FunnelExceed         :='�����ȏ�';
  TeeMsg_FunnelWithin         :=' �����ȓ�';
  TeeMsg_FunnelBelow          :=' �����ȉ�';
  TeeMsg_CalendarSeries       :='�J�����_�[';
  TeeMsg_DeltaPointSeries     :='�����߲��';
  TeeMsg_ImagePointSeries     :='�Ұ���߲��';
  TeeMsg_ImageBarSeries       :='�C���[�W�o�[';
  TeeMsg_SeriesTextFieldZero  :='SeriesText: Field �̐���0���傫�Ȓl��ݒ肵�Ă��������B';

  { 5.02 } { Moved from TeeImageConstants.pas unit }

  TeeMsg_AsJPEG        :='JPEG(&J)';
  TeeMsg_JPEGFilter    :='JPEG�t�@�C�� (*.jpg)|*.jpg';
  TeeMsg_AsGIF         :='GIF(&G)';
  TeeMsg_GIFFilter     :='GIF�t�@�C�� (*.gif)|*.gif';
  TeeMsg_AsPNG         :='PNG(&P)';
  TeeMsg_PNGFilter     :='PNG�t�@�C�� (*.png)|*.png';
  TeeMsg_AsPCX         :='PCX(&X)';
  TeeMsg_PCXFilter     :='PCX�t�@�C�� (*.pcx)|*.pcx';
  TeeMsg_AsVML         :='VML(HTM)(&V)';
  TeeMsg_VMLFilter     :='VML�t�@�C�� (*.htm)|*.htm';

  { 5.02 }
  TeeMsg_Origin               := '���_';
  TeeMsg_Transparency         := '����';
  TeeMsg_Box		      := '��';
  TeeMsg_ExtrOut	      := '�ɒl';
  TeeMsg_MildOut	      := '�O��l';
  TeeMsg_PageNumber	      := '�y�[�W��';
  TeeMsg_TextFile             := 'Text�t�@�C��';

  { 5.03 }
  TeeMsg_DragPoint            := 'Drag Point';
  TeeMsg_OpportunityValues    := '������è�l';
  TeeMsg_QuoteValues          := '���Ēl';

  {OCX 5.0.4}
  TeeMsg_ActiveXVersion      := 'ActiveX Release ' + AXVer;
  TeeMsg_ActiveXCannotImport := '%s����TeeChart���C���|�[�g�ł��܂���B';
  TeeMsg_ActiveXVerbPrint    := '�v���r���[';
  TeeMsg_ActiveXVerbExport   := '�G�N�X�|�[�g';
  TeeMsg_ActiveXVerbImport   := '�C���|�[�g';
  TeeMsg_ActiveXVerbHelp     := '�w���v';
  TeeMsg_ActiveXVerbAbout    := '�o�[�W�������';
  TeeMsg_ActiveXError        := 'TeeChart: �G���[�R�[�h: %d �_�E�����[�h: %s';
  TeeMsg_DatasourceError     := 'TeeChart�̃f�[�^�\�[�X�͌n��܂��̓��R�[�h�Z�b�g�ł͂���܂���B';
  TeeMsg_SeriesTextSrcError  := '�����Ȍn��^';
  TeeMsg_AxisTextSrcError    := '�����Ȏ��^';
  TeeMsg_DelSeriesDatasource := '%s���폜���Ă�낵���ł����H';
  TeeMsg_OCXNoPrinter        := '�v�����^���C���X�g�[������Ă��܂���B';
  TeeMsg_ActiveXPictureNotValid:='�s�N�`���[�������ł��B';
end;

Procedure TeeCreateJapanese;
begin
  if not Assigned(TeeJapaneseLanguage) then
  begin
    TeeJapaneseLanguage:=TStringList.Create;
    TeeJapaneseLanguage.Text:=
'GRADIENT EDITOR=�O���f�[�V�����̐ݒ�'#13+
'GRADIENT=����ް���'#13+
'DIRECTION=����'#13+
'VISIBLE=�\��'#13+
'TOP BOTTOM=��������'#13+
'BOTTOM TOP=�ォ�牺��'#13+
'LEFT RIGHT=�E���獶��'#13+
'RIGHT LEFT=������E��'#13+
'FROM CENTER=��������'#13+
'FROM TOP LEFT=�E�������'#13+
'FROM BOTTOM LEFT=�E��������'#13+
'OK=OK'#13+
'CANCEL=�L�����Z��'#13+
'COLORS=�F'#13+
'START=�J�n'#13+
'MIDDLE=����'#13+
'END=�I��'#13+
'SWAP=����'#13+
'NO MIDDLE=�����s��'#13+
'TEEFONT EDITOR=TeeFont Editor'#13+
'INTER-CHAR SPACING=�����̊Ԋu'#13+
'FONT=�t�H���g'#13+
'SHADOW=�e'#13+
'HORIZ. SIZE=��������'#13+
'VERT. SIZE=��������'#13+
'COLOR=�F'#13+
'OUTLINE=���ײ�'#13+
'FORMAT=�`��'#13+
'BEVEL=�x�x��'#13+
'SIZE=�T�C�Y'#13+
'FRAME=�g'#13+
'PATTERN=�p�^�[��'#13+
'ROUND FRAME=�g�̊p���ۂ�����'#13+
'TRANSPARENT=����'#13+
'NONE=�Ȃ�'#13+
'LOWERED=��'#13+
'RAISED=��'#13+
'COLOR=�F'#13+
'LEFT TOP=����'#13+
'LEFT BOTTOM=����'#13+
'RIGHT TOP=�E��'#13+
'RIGHT BOTTOM=�E��'#13+
'MULTIPLE AREAS=����'#13+
'STACKED=�ςݏd��'#13+
'STACKED 100%=�S����'#13+
'AREA=��'#13+
'STAIRS=�K�i'#13+
'SOLID=�h��Ԃ�'#13+
'CLEAR=�Ȃ�'#13+
'HORIZONTAL=������'#13+
'VERTICAL=������'#13+
'DIAGONAL=�E������ΐ�'#13+
'B.DIAGONAL=�E�オ��ΐ�'#13+
'CROSS=������'#13+
'DIAG.CROSS=�΂ߌ�����'#13+
'AREA LINES=�ʂ̉����'#13+
'BORDER=�g'#13+
'INVERTED=���]'#13+
'COLOR=�F'#13+
'COLOR EACH=�F�𕪂���'#13+
'ORIGIN=���_'#13+
'USE ORIGIN=���_���g�p'#13+
'WIDTH=��'#13+
'HEIGHT=����'#13+
'TEECHART LANGUAGES=TeeChart ����'#13+
'CHOOSE A LANGUAGE=����̑I��'#13+
'CANCEL=�L�����Z��'#13+
'AXIS=��'#13+
'LENGTH=����'#13+
'POSITION=�ʒu'#13+
'SCROLL=�X�N���[��'#13+
'START=�J�n'#13+
'END=�I��'#13+
'BOTH=����'#13+
'INVERTED SCROLL=�t�X�N���[��'#13+
'AXIS INCREMENT=Axis Increment'#13+
'INCREMENT=������'#13+
'INCREMENT=������'#13+
'STANDARD=�W��'#13+
'CUSTOM=�J�X�^��'#13+
'ONE MILLISECOND=1�~���b'#13+
'ONE SECOND=1�b'#13+
'FIVE SECONDS=5�b'#13+
'TEN SECONDS=10�b'#13+
'FIFTEEN SECONDS=15�b'#13+
'THIRTY SECONDS=30�b'#13+
'ONE MINUTE=1��'#13+
'FIVE MINUTES=5��'#13+
'TEN MINUTES=10��'#13+
'FIFTEEN MINUTES=15��'#13+
'THIRTY MINUTES=30��'#13+
'ONE HOUR=1����'#13+
'TWO HOURS=2����'#13+
'SIX HOURS=6����'#13+
'TWELVE HOURS=12����'#13+
'ONE DAY=1��'#13+
'TWO DAYS=2��'#13+
'THREE DAYS=3��'#13+
'ONE WEEK=1�T��'#13+
'HALF MONTH=����'#13+
'ONE MONTH=1����'#13+
'TWO MONTHS=2����'#13+
'THREE MONTHS=3����'#13+
'FOUR MONTHS=4����'#13+
'SIX MONTHS=6����'#13+
'ONE YEAR=1�N'#13+
'EXACT DATE TIME=���m�ȓ��t'#13+
'AXIS MAXIMUM AND MINIMUM=���̍ő�l�ƍŏ��l'#13+
'VALUE=�l'#13+
'TIME=����'#13+
'LEFT AXIS=����'#13+
'RIGHT AXIS=�E��'#13+
'TOP AXIS=�㎲'#13+
'BOTTOM AXIS=����'#13+
'% BAR WIDTH=�_�̕�'#13+
'STYLE=�X�^�C��'#13+
'% BAR OFFSET=�_�̈ʒu'#13+
'RECTANGLE=��`'#13+
'PYRAMID=�l�p��'#13+
'INVERT. PYRAMID=�|���l�p��'#13+
'CYLINDER=�~��'#13+
'ELLIPSE=�ȉ~'#13+
'ARROW=���'#13+
'RECT. GRADIENT=����ް��݋�`'#13+
'CONE=�~��'#13+
'DARK BAR 3D SIDES=3D�����Â�����'#13+
'BAR SIDE MARGINS=�_�̘e�ɗ]�������'#13+
'AUTO MARK POSITION=ϰ��ʒu�̎�������'#13+
'GRADIENT=����ް���'#13+
'JOIN=����'#13+
'AUTO MARK POSITION=ϰ��ʒu�̎�������'#13+
'DATASET=�ް����'#13+
'APPLY=�K�p'#13+
'SOURCE=�\�[�X'#13+
'COLORS=�F'#13+
'MONOCHROME=���m�N��'#13+
'DEFAULT=�f�t�H���g'#13+
'2 (1 BIT)=2 (1 bit)'#13+
'16 (4 BIT)=16 (4 bit)'#13+
'256 (8 BIT)=256 (8 bit)'#13+
'32768 (15 BIT)=32768 (15 bit)'#13+
'65536 (16 BIT)=65536 (16 bit)'#13+
'16M (24 BIT)=16M (24 bit)'#13+
'16M (32 BIT)=16M (32 bit)'#13+
'MEDIAN=�����l'#13+
'WHISKER=�Ђ�'#13+
'PATTERN COLOR EDITOR=�p�^�[���ƐF�̐ݒ�'#13+
'IMAGE=�C���[�W'#13+
'IMAGE=�C���[�W'#13+
'BACK DIAGONAL=�E�オ��ΐ�'#13+
'DIAGONAL CROSS=�΂ߌ�����'#13+
'FILL 80%=�h��Ԃ� 80%'#13+
'FILL 60%=�h��Ԃ� 60%'#13+
'FILL 40%=�h��Ԃ� 40%'#13+
'FILL 20%=�h��Ԃ� 20%'#13+
'FILL 10%=�h��Ԃ� 10%'#13+
'ZIG ZAG=�W�O�U�O'#13+
'VERTICAL SMALL=������ (��)'#13+
'HORIZ. SMALL=������ (��)'#13+
'DIAG. SMALL=�E������ΐ� (��)'#13+
'BACK DIAG. SMALL=�E�オ��ΐ� (��)'#13+
'CROSS SMALL=������ (��)'#13+
'DIAG. CROSS SMALL=�΂ߌ����� (��)'#13+
'PATTERN COLOR EDITOR=�p�^�[���ƐF�̐ݒ�'#13+
'OPTIONS=�I�v�V����'#13+
'DAYS=��'#13+
'WEEKDAYS=�j��'#13+
'TODAY=����'#13+
'SUNDAY=���j��'#13+
'TRAILING=�O�㌎'#13+
'MONTHS=�N��'#13+
'LINES=��'#13+
'SHOW WEEKDAYS=�j���̕\��'#13+
'UPPERCASE=�啶��'#13+
'TRAILING DAYS=�O�㌎�̕\��'#13+
'SHOW TODAY=�����̕\��'#13+
'SHOW MONTHS=�N���̕\��'#13+
'UPPERCASE=�啶��'#13+
{'UPPERCASE=NOTVisible'#13+}
'SHOW PREVIOUS BUTTON=�O���{�^���̕\��'#13+
'SHOW NEXT BUTTON=�����{�^���̕\��'#13+
'CANDLE WIDTH=�����ق̕�'#13+
'STYLE=�X�^�C��'#13+
'STICK=�_��'#13+
'BAR=����'#13+
'OPEN CLOSE=�n�l�E�I�l'#13+
'UP CLOSE=���l�̐F'#13+
'DOWN CLOSE=���l�̐F'#13+
'SHOW OPEN=�n�l��\��'#13+
'SHOW CLOSE=�I�l��\��'#13+
'BORDER=�g'#13+
'DRAW 3D=3D'#13+
'DARK 3D=3D�����Â�����'#13+
'EDITING=Editing'#13+
'CHART=�`���[�g'#13+
'SERIES=�n��'#13+
'DATA=�f�[�^'#13+
'TOOLS=�c�[��'#13+
'EXPORT=�G�N�X�|�[�g'#13+
'PRINT=���'#13+
'GENERAL=���'#13+
'AXIS=��'#13+
'TITLES=�^�C�g��'#13+
'LEGEND=�}��'#13+
'PANEL=�p�l��'#13+
'PAGING=�y�[�W'#13+
'WALLS=��'#13+
'3D=3D'#13+
'ADD=�ǉ�'#13+
'DELETE=�폜'#13+
'TITLE=�^�C�g��'#13+
'CLONE=����'#13+
'CHANGE=�ύX'#13+
'WWW.STEEMA.COM=http://www.newtone.co.jp/'#13+
'HELP=�w���v'#13+
'CLOSE=����'#13+
'SERIES=�n��'#13+
'IMAGE=�C���[�W'#13+
'TEECHART PRINT PREVIEW=TeeChart ����v���r���['#13+
'PRINTER=�����'#13+
'SETUP=�ݒ�'#13+
'PRINT=���'#13+
'ORIENTATION=����̌���'#13+
'PORTRAIT=�c'#13+
'LANDSCAPE=��'#13+
'MARGINS (%)=�]�� (%)'#13+
'DETAIL=�ڍ�'#13+
'MORE=���ڂ���'#13+
'NORMAL=�W��'#13+
'RESET MARGINS=�]����ؾ��'#13+
'VIEW MARGINS=�]���̕\��'#13+
'PROPORTIONAL=�����l��'#13+
'TEECHART PRINT PREVIEW=TeeChart ����v���r���['#13+
'STYLE=�X�^�C��'#13+
'CIRCLE=�~'#13+
'VERTICAL LINE=������'#13+
'HORIZ. LINE=������'#13+
'TRIANGLE=�O�p�`'#13+
'INVERT. TRIANGLE=�|���O�p�`'#13+
'LINE=����'#13+
'DIAMOND=�H�`'#13+
'CUBE=������'#13+
'STAR=���`'#13+
'BORDER=�g'#13+
'TRANSPARENT=����'#13+
'HORIZ. ALIGNMENT=���������̈ʒu���킹'#13+
'LEFT=��'#13+
'CENTER=����'#13+
'RIGHT=�E'#13+
'ROUND RECTANGLE=�p���ۂ�����'#13+
'ALIGNMENT=�ʒu���킹'#13+
'TOP=��'#13+
'BOTTOM=��'#13+
'GRADIENT=����ް���'#13+
'LEFT=��'#13+
'RIGHT=:�E'#13+
'TOP=��'#13+
'BOTTOM=��'#13+
'UNITS=�P��'#13+
'PIXELS=�s�N�Z��'#13+
'AXIS ORIGIN=���̌��_'#13+
'ROTATION=��]'#13+
'CIRCLED=���~'#13+
'3 DIMENSIONS=3D'#13+
'RADIUS=���a'#13+
'HORIZONTAL=����'#13+
'VERTICAL=����'#13+
'AUTO=����'#13+
'AUTO=����'#13+
'ANGLE INCREMENT=�p�x�̑�����'#13+
'RADIUS INCREMENT=���a�̑�����'#13+
'CLOSE CIRCLE=�n�_�ƏI�_�̐ڑ�'#13+
'PEN=�y��'#13+
'CIRCLE=�~'#13+
'PATTERN=�p�^�[��'#13+
'LABELS=���x��'#13+
'ROTATED=90�x��]'#13+
'CLOCKWISE=���v���'#13+
'INSIDE=����'#13+
'ROMAN=���[�}����'#13+
'HOURS=����'#13+
'MINUTES=��'#13+
'SECONDS=�b'#13+
'RADIUS=���a'#13+
'START VALUE=�J�n�l'#13+
'END VALUE=�I���l'#13+
'TRANSPARENCY=����'#13+
'DRAW BEHIND=�w�ʂɕ`��'#13+
'COLOR MODE=�F�̎��'#13+
'STEPS=�X�e�b�v'#13+
'RANGE=�͈�'#13+
'PALETTE=�p���b�g'#13+
'PALE=�W��'#13+
'STRONG=�Z��'#13+
'GRID SIZE=��د�޻���'#13+
'X=X'#13+
'Z=Z'#13+
'DEPTH=�[��'#13+
'IRREGULAR=�s�K��'#13+
'GRID=�O���b�h'#13+
'VALUE:=�l'#13+
'ALLOW DRAG=�h���b�O��'#13+
'DRAG REPAINT=�h���b�O�̕`��'#13+
'NO LIMIT DRAG=�������h���b�O'#13+
'VERTICAL POSITION=�����ʒu'#13+
'LEVELS POSITION=���x���ʒu'#13+
'LEVELS=���x��'#13+
'NUMBER=��'#13+
'LEVEL=���x��'#13+
'AUTOMATIC=����'#13+
'COLOR EACH=�F�𕪂���'#13+
'STYLE=�X�^�C��'#13+
'SNAP=�ړ�����'#13+
'FOLLOW MOUSE=�}�E�X�ɘA��'#13+
'STACK=�ςݏd��'#13+
'HEIGHT 3D=3D�̍���'#13+
'LINE MODE=���̎��'#13+
'INVERTED=���]'#13+
'DARK 3D=3D�����Â�����'#13+
'OVERLAP=���ްׯ��'#13+
'STACK=�ςݏd��'#13+
'STACK 100%=�S����'#13+
'CLICKABLE=�N���b�N��'#13+
'OUTLINE=���ײ�'#13+
'LABELS=���x��'#13+
'AVAILABLE=�I���\�ȍ���'#13+
'SELECTED=�I�����ꂽ����'#13+
'>=>'#13+
'>>=>>'#13+
'<=<'#13+
'<<=<<'#13+
'DATASOURCE=�ް����'#13+
'GROUP BY=��ٰ��'#13+
'CALC=�v�Z'#13+
'OF=of'#13+
'SUM=�a'#13+
'COUNT=�v�Z'#13+
'HIGH=�ő�'#13+
'LOW=�ŏ�'#13+
'AVG=���ϒl'#13+
'HOUR=����'#13+
'DAY=��'#13+
'WEEK=�T'#13+
'WEEKDAY=�j��'#13+
'MONTH=��'#13+
'QUARTER=�l����'#13+
'YEAR=�N'#13+
'HOLE %=�� %'#13+
'RESET POSITIONS=�ʒu�̃��Z�b�g'#13+
'MOUSE BUTTON=ϳ�����'#13+
'MIDDLE=����'#13+
'ENABLE DRAWING=�`���'#13+
'ENABLE SELECT=�I����'#13+
'ENHANCED=�g��'#13+
'ERROR WIDTH=�G���[�̕�'#13+
'WIDTH UNITS=���̒P��'#13+
'PERCENT=�S����'#13+
'PIXELS=�s�N�Z��'#13+
'RIGHT=�E'#13+
'LEFT AND RIGHT=���ƉE'#13+
'TOP AND BOTTOM=��Ɖ�'#13+
'BORDER=�y��'#13+
'BORDER EDITOR=�y���̐ݒ�'#13+
'SOLID=����'#13+
'DASH=�j��'#13+
'DOT=�_��'#13+
'DASH DOT=��_����'#13+
'DASH DOT DOT=��_����'#13+
'DRAW ALL=�S�ĕ`��'#13+
'CALCULATE EVERY=�v�Z'#13+
'ALL POINTS=�S���̓_'#13+
'NUMBER OF POINTS=�|�C���g�̐�'#13+
'RANGE OF VALUES=�l�͈̔�'#13+
'ALIGNMENT=����'#13+
'FIRST=�ŏ�'#13+
'CENTER=����'#13+
'LAST=�Ō�'#13+
'TEEPREVIEW EDITOR=TeePreview�̐ݒ�'#13+
'ALLOW MOVE=�ړ���'#13+
'ALLOW RESIZE=���T�C�Y��'#13+
'DRAG IMAGE=�Ұ�ނ���ׯ��'#13+
'AS BITMAP=�ޯ�ϯ��'#13+
'SHOW IMAGE=�C���[�W�̕\��'#13+
'PORTRAIT=�c'#13+
'LANDSCAPE=��'#13+
'MARGINS=�]��'#13+
'SIZE=�T�C�Y'#13+
'3D %=3D %'#13+
'ZOOM=�Y�[��'#13+
'ELEVATION=�p'#13+
'100%=100%'#13+
'HORIZ. OFFSET=�����̾��'#13+
'VERT. OFFSET=�����̾��'#13+
'PERSPECTIVE=���ߌ���'#13+
'ANGLE=�p�x'#13+
'ORTHOGONAL=����'#13+
'ZOOM TEXT=÷�Ă�ް�'#13+
'SCALES=�X�P�[��'#13+
'TITLE=�^�C�g��'#13+
'TICKS=�ڐ�'#13+
'MINOR=���ڐ�'#13+
'MAXIMUM=�ő�l'#13+
'MINIMUM=�ŏ��l'#13+
'(MAX)=(max)'#13+
'(MIN)=(min)'#13+
'DESIRED INCREMENT=���҂��鑝����'#13+
'(INCREMENT)=(increment)'#13+
'LOG BASE=�ΐ��̊'#13+
'LOGARITHMIC=�ΐ���'#13+
'AUTO=����'#13+
'CHANGE=�ύX'#13+
'CHANGE=�ύX'#13+
'TITLE=�^�C�g��'#13+
'ANGLE=�p�x'#13+
'MIN. SEPARATION %=�ŏ��Ԋu %'#13+
'VISIBLE=�\��'#13+
'MULTI-LINE=�����s'#13+
'LABEL ON AXIS=�����x��'#13+
'ROUND FIRST=�n�_�ő�����'#13+
'AUTO=����'#13+
'VALUE=�l'#13+
'MARK=�}�[�J'#13+
'LABELS FORMAT=�l�̏���'#13+
'EXPONENTIAL=�w��'#13+
'DEFAULT ALIGNMENT=�f�t�H���g�̔z�u'#13+
'LEN=����'#13+
'TICKS=�ڐ�'#13+
'INNER=����'#13+
'AT LABELS ONLY=���x���̂�'#13+
'CENTERED=�����ɔz�u'#13+
'LENGTH=����'#13+
'COUNT=��'#13+
'TICKS=�ڐ�'#13+
'GRID=�O���b�h'#13+
'POSITION %=�ʒu %'#13+
'START %=�J�n %'#13+
'END %=�I�� %'#13+
'OTHER SIDE=���Α�'#13+
'AXES=��'#13+
'VISIBLE=�\��'#13+
'BEHIND=�w��'#13+
'CLIP POINTS=�د��ݸ�'#13+
'PRINT PREVIEW=�������ޭ�'#13+
'ZOOM=�Y�[��'#13+
'SCROLL=�X�N���[��'#13+
'STEPS=�X�e�b�v'#13+
'MINIMUM PIXELS=�ŏ��s�N�Z��'#13+
'ALLOW=��'#13+
'ANIMATED=��Ұ���'#13+
'PEN=�y��'#13+
'HORIZONTAL=����'#13+
'VERTICAL=����'#13+
'ALLOW SCROLL=���@'#13+
'NONE=�Ȃ�'#13+
'BOTH=����'#13+
'TEEOPENGL EDITOR=TeeOpenGL�̐ݒ�'#13+
'AMBIENT LIGHT=���޴�Č�'#13+
'SHININESS=���邳'#13+
'FONT 3D DEPTH=3D̫�Ă̐[��'#13+
'ACTIVE=�L��'#13+
'FONT OUTLINES=̫�Ă̱��ײ�'#13+
'SMOOTH SHADING=���炩�ȉe'#13+
'LIGHT=��'#13+
'Y=Y'#13+
'INTENSITY=����'#13+
'SYMBOLS=�V���{��'#13+
'TEXT STYLE=÷�Ă̌`��'#13+
'LEGEND STYLE=�}��̌`��'#13+
'VERT. SPACING=���������̽�߰�'#13+
'AUTOMATIC=����'#13+
'SERIES NAMES=�n��̖���'#13+
'SERIES VALUES=�n��̒l'#13+
'LAST VALUES=�Ō�̒l'#13+
'PLAIN=������̂�'#13+
'LEFT VALUE=�l���E��'#13+
'RIGHT VALUE=�l������'#13+
'LEFT PERCENT=�S�������E��'#13+
'RIGHT PERCENT=�S����������'#13+
'X VALUE=X�l'#13+
'PERCENT=�S����'#13+
'X AND VALUE=X�l�ƒl'#13+
'X AND PERCENT=X�l�ƕS����'#13+
'CHECK BOXES=�����ޯ��'#13+
'DIVIDING LINES=������'#13+
'FONT SERIES COLOR=̫�Ă��n��F��'#13+
'POSITION OFFSET %=�ʒu�̵̾�� %'#13+
'MARGIN=�]��'#13+
'RESIZE CHART=�ʒu���킹'#13+
'LEFT=��'#13+
'TOP=��'#13+
'WIDTH UNITS=���̒P��'#13+
'CONTINUOUS=�A��'#13+
'POINTS PER PAGE=1�߰�ނ��߲�Đ�'#13+
'SCALE LAST PAGE=�ŏI�߰�ނ��قɕ\��'#13+
'CURRENT PAGE LEGEND=���݂��߰�ނ̖}��'#13+
'SHOW PAGE NUMBER=�߰�ސ��̕\��'#13+
'PANEL EDITOR=Panel Editor'#13+
'BACKGROUND=�w�i'#13+
'BORDERS=�g'#13+
'COLOR=�F'#13+
'BACK IMAGE=�w�i�C���[�W'#13+
'STRETCH=�X�g���b�`'#13+
'TILE=�^�C��'#13+
'CENTER=����'#13+
'BROWSE=�Q��'#13+
'INSIDE=���̂̓���'#13+
'TRANSPARENT=����'#13+
'WIDTH=��'#13+
'BEVEL INNER=�����x�x��'#13+
'BEVEL OUTER=�O���x�x��'#13+
'LOWERED=��'#13+
'RAISED=��'#13+
'MARKS=�}�[�J'#13+
'DATA SOURCE=�ް����'#13+
'SORT=���בւ�'#13+
'CURSOR=�J�[�\��'#13+
'SHOW IN LEGEND=�}���\������'#13+
'FORMATS=����'#13+
'VALUES=�l'#13+
'PERCENTS=�S����'#13+
'HORIZONTAL AXIS=������'#13+
'TOP AND BOTTOM=��Ɖ�'#13+
'DATETIME=���t����'#13+
'VERTICAL AXIS=������'#13+
'LEFT AND RIGHT=���ƉE'#13+
'DATETIME=���t����'#13+
'ASCENDING=����'#13+
'DESCENDING=�~��'#13+
'DRAW EVERY=�\���Ԋu'#13+
'STYLE=�X�^�C��'#13+
'CLIPPED=�د��ݸ�'#13+
'ARROWS=���o��'#13+
'MULTI LINE=�����s'#13+
'ALL SERIES VISIBLE=�S�n��̕\��'#13+
'VALUE=�l'#13+
'PERCENT=�S����'#13+
'LABEL=���x��'#13+
'LABEL AND PERCENT=���x���ƕS����'#13+
'LABEL AND VALUE=���x���ƒl'#13+
'LEGEND=�}��'#13+
'PERCENT TOTAL=�S�̂ɑ΂��銄��'#13+
'LABEL AND PERCENT TOTAL=���x���Ɗ���'#13+
'X VALUE=X�l'#13+
'X AND Y VALUES=X�l��Y�l'#13+
'MANUAL=�蓮'#13+
'RANDOM=����'#13+
'FUNCTION=�֐�'#13+
'NEW=�V�K'#13+
'EDIT=�ҏW'#13+
'DELETE=�폜'#13+
'PERSISTENT=��������'#13+
'TEXT=�e�L�X�g'#13+
'ADJUST FRAME=�ڰтɍ��킹��'#13+
'CENTER=����'#13+
'SUBTITLE=�T�u�^�C�g��'#13+
'SUBFOOT=�t�b�^�['#13+
'FOOT=�T�u�t�b�^�['#13+
'ACTIVE=�L��'#13+
'VISIBLE WALLS=�ǂ̕\��'#13+
'LEFT=����'#13+
'RIGHT=�E��'#13+
'BOTTOM=����'#13+
'BACK=�w��'#13+
'BORDER=�g'#13+
'DARK 3D=3D�����Â�����'#13+
'DIF. LIMIT=���~�b�g'#13+
'LINES=��'#13+
'ABOVE=�ȏ�'#13+
'WITHIN=�ȓ�'#13+
'BELOW=�ȉ�'#13+
'CONNECTING LINES=�ڑ���'#13+
'HIGH=����'#13+
'LOW=�Ⴂ'#13+
'PATTERN=�p�^�[��'#13+
'BROWSE=�Q��'#13+
'TILED=�^�C��'#13+
'3D=3D'#13+
'INFLATE MARGINS=�߲�Ă̊��S�\��'#13+
'SQUARE=�����`'#13+
'FLAT=����'#13+
'ROUND=��'#13+
'DOWN TRIANGLE=�|���O�p�`'#13+
'STAR=��'#13+
'SMALL DOT=�_'#13+
'DARK 3D=3D�����Â�����'#13+
'DEFAULT=�f�t�H���g'#13+
'GLOBAL=�O���[�o��'#13+
'SHAPES=�`��'#13+
'BRUSH=�u���V'#13+
'GLOBAL=�O���[�o��'#13+
'BRUSH=�u���V'#13+
'GLOBAL=�O���[�o��'#13+
'DELAY=�x������'#13+
'MSEC.=�~���b'#13+
'PERCENT=�S����'#13+
'LABEL=���x��'#13+
'LABEL AND PERCENT=���x���ƕS����'#13+
'LABEL AND VALUE=���x���ƒl'#13+
'LEGEND=�}��'#13+
'PERCENT TOTAL=�S�̂ɑ΂��銄��'#13+
'X VALUE=X�l'#13+
'X AND Y VALUES=X�l��Y�l'#13+
'MOUSE ACTION=�}�E�X�̓���'#13+
'MOVE=�ړ�'#13+
'CLICK=�N���b�N'#13+
'SIZE=�T�C�Y'#13+
'BRUSH=�u���V'#13+
'DRAW LINE=���̕`��'#13+
'EXPLODE BIGGEST=�ő�敪�̕���'#13+
'TOTAL ANGLE=�S�̂̊p�x'#13+
'GROUP SLICES=�O���[�v'#13+
'VALUE=�l'#13+
'LABEL=���x��'#13+
'BELOW %=�w��%����'#13+
'BELOW VALUE=�w��l����'#13+
'OTHER=���̑�'#13+
'PATTERNS=�p�^�[��'#13+
'DEPTH=�[��'#13+
'LINE=��'#13+
'SIZE %=�T�C�Y'#13+
'SERIES DATASOURCE TEXT EDITOR=Series DataSource Text �̐ݒ�'#13+
'FIELDS=�t�B�[���h'#13+
'SOURCE=�\�[�X'#13+
'NUMBER OF HEADER LINES=�w�b�_�[�̍s��'#13+
'SEPARATOR=���ڰ�'#13+
'SERIES=�n��'#13+
'COMMA=�J���}'#13+
'SPACE=�X�y�[�X'#13+
'TAB=�^�u'#13+
'FILE=�t�@�C��'#13+
'WEB URL=URL'#13+
'LOAD=�Ǎ�'#13+
'IMAG. SYMBOL=���������'#13+
'C LABELS=C ���x��'#13+
'R LABELS=R ���x��'#13+
'C PEN=C �y��'#13+
'R PEN=R �y��'#13+
'CIRCLE=�O�~'#13+
'COLOR EACH=�F�𕪂���'#13+
'FONT=�t�H���g'#13+
'STACK GROUP=�ςݏd�˂̸�ٰ��'#13+
'USE ORIGIN=���_���g�p'#13+
'MULTIPLE BAR=����'#13+
'SIDE=���u'#13+
'SIDE ALL=����i�n�񖈁j'#13+
'DRAWING MODE=�`�惂�[�h'#13+
'WIREFRAME=���C���['#13+
'DOTFRAME=�_'#13+
'SMOOTH PALETTE=��گĂ����炩��'#13+
'SIDE BRUSH=���ʃu���V'#13+
'ABOUT TEECHART PRO V6.01=About TeeChart Pro v6.01'#13+
'ALL RIGHTS RESERVED.=All Rights Reserved.'#13+
'STEEMA SOFTWARE=NEWTONE Corp.'#13+
'WWW.STEEMA.COM=http://www.newtone.co.jp/'#13+
'VISIT OUR WEB SITE !=Visit our Web site !'#13+
'TEECHART WIZARD=TeeChart �E�B�U�[�h'#13+
'WWW.STEEMA.COM=www.newtone.co.jp'#13+
'SELECT A CHART STYLE=�`���[�g�̃X�^�C���̑I��'#13+
'DATABASE CHART=�f�[�^�x�[�X�`���[�g'#13+
'NON DATABASE CHART=��f�[�^�x�[�X�`���[�g'#13+
'SELECT A DATABASE TABLE=�f�[�^�x�[�X�e�[�u���̑I��'#13+
'ALIAS=�G���A�X'#13+
'TABLE=�e�[�u����'#13+
'SOURCE=�\�[�X'#13+
'BORLAND DATABASE ENGINE=Borland Database Engine'#13+
'MICROSOFT ADO=Microsoft ADO'#13+
'SELECT THE DESIRED FIELDS TO CHART=�`���[�g�ɐݒ肷�鍀�ڂ̑I��'#13+
'SELECT A TEXT LABELS FIELD=���x���ɂ���������'#13+
'CHOOSE THE DESIRED CHART TYPE=�`���[�g�̑I��'#13+
'2D=2D'#13+
'CHART PREVIEW=�`���[�g�v���r���['#13+
'3D=3D'#13+
'SHOW LEGEND=�}���\��'#13+
'SHOW MARKS=ϰ���\��'#13+
'COLOR EACH=�F�𕪂���'#13+
'< BACK=< �߂�'#13+
'NEXT >=���� >'#13+
'EXPORT CHART=�`���[�g�̃G�N�X�|�[�g'#13+
'PICTURE=�s�N�`���['#13+
'NATIVE=�l�C�e�B�u'#13+
'FORMAT=�`��'#13+
'SIZE=�T�C�Y'#13+
'KEEP ASPECT RATIO=�c�����ۂ�'#13+
'INCLUDE SERIES DATA=�n��f�[�^���܂�'#13+
'FILE SIZE=�t�@�C���T�C�Y'#13+
'SERIES=�n��'#13+
'DELIMITER=�f���~�^'#13+
'XML=XML'#13+
'HTML TABLE=HTML �e�[�u��'#13+
'EXCEL=Excel'#13+
'COLON=�R����'#13+
'CUSTOM=�J�X�^��'#13+
'INCLUDE=�܂߂鍀��'#13+
'POINT LABELS=�߲������'#13+
'POINT INDEX=�߲�Ĳ��ޯ��'#13+
'HEADER=ͯ�ް'#13+
'COPY=�R�s�['#13+
'SAVE=�ۑ�'#13+
'SEND=����'#13+
'FUNCTIONS=�֐�'#13+
'ADD=Add'#13+
'ADX=ADX'#13+
'AVERAGE=Average'#13+
'BOLLINGER=Bollinger'#13+
'COPY=Copy'#13+
'COUNT=Count'#13+
'CUMULATIVE=Cumulative'#13+
'CURVE FITTING=Curve Fitting'#13+
'DIVIDE=Divide'#13+
'EXP. AVERAGE=Exp. Average'#13+
'EXP.MOV.AVRG.=Exp.Mov.Avrg.'#13+
'EXP.TREND=Exp.Trend'#13+
'HIGH=High'#13+
'LOW=Low'#13+
'MACD=MACD'#13+
'MOMENTUM=Momentum'#13+
'MOMENTUM DIV=Momentum Div'#13+
'MOVING AVRG.=Moving Avrg.'#13+
'MULTIPLY=Multiply'#13+
'R.S.I.=R.S.I.'#13+
'ROOT MEAN SQ.=Root Mean Sq.'#13+
'STD.DEVIATION=Std.Deviation'#13+
'STOCHASTIC=Stochastic'#13+
'SUBTRACT=Subtract'#13+
'TREND=Trend'#13+
'SOURCE SERIES=�n��'#13+
'TEECHART GALLERY=TeeChart �M������'#13+
'FUNCTIONS=�֐�'#13+
'STANDARD=�W��'#13+
'FINANCIAL=���Z'#13+
'STATS=���v'#13+
'EXTENDED=�g��'#13+
'OTHER=���̑�'#13+
'DITHER=�f�B�U'#13+
'REDUCTION=���F'#13+
'COMPRESSION=���k'#13+
'LZW=LZW'#13+
'RLE=RLE'#13+
'NEAREST=Nearest'#13+
'FLOYD STEINBERG=Floyd Steinberg'#13+
'STUCKI=Stucki'#13+
'SIERRA=Sierra'#13+
'JAJUNI=JaJuNI'#13+
'STEVE ARCHE=Steve Arche'#13+
'BURKES=Burkes'#13+
'NONE=�Ȃ�'#13+
'WINDOWS 20=Windows 20'#13+
'WINDOWS 256=Windows 256'#13+
'WINDOWS GRAY=Windows Gray'#13+
'MONOCHROME=���m�N��'#13+
'GRAY SCALE=��ڰ����'#13+
'NETSCAPE=Netscape'#13+
'QUANTIZE=Quantize'#13+
'QUANTIZE 256=Quantize 256'#13+
'% QUALITY=% �i��'#13+
'GRAY SCALE=��ڰ����'#13+
'PERFORMANCE=��̫��ݽ'#13+
'QUALITY=�i��'#13+
'SPEED=���x'#13+
'COMPRESSION LEVEL=���k���x��'#13+
'CHART TOOLS GALLERY=Chart Tools �M������'#13+
'ANNOTATION=�A�m�e�[�V����'#13+
'AXIS ARROWS=�����'#13+
'COLOR BAND=�J���[�o���h'#13+
'COLOR LINE=�J���[���C��'#13+
'CURSOR=�J�[�\��'#13+
'DRAG MARKS=�h���b�O�}�[�J'#13+
'DRAW LINE=�h���[���C��'#13+
'IMAGE=�C���[�W'#13+
'MARK TIPS=�}�[�J�`�b�v'#13+
'NEAREST POINT=�ߖT�_'#13+
'PAGE NUMBER=�y�[�W��'#13+
'ROTATE=��]'#13+
'CHART TOOLS GALLERY=Chart Tools �M������'#13+
'OUTLINE=�g'#13+
'USE Y ORIGIN=Y���_���g�p'#13+

{AX 5.0.4}
'COLOR EACH LINE=�F�𕪂����'#13+
'SUBFOOT=�T�u�t�b�^�['#13+
'FOOT=�t�b�^�['#13+
'RADIAL=���ˏ��'#13+
'BUTTON=�{�^��'#13+
'ALL=�S��'#13

{$IFDEF TEEOCX}
+
{ADO Editor}
'TEECHART PRO -- SELECT ADO DATASOURCE=TeeChart Pro -- ADO�f�[�^�\�[�X�̑I��'#13+
'CONNECTION=�ڑ�'#13+
'DATASET=�f�[�^�Z�b�g'#13+
'TABLE=�e�[�u��'#13+
'SQL=SQL'#13+
'SYSTEM TABLES=�V�X�e���e�[�u��'#13+
'LOGIN PROMPT=۸޲� �������'#13+
'SELECT=�I��'#13+
{Import dialogue}
'TEECHART IMPORT=TeeChart �C���|�[�g'#13+
'IMPORT CHART FROM=�C���|�[�g�`���[�g�ꏊ'#13+
'IMPORT NOW=�C���|�[�g'#13+
{Property page}
'EDIT CHART=�`���[�g�̕ҏW'#13
{$ENDIF}
;
  end;
end;

Procedure TeeSetJapanese;
begin
  TeeCreateJapanese;
  TeeLanguage:=TeeJapaneseLanguage;
  TeeJapaneseConstants;
  TeeLanguageHotKeyAtEnd:=True;
  TeeLanguageCanUpper:=False;
end;

initialization
finalization
  FreeAndNil(TeeJapaneseLanguage);
end.
