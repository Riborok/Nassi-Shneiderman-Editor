﻿unit IfBranching;

interface
uses Base, vcl.graphics, DrawShapes, MinMaxInt, Vcl.ExtCtrls;
type

  TIfBranching = class(TOperator)
  private
    FBlocks: TBlockArr;
    function GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
    function GetMinValidPartWidth(const ATextHeight, ATextWidth: Integer): Integer;
  protected
    procedure CreateBlock(const ABaseBlock: TBlock); override;
    procedure InitializeBlock; override;
    function GetOptimalXLast: Integer; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    procedure SetInitiaXLast; override;
    function GetOptimalYLast: Integer; override;
  private class var
    FTrueText, FFalseText: string;
  private const
    FBlockCount = 2;
  public
    destructor Destroy; override;
    constructor Create(AYStart: Integer; const AAction: string;
                       const ABaseBlock: TBlock; const AImage: TImage);
    procedure Draw; override;
    function GetBlocks: TBlockArr; override;
    function GetBlockCount: Integer; override;
    function IsPreсOperator: Boolean; override;
  end;

implementation

  function TIfBranching.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  function TIfBranching.GetBlocks: TBlockArr;
  begin
    Result:= FBlocks;
  end;

  function TIfBranching.GetBlockCount: Integer;
  begin
    Result:= FBlockCount;
  end;

  destructor TIfBranching.Destroy;
  begin

    FBlocks[0].Destroy;
    FBlocks[1].Destroy;

    inherited;
  end;

  procedure TIfBranching.CreateBlock (const ABaseBlock: TBlock);
  begin
    SetLength(FBlocks, FBlockCount);

    FBlocks[0]:= TBlock.Create(ABaseBlock.XStart,
                       (ABaseBlock.XStart + ABaseBlock.XLast) div 2, Self);

    FBlocks[1]:= TBlock.Create(FBlocks[0].XLast, ABaseBlock.XLast, Self);
  end;

  constructor TIfBranching.Create(AYStart: Integer; const AAction:
                           string; const ABaseBlock: TBlock; const AImage: TImage);
  begin
    inherited Create(AYStart, AAction, ABaseBlock, AImage);
  end;

  procedure TIfBranching.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FYLast, FBlocks[0], FImage);
    FBlocks[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalHeight;

    NewStatement:= DefaultBlock.CreateUncertainty(FYLast, FBlocks[1], FImage);
    FBlocks[1].Statements.Add(NewStatement);
    NewStatement.SetOptimalHeight;
  end;

  function TIfBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= -1;
    if ABlock = FBlocks[0] then
      result:= GetMinValidPartWidth(GetTextHeight(FImage.Canvas, FTrueText),
                                              GetTextWidth(FImage.Canvas, FTrueText))
    else if ABlock = FBlocks[1] then
      result:= GetMinValidPartWidth(GetTextHeight(FImage.Canvas, FFalseText),
                                              GetTextWidth(FImage.Canvas, FFalseText));
  end;

  function TIfBranching.GetOptimalXLast: Integer;
  begin
    Result:= GetMinValidPartWidth(GetTextHeight(FImage.Canvas, FAction),
                                              GetTextWidth(FImage.Canvas, FAction));
  end;

  function TIfBranching.GetOptimalYLast: Integer;
  begin
    Result := FYStart + GetTextHeight(FImage.Canvas, FTrueText) +
              GetTextHeight(FImage.Canvas, FAction) + 3 * YIndentText;
  end;

  function TIfBranching.GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
  begin
    Result:= Round(APartWidth *
             (FYLast - FYStart - ATextHeight - YIndentText) / (FYLast - FYStart));
  end;

  function TIfBranching.GetMinValidPartWidth(const ATextHeight,
                                             ATextWidth: Integer): Integer;
  begin
    Result:= Round((ATextWidth + 2 * XMinIndentText) *
             (FYLast - FYStart) / (FYLast - FYStart - ATextHeight - YIndentText));
  end;

  procedure TIfBranching.SetInitiaXLast;
  begin
    FBlocks[0].SetOptimalXLastBlock;
  end;

  procedure TIfBranching.Draw;
  var
    TrueWidth, TrueHeight: Integer;
    FalseWidth, FalseHeight: Integer;
    TextWidth, TextHeight: Integer;
    Right: Integer;
  begin

    // Calculate the dimensions of the text
    TextWidth := GetTextWidth(FImage.Canvas, FAction);
    TextHeight := GetTextHeight(FImage.Canvas, FAction);

    TrueWidth := GetTextWidth(FImage.Canvas, FTrueText);
    TrueHeight := GetTextHeight(FImage.Canvas, FTrueText);

    FalseWidth := GetTextWidth(FImage.Canvas, FFalseText);
    FalseHeight := GetTextHeight(FImage.Canvas, FFalseText);

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    // Drawing the text
    DrawText(FImage.Canvas,
      FBlocks[0].XStart +
      GetAvailablePartWidth(FBlocks[0].XLast - FBlocks[0].XStart, TrueHeight + YIndentText) +
      GetAvailablePartWidth(BaseBlock.XLast - BaseBlock.XStart, TextHeight) div 2 -
      TextWidth div 2,
      FYStart + YIndentText, Action);

    // Drawing the True and False text
    DrawText(FImage.Canvas,
                    FBlocks[0].XStart + GetAvailablePartWidth(
                    FBlocks[0].XLast - FBlocks[0].XStart, TrueHeight) div 2 -
                    TrueWidth div 2,
                    FYStart + 2*YIndentText + TextHeight, FTrueText);

    DrawText(FImage.Canvas,
                    FBlocks[1].XLast - GetAvailablePartWidth(
                    FBlocks[1].XLast - FBlocks[1].XStart, FalseHeight) div 2 -
                    FalseWidth div 2,
                    FYStart + 2*YIndentText + TextHeight, FFalseText);

    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[0].XLast, BaseBlock.XLast,
                                                      FYStart, FYLast, FImage.Canvas);

    FBlocks[0].DrawBlock;
    FBlocks[1].DrawBlock;
  end;


  initialization
  TIfBranching.FTrueText := 'False';
  TIfBranching.FFalseText := 'True';

end.