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
function TADRConnDAOUsuario.Login(AValue: String): TJSONObject;
{$Region 'SELECT'}
const
  LSelect =
    'SELECT ID, USUARIO, SENHA, TIPOUSUARIO FROM USUARIOS WHERE UPPER(USUARIO) =:pUSUARIO AND SENHA =:pSENHA';
{$EndRegion}
Var
  Ldataset : Tdataset;
  LUsuario : String;
  LSenha   : String;
  LJSON    : TJSONValue;
begin
  try
    try
      LJSON    := TJSONObject.ParseJSONValue(AValue) as TJSONValue;
      LUsuario := LJSON.GetValue<String>('usuario');
      LSenha   := LJSON.GetValue<String>('senha');
      LDataset :=
        FQuery
          .SQL(LSelect)
          .ParamAsString('pUsuario', UpperCase(LUsuario))
          .ParamAsString('pSenha', LSenha)
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
