unit IfBranching;

interface
uses Base, ConditionalOperator, vcl.graphics, DrawShapes, MinMaxInt, Vcl.ExtCtrls, DetermineDimensions;
type

  TIfBranching = class(TConditionalOperator)
  private const
    FBlockCount = 2;
  protected
    procedure CreateBlock(const ABaseBlock: TBlock); override;
    procedure InitializeBlock; override;
    function GetCondition(const Index: Integer): String; override;
  private class var
    FFirstCond, FSecondCond: string;
  public
    procedure Draw; override;
    function IsPreсOperator: Boolean; override;
  end;

implementation

  function TIfBranching.GetCondition(const Index: Integer): String;
  begin
    case Index of
      0: Result:= FFirstCond;
      1: Result:= FSecondCond;
    end;
  end;

  function TIfBranching.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TIfBranching.CreateBlock (const ABaseBlock: TBlock);
  begin
    SetLength(FBlocks, FBlockCount);

    FBlocks[0]:= TBlock.Create(ABaseBlock.XStart,
                       (ABaseBlock.XStart + ABaseBlock.XLast) div 2, Self);

    FBlocks[1]:= TBlock.Create(FBlocks[0].XLast, ABaseBlock.XLast, Self);
  end;

  procedure TIfBranching.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[0], FImage);
    FBlocks[0].AddLast(NewStatement, False);

    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[1], FImage);
    FBlocks[1].AddLast(NewStatement, True);
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

    TrueWidth := GetTextWidth(FImage.Canvas, FFirstCond);
    TrueHeight := GetTextHeight(FImage.Canvas, FFirstCond);

    FalseWidth := GetTextWidth(FImage.Canvas, FSecondCond);
    FalseHeight := GetTextHeight(FImage.Canvas, FSecondCond);

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
                    FYStart + 2*YIndentText + TextHeight, FFirstCond);

    DrawText(FImage.Canvas,
                    FBlocks[1].XLast - GetAvailablePartWidth(
                    FBlocks[1].XLast - FBlocks[1].XStart, FalseHeight) div 2 -
                    FalseWidth div 2,
                    FYStart + 2*YIndentText + TextHeight, FSecondCond);

    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[0].XLast, BaseBlock.XLast,
                                                      FYStart, FYLast, FImage.Canvas);

    FBlocks[0].DrawBlock;
    FBlocks[1].DrawBlock;
  end;


  initialization
  TIfBranching.FFirstCond := 'False';
  TIfBranching.FSecondCond := 'True';

end.
