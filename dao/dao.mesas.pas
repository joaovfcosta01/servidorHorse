unit dao.mesas;

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
  TADRConnDAOMesa = class(TADRConnDAOBase)
    private
    public
      function List(): TJSONArray;
      function Find(AID: Integer): TJSONObject;
      function Insert(AValue: string): TJSONObject;
      function Update(AID: Integer; AValue: string): TJSONObject;
      function Delete(AID: Integer; AValue: string =''): TJSONObject;

  end;

implementation

{ TADRConnDAOMesa }
//------------------------------------------------------------------------------

function TADRConnDAOMesa.List: TJSONArray;
const
  LSelect   ='SELECT ID, NUM_MESA, OCUPADA FROM MESA WHERE ATIVOINATIVO = ''A'' ORDER BY  ID';
var
  LDataSet   : TDataSet;
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

function TADRConnDAOMesa.FIND(AID: Integer): TJSONObject;
const
  LSelect   = 'SELECT * FROM MESA WHERE ID =:pID';
var
  LDataSet   : TDataSet;
begin
  try
    LDataset :=
      FQuery
        .SQL(LSelect)
        .ParamAsInteger('pID', AID)
        .OpenDataSet;

      if LDataSet.IsEmpty then
        Result := TJSONObject.Create
      else
        Result := LDataSet.ToJSONObject;
  finally
    LDataSet.Free;
  end;

end;

//------------------------------------------------------------------------------

function TADRConnDAOMesa.Insert(AValue: string): TJSONObject;
const
  LSelect   = 'SELECT * FROM MESA WHERE 1=2';
var
  LDataSet   : TDataSet;
begin
  try
    LDataSet :=
      FQuery
        .SQL(LSelect)
        .OpenDataSet;
    LDataSet.LoadFromJSON(AValue);
    Result := LDataSet.ToJSONObject;
  finally
    LDataSet.Free;
  end;
end;

//------------------------------------------------------------------------------

function TADRConnDAOMesa.Update(AID: Integer; AValue: string): TJSONObject;
const
  LSelect   = 'SELECT * FROM MESA WHERE ID =:pID';
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

//------------------------------------------------------------------------------

{$Region 'Function Exclus�o F�sica'}
//function TADRConnDAOMesa.Delete(AID: Integer; AValue: string): TJSONObject;
//const
//  LSelect   = 'SELECT * FROM MESA WHERE ID =:pID';
//var
//  LDataSet   : TDataSet;
//begin
//  try
//    LDataSet :=
//      FQuery
//        .SQL(LSelect)
//        .ParamAsInteger('pID', AID)
//        .OpenDataSet;
//
//    if LDataSet.IsEmpty then
//      Result := TJSONObject.Create
//    else
//    begin
//      LDataSet.Delete;
//      Result := TJSONObject.Create;
//    end;
//    LDataSet.LoadFromJSON(AValue);
//  finally
//    LDataSet.Free;
//  end;
//end;
{$EndRegion}

//----------------------------Exclus�o L�gica-----------------------------------


function TADRConnDAOMesa.Delete(AID: Integer; AValue: string): TJSONObject;
const
  LSelect   = 'SELECT * FROM MESA WHERE ID =:pID';
var
  LDataSet   : TDataSet;
begin
  try
    LDataSet :=
      FQuery
        .SQL(LSelect)
        .ParamAsInteger('pID', AID)
        .OpenDataSet;

    if LDataSet.IsEmpty then
      Result := TJSONObject.Create
    else
    begin
      {$Region 'Exemplo de JSON Exclus�o L�gica'}
      (*
      //JSON de Exclus�o L�gica
        {
          "ID": AID,
          "NUM_MESA": AID,
          "OCUPADA": 0,
          "ATIVOINATIVO": "I"
        }
      *)
      {$EndRegion}
      LDataSet.MergeFromJSONObject(AValue);
      Result := LDataSet.ToJSONObject;
    end;
    LDataSet.LoadFromJSON(AValue);
  finally
    LDataSet.Free;
  end;
end;

end.