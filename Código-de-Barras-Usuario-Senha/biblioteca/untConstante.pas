unit untConstante;

interface

uses SysUtils;

{ ===========================================================================
                   Constantes utilizadas na conex�o
  =========================================================================== }
{ Tipos de conex�o }
const
      cAccess         : string = 'ORACLE';
{ Sess�o Ini }
      cKeyBanco       : string = 'Conexao_';
      cKeyParDatabase : string = 'Database';
      cKeyParUsuario  : string = 'User_Name';
      cKeyParSenha    : string = 'Password';
{ Usu�rio padr�o para exemplo }
      cConexao_Salva_INI      : string = 'Conexao.ini';
      cConexao_Salva_INI_Temp : string = 'TempConexao.ini';
      cUsuarioBanco           : string = 'Usuario';
      cDatabaseBanco          : string = 'Banco';
      cSenha                  : string = 'Senha';
{ ===========================================================================
              Parametros utilizados nas conex�es com os bancos
  =========================================================================== }
{ Conex�o ACCESS }
      cConnectionString : string = '';

      cDefaultDatabase : string = '';
{ ===========================================================================
             Constantes utilizadas nos nomes do arquivo .xml
  =========================================================================== }
      cCorreios          : string = 'Correios.xml';
      cCidade            : string = 'Cidades.xml';
      cPedido            : string = 'Pedidos.xml';
      cPessoa            : string = 'Pessoas.xml';
      cTipoPessoa        : string = 'TipoPessoa.xml';
      cTipoSedex         : string = 'TipoSedex.xml';

      cItensAlmoxarifado : string = 'Itens_Amoxarifado.xml';
      cRamais            : string = 'Ramais.xml';
      cBotinas           : string = 'Botinas.xml';
      cSiderurgico       : string = 'Siderurgico.xml';

      cItensAlmoSemExt   : string = 'Itens_Amoxarifado';
      cRamaisSemExt      : string = 'Ramais';
      cBotinasSemExt     : string = 'Botinas';
      cSiderurgicoSemExt : string = 'Siderurgico';
{ ===========================================================================
             Constantes utilizadas nos nomes do arquivo .xml
             ( Controle de Estoque )
  =========================================================================== }
      cProduto              : string = 'Produto.xml';
      cUnidade              : string = 'Unidade.xml';
      cPosicaoEstoque       : string = 'PosicaoEstoque.xml';
      cCompra               : string = 'Compra.xml';
      cVenda                : string = 'Venda.xml';

      // Constantes sem a extens�o do arquivo .xml
      cProdutoSemExt        : string = 'Produto';
      cUnidadeSemExt        : string = 'Unidade';
      cPosicaoEstoqueSemExt : string = 'PosicaoEstoque';
      cCompraSemExt         : string = 'Compra';
      cVendaSemExt          : string = 'Venda';

      cRelatorio            : string = 'Relatorio.xml';


      // Constantes diversas
      cEntrada       : string = 'Entrada';
      cSaida         : string = 'Sa�da';

      cSim           : string = 'Sim';
      cNao           : string = 'N�o';
      //========================================
      sImagemExcluir : string = 'excluir.bmp';
      //========================================
      iTotalZeroDireita: Integer = 5;

{ ===========================================================================
                            Constantes diversas
  =========================================================================== }
      cRemetente    : string = 'REMETENTE';
      cDestinatario : string = 'DESTINATARIO';
{ ===========================================================================

  =========================================================================== }

{ ===========================================================================

  =========================================================================== }

{ ===========================================================================

  =========================================================================== }

implementation

end.
