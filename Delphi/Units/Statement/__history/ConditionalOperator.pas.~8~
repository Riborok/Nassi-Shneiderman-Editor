unit ConditionalOperator;

interface
uses Base, Vcl.ExtCtrls, DetermineDimensions;
type
  TConditionalOperator = class abstract(TOperator)
  protected
    function GetOptimalYLast: Integer; override;
    function GetCondition(const Index: Integer): String; virtual; abstract;
  end;

implementation

  function TConditionalOperator.GetOptimalYLast: Integer;
  var
    I: Integer;
    MaxConditionHeight, CurrConditionHeight: Integer;
  begin
    MaxConditionHeight:= GetTextHeight(FImage.Canvas, GetCondition(0));
    for I := 1 to High(FBlocks) do
    begin
      CurrConditionHeight:= GetTextHeight(FImage.Canvas, GetCondition(I));
      if CurrConditionHeight > MaxConditionHeight then
        MaxConditionHeight:= CurrConditionHeight;
    end;
    Result := FYStart + MaxConditionHeight + GetTextHeight(FImage.Canvas,
                                              FAction) + 3 * YIndentText;
  end;

end.
