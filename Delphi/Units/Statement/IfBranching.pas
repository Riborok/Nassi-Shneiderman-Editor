unit IfBranching;

interface
uses Base, DrawShapes, MinMaxInt, DetermineDimensions;
type

  TIfBranching = class(TOperator)
  private const
    FBlockCount = 2;
  private class var
    TrueCond, FalseCond: String;
  private
    FTrueWidth, FTrueHeight: Integer;
    FFalseWidth, FFalseHeight: Integer;
    function GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
    function GetMinValidPartWidth(const ATextHeight, ATextWidth: Integer): Integer;
  protected
    procedure SetTextSize; override;
    function GetOptimaWidth: Integer; override;
    procedure CreateBlock; override;
    procedure InitializeBlock; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimalYLast: Integer; override;
    procedure Draw; override;
  public
    function IsPreсOperator: Boolean; override;
    class procedure ChangeConditions(const ATrue, AFalse: String);
    function Clone: TStatement; override;
  end;

implementation

  procedure TIfBranching.SetTextSize;
  begin
    inherited;
    FTrueWidth:= GetTextWidth(BaseBlock.Canvas, TrueCond);
    FTrueHeight:= GetTextHeight(BaseBlock.Canvas, TrueCond);

    FFalseWidth:= GetTextWidth(BaseBlock.Canvas, FalseCond);
    FFalseHeight:= GetTextHeight(BaseBlock.Canvas, FalseCond);
  end;

  function TIfBranching.Clone: TStatement;
  var
    ResultIf: TIfBranching;
  begin
    Result:= inherited;
    ResultIf:= TIfBranching(Result);

    ResultIf.FTrueWidth := Self.FTrueWidth;
    ResultIf.FTrueHeight := Self.FTrueHeight;

    ResultIf.FFalseWidth := Self.FFalseWidth;
    ResultIf.FFalseHeight := Self.FFalseHeight;
  end;

  class procedure TIfBranching.ChangeConditions(const ATrue, AFalse: String);
  begin
    TrueCond:= ATrue;
    FalseCond:= AFalse;
  end;

  function TIfBranching.GetOptimalYLast: Integer;
  begin
    Result := FYStart + Max(FTrueHeight, FFalseHeight) + FActHeight + 3 * FYIndentText;
  end;

  function TIfBranching.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TIfBranching.CreateBlock;
  begin
    SetLength(FBlocks, FBlockCount);

    FBlocks[0]:= TBlock.Create(FBaseBlock.XStart,
                       (FBaseBlock.XStart + FBaseBlock.XLast) div 2, Self, BaseBlock.Canvas);

    FBlocks[1]:= TBlock.Create(FBlocks[0].XLast, FBaseBlock.XLast, Self, BaseBlock.Canvas);
  end;

  procedure TIfBranching.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[0]);
    FBlocks[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalYLast;

    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[1]);
    FBlocks[1].Statements.Add(NewStatement);
    NewStatement.SetOptimalYLast;
  end;

  function TIfBranching.GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
  begin
    Result:= APartWidth *
             (FYLast - FYStart - ATextHeight - FYIndentText) div (FYLast - FYStart);
  end;

  function TIfBranching.GetMinValidPartWidth(const ATextHeight,
                                             ATextWidth: Integer): Integer;
  begin
    Result:= (ATextWidth + 2 * FXMinIndentText) *
             (FYLast - FYStart) div (FYLast - FYStart - ATextHeight - FYIndentText);
  end;

  function TIfBranching.GetOptimaWidth: Integer;
  begin
    Result:= GetMinValidPartWidth(FActHeight, FActWidth);
  end;

  function TIfBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  var
    I: Integer;
  begin
    if ABlock = FBlocks[0] then
      Result:= GetMinValidPartWidth(FTrueHeight, FTrueWidth)
    else if ABlock = FBlocks[1] then
      Result:= GetMinValidPartWidth(FFalseHeight, FFalseWidth);
  end;

  procedure TIfBranching.Draw;
  begin

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

    // Drawing a triangle
    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[1].XStart, BaseBlock.XLast,
                                                FYStart, FYLast, BaseBlock.Canvas);

    // Drawing the action
    DrawText(BaseBlock.Canvas,
      FBlocks[0].XStart +
      GetAvailablePartWidth(FBlocks[0].XLast - FBlocks[0].XStart, FTrueHeight + FYIndentText) +
      GetAvailablePartWidth(BaseBlock.XLast - BaseBlock.XStart, FActHeight) div 2 -
      FActWidth div 2,
      FYStart + FYIndentText, Action);

    // Drawing the True text
    DrawText(BaseBlock.Canvas,
                    FBlocks[0].XStart + GetAvailablePartWidth(
                    FBlocks[0].XLast - FBlocks[0].XStart, FTrueHeight) div 2 -
                    FTrueWidth div 2,
                    FYStart + 2*FYIndentText + FActHeight, TrueCond);

    // Drawing the False text
    DrawText(BaseBlock.Canvas,
                    FBlocks[1].XLast - GetAvailablePartWidth(
                    FBlocks[1].XLast - FBlocks[1].XStart, FFalseHeight) div 2 -
                    FFalseWidth div 2,
                    FYStart + 2*FYIndentText + FActHeight, FalseCond);

    // Drawing child blocks
    FBlocks[0].DrawBlock;
    FBlocks[1].DrawBlock;
  end;


  initialization
  TIfBranching.TrueCond := 'False';
  TIfBranching.FalseCond := 'True';

end.
