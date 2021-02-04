unit untFuncao;

interface

uses  System.SysUtils, System.IniFiles, Vcl.Forms, System.Classes, Datasnap.DBClient, Vcl.StdCtrls,
      Vcl.ComCtrls, Vcl.Grids, Vcl.Graphics, Vcl.DBGrids, frxClass;

type
  // Set ReadOnly
  //SendMessage(GetWindow(ComboBox1.Handle,GW_CHILD), EM_SETREADONLY, 1, 0);

  // Remove ReadOnly
  //SendMessage(GetWindow(ComboBox1.Handle,GW_CHILD), EM_SETREADONLY, 0, 0);

  // Estado Civil
  TEstadoCivil = (tSolteiro, tCasado, tDivorciado, tViuvo, tNone);

  //Registro da agenda
  TAgenda = record
    Nome, Sobrenome, DataNascimento, DataCadastro, CIC, RG, Endereco, Bairro,
    Cidade, CEP, Estado, Telefone, Email: string;
    EstadoCivil: TEstadoCivil;
  end;

  //Funções
  function GravaIni(Sessao, Nome, aTexto, FileName: string): string;
  function LeIni(Sessao, Nome, aTexto, FileName: string): string;

  function Iif(Teste: Boolean; ValorTrue, ValorFalse:String): String; overload;
  function Iif(Teste: Boolean; ValorTrue, ValorFalse:Real): Extended; overload;
  function Iif(Teste: Boolean; ValorTrue, ValorFalse:Integer): Integer; overload;
  function ExisteArquivo(sCaminho, sNomeArquivo: String): Boolean;
  function RetornaCodigo(cds: TClientDataSet): Integer;
  function adiciona_zero_a_direita(numero :integer; casa: integer) :string;
  function EliminaFormatacao(sTexto:String):String;
  function VerificaLigacaoTabela(sValorCampo, sFieldByName: string; cdsProduto: TClientDataSet): Boolean;
  function VerificaSeExisteCadastro(sValorCampo, sFieldByName, sArquivoCarregar: string; cds: TClientDataSet): Boolean;
  function VerificaSeExisteVenda(sCodigoCompra, sCodigoProduto, sFieldByName, sArquivoCarregar: string; cds: TClientDataSet): Boolean;
  function ValidaData(sData: string): Boolean;

  //Procedures
  procedure CriaForm(NomeForm: TFormClass);
  procedure AtivaDesativaCDS(cds: TClientDataSet; bVal: Boolean);
  procedure ValidaQtdeMinima(cdsDados: TClientDataSet; memoTexto: TRichEdit; nomeCampo1, nomeCampo2, nomeCampo3, nomeCampo4, nomeCampo5, dadosCarregar: string);
  procedure AtualizaQtdeProduto(sCodProduto, sTipoMovimento, Tabela: string; fQtdeProduto: Real; cdsProduto: TClientDataSet);
  procedure AtualizaQtdeVendaEntrada(sCodVenda, sCodEntrada, sCodProduto, sTipoMovimento, Tabela: string; fQtdeProduto: Real; cdsEntrada: TClientDataSet);

  procedure LimpaStringGrid(Grid: TStringGrid);
  procedure GridDeleteRow(RowNumber: Integer; Grid: TstringGrid);
  procedure DesmarcarRegistroDbgrid(dbg: TDBGrid; cds: TClientDataSet);
  procedure CarregaRelatorio(const pReport: TFrxReport);

  //Constante
  const cIni = 'Resultado_Pegada_Ecologica.ini';

//Principal
var agenda: array of TAgenda;
    list: TStringList;
implementation

//Grava Ini


uses untConstante;function GravaIni(Sessao, Nome, aTexto, FileName: string): string;
var ArqIni: TIniFile;
    Diretorio: string;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + FileName);
  try
    ArqIni.WriteString(Sessao, Nome, aTexto);
    Diretorio := ArqIni.ReadString(Sessao, Nome, aTexto);
  finally
    Result := Diretorio;
    ArqIni.Free;
  end;
end;

//Le Ini
function LeIni(Sessao, Nome, aTexto, FileName: string): string;
var ArqIni: TIniFile;
    Diretorio: string;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + FileName);
  try
    Diretorio := ArqIni.ReadString(Sessao, Nome, aTexto);
  finally
    Result := Diretorio;
    ArqIni.Free;
  end;
end;

function Iif(Teste: Boolean; ValorTrue, ValorFalse:String): String; overload;
begin
  If Teste then
    Result := ValorTrue
  else
    Result := ValorFalse;
end;

function Iif(Teste: Boolean; ValorTrue, ValorFalse:Real): Extended;
begin
  If Teste then
    Result := ValorTrue
  else
    Result := ValorFalse;
end;

function Iif(Teste: Boolean; ValorTrue, ValorFalse:Integer): Integer;
begin
  If Teste then
    Result := ValorTrue
  else
    Result := ValorFalse;
end;

// Cria form dinamicamente
procedure CriaForm(NomeForm: TFormClass);
begin
  TForm(NomeForm) := NomeForm.Create(nil);
  try
     TForm(NomeForm).ShowModal;
  finally
     FreeAndNil(NomeForm);
  end;
end;

function ExisteArquivo(sCaminho, sNomeArquivo: String): Boolean;
begin
  if FileExists(sCaminho + sNomeArquivo) then
    begin
      result := True;
    end
  else
    begin
      result := False;
    end;
end;

procedure AtivaDesativaCDS(cds: TClientDataSet; bVal: Boolean);
begin
    try
        cds.Active := False;
        if bVal then
          begin
            cds.Active := True;
          end;
    except

    end;
end;

function RetornaCodigo(cds: TClientDataSet): Integer;
begin
    try

        cds.Filtered := False;
        cds.First;

    finally
       Result := cds.FieldByName('CODIGO').AsInteger + 1;
       cds.Append;
    end;
end;

function adiciona_zero_a_direita(numero: integer; casa: integer) :string;
var		aux: string;
        i: integer;
begin
    aux := inttostr(numero);
    i := 0;
    while (i < (casa - Length(inttostr(numero)))) do
      begin
        aux := '0' + aux;
        inc (i);
      end;
      Result := aux;
end;

function EliminaFormatacao(sTexto:String):String;
//
// Elimina os caracteres de formatacao da string
// (inclusive os espaços entre as palavras)
//
var iPos : Integer;
    iTamanho : Integer;
    sTextoSemFormato : String;
    sCaractere : String;
    sCaracMascaras : String;
begin
    Result := sTexto;
    if sTexto = ''  then
       begin
          Exit;
       end;

    sTextoSemFormato := '';
    //sCaracMascaras := './><_+=[]{}()-$&@*';
    sCaracMascaras := 'ABCDEFGHIJLMNOPQRSTUVXZKYWabcdefghijlmnopqrstuvxzkyw./><_+=[]{}()-$&@*!^~;:?/+=|';
    iTamanho := Length(sTexto);

    for iPos := 1 to iTamanho do
      begin
          sCaractere := Copy(sTexto,iPos,1);
          if Pos(sCaractere,sCaracMascaras) = 0 then
             begin
                sTextoSemFormato := sTextoSemFormato + sCaractere;
             end;
      end;
    Result := sTextoSemFormato;
end;

procedure LimpaStringGrid(Grid: TStringGrid);
var lin, col: integer;
begin
     for lin := 1 to Grid.RowCount - 1 do
       for col := 0 to Grid.ColCount - 1 do
         Grid.Cells[col, lin] := '';
end;

// deletar uma linha de uma stringgrid
procedure GridDeleteRow(RowNumber: Integer; Grid: TstringGrid);
var i: Integer;
begin
    Grid.Row := RowNumber;
    if (Grid.Row = Grid.RowCount - 1) then
        { On the last row }
        Grid.RowCount := Grid.RowCount - 1
    else
      begin
          { Not the last row }
          for i := RowNumber to Grid.RowCount - 1 do
            Grid.Rows[i] := Grid.Rows[i + 1];

          Grid.RowCount := Grid.RowCount - 1;
      end;
end;

{ Procedimento utilizado para desmarcar todos os registro de um Dbgrid }
procedure DesmarcarRegistroDbgrid(dbg: TDBGrid; cds: TClientDataSet);
var vlLinha: Integer;
begin
    try
        if cds.RecordCount > 0 then
          begin
              with dbg.DataSource.DataSet do
                begin
                    First;
                    for vlLinha := 0 to RecordCount - 1 do
                      begin
                          dbg.SelectedRows.CurrentRowSelected := False;
                          Next;
                      end;
                end;
              dbg.SelectedRows.Refresh;
          end;
    except
        //
    end;
end;

function ValidaData(sData: string): Boolean;
begin
    try
        StrToDate(sData);
        Result := True;
    except
        Result := False;
    end;
end;

{ Procedimento usado para validar se o produto esta na quantidade
  minima ou abaixo dela }
procedure ValidaQtdeMinima(cdsDados: TClientDataSet; memoTexto: TRichEdit; nomeCampo1, nomeCampo2, nomeCampo3, nomeCampo4, nomeCampo5, dadosCarregar: string);
var bValidaAtivado: Boolean;
    i: Integer;
    sQtde: string;
begin
    // Inicia variavel
    bValidaAtivado := False;
    sQtde := '0';

    try
        // Verifica se o componente existe
        if cdsDados.Active = False then
          begin
              // cria cds
              cdsDados.CreateDataSet;

              // carregando dados
              cdsDados.LoadFromFile(dadosCarregar);

              // joga no inicio do registro
              cdsDados.First;
          end
        else
          begin
              // Fecha para criar denovo
              cdsDados.Close;

              // cria cds
              cdsDados.CreateDataSet;

              // carregando dados
              cdsDados.LoadFromFile(dadosCarregar);

              // joga no inicio do registro
              cdsDados.First;
          end;

        for i := 0 to cdsDados.RecordCount -1 do
          begin
            if cdsDados.FieldByName(nomeCampo1).AsInteger <= cdsDados.FieldByName(nomeCampo2).AsInteger then
              begin
                 if bValidaAtivado = False then
                   begin
                      memoTexto.Visible := True;
                      memoTexto.Lines.Add('Existem itens que precisam de atenção! ');
                      memoTexto.Lines.Add('Estão no estoque minímo ou abaixo:     ');
                      memoTexto.Lines.Add('=========================');

                      bValidaAtivado := True;
                   end;

                 if Trim(cdsDados.FieldByName(nomeCampo5).AsString) <> '' then
                    sQtde := cdsDados.FieldByName(nomeCampo5).AsString;

                 // Adiciona conteúdo no memo
                 memoTexto.Lines.Add('Código: ' + cdsDados.FieldByName(nomeCampo3).AsString);
                 memoTexto.Lines.Add('Descrição: ' + cdsDados.FieldByName(nomeCampo4).AsString);
                 memoTexto.Lines.Add('Estoque: ' + sQtde);
                 memoTexto.Lines.Add('-----------------------------------');
              end;
              cdsDados.Next;
          end;

        if bValidaAtivado = False then
          memoTexto.Visible := False;
    except
        //
    end;
end;

{ Procedimento usado para alterar a quantidade
  do produto que esta sendo passado no parametro }
procedure AtualizaQtdeProduto(sCodProduto, sTipoMovimento, Tabela: string; fQtdeProduto: Real; cdsProduto: TClientDataSet);
var i: integer;
begin
    try
        if cdsProduto.Active = False then
            cdsProduto.CreateDataSet;

        cdsProduto.LoadFromFile(cProduto);

        cdsProduto.First;
        for i := 0 to cdsProduto.RecordCount - 1 do
          begin
              if cdsProduto.FieldByName('CODIGO').AsString = sCodProduto then
                begin
                    cdsProduto.Edit;
                    if sTipoMovimento = cEntrada then
                      begin
                          cdsProduto.FieldByName('ESTOQUE').AsFloat := cdsProduto.FieldByName('ESTOQUE').AsFloat + fQtdeProduto;
                      end
                    else if sTipoMovimento = cSaida then
                      begin
                         cdsProduto.FieldByName('ESTOQUE').AsFloat := cdsProduto.FieldByName('ESTOQUE').AsFloat - fQtdeProduto;
                      end;

                    if Tabela = cEntrada then
                        cdsProduto.FieldByName('OBSERVACAO').AsString := 'Estoque do produto alterado pela tabela de Entrada.'
                    else
                        cdsProduto.FieldByName('OBSERVACAO').AsString := 'Estoque do produto alterado pela tabela de Saída.';

                    { Atualiza o campo de data de atualização, pois
                      a tabela Produto também está sendo alterada }
                    cdsProduto.FieldByName('DATAATUALIZACAO').AsDateTime := Now;

                    cdsProduto.Post;

                    exit;
                end;
              cdsProduto.Next;
          end;
    except
        //
    end;
end;

{ Procedimento usado para alterar a quantidade
  do produto que saiu na entrada correspondente }
procedure AtualizaQtdeVendaEntrada(sCodVenda, sCodEntrada, sCodProduto, sTipoMovimento, Tabela: string; fQtdeProduto: Real; cdsEntrada: TClientDataSet);
var i: integer;
begin
    try
        if cdsEntrada.Active = False then
            cdsEntrada.CreateDataSet;

        cdsEntrada.LoadFromFile(cCompra);

        cdsEntrada.First;
        for i := 0 to cdsEntrada.RecordCount - 1 do
          begin
              if (cdsEntrada.FieldByName('CODIGOCOMPRA').AsString = sCodEntrada) and
                 (cdsEntrada.FieldByName('CODIGOPRODUTO').AsString = sCodProduto) then
                begin
                    cdsEntrada.Edit;
                    { Adicionando o código da venda na compra }
                    cdsEntrada.FieldByName('CODIGOVENDA').AsString := sCodVenda;
                    if sTipoMovimento = cSaida then
                      begin
                          cdsEntrada.FieldByName('QTDEVENDA').AsFloat := cdsEntrada.FieldByName('QTDEVENDA').AsFloat + fQtdeProduto;
                      end
                    else if sTipoMovimento = cEntrada then
                      begin
                         if (cdsEntrada.FieldByName('QTDEVENDA').AsFloat - fQtdeProduto) = 0 then
                           begin
                               { Caso zerou a quantidade de vendas na compra, limpa o campo }
                               cdsEntrada.FieldByName('CODIGOVENDA').AsString := '';
                           end;

                         cdsEntrada.FieldByName('QTDEVENDA').AsFloat := cdsEntrada.FieldByName('QTDEVENDA').AsFloat - fQtdeProduto;
                      end; // fim if TipoMovimento

                    //if Tabela = 'Entrada' then
                    cdsEntrada.FieldByName('OBSERVACAO').AsString := 'Tabela de Entrada alterada pela tabela de Saída.';
                    //else
                        //cdsEntrada.FieldByName('OBSERVACAO').AsString := 'Estoque do produto alterado pela tabela de Saída.';

                    { Atualiza o campo de data de atualização, pois
                      a tabela Produto também está sendo alterada }
                    cdsEntrada.FieldByName('DATAATUALIZACAO').AsDateTime := Now;

                    cdsEntrada.Post;

                    exit;
                end; // fim if CODIGOCOMPRA / CODIGOPRODUTO
              cdsEntrada.Next;
          end;// fim for RecordCount
    except
        //
    end;
end;

{ Função que verifica se o produto esta relacionado com alguma tabela }
function VerificaLigacaoTabela(sValorCampo, sFieldByName: string; cdsProduto: TClientDataSet): Boolean;
var i: integer;
begin
    // Inicializa variavel
    Result := False;

    try
        if cdsProduto.Active = False then
            cdsProduto.CreateDataSet;

        cdsProduto.LoadFromFile(cProduto);

        cdsProduto.First;
        for i := 0 to cdsProduto.RecordCount do
          begin
              // Verifica se existe a unidade na tabela de produto
              if cdsProduto.FieldByName(sFieldByName).AsString = sValorCampo then
                begin
                    Result := True;

                    Break;
                end;

              cdsProduto.Next;
          end;
    except
       //
    end;
end;

{ Função usada para verificar se existe algum cadastro na
  na tabela passada como parametro }
function VerificaSeExisteCadastro(sValorCampo, sFieldByName, sArquivoCarregar: string; cds: TClientDataSet): Boolean;
var i: Integer;
begin
    // Inicia variavel
    Result :=  False;

    try
        if cds.Active = False then
          cds.CreateDataSet;

        cds.LoadFromFile(sArquivoCarregar);

        cds.First;
        for i := 0 to cds.RecordCount do
          begin
              // Verifica se existe o campo cadastrado
              if cds.FieldByName(sFieldByName).AsString = sValorCampo then
                begin
                    Result := True;

                    Break;
                end;

              cds.Next;
          end;

    except
        //
    end;
end;

{ Função usada para verificar se existe algum valor no campo da
  tabela passada como parametro }
function VerificaSeExisteVenda(sCodigoCompra, sCodigoProduto, sFieldByName, sArquivoCarregar: string; cds: TClientDataSet): Boolean;
var i: Integer;
begin
    // Inicia variavel
    Result :=  False;

    try
        if cds.Active = False then
          cds.CreateDataSet;

        cds.LoadFromFile(sArquivoCarregar);

        cds.First;
        for i := 0 to cds.RecordCount do
          begin
              { Se o código da compra e do produto que for passado é igual
                o que esta percorrendo no laço é verificado abaixo se o código
                da venda esta preenchido na tabela de compra }
              if (cds.FieldByName('CODIGOCOMPRA').AsString = sCodigoCompra) and
                 (cds.FieldByName('CODIGOPRODUTO').AsString = sCodigoProduto) then
                begin
                    // Verifica se esta preenchido
                    if Trim(cds.FieldByName(sFieldByName).AsString) <> '' then
                      begin
                          Result := True;
                      end;
                    Break;
                end;

              cds.Next;
          end;

    except
        //
    end;
end;

procedure CarregaRelatorio(const pReport: TFrxReport);
begin
    //
    pReport.PrepareReport;
    pReport.ShowPreparedReport;
end;

end.
