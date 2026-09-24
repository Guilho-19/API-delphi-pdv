object WebModule1: TWebModule1
  Actions = <
    item
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'wmProdutos'
      PathInfo = '/produtos'
      OnAction = WebModule1wmProdutosAction
    end
    item
      MethodType = mtPost
      Name = 'actNovoProduto'
      PathInfo = '/produtos/novo'
      OnAction = WebModule1actNovoProdutoAction
    end
    item
      MethodType = mtPut
      Name = 'actAtualizarProduto'
      PathInfo = '/produtos'
      OnAction = WebModule1actAtualizarProdutoAction
    end>
  Height = 230
  Width = 415
end
