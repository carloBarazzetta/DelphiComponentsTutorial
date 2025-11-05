object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'ClockLabel App Demo - '#169' Ethea S.r.l.'
  ClientHeight = 230
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    466
    230)
  TextHeight = 15
  object ClockLabel: TClockLabel
    Left = 32
    Top = 8
    Width = 146
    Height = 50
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ClockType = ctCustomClock
  end
  object MatrixClockLabel: TClockLabel
    Left = 32
    Top = 63
    Width = 224
    Height = 42
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = '5x7 DOT Matrix'
    Font.Style = []
    ParentFont = False
    OnClick = EditComponent
    SpecialFont = sfDotMatrix
  end
  object AlarmClockLabel: TClockLabel
    Left = 32
    Top = 133
    Width = 228
    Height = 39
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBrown
    Font.Height = -37
    Font.Name = 'alarm clock'
    Font.Style = []
    ParentFont = False
    OnClick = EditComponent
    ClockType = ctMillisecondsClock
    DisplayFormat = 'hh:mm:ss.zzz'
    SpecialFont = sfAlarmClock
    TimerInterval = 10
  end
  object hhmmClockLabel: TClockLabel
    Left = 32
    Top = 178
    Width = 88
    Height = 50
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = EditComponent
    ClockType = ctHourMinutesClock
    DisplayFormat = 'hh:mm'
  end
  object AppStyleRadioGroup: TRadioGroup
    Left = 273
    Top = 8
    Width = 185
    Height = 105
    Anchors = [akTop, akRight]
    Caption = 'Change Style'
    ItemIndex = 0
    Items.Strings = (
      'Windows'
      'Windows10'
      'Windows10 Dark')
    TabOrder = 0
    OnClick = AppStyleRadioGroupClick
  end
end
