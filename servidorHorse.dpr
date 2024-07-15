program servidorHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.Logger,
  Horse.Logger.Provider.Console,
  Horse.Logger.Provider.LogFile,
  Horse.Paginate,
  Horse.HandleException,
  Horse.BasicAuthentication,
  System.Json,
  System.SysUtils,
  REST.Json,
  Dataset.Serialize,
  Dataset.Serialize.Config,
  RESTRequest4D,
  controllers.mesas in 'controllers\controllers.mesas.pas',
  dao.mesas in 'dao\dao.mesas.pas',
  dao.usuarios in 'dao\dao.usuarios.pas',
  controllers.usuarios in 'controllers\controllers.usuarios.pas',
  controllers.comandas in 'controllers\controllers.comandas.pas',
  dao.comandas in 'dao\dao.comandas.pas',
  controllers.produtos in 'controllers\controllers.produtos.pas',
  dao.produtos in 'dao\dao.produtos.pas',
  controllers.pedidos in 'controllers\controllers.pedidos.pas',
  dao.pedidos in 'dao\dao.pedidos.pas',
  controllers.cores in 'controllers\controllers.cores.pas',
  dao.cores in 'dao\dao.cores.pas';

var
  LLogFileConfig: THorseLoggerLogFileConfig;
  LLogConsoleConfig: THorseLoggerConsoleConfig;
  LLog              : string;
begin
  THorse
    .Use(Jhonson);

//------------------------------------------------------------------------------

  THorse
    .Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('adm') and APassword.Equals('123');
    end)
  );

//------------------------------------------------------------------------------
  if ParamStr(1).Equals(EmptyStr) then
    LLog := '--c'
  else LLog := ParamStr(1);

if ParamStr(1).Equals('--c') or ParamStr(1).Equals('--console') then
  begin
//    LLogConsoleConfig := THorseLoggerConsoleConfig.New
//      .SetLogFormat('${request_clientip} [${time}] ${response_status}');
    THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New());
    THorse.Use(THorseLoggerManager.HorseCallback);
  end

//------------------------------------------------------------------------------

  else if ParamStr(1).Equals('--f') or ParamStr(1).Equals('--file') then
  begin
    LLogFileConfig := THorseLoggerLogFileConfig.New
      .SetLogFormat('${request_clientip} [${time}] ${response_status}')
      .SetDir('C:\Servidor_Horse\rel');
    THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New());
    THorse
      .Use(THorseLoggerManager.HorseCallback);
  end;
//------------------------------------------------------------------------------
  THorse
    .Get('/version',
    procedure (Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LVersion : String;
      LObj     : TJSONObject;
    begin
      Randomize;
      LVersion := (Format('%3.3d', [Random(100)]));
      LObj := TJSONOBject.Create;
      LObj.AddPair('Version', LVersion);
      Res.Send<TJSONObject>(LObj);
    end
    );
//------------------------------------------------------------------------------
    THorse
      .Get('/ping',
      procedure (Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
        LJSON     : TJSONValue;
        LResponse : IResponse;
      begin
        LResponse :=
          TRequest.New.BaseURL('https://api.myip.com')
            .ContentType('application/json')
            .Get;
        LJson := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONValue;
        WriteLn(TJson.Format(LJson));
        Res.Send(LResponse.Content);
      end
      );
//------------------------------------------------------------------------------

  controllers.mesas.Registry;
  controllers.cores.Registry;
  controllers.comandas.Registry;
  controllers.usuarios.Registry;
  controllers.produtos.Registry;
  controllers.pedidos.Registry;

//------------------------------------------------------------------------------

  THorse
    .Get('/healthcheck',
    procedure (Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('Ta joia');
    end
    );

//------------------------------------------------------------------------------

  LLog:= '--f';
  THorse
    .Listen(9000,
    procedure (Horse: THorse)
    begin
      WriteLn(Format('Servidor Comanda Eletronica executando na porta %d ', [Horse.Port]));
      WriteLn('Bora trabaiar!');
      if LLog.Equals('--f') or LLog.Equals('--file') then
        WriteLn('Atencao! Log salvando em arquivo!');
    end
  )
end.
