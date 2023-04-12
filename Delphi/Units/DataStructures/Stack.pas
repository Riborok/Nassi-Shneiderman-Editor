unit Stack;

interface
uses System.SysUtils;

type
  TStack<T> = class
  private type
    PItem = ^TItem;
    TItem = record
      Data: T;
      Next: PItem;
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
  begin

    while FTop <> nil do
      Pop;

    inherited;
  end;

  procedure TStack<T>.Push(const AItem: T);
  var
    NewItem: PItem;
  begin

    New(NewItem);

    NewItem^.Data := AItem;
    NewItem^.Next := FTop;
    FTop := NewItem;

    Inc(FCount);
  end;

  function TStack<T>.Pop: T;
  var
    Item: PItem;
  begin

    if FTop = nil then
      raise Exception.Create('Stack is empty');

    Item := FTop;
    FTop := FTop^.Next;
    Result := Item^.Data;

    Dispose(Item);

    Dec(FCount);
  end;

  function TStack<T>.Peek: T;
  begin

    if FTop = nil then
      raise Exception.Create('Stack is empty');

    Result := FTop^.Data;
  end;

end.

