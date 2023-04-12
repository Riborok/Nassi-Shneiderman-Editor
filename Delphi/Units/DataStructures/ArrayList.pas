unit ArrayList;

interface
uses System.SysUtils;

type
  TArrayList<T> = class
  private type
    TArray = array of T;
  private
    FArray: TArray;
    FCount: Integer;
    procedure CapacityInc;
    function GetItem(const AIndex: Integer): T;
    procedure SetItem(const AIndex: Integer; const AValue: T);
  public
    property GetArray: TArray read FArray;
    constructor Create(const AInitialCapacity: Integer = 0);
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

  constructor TArrayList<T>.Create(const AInitialCapacity: Integer = 0);
  begin
    FCount := 0;
    SetLength(FArray, AInitialCapacity);
  end;

  destructor TArrayList<T>.Destroy;
  begin
    Clear;

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

    if (AIndex < 0) or (AIndex >= FCount) then
      raise Exception.Create('Index out of bounds');

    for I := AIndex to FCount - 2 do
      FArray[I] := FArray[I + 1];

    Dec(FCount);

  end;

  procedure TArrayList<T>.Insert(const AItem: T; const AIndex: Integer);
  var
    I: Integer;
  begin

    if (AIndex < 0) or (AIndex > FCount) then
      raise Exception.Create('Index out of bounds');

    if FCount = Length(FArray) then
      CapacityInc;

    for I := FCount - 1 downto AIndex do
      FArray[I + 1] := FArray[I];

    FArray[AIndex] := AItem;
    Inc(FCount);
  end;

  procedure TArrayList<T>.Clear;
  begin

    SetLength(FArray, 0);

    FCount := 0;
  end;

  function TArrayList<T>.GetItem(const AIndex: Integer): T;
  begin

    if (AIndex < 0) or (AIndex >= FCount) then
      raise Exception.Create('Index out of bounds');

    Result := FArray[AIndex];
  end;

  procedure TArrayList<T>.SetItem(const AIndex: Integer; const AValue: T);
  begin

    if (AIndex < 0) or (AIndex >= FCount) then
      raise Exception.Create('Index out of bounds');


    FArray[AIndex] := AValue;
  end;

  function TArrayList<T>.GetLast: T;
  begin

    if FCount < 1 then
      raise Exception.Create('Index out of bounds');

    Result:= FArray[FCount - 1];
  end;

  procedure TArrayList<T>.CapacityInc;
  begin
    SetLength(FArray, Length(FArray) * 2 + 4);
  end;

end.

