{|----------------------------------------------------------------------
 | Library:     DelForEx4
 |
 | Author:      Egbert van Nes
 |
 | Description: The library generating the expert dll
 |              to be used with Delphi 4
 |              Compile with packages to save memory
 |              (it needs Delphi anyway)
 |              The engine of the formatter is in a separate dll
 |              of which the source code is not free
 |
 | Copyright (c) 2000  Egbert van Nes
 |   All rights reserved
 |   Disclaimer and licence notes: see license.txt
 |
 |----------------------------------------------------------------------
}
library DelForEx4;


{$IFNDEF Ver120}
Compile this expert only for Delphi 4
{$ENDIF}

uses
  ShareMem,
  Forms,
  Windows,
  ExptIntf,
  ToolIntf,
  VirtIntf,
  SysUtils,
  Classes,
  DelForExpert in 'DelForExpert.pas',
  MyIDEStream in 'MyIDEStream.pas',
  Progr in 'progr.pas' {ProgressDlg},
  OptDlg in 'OptDlg.pas' {OptionsDlg},
  DelExpert in 'DelExpert.pas' {DelExpertDlg},
  Delfor1 in 'Delfor1.pas',
  EditFile in 'EditFile.pas' {FileEditDlg},
  OObjects in 'oObjects.pas',
  DelforEng in 'DelforEng.pas';

exports
  InitExpert Name ExpertEntryPoint;


begin
end.
