unit uStatementSearch;

interface
uses
  uBase;

  function BinarySearchStatement(const AX, AY: Integer; const ABlock: TBlock): TStatement;
  function BinarySearchBlock(const Blocks: TBlockArr; const AX: Integer): TBlock;
implementation

  function BinarySearchBlock(const Blocks: TBlockArr; const AX: Integer): TBlock;
  var
    L, R, M: Integer;
  begin
    Result := nil;
    L := 0;
    R := High(Blocks);
    while L <= R do
    begin
      M := (L + R) shr 1;

      if (AX >= Blocks[M].XStart) and (AX <= Blocks[M].XLast) then
        Exit(Blocks[M])

      else if AX < Blocks[M].XStart then
        R := M - 1
      else
        L := M + 1;
    end;
  end;

  function BinarySearchStatement(const AX, AY: Integer; const ABlock: TBlock): TStatement;
  var
    L, R, M: Integer;
    CurrOperator: TOperator;
    CurrStatement: TStatement;
  begin
    Result := nil;

    if (AX >= ABlock.XStart) and (AX <= ABlock.XLast) then
    begin

      L := 0;
      R := ABlock.Statements.Count - 1;

      while L <= R do
      begin

        M := (L + R) shr 1;
        CurrStatement := ABlock.Statements[M];

        if (AY >= CurrStatement.YStart) and (AY <= CurrStatement.GetYBottom) then
        begin

          if CurrStatement is TOperator then
          begin

            CurrOperator:= TOperator(CurrStatement);

            case CurrOperator.IsPreñOperator of
              True:
                if AY <= CurrOperator.YLast then
                  Exit(CurrStatement);
              False:
                if AY >= CurrOperator.Blocks[0].Statements.GetLast.GetYBottom then
                  Exit(CurrStatement);
            end;

            if AX <= CurrOperator.BaseBlock.XStart + CurrOperator.GetOffsetFromXStart then
              Exit(CurrStatement);

            Exit(BinarySearchStatement(AX, AY, BinarySearchBlock(CurrOperator.Blocks, AX)));
          end
          else
            Exit(CurrStatement);
        end
        else if AY < CurrStatement.YStart then
          R := M - 1
        else
          L := M + 1;
      end;
    end
  end;


end.
