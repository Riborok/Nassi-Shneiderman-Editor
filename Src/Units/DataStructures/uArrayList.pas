unit uArrayList;

interface

type
  TArrayList<T> = class
  private const
    MinInitialCapacity = 1;
  private
    FArray: array of T;
    FCount: Integer;
    procedure CapacityInc;
    procedure CapacityDec;
    function GetItem(const AIndex: Integer): T;
    procedure SetItem(const AIndex: Integer; const AValue: T);
  public
    constructor Create(AInitialCapacity: Integer = MinInitialCapacity);
    destructor Destroy; override;
    procedure Delete(const AIndex: Integer);
    procedure Add(const Item: T);
    procedure Insert(const AItem: T; const AIndex: Integer);
    procedure Clear;
    property Items[const Index: Integer]: T read GetItem write SetItem; default;
    property Count: Integer read FCount;
    function GetLast: T;
  end;

implementation

  constructor TArrayList<T>.Create(AInitialCapacity: Integer = MinInitialCapacity);
  begin
    if AInitialCapacity < MinInitialCapacity then
      AInitialCapacity := MinInitialCapacity;
    FCount := 0;
    SetLength(FArray, AInitialCapacity);
  end;

  destructor TArrayList<T>.Destroy;
  begin
    SetLength(FArray, 0);
    inherited;
  end;

  procedure TArrayList<T>.Add(const Item: T);
  begin
    if FCount = Length(FArray) then
      CapacityInc;

    FArray[FCount] := Item;
    Inc(FCount);
  end;

  procedure TArrayList<T>.Delete(const AIndex: Integer);
  var
    I: Integer;
  begin
    for I := AIndex to FCount - 2 do
      FArray[I] := FArray[I + 1];

    Dec(FCount);

    if (Length(FArray) >= 4) and (FCount <= Length(FArray) shr 2) then
      CapacityDec;
  end;

  procedure TArrayList<T>.Insert(const AItem: T; const AIndex: Integer);
  var
    I: Integer;
  begin

    if FCount = Length(FArray) then
      CapacityInc;

    for I := FCount - 1 downto AIndex do
      FArray[I + 1] := FArray[I];

    FArray[AIndex] := AItem;
    Inc(FCount);
  end;

  procedure TArrayList<T>.Clear;
  begin
    FCount := 0;
  end;

  function TArrayList<T>.GetItem(const AIndex: Integer): T;
  begin
    Result := FArray[AIndex];
  end;

  procedure TArrayList<T>.SetItem(const AIndex: Integer; const AValue: T);
  begin
    FArray[AIndex] := AValue;
  end;

  function TArrayList<T>.GetLast: T;
  begin
    Result:= FArray[FCount - 1];
  end;

  procedure TArrayList<T>.CapacityInc;
  begin
    SetLength(FArray, Length(FArray) shl 1);
  end;

  procedure TArrayList<T>.CapacityDec;
  begin
    SetLength(FArray, Length(FArray) shr 1);
  end;

end.

