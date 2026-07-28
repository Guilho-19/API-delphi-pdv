unit uWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, System.JSON, Data.DB,
  Data.Win.ADODB, Winapi.ActiveX;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wmProdutosAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses uDMConexao;

{$R *.dfm}

var
  FConexaoDM: TdmConexao;

constructor TWebModule1.Create(AOwner: TComponent);
begin
  CoInitialize(nil);
  inherited Create(AOwner);
  FConexaoDM := TdmConexao.Create(nil);
end;

destructor TWebModule1.Destroy;
begin
  FConexaoDM.Free;
  inherited Destroy;
  CoUninitialize;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>Web Server Application</body>' +
    '</html>';
end;

procedure TWebModule1.WebModule1wmProdutosAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  queryTADO: TADOQuery;
  arrayJSON: TJSONArray;
  objectJSON: TJSONObject;
begin
  try
    queryTADO := TADOQuery.Create(nil);
    arrayJSON := TJSONArray.Create;

    try
      queryTADO.Connection := FConexaoDM.conSQLServer;
      queryTADO.SQL.Text := 'select id_produto, codigo_barras, descricao, preco_venda, estoque from PDV_Produtos';
      queryTADO.Open;

      while not queryTADO.Eof do
      begin
        objectJSON := TJSONObject.Create;

        objectJSON.AddPair('id_produto', TJSONNumber.Create(queryTado.FieldByName('id_produto').AsInteger));
        objectJSON.AddPair('codigo_barras', queryTADO.FieldByName('codigo_barras').AsString);
        objectJSON.AddPair('descricao', queryTADO.FieldByName('descricao').AsString);
        objectJSON.AddPair('preco_venda', TJSONNumber.Create(queryTADO.FieldByName('preco_venda').AsFloat));
        objectJSON.AddPair('estoque', TJSONNumber.Create(queryTADO.FieldByName('estoque').AsFloat));

        arrayJSON.AddElement(objectJSON);

        queryTADO.Next;
      end;

      Response.ContentType := 'application/json; charset=utf-8';
      Response.Content := arrayJSON.ToString;
    finally
      queryTADO.Free; arrayJSON.Free;
    end;
  except
    on E: Exception do
    begin
      Response.StatusCode := 500;
      Response.Content := '{"error": "' + E.Message + '"}';
    end;
  end;

  Handled := True;
end;

end.
