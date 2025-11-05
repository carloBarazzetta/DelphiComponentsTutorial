object ClockLabelEditor: TClockLabelEditor
  Left = 0
  Top = 0
  Caption = 'ClockLabel Component Editor %s - Copyright Ethea S.r.l.'
  ClientHeight = 172
  ClientWidth = 367
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 383
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object BottomPanel: TPanel
    Left = 269
    Top = 0
    Width = 98
    Height = 172
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object OKButton: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 92
      Height = 26
      Align = alTop
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = OKButtonClick
    end
    object ApplyButton: TButton
      AlignWithMargins = True
      Left = 3
      Top = 67
      Width = 92
      Height = 26
      Align = alTop
      Caption = '&Apply'
      TabOrder = 2
      OnClick = ApplyButtonClick
    end
    object CancelButton: TButton
      AlignWithMargins = True
      Left = 3
      Top = 35
      Width = 92
      Height = 26
      Align = alTop
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpButton: TButton
      AlignWithMargins = True
      Left = 3
      Top = 99
      Width = 92
      Height = 26
      Align = alTop
      Caption = '&Help'
      TabOrder = 3
      OnClick = HelpButtonClick
    end
  end
  object PropertiesPanel: TPanel
    Left = 0
    Top = 0
    Width = 269
    Height = 172
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object ClockLabel: TClockLabel
      AlignWithMargins = True
      Left = 10
      Top = 137
      Width = 249
      Height = 25
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      ExplicitWidth = 42
      ExplicitHeight = 13
    end
    object PreviewLabel: TLabel
      Left = 0
      Top = 114
      Width = 269
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'PREVIEW'
      Color = clWindow
      ParentColor = False
      ExplicitWidth = 46
    end
    object ClockTypeGroupBox: TGroupBox
      Left = 0
      Top = 0
      Width = 269
      Height = 57
      Align = alTop
      Caption = 'ClockType Property'
      TabOrder = 0
      object ClockTypeComboBox: TComboBox
        AlignWithMargins = True
        Left = 5
        Top = 21
        Width = 259
        Height = 21
        Margins.Top = 6
        Align = alClient
        Style = csDropDownList
        TabOrder = 0
        OnSelect = ComboBoxSelect
      end
    end
    object SpecialFontGroupBox: TGroupBox
      Left = 0
      Top = 57
      Width = 269
      Height = 57
      Align = alTop
      Caption = 'Special Font Property'
      TabOrder = 1
      object SpecialFontComboBox: TComboBox
        AlignWithMargins = True
        Left = 5
        Top = 21
        Width = 259
        Height = 21
        Margins.Top = 6
        Align = alClient
        Style = csDropDownList
        TabOrder = 0
        OnSelect = ComboBoxSelect
      end
    end
  end
end
