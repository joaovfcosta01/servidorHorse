unit controllers.usuarios;

interface

procedure Registry;

implementation
uses
  Horse,

  ADRConn.Model.Factory,
  ADRConn.Model.Interfaces,

  DAO.Usuarios,

  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils;
//------------------------------------------------------------------------------
procedure DoList(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOUsuario;
  LConn   : IADRConnection;
  LResult : TJSONArray;
begin
  LConn := TADRConnModelFactory.GetConnectionIniFile();
  LConn.Connect;
  LDAO := TADRConnDAOUsuario.Create(LConn);
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
  LDAO    : TADRConnDAOUsuario;
  LConn   : IADRConnection;
  LResult : TJSONObject;
  LID     : Integer;
begin
  if not TryStrToInt(Req.Params['id'] , LID) then
    raise Exception.Create('ID inv�lido. Envie um n�mero inteiro.');

  LConn := TADRConnModelFactory.GetConnectionIniFile();
  LConn.Connect;
  LDAO := TADRConnDAOUsuario.Create(LConn);
  try
    LResult := LDAO.Find(LID);
    if LResult.Count > 0 then
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.OK)
    else
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.NotFound)
  finally
    LDao.Free;
  end;
end;
//------------------------------------------------------------------------------
procedure DoInsert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOUsuario;
  LConn   : IADRConnection;
  LResult : TJSONObject;
begin
  if Req.Body.IsEmpty then
    raise Exception.Create('Corpo da requisi��o inv�lido. Envie um JSONArray '+
                            'com os dados a serem inseridos.');

  LConn := TADRConnModelFactory.GetConnectionIniFile();
  LConn.Connect;
  LDAO := TADRConnDAOUsuario.Create(LConn);
  try
    LResult := LDAO.Insert(Req.Body);
    if LResult.Count > 0 then
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.OK)
    else
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.NotFound)
  finally
    LDao.Free;
  end;
end;
//------------------------------------------------------------------------------
 procedure DoUpdate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOUsuario;
  LConn   : IADRConnection;
  LResult : TJSONObject;
  LID     : Integer;
begin
  if not TryStrToInt(Req.Params['id'] , LID) then
    raise Exception.Create('ID inv�lido. Envie um n�mero inteiro.');

  if Req.Body.IsEmpty then
    raise Exception.Create('Corpo da requisi��o inv�lido. Envie um JSONArray '+
                            'com os dados a serem inseridos.');

  LConn := TADRConnModelFactory.GetConnectionIniFile();
  LConn.Connect;
  LDAO := TADRConnDAOUsuario.Create(LConn);
  try
    LResult := LDAO.Update(LID, Req.Body);
    if LResult.Count > 0 then
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.OK)
    else
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.NotFound)
  finally
    LDao.Free;
  end;
end;
//------------------------------------------------------------------------------
 procedure DoLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDAO    : TADRConnDAOUsuario;
  LConn   : IADRConnection;
  LDADOS  : TJSONValue;
  LResult : TJSONObject;
  LID     : Integer;
begin
  if Req.Body.IsEmpty then
    raise Exception.Create('Corpo da requisi��o inv�lido. Envie um JSONArray '+
                            'com os dados a serem inseridos.');

  LConn := TADRConnModelFactory.GetConnectionIniFile();
  LConn.Connect;
  LDAO := TADRConnDAOUsuario.Create(LConn);
  LDADOS := TJSONObject.ParseJSONValue(Req.Body);
  try
    LResult := LDAO.Login(Req.Body);
    if LResult.Count > 0 then
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.OK)
    else
      Res
        .Send<TJSONObject>(LResult)
        .Status(THTTPStatus.NotFound)
  finally
    LDao.Free;
  end;
end;
//------------------------------------------------------------------------------
procedure Registry;
begin
  THorse.Get('/usuarios/'        , DoList);
  THorse.Get('/usuarios/:id'     , DoFind);
  THorse.Post('/usuarios/'       , DoInsert);
  THorse.Put('/usuarios/:id'     , DoUpdate);
  THorse.Get ('/usuarios/login'  , DoLogin);
end;
end.
