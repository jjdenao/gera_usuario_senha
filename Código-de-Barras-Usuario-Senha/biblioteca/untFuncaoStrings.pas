//Biblioteca com funções para Strings
{*******************************************************}
{ }
{ Delphi Runtime Library }
{ Windows Messages and Types }
{ }
{ Copyright (c) 1991,96 Walter Alves Chagas Junior }
{ }
{*******************************************************}

unit untFuncaoStrings;

interface

uses Winapi.Windows, Vcl.Dialogs, Winapi.Messages, System.SysUtils,
     System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Mask;

function ArredontaFloat(x : Real): Real;
function RoundNum(Valor:Extended;Decimais:Integer):Extended;
function Gerapercentual(valor:real;Percent:Real):real;
function IntToBin(Value: LongInt;Size: Integer): String;
function BinToInt(Value: String): LongInt;
function DecToBase( Decimal: LongInt; const Base: Byte): String;
function Base10(Base2:Integer):Integer; Assembler;
function DecToBinStr(n: integer): string;
function DecToRoman( Decimal: LongInt ): String;
function NumToHex(Num: Word): String;
function Min(A, B: Integer): Integer;
function Max(A, B: Integer): Integer;
function IntPrime(Value: Integer): Boolean;
function strByteSize(Value: Longint): String;
Function StrToReal(inString :String): Real;
function BuscaDireita(Busca,Text : string) : integer;
function BuscaTroca(Text,Busca,Troca : string) : string;
Function Codifica( const Str1: string): String;
function ContaCaracs(Edit:String): integer;
function Empty(inString:String): Boolean;
function LTrim(Texto:String):String;
function Maiuscula(Texto:String): String;
function Padr(s:string;n:integer):string;
function RemoveAcentos(Str:String): String;
function Replicate( Caracter:String; Quant:Integer ): String;
function RTrim(Texto:String):String;
function StringToFloat(s : string) : Extended;
Function Strs(I:longint):string ;
function StrToPChar(const Str: string): PChar;
function Alltrim(const Search: string): string;
function StrZero(Zeros:string;Quant:integer):String;
function StrZerodec(Numero: Double; Total, Decimal: integer): string;
function Padl(s:string;n:integer):string;
Function wordcount(str : string) : integer;
function LineIsEmpty(Text:string):boolean;
function PadC(S:string;Len:byte):string;
function FullFill(Str:String;FLen:byte;symb:char):string;
function Before(const Search, Find: string): string;
function after(const Search, Find: string): string;
function MaskString(Valor: String) : String;
function Encrypt( Senha:String ): String;
function ExisteInt(Texto:String): Boolean;

implementation

function ArredontaFloat(x : Real): Real;
{Arredonda um número float para convertê-lo em String}
Begin
  if x > 0 then
  begin
  if Frac(x) > 0.5 then
  begin
  x := x + 1 - Frac(x);
  end
  else
  begin
  x := x - Frac(x);
  end;
  end
  else
  begin
  x := x - Frac(x);
  end;
  result := x
end;


function RoundNum(Valor:Extended;Decimais:Integer):Extended;
{Quando houver,Arredonda uma possivel terceira casa decimal em uma variável}
var
  I:Integer;
  Multiplicador:Integer;
begin
  if Decimais > 15 then
  begin
  Decimais := 15;
  end
  else if Decimais < 0 then
  begin
  Decimais := 0;
  end;
  Multiplicador := 1;
  for I:=1 to Decimais do
  begin
  Multiplicador := Multiplicador*10;
  end;
Result := round(Valor*Multiplicador)/Multiplicador;
end;


function Gerapercentual(valor:real;Percent:Real):real;
// Retorna a porcentagem de um valor
begin
percent := percent / 100;
try
  valor := valor * Percent;
finally
  result := valor;
end;
end;

// Integer
function IntToBin(Value: LongInt;Size: Integer): String;
{Converte uma string em binário}
var
  i: Integer;
begin
Result:='';
for i:=Size downto 0 do
  begin
  if Value and (1 shl i)<>0 then
  begin
  Result:=Result+'1';
  end
  else
  begin
  Result:=Result+'0';
  end;
  end;
end;


function BinToInt(Value: String): LongInt;
{Converte um numero binário em Inteiro}
var
i,Size: Integer;
begin
Result := 0;
Size := length(Value);
for i:=Size downto 0 do
  begin
  if Copy(Value,i,1)='1' then
  begin
  Result := Result+(1 shl i);
  end;
  end;
end;


function DecToBase( Decimal: LongInt; const Base: Byte): String;
{converte um número decimal na base especificada}
const
  Symbols: String[16] = '0123456789ABCDEF';
var
  scratch: String;
  remainder: Byte;
begin
  scratch := '';
  repeat
  remainder := Decimal mod Base;
  scratch := Symbols[remainder + 1] + scratch;
  Decimal := Decimal div Base;
  until ( Decimal = 0 );
  Result := scratch;
end;

function Base10(Base2:Integer):Integer; Assembler;
{Converte uma string em Base 10}
asm
  cmp eax,100000000 // check upper limit
  jb @1 // ok
  mov eax,-1 // error flag
  jmp @exit // exit with -1
@1:
  push ebx // save registers
  push esi
  xor esi,esi // result = 0
  mov ebx,10 // diveder base 10
  mov ecx,8 // 8 nibbles (10^8-1)
@2:
  mov edx,0 // clear remainder
  div ebx // eax DIV 10, edx mod 10
  add esi,edx // result = result + remainder[I]
  ror esi,4 // shift nibble
  loop @2 // loop for all 8 nibbles
  mov eax,esi // function result
  pop esi // restore registers
  pop ebx
@exit:
end;


function DecToBinStr(n: integer): string;
{Converte um numero decimal em binário}
var
S: string;
i: integer;
Negative: boolean;
begin
if n < 0 then
  begin
  Negative := true;
  end;
n := Abs(n);
for i := 1 to SizeOf(n) * 8 do
  begin
  if n < 0 then
  begin
  S := S + '1';
  end
  else
  begin
  S := S + '0';
  end;
  n := n shl 1;
  end;
Delete(S,1,Pos('1',S) - 1);//remove leading zeros
if Negative then
  begin
  S := '-' + S;
  end;
Result := S;
end;


function DecToRoman( Decimal: LongInt ): String;
{Converte um numero decimal em algarismos romanos}
const
Romans: Array[1..13] of String = ( 'I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M' );
Arabics: Array[1..13] of Integer =( 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
var
i: Integer;
scratch: String;
begin
  scratch := '';
  for i := 13 downto 1 do
  while ( Decimal >= Arabics[i] ) do
  begin
  Decimal := Decimal - Arabics[i];
  scratch := scratch + Romans[i];
  end;
  Result := scratch;
end;


function NumToHex(Num: Word): String;
//Converte um numero em Hexadecimal
Var
L : string[16];
BHi,BLo : byte;
Begin
L := '0123456789ABCDEF';
BHi := Hi(Num);
BLo := Lo(Num);
result := copy(L,succ(BHi shr 4),1) +
  copy(L,succ(BHi and 15),1) +
  copy(L,succ(BLo shr 4),1) +
  copy(L,succ(BLo and 15),1);
end;


function Min(A, B: Integer): Integer;
{Compara dois valores Retornando o maior deles}
begin
  if A < B then
  Result := A
  else
  Result := B;
end;


function Max(A, B: Integer): Integer;
{Compara dois valores Retornando o maior deles}
begin
  if A > B then
  Result := A
  else
  Result := B;
end;


function IntPrime(Value: Integer): Boolean;
{Testa se um numero é primo ou não}
var
i : integer;
begin
Result := False;
Value := Abs(Value);
if Value mod 2 <> 0 then
  begin
  i := 1;
  repeat
  i := i + 2;
  Result:= Value mod i = 0
  until Result or ( i > Trunc(sqrt(Value)) );
  Result:= not Result;
  end;
end;

function strByteSize(Value: Longint): String;
{Retorna uma conversão de Bytes para integer}
Const
KBYTE = Sizeof(Byte) shl 10;
MBYTE = KBYTE shl 10;
GBYTE = MBYTE shl 10;
begin
  if Value > GBYTE then
  begin
  Result := FloatToStrF(Round(Value / GBYTE),ffNumber,6,0)+' GB';
  end
  else if Value > MBYTE then
  begin
  Result := FloatToStrF(Round(Value / MBYTE),ffNumber,6,0)+' MB';
  end
  else if Value > KBYTE then
  begin
  Result := FloatToStrF(Round(Value / KBYTE),ffNumber,6,0)+' KB';
  end
  else
  begin
  Result := FloatToStrF(Round(Value),ffNumber,6,0)+' Byte';
  end;
end;

// Strings
Function StrToReal(inString :String): Real;
{converte um número em Float}
Var
  i : Real;
  k : Integer;
Begin
  Val(inString,i,k);
  StrToReal := i;
End;

function BuscaDireita(Busca,Text : string) : integer;
{Pesquisa um caractere à direita da string,
 retornando sua posição}
var n,retorno : integer;
begin
retorno := 0;
for n := length(Text) downto 1 do
  begin
  if Copy(Text,n,1) = Busca then
  begin
  retorno := n;
  break;
  end;
  end;
Result := retorno;
end;

function BuscaTroca(Text,Busca,Troca : string) : string;
{ Substitui um caractere dentro da string}
var n : integer;
begin
for n := 1 to length(Text) do
  begin
  if Copy(Text,n,1) = Busca then
  begin
  Delete(Text,n,1);
  Insert(Troca,Text,n);
  end;
  end;
Result := Text;
end;


Function Codifica( const Str1: string): String;
{Encripta uma string}
var
Mascara,Str2: String;
PonM, PonS: Byte;
begin
Mascara := '#$%$'#13#12;
Str2 := '';
PonM := 1;
for PonS:=1 to length(Str1) do
  begin
  AppendStr( Str2, Chr( Ord(Str1[PonS]) Xor Ord(Mascara[PonM])));
  Inc( PonM);
  if PonM>length(Mascara) then
  begin
  PonM:=1;
  end;
  Result := Str2;
  end;
end;


function ContaCaracs(Edit:String): integer;
{Retorna quantos caracteres tem um Edit especificado}
begin
Result := length(Edit);
end;


function Empty(inString:String): Boolean;
{Testa se a variavel está vazia ou não}
Var
  index : Byte;
Begin
  index := 1;
  Empty := True;
  while (index <= length(inString))and (index <> 0) do
  begin
  if inString[index] = ' ' then
  begin
inc(index)
  end
  else
Begin
  Empty := False;
  index := 0
end;
  end;
end;


function LTrim(Texto:String):String;
{Remove os Espathos em branco à direita da string}
var
  I : Integer;
begin
  I := 0;
  while True do
  begin
  inc(I);
  if I > length(Texto) then
  break;
  if Texto[I] <> #32 then
  break;
  end;
  Result := Copy(Texto,I,length(Texto));
end;


function Maiuscula(Texto:String): String;
{Converte a primeira letra do texto especificado para
maiuscula e as restantes para minuscula}
var
OldStart: Integer;
begin
if Texto <> '' then
  begin
  Texto := UpperCase(Copy(Texto,1,1))+LowerCase(Copy(Texto,2,length(Texto)));
  Result := Texto;
  end;
end;

function Padr(s:string;n:integer):string;
{alinha uma string à direita}
begin
Result:=Format('%'+IntToStr(n)+'.'+IntToStr(n)+'s',[s]);
end;


function RemoveAcentos(Str:String): String;
{Remove caracteres acentuados de uma string}
Const ComAcento = 'àâêô¹ãõáéíóúç³&#9492;&#9516;&#9577;È&#9608;&#9500;&#305;&#9524;&#9556;&#9552;Ë&#9484;Ã&#9604;';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
Var
x : Integer;
Begin
For x := 1 to length(Str) do
  Begin
  if Pos(Str[x],ComAcento)<>0 then
  begin
  Str[x] := SemAcento[Pos(Str[x],ComAcento)];
  end;
  end;
Result := Str;
end;


function Replicate( Caracter:String; Quant:Integer ): String;
{Repete o mesmo caractere várias vezes}
var I : Integer;
begin
Result := '';
  for I := 1 to Quant do
  Result := Result + Caracter;
end;


function RTrim(Texto:String):String;
{Remove os Espathos em branco à esquerda da string}
var
  I : Integer;
begin
  I := length(Texto)+1;
  while True do
  begin
  Dec(I);
  if I <= 0 then
  break;
  if Texto[I] <> #32 then
  break;
  end;
  Result := Copy(Texto,1,I);
end;


function StringToFloat(s : string) : Extended;
{ Filtra uma string qualquer, convertendo as suas partes
  numéricas para sua representação decimal, por exemplo:
  'R$ 1.200,00' para 1200,00 '1AB34TZ' para 134}
var
  i :Integer;
  t : string;
  SeenDecimal,SeenSgn : Boolean;
begin
  t := '';
  SeenDecimal := False;
  SeenSgn := False;
  {Percorre os caracteres da string:}
  for i := length(s) downto 0 do
  {Filtra a string, aceitando somente números e separador decimal:}
  if (s[i] in ['0'..'9', '-','+', DecimalSeparator]) then
  begin
  if (s[i] = DecimalSeparator) and (not SeenDecimal) then
  begin
  t := s[i] + t;
  SeenDecimal := True;
  end
  else if (s[i] in ['+','-']) and (not SeenSgn) and (i = 1) then
  begin
  t := s[i] + t;
  SeenSgn := True;
  end
  else if s[i] in ['0'..'9'] then
  begin
  t := s[i] + t;
  end;
  end;
  Result := StrToFloat(t);
  end;


Function Strs(I:longint):string ;
{Converte uma variavel numérica em string}
Var
 X : string[16] ;
begin
  STR (I,X) ;
  Strs := X ;
end ;


function StrToPChar(const Str: string): PChar;
{Converte String em Pchar}
type
  TRingIndex = 0..7;
var
  Ring: array[TRingIndex] of PChar;
  RingIndex: TRingIndex;
  Ptr: PChar;
begin
  Ptr := @Str[length(Str)];
  Inc(Ptr);
  if Ptr^ = #0 then
  begin
  Result := @Str[1];
  end
  else
  begin
  Result := StrAlloc(length(Str)+1);
  RingIndex := (RingIndex + 1) mod (High(TRingIndex) + 1);
  StrPCopy(Result,Str);
  StrDispose(Ring[RingIndex]);
  Ring[RingIndex]:= Result;
  end;
end;


function Alltrim(const Search: string): string;
{Remove os espathos em branco de ambos os lados da string}
const
BlackSpace = [#33..#126];
var
Index: byte;
begin
Index:=1;
while (Index <= length(Search)) and not (Search[Index] in BlackSpace) do
  begin
  Index:=Index + 1;
  end;
Result:=Copy(Search, Index, 255);
Index := length(Result);
while (Index > 0) and not (Result[Index] in BlackSpace) do
  begin
  Index:=Index - 1;
  end;
Result := Copy(Result, 1, Index);
end;


function StrZero(Zeros:string;Quant:integer):String;
{Insere Zeros à frente de uma string}
var
I,Tamanho:integer;
aux: string;
begin
  aux := zeros;
  Tamanho := length(ZEROS);
  ZEROS:='';
  for I:=1 to quant-tamanho do
  ZEROS:=ZEROS + '0';
  aux := zeros + aux;
  StrZero := aux;
end;


function StrZerodec(Numero: Double; Total, Decimal: integer): string;
{Insere Zeros e decimais à frente de uma string}
var
 TempStr: string;
begin
 Str(Numero:0:Decimal,TempStr);
 while length(TempStr) < Total do
  begin
  Insert('0',TempStr,1);
  end;
Result := TempStr;

end;



function Padl(s:string;n:integer):string; // Alinhamento pela esquerda
{alinha uma string à esquerda}
begin
  Result:=Format('%-'+IntToStr(n)+'.'+IntToStr(n)+'s',[s]);
end;


Function wordcount(str : string) : integer;
// Retorna o número de palavras que contem em uma string
var
count : integer;
i : integer;
len : integer;
begin
len := length(str);
count := 0;
i := 1;
while i <= len do
  begin
  while ((i <= len) and ((str[i] = #32) or (str[i] = #9) or (Str[i] = ';'))) do
  inc(i);
  if i <= len then
  inc(count);
  while ((i <= len) and ((str[i] <> #32) and (str[i] <> #9) and (Str[i] <> ';'))) do
  inc(i);
  end;
  wordcount := count;
end;


function LineIsEmpty(Text:string):boolean;
// Testa se uma linha de texto está vazia ou não
var
  i:byte;
begin
for i:=1 to length(Text) do
  begin
  if Text[i]<>' ' then
  begin
  result := False;
  exit;
  end;
  end;
Result := True;
end;


function PadC(S:string;Len:byte):string;
// Centraliza uma string em um espatho determinado
var
 Str:String;
 L:byte;
begin
str :='';
if len < length(s) then
  begin
  Result := '';
  Exit;
  end;
l:=(Len-length(S)) div 2;
while l > 0 do
  begin
  str:=str+' ';
  dec(l);
  end;
for l:=1 to length(S) do
  begin
  str := str+s[L];
  end;
 Result := str;
end;


function FullFill(Str:String;FLen:byte;symb:char):string;
// Preenche o restante da string com um caractere especificado
var
 S:String;
 i:byte;
begin
s:=Str;
if length(s) >= FLen then
  begin
  Result := s;
  Exit;
  end;
for i := length(s) to FLen do
  begin
  S := S + symb;
  end;
Result := s;
end;


function Before(const Search, Find: string): string;
{Retorna uma cadeia de caracteres antecedentes a uma parte da string selecionada}
const
  BlackSpace = [#33..#126];
var
  index: byte;
begin
  index:=Pos(Find, Search);
  if index = 0 then
  Result:=Search
  else
  Result:=Copy(Search, 1, index - 1);
end;


function after(const Search, Find: string): string;
{Retorna uma cadeia de caracteres após a parte da string selecionada}
var
index: byte;
begin
index := Pos(Find, Search);
if index = 0 then
  begin
  Result := '';
  end
else
  begin
  Result := Copy(Search, index + length(Find), 255);
  end;
end;


function MaskString(Valor: String) : String;
begin
Result := FormatMaskText('!aaaaaaaaaaaaaa;0; ',(FormatFloat('#,##0.00',StrToFloat(valor))));
end;

function Encrypt( Senha:String ): String;
{Encripta uma String}
Const
  Chave : String = 'Jesus';
Var
  x,y : Integer;
  NovaSenha : String;
begin
  for x := 1 to length( Chave ) do begin
  NovaSenha := '';
  for y := 1 to length( Senha ) do
  NovaSenha := NovaSenha + chr( (Ord(Chave[x]) xor Ord(Senha[y])));
  Senha := NovaSenha;
  end;
  result := Senha;
end;

function ExisteInt(Texto:String): Boolean;
{Testa se em uma string existe um numero inteiro valido ou não}
var
i:integer;
begin
try
  i := StrToInt(Texto);
  Result := True;
except
  Result := False;
end;
end;
end.
