unit uConstants;

interface
const
  SchemeIndent = 10;
  Space = ' ';
  mmFontSize = 14;
  mmFontName = 'Times New Roman';
  MaxTextLength = 14242;
  VK_Z = $5A;
  VK_X = $58;
  VK_C = $43;
  VK_V = $56;
  VK_F = $46;
  VK_P = $50;
  VK_G = $47;

  constExtStat = '.stat';
  constExtJSON = '.json';
  constExtSVG = '.svg';
  constExtBmp = '.bmp';
  constExtPng = '.png';
  constExtAll = '.*';

  dirAppData = 'AppData';
  PathToMITLicense = 'Help\MITLicense.txt';
  PathToGitHubLicense = 'https://github.com/Riborok/Nassi-Shneiderman-Editor/blob/main/LICENSE';

resourcestring
  rsUseGuide = 'UserGuide';
  rsAbout = 'AboutProgram';

  rsFMJSON = 'JSON Files (*' + constExtJSON + ')|*' + constExtJSON;
  rsFMSVG = 'SVG Files (*' + constExtSVG + ')|*' + constExtSVG;
  rsFMBmp = 'Bitmap Files (*' + constExtBmp + ')|*' + constExtBmp;
  rsFMPng = 'PNG Files (*' + constExtPng + ')|*' + constExtPng;
  rsFMStat = 'PNG Files (*' + constExtStat +')|*' + constExtStat;
  rsFMAll = 'All Files (*' + constExtAll + ')|*' + constExtAll;

implementation

end.
