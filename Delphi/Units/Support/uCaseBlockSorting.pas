﻿unit uCaseBlockSorting;

interface
uses
  uAdditionalTypes, uStack, uBase;
type
  TCompareFunction = function(const AFirstStr, ASecondStr: String): Boolean;

procedure QuickSort(const AStr: TStringArr; const ABlocks : TBlockArr;
                    const ACompare: TCompareFunction);

function CompareStrAsc(const AFirstStr, ASecondStr: string): Boolean;
function CompareStrDesc(const AFirstStr, ASecondStr: string): Boolean;
implementation

  procedure QuickSort(const AStr: TStringArr; const ABlocks : TBlockArr;
                      const ACompare: TCompareFunction);
  type
    TIndexRange = record
      LeftIndex: Integer;
      RightIndex: Integer;
    end;
  var
    I, J: Integer;
    Pivot: string;
    TempStr: string;
    TempBlock: TBlock;
    Stack: TStack<TIndexRange>;
    IndexRange: TIndexRange;
  begin
    Stack := TStack<TIndexRange>.Create;

    IndexRange.LeftIndex := Low(AStr);
    IndexRange.RightIndex := High(AStr);
    Stack.Push(IndexRange);

    while Stack.Count > 0 do
    begin
      IndexRange := Stack.Pop;

      Pivot := AStr[(IndexRange.LeftIndex + IndexRange.RightIndex) shr 1];

      I := IndexRange.LeftIndex;
      J := IndexRange.RightIndex;

      repeat
        while ACompare(AStr[I], Pivot) do
          Inc(I);

        while ACompare(Pivot, AStr[J]) do
          Dec(J);

        if I <= J then
        begin
          TempStr := AStr[I];
          AStr[I] := AStr[J];
          AStr[J] := TempStr;

          TempBlock := ABlocks[I];
          ABlocks[I] := ABlocks[J];
          ABlocks[J] := TempBlock;

          Inc(I);
          Dec(J);
        end;
      until I > J;

      if IndexRange.LeftIndex < J then
      begin
        I:= IndexRange.RightIndex;
        IndexRange.RightIndex := J;
        Stack.Push(IndexRange);

        IndexRange.LeftIndex := IndexRange.RightIndex + 1;
        IndexRange.RightIndex := I;
        Stack.Push(IndexRange);
      end

      else if IndexRange.RightIndex > I then
      begin
        J := IndexRange.LeftIndex;
        IndexRange.LeftIndex := I;
        Stack.Push(IndexRange);

        IndexRange.RightIndex := IndexRange.LeftIndex - 1;
        IndexRange.LeftIndex := J;
        Stack.Push(IndexRange);
      end;
    end;

    Stack.Destroy;
  end;

  function CompareStrAsc(const AFirstStr, ASecondStr: string): Boolean;
  begin
    if Length(AFirstStr) = Length(ASecondStr) then
      Result := AFirstStr < ASecondStr
    else
      Result := Length(AFirstStr) < Length(ASecondStr);
  end;

  function CompareStrDesc(const AFirstStr, ASecondStr: string): Boolean;
  begin
    if Length(AFirstStr) = Length(ASecondStr) then
      Result := AFirstStr > ASecondStr
    else
      Result := Length(AFirstStr) > Length(ASecondStr);
  end;
end.
