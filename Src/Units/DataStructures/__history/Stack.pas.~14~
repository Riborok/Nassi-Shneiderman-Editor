unit Stack;

interface

type
  TStack<T> = class
  private type
    PItem = ^TItem;
    TItem = record
      FData: T;
      FNext: PItem;
    end;
  private
    FTop: PItem;
    FCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(const AItem: T);
    function Pop: T;
    function Peek: T;
    property Count: Integer read FCount;
  end;

implementation

  constructor TStack<T>.Create;
  begin
    FTop := nil;
    FCount := 0;
  end;

  destructor TStack<T>.Destroy;
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      Pop;
    inherited;
  end;

  procedure TStack<T>.Push(const AItem: T);
  var
    NewItem: PItem;
  begin
    New(NewItem);

    NewItem^.FData := AItem;
    NewItem^.FNext := FTop;
    FTop := NewItem;

    Inc(FCount);
  end;

  function TStack<T>.Pop: T;
  var
    Item: PItem;
  begin
    Item := FTop;
    FTop := FTop^.FNext;
    Result := Item^.FData;

    Dispose(Item);

    Dec(FCount);
  end;

  function TStack<T>.Peek: T;
  begin
    Result := FTop^.FData;
  end;

end.

