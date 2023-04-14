unit CaseBranching;

interface
uses Base, ArrayList, vcl.graphics, Vcl.ExtCtrls;
type

  TCaseBranching = class(TOperator)
  protected

  public
    constructor Create(const AYStart: Integer; const AAction : String;
                       const ABaseBlock: TBlock; const AImage: TImage); override;
    function IsPreņOperator: Boolean; override;
  end;

implementation

  constructor TCaseBranching.Create(const AYStart: Integer; const AAction : String;
                     const ABaseBlock: TBlock; const AImage: TImage);
  begin

    inherited Create(AYStart, AAction, ABaseBlock, AImage);
  end;

  function TCaseBranching.IsPreņOperator: Boolean;
  begin
    Result:= True;
  end;

end.
