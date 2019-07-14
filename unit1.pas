unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Interfaces;

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
      Executable := GetEnvironmentVariable('COMSPEC');
      Execute;
      repeat
        OS := Output.Read(Buffer^, BS);
        {ShowMessage(Format('OS = %d, BS = %d', [OS, BS]));}
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
  Inc(Y, Image1.Canvas.TextHeight(S));
end;
begin
  Image1.Canvas.Font.Height := 24;
  Image1.Canvas.Font.Color := clYellow;
  Image1.Canvas.Font.Italic := True;
  Image1.Canvas.Brush.Color := clBlack;
  X := 8; Y := 8;
  WriteLine('Hello!');
  WriteLine('This is Nancy.');
  WriteLine('So you can send me information about your system:');
  WriteLine('1) Go to our chat like for writing a message!');
  WriteLine('2) Instead of writing press [Ctrl] + [V] on your Keyboard! This inserts your system description');
  WriteLine('3) Then send the message with your system description!')
end;

end.

