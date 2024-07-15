unit dao.usuarios;

interface
uses
  Data.DB,
  ADRConn.DAO.Base,
  ADRConn.Model.Factory,
  ADRCOnn.Model.Interfaces,

  DataSet.Serialize,

  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils;

type
  TADRConnDAOUsuario = class(TADRConnDAOBase)
    private
    public
      function List(): TJSONArray;
      function Find(AID: Integer): TJSONObject;
      function Insert(AValue: string): TJSONObject;
      function Update(AID: Integer; AValue: string): TJSONObject;
      function Login(AValue: String): TJSONObject;
  end;

implementation

{ TADRConnDAOComandas }

function TADRConnDAOUsuario.List: TJSONArray;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  *                     ' +
    'FROM                    ' +
    '  COMANDA              ' +
    'ORDER BY                ' +
    ' ID                     ';
{$EndRegion}
Var
  Ldataset : Tdataset;
begin
  try
    try
      LDataset :=
        FQuery
          .SQL(LSelect)
          .OpenDataSet;

      Result := LDataset.ToJSONArray;
    except
      Result := TJSONArray.Create;
    end;
  finally
    LDataSet.Free;
  end;

end;
//------------------------------------------------------------------------------

//function TADRConnDAOUsuario.Login(AValue: string): TJSONObject;
//{$Region 'SELECT'}
//const
//  LSelect =
//    'SELECT ID, USUARIO, SENHA, TIPOUSUARIO FROM USUARIOS WHERE UPPER(USUARIO) =:pUSUARIO AND SENHA =:pSENHA';
//{$EndRegion}
//var
//  LDataSet : TDataSet;
//  LUsuario : string;
//  LSenha   : string;
//  LJSON    : TJSONValue;
//begin
//  try
//    try
//      LJSON    := TJSONObject.ParseJSONValue(AValue) as TJSONValue;
//      LUsuario := LJSON.GetValue<string>('usuario');
//      LSenha   := LJSON.GetValue<string>('senha');
//
//      LDataSet :=
//        FQuery
//          .SQL(LSelect)
//          .ParamAsString('pUSUARIO', UpperCase(LUsuario))
//          .ParamAsString('pSENHA', LSenha)
//          .OpenDataSet;
//
//      Result := LDataSet.ToJSONObject;
//    except
//      Result := TJSONObject.Create;
//    end;
//  finally
//    LDataSet.Free;
//  end;
//end;
function TADRConnDAOUsuario.Login(AValue: string): TJSONObject;
{$Region 'SELECT'}
const
  LSelect =
    'SELECT ID, USUARIO, SENHA, TIPOUSUARIO FROM USUARIOS WHERE UPPER(USUARIO) =:pUSUARIO AND SENHA =:pSENHA';
{$EndRegion}
var
  LDataSet: TDataSet;
  LUsuario: string;
  LSenha: string;
  LParams: TStrings;
begin
  LDataSet := nil;
  Result := TJSONObject.Create;

  try
    LParams := TStringList.Create;
    try
      // Analisa a string de consulta para extrair os par�metros
      ExtractStrings(['&'], [], PChar(AValue), LParams);

      // Extrai os valores dos par�metros
      LUsuario := LParams.Values['usuario'];
      LSenha := LParams.Values['senha'];

      if (LUsuario = '') or (LSenha = '') then
        raise Exception.Create('Usu�rio ou senha n�o fornecidos');

      LDataSet :=
        FQuery
          .SQL(LSelect)
          .ParamAsString('pUSUARIO', UpperCase(LUsuario))
          .ParamAsString('pSENHA', LSenha)
          .OpenDataSet;

      if not LDataSet.IsEmpty then
        Result := LDataSet.ToJSONObject
      else
        raise Exception.Create('Usu�rio ou senha inv�lidos');
    finally
      LParams.Free;
    end;
  except
    on E: Exception do
    begin
      Result := TJSONObject.Create;
      Result.AddPair('error', E.Message);
    end;
  end;

  if Assigned(LDataSet) then
    LDataSet.Free;
end;






//------------------------------------------------------------------------------
function TADRConnDAOUsuario.Find(AID: Integer): TJSONObject;
{$Region 'SELECT'}
const
  LSelect =
    'SELECT ID, USUARIO, SENHA, TIPOUSUARIO FROM USUARIOS WHERE ID = :pID ORDER BY ID';
{$EndRegion}
Var
  Ldataset : Tdataset;
begin
  try
    try
      LDataset :=
        FQuery
          .SQL(LSelect)
          .ParamAsInteger('pID', AID)
          .OpenDataSet;

      Result := LDataset.ToJSONObject;
    except
      Result := TJSONObject.Create;
    end;
  finally
    LDataSet.Free;
  end;
end;
//------------------------------------------------------------------------------
function TADRConnDAOUsuario.Insert(AValue: string): TJSONObject;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  *                     ' +
    'FROM                    ' +
    '  Usuario               ' +
    'WHERE                   ' +
    '  1=2                   ';
{$EndRegion}
Var
  Ldataset : Tdataset;
begin
  try
    try
      LDataset :=
        FQuery
          .SQL(LSelect)
          .OpenDataSet;

        LDataSet
          .LoadFromJSON(AValue);

      Result := LDataset.ToJSONObject;
    except
      Result := TJSONObject.Create;
    end;
  finally
    LDataSet.Free;
  end;
end;
//------------------------------------------------------------------------------
function TADRConnDAOUsuario.Update(AID: Integer; AValue: string): TJSONObject;
{$Region 'SELECT'}
const
  LSelect =
    'SELECT ID, USUARIO, SENHA, TIPOUSUARIO FROM USUARIOS WHERE ID = :pID'+
    ' ORDER BY ID';
{$EndRegion}
Var
  Ldataset : Tdataset;
begin
  try
    try
      LDataset :=
        FQuery
          .SQL(LSelect)
          .ParamAsInteger('pID', AID)
          .OpenDataSet;

      LDataSet
        .MergeFromJSONObject(AValue);

      Result := LDataset.ToJSONObject;
    except
      Result := TJSONObject.Create;
    end;
  finally
    LDataSet.Free;
  end;
end;

end.
