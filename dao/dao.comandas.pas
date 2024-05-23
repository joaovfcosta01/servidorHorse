unit dao.comandas;

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
  TADRConnDAOComandas = class(TADRConnDAOBase)
    private
    public
      function List(): TJSONArray;
      function Find(AID: Integer): TJSONObject;
      function Insert(AValue: string): TJSONObject;
      function Update(AID: Integer; AValue: string): TJSONObject;
  end;

implementation

{ TADRConnDAOComandas }

function TADRConnDAOComandas.List: TJSONArray;
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
function TADRConnDAOComandas.Find(AID: Integer): TJSONObject;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  *                     ' +
    'FROM                    ' +
    '  COMANDA               ' +
    'WHERE                   ' +
    '  ID         =:pID      ';
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
function TADRConnDAOComandas.Insert(AValue: string): TJSONObject;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  *                     ' +
    'FROM                    ' +
    '  COMANDA               ' +
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
function TADRConnDAOComandas.Update(AID: Integer; AValue: string): TJSONObject;
{$Region 'Select'}
const
  LSelect =
    'SELECT                  ' +
    '  *                     ' +
    'FROM                    ' +
    '  COMANDA               ' +
    'WHERE                   ' +
    '  ID =:pID              ';
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
