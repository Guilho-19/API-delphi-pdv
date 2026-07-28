object dmConexao: TdmConexao
  Height = 480
  Width = 640
  object conSQLServer: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=PDV;Data Source=DESKTOP-IMACRFG'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 40
    Top = 24
  end
end
