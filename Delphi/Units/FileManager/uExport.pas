unit uExport;

interface
uses
  uBlockManager, Vcl.Graphics, Vcl.ExtCtrls, uAdditionalTypes, uConstants, PNGImage;

procedure SaveBMPFile(const ABlockManager: TBlockManager; const AFileName: string);
procedure SavePNGFile(const ABlockManager: TBlockManager; const AFileName: string);

implementation

  procedure InitializeVisibleImageRect(const ABitmap: TBitmap;
                                       out AVisibleImageRect: TVisibleImageRect);
  begin
    AVisibleImageRect.FTopLeft.X := 0;
    AVisibleImageRect.FTopLeft.Y := 0;
    AVisibleImageRect.FBottomRight.X := ABitmap.Width;
    AVisibleImageRect.FBottomRight.Y := ABitmap.Height;
  end;

  procedure InitializeBitmap(const ABitmap: TBitmap; const ABlockManager: TBlockManager);
  begin
    ABitmap.Width := ABlockManager.MainBlock.XLast + SchemeIndent;
    ABitmap.Height := ABlockManager.MainBlock.Statements[ABlockManager.MainBlock.
                     Statements.Count - 1].GetYBottom + SchemeIndent;
    ABitmap.Canvas.Font := ABlockManager.Font;
    ABitmap.Canvas.Pen := ABlockManager.Pen;
  end;

  procedure SaveBMPFile(const ABlockManager: TBlockManager; const AFileName: string);
  var
    VisibleImageRect: TVisibleImageRect;
    Bitmap: TBitmap;
  begin
    Bitmap := TBitmap.Create;
    try
      InitializeBitmap(Bitmap, ABlockManager);

      InitializeVisibleImageRect(Bitmap, VisibleImageRect);

      ABlockManager.MainBlock.InstallCanvas(Bitmap.Canvas);
      ABlockManager.MainBlock.DrawBlock(VisibleImageRect);

      Bitmap.SaveToFile(AFileName);
    finally
      Bitmap.Destroy;
    end;
    ABlockManager.MainBlock.InstallCanvas(ABlockManager.PaintBox.Canvas);
  end;

  procedure SavePNGFile(const ABlockManager: TBlockManager; const AFileName: string);
  var
    Bitmap: TBitmap;
    PNG: TPNGImage;
    VisibleImageRect: TVisibleImageRect;
  begin
    Bitmap := TBitmap.Create;
    try
      InitializeBitmap(Bitmap, ABlockManager);

      InitializeVisibleImageRect(Bitmap, VisibleImageRect);

      ABlockManager.MainBlock.InstallCanvas(Bitmap.Canvas);
      ABlockManager.MainBlock.DrawBlock(VisibleImageRect);

      PNG := TPNGImage.Create;
      try
        PNG.Assign(Bitmap);
        PNG.SaveToFile(AFileName);
      finally
        PNG.Free;
      end;
    finally
      Bitmap.Free;
    end;
    ABlockManager.MainBlock.InstallCanvas(ABlockManager.PaintBox.Canvas);
  end;

end.
