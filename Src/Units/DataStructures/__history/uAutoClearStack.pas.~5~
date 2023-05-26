unit uAutoClearStack;

interface
uses
  uStack;
type
  TAutoClearStack<T> = class(TStack<T>)
  private const
    MaxAmount = 142;
  public
    procedure Push(const AItem: T);
  end;

implementation
  procedure TAutoClearStack<T>.Push(const AItem: T);
  begin
    if Count > MaxAmount then
      Clear;
    inherited;
  end;
end.
