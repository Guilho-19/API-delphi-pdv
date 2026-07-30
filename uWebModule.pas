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
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses uDMConexao;

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

procedure TWebModule1.WebModule1wmProdutosAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  dmLocal: TdmConexao;
  queryTADO: TADOQuery;
  arrayJSON: TJSONArray;
  objectJSON: TJSONObject;
  idBusca: string;
begin
  CoInitialize(nil);
  try
    try
      dmLocal := TdmConexao.Create(nil);
      try
        queryTADO := TADOQuery.Create(nil);
        try
          arrayJSON := TJSONArray.Create;
          try
            queryTADO.Connection := dmLocal.conSQLServer;
            dmLocal.conSQLServer.Connected := True;
            idBusca := Request.QueryFields.Values['id'];

            if idBusca <> '' then
            begin
              queryTADO.SQL.Text := 'select id_produto, codigo_barras, descricao, preco_venda, estoque from PDV_Produtos where id_produto = :pId';
              queryTADO.Parameters.ParamByName('pId').Value := StrToIntDef(idBusca, 0);
            end
            else
            begin
              queryTADO.SQL.Text := 'select id_produto, codigo_barras, descricao, preco_venda, estoque from PDV_Produtos';
            end;

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
            arrayJSON.Free;
          end;
        finally
          queryTADO.Free;
          dmLocal.conSQLServer.Connected := False;
        end;
      finally
        dmLocal.Free;
      end;
    except
      on E: Exception do
      begin
        Response.StatusCode := 500;
        Response.Content := '{"error": "' + E.Message + '"}';
      end;

    end;
  finally
    CoUninitialize;
  end;

  Handled := True;
end;

end.
