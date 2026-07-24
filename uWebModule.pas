unit uWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, System.JSON;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1WebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>Web Server Application</body>' +
    '</html>';
end;

procedure TWebModule1.WebModule1WebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  meuJSON : TJSONObject;
begin
  meuJSON := TJSONObject.Create;

  try
    meuJSON.AddPair('id', TJSONNumber.Create(1));
    meuJSON.AddPair('nome', 'Maria Souza');
    meuJSON.AddPair('status', 'ativo');

    Response.ContentType := 'application/json';
    Response.Content := meuJSON.ToString;
  finally
    meuJSON.Free;
  end;

  Handled := true;
end;

end.
