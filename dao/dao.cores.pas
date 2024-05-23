unit dao.cores;

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
  TADRConnDAOCores = class(TADRConnDAOBase)
    private
    public
      function List(): TJSONArray;
      function Find(AID: Integer): TJSONObject;
      function Insert(AValue: string): TJSONObject;
      function Update(AID: Integer; AValue: string): TJSONObject;
  end;

implementation
{ TADRConnDAOMesa }
//------------------------------------------------------------------------------
function TADRConnDAOCores.List: TJSONArray;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  ID_COR              , ' +
    '  ID_PERFIL           , ' +
    '  NOME_PERFIL         , ' +
    '  COR_OCUPADA         , ' +
    '  COR_LABEL_OCUPADA   , ' +
    '  COR_LIVRE           , ' +
    '  COR_LABEL_LIVRE     , ' +
    '  COR_PRINCIPAL       , ' +
    '  COR_SECUNDARIA      , ' +
    '  COR_TERCIARIA       , ' +
    '  COR_FONTE_ESMAECIDA , ' +
    '  COR_FONTE_ATIVA       ' +
    'FROM                    ' +
    '  CORES                 ' +
    'ORDER BY                ' +
    ' ID_COR                 ';
{$EndRegion}
var
  LDataSet : TDataSet;
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
function TADRConnDAOCores.Find(AID: Integer): TJSONObject;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  ID_COR              , ' +
    '  ID_PERFIL           , ' +
    '  NOME_PERFIL         , ' +
    '  COR_OCUPADA         , ' +
    '  COR_LABEL_OCUPADA   , ' +
    '  COR_LIVRE           , ' +
    '  COR_LABEL_LIVRE     , ' +
    '  COR_PRINCIPAL       , ' +
    '  COR_SECUNDARIA      , ' +
    '  COR_TERCIARIA       , ' +
    '  COR_FONTE_ESMAECIDA , ' +
    '  COR_FONTE_ATIVA       ' +
    'FROM                    ' +
    '  CORES                 ' +
    'WHERE                   ' +
    '  ID_PERFIL  =:pID      ';
{$EndRegion}
var
  LDataSet : TDataSet;
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
function TADRConnDAOCores.Insert(AValue: string): TJSONObject;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  ID_COR              , ' +
    '  ID_PERFIL           , ' +
    '  NOME_PERFIL         , ' +
    '  COR_OCUPADA         , ' +
    '  COR_LABEL_OCUPADA   , ' +
    '  COR_LIVRE           , ' +
    '  COR_LABEL_LIVRE     , ' +
    '  COR_PRINCIPAL       , ' +
    '  COR_SECUNDARIA      , ' +
    '  COR_TERCIARIA       , ' +
    '  COR_FONTE_ESMAECIDA , ' +
    '  COR_FONTE_ATIVA       ' +
    'FROM                    ' +
    '  CORES                 ' +
    'WHERE                   ' +
    '  1=2                   ';
{$EndRegion}
var
  LDataSet : TDataSet;
begin
  try
    try
      LDataSet :=
        FQuery
          .SQL(LSelect)
          .OpenDataSet;

      LDataSet
        .LoadFromJSON(AValue);

      Result := LDataSet.ToJSONObject;
    except
      Result := TJSONObject.Create;
    end;
  finally
    LDataSet.Free;
  end;

end;
//------------------------------------------------------------------------------
function TADRConnDAOCores.Update(AID: Integer; AValue: string): TJSONObject;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  ID_COR                ' +
    '  ID_PERFIL           , ' +
    '  NOME_PERFIL         , ' +
    '  COR_OCUPADA         , ' +
    '  COR_LABEL_OCUPADA   , ' +
    '  COR_LIVRE           , ' +
    '  COR_LABEL_LIVRE     , ' +
    '  COR_PRINCIPAL       , ' +
    '  COR_SECUNDARIA      , ' +
    '  COR_TERCIARIA       , ' +
    '  COR_FONTE_ESMAECIDA , ' +
    '  COR_FONTE_ATIVA       ' +
    'FROM                    ' +
    '  CORES                 ' +
    'WHERE                   ' +
    '  ID_PERFIL =:pID        ';
{$EndRegion}
var
  LDataSet : TDataSet;
begin
  try
    try
      LDataSet :=
        FQuery
          .SQL(LSelect)
          .ParamAsInteger('pID', AID)
          .OpenDataSet;

      LDataSet
        .MergeFromJSONObject(AValue);

      Result := LDataSet.ToJSONObject;
    except
      Result := TJSONObject.Create;
    end;
  finally
    LDataSet.Free;
  end;
end;
//------------------------------------------------------------------------------
end.
