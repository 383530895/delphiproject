object frmEncrypt: TfrmEncrypt
  Left = 294
  Top = 201
  BorderStyle = bsDialog
  Caption = '���ܽ���'
  ClientHeight = 344
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 497
    Height = 49
    Align = alTop
    TabOrder = 0
    object lbl1: TLabel
      Left = 8
      Top = 16
      Width = 65
      Height = 15
      AutoSize = False
      Caption = '�����ܳף�'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = '����'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 296
      Top = 16
      Width = 65
      Height = 15
      AutoSize = False
      Caption = '�ܳ׳��ȣ�'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = '����'
      Font.Style = []
      ParentFont = False
    end
    object edtKey: TEdit
      Left = 80
      Top = 11
      Width = 209
      Height = 21
      TabOrder = 0
      Text = 'ksykt123'
    end
    object cbbLength: TComboBox
      Left = 368
      Top = 10
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        '128λ'
        '192λ'
        '256λ')
    end
  end
  object grpSource: TGroupBox
    Left = 0
    Top = 49
    Width = 497
    Height = 80
    Align = alTop
    Caption = 'Դ�ַ���'
    TabOrder = 1
    object mmoSource: TMemo
      Left = 2
      Top = 15
      Width = 493
      Height = 63
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 129
    Width = 497
    Height = 80
    Align = alTop
    Caption = '���ܺ���ַ���'
    TabOrder = 2
    object mmoencrypt: TMemo
      Left = 2
      Top = 15
      Width = 493
      Height = 63
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 209
    Width = 497
    Height = 88
    Align = alTop
    Caption = '���ܺ���ַ���'
    TabOrder = 3
    object mmoDecrypt: TMemo
      Left = 2
      Top = 15
      Width = 493
      Height = 71
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object btnEncrypt: TRzButton
    Left = 256
    Top = 304
    Width = 65
    Caption = '�� ��'
    Color = 15791348
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '����'
    Font.Style = []
    HighlightColor = 16026986
    HotTrack = True
    HotTrackColor = 3983359
    ParentFont = False
    TabOrder = 4
    OnClick = btnEncryptClick
  end
  object btnDecrypy: TRzButton
    Left = 336
    Top = 304
    Width = 65
    Caption = '�� ��'
    Color = 15791348
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '����'
    Font.Style = []
    HighlightColor = 16026986
    HotTrack = True
    HotTrackColor = 3983359
    ParentFont = False
    TabOrder = 5
    OnClick = btnDecrypyClick
  end
  object btnClose: TRzButton
    Left = 416
    Top = 304
    Width = 65
    Caption = '�� ��'
    Color = 15791348
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '����'
    Font.Style = []
    HighlightColor = 16026986
    HotTrack = True
    HotTrackColor = 3983359
    ParentFont = False
    TabOrder = 6
    OnClick = btnCloseClick
  end
end
