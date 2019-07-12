unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Process: TProcess;
    procedure FormCreate(Sender: TObject);
    procedure Image1Paint(Sender: TObject);
  private

  public
    List: TStringList;
  end;

var
  Form1: TForm1;

implementation

uses FormEx, Clipbrd;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  S: TMemoryStream;
  Buffer: Pointer;
  BS, OS: Longint;
  FN: string;
begin
  FormAdjust(Self);
  S := TMemoryStream.Create;
  BS := Process.PipeBufferSize;
  GetMem(Buffer, BS);
  List := TStringList.Create;
  FN := GetTempFileName;
  try
    with Process do begin
      CurrentDirectory := ExtractFilePath(Application.ExeName);
      Execute;
      repeat
        OS := Output.Read(Buffer^, BS);
        ShowMessage(Format('OS = %d, BS = %d', [OS, BS]));
        if OS > 0 then S.Write(Buffer^, OS)
        {else Sleep(1000);}
      until (OS = 0) and not Running;
      Terminate(0);
      {ShowMessage(Format('ExitCode = %d, ExitSatus = %d',
        [Process.ExitCode, Process.ExitStatus]));}
    end;
    S.SaveToFile(FN);
    List.LoadFromFile(FN);
    Clipboard.AsText := List.Text;
  finally
    FreeMem(Buffer, BS);
    S.Free
  end;
end;

procedure TForm1.Image1Paint(Sender: TObject);
var
  i, X, Y: Integer;
procedure WriteLine(S: string);
begin
  Image1.Canvas.TextOut(X, Y, S);
  Inc(Y, Canvas.TextHeight(S));
end;
begin
  Image1.Canvas.Font.Height := 16;
  Image1.Canvas.Font.Color := clYellow;
  {i := 0; Y := 0;
  while Y < Image1.Height do begin
    if i >= List.Count then Break;
    Image1.Canvas.TextOut(0, Y, List[i]);
    i := i + 1;
    Y := Y + Image1.Canvas.Font.Height + 4
  end;}
  X := 8; Y := 8;
  WriteLine('Hello!');
  WriteLine('Go to our chat!');
  WriteLine('Then press [Ctrl] + [V] on your Keyboard! This inserts your system description');
  WriteLine('Then send the message with your system description!')
end;

end.

