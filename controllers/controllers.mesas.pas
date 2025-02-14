unit controllers.mesas;

interface

procedure Registry;

implementation

uses
  Horse,

  ADRConn.Model.Factory,
  ADRConn.Model.Interfaces,

  DAO.Mesas,

  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils;

//------------------------------------------------------------------------------

procedure DoList(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOMesa;
  LConn   : IADRConnection;
  LResult : TJSONArray;
begin
  LConn := TADRConnModelFactory.GetConnectionIniFile();
  LConn.Connect;
  LDAO := TADRConnDAOMesa.Create(LConn);
  try
    LResult := LDAO.List;
    if LResult.Count > 0 then
      Res
        .Send<TJSONArray>(LResult)
        .Status(THTTPStatus.OK)
    else
      Res
        .Send<TJSONArray>(LResult)
        .Status(THTTPStatus.NotFound)
  finally
    LDao.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure DoFind(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOMesa;
  LConn   : IADRConnection;
  LResult : TJSONObject;
  LID     : Integer;
begin
  if not TryStrToInt(Req.Params['id'],LID) then
    raise Exception.Create('ID inv�lido. Envie um n�mero inteiro');

  LConn := TADRConnModelFactory.GetConnectionIniFile;
  LConn.Connect;
  LDAO := TADRConnDAOMesa.Create(LConn);
  try
    LResult := LDAO.Find(LID);
    Res.Send(LResult);
  finally
    LDao.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure DoInsert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOMesa;
  LConn   : IADRConnection;
  LResult : TJSONObject;
begin
  if Req.Body.IsEmpty then
  raise Exception.Create('corpo da requisi��o inv�lido. Envie um JsonObject com dados.');


  LConn := TADRConnModelFactory.GetConnectionIniFile();
  LConn.Connect;
  LDAO := TADRConnDAOMesa.Create(LConn);
  try
    LResult := LDAO.Insert(Req.Body);
    Res.Send(LResult);
  finally
    LDao.Free;
  end;
  //Res.Send('DoInsert');
end;

//------------------------------------------------------------------------------

procedure DoUpdate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOMesa;
  LConn   : IADRConnection;
  LDADOS  : TJSONValue;
  LResult : TJSONObject;
  LID     : Integer;
begin
  if not TryStrToInt(Req.Params['id'],LID) then
    raise Exception.Create('ID inv�lido. Envie um n�mero inteiro');

  if Req.Body.IsEmpty then
    raise Exception.Create('corpo da requisi��o inv�lido. Envie um JsonObject com dados.');


  LConn := TADRConnModelFactory.GetConnectionIniFile;
  LConn.Connect;
  LDAO := TADRConnDAOMesa.Create(LConn);
  LDADOS := TJSONObject.ParseJSONValue(Req.Body);
  try
    LResult := LDAO.Update(LID, Req.Body);
    Res.Send(LResult);
  finally
    LDao.Free;
  end;
end;

//------------------------------------------------------------------------------
{$Region 'Procedure Exclus�o F�sica'}
//procedure DoDelete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
//var
//  LDAO    : TADRConnDAOMesa;
//  LConn   : IADRConnection;
//  LResult : TJSONObject;
//  LID     : Integer;
//begin
//  if not TryStrToInt(Req.Params['id'],LID) then
//    raise Exception.Create('ID inv�lido. Envie um n�mero inteiro');
//
//
//  LConn := TADRConnModelFactory.GetConnectionIniFile;
//  LConn.Connect;
//  LDAO := TADRConnDAOMesa.Create(LConn);
//  try
//    LResult := LDAO.Delete(LID);
//    Res.Send(LResult);
//  finally
//    LDao.Free;
//  end;
//end;
{$EndRegion}
//----------------------------Exclus�o L�gica-----------------------------------

procedure DoDelete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOMesa;
  LConn   : IADRConnection;
  LResult : TJSONObject;
  LID     : Integer;
begin
  if not TryStrToInt(Req.Params['id'],LID) then
    raise Exception.Create('ID inv�lido. Envie um n�mero inteiro');

  if Req.Body.IsEmpty then
    raise Exception.Create('corpo da requisi��o inv�lido. Envie um JsonObject com dados.');

  LConn := TADRConnModelFactory.GetConnectionIniFile;
  LConn.Connect;
  LDAO := TADRConnDAOMesa.Create(LConn);
  try
    LResult := LDAO.Delete(LID, Req.Body);
    Res.Send(LResult);
  finally
    LDao.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure Registry;
begin
  THorse.Get    ('/mesas'      ,  DoList);
  THorse.Get    ('/mesas/:id'  ,  DoFind);
  THorse.Post   ('mesas/'      ,  DoInsert);
  THorse.Put    ('/mesas/:id'  ,  DoUpdate);
  THorse.Delete ('/mesas/:id'  ,  DoDelete);
  end;

end.
