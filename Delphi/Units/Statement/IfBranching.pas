﻿unit IfBranching;

interface
uses Base, vcl.graphics, DrawShapes, MinMaxInt, Vcl.ExtCtrls, DetermineDimensions;
type

  TIfBranching = class(TOperator)
  private const
    FBlockCount = 2;
  private
    function GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
    function GetMinValidPartWidth(const ATextHeight, ATextWidth: Integer): Integer;
  protected
    function GetOptimaWidth: Integer; override;
    procedure CreateBlock; override;
    procedure InitializeBlock; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimalYLast: Integer; override;
  public class var
    TrueCond, FalseCond: String;
  public
    procedure Draw; override;
    function IsPreсOperator: Boolean; override;
  end;

implementation

  function TIfBranching.GetOptimalYLast: Integer;
  begin
    Result := FYStart + Max(GetTextHeight(FCanvas, TrueCond),
                          GetTextHeight(FCanvas, FalseCond)) +
                          GetTextHeight(FCanvas, FAction) + 3 * YIndentText;
  end;

  function TIfBranching.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TIfBranching.CreateBlock;
  begin
    SetLength(FBlocks, FBlockCount);

    FBlocks[0]:= TBlock.Create(FBaseBlock.XStart,
                       (FBaseBlock.XStart + FBaseBlock.XLast) div 2, Self);

    FBlocks[1]:= TBlock.Create(FBlocks[0].XLast, FBaseBlock.XLast, Self);
  end;

  procedure TIfBranching.InitializeBlock;
  begin
    FBlocks[0].AddFirstStatement(DefaultBlock.CreateUncertainty(FBlocks[0], FCanvas), FYLast);
    FBlocks[1].AddFirstStatement(DefaultBlock.CreateUncertainty(FBlocks[1], FCanvas), FYLast);
  end;

  function TIfBranching.GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
  begin
    Result:= APartWidth *
             (FYLast - FYStart - ATextHeight - YIndentText) div (FYLast - FYStart);
  end;

  function TIfBranching.GetMinValidPartWidth(const ATextHeight,
                                             ATextWidth: Integer): Integer;
  begin
    Result:= (ATextWidth + 2 * XMinIndentText) *
             (FYLast - FYStart) div (FYLast - FYStart - ATextHeight - YIndentText);
  end;

  function TIfBranching.GetOptimaWidth: Integer;
  begin
    Result:= GetMinValidPartWidth(GetTextHeight(FCanvas, FAction),
                                              GetTextWidth(FCanvas, FAction));
  end;

  function TIfBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  var
    I: Integer;
  begin
    if ABlock = FBlocks[0] then
    Result:= GetMinValidPartWidth(GetTextHeight(FCanvas, TrueCond),
                                  GetTextWidth(FCanvas, TrueCond))
    else if ABlock = FBlocks[1] then
    Result:= GetMinValidPartWidth(GetTextHeight(FCanvas, FalseCond),
                                  GetTextWidth(FCanvas, FalseCond))
  end;

  procedure TIfBranching.Draw;
  var
    CondHeight: Integer;
    ActionHeight: Integer;
  begin

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FCanvas);

    // Drawing a triangle
    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[1].XStart, BaseBlock.XLast,
                                                FYStart, FYLast, FCanvas);

    // Calculate the heights of texts
    ActionHeight := GetTextHeight(FCanvas, FAction);
    CondHeight := GetTextHeight(FCanvas, TrueCond);

    // Drawing the action
    DrawText(FCanvas,
      FBlocks[0].XStart +
      GetAvailablePartWidth(FBlocks[0].XLast - FBlocks[0].XStart, CondHeight + YIndentText) +
      GetAvailablePartWidth(BaseBlock.XLast - BaseBlock.XStart, ActionHeight) div 2 -
      GetTextWidth(FCanvas, FAction) div 2,
      FYStart + YIndentText, Action);

    // Drawing the True text
    DrawText(FCanvas,
                    FBlocks[0].XStart + GetAvailablePartWidth(
                    FBlocks[0].XLast - FBlocks[0].XStart, CondHeight) div 2 -
                    GetTextWidth(FCanvas, TrueCond) div 2,
                    FYStart + 2*YIndentText + ActionHeight, TrueCond);

    // Drawing the False text
    CondHeight := GetTextHeight(FCanvas, FalseCond);
    DrawText(FCanvas,
                    FBlocks[1].XLast - GetAvailablePartWidth(
                    FBlocks[1].XLast - FBlocks[1].XStart, CondHeight) div 2 -
                    GetTextWidth(FCanvas, FalseCond) div 2,
                    FYStart + 2*YIndentText + ActionHeight, FalseCond);

    // Drawing child blocks
    FBlocks[0].DrawBlock;
    FBlocks[1].DrawBlock;
  end;


  initialization
  TIfBranching.TrueCond := 'False';
  TIfBranching.FalseCond := 'True';

end.
