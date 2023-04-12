﻿unit IfBranching;

interface
uses Base, vcl.graphics, ProcessStatement, DrawShapes, MinMaxInt;
type

  TIfBranching = class(TOperator)
  private
    Blocks: TBlockArr;
    function GetAvailablePartWidth(const PartWidth, ATextHeight: Integer): Integer;
    function GetMinValidPartWidth(const ATextHeight, ATextWidth: Integer): Integer;
  protected
    procedure CreateBlock(const ABaseBlock: TBlock); override;
    procedure InitializeBlock; override;
    function GetOptimalWidth: Integer; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    procedure SetInitiaWidth; override;
    function GetOptimalHeight: Integer; override;
  private class var
    TrueText, FalseText: string;
  private const
    BlockCount = 2;
  public
    destructor Destroy; override;
    constructor Create(AYStart: Integer; const AAction: string;
                       const ABaseBlock: TBlock; const ACanvas: TCanvas);
    procedure Draw; override;
    function GetBlocks: TBlockArr; override;
    function GetBlockCount: Integer; override;
  end;

implementation

  function TIfBranching.GetBlocks: TBlockArr;
  begin
    result:= Blocks;
  end;

  function TIfBranching.GetBlockCount: Integer;
  begin
    result:= BlockCount;
  end;

  destructor TIfBranching.Destroy;
  begin

    Blocks[0].Destroy;
    Blocks[1].Destroy;

    inherited;
  end;

  procedure TIfBranching.CreateBlock (const ABaseBlock: TBlock);
  begin
    SetLength(Blocks, BlockCount);

    Blocks[0]:= TBlock.Create(
                       ABaseBlock.XStart,
                       (ABaseBlock.XStart + ABaseBlock.XLast) div 2, Self);

    Blocks[1]:= TBlock.Create(Blocks[0].XLast, ABaseBlock.XLast, Self);
  end;

  constructor TIfBranching.Create(AYStart: Integer; const AAction:
                           string; const ABaseBlock: TBlock; const ACanvas: TCanvas);
  begin
    inherited Create(AYStart, AAction, ABaseBlock, ACanvas);
  end;

  procedure TIfBranching.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= TProcessStatement.CreateUncertainty(FYLast, Blocks[0], FImage);
    Blocks[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalHeight;

    NewStatement:= TProcessStatement.CreateUncertainty(FYLast, Blocks[1], FImage);
    Blocks[1].Statements.Add(NewStatement);
    NewStatement.SetOptimalHeight;
  end;

  function TIfBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= -1;
    if ABlock = Blocks[0] then
      result:= GetMinValidPartWidth(GetTextHeight(FImage, TrueText),
                                              GetTextWidth(FImage, TrueText))
    else if ABlock = Blocks[1] then
      result:= GetMinValidPartWidth(GetTextHeight(FImage, FalseText),
                                              GetTextWidth(FImage, FalseText));
  end;

  function TIfBranching.GetOptimalWidth: Integer;
  begin
    Result:= GetMinValidPartWidth(GetTextHeight(FImage, FAction),
                                              GetTextWidth(FImage, FAction));
  end;

  function TIfBranching.GetOptimalHeight: Integer;
  begin
    Result := FYStart + GetTextHeight(FImage, TrueText) +
              GetTextHeight(FImage, FAction) + 3 * YIndentText;
  end;

  function TIfBranching.GetAvailablePartWidth(const PartWidth, ATextHeight: Integer): Integer;
  begin
    Result:= Round(PartWidth *
             (FYLast - FYStart - ATextHeight - YIndentText) / (FYLast - FYStart));
  end;

  function TIfBranching.GetMinValidPartWidth(const ATextHeight,
                                             ATextWidth: Integer): Integer;
  begin
    Result:= Round((ATextWidth + 2 * XMinIndentText) *
             (FYLast - FYStart) / (FYLast - FYStart - ATextHeight - YIndentText));
  end;

  procedure TIfBranching.SetInitiaWidth;
  begin
    Blocks[0].SetOptimalXLastBlock;
  end;

  procedure TIfBranching.Draw;
  var
    TrueWidth, TrueHeight: Integer;
    FalseWidth, FalseHeight: Integer;
    TextWidth, TextHeight: Integer;
    Right: Integer;
  begin

    // Calculate the dimensions of the text
    TextWidth := GetTextWidth(FImage, FAction);
    TextHeight := GetTextHeight(FImage, FAction);

    TrueWidth := GetTextWidth(FImage, TrueText);
    TrueHeight := GetTextHeight(FImage, TrueText);

    FalseWidth := GetTextWidth(FImage, FalseText);
    FalseHeight := GetTextHeight(FImage, FalseText);

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    // Drawing the text
    DrawText(FImage,
      Blocks[0].XStart +
      GetAvailablePartWidth(Blocks[0].XLast - Blocks[0].XStart, TrueHeight + YIndentText) +
      GetAvailablePartWidth(BaseBlock.XLast - BaseBlock.XStart, TextHeight) div 2 -
      TextWidth div 2,
      FYStart + YIndentText, Action);

    // Drawing the True and False text
    DrawText(FImage,
                    Blocks[0].XStart + GetAvailablePartWidth(
                    Blocks[0].XLast - Blocks[0].XStart, TrueHeight) div 2 -
                    TrueWidth div 2,
                    FYStart + 2*YIndentText + TextHeight, TrueText);

    DrawText(FImage,
                    Blocks[1].XLast - GetAvailablePartWidth(
                    Blocks[1].XLast - Blocks[1].XStart, FalseHeight) div 2 -
                    FalseWidth div 2,
                    FYStart + 2*YIndentText + TextHeight, FalseText);

    DrawInvertedTriangle(BaseBlock.XStart, Blocks[0].XLast, BaseBlock.XLast,
                                                      FYStart, FYLast, FImage);

    Blocks[0].DrawBlock;
    Blocks[1].DrawBlock;
  end;


  initialization
  TIfBranching.TrueText := 'False';
  TIfBranching.FalseText := 'True';

end.
