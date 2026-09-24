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
    procedure WebModule1actNovoProdutoAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1actAtualizarProdutoAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1actExcluirProdutoAction(Sender: TObject;
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

uses uDMConexao;

{$R *.dfm}

procedure TWebModule1.WebModule1actAtualizarProdutoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  dmLocal: TdmConexao;
  queryTADO: TADOQuery;
  jsonRecebido: TJSONObject;
  IdBusca: string;
begin
  CoInitialize(nil);
  try
    try
      IdBusca := Request.QueryFields.Values['id'];

      if IdBusca = '' then
      begin
        Response.StatusCode := 400;
        Response.ContentType := 'application/json; charset=utf-8';
        Response.Content := '{"error": "ID do produto não informado na URL."}';
        Handled := True;
        Exit;
      end;

      dmLocal := TdmConexao.Create(nil);
      queryTADO := TADOQuery.Create(nil);
      try
        dmLocal.conSQLServer.Connected := True;
        queryTADO.Connection := dmLocal.conSQLServer;
        jsonRecebido := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;

        if Assigned(jsonRecebido) then
        begin
          try
            queryTADO.SQL.Text := 'update PDV_Produtos set codigo_barras = :pCodigo,' +
                                  'descricao = :pDescricao, preco_venda = :pPreco, ' +
                                  'estoque = :pEstoque where id_produto = :pId';

            queryTADO.Parameters.ParamByName('pId').Value := StrToIntDef (IdBusca, 0);
            queryTADO.Parameters.ParamByName('pCodigo').Value := jsonRecebido.GetValue<string>('codigo_barras');
            queryTADO.Parameters.ParamByName('pDescricao').Value := jsonRecebido.GetValue<string>('descricao');
            queryTADO.Parameters.ParamByName('pPreco').Value := jsonRecebido.GetValue<Double>('preco_venda');
            queryTADO.Parameters.ParamByName('pEstoque').Value := jsonRecebido.GetValue<Double>('estoque');

            queryTADO.ExecSQL;

            Response.StatusCode := 200;
            Response.ContentType := 'application/json; charset=utf-8';
            Response.Content := '{"mensagem": "Produto atualizado com sucesso!"}';
          finally
            jsonRecebido.Free;
          end;
        end
        else
        begin
          Response.StatusCode := 400;
          Response.ContentType := 'application/json; charset=utf-8';
          Response.Content := '{"error": "Formato JSON inválido ou vazio."}';
        end;

      finally
        queryTADO.Free;
        dmLocal.conSQLServer.Connected := False;
        dmLocal.Free;
      end;
    except
      on E: Exception do
      begin
        Response.StatusCode := 500;
        Response.ContentType := 'application/json; charset=utf-8';
        Response.Content := '{"error": "' + E.Message + '"}';
      end;
    end;
  finally
    CoUninitialize;
  end;

  Handled := True;
end;

procedure TWebModule1.WebModule1actExcluirProdutoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  dmLocal: TdmConexao;
  queryTADO: TADOQuery;
  IdBusca: string;
begin
  CoInitialize(nil);
  try
    try
      IdBusca := Request.QueryFields.Values['id'];

      if IdBusca = '' then
      begin
        Response.StatusCode := 400;
        Response.ContentType := 'application/json; charset=utf-8';
        Response.Content := '{"error": "ID do produto não informado para exclusão."}';
        Handled := True;
        Exit;
      end;

      dmLocal := TdmConexao.Create(nil);
      queryTADO := TADOQuery.Create(nil);
      try
        dmLocal.conSQLServer.Connected := True;
        queryTADO.Connection := dmLocal.conSQLServer;

        queryTADO.SQL.Text := 'delete from PDV_Produtos where id_produto = :pId';
        queryTADO.Parameters.ParamByName('pId').Value := StrToIntDef(IdBusca, 0);
        queryTADO.ExecSQL;

        Response.StatusCode := 200;
        Response.ContentType := 'application/json; charset=utf-8';
        Response.Content := '{"mensagem": "Produto excluído com sucesso!"}';
      finally
        queryTADO.Free;
        dmLocal.conSQLServer.Connected := False;
        dmLocal.Free;
      end;
    except
      on E: Exception do
      begin
        Response.StatusCode := 500;
        Response.ContentType := 'application/json; charset=utf-8';
        Response.Content := '{"error": "' + E.Message + '"}';
      end;
    end;
  finally
    CoUninitialize;
  end;

  Handled := True;
end;

procedure TWebModule1.WebModule1actNovoProdutoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  dmLocal: TdmConexao;
  queryTADO: TADOQuery;
  jsonRecebido: TJSONObject;
begin
  CoInitialize(nil);
  try
    try
      dmLocal := TdmConexao.Create(nil);
      queryTADO := TADOQuery.Create(nil);
      try
        dmLocal.conSQLServer.Connected := True;
        queryTADO.Connection := dmLocal.conSQLServer;
        jsonRecebido := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;

        if Assigned(jsonRecebido) then
        begin
          try
            queryTADO.SQL.Text := 'insert into PDV_Produtos (codigo_barras, descricao, preco_venda, estoque) ' +
                                  'values (:pCodigo, :pDescricao, :pPreco, :pEstoque) ';

            queryTADO.Parameters.ParamByName('pCodigo').Value := jsonRecebido.GetValue<string>('codigo_barras');
            queryTADO.Parameters.ParamByName('pDescricao').Value := jsonRecebido.GetValue<string>('descricao');
            queryTADO.Parameters.ParamByName('pPreco').Value := jsonRecebido.GetValue<double>('preco_venda');
            queryTADO.Parameters.ParamByName('pEstoque').Value := jsonRecebido.GetValue<double>('estoque');
            queryTADO.ExecSQL;

            Response.StatusCode := 201;
            Response.ContentType := 'application/json; charset=utf-8';
            Response.Content := '{"mensagem": "Produto inserido com sucesso!"}';
          finally
            jsonRecebido.Free;
          end;
        end
        else
        begin
          Response.StatusCode := 400;
          Response.ContentType := 'application/json; charset=utf-8';
          Response.Content := '{"error": "Formato JSON inválido ou vazio."}';
        end;
      finally
        queryTADO.Free;
        dmLocal.conSQLServer.Connected := False;
        dmLocal.Free;
      end;
    except
      on E: Exception do
      begin
        Response.StatusCode := 500;
        Response.ContentType := 'application/json; charset=utf-8';
        Response.COntent := '{"error": " ' + E.Message + '"}';
      end;
    end;
  finally
    CoUninitialize;
  end;
    Handled := True;
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
