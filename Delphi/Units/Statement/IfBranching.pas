﻿unit IfBranching;

interface
uses Base, ConditionalOperator, vcl.graphics, DrawShapes, MinMaxInt, Vcl.ExtCtrls, DetermineDimensions;
type

  TIfBranching = class(TConditionalOperator)
  private const
    FBlockCount = 2;
  private
    function GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
    function GetMinValidPartWidth(const ATextHeight, ATextWidth: Integer): Integer;
  protected
    function GetOptimaWidth: Integer; override;
    procedure CreateBlock; override;
    procedure InitializeBlock; override;
    function GetCondition(const Index: Integer): String; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
  public class var
    TrueCond, FalseCond: String;
  public
    procedure Draw; override;
    function IsPreсOperator: Boolean; override;
  end;

implementation

  function TIfBranching.GetCondition(const Index: Integer): String;
  begin
    case Index of
      0: Result:= TrueCond;
      1: Result:= FalseCond;
      else Result:= '';
    end;
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
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[0], FImage);
    FBlocks[0].AddLast(NewStatement, False);

    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[1], FImage);
    FBlocks[1].AddLast(NewStatement, True);
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
    Result:= GetMinValidPartWidth(GetTextHeight(FImage.Canvas, FAction),
                                              GetTextWidth(FImage.Canvas, FAction));
  end;

  function TIfBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  var
    I: Integer;
  begin
    I:= FindBlockIndex(ABlock.XStart);
    Result:= GetMinValidPartWidth(GetTextHeight(FImage.Canvas, GetCondition(I)),
                                  GetTextWidth(FImage.Canvas, GetCondition(I)));
  end;

  procedure TIfBranching.Draw;
  var
    TrueWidth, TrueHeight: Integer;
    FalseWidth, FalseHeight: Integer;
    ActionWidth, ActionHeight: Integer;
  begin

    // Calculate the dimensions of the action
    ActionWidth := GetTextWidth(FImage.Canvas, FAction);
    ActionHeight := GetTextHeight(FImage.Canvas, FAction);

    TrueWidth := GetTextWidth(FImage.Canvas, TrueCond);
    TrueHeight := GetTextHeight(FImage.Canvas, TrueCond);

    FalseWidth := GetTextWidth(FImage.Canvas, FalseCond);
    FalseHeight := GetTextHeight(FImage.Canvas, FalseCond);

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    // Drawing the text
    DrawText(FImage.Canvas,
      FBlocks[0].XStart +
      GetAvailablePartWidth(FBlocks[0].XLast - FBlocks[0].XStart, TrueHeight + YIndentText) +
      GetAvailablePartWidth(BaseBlock.XLast - BaseBlock.XStart, ActionHeight) div 2 -
      ActionWidth div 2,
      FYStart + YIndentText, Action);

    // Drawing the True and False text
    DrawText(FImage.Canvas,
                    FBlocks[0].XStart + GetAvailablePartWidth(
                    FBlocks[0].XLast - FBlocks[0].XStart, TrueHeight) div 2 -
                    TrueWidth div 2,
                    FYStart + 2*YIndentText + ActionHeight, TrueCond);

    DrawText(FImage.Canvas,
                    FBlocks[1].XLast - GetAvailablePartWidth(
                    FBlocks[1].XLast - FBlocks[1].XStart, FalseHeight) div 2 -
                    FalseWidth div 2,
                    FYStart + 2*YIndentText + ActionHeight, FalseCond);

    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[0].XLast, BaseBlock.XLast,
                                                      FYStart, FYLast, FImage.Canvas);

    FBlocks[0].DrawBlock;
    FBlocks[1].DrawBlock;
  end;


  initialization
  TIfBranching.TrueCond := 'False';
  TIfBranching.FalseCond := 'True';

end.
