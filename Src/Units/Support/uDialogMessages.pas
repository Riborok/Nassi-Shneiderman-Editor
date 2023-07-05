unit uDialogMessages;

interface

resourcestring
  rsErrorFile = 'Error: Failed to read the file.' + sLineBreak +
                'The specified file could not be accessed or does not exist.' + sLineBreak +
                'Please ensure that the file path is correct and the necessary permissions are granted.' + sLineBreak +
                'Additionally, the file may contain incorrect or invalid data, such as improperly formatted dates or other inconsistencies.' + sLineBreak +
                'Please review the file contents and make sure they adhere to the expected format.';
  rsExitDlgPart1 = 'You have made changes to the "';
  rsExitDlgPart2 = '" diagram. Would you like to save before exiting?';
  rsNewSchemeName = 'Scheme Name';
  rsNewSchemeContent = 'Please enter the scheme name:';
  rsNewDlg = '"Creating a new sheet will discard your current changes. Are you sure you want to proceed?';

implementation

end.
