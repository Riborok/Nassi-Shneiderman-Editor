﻿unit uLastLoop;

interface
uses
  uDrawShapes, uLoop;
type

  TLastLoop = class(TLoop)
  protected
    function GetOptimalYLast: Integer; override;
    procedure Draw; override;
  public
    function GetBlockYBottom: Integer;
    function IsPreсOperator: Boolean; override;
    function GetSerialNumber: Integer; override;
  end;

implementation

  function TLastLoop.IsPreсOperator: Boolean;
  begin
    Result:= False;
  end;

  procedure TLastLoop.Draw;
  begin
    DrawUnfinishedVertRectForLoop(BaseBlock.XStart, BaseBlock.XLast, FYLast,
                         GetYBottom, FYStart, BaseBlock.Canvas);

    DrawUnfinishedHorRectForLoop(BaseBlock.XStart, Blocks[0].XStart,
                         BaseBlock.XLast, FYLast, FYStart, BaseBlock.Canvas);

    DrawText(BaseBlock.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) shr 1)
                         - (FActionSize.Width shr 1), GetBlockYBottom + FYIndentText, Action);
  end;

  function TLastLoop.GetOptimalYLast: Integer;
  begin
    Result := GetBlockYBottom + FActionSize.Height + FXMinIndentText shl 1;
  end;

  function TLastLoop.GetSerialNumber: Integer;
  begin
    Result := 4;
  end;

  function TLastLoop.GetBlockYBottom: Integer;
  begin
    Result:= FBlocks[0].Statements.GetLast.GetYBottom;
  end;

end.
