unit TeeTurkish;
{$I TeeDefs.inc}

interface

Uses Classes;

Var TeeTurkishLanguage:TStringList=nil;

Procedure TeeSetTurkish;
Procedure TeeCreateTurkish;

implementation

Uses SysUtils, TeeTranslate, TeeConst, TeeProCo {$IFNDEF D5},TeCanvas{$ENDIF};

Procedure TeeTurkishConstants;
begin
  { TeeConst }
  TeeMsg_Copyright          :='� 1995-2003 David Berneda';
  TeeMsg_LegendFirstValue   :='�lk A��klay�c� de�eri > 0 olmal�';
  TeeMsg_LegendColorWidth   :='A��klay�c� Renk Geni�li�i %0''dan b�y�k olmal�';
  TeeMsg_SeriesSetDataSource:='Veri kayna��n� do�rulamak i�in gerekli ana grafik mevcut de�il';
  TeeMsg_SeriesInvDataSource:='Ge�erli veri kayna�� mevcut de�il: %s';
  TeeMsg_FillSample         :='FillSampleValues de�er say�s� >0 olmal�';
  TeeMsg_AxisLogDateTime    :='Tarih/Saat tipi eksen logaritmik olamaz';
  TeeMsg_AxisLogNotPositive :='Logaritmik Eksen Minimum ve Maksimum de�erleri > 0 olmal�d�r';
  TeeMsg_AxisLabelSep       :='Etiket aral�k y�zdesi > %0 olmal�';
  TeeMsg_AxisIncrementNeg   :='Eksen art�� birimi > 0 olmal�';
  TeeMsg_AxisMinMax         :='Eksen Minimum De�eri <= Eksen Maksimum De�eri olmal�';
  TeeMsg_AxisMaxMin         :='Eksen Maksimum De�eri  >= Eksen Minimum De�eri olmal�';
  TeeMsg_AxisLogBase        :='Eksen Logaritma Taban� >= 2 olmal�';
  TeeMsg_MaxPointsPerPage   :='Sayfa ba��na maksimum nokta say�s� >= 0 olmal�';
  TeeMsg_3dPercent          :='3B efekt y�zdesi %d ile %d aras�nda olmal�';
  TeeMsg_CircularSeries     :='Dairesel Seri Ba��ml�l��� yasak'; //****/
  TeeMsg_WarningHiColor     :='Daha iyi g�r�nt� i�in 16k veya daha y�ksek renk ��z�n�rl��� gerekli';

  TeeMsg_DefaultPercentOf   :='%s / %s';
  TeeMsg_DefaultPercentOf2  :='%s'+#13+'/ %s';
  TeeMsg_DefPercentFormat   :='##0,## %';
  TeeMsg_DefValueFormat     :='#.##0,###';
  TeeMsg_DefLogValueFormat  :='#,0 "x10" E+0';
  TeeMsg_AxisTitle          :='Eksen Ba�l���';
  TeeMsg_AxisLabels         :='Eksen Etiketleri';
  TeeMsg_RefreshInterval    :='Yenileme Aral��� 0 ile 60 sn aras�nda olmal�';
  TeeMsg_SeriesParentNoSelf :='Series.ParentChart kendim de�ilim!';
  TeeMsg_GalleryLine        :='�izgi';
  TeeMsg_GalleryPoint       :='Nokta';
  TeeMsg_GalleryArea        :='Alan';
  TeeMsg_GalleryBar         :='�ubuk';
  TeeMsg_GalleryHorizBar    :='Yatay �ubuk';
  TeeMsg_Stack              :='Y���n';
  TeeMsg_GalleryPie         :='Elma';
  TeeMsg_GalleryCircled     :='Dairesel';
  TeeMsg_GalleryFastLine    :='H�zl� �izgi';
  TeeMsg_GalleryHorizLine   :='Yatay �izgi';

  TeeMsg_PieSample1         :='Arbalar';
  TeeMsg_PieSample2         :='Telefonlar';
  TeeMsg_PieSample3         :='Masalar';
  TeeMsg_PieSample4         :='Monit�rler';
  TeeMsg_PieSample5         :='Lambalar';
  TeeMsg_PieSample6         :='Klavyeler';
  TeeMsg_PieSample7         :='Bisikletler';
  TeeMsg_PieSample8         :='Sandalyeler';

  TeeMsg_GalleryLogoFont    :='Courier New';
  TeeMsg_Editing            :='%s d�zenleniyor';

  TeeMsg_GalleryStandard    :='Standart';
  TeeMsg_GalleryExtended    :='�lave';
  TeeMsg_GalleryFunctions   :='Fonksiyonlar';

  TeeMsg_EditChart          :='Grafi�i &D�zenle...';
  TeeMsg_PrintPreview       :='&Bask� �ng�r�n�m...';
  TeeMsg_ExportChart        :='Grafi�i &�hra� Et...';
  TeeMsg_CustomAxes         :='Ki�isel Eksenler...';

  TeeMsg_InvalidEditorClass :='%s: D�zenleyici S�n�f� ge�erli de�il: %s';
  TeeMsg_MissingEditorClass :='%s: D�zenleyici Diyalo�una sahip de�il';

  TeeMsg_GalleryArrow       :='Ok';

  TeeMsg_ExpFinish          :='&Bitir';
  TeeMsg_ExpNext            :='&Sonraki >';

  TeeMsg_GalleryGantt       :='Gantt';

  TeeMsg_GanttSample1       :='Dizayn';
  TeeMsg_GanttSample2       :='Prototip';
  TeeMsg_GanttSample3       :='Geli�tirme';
  TeeMsg_GanttSample4       :='Sat��';
  TeeMsg_GanttSample5       :='Pazarlama';
  TeeMsg_GanttSample6       :='Kalite Kontrol';
  TeeMsg_GanttSample7       :='�retim';
  TeeMsg_GanttSample8       :='Hata Ay�klama';
  TeeMsg_GanttSample9       :='Yeni Versiyon';
  TeeMsg_GanttSample10      :='Maliye';

  TeeMsg_ChangeSeriesTitle  :='Seri Ba�l���n� De�i�tir';
  TeeMsg_NewSeriesTitle     :='Yeni Seri Ba�l���:';
  TeeMsg_DateTime           :='Tarih/Saat';
  TeeMsg_TopAxis            :='�st Eksen';
  TeeMsg_BottomAxis         :='Alt Eksen';
  TeeMsg_LeftAxis           :='Sol Eksen';
  TeeMsg_RightAxis          :='Sa� Eksen';

  TeeMsg_SureToDelete       :='%s silinsin mi ?';
  TeeMsg_DateTimeFormat     :='Tarih/Saat Bi�imi:';
  TeeMsg_Default            :='Varsay�lan: ';
  TeeMsg_ValuesFormat       :='De�er &Bi�imi:';
  TeeMsg_Maximum            :='Maksimum';
  TeeMsg_Minimum            :='Minimum';
  TeeMsg_DesiredIncrement   :='�stenen %s Art���';

  TeeMsg_IncorrectMaxMinValue:='Ge�ersiz De�er. Sebep: %s';
  TeeMsg_EnterDateTime      :='Giriniz [G�n Say�s�] [ss:dd:ss]';

  TeeMsg_SureToApply        :='De�i�iklikler uygulans�n m� ?';
  TeeMsg_SelectedSeries     :='(Se�ilen Seri)';
  TeeMsg_RefreshData        :='Veriyi &Yenile';

  TeeMsg_DefaultFontSize    :={$IFDEF LINUX}'10'{$ELSE}'8'{$ENDIF};
  TeeMsg_DefaultEditorSize  :='419';
  TeeMsg_FunctionAdd        :='Toplam';
  TeeMsg_FunctionSubtract   :='��kart';
  TeeMsg_FunctionMultiply   :='�arp';
  TeeMsg_FunctionDivide     :='B�l';
  TeeMsg_FunctionHigh       :='Y�ksek';
  TeeMsg_FunctionLow        :='D���k';
  TeeMsg_FunctionAverage    :='Ortalama';

  TeeMsg_GalleryShape       :='�ekil';
  TeeMsg_GalleryBubble      :='Kabarc�k';
  TeeMsg_FunctionNone       :='Kopyala';

  TeeMsg_None               :='(hi�biri)';

  TeeMsg_PrivateDeclarations:='{ �zel tan�mlar }';
  TeeMsg_PublicDeclarations :='{ Genel tan�mlar }';

  TeeMsg_DefaultFontName    :=TeeMsg_DefaultEngFontName;

  TeeMsg_CheckPointerSize   :='G�sterici b�y�kl��� de�eri s�f�rdan b�y�k olmal�';

  //if folowing three lines  are palette pages in delphi toolbar no change, there is no turkish version of delphi
  tcAdditional              :='Additional'; //tcAdditional              :='Ekstra';
  tcDControls               :='Data Controls';//tcDControls               :='Veri Kontrolleri';
  tcQReport                 :='QReport';//tcQReport                 :='QReport';

  TeeMsg_About              :='TeeChart &Hakk�nda...';

  //Again, programmers use delphi in english usually so for myself I will prefer to use Data Set instead of turkish synonym
  TeeMsg_DataSet            :='Tabla/consulta';//TeeMsg_DataSet            :='Veri K�mesi';
  TeeMsg_AskDataSet         :='&Tabla/consulta:';//TeeMsg_DataSet            :='&Veri K�mesi:';



  TeeMsg_SingleRecord       :='Tek bir kay�t';
  TeeMsg_AskDataSource      :='&Veri K�mesi:';

  TeeMsg_Summary            :='�zet';

  TeeMsg_FunctionPeriod     :='Fonksyion periyodu >= 0 olmal�';

  TeeMsg_TeeChartWizard     :='TeeChart Sihibaz�';

  TeeMsg_ClearImage         :='&Temizle';
  TeeMsg_BrowseImage        :='&G�zat...';

  TeeMsg_WizardSureToClose  :='TeeChart Sihirbaz�n� kapatmak istedi�inize emin misiniz ?';
  TeeMsg_FieldNotFound      :='% alan� mevcut de�il';

  TeeMsg_DepthAxis          :='Derinlik Ekseni';
  TeeMsg_PieOther           :='Di�er';
  TeeMsg_ShapeGallery1      :='abc';
  TeeMsg_ShapeGallery2      :='123';
  TeeMsg_ValuesX            :='X';
  TeeMsg_ValuesY            :='Y';
  TeeMsg_ValuesPie          :='Pasta';
  TeeMsg_ValuesBar          :='�ubuk';
  TeeMsg_ValuesAngle        :='A��';
  TeeMsg_ValuesGanttStart   :='Ba�lang��';
  TeeMsg_ValuesGanttEnd     :='Biti�';
  TeeMsg_ValuesGanttNextTask:='SonrakiG�rev';
  TeeMsg_ValuesBubbleRadius :='Yar��ap';
  TeeMsg_ValuesArrowEndX    :='Biti� X';
  TeeMsg_ValuesArrowEndY    :='Biti� Y';
  TeeMsg_Legend             :='A��klay�c�';
  TeeMsg_Title              :='Ba�l�k';
  TeeMsg_Foot               :='Altl�k';
  TeeMsg_Period		    :='Periyod';
  TeeMsg_PeriodRange        :='Periyod Uzan�m�';
  TeeMsg_CalcPeriod         :='%s hesaplama �ekli:';
  TeeMsg_SmallDotsPen       :='K���k Nokta';

  TeeMsg_InvalidTeeFile     :='*.tee dosyas�ndaki grafik ge�ersiz ';
  TeeMsg_WrongTeeFileFormat :='*.tee dosya bi�imi hatal�';
  TeeMsg_EmptyTeeFile       :='*.tee dosyas� bo�';  { 5.01 }

  {$IFDEF D5}
  TeeMsg_ChartAxesCategoryName   := 'Grafik Eksenleri';
  TeeMsg_ChartAxesCategoryDesc   := 'Grafik Ekseni �zellik ve olaylar�';
  TeeMsg_ChartWallsCategoryName  := 'Grafik Duvarlar�';
  TeeMsg_ChartWallsCategoryDesc  := 'Grafik Duvar �zellik ve olaylar�';
  TeeMsg_ChartTitlesCategoryName := 'Grafik Ba�l�klar�';
  TeeMsg_ChartTitlesCategoryDesc := 'Grafik Ba�l��� �zellik ve olaylar�';
  TeeMsg_Chart3DCategoryName     := '3B Grafik';
  TeeMsg_Chart3DCategoryDesc     := '3B Grafik �zellik ve olaylar�';
  {$ENDIF}

  TeeMsg_CustomAxesEditor       :='Ki�iselle�tir ';
  TeeMsg_Series                 :='Seriler';
  TeeMsg_SeriesList             :='Seriler...';

  TeeMsg_PageOfPages            :='Sayfa %d / %d';
  TeeMsg_FileSize               :='%d byte';

  TeeMsg_First  :='�lk';
  TeeMsg_Prior  :='�nceki';
  TeeMsg_Next   :='Sonraki';
  TeeMsg_Last   :='Son';
  TeeMsg_Insert :='Yeni';
  TeeMsg_Delete :='Sil';
  TeeMsg_Edit   :='D�zenle';
  TeeMsg_Post   :='Kaydet';
  TeeMsg_Cancel :='Vazge�';

  TeeMsg_All    :='(t�m�)'; {las series}
  TeeMsg_Index  :='�ndis';
  TeeMsg_Text   :='Metin';

  TeeMsg_AsBMP        :='&Bitmap olarak';
  TeeMsg_BMPFilter    :='Bitmap (*.bmp)|*.bmp';
  TeeMsg_AsEMF        :='&Metafile olarak';
  TeeMsg_EMFFilter    :='Geli�mi� Metafile  (*.emf)|*.emf|Metafile (*.wmf)|*.wmf';
  TeeMsg_ExportPanelNotSet := '�hra� bi�iminde panel �zelli�i atanmam��.';

  TeeMsg_Normal    :='Normal';
  TeeMsg_NoBorder  :='Kenars�z';
  TeeMsg_Dotted    :='Noktal�';
  TeeMsg_Colors    :='Renkler';
  TeeMsg_Filled    :='Doldurulmu�';
  TeeMsg_Marks     :='��aretler';
  TeeMsg_Stairs    :='Basamaklar';
  TeeMsg_Points    :='Noktalar';
  TeeMsg_Height    :='Y�kseklik';
  TeeMsg_Hollow    :='Oyuk';
  TeeMsg_Point2D   :='2B Nokta';
  TeeMsg_Triangle  :='��gen';
  TeeMsg_Star      :='Y�ld�z';
  TeeMsg_Circle    :='�amber';
  TeeMsg_DownTri   :='A�a�� ��gen';
  TeeMsg_Cross     :='Ha�';
  TeeMsg_Diamond   :='Karo';
  TeeMsg_NoLines   :='�izgisiz';
  TeeMsg_Stack100  :='%100 Y���lm��';
  TeeMsg_Pyramid   :='Piramit';
  TeeMsg_Ellipse   :='Elips';
  TeeMsg_InvPyramid:='Ters Piramit';
  TeeMsg_Sides     :='Kenar';
  TeeMsg_SideAll   :='T�m KenarTodas las caras';
  TeeMsg_Patterns  :='Desenler';
  TeeMsg_Exploded  :='Patlam��';
  TeeMsg_Shadow    :='G�lge';
  TeeMsg_SemiPie   :='Yar�m Pasta';
  TeeMsg_Rectangle :='DikD�rtgen';
  TeeMsg_VertLine  :='Dikey �izgi';
  TeeMsg_HorizLine :='Yatay �izgi';
  TeeMsg_Line      :='�izgi';
  TeeMsg_Cube      :='K�p';
  TeeMsg_DiagCross :='�arp�';

  TeeMsg_CanNotFindTempPath    :='Temp dizini blunamad�';
  TeeMsg_CanNotCreateTempChart :='Temp dosyas� olu�turulam�yor';
  TeeMsg_CanNotEmailChart      :='Grafik e-postalanamad�. Mapi Hatas�: %d';

  TeeMsg_SeriesDelete :='Seri Silme: Seri indisi %d s�n�rlar d���nda (min:0 , max:%d).';

  { 5.02 }
  TeeMsg_AskLanguage  :='&Dil...';

  { TeeProCo }
  TeeMsg_GalleryPolar       :='Polar';
  TeeMsg_GalleryCandle      :='Mum';
  TeeMsg_GalleryVolume      :='Hacim';
  TeeMsg_GallerySurface     :='Y�zey';
  TeeMsg_GalleryContour     :='Kontur';
  TeeMsg_GalleryBezier      :='Bezier';
  TeeMsg_GalleryPoint3D     :='3B Nokta';
  TeeMsg_GalleryRadar       :='Radar';
  TeeMsg_GalleryDonut       :='Simit';
  TeeMsg_GalleryCursor      :='�mle�';
  TeeMsg_GalleryBar3D       :='3B �ubuk';
  TeeMsg_GalleryBigCandle   :='B�y�k Mum';
  TeeMsg_GalleryLinePoint   :='Nokta �izgi';
  TeeMsg_GalleryHistogram   :='Histogram';
  TeeMsg_GalleryWaterFall   :='�ellale';
  TeeMsg_GalleryWindRose    :='R�zgar G�l�';
  TeeMsg_GalleryClock       :='Saat';
  TeeMsg_GalleryColorGrid   :='Renk Izgaras�';
  TeeMsg_GalleryBoxPlot     :='Dikey Kutu';
  TeeMsg_GalleryHorizBoxPlot:='Yatay Kutu';
  TeeMsg_GalleryBarJoin     :='�ubuk Birle�im';
  TeeMsg_GallerySmith       :='Smith';
  TeeMsg_GalleryPyramid     :='Piramit';
  TeeMsg_GalleryMap         :='Harita';

  TeeMsg_PolyDegreeRange     :='Polinom derecesi 1 ile 20 aras�nda olmal�';
  TeeMsg_AnswerVectorIndex   :='Cevap vekt�r indisi 1 ile %d aras�nda olmal�';
  TeeMsg_FittingError        :='Uyarlama hesaplamas� yap�lam�yor';
  TeeMsg_PeriodRange         :='Periyod >= 0 olmal�';
  TeeMsg_ExpAverageWeight    :='�ssel Ort. A��rl��� 0 ile 1 aras�nda olmal�';
  TeeMsg_GalleryErrorBar     :='Hata �ubu�u';
  TeeMsg_GalleryError        :='Hata';
  TeeMsg_GalleryHighLow      :='Y�ksek-D���k';
  TeeMsg_FunctionMomentum    :='Momentum';
  TeeMsg_FunctionMomentumDiv :='Mom.B�l�m�';
  TeeMsg_FunctionExpAverage  :='�ssel Ort.';
  TeeMsg_FunctionMovingAverage:='Hareketli Ort.';
  TeeMsg_FunctionExpMovAve   :='�ssel Hareketli Ort.';
  TeeMsg_FunctionRSI         :='R.S.I.';
  TeeMsg_FunctionCurveFitting:='Kavis Uyarlama';
  TeeMsg_FunctionTrend       :='Trend';
  TeeMsg_FunctionExpTrend    :='�ssel Trend';
  TeeMsg_FunctionLogTrend    :='Logaritmik Trend';
  TeeMsg_FunctionCumulative  :='K�m�latif';
  TeeMsg_FunctionStdDeviation:='Std. Sapma';
  TeeMsg_FunctionBollinger   :='Bollinger';
  TeeMsg_FunctionRMS         :='Root Mean Square';
  TeeMsg_FunctionMACD        :='MACD';
  TeeMsg_FunctionStochastic  :='Stokastik';
  TeeMsg_FunctionADX         :='ADX';

  TeeMsg_FunctionCount       :='Say�';
  TeeMsg_LoadChart           :='TeeChart grafi�i y�kle...';
  TeeMsg_SaveChart           :='TeeChart grafi�i kaydet...';
  TeeMsg_TeeFiles            :='TeeChart Pro dosyalar�';

  TeeMsg_GallerySamples      :='Di�er';
  TeeMsg_GalleryStats        :='�statistik';

  TeeMsg_CannotFindEditor    :='Seri d�zenleyici edit�r formu bulunamad�: %s';

  TeeMsg_CannotLoadChartFromURL:='%s adresinden grafik y�kleme i�leminde hata. Hata Mesaj�: %d';
  TeeMsg_CannotLoadSeriesDataFromURL:='%s adresinden seri verisi y�klemesinde hata. Hata Mesaj�: %d';

  TeeMsg_Test                :='Test Et...';

  TeeMsg_ValuesDate          :='Tarih';
  TeeMsg_ValuesOpen          :='A��l��';
  TeeMsg_ValuesHigh          :='Y�ksek';
  TeeMsg_ValuesLow           :='D���k';
  TeeMsg_ValuesClose         :='Kapan��';
  TeeMsg_ValuesOffset        :='Ofset';
  TeeMsg_ValuesStdError      :='Std.Hata';

  TeeMsg_Grid3D              :='3B Izgara';

  TeeMsg_LowBezierPoints     :='Bezier nokta say�s� > 1 olmal�';

  { TeeCommander component... }

  TeeCommanMsg_Normal   :='Normal';
  TeeCommanMsg_Edit     :='D�zenle';
  TeeCommanMsg_Print    :='Yazd�r';
  TeeCommanMsg_Copy     :='Kopyala';
  TeeCommanMsg_Save     :='Kaydet';
  TeeCommanMsg_3D       :='3B';

  TeeCommanMsg_Rotating :='Rotasyon: %d� Elevasyon: %d�';
  TeeCommanMsg_Rotate   :='D�nd�r';

  TeeCommanMsg_Moving   :='Yatay Ofset: %d Dikey Ofset: %d';
  TeeCommanMsg_Move     :='Ta��';

  TeeCommanMsg_Zooming  :='B�y�t: %d %%';
  TeeCommanMsg_Zoom     :='B�y�t';

  TeeCommanMsg_Depthing :='3B: %d %%';
  TeeCommanMsg_Depth    :='Derinlik'; { 5.01 }

  TeeCommanMsg_Chart    :='Grafik';
  TeeCommanMsg_Panel    :='Panel';

  TeeCommanMsg_RotateLabel:='D�nd�rmek i�in %s ''yi s�r�kleyin'; { 5.01 }
  TeeCommanMsg_MoveLabel  :='Ta��mak i�in %s'' yi s�r�kleyin'; { 5.01 }
  TeeCommanMsg_ZoomLabel  :='B�y�tmek i�in %s'' yi s�r�kleyin'; { 5.01 }
  TeeCommanMsg_DepthLabel :='3B''yi ayarlamak i�in %s''yi s�r�kleyin';

  TeeCommanMsg_NormalLabel:='B�y�tmek i�in Sol d��mesini, kayd�rmak i�in Sa� d��mesini s�r�kleyin';
  TeeCommanMsg_NormalPieLabel:='Pasta dilimini patlatmak i�in o dilimi s�r�kleyin';

  TeeCommanMsg_PieExploding := 'Dilim: %d Patlama: %d %%';

  TeeMsg_TriSurfaceLess:='Nokta say�s� >= 4 olmal�';
  TeeMsg_TriSurfaceAllColinear:='T�m yard�mc� �izgisel veri noktalar�';
  TeeMsg_TriSurfaceSimilar:='Benzer noktalar - i�lemi devam ettiremiyorum';
  TeeMsg_GalleryTriSurface:='��gensel Y�zey';

  TeeMsg_AllSeries := 'T�m Seriler';
  TeeMsg_Edit      := 'D�zenle';

  TeeMsg_GalleryFinancial    :='Finansal';

  TeeMsg_CursorTool    :='�mle�';
  TeeMsg_DragMarksTool :='��aret S�r�kleyici'; { 5.01 }
  TeeMsg_AxisArrowTool :='Eksen Oklar�';
  TeeMsg_DrawLineTool  :='�izgi �izme';
  TeeMsg_NearestTool   :='En Yak�n Nokta';
  TeeMsg_ColorBandTool :='Renk Band�';
  TeeMsg_ColorLineTool :='Renk �izgisi';
  TeeMsg_RotateTool    :='D�nd�r';
  TeeMsg_ImageTool     :='G�r�nt�';
  TeeMsg_MarksTipTool  :='��aret Tavsiyeleri';

  TeeMsg_CantDeleteAncestor  :='�st seviyemi (ancestor) silemiyorum';

  TeeMsg_Load	         :='Y�kle...';
  TeeMsg_DefaultDemoTee  :='http://www.steema.com/demo.tee';
  TeeMsg_NoSeriesSelected:='Seri se�ilmedi';

  { TeeChart Actions }
  TeeMsg_CategoryChartActions  :='Grafik';
  TeeMsg_CategorySeriesActions :='Grafik Serileri';

  TeeMsg_Action3D               :='&3B';
  TeeMsg_Action3DHint           :='2B / 3B anahtar�';
  TeeMsg_ActionSeriesActive     :='&Aktifle�tir';
  TeeMsg_ActionSeriesActiveHint :='Serileri G�ster / Sakla';
  TeeMsg_ActionEditHint         :='Grafi�i D�zenle';
  TeeMsg_ActionEdit             :='&D�zenle...';
  TeeMsg_ActionCopyHint         :='Haf�zaya Kopyala';
  TeeMsg_ActionCopy             :='&Kopyala';
  TeeMsg_ActionPrintHint        :='Grafik bask� �nizleme';
  TeeMsg_ActionPrint            :='&Bask� �nizleme...';
  TeeMsg_ActionAxesHint         :='Eksenleri G�ster / Sakla';
  TeeMsg_ActionAxes             :='&Eksenler';
  TeeMsg_ActionGridsHint        :='Izgaray� G�ster / Sakla';
  TeeMsg_ActionGrids            :='&Izgara';
  TeeMsg_ActionLegendHint       :='A��klay�c�lar� G�ster / Sakla';
  TeeMsg_ActionLegend           :='&A��klay�c�lar';
  TeeMsg_ActionSeriesEditHint   :='Serileri D�zenle';
  TeeMsg_ActionSeriesMarksHint  :='��aretleri G�ster / Sakla';
  TeeMsg_ActionSeriesMarks      :='&��aretler';
  TeeMsg_ActionSaveHint         :='Grafi�i Kaydet';
  TeeMsg_ActionSave             :='&Kaydet...';

  TeeMsg_CandleBar              :='�ubuk';
  TeeMsg_CandleNoOpen           :='A�l��� gizle';
  TeeMsg_CandleNoClose          :='Kapan��� gizle';
  TeeMsg_NoLines                :='�izgileri gizle';
  TeeMsg_NoHigh                 :='Y�kse�i gizle';
  TeeMsg_NoLow                  :='D����� gizle';
  TeeMsg_ColorRange             :='Renk Uzan�m�';
  TeeMsg_WireFrame              :='Tel �er�eve';
  TeeMsg_DotFrame               :='Nokta �er�eve';
  TeeMsg_Positions              :='Pozisyonlar';
  TeeMsg_NoGrid                 :='Izgaray� gizle';
  TeeMsg_NoPoint                :='Noktalar� gizle';
  TeeMsg_NoLine                 :='�izgileri gizle';
  TeeMsg_Labels                 :='Etiketler';
  TeeMsg_NoCircle               :='Daireleri gizle';
  TeeMsg_Lines                  :='�izgiler';
  TeeMsg_Border                 :='S�n�r';

  TeeMsg_SmithResistance      :='Diren�';
  TeeMsg_SmithReactance       :='Reaktans';

  TeeMsg_Column  :='S�tun';

  { 5.01 }
  TeeMsg_Separator            :='Ayra�';
  TeeMsg_FunnelSegment        :='K�s�m ';
  TeeMsg_FunnelSeries         :='Huni';
  TeeMsg_FunnelPercent        :='0.00 %';
  TeeMsg_FunnelExceed         :='Kota a��ld�';
  TeeMsg_FunnelWithin         :=' kota i�inde';
  TeeMsg_FunnelBelow          :=' veya kota alt�nda';
  TeeMsg_CalendarSeries       :='Takvim';
  TeeMsg_DeltaPointSeries     :='Delta Nokta';
  TeeMsg_ImagePointSeries     :='G�r�nt� Nokta';
  TeeMsg_ImageBarSeries       :='G�r�nt� �ubuk';
  TeeMsg_SeriesTextFieldZero  :='SeriesText: Alan indisi s�f�rdan b�y�k olmal�d�r.';

  { 5.02 } { Moved from TeeImageConstants.pas unit }

  TeeMsg_AsJPEG        :='&JPEG olarak';
  TeeMsg_JPEGFilter    :='JPEG dosyalar� (*.jpg)|*.jpg';
  TeeMsg_AsGIF         :='&GIF olarak';
  TeeMsg_GIFFilter     :='GIF dosyalar� (*.gif)|*.gif';
  TeeMsg_AsPNG         :='&PNG olarak';
  TeeMsg_PNGFilter     :='PNG dosyalar� (*.png)|*.png';
  TeeMsg_AsPCX         :='PC&X olarak';
  TeeMsg_PCXFilter     :='PCX dosyalar� (*.pcx)|*.pcx';
  TeeMsg_AsVML         :='&VML (HTM) olarak';
  TeeMsg_VMLFilter     :='VML dosyalar� (*.htm)|*.htm';

  { 5.02 }
  TeeMsg_Origin               := 'Ba�lang��';
  TeeMsg_Transparency         := 'Saydaml�k';
  TeeMsg_Box		      := 'Kutu';
  TeeMsg_ExtrOut	      := 'ExtrOut';
  TeeMsg_MildOut	      := 'MildOut';
  TeeMsg_PageNumber	      := 'Sayfa No';
  TeeMsg_TextFile             := 'Metin Dosya';

  { 5.03 }
  TeeMsg_DragPoint            := 'Drag Point';
  TeeMsg_OpportunityValues    := 'OpportunityValues';
  TeeMsg_QuoteValues          := 'QuoteValues';

// 6.0
// TeeConst

  TeeMsg_FunctionCustom   :='y = f(x)';
  TeeMsg_AsPDF            :='&PDF olarak';
  TeeMsg_PDFFilter        :='PDF dosyalar� (*.pdf)|*.pdf';
  TeeMsg_AsPS             :='PostScript olarak';
  TeeMsg_PSFilter         :='PostScript dosyalar� (*.eps)|*.eps';
  TeeMsg_GalleryHorizArea :='Yatay'#13'Alan';
  TeeMsg_SelfStack        :='Kendi �zerine Y���lm��';
  TeeMsg_DarkPen          :='Koyu Kenar';
  TeeMsg_SelectFolder     :='Veritaban� klas�r�n� se�';
  TeeMsg_BDEAlias         :='&Alias:';   // Turkish translation is not proper
  TeeMsg_ADOConnection    :='&Ba�lant�';

// TeeProCo

  TeeMsg_FunctionSmooth       :='Yumu�atma';
  TeeMsg_FunctionCross        :='Kesi�me Noktalar�';
  TeeMsg_GridTranspose        :='3B Izgara Transpozesi';
  TeeMsg_FunctionCompress     :='S�k��t�rma';
  TeeMsg_ExtraLegendTool      :='Extra A��klay�c�';
  TeeMsg_FunctionCLV          :='Kapan�� Konum'#13'De�eri';
  TeeMsg_FunctionOBV          :='On Balance'#13'Volume';
  TeeMsg_FunctionCCI          :='Commodity'#13'Channel Index';
  TeeMsg_FunctionPVO          :='Volume'#13'Oscillator';
  TeeMsg_SeriesAnimTool       :='Seri Animasyonu';
  TeeMsg_GalleryPointFigure   :='Point & Figure';
  TeeMsg_Up                   :='Yukar�';
  TeeMsg_Down                 :='A�a��';
  TeeMsg_GanttTool            :='Gantt S�r�kle';
  TeeMsg_XMLFile              :='XML dosya';
  TeeMsg_GridBandTool         :='Izgara ve Bant arac�';
  TeeMsg_FunctionPerf         :='Performans';
  TeeMsg_GalleryGauge         :='Gauge';
  TeeMsg_GalleryGauges        :='Gauges';
  TeeMsg_ValuesVectorEndZ     :='Biti�';
  TeeMsg_GalleryVector3D      :='Vekt�r 3B';
  TeeMsg_Gallery3D            :='3B';
  TeeMsg_GalleryTower         :='Kule';
  TeeMsg_SingleColor          :='Tek Renk';
  TeeMsg_Cover                :='Kapla';
  TeeMsg_Cone                 :='Koni';
  TeeMsg_PieTool              :='Elma Dilimleri';

end;

Procedure TeeCreateTurkish;
begin
  if not Assigned(TeeTurkishLanguage) then
  begin
    TeeTurkishLanguage:=TStringList.Create;
    TeeTurkishLanguage.Text:=

'LABELS=Etiketler'+#13+
'DATASET=Veri K�mesi'+#13+
'ALL RIGHTS RESERVED.=T�m haklar� sakl�d�r.'+#13+
'APPLY=Uygula'+#13+
'CLOSE=Kapat'+#13+
'OK=Tamam'+#13+
'ABOUT TEECHART PRO V5.03=TeeChart Pro s�r�m 5.03 hakk�nda'+#13+
'OPTIONS=Se�imler'+#13+
'FORMAT=Bi�im'+#13+
'TEXT=Metin'+#13+
'GRADIENT=E�im'+#13+
'SHADOW=G�lge'+#13+
'POSITION=Pozisyon'+#13+
'LEFT=Sol'+#13+
'TOP=�st'+#13+
'CUSTOM=Ki�isel'+#13+
'PEN=Kalem'+#13+
'PATTERN=Desen'+#13+
'SIZE=Boyut'+#13+
'BEVEL=Y�kselti'+#13+
'INVERTED=Ters'+#13+
'INVERTED SCROLL=Ters Kayd�rma'+#13+
'BORDER=S�n�r'+#13+
'ORIGIN=Ba�lang��'+#13+
'USE ORIGIN=Kullan�lacak Ba�lang��'+#13+
'AREA LINES=Alan �izgileri'+#13+
'AREA=Alan'+#13+
'COLOR=Renk'+#13+
'SERIES=Seriler'+#13+
'SUM=Toplam'+#13+
'DAY=G�n'+#13+
'QUARTER=�eyrek'+#13+
'(MAX)=(maks)'+#13+
'(MIN)=(min)'+#13+
'VISIBLE=G�r�n�r'+#13+
'CURSOR=�mle�'+#13+
'GLOBAL=Global'+#13+
'X=X'+#13+
'Y=Y'+#13+
'Z=Z'+#13+
'3D=3B'+#13+
'HORIZ. LINE=Yatay �izgi'+#13+
'LABEL AND PERCENT=Etiket ve Y�zde'+#13+
'LABEL AND VALUE=Etiket ve De�er'+#13+
'LABEL AND PERCENT TOTAL=Etiket ve Y�zde Toplam'+#13+
'PERCENT TOTAL=Y�zde Toplam'+#13+
'MSEC.=msan.'+#13+
'SUBTRACT=��kart'+#13+
'MULTIPLY=�arp'+#13+
'DIVIDE=B�l'+#13+
'STAIRS=Basamaklar'+#13+
'MOMENTUM=Momentum'+#13+
'AVERAGE=Ortalama'+#13+
'XML=XML'+#13+
'HTML TABLE=HTML Tablosu'+#13+
'EXCEL=Excel'+#13+
'NONE=Hi�biri'+#13+
'(NONE)=Hi�biri'#13+
'WIDTH=Geni�lik'+#13+
'HEIGHT=Y�kseklik'+#13+
'COLOR EACH=Herbirini Renklendir'+#13+
'STACK=Y���n'+#13+
'STACKED=Y���lm��'+#13+
'STACKED 100%=%100 y���lm��'+#13+
'AXIS=Eksen'+#13+
'LENGTH=Uzunluk'+#13+
'CANCEL=Vazge�'+#13+
'SCROLL=Kayd�r'+#13+
'INCREMENT=Art��'+#13+
'VALUE=De�er'+#13+
'STYLE=Stil'+#13+
'JOIN=Birle�tir'+#13+
'AXIS INCREMENT=Eksen Art���'+#13+
'AXIS MAXIMUM AND MINIMUM=Eksen Maksimum ve minimumu'+#13+
'% BAR WIDTH=% �ubuk Geni�li�i %'+#13+
'% BAR OFFSET=% �ubuk Ofseti'+#13+
'BAR SIDE MARGINS=�ubuk Yan Marjinleri'+#13+
'AUTO MARK POSITION=Otomatik ��aret Pozisyonlar�.'+#13+
'DARK BAR 3D SIDES=Koyu �ubuk 3B Yanlar�'+#13+
'MONOCHROME=Tek Renkli'+#13+
'COLORS=Renkler'+#13+
'DEFAULT=Varsay�lan'+#13+
'MEDIAN=Medyan'+#13+
'IMAGE=G�r�nt�'+#13+
'DAYS=G�nler'+#13+
'WEEKDAYS=�� G�nleri'+#13+
'TODAY=Bug�n'+#13+
'SUNDAY=Pazar'+#13+
'MONTHS=Aylar'+#13+
'LINES=�izgiler'+#13+
'UPPERCASE=B�y�k Harf'+#13+
'STICK=Mum'+#13+
'CANDLE WIDTH=Mum Geni�li�i'+#13+
'BAR=�ubuk'+#13+
'OPEN CLOSE=A��l�� Kapan��'+#13+
'DRAW 3D=3B �iz'+#13+
'DARK 3D=Koyu 3B'+#13+
'SHOW OPEN=A��l��� g�ster'+#13+
'SHOW CLOSE=Kapan��� G�ster'+#13+
'UP CLOSE=Y�kselen Kapan��'+#13+
'DOWN CLOSE=D��en Kapan��'+#13+
'CIRCLED=Dairesel'+#13+
'CIRCLE=Daire'+#13+
'3 DIMENSIONS=3 Boyutlu'+#13+
'ROTATION=Rotasyon'+#13+
'RADIUS=Yar��ap'+#13+
'HOURS=Saatler'+#13+
'HOUR=Saat'+#13+
'MINUTES=Dakikalar'+#13+
'SECONDS=Saniyeler'+#13+
'FONT=Yaz� Tipi'+#13+
'INSIDE=�� K�s�m'+#13+
'ROTATED=D�nd�r�lm��'+#13+
'ROMAN=Roma'+#13+
'TRANSPARENCY=Saydaml�k'+#13+
'DRAW BEHIND=Arkaya �iz'+#13+
'RANGE=Uzan�m'+#13+
'PALETTE=Palet'+#13+
'STEPS=Ad�mlar'+#13+
'GRID=Izgara'+#13+
'GRID SIZE=Izgara Boyu'+#13+
'ALLOW DRAG=S�r�klemeye �zin Ver'+#13+
'AUTOMATIC=Otomatik'+#13+
'LEVEL=Seviye'+#13+
'LEVELS POSITION=Seviye Pozisyonu'+#13+
'SNAP=Tuttur'+#13+
'FOLLOW MOUSE=Fareyi �zle'+#13+
'TRANSPARENT=Saydam'+#13+
'ROUND FRAME=Oval �er�eve'+#13+
'FRAME=�er�eve'+#13+
'START=Ba�lang��'+#13+
'END=Biti�'+#13+
'MIDDLE=Orta'+#13+
'NO MIDDLE=Orta Yok'+#13+
'DIRECTION=Y�n'+#13+
'DATASOURCE=Veri Kayna��'+#13+
'AVAILABLE=Mevcut'+#13+
'SELECTED=Se�ilen'+#13+
'CALC=Hesapla'+#13+
'GROUP BY=Grupla'+#13+
'OF=/'+#13+
'HOLE %=Delik %'+#13+
'RESET POSITIONS=Pozisyonlar� S�f�rla'+#13+
'MOUSE BUTTON=Fare Butonu'+#13+
'ENABLE DRAWING=�izime �zin Ver'+#13+
'ENABLE SELECT=Se�ime �zin Ver'+#13+
'ORTHOGONAL=Ortagonal'+#13+
'ANGLE=A��'+#13+
'ZOOM TEXT=Metni B�y�t'+#13+
'PERSPECTIVE=Perspektif'+#13+
'ZOOM=B�y�t'+#13+
'ELEVATION=Y�kseklik'+#13+
'BEHIND=Arkada'+#13+
'AXES=Eksenler'+#13+
'SCALES=�l�ekler'+#13+
'TITLE=Ba�l�k'+#13+
'TICKS=Tikler'+#13+
'MINOR=Min�r'+#13+
'CENTERED=Ortal�'+#13+
'CENTER=Orta'+#13+
'PATTERN COLOR EDITOR=Desen Renk D�zenleyici'+#13+
'START VALUE=Ba�lang�� De�eri'+#13+
'END VALUE=Biti� De�eri'+#13+
'COLOR MODE=Renk Modu'+#13+
'LINE MODE=�izgi Modu'+#13+
'HEIGHT 3D=3B Y�kseklik'+#13+
'OUTLINE=S�n�r'+#13+
'PRINT PREVIEW=Bask� �nizleme'+#13+
'ANIMATED=Hareketli'+#13+
'ALLOW=�zin Ver'+#13+
'DASH=K�sa �izgi'+#13+
'DOT=Nokta'+#13+
'DASH DOT DOT=�izgi Nokta Nokta'+#13+
'PALE=Soluk'+#13+
'STRONG=Parlak'+#13+
'WIDTH UNITS=Birim'+#13+
'FOOT=Altl�k'+#13+
'SUBFOOT=�kincil Altl�k'+#13+
'SUBTITLE=Alt Ba�l�k'+#13+
'LEGEND=A��klay�c�'+#13+
'COLON=Kolon'+#13+
'AXIS ORIGIN=Eksen Ba�lang�c�'+#13+
'UNITS=Birim'+#13+
'PYRAMID=Piramit'+#13+
'DIAMOND=Karo'+#13+
'CUBE=K�p'+#13+
'TRIANGLE=��gen'+#13+
'STAR=Y�ld�z'+#13+
'SQUARE=Kare'+#13+
'DOWN TRIANGLE=A�a�� ��gen'+#13+
'SMALL DOT=Noktac�k'+#13+
'LOAD=Y�kle'+#13+
'FILE=Dosya'+#13+
'RECTANGLE=Dikd�rtgen'+#13+
'HEADER=Ba�l�k'+#13+
'CLEAR=Temizle'+#13+
'ONE HOUR=Bir Saat'+#13+
'ONE YEAR=Bir Y�l'+#13+
'ELLIPSE=Elips'+#13+
'CONE=Koni'+#13+
'ARROW=Ok'+#13+
'CYLLINDER=Silindir'+#13+
'TIME=Zaman'+#13+
'BRUSH=F�r�a'+#13+
'LINE=�izgi'+#13+
'VERTICAL LINE=Dikey �izgi'+#13+
'AXIS ARROWS=Eksen Oklar�'+#13+
'MARK TIPS=��aret Tavsiyeleri'+#13+
'DASH DOT=�izgi Nokta'+#13+
'COLOR BAND=Renk Band�'+#13+
'COLOR LINE=Renk �izgisi'+#13+
'INVERT. TRIANGLE=Ters ��gen'+#13+
'INVERT. PYRAMID=Ters Piramit'+#13+
'INVERTED PYRAMID=Ters Piramit'+#13+
'SERIES DATASOURCE TEXT EDITOR=Seri veri kayna�� d�zenleyicisi'+#13+
'SOLID=Yekpare'+#13+
'WIREFRAME=Tel �er�eve'+#13+
'DOTFRAME=Noktalar'+#13+
'SIDE BRUSH=Yanal F�r�a'+#13+
'SIDE=Yan'+#13+
'SIDE ALL=T�m Yanlar'+#13+
'ANNOTATION=Not'+#13+
'ROTATE=D�nd�r'+#13+
'SMOOTH PALETTE=Yumu�ak Palet'+#13+
'CHART TOOLS GALLERY=Grafik Ara� Galerisi'+#13+
'ADD=Ekle'+#13+
'BORDER EDITOR=S�n�r D�zenleyici'+#13+
'DRAWING MODE=�izim Modu'+#13+
'CLOSE CIRCLE=Kapal� Daire'+#13+
'PICTURE=Resim'+#13+
'NATIVE=Yerel'+#13+
'DATA=Veri'+#13+
'KEEP ASPECT RATIO=Kenar Uzunluk Oranlar�n� Koru'+#13+
'COPY=Kopyala'+#13+
'SAVE=Kaydet'+#13+
'SEND=G�nder'+#13+
'INCLUDE SERIES DATA=Seri Verisini Dahil Et'+#13+
'FILE SIZE=Dosya Boyutu'+#13+
'INCLUDE=Dahil Et'+#13+
'POINT INDEX=Nokta �ndisi'+#13+
'POINT LABELS=Nokta Etiketleri'+#13+
'DELIMITER=Ayra�'+#13+
'DEPTH=Derinlik'+#13+
'COMPRESSION LEVEL=S�k��t�rma Seviyesi'+#13+
'COMPRESSION=S�k��t�rma'+#13+
'PATTERNS=Desenler'+#13+
'LABEL=Etiket'+#13+
'GROUP SLICES=Grup B�l�mleri'+#13+
'EXPLODE BIGGEST=En B�y��� Patlat'+#13+
'TOTAL ANGLE=Toplam A��'+#13+
'HORIZ. SIZE=Yatay Boyut'+#13+
'VERT. SIZE=Dikey Boyut'+#13+
'SHAPES=�ekiller'+#13+
'INFLATE MARGINS=Marjinleri Geni�let'+#13+
'QUALITY=Kalite'+#13+
'SPEED=H�z'+#13+
'% QUALITY=Kalite Y�zdesi'+#13+
'GRAY SCALE=Gri �l�ek'+#13+
'PERFORMANCE=Performans'+#13+
'BROWSE=G�zat'+#13+
'TILED=Mozayik'+#13+
'HIGH=Y�ksek'+#13+
'LOW=D���k'+#13+
'DATABASE CHART=Veritaban� Grafi�i'+#13+
'NON DATABASE CHART=Veritaban� Olmayan Grafik'+#13+
'HELP=Yard�m'+#13+
'NEXT >=�leri >'+#13+
'< BACK=< Geri'+#13+
'TEECHART WIZARD=TeeChart Sihirbaz�'+#13+
'PERCENT=Y�zde'+#13+
'PIXELS=Piksel'+#13+
'ERROR WIDTH=Hata Geni�li�i'+#13+
'ENHANCED=Geli�mi�'+#13+
'VISIBLE WALLS=G�r�n�r Duvarlar'+#13+
'ACTIVE=Aktif'+#13+
'DELETE=Sil'+#13+
'ALIGNMENT=Hiza'+#13+
'ADJUST FRAME=�er�eveyi Ayarla'+#13+
'HORIZONTAL=Yatay'+#13+
'VERTICAL=Dikey'+#13+
'VERTICAL POSITION=Dikey Pozisyon'+#13+
'NUMBER=Say�'+#13+
'LEVELS=Seviyeler'+#13+
'OVERLAP=�st�ste Bindir'+#13+
'STACK 100%=%100 Y���nla'+#13+
'MOVE=Ta��'+#13+
'CLICK=T�kla'+#13+
'DELAY=Gecikme'+#13+
'DRAW LINE=�izgi �iz'+#13+
'FUNCTIONS=Fonksyiyonlar'+#13+
'SOURCE SERIES=Kaynak Seriler'+#13+
'ABOVE=�st'+#13+
'BELOW=Alt'+#13+
'Dif. Limit=Fark Limiti'+#13+
'WITHIN=��inde'+#13+
'EXTENDED=Uzat�lm��'+#13+
'STANDARD=Standart'+#13+
'STATS=�stistik'+#13+
'FINANCIAL=F�nsnsal'+#13+
'OTHER=Di�er'+#13+
'TEECHART GALLERY=TeeChart Galerisi'+#13+
'CONNECTING LINES=Noktalar� Birle�tir'+#13+
'REDUCTION=Azaltma'+#13+
'LIGHT=I��k'+#13+
'INTENSITY=Yo�unluk'+#13+
'FONT OUTLINES=Yaz� S�n�rlar�'+#13+
'SMOOTH SHADING=Yumu�ak G�lgeleme'+#13+
'AMBIENT LIGHT=�evre I����'+#13+
'MOUSE ACTION=Fare Hareketi'+#13+
'CLOCKWISE=Saat Y�n�'+#13+
'ANGLE INCREMENT=A�� Art���'+#13+
'RADIUS INCREMENT=Yar��ap Art���'+#13+
'PRINTER=Yaz�c�'+#13+
'SETUP=Ayarlar'+#13+
'ORIENTATION=Oryantasyon'+#13+
'PORTRAIT=Dikey'+#13+
'LANDSCAPE=Yatay'+#13+
'MARGINS (%)=Marjinler (%)'+#13+
'MARGINS=Marjinler'+#13+
'DETAIL=Detay'+#13+
'MORE=Daha'+#13+
'PROPORTIONAL=Orant�l�'+#13+
'VIEW MARGINS=Marjinleri G�ster'+#13+
'RESET MARGINS=Marjinleri S�f�rla'+#13+
'PRINT=Yazd�r'+#13+
'TEEPREVIEW EDITOR=Bask� �nizleme D�zenleyicisi'+#13+
'ALLOW MOVE=Ta��maya �zin ver'+#13+
'ALLOW RESIZE=Boyut De�i�tirmeye �zin Ver'+#13+
'SHOW IMAGE=G�r�nt�y� G�ster'+#13+
'DRAG IMAGE=G�r�nt�y� �iz'+#13+
'AS BITMAP=Bitmap olarak'+#13+
'SIZE %=Boyut %'+#13+
'FIELDS=Alanlar'+#13+
'SOURCE=Kaynak'+#13+
'SEPARATOR=Ayra�'+#13+
'NUMBER OF HEADER LINES=Ba�l�k sat�r say�s�'+#13+
'COMMA=Virg�l'+#13+
'EDITING=D�zenliyor'+#13+
'TAB=�izelgeleme'+#13+
'SPACE=Bo�luk'+#13+
'ROUND RECTANGLE=Oval Dikd�rtgen'+#13+
'BOTTOM=Alt'+#13+
'RIGHT=Sa�'+#13+
'C PEN=C Kalem'+#13+
'R PEN=R Kalem'+#13+
'C LABELS=C Etiketler'+#13+
'R LABELS=R Etiketler'+#13+
'MULTIPLE BAR=Birden �ok �ubuk'+#13+
'MULTIPLE AREAS=Birden �ok Alan'+#13+
'STACK GROUP=Y���n Grubu'+#13+
'BOTH=�kisi de'+#13+
'BACK DIAGONAL=Ters Diyagonal'+#13+
'B.DIAGONAL=Ters Diyagonal'+#13+
'DIAG.CROSS=Diyagonal Ha�'+#13+
'WHISKER=Kedi B�y���'+#13+
'CROSS=Ha�'+#13+
'DIAGONAL CROSS=Diyagonal Ha�'+#13+
'LEFT RIGHT=Sol Sa�'+#13+
'RIGHT LEFT=Sa� Sol'+#13+
'FROM CENTER=Merkezden'+#13+
'FROM TOP LEFT=Sol �stten'+#13+
'FROM BOTTOM LEFT=Sa� Alttan'+#13+
'SHOW WEEKDAYS=��g�nlerini G�ster'+#13+
'SHOW MONTHS=Aylar� G�ster'+#13+
'SHOW PREVIOUS BUTTON=�nceki Butonunu G�ster'#13+
'SHOW NEXT BUTTON=Ver Sonraki Butonunu G�ster'#13+
'TRAILING DAYS=�zleyen G�nler'+#13+
'SHOW TODAY=Bug�n� G�ster'+#13+
'TRAILING=�zleyen'+#13+
'LOWERED=Al�alt�lm��'+#13+
'RAISED=Y�kseltilmi�'+#13+
'HORIZ. OFFSET=Yatay Ofset'+#13+
'VERT. OFFSET=Dikey Ofset'+#13+
'INNER=Dahili'+#13+
'LEN=Uzunluk'+#13+
'AT LABELS ONLY=Sadece etiketlerde'+#13+
'MAXIMUM=Maksimum'+#13+
'MINIMUM=Minimum'+#13+
'CHANGE=De�i�tir'+#13+
'LOGARITHMIC=Logaritmik'+#13+
'LOG BASE=Log. Taban�'+#13+
'DESIRED INCREMENT=�stenen Art��'+#13+
'(INCREMENT)=(Art��)'+#13+
'MULTI-LINE=�oklu-�izgi'+#13+
'MULTI LINE=�oklu �izgi'+#13+
'RESIZE CHART=Grafi�i Yeniden Boyutland�r'+#13+
'X AND PERCENT=X ve Y�zde'+#13+
'X AND VALUE=X ve De�er'+#13+
'RIGHT PERCENT=Da� Y�zde'+#13+
'LEFT PERCENT=Sol Y�zde'+#13+
'LEFT VALUE=Sol De�er'+#13+
'RIGHT VALUE=Sa� De�er'+#13+
'PLAIN=Sade'+#13+
'LAST VALUES=Son De�erler'+#13+
'SERIES VALUES=Seri De�erleri'+#13+
'SERIES NAMES=Seri Adlar�'+#13+
'NEW=Yeni'+#13+
'EDIT=D�zenle'+#13+
'PANEL COLOR=Panel Rengi'+#13+
'TOP BOTTOM=�st Alt'+#13+
'BOTTOM TOP=Alt �st'+#13+
'DEFAULT ALIGNMENT=Varsay�lan Hizalama'+#13+
'EXPONENTIAL=�ssel'+#13+
'LABELS FORMAT=Etiket Bi�imi'+#13+
'MIN. SEPARATION %=Min. Ayr�kl�k %'+#13+
'YEAR=Y�l'+#13+
'MONTH=Ay'+#13+
'WEEK=Hafta'+#13+
'WEEKDAY=�� G�n�'+#13+
'MARK=��aret'+#13+
'ROUND FIRST=�lkini Yuvarla'+#13+
'LABEL ON AXIS=Eksen �zerinde Etiket'+#13+
'COUNT=Say�'+#13+
'POSITION %=Pozisyon %'+#13+
'START %=Ba�lang�� %'+#13+
'END %=Biti� %'+#13+
'OTHER SIDE=Di�er Taraf'+#13+
'INTER-CHAR SPACING=Harfler aras� bo�luk'+#13+
'VERT. SPACING=Dikey Bo�luk'+#13+
'POSITION OFFSET %=Pozisyon Ofseti %'+#13+
'GENERAL=Genel'+#13+
'MANUAL=Manuel'+#13+
'PERSISTENT=Kal�c�'+#13+
'PANEL=Panel'+#13+
'ALIAS=Lakab'+#13+
'2D=2B'+#13+
'ADX=ADX'+#13+
'BOLLINGER=Bollinger'+#13+
'TEEOPENGL EDITOR=OpenGL D�zenleyici'+#13+
'FONT 3D DEPTH=Yaz�tip 3B Derinli�i'+#13+
'NORMAL=Normal'+#13+
'TEEFONT EDITOR=Yaz� Tipi D�zenleyici'+#13+
'CLIP POINTS=Noktalar� Kes'+#13+
'CLIPPED=Kesilmi�'+#13+
'3D %=3B %'+#13+
'QUANTIZE=Nicelendir'+#13+
'QUANTIZE 256=Nicelendir 256'+#13+
'DITHER=Dither'+#13+
'VERTICAL SMALL=K���k Dikey'+#13+
'HORIZ. SMALL=K���k Yatay'+#13+
'DIAG. SMALL=K���k Diyagonal'+#13+
'BACK DIAG. SMALL=Ters K���k Diyagonal'+#13+
'DIAG. CROSS SMALL=Diyagonal K���k Ha�'+#13+
'MINIMUM PIXELS=Minimum Pixel Say�s�'+#13+
'ALLOW SCROLL=Kayd�rmaya �zin Ver'+#13+
'SWAP=De�i�tir'+#13+
'GRADIENT EDITOR=E�imli Renk D�zenleyici'+#13+
'TEXT STYLE=Metin Stili'+#13+
'DIVIDING LINES=B�l�m �izgileri'+#13+
'SYMBOLS=Semboller'+#13+
'CHECK BOXES=Onaylama Kutucu�u'+#13+
'FONT SERIES COLOR=Seri Rengi'+#13+
'LEGEND STYLE=A��klay�c� Stili'+#13+
'POINTS PER PAGE=Sayfa Ba��na Nokta'+#13+
'SCALE LAST PAGE=Son Sayfay� �l�eklendir'+#13+
'CURRENT PAGE LEGEND=�uanki Sayfa A��klay�c�lar�'+#13+
'BACKGROUND=Arka Plan'+#13+
'BACK IMAGE=Arka Plan Resmi'+#13+
'STRETCH=Ger'+#13+
'TILE=Mozayik'+#13+
'BORDERS=S�n�rlar'+#13+
'CALCULATE EVERY=Hesaplama Peryodu'+#13+
'NUMBER OF POINTS=Nokta Say�s�'+#13+
'RANGE OF VALUES=De�er Uzan�mlar�'+#13+
'FIRST=�lk'+#13+
'LAST=Son'+#13+
'ALL POINTS=T�m Noktalar'+#13+
'DATA SOURCE=Veri Kayna��'+#13+
'WALLS=Duvarlar'+#13+
'PAGING=Sayfalama'+#13+
'CLONE=Klonla'+#13+
'TITLES=Ba�l�klar'+#13+
'TOOLS=Ara�lar'+#13+
'EXPORT=�hra� Et'+#13+
'CHART=Grafik'+#13+
'BACK=Arka'+#13+
'LEFT AND RIGHT=Sol ve Sa�'+#13+
'SELECT A CHART STYLE=Bir grafik stili se�iniz'+#13+
'SELECT A DATABASE TABLE=Bir veritaban� tablosu se�iniz'+#13+
'TABLE=Tablo'+#13+
'SELECT THE DESIRED FIELDS TO CHART=Grafikten istenen alan� se�iniz'+#13+
'SELECT A TEXT LABELS FIELD=Etiket alan� se�iniz'+#13+
'CHOOSE THE DESIRED CHART TYPE=�stenen grafik tipini se�iniz'+#13+
'CHART PREVIEW=Grafik �ng�r�n�m'+#13+
'SHOW LEGEND=A��klay�c�lar� G�ster'+#13+
'SHOW MARKS=��aretleri G�ster'+#13+
'FINISH=Bitir'+#13+
'RANDOM=Rasgele'+#13+
'DRAW EVERY=�izim Peryodu'+#13+
'ARROWS=Oklar'+#13+
'ASCENDING=Artan'+#13+
'DESCENDING=Azalan'+#13+
'VERTICAL AXIS=Dikey Eksen'+#13+
'DATETIME=Tarih/Saat'+#13+
'TOP AND BOTTOM=�st ve Alt'+#13+
'HORIZONTAL AXIS=Yatay Eksen'+#13+
'PERCENTS=Y�zdeler'+#13+
'VALUES=De�erler'+#13+
'FORMATS=Bi�imler'+#13+
'SHOW IN LEGEND=A��klay�c�da G�ster'+#13+
'SORT=S�rala'+#13+
'MARKS=��aretler'+#13+
'BEVEL INNER=�� Seviyelendirici'+#13+
'BEVEL OUTER=D�� Seviyelndirici'+#13+
'PANEL EDITOR=Panel D�zenleyici'+#13+
'CONTINUOUS=Devaml�'+#13+
'HORIZ. ALIGNMENT=Yatay Hiza'+#13+
'EXPORT CHART=Grafi�i �hra� Et'+#13+
'BELOW %=% Altta'+#13+
'BELOW VALUE=De�erin Alt�nda'+#13+
'NEAREST POINT=En Yak�n Nokta'+#13+
'DRAG MARKS=��aret Ta��y�c�'+#13+
'TEECHART PRINT PREVIEW=Bask� �nizleme'+#13+
'X VALUE=X De�eri'+#13+
'X AND Y VALUES=X ve Y De�eri'+#13+
'SHININESS=Parlakl�k'+#13+
'ALL SERIES VISIBLE=B�t�n Seriler G�r�n�r'+#13+
'MARGIN=Marjin'+#13+
'DIAGONAL=Diyagonal'+#13+
'LEFT TOP=Sol �st'+#13+
'LEFT BOTTOM=Sol Alt'+#13+
'RIGHT TOP=Sa� �st'+#13+
'RIGHT BOTTOM=Sa� Alt'+#13+
'EXACT DATE TIME=Tam Tarih/Saat'+#13+
'RECT. GRADIENT=E�imli'+#13+
'CROSS SMALL=K���k Ha�'+#13+
'AVG=Ortalama'+#13+
'FUNCTION=Fonksiyon'+#13+
'AUTO=Otomatik'+#13+
'ONE MILLISECOND=Bir milisaniye'+#13+
'ONE SECOND=Bir saniye'+#13+
'FIVE SECONDS=Be� saniye'+#13+
'TEN SECONDS=On saniye'+#13+
'FIFTEEN SECONDS=Onbe� saniye'+#13+
'THIRTY SECONDS=Otuz saniye'+#13+
'ONE MINUTE=Bir dakika'+#13+
'FIVE MINUTES=Be� Dakika'+#13+
'TEN MINUTES=On Dakika'+#13+
'FIFTEEN MINUTES=Onbe� Dakika'+#13+
'THIRTY MINUTES=Otuz Dakika'+#13+
'TWO HOURS=�ki Saat'+#13+
'TWO HOURS=�ki Saat'+#13+
'SIX HOURS=Alt� Saat'+#13+
'TWELVE HOURS=Oniki Saat'+#13+
'ONE DAY=Bir g�n'+#13+
'TWO DAYS=�ki g�n'+#13+
'THREE DAYS=�� g�n'+#13+
'ONE WEEK=Bir hafta'+#13+
'HALF MONTH=Yar�m ay'+#13+
'ONE MONTH=Bir ay'+#13+
'TWO MONTHS=�ki ay'+#13+
'THREE MONTHS=�� ay'+#13+
'FOUR MONTHS=D�rt ay'+#13+
'SIX MONTHS=Alt� ay'+#13+
'IRREGULAR=D�zensiz'+#13+
'CLICKABLE=T�klanabilir'+#13+
'ROUND=Oval'+#13+
'FLAT=Yass�'+#13+
'PIE=Pasta'+#13+
'HORIZ. BAR=Yatay �ubuk'+#13+
'BUBBLE=Kabarc�k'+#13+
'SHAPE=�ekil'+#13+
'POINT=Nokta'+#13+
'FAST LINE=H�zl� �izgi'+#13+
'CANDLE=Mum'+#13+
'VOLUME=Hacim'+#13+
'HORIZ LINE=Yatay �izgi'+#13+
'SURFACE=Y�zey'+#13+
'LEFT AXIS=Sol Eksen'+#13+
'RIGHT AXIS=Sa� Eksen'+#13+
'TOP AXIS=�st Eksen'+#13+
'BOTTOM AXIS=Alt Eksen'+#13+
'CHANGE SERIES TITLE=Seri Ba�l���n� De�i�tir'+#13+
'DELETE %S ?=%s silinsin mi ?'+#13+
'DESIRED %S INCREMENT=�stenen %s art���'+#13+
'INCORRECT VALUE. REASON: %S=Ge�ersiz De�er. Neden: %s'+#13+
'FILLSAMPLEVALUES NUMVALUES MUST BE > 0=FillSampleValues. De�er say�s� > 0 olmal�.'#13+
'VISIT OUR WEB SITE !=Web sitemizi ziyaret edin !'#13+
'SHOW PAGE NUMBER=Sayfa Numaras�n� G�ster'#13+
'PAGE NUMBER=Sayfa No'#13+
'PAGE %D OF %D=Sayfa %d / %d'#13+
'TEECHART LANGUAGES=TeeChart Dilleri'#13+
'CHOOSE A LANGUAGE=Bir dil se�iniz'+#13+
'SELECT ALL=T�m�n� Se�'#13+
'MOVE UP=Yukar� Ta��'#13+
'MOVE DOWN=A�a�� Ta��'#13+
'DRAW ALL=T�m�n� �iz'#13+
'TEXT FILE=Metin Dosya'#13+
'IMAG. SYMBOL=G�r�nt� Sembol�'#13+
'DRAG REPAINT=S�r�kle yeniden boya'#13+
'NO LIMIT DRAG=S�r�klemeyi s�n�rlama'#13+

// 6.0

'BEVEL SIZE=�er�eve gen��l���'#13+
'DELETE ROW=Satir s�l'#13+
'VOLUME SERIES=��.hacm� ser�s�'#13+
'SINGLE=Tek'#13+
'REMOVE CUSTOM COLORS=K���sel Renkler� kaldir'#13+
'USE PALETTE MINIMUM=Palet m�n�mumunu kullan'#13+
'AXIS MAXIMUM=Eksen m�n�nmumu'#13+
'AXIS CENTER=Eksen merkez�'#13+
'AXIS MINIMUM=Eksen m�n�mumu'#13+
'DAILY (NONE)=G�nl�k (yok)'#13+
'WEEKLY=Haftalik'#13+
'MONTHLY=Aylik'#13+
'BI-MONTHLY=2 Aylik'#13+
'QUARTERLY=3 Aylik'#13+
'YEARLY=Yillik'#13+
'DATETIME PERIOD=Tar�h peryodu'#13+
'CASE SENSITIVE=B�y�k/k���k harf duyarli'#13+
'DRAG STYLE=S�r�kleme st�l�'#13+
'SQUARED=Kare'#13+
'GRID 3D SERIES=Izgara 3d ser�s�'#13+
'DARK BORDER=Koyu kenar'#13+
'PIE SERIES=Elma ser�s�'#13+
'FOCUS=Odaklan'#13+
'EXPLODE=Ayrik'#13+
'FACTOR=Fakt�r'#13+
'CHART FROM TEMPLATE (*.TEE FILE)=�ablondan graf�k (*.tee dosyasi)'#13+
'OPEN TEECHART TEMPLATE FILE FROM=Teechart �ablonunu dosyadan a�'#13+
'BINARY=�k�l�'#13+
'VOLUME OSCILLATOR=Volume Oscillator'#13+
'PIE SLICES=Elma d�l�mler�'#13+
'ARROW WIDTH=Ok gen��l���'#13+
'ARROW HEIGHT=Ok y�ksekl���'#13+
'DEFAULT COLOR=Varsayilan Renk'
;
  end;
end;

Procedure TeeSetTurkish;
begin
  TeeCreateTurkish;
  TeeLanguage:=TeeTurkishLanguage;
  TeeTurkishConstants;
  TeeLanguageHotKeyAtEnd:=False;
  TeeLanguageCanUpper:=True;
end;

initialization
finalization
  FreeAndNil(TeeTurkishLanguage);
end.


