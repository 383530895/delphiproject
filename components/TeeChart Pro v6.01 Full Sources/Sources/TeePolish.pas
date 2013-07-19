unit TeePolish;
{$I TeeDefs.inc}

interface

Uses Classes;

Var TeePolishLanguage:TStringList=nil;

Procedure TeeCreatePolish;
Procedure TeeSetPolish;

implementation

Uses SysUtils, TeeTranslate, TeeConst, TeeProCo {$IFNDEF D5},TeCanvas{$ENDIF};

Procedure TeePolishConstants;
begin
  { TeeConst }
  TeeMsg_Copyright          :='� 1995-2003 by David Berneda';
  TeeMsg_LegendFirstValue   :='Pierwsza warto�� legendy musi by� > 0';
  TeeMsg_LegendColorWidth   :='Szeroko�� musi by� mi�dzy 0 i 100';
  TeeMsg_SeriesSetDataSource:='Brak ParentChart �eby sprawdzi� �r�d�o danych';
  TeeMsg_SeriesInvDataSource:='Brak poprawnego �r�d�a danych: %s';
  TeeMsg_FillSample         :='FillSampleValues warto�ci liczbowe musz� by� > 0';
  TeeMsg_AxisLogDateTime    :='O� daty/czasu nie mo�e by� logarytmiczna';
  TeeMsg_AxisLogNotPositive :='Min i Max warto�ci osi logarytmicznej powinny by� >= 0';
  TeeMsg_AxisLabelSep       :='% odst�pu etykiet musi by� wi�kszy ni� 0';
  TeeMsg_AxisIncrementNeg   :='Inkrement osi musi by� >= 0';
  TeeMsg_AxisMinMax         :='Warto�� minimum osi musi by� <= maksimum';
  TeeMsg_AxisMaxMin         :='Warto�� maksimum osi musi by� >= minimum';
  TeeMsg_AxisLogBase        :='Podstawa logarytmiczna osi powinna by� >= 2';
  TeeMsg_MaxPointsPerPage   :='Max. ilo�� punkt�w na stron� musi by� >= 0';
  TeeMsg_3dPercent          :='Procent efektu 3W musi by� zawarty mi�dzy %d i %d';
  TeeMsg_CircularSeries     :='Cykliczne zale�no�ci mi�dzy seriami s� niedozwolone';
  TeeMsg_WarningHiColor     :='16K kolor jest wymagany aby uzyska� lepszy wygl�d';

  TeeMsg_DefaultPercentOf   :='%s z %s';
  TeeMsg_DefaultPercentOf2  :='%s'+#13+'z %s';
  TeeMsg_DefPercentFormat   :='##0.## %';
  TeeMsg_DefValueFormat     :='#,##0.###';
  TeeMsg_DefLogValueFormat  :='#.0 "x10" E+0';
  TeeMsg_AxisTitle          :='Tytu� osi';
  TeeMsg_AxisLabels         :='Etykiety osi';
  TeeMsg_RefreshInterval    :='Interwa� odswie�ania musi by� zawarty mi�dzy 0 i 60';
  TeeMsg_SeriesParentNoSelf :='Sam nie jestem Series.ParentChart!';
  TeeMsg_GalleryLine        :='Liniowy';
  TeeMsg_GalleryPoint       :='Punktowy';
  TeeMsg_GalleryArea        :='Powierzchniowy';
  TeeMsg_GalleryBar         :='S�upkowy';
  TeeMsg_GalleryHorizBar    :='S�upkowy poziomy';
  TeeMsg_Stack              :='Stos';
  TeeMsg_GalleryPie         :='Ko�owy';
  TeeMsg_GalleryCircled     :='Zaokr�glony';
  TeeMsg_GalleryFastLine    :='Szybka linia';
  TeeMsg_GalleryHorizLine   :='Liniowy horyz.';

  TeeMsg_PieSample1         :='Auta';
  TeeMsg_PieSample2         :='Telefony';
  TeeMsg_PieSample3         :='Sto�y';
  TeeMsg_PieSample4         :='Monitory';
  TeeMsg_PieSample5         :='Lampy';
  TeeMsg_PieSample6         :='Klawiatury';
  TeeMsg_PieSample7         :='Rowery';
  TeeMsg_PieSample8         :='Krzes�a';

  TeeMsg_GalleryLogoFont    :='Courier New';
  TeeMsg_Editing            :='Redagowanie %s';

  TeeMsg_GalleryStandard    :='Standardowe';
  TeeMsg_GalleryExtended    :='Rozszerzone';
  TeeMsg_GalleryFunctions   :='Funkcje';

  TeeMsg_EditChart          :='&Edycja wykresu...';
  TeeMsg_PrintPreview       :='&Podgl�d wydruku...';
  TeeMsg_ExportChart        :='E&ksport wykresu...';
  TeeMsg_CustomAxes         :='Dostosowane osie...';

  TeeMsg_InvalidEditorClass :='%s: Nieprawid�owa klasa edytora: %s';
  TeeMsg_MissingEditorClass :='%s: brak okna dialogowego edytora';

  TeeMsg_GalleryArrow       :='Strza�kowy';

  TeeMsg_ExpFinish          :='&Koniec';
  TeeMsg_ExpNext            :='&Dalej >';

  TeeMsg_GalleryGantt       :='Gantt';

  TeeMsg_GanttSample1       :='Projekt';
  TeeMsg_GanttSample2       :='Prototyp';
  TeeMsg_GanttSample3       :='Rozw�j';
  TeeMsg_GanttSample4       :='Sprzeda�';
  TeeMsg_GanttSample5       :='Marketing';
  TeeMsg_GanttSample6       :='Testowanie';
  TeeMsg_GanttSample7       :='Produkcja';
  TeeMsg_GanttSample8       :='Ulepszanie';
  TeeMsg_GanttSample9       :='Nowa wersja';
  TeeMsg_GanttSample10      :='Bankowo��';

  TeeMsg_ChangeSeriesTitle  :='Zmie� tytu� serii';
  TeeMsg_NewSeriesTitle     :='Nowy tytu� serii:';
  TeeMsg_DateTime           :='Data/Czas';
  TeeMsg_TopAxis            :='G�rna o�';
  TeeMsg_BottomAxis         :='Dolna o�';
  TeeMsg_LeftAxis           :='Lewa o�';
  TeeMsg_RightAxis          :='Prawa o�';

  TeeMsg_SureToDelete       :='Usun�� %s ?';
  TeeMsg_DateTimeFormat     :='For&mat daty/czasu:';
  TeeMsg_Default            :='Domy�lnie: ';
  TeeMsg_ValuesFormat       :='For&mat warto�ci:';
  TeeMsg_Maximum            :='Maksimum';
  TeeMsg_Minimum            :='Minimum';
  TeeMsg_DesiredIncrement   :='Po�adany %s Inkrement';

  TeeMsg_IncorrectMaxMinValue:='Z�a warto��. Przyczyna: %s';
  TeeMsg_EnterDateTime      :='Wprowad� [liczba dni] [hh:mm:ss]';

  TeeMsg_SureToApply        :='Zastosowa� zmiany ?';
  TeeMsg_SelectedSeries     :='(Wybrane serie)';
  TeeMsg_RefreshData        :='&Od�wie� dane';

  TeeMsg_DefaultFontSize    :='8';
  TeeMsg_FunctionAdd        :='Dodaj';
  TeeMsg_FunctionSubtract   :='Odejmij';
  TeeMsg_FunctionMultiply   :='Pomn�';
  TeeMsg_FunctionDivide     :='Podziel';
  TeeMsg_FunctionHigh       :='Wysoko';
  TeeMsg_FunctionLow        :='Nisko';
  TeeMsg_FunctionAverage    :='�rednio';

  TeeMsg_GalleryShape       :='Kszta�ty';
  TeeMsg_GalleryBubble      :='B�belkowy';
  TeeMsg_FunctionNone       :='Kopiuj';

  TeeMsg_None               :='(Brak)';

  TeeMsg_PrivateDeclarations:='{ Private declarations }';
  TeeMsg_PublicDeclarations :='{ Public declarations }';

  TeeMsg_DefaultFontName    :=TeeMsg_DefaultEngFontName;

  TeeMsg_CheckPointerSize   :='Wielko�� wska�nika musi by� wi�ksza ni� zero';
  TeeMsg_About              :='&O TeeChart...';

  tcAdditional              :='Dodatkowo';
  tcDControls               :='Kontrolki danych';
  tcQReport                 :='QReport';

  TeeMsg_DataSet            :='Zbi�r danych';
  TeeMsg_AskDataSet         :='&Zbi�r danych:';

  TeeMsg_SingleRecord       :='Pojedy�czy wiersz';
  TeeMsg_AskDataSource      :='&�r�d�o danych:';

  TeeMsg_Summary            :='Podsumowanie';

  TeeMsg_FunctionPeriod     :='Okres funkcji powinien by� >= 0';

  TeeMsg_WizardTab          :='Biznes';

  TeeMsg_ClearImage         :='&Wyszy��';
  TeeMsg_BrowseImage        :='&Szukaj w...';

  TeeMsg_WizardSureToClose  :='Jeste� pewien, �e chcesz zamkn�� kreatora TeeChart ?';
  TeeMsg_FieldNotFound      :='Pole %s nie istnieje';

  TeeMsg_DepthAxis          :='O� g��boko�ci';
  TeeMsg_PieOther           :='Inny';
  TeeMsg_ShapeGallery1      :='abc';
  TeeMsg_ShapeGallery2      :='123';
  TeeMsg_ValuesX            :='X';
  TeeMsg_ValuesY            :='Y';
  TeeMsg_ValuesPie          :='Ko�o';
  TeeMsg_ValuesBar          :='S�upek';
  TeeMsg_ValuesAngle        :='K�t';
  TeeMsg_ValuesGanttStart   :='Pocz�tek';
  TeeMsg_ValuesGanttEnd     :='Koniec';
  TeeMsg_ValuesGanttNextTask:='Nastepne zadanie';
  TeeMsg_ValuesBubbleRadius :='Promie�';
  TeeMsg_ValuesArrowEndX    :='KoniecX';
  TeeMsg_ValuesArrowEndY    :='KoniecY';
  TeeMsg_Legend             :='Legenda';
  TeeMsg_Title              :='Tytu�';
  TeeMsg_Foot               :='Stopka';
  TeeMsg_Period		    :='Okres';
  TeeMsg_PeriodRange        :='Zakres okres�w';
  TeeMsg_CalcPeriod         :='%s oblicz ka�dy:';
  TeeMsg_SmallDotsPen       :='Ma�e kropki';

  TeeMsg_InvalidTeeFile     :='Nieprawid�owy wykres w pliku *.tee';
  TeeMsg_WrongTeeFileFormat :='Z�y format pliku *.tee';
  TeeMsg_EmptyTeeFile       :='Pusty plik *.tee';  { 5.01 }

  {$IFDEF D5}
  TeeMsg_ChartAxesCategoryName   :='Osie wykresu';
  TeeMsg_ChartAxesCategoryDesc   :='Osie wykresu - w�a�ciwo�ci i zdarzenia';
  TeeMsg_ChartWallsCategoryName  :='�ciany wykresu';
  TeeMsg_ChartWallsCategoryDesc  :='�ciany wykresu - w�a�ciwo�ci i zdarzenia';
  TeeMsg_ChartTitlesCategoryName :='Tytu�y wykresu';
  TeeMsg_ChartTitlesCategoryDesc :='Tytu�y wykresu - w�a�ciwo�ci i zdarzenia';
  TeeMsg_Chart3DCategoryName     :='Wykres 3W';
  TeeMsg_Chart3DCategoryDesc     :='Wykres 3W - w�a�ciwo�ci i zdarzenia';
  {$ENDIF}

  TeeMsg_CustomAxesEditor       :='Dostosowany ';
  TeeMsg_Series                 :='Serie';
  TeeMsg_SeriesList             :='Serie...';

  TeeMsg_PageOfPages            :='Strona %d z %d';
  TeeMsg_FileSize               :='%d bajt�w';

  TeeMsg_First  :='Pierwszy';
  TeeMsg_Prior  :='Poprzedni';
  TeeMsg_Next   :='Nast�pny';
  TeeMsg_Last   :='Ostatni';
  TeeMsg_Insert :='Wstaw';
  TeeMsg_Delete :='Usu�';
  TeeMsg_Edit   :='Redaguj';
  TeeMsg_Post   :='Zastosuj';
  TeeMsg_Cancel :='Anuluj';

  TeeMsg_All    :='(wszystko)';
  TeeMsg_Index  :='Indeks';
  TeeMsg_Text   :='Tekst';

  TeeMsg_AsBMP        :='jako &Bitmapa';
  TeeMsg_BMPFilter    :='Bitmapy (*.bmp)|*.bmp';
  TeeMsg_AsEMF        :='jako &Metafile';
  TeeMsg_EMFFilter    :='Ulepszone Metapliki (*.emf)|*.emf|Metapliki (*.wmf)|*.wmf';
  TeeMsg_ExportPanelNotSet :='W�a�ciwo�� panel nie jest ustawiona w formacie Eksportu';

  TeeMsg_Normal    :='Normalny';
  TeeMsg_NoBorder  :='Bez kraw�dzi';
  TeeMsg_Dotted    :='Kropkowany';
  TeeMsg_Colors    :='Kolory';
  TeeMsg_Filled    :='Wype�niony';
  TeeMsg_Marks     :='Znaczniki';
  TeeMsg_Stairs    :='Schody';
  TeeMsg_Points    :='Punkty';
  TeeMsg_Height    :='Wysoko��';
  TeeMsg_Hollow    :='Pusty';
  TeeMsg_Point2D   :='Punkt 2W';
  TeeMsg_Triangle  :='Tr�jk�t';
  TeeMsg_Star      :='Gwiazda';
  TeeMsg_Circle    :='Ko�o';
  TeeMsg_DownTri   :='Tr�jk�t odwr.';
  TeeMsg_Cross     :='Krzy�';
  TeeMsg_Diamond   :='Diament';
  TeeMsg_NoLines   :='Bez linii';
  TeeMsg_Stack100  :='Stos 100%';
  TeeMsg_Pyramid   :='Piramida';
  TeeMsg_Ellipse   :='Elipsa';
  TeeMsg_InvPyramid:='Piramida odwr.';
  TeeMsg_Sides     :='Boki';
  TeeMsg_SideAll   :='Wszystkie boki';
  TeeMsg_Patterns  :='Wzory';
  TeeMsg_Exploded  :='Rozsuni�ty';
  TeeMsg_Shadow    :='Cie�';
  TeeMsg_SemiPie   :='P�kole';
  TeeMsg_Rectangle :='Prostok�t';
  TeeMsg_VertLine  :='Linia pion.';
  TeeMsg_HorizLine :='Linia poz.';
  TeeMsg_Line      :='Linia';
  TeeMsg_Cube      :='Sze�cian';
  TeeMsg_DiagCross :='Diag.Krzy�';

  TeeMsg_CanNotFindTempPath    :='Nie mog� znale�� folderu Temp';
  TeeMsg_CanNotCreateTempChart :='Nie mog� utworzy� pliku Temp';
  TeeMsg_CanNotEmailChart      :='Nie mog� wys�a� wykresu TeeChart. B��d MAPI: %d';

  TeeMsg_SeriesDelete :='Usuwanie serii: Indeks warto�ci %d poza granicami (0 do %d).';

  { 5.02 }
  TeeMsg_AskLanguage  :='&J�zyk...';
  
  { TeeProCo }
  TeeMsg_GalleryPolar       :='Biegunowy';
  TeeMsg_GalleryCandle      :='Gie�dowy';
  TeeMsg_GalleryVolume      :='Wolumen';
  TeeMsg_GallerySurface     :='Powierzchniowy';
  TeeMsg_GalleryContour     :='Konturowy';
  TeeMsg_GalleryBezier      :='Bezier';
  TeeMsg_GalleryPoint3D     :='Punktowy 3W';
  TeeMsg_GalleryRadar       :='Radarowy';
  TeeMsg_GalleryDonut       :='Pier�cieniowy';
  TeeMsg_GalleryCursor      :='Kursor';
  TeeMsg_GalleryBar3D       :='S�upkowy 3W';
  TeeMsg_GalleryBigCandle   :='Gie�dowy-wielki';
  TeeMsg_GalleryLinePoint   :='Linia Punkt';
  TeeMsg_GalleryHistogram   :='Histogram';
  TeeMsg_GalleryWaterFall   :='Wodospad';
  TeeMsg_GalleryWindRose    :='R�a wiatr�w';
  TeeMsg_GalleryClock       :='Zegarowy';
  TeeMsg_GalleryColorGrid   :='Siatka kolor�w';
  TeeMsg_GalleryBoxPlot     :='Pude�kowy';
  TeeMsg_GalleryHorizBoxPlot:='Pude�k. poziomy';
  TeeMsg_GalleryBarJoin     :='S�upkowy z��cz.';
  TeeMsg_GallerySmith       :='Smith';
  TeeMsg_GalleryPyramid     :='Piramida';
  TeeMsg_GalleryMap         :='Mapa';

  TeeMsg_PolyDegreeRange    :='Stopie� wielomianu musi le�e� pomi�dzy 1 i 20';
  TeeMsg_AnswerVectorIndex   :='Indeks wektora odpowiedzi musi le�e� pomi�dzy 1 i %d';
  TeeMsg_FittingError        :='Nie mo�na przeprowadzi� dopasowania';
  TeeMsg_PeriodRange         :='Okres musi by� >= 0';
  TeeMsg_ExpAverageWeight    :='Exp. �rednia musi le�e� pomi�dzy 0 i 1';
  TeeMsg_GalleryErrorBar     :='S�upki b��du';
  TeeMsg_GalleryError        :='B��d';
  TeeMsg_GalleryHighLow      :='Wysoko Nisko';
  TeeMsg_FunctionMomentum    :='P�d';
  TeeMsg_FunctionMomentumDiv :='P�d (Div.)';
  TeeMsg_FunctionExpAverage  :='Exp.�rednia';
  TeeMsg_FunctionMovingAverage:='�rednia ruchoma';
  TeeMsg_FunctionExpMovAve   :='Exp.�rednia ruchoma';
  TeeMsg_FunctionRSI         :='R.S.I.';
  TeeMsg_FunctionCurveFitting:='Krzywa dostosowana';
  TeeMsg_FunctionTrend       :='Trend';
  TeeMsg_FunctionExpTrend    :='Exp.Trend';
  TeeMsg_FunctionLogTrend    :='Log.Trend';
  TeeMsg_FunctionCumulative  :='Kumulacja';
  TeeMsg_FunctionStdDeviation:='Odchylenie std.';
  TeeMsg_FunctionBollinger   :='Bollinger';
  TeeMsg_FunctionRMS         :='�redni pierw.kw.';
  TeeMsg_FunctionMACD        :='MACD';
  TeeMsg_FunctionStochastic  :='Stochastyczny';
  TeeMsg_FunctionADX         :='ADX';

  TeeMsg_FunctionCount       :='Ilo��';
  TeeMsg_LoadChart           :='Otw�rz TeeChart...';
  TeeMsg_SaveChart           :='Zapisz TeeChart...';
  TeeMsg_TeeFiles            :='Pliki TeeChart Pro';

  TeeMsg_GallerySamples      :='Inne';
  TeeMsg_GalleryStats        :='Stat.';

  TeeMsg_CannotFindEditor    :='Nie mo�na znale�� formularza edytora serii: %s';


  TeeMsg_CannotLoadChartFromURL:='Kod b��du: %d �adowanie wykresu z URL: %s';
  TeeMsg_CannotLoadSeriesDataFromURL:='Kod b��du: %d �adowanie danych serii z URL: %s';

  TeeMsg_Test                :='Test...';

  TeeMsg_ValuesDate          :='Data';
  TeeMsg_ValuesOpen          :='Otw�rz';
  TeeMsg_ValuesHigh          :='Wysoka';
  TeeMsg_ValuesLow           :='Niska';
  TeeMsg_ValuesClose         :='Zamknij';
  TeeMsg_ValuesOffset        :='Przesuni�cie';
  TeeMsg_ValuesStdError      :='B��d Std.';

  TeeMsg_Grid3D              :='Siatka 3W';

  TeeMsg_LowBezierPoints     :='Ilo�� punkt�w Bezier powinna by� > 1';

  { TeeCommander component... }

  TeeCommanMsg_Normal   :='Normalny';
  TeeCommanMsg_Edit     :='Redaguj';
  TeeCommanMsg_Print    :='Drukuj';
  TeeCommanMsg_Copy     :='Kopiuj';
  TeeCommanMsg_Save     :='Zapisz';
  TeeCommanMsg_3D       :='3W';

  TeeCommanMsg_Rotating :='Obr�t: %d� Podniesienie: %d�';
  TeeCommanMsg_Rotate   :='Obr��';

  TeeCommanMsg_Moving   :='Poz.Przesun.: %d Pion.Przesun.: %d';
  TeeCommanMsg_Move     :='Przesu�';

  TeeCommanMsg_Zooming  :='Zoom: %d %%';
  TeeCommanMsg_Zoom     :='Zoom';

  TeeCommanMsg_Depthing :='3W: %d %%';
  TeeCommanMsg_Depth    :='G��boko��';

  TeeCommanMsg_Chart    :='Wykres';
  TeeCommanMsg_Panel    :='Panel';

  TeeCommanMsg_RotateLabel:='Ci�gnij %s by obr�ci�';
  TeeCommanMsg_MoveLabel  :='Ci�gnij %s by przesun��';
  TeeCommanMsg_ZoomLabel  :='Ci�gnij %s by powi�kszy�';
  TeeCommanMsg_DepthLabel :='Ci�gnij  %s by zmieni� g��boko�� 3W';

  TeeCommanMsg_NormalLabel:='Ci�gnij lewym przyciskiem by wykona� Zoom, prawym by przewin��';
  TeeCommanMsg_NormalPieLabel:='Ci�gnij odp. wycinek by go wysun��';

  TeeCommanMsg_PieExploding :='Wycinek: %d Wysuni�ty: %d %%';

  TeeMsg_TriSurfaceLess:='Liczba punkt�w musi by� >= 4';
  TeeMsg_TriSurfaceAllColinear:='Wszystkie wsp�liniowe punkty danych';
  TeeMsg_TriSurfaceSimilar:='Podobne punkty - nie mo�na wykona�';
  TeeMsg_GalleryTriSurface:='Powierzch. tr�jk.';

  TeeMsg_AllSeries :='Wszystkie serie';
  TeeMsg_Edit      :='Redaguj';

  TeeMsg_GalleryFinancial    :='Finansowe';

  TeeMsg_CursorTool    :='Kursor';
  TeeMsg_DragMarksTool :='Ci�gnij znacznik';
  TeeMsg_AxisArrowTool :='Strza�ki Osi';
  TeeMsg_DrawLineTool  :='Rysuj Linie';
  TeeMsg_NearestTool   :='Najbli�szy Punkt';
  TeeMsg_ColorBandTool :='Kolorowa Ta�ma';
  TeeMsg_ColorLineTool :='Kolorowa Linia';
  TeeMsg_RotateTool    :='Obr�c';
  TeeMsg_ImageTool     :='Obraz';
  TeeMsg_MarksTipTool  :='Uwagi Znacznika';

  TeeMsg_CantDeleteAncestor  :='Nie mo�na usun�� poprzednika';

  TeeMsg_Load	         :='Wczytywanie...';
  TeeMsg_DefaultDemoTee  :='http://www.steema.com/demo.tee';
  TeeMsg_NoSeriesSelected:='Nie wybrano �adnej serii';

  { TeeChart Actions }
  TeeMsg_CategoryChartActions  :='Wykres';
  TeeMsg_CategorySeriesActions :='Serie wykresu';

  TeeMsg_Action3D               :='&3W';
  TeeMsg_Action3DHint           :='Prze��cz 2W / 3W';
  TeeMsg_ActionSeriesActive     :='&Aktywne';
  TeeMsg_ActionSeriesActiveHint :='Poka�/Ukryj serie';
  TeeMsg_ActionEditHint         :='Redaguj wykres';
  TeeMsg_ActionEdit             :='&Redaguj...';
  TeeMsg_ActionCopyHint         :='Kopiuj do schowka';
  TeeMsg_ActionCopy             :='&Kopiuj';
  TeeMsg_ActionPrintHint        :='Podgl�d wydruku';
  TeeMsg_ActionPrint            :='&Drukuj...';
  TeeMsg_ActionAxesHint         :='Poka�/Ukryj osie';
  TeeMsg_ActionAxes             :='&Osie';
  TeeMsg_ActionGridsHint        :='Poka�/Ukryj siatk�';
  TeeMsg_ActionGrids            :='&Siatka';
  TeeMsg_ActionLegendHint       :='Poka�/Ukryj legend�';
  TeeMsg_ActionLegend           :='&Legenda';
  TeeMsg_ActionSeriesEditHint   :='Redaguj serie';
  TeeMsg_ActionSeriesMarksHint  :='Poka�/Ukryj znaczniki serii';
  TeeMsg_ActionSeriesMarks      :='&Znaczniki';
  TeeMsg_ActionSaveHint         :='Zapisz wykres';
  TeeMsg_ActionSave             :='&Zapisz...';

  TeeMsg_CandleBar              :='S�upek';
  TeeMsg_CandleNoOpen           :='Bez otw.';
  TeeMsg_CandleNoClose          :='Bez zamkn.';
  TeeMsg_NoLines                :='Bez linii';
  TeeMsg_NoHigh                 :='Bez wysok.';
  TeeMsg_NoLow                  :='Bez nisk.';
  TeeMsg_ColorRange             :='Zakres kolor�w';
  TeeMsg_WireFrame              :='Szkielet druc.';
  TeeMsg_DotFrame               :='Szkielet punkt.';
  TeeMsg_Positions              :='Pozycje';
  TeeMsg_NoGrid                 :='Bez siatki';
  TeeMsg_NoPoint                :='Bez punktu';
  TeeMsg_NoLine                 :='Bez linii';
  TeeMsg_Labels                 :='Etykiety';
  TeeMsg_NoCircle               :='Bez ko�a';
  TeeMsg_Lines                  :='Linie';
  TeeMsg_Border                 :='Kraw�d�';

  TeeMsg_SmithResistance      :='Op�r(Smith)';
  TeeMsg_SmithReactance       :='Op�r bierny';
  
  TeeMsg_Column  :='Kolumna';

  { 5.01 }
  TeeMsg_Separator            :='Separator';
  TeeMsg_FunnelSegment        :='Segment ';
  TeeMsg_FunnelSeries         :='Lejkowy';
  TeeMsg_FunnelPercent        :='0.00%';
  TeeMsg_FunnelExceed         :='przekroczony limit';
  TeeMsg_FunnelWithin         :=' wewnetrzny limit';
  TeeMsg_FunnelBelow          :=' poni�ej limitu';
  TeeMsg_CalendarSeries       :='Kalendarz';
  TeeMsg_DeltaPointSeries     :='Punkt delta';
  TeeMsg_ImagePointSeries     :='Punkt z obrazem';
  TeeMsg_ImageBarSeries       :='S�upek z obrazem';
  TeeMsg_SeriesTextFieldZero  :='Tekst serii: Indeks pola powinien by� wi�kszy ni� zero.';

  { 5.02 }
  TeeMsg_Origin               :='Pocz�tek';
  TeeMsg_Transparency         :='Przezroczysto��';
  TeeMsg_Box		      :='Pude�ko';
  TeeMsg_ExtrOut	      :='ExtrOut';
  TeeMsg_MildOut	      :='MildOut';
  TeeMsg_PageNumber	      :='Numer strony';

  { 5.02 } { Moved from TeeImageConstants.pas unit }

  TeeMsg_AsJPEG        :='jako &JPEG';
  TeeMsg_JPEGFilter    :='Pliki JPEG (*.jpg)|*.jpg';
  TeeMsg_AsGIF         :='jako &GIF';
  TeeMsg_GIFFilter     :='Pliki GIF (*.gif)|*.gif';
  TeeMsg_AsPNG         :='jako &PNG';
  TeeMsg_PNGFilter     :='Pliki PNG (*.png)|*.png';
  TeeMsg_AsPCX         :='jako PC&X';
  TeeMsg_PCXFilter     :='Pliki PCX (*.pcx)|*.pcx';

  { 5.03 }
  TeeMsg_Property            :='W�a�ciwo�ci';
  TeeMsg_Value               :='Warto��';
  TeeMsg_Yes                 :='Tak';
  TeeMsg_No                  :='Nie';
  TeeMsg_Image              :='(obrazek)';

  { 5.03 }
  TeeMsg_DragPoint            := 'Drag Point';
  TeeMsg_OpportunityValues    := 'OpportunityValues';
  TeeMsg_QuoteValues          := 'QuoteValues';

  {OCX 5.0.4}
  TeeMsg_ActiveXVersion      := 'ActiveX wersja ' + AXVer;
  TeeMsg_ActiveXCannotImport := 'Nie mo�na zaimportowa� TeeChart z %s';
  TeeMsg_ActiveXVerbPrint    := '&Podgl�d wydruku...';
  TeeMsg_ActiveXVerbExport   := 'E&xport...';
  TeeMsg_ActiveXVerbImport   := '&Import...';
  TeeMsg_ActiveXVerbHelp     := '&Pomoc...';
  TeeMsg_ActiveXVerbAbout    := '&O TeeChart...';
  TeeMsg_ActiveXError        := 'TeeChart: Kod b��du: %d �ci�ganie: %s';
  TeeMsg_DatasourceError     := '�r�d�o danych TeeChart nie jest Seri� lub RecordSetem';
  TeeMsg_SeriesTextSrcError  := 'Nieprawid�owy typ Serii';
  TeeMsg_AxisTextSrcError    := 'Nieprawid�owy typ Osi';
  TeeMsg_DelSeriesDatasource := 'Czy jeste� pewny �e chcesz usun�� %s ?';
  TeeMsg_OCXNoPrinter        := 'Nie zainstalowano domy�lnej drukarki.';
  TeeMsg_ActiveXPictureNotValid:='Obraz jest nieprawid�owy';

  // 6.0
  TeeMsg_FunctionCustom   :='y = f(x)';
  TeeMsg_AsPDF            :='as &PDF';
  TeeMsg_PDFFilter        :='PDF files (*.pdf)|*.pdf';
  TeeMsg_AsPS             :='as PostScript';
  TeeMsg_PSFilter         :='PostScript files (*.eps)|*.eps';
  TeeMsg_GalleryHorizArea :='Horizontal'#13'Area';
  TeeMsg_SelfStack        :='Self Stacked';
  TeeMsg_DarkPen          :='Dark Border';
  TeeMsg_SelectFolder     :='Select database folder';
  TeeMsg_BDEAlias         :='&Alias:';
  TeeMsg_ADOConnection    :='&Connection:';

  { 6.0 }
  TeeMsg_FunctionSmooth       :='Smoothing';
  TeeMsg_FunctionCross        :='Cross Points';
  TeeMsg_GridTranspose        :='3D Grid Transpose';
  TeeMsg_FunctionCompress     :='Compression';
  TeeMsg_ExtraLegendTool      :='Extra Legend';
  TeeMsg_FunctionCLV          :='Close Location'#13'Value';
  TeeMsg_FunctionOBV          :='On Balance'#13'Volume';
  TeeMsg_FunctionCCI          :='Commodity'#13'Channel Index';
  TeeMsg_FunctionPVO          :='Volume'#13'Oscillator';
  TeeMsg_SeriesAnimTool       :='Series Animation';
  TeeMsg_GalleryPointFigure   :='Point & Figure';
  TeeMsg_Up                   :='Up';
  TeeMsg_Down                 :='Down';
  TeeMsg_GanttTool            :='Gantt Drag';
  TeeMsg_XMLFile              :='XML file';
  TeeMsg_GridBandTool         :='Grid band tool';
  TeeMsg_FunctionPerf         :='Performance';
  TeeMsg_GalleryGauge         :='Gauge';
  TeeMsg_GalleryGauges        :='Gauges';
  TeeMsg_ValuesVectorEndZ     :='EndZ';
  TeeMsg_GalleryVector3D      :='Vector 3D';
  TeeMsg_Gallery3D            :='3D';
  TeeMsg_GalleryTower         :='Tower';
  TeeMsg_SingleColor          :='Single Color';
  TeeMsg_Cover                :='Cover';
  TeeMsg_Cone                 :='Cone';
  TeeMsg_PieTool              :='Pie Slices';
end;

Procedure TeeCreatePolish;
begin
  if not Assigned(TeePolishLanguage) then
  begin
    TeePolishLanguage:=TStringList.Create;
    TeePolishLanguage.Text:=

'GRADIENT EDITOR=Edytor gradientu'#13+
'GRADIENT=Gradient'#13+
'DIRECTION=Kierunek'#13+
'VISIBLE=Poka�'#13+
'TOP BOTTOM=G�ra D�'#13+
'BOTTOM TOP=D� G�ra'#13+
'LEFT RIGHT=Lewo Prawo'#13+
'RIGHT LEFT=Prawo Lewo'#13+
'FROM CENTER=Od �rodka'#13+
'FROM TOP LEFT=Od G�ry Lewo'#13+
'FROM BOTTOM LEFT=Od Do�u Lewo'#13+
'OK=OK'#13+
'CANCEL=Anuluj'#13+
'COLORS=Kolory'#13+
'START=Pocz�tek'#13+
'MIDDLE=�rodek'#13+
'END=Koniec'#13+
'SWAP=Zamie�'#13+
'NO MIDDLE=Bez �rodka'#13+
'TEEFONT EDITOR=Edytor czcionki'#13+
'INTER-CHAR SPACING=Odst.mi�dzyznak.'#13+
'FONT=Czcionka'#13+
'SHADOW=Cie�'#13+
'HORIZ. SIZE=Rozm. poziom.'#13+
'VERT. SIZE=Rozmiar pion.'#13+
'COLOR=Kolor'#13+
'OUTLINE=Kontur'#13+
'OPTIONS=Opcje'#13+
'FORMAT=Format'#13+
'TEXT=Tekst'#13+
'POSITION=Pozycja'#13+
'LEFT=Lewo'#13+
'TOP=G�ra'#13+
'AUTO=Auto'#13+
'CUSTOM=Dostosowana'#13+
'LEFT TOP=Lewo g�ra'#13+
'LEFT BOTTOM=Lewo d�'#13+
'RIGHT TOP=Prawo g�ra'#13+
'RIGHT BOTTOM=Prawo d�'#13+
'MULTIPLE AREAS=Wiele powierzchni'#13+
'NONE=Brak'#13+
'STACKED=Stos'#13+
'STACKED 100%=Stos 100%'#13+
'AREA=Powierzchnia'#13+
'PATTERN=Wz�r'#13+
'STAIRS=Schody'#13+
'SOLID=Pe�ny'#13+
'CLEAR=Pusty'#13+
'HORIZONTAL=Poziomy'#13+
'VERTICAL=Pionowy'#13+
'DIAGONAL=Diagonaly'#13+
'B.DIAGONAL=B.Diagonal.'#13+
'CROSS=Krzy�'#13+
'DIAG.CROSS=Diag.Krzy�'#13+
'AREA LINES=Linie powierz.'#13+
'BORDER=Kraw�d�'#13+
'INVERTED=Odwr�cony'#13+
'COLOR EACH=Koloruj ka�dy'#13+
'ORIGIN=Pocz�tek'#13+
'USE ORIGIN=U�yj pocz�tek'#13+
'WIDTH=Szerok.'#13+
'HEIGHT=Wysoko��'#13+
'AXIS=O�'#13+
'LENGTH=D�ugo��'#13+
'SCROLL=Przewijaj'#13+
'BOTH=Oba'#13+
'AXIS INCREMENT=Inkrement osi'#13+
'INCREMENT=Inkrement'#13+
'STANDARD=Standard'#13+
'ONE MILLISECOND=Jedna milisekunda'#13+
'ONE SECOND=Jedna sekunda'#13+
'FIVE SECONDS=Pi�� sekund'#13+
'TEN SECONDS=Dziesi�� sekund'#13+
'FIFTEEN SECONDS=Pi�tna�cie sekund'#13+
'THIRTY SECONDS=Trzydzie�ci sekund'#13+
'ONE MINUTE=Jedna minuta'#13+
'FIVE MINUTES=Pi�� minut'#13+
'TEN MINUTES=Dzies�� minut'#13+
'FIFTEEN MINUTES=Pi�tna�cie minut'#13+
'THIRTY MINUTES=Trzydzie�ci minut'#13+
'ONE HOUR=Jedna godzina'#13+
'TWO HOURS=Dwie godziny'#13+
'SIX HOURS=Sze�� godzina'#13+
'TWELVE HOURS=Dwana�cie godzin'#13+
'ONE DAY=Jeden dzie�'#13+
'TWO DAYS=Dwa dni'#13+
'THREE DAYS=Trzy dni'#13+
'ONE WEEK=Jeden tydzie�'#13+
'HALF MONTH=P� miesi�ca'#13+
'ONE MONTH=Jeden miesi�c'#13+
'TWO MONTHS=Dwa miesi�ce'#13+
'THREE MONTHS=Trzy miesi�ce'#13+
'FOUR MONTHS=Cztery miesi�ce'#13+
'SIX MONTHS=Sze�� miesi�cy'#13+
'ONE YEAR=Jeden rok'#13+
'EXACT DATE TIME=Dok�adna data/czas'#13+
'AXIS MAXIMUM AND MINIMUM=Maksimum i minimum osi'#13+
'VALUE=Warto��'#13+
'TIME=Czas'#13+
'LEFT AXIS=O� lewa'#13+
'RIGHT AXIS=O� prawa'#13+
'TOP AXIS=O� g�rna'#13+
'BOTTOM AXIS=O� dolna'#13+
'% BAR WIDTH=% Szeroko�� s�upka'#13+
'STYLE=Styl'#13+
'% BAR OFFSET=% Przesuni�cie s�upka'#13+
'RECTANGLE=Prostok�t'#13+
'PYRAMID=Piramida'#13+
'INVERT. PYRAMID=Odwr�cona piramida'#13+
'CYLINDER=Cylinder'#13+
'ELLIPSE=Elipsa'#13+
'ARROW=Strza�ka'#13+
'RECT. GRADIENT=Prost. Gradient'#13+
'CONE=Sto�ek'#13+
'DARK BAR 3D SIDES=Ciemne boki s�upka 3W'#13+
'BAR SIDE MARGINS=Boczne marginesy s�upka'#13+
'AUTO MARK POSITION=Autom. pozycja znacznika'#13+
'JOIN=Z��cz'#13+
'DATASET=Zbi�r danych'#13+
'APPLY=Zastosuj'#13+
'SOURCE=�r�d�o'#13+
'MONOCHROME=Monochromatyczny'#13+
'DEFAULT=Domy�lnie'#13+
'2 (1 BIT)=2 (1 bit)'#13+
'16 (4 BIT)=16 (4 bit)'#13+
'256 (8 BIT)=256 (8 bit)'#13+
'32768 (15 BIT)=32768 (15 bit)'#13+
'65536 (16 BIT)=65536 (16 bit)'#13+
'16M (24 BIT)=16M (24 bit)'#13+
'16M (32 BIT)=16M (32 bit)'#13+
'MEDIAN=�rednia'#13+
'WHISKER=Wisker'#13+
'PATTERN COLOR EDITOR=Edytor koloru desenia'#13+
'IMAGE=Obraz'#13+
'BACK DIAGONAL=Uko�ny odwrotny'#13+
'DIAGONAL CROSS=Siatka uko�na'#13+
'FILL 80%=Wype�nienie 80%'#13+
'FILL 60%=Wype�nienie 60%'#13+
'FILL 40%=Wype�nienie 40%'#13+
'FILL 20%=Wype�nienie 20%'#13+
'FILL 10%=Wype�nienie 10%'#13+
'ZIG ZAG=Zygzak'#13+
'VERTICAL SMALL=Pionowy drobny'#13+
'HORIZ. SMALL=Poziomy drobny'#13+
'DIAG. SMALL=Uko�ny drobny'#13+
'BACK DIAG. SMALL=Uko�ny odwr. drobny'#13+
'CROSS SMALL=Drobna siatka'#13+
'DIAG. CROSS SMALL=Drobna siatka uko�na'#13+
'DAYS=Dni'#13+
'WEEKDAYS=Dni tygodnia'#13+
'TODAY=Dzi�'#13+
'SUNDAY=Niedziela'#13+
'TRAILING=Dni po�rednie'#13+
'MONTHS=Miesi�ce'#13+
'LINES=Linie'#13+
'SHOW WEEKDAYS=Dni tygodnia'#13+
'UPPERCASE=Du�e litery'#13+
'TRAILING DAYS=Dni po�rednie'#13+
'SHOW TODAY=Poka� Dzisiaj'#13+
'SHOW MONTHS=Poka� Miesi�ce'#13+
'CANDLE WIDTH=Szerok. �wiecy'#13+
'STICK=Sztyft'#13+
'BAR=S�upek'#13+
'OPEN CLOSE=Otwar. Zamkn.'#13+
'UP CLOSE=G�ra zamkni�te'#13+
'DOWN CLOSE=D� zamkni�te'#13+
'SHOW OPEN=Poka� Otwar.'#13+
'SHOW CLOSE=Poka� Zamkn.'#13+
'DRAW 3D=3W'#13+
'DARK 3D=3w ciemny'#13+
'EDITING=Redagowanie'#13+
'CHART=Wykres'#13+
'SERIES=Serie'#13+
'DATA=Dane'#13+
'TOOLS=Narz�dzia'#13+
'EXPORT=Eksport'#13+
'PRINT=Drukowanie'#13+
'GENERAL=Og�lne'#13+
'TITLES=Tytu�'#13+
'LEGEND=Legenda'#13+
'PANEL=Panel'#13+
'PAGING=Strona'#13+
'WALLS=�ciana'#13+
'3D=3W'#13+
'ADD=Dodaj'#13+
'DELETE=Usu�'#13+
'TITLE=Nazwa'#13+
'CLONE=Powiel'#13+
'CHANGE=Zmie�'#13+
'HELP=Pomoc'#13+
'CLOSE=Zamknij'#13+
'TEECHART PRINT PREVIEW=TeeChart Podgl�d Wydruku'#13+
'PRINTER=Drukarka'#13+
'SETUP=Ustawienia'#13+
'ORIENTATION=Orientacja'#13+
'PORTRAIT=Pionowo'#13+
'LANDSCAPE=Poziomo'#13+
'MARGINS (%)=Marginesy (%)'#13+
'DETAIL=Szceg�y'#13+
'MORE=Wi�cej'#13+
'NORMAL=Normalnie'#13+
'RESET MARGINS=Przywr�� marginesy'#13+
'VIEW MARGINS=Poka� marginesy'#13+
'PROPORTIONAL=Proporcjonalny'#13+
'CIRCLE=Ko�o'#13+
'VERTICAL LINE=Linia pionowa'#13+
'HORIZ. LINE=Linia pozioma'#13+
'TRIANGLE=Tr�kat'#13+
'INVERT. TRIANGLE=Odwr�cony tr�k�t'#13+
'LINE=Linia'#13+
'DIAMOND=Diament'#13+
'CUBE=Sze�cian'#13+
'STAR=Gwiazda'#13+
'TRANSPARENT=Przezroczysty'#13+
'HORIZ. ALIGNMENT=U�o�enie poziome'#13+
'CENTER=�rodek'#13+
'RIGHT=Prawo'#13+
'ROUND RECTANGLE=Zaokr�g. prostok�t'#13+
'ALIGNMENT=U�o�enie'#13+
'BOTTOM=D�'#13+
'UNITS=Jednostki'#13+
'PIXELS=Piksele'#13+
'AXIS ORIGIN=Pocz�tek osi'#13+
'ROTATION=Obr�t'#13+
'CIRCLED=Okr�g�y'#13+
'3 DIMENSIONS=3 Wymiary'#13+
'RADIUS=Promie�'#13+
'ANGLE INCREMENT=Inkrement k�ta'#13+
'RADIUS INCREMENT=Inkrement promienia'#13+
'CLOSE CIRCLE=Zamkni�te ko�o'#13+
'PEN=Pi�rko'#13+
'LABELS=Etykiety'#13+
'ROTATED=Obr�cone'#13+
'CLOCKWISE=Zegarowo'#13+
'INSIDE=wewn�trz'#13+
'ROMAN=Rzym.'#13+
'HOURS=Godziny'#13+
'MINUTES=Minuty'#13+
'SECONDS=Sekundy'#13+
'START VALUE=Wart. pocz.'#13+
'END VALUE=Wart. ko�c.'#13+
'TRANSPARENCY=Przezroczysto��'#13+
'DRAW BEHIND=Rysuj w tle'#13+
'COLOR MODE=Tryb koloru'#13+
'STEPS=Kroki'#13+
'RANGE=Zakres'#13+
'PALETTE=Paleta'#13+
'PALE=Blado'#13+
'STRONG=Mocno'#13+
'GRID SIZE=Rozmiar siatki'#13+
'X=X'#13+
'Z=Z'#13+
'DEPTH=G��bok.'#13+
'IRREGULAR=Nieregularny'#13+
'GRID=Siatka'#13+
'ALLOW DRAG=Pozw�l ci�gn��'#13+
'VERTICAL POSITION=Pozycja pionowa'#13+
'LEVELS POSITION=Pozycja poziomu'#13+
'LEVELS=Poziomy'#13+
'NUMBER=Liczba'#13+
'LEVEL=Poziom'#13+
'AUTOMATIC=Automat.'#13+
'SNAP=Zatrzask'#13+
'FOLLOW MOUSE=�ladem myszy'#13+
'STACK=Stos'#13+
'HEIGHT 3D=Wysoko�� 3W'#13+
'LINE MODE=Tryb linii'#13+
'OVERLAP=Na��'#13+
'STACK 100%=Stos 100%'#13+
'CLICKABLE=Mo�na klika�'#13+
'AVAILABLE=Dost�pne'#13+
'SELECTED=Wybrane'#13+
'DATASOURCE=�r�d�o danych'#13+
'GROUP BY=Grupuj wg'#13+
'CALC=Licz.'#13+
'OF=z'#13+
'SUM=Sum'#13+
'COUNT=Ilo��'#13+
'HIGH=Wysoko'#13+
'LOW=Nisko'#13+
'AVG=�red.'#13+
'HOUR=Godz.'#13+
'DAY=Dzie�'#13+
'WEEK=Tydzie�'#13+
'WEEKDAY=Dzie� tygodnia'#13+
'MONTH=Miesi�c'#13+
'QUARTER=Kwarta�'#13+
'YEAR=Rok'#13+
'HOLE %=Otw�r %'#13+
'RESET POSITIONS=Reset pozycji'#13+
'MOUSE BUTTON=Przycisk myszy'#13+
'ENABLE DRAWING=Pozw�l rysowa�'#13+
'ENABLE SELECT=Pozw�l wybiera�'#13+
'ENHANCED=Ulepszony'#13+
'ERROR WIDTH=Szerok. b��du'#13+
'WIDTH UNITS=Jedn. szerok.'#13+
'PERCENT=Procent'#13+
'LEFT AND RIGHT=Lewo i Prawo'#13+
'TOP AND BOTTOM=G�ra i D�'#13+
'BORDER EDITOR=Edytor kraw�dzi'#13+
'DASH=Kreska'#13+
'DOT=Kropka'#13+
'DASH DOT=Kreska Kropka'#13+
'DASH DOT DOT=Kreska Kropka Kropka'#13+
'CALCULATE EVERY=Oblicz ka�dy'#13+
'ALL POINTS=Wszystkie punkt.'#13+
'NUMBER OF POINTS=Liczba punkt�w'#13+
'RANGE OF VALUES=Zakres warto�ci'#13+
'FIRST=Pierwszy'#13+
'LAST=Ostatni'#13+
'TEEPREVIEW EDITOR=Edytor Tee-podgl�du'#13+
'ALLOW MOVE=Pozw�l przesuwa�'#13+
'ALLOW RESIZE=Pozw�l zm. rozmiar'#13+
'DRAG IMAGE=Ci�gnij obraz'#13+
'AS BITMAP=Jako bitmapa'#13+
'SHOW IMAGE=Poka� obraz'#13+
'MARGINS=Marginesy'#13+
'SIZE=Rozm.'#13+
'3D %=3W %'#13+
'ZOOM=Zoom'#13+
'ELEVATION=Wzniesienie'#13+
'100%=100%'#13+
'HORIZ. OFFSET=Przes.poziome'#13+
'VERT. OFFSET=Przes.pionowe'#13+
'PERSPECTIVE=Perspektywa'#13+
'ANGLE=K�t'#13+
'ORTHOGONAL=Ortogonalny'#13+
'ZOOM TEXT=Zoom Tekst'#13+
'SCALES=Skale'#13+
'TICKS=Podzia�ka'#13+
'MINOR=Drobna'#13+
'MAXIMUM=Maksimum'#13+
'MINIMUM=Minimum'#13+
'(MAX)=(max)'#13+
'(MIN)=(min)'#13+
'DESIRED INCREMENT=Po��dany przyrost'#13+
'(INCREMENT)=(przyrost)'#13+
'LOG BASE=Podstawa log'#13+
'LOGARITHMIC=Logarytmiczny'#13+
'MIN. SEPARATION %=Min. odst�p %'#13+
'MULTI-LINE=Multi-linia'#13+
'LABEL ON AXIS=Etykieta na osi'#13+
'ROUND FIRST=Zaokr�glij pierwsz�'#13+
'MARK=Znak.'#13+
'LABELS FORMAT=Format etykiet'#13+
'EXPONENTIAL=Wyk�adniczy'#13+
'DEFAULT ALIGNMENT=Domy�lne po�o�enie'#13+
'LEN=D�ug.'#13+
'INNER=Wewn�trz'#13+
'AT LABELS ONLY=Tylko przy etykiet.'#13+
'CENTERED=Centrowany'#13+
'POSITION %=Pozycja %'#13+
'START %=Pocz�tek %'#13+
'END %=Koniec %'#13+
'OTHER SIDE=Inna strona'#13+
'AXES=Osie'#13+
'BEHIND=Z ty�u'#13+
'CLIP POINTS=all'#13+
'PRINT PREVIEW=Podgl�d wydruku'#13+
'MINIMUM PIXELS=Minimum pikseli'#13+
'ALLOW=Pozw�l'#13+
'ANIMATED=Animowany'#13+
'ALLOW SCROLL=Pozw�l przewija�'#13+
'TEEOPENGL EDITOR=TeeOpenGL Edytor'#13+
'AMBIENT LIGHT=O�wietlenie'#13+
'SHININESS=Po�ysk'#13+
'FONT 3D DEPTH=G��b. czcionki 3W'#13+
'ACTIVE=Aktywny'#13+
'FONT OUTLINES=Kontur czcionki'#13+
'SMOOTH SHADING=P�ynne cieniowanie'#13+
'LIGHT=�wiat�o'#13+
'Y=Y'#13+
'INTENSITY=Intensywn.'#13+
'BEVEL=Skos'#13+
'FRAME=Ramka'#13+
'ROUND FRAME=Zaokr. ramka'#13+
'LOWERED=Obni�ony'#13+
'RAISED=Podniesiony'#13+
'SYMBOLS=Symbole'#13+
'TEXT STYLE=Styl tekstu'#13+
'LEGEND STYLE=Styl legendy'#13+
'VERT. SPACING=Odst�p pion.'#13+
'SERIES NAMES=Nazwy serii'#13+
'SERIES VALUES=Warto�ci serii'#13+
'LAST VALUES=Ostatnie warto�ci'#13+
'PLAIN=Plain'#13+
'LEFT VALUE=Lewo Warto��'#13+
'RIGHT VALUE=Prawo Warto��'#13+
'LEFT PERCENT=Lewo Procent'#13+
'RIGHT PERCENT=Prawo Procent'#13+
'X VALUE=X Warto��'#13+
'X AND VALUE=X i Warto��'#13+
'X AND PERCENT=X i Procent'#13+
'CHECK BOXES=Pola wyboru'#13+
'DIVIDING LINES=Linie podzia�u'#13+
'FONT SERIES COLOR=Kolor czcionki serii'#13+
'POSITION OFFSET %=Przes. pozycji %'#13+
'MARGIN=Margines'#13+
'RESIZE CHART=Oryginalny rozmiar'#13+
'CONTINUOUS=Ci�g�y'#13+
'POINTS PER PAGE=Punkty na stron�'#13+
'SCALE LAST PAGE=Skaluj ostatni� stron�'#13+
'CURRENT PAGE LEGEND=Legenda bie�acej strony'#13+
'PANEL EDITOR=Edytor panelu'#13+
'BACKGROUND=T�o'#13+
'BORDERS=Kraw�dzie'#13+
'BACK IMAGE=Obraz w tle'#13+
'STRETCH=Rozci�gnij'#13+
'TILE=Wype�nij'#13+
'BEVEL INNER=Skos wewn.'#13+
'BEVEL OUTER=Skos zewn.'#13+
'MARKS=Znaczniki'#13+
'DATA SOURCE=�r�d�o danych'#13+
'SORT=Sortuj'#13+
'CURSOR=Kursor'#13+
'SHOW IN LEGEND=Poka� w legendzie'#13+
'FORMATS=Formaty'#13+
'VALUES=Warto�ci'#13+
'PERCENTS=Procenty'#13+
'HORIZONTAL AXIS=O� pozioma'#13+
'DATETIME=Data/Czas'#13+
'VERTICAL AXIS=O� pionowa'#13+
'ASCENDING=Rosn�co'#13+
'DESCENDING=Malej�co'#13+
'DRAW EVERY=Rysuj wszystko'#13+
'CLIPPED=Obci�te'#13+
'ARROWS=Strza�ki'#13+
'MULTI LINE=Multi-linia'#13+
'ALL SERIES VISIBLE=Wszystkie serie widoczne'#13+
'LABEL=Etykieta'#13+
'LABEL AND PERCENT=Etykieta i procent'#13+
'LABEL AND VALUE=Etykieta i warto��'#13+
'PERCENT TOTAL=Procent ca�o�ci'#13+
'LABEL AND PERCENT TOTAL=Etykieta i procent ca�o�ci'#13+
'X AND Y VALUES=X i Y Warto��'#13+
'MANUAL=R�cznie'#13+
'RANDOM=Losowo'#13+
'FUNCTION=Funkcja'#13+
'NEW=Nowy'#13+
'EDIT=Redaguj'#13+
'PERSISTENT=Trwa�y'#13+
'ADJUST FRAME=Ustal ramk�'#13+
'SUBTITLE=Podtytu�'#13+
'SUBFOOT=Stopka 2'#13+
'FOOT=Stopka'#13+
'VISIBLE WALLS=�ciany widoczne'#13+
'BACK=Z ty�u'#13+
'DIF. LIMIT=Dif. Limit'#13+
'ABOVE=Ponad'#13+
'WITHIN=Wewn�trz'#13+
'BELOW=Poni�ej'#13+
'CONNECTING LINES=Linie ��cz�ce'#13+
'BROWSE=Szukaj w'#13+
'TILED=Wype�niony'#13+
'INFLATE MARGINS=Zwi�ksz marginesy'#13+
'SQUARE=Kwadrat'#13+
'DOWN TRIANGLE=Odwr�cony tr�jk�t'#13+
'SMALL DOT=Ma�e kropki'#13+
'GLOBAL=Globalny'#13+
'SHAPES=Kszta�ty'#13+
'BRUSH=P�dzel'#13+
'DELAY=Zw�oka'#13+
'MSEC.=msek.'#13+
'MOUSE ACTION=Akcja myszy'#13+
'MOVE=Poruszaj'#13+
'CLICK=Klik'#13+
'DRAW LINE=Rysuj linie'#13+
'EXPLODE BIGGEST=Wysu� najwi�kszy'#13+
'TOTAL ANGLE=K�t sumaryczny'#13+
'GROUP SLICES=Grupuj kawa�ki'#13+
'BELOW %=Poni�ej %'#13+
'BELOW VALUE=Poni�ej warto�ci'#13+
'OTHER=Inne'#13+
'PATTERNS=Desenie'#13+
'SIZE %=Rozmiar %'#13+
'SERIES DATASOURCE TEXT EDITOR=Edytor tekstu zr�de� danych serii'#13+
'FIELDS=Pola'#13+
'NUMBER OF HEADER LINES=Ilo�� linii nag��wka'#13+
'SEPARATOR=Separator'#13+
'COMMA=Przecinek'#13+
'SPACE=Spacja'#13+
'TAB=Tabulator'#13+
'FILE=Plik'#13+
'WEB URL=Web URL'#13+
'LOAD=Za�aduj'#13+
'C LABELS=C Etykiety'#13+
'R LABELS=R Etykiety'#13+
'C PEN=C Pi�rko'#13+
'R PEN=R Pi�rko'#13+
'STACK GROUP=Grupowanie'#13+
'MULTIPLE BAR=Wiele s�upk�w'#13+
'SIDE=S�siaduj�co'#13+
'SIDE ALL=S�siad. wszystkie'#13+
'DRAWING MODE=Tryb rysowania'#13+
'WIREFRAME=Siatka druc.'#13+
'DOTFRAME=Siatka punkt.'#13+
'SMOOTH PALETTE=P�ynna paleta'#13+
'SIDE BRUSH=P�dzel boczny'#13+
'ABOUT TEECHART PRO V6.01=Info TeeChart Pro v6.01'#13+
'ALL RIGHTS RESERVED.=Wczystkie Prawa Zastrze�one.'#13+
'VISIT OUR WEB SITE !=Odwied� nasz� witryn� !'#13+
'TEECHART WIZARD=TeeChart Kreator'#13+
'SELECT A CHART STYLE=Wybierz styl wykresu'#13+
'DATABASE CHART=Wykres bazodanowy'#13+
'NON DATABASE CHART=Wykres nie bazodanowy'#13+
'SELECT A DATABASE TABLE=Wybierz tabel� bazy danych'#13+
'ALIAS=Alias'#13+
'TABLE=Tabela'#13+
'BORLAND DATABASE ENGINE=Borland Database Engine'#13+
'MICROSOFT ADO=Microsoft ADO'#13+
'SELECT THE DESIRED FIELDS TO CHART=Wybierz pola do wykresu'#13+
'SELECT A TEXT LABELS FIELD=Wybierz pole z tekstem etykiet'#13+
'CHOOSE THE DESIRED CHART TYPE=Wybierz typ wykresu'#13+
'2D=2W'#13+
'CHART PREVIEW=Podgl�d wykresu'#13+
'SHOW LEGEND=Poka� legend�'#13+
'SHOW MARKS=Poka� znaczniki'#13+
'< BACK=< Wstecz'#13+
'EXPORT CHART=Eksportuj wykres'#13+
'PICTURE=Obraz'#13+
'NATIVE=TeeFile'#13+
'KEEP ASPECT RATIO=Trzymaj proporcje'#13+
'INCLUDE SERIES DATA=Do��cz dane serii'#13+
'FILE SIZE=Rozmiar pliku'#13+
'DELIMITER=Ogranicznik'#13+
'XML=XML'#13+
'HTML TABLE=Tabela HTML'#13+
'EXCEL=Excel'#13+
'COLON=Dwukropek'#13+
'INCLUDE=W��cz'#13+
'POINT LABELS=Etykiety punktu'#13+
'POINT INDEX=Indeks punktu'#13+
'HEADER=Nag��wek'#13+
'COPY=Kopiuj'#13+
'SAVE=Zapisz'#13+
'SEND=Wy�lij'#13+
'FUNCTIONS=Funkcje'#13+
'ADX=ADX'#13+
'AVERAGE=�rednia'#13+
'BOLLINGER=Bollinger'#13+
'DIVIDE=Podziel'#13+
'EXP. AVERAGE=�rednia.Exp.'#13+
'EXP.MOV.AVRG.=�rednia.Exp.Ruch.'#13+
'MACD=MACD'#13+
'MOMENTUM=P�d'#13+
'MOMENTUM DIV=P�d Div'#13+
'MOVING AVRG.=�redn.ruchoma'#13+
'MULTIPLY=Pomn�'#13+
'R.S.I.=R.S.I'#13+
'ROOT MEAN SQ.=�red.pierw.kw.'#13+
'STD.DEVIATION=Odch.Stand.'#13+
'STOCHASTIC=Stochastyczny'#13+
'SUBTRACT=Odejmij'#13+
'SOURCE SERIES=�r�d�o serii'#13+
'TEECHART GALLERY=Galleria TeeChart'#13+
'DITHER=Rozedrgaj'#13+
'REDUCTION=Redukcja'#13+
'COMPRESSION=Kompresja'#13+
'LZW=LZW'#13+
'RLE=RLE'#13+
'NEAREST=Najbli�szy'#13+
'FLOYD STEINBERG=Floyd Steinberg'#13+
'STUCKI=Stucki'#13+
'SIERRA=Sierra'#13+
'JAJUNI=JaJuNI'#13+
'STEVE ARCHE=Steve Arche'#13+
'BURKES=Burkes'#13+
'WINDOWS 20=Windows 20'#13+
'WINDOWS 256=Windows 256'#13+
'WINDOWS GRAY=Windows Szary'#13+
'GRAY SCALE=Skala szaro�ci'#13+
'NETSCAPE=Netscape'#13+
'QUANTIZE=Kwantyzuj'#13+
'QUANTIZE 256=Kwantyzuj 256'#13+
'% QUALITY=% Jako��'#13+
'PERFORMANCE=Prezentacja'#13+
'QUALITY=Jako��'#13+
'SPEED=Pr�dko��'#13+
'COMPRESSION LEVEL=Poziom kompresji'#13+
'CHART TOOLS GALLERY=Galeria narz�dzi wykresu'#13+
'ANNOTATION=Adnotacja'#13+
'AXIS ARROWS=Strza�ki osi'#13+
'COLOR BAND=Koloruj pasmo'#13+
'COLOR LINE=koloruj linie'#13+
'DRAG MARKS=Ci�gnij znaczniki'#13+
'MARK TIPS=Tipsy znacznika'#13+
'NEAREST POINT=Najbli�szy punkt'#13+
'ROTATE=Obr��'#13+
'YES=Tak'#13+

{$IFDEF TEEOCX}
'TEECHART PRO -- SELECT ADO DATASOURCE=TeeChart Pro -- Wybierz �rod�o danych ADO'#13+
'CONNECTION=Po��czenie'#13+
'DATASET=Zbi�r danych'#13+
'TABLE=Tabela'#13+
'SQL=SQL'#13+
'SYSTEM TABLES=Tabele systemowe'#13+
'LOGIN PROMPT=Login'#13+
'SELECT=Wybierz'#13+
'TEECHART IMPORT=TeeChart import'#13+
'IMPORT CHART FROM=Importuj wykres z'#13+
'IMPORT NOW=Importuj teraz'#13+
'EDIT CHART=Redaguj wykres'#13+
{$ENDIF}

// 6.0

'PERIOD='#13+
'UP='#13+
'DOWN='#13+
'SHADOW EDITOR='#13+
'CALLOUT='#13+
'TEXT ALIGNMENT='#13+
'DISTANCE='#13+
'ARROW HEAD='#13+
'POINTER='#13+
'AVAILABLE LANGUAGES='#13+
'CHOOSE A LANGUAGE='#13+
'CALCULATE USING='#13+
'EVERY NUMBER OF POINTS='#13+
'EVERY RANGE='#13+
'INCLUDE NULL VALUES='#13+
'INVERTED SCROLL='#13+
'DATE='#13+
'ENTER DATE='#13+
'ENTER TIME='#13+
'BEVEL SIZE='#13+
'DEVIATION='#13+
'UPPER='#13+
'LOWER='#13+
'NOTHING='#13+
'LEFT TRIANGLE='#13+
'RIGHT TRIANGLE='#13+
'SHOW PREVIOUS BUTTON='#13+
'SHOW NEXT BUTTON='#13+
'CONSTANT='#13+
'SHOW LABELS='#13+
'SHOW COLORS='#13+
'XYZ SERIES='#13+
'SHOW X VALUES='#13+
'DELETE ROW='#13+
'VOLUME SERIES='#13+
'ACCUMULATE='#13+
'SINGLE='#13+
'REMOVE CUSTOM COLORS='#13+
'STEP='#13+
'USE PALETTE MINIMUM='#13+
'AXIS MAXIMUM='#13+
'AXIS CENTER='#13+
'AXIS MINIMUM='#13+
'DRAG REPAINT='#13+
'NO LIMIT DRAG='#13+
'DAILY (NONE)='#13+
'WEEKLY='#13+
'MONTHLY='#13+
'BI-MONTHLY='#13+
'QUARTERLY='#13+
'YEARLY='#13+
'DATETIME PERIOD='#13+
'SMOOTH='#13+
'INTERPOLATE='#13+
'START X='#13+
'NUM. POINTS='#13+
'COLOR EACH LINE='#13+
'CASE SENSITIVE='#13+
'SORT BY='#13+
'(NONE)='#13+
'CALCULATION='#13+
'GROUP='#13+
'DRAG STYLE='#13+
'WEIGHT='#13+
'EDIT LEGEND='#13+
'ROUND='#13+
'FLAT='#13+
'DRAW ALL='#13+
'IGNORE NULLS='#13+
'OFFSET='#13+
'LIGHT 0='#13+
'LIGHT 1='#13+
'LIGHT 2='#13+
'DRAW STYLE='#13+
'POINTS='#13+
'DEFAULT BORDER='#13+
'SQUARED='#13+
'SHOW PAGE NUMBER='#13+
'SEPARATION='#13+
'ROUND BORDER='#13+
'NUMBER OF SAMPLE VALUES='#13+
'RESIZE PIXELS TOLERANCE='#13+
'FULL REPAINT='#13+
'END POINT='#13+
'BAND 1='#13+
'BAND 2='#13+
'GRID 3D SERIES='#13+
'TRANSPOSE NOW='#13+
'PERIOD 1='#13+
'PERIOD 2='#13+
'PERIOD 3='#13+
'HISTOGRAM='#13+
'EXP. LINE='#13+
'WEIGHTED='#13+
'WEIGHTED BY INDEX='#13+
'DARK BORDER='#13+
'PIE SERIES='#13+
'FOCUS='#13+
'EXPLODE='#13+
'BOX SIZE='#13+
'REVERSAL AMOUNT='#13+
'PERCENTAGE='#13+
'COMPLETE R.M.S.='#13+
'BUTTON='#13+
'START AT MIN. VALUE='#13+
'EXECUTE !='#13+
'IMAG. SYMBOL='#13+
'FACTOR='#13+
'SELF STACK='#13+
'SIDE LINES='#13+
'CHART FROM TEMPLATE (*.TEE FILE)='#13+
'OPEN TEECHART TEMPLATE FILE FROM='#13+
'EXPORT DIALOG='#13+
'BINARY='#13+
'POINT COLORS='#13+
'OUTLINE GRADIENT='#13+
'CLOSE LOCATION VALUE='#13+
'COMMODITY CHANNEL INDEX='#13+
'CROSS POINTS='#13+
'ON BALANCE VOLUME='#13+
'SMOOTHING='#13+
'TREND='#13+
'VOLUME OSCILLATOR='#13+
'BALANCE='#13+
'RADIAL OFFSET='#13+
'HORIZ='#13+
'VERT='#13+
'RADIAL='#13+
'COVER='#13+
'ARROW WIDTH='#13+
'ARROW HEIGHT='#13+
'DEFAULT COLOR='#13+
'VALUE SOURCE='#13

;

  end;
end;

Procedure TeeSetPolish;
begin
  TeeCreatePolish;
  TeeLanguage:=TeePolishLanguage;
  TeePolishConstants;
  TeeLanguageHotKeyAtEnd:=False;
  TeeLanguageCanUpper:=True;
end;

initialization
finalization
  FreeAndNil(TeePolishLanguage);
end.
