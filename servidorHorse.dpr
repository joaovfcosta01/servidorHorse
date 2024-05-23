program servidorHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.BasicAuthentication,
  Horse.Logger,
  Horse.Logger.Provider.Console,
  Horse.Logger.Provider.LogFile,
  System.SysUtils,
  controllers.mesas in 'controllers\controllers.mesas.pas',
  dao.mesas in 'dao\dao.mesas.pas',
  controllers.cores in 'controllers\controllers.cores.pas',
  dao.cores in 'dao\dao.cores.pas',
  dao.comandas in 'dao\dao.comandas.pas',
  controllers.comandas in 'controllers\controllers.comandas.pas',
  controllers.usuarios in 'controllers\controllers.usuarios.pas',
  dao.usuarios in 'dao\dao.usuarios.pas',
  dao.produtos in 'dao\dao.produtos.pas',
  controllers.produtos in 'controllers\controllers.produtos.pas',
  controllers.pedidos in 'controllers\controllers.pedidos.pas',
  dao.pedidos in 'dao\dao.pedidos.pas';

var
  LLogFileConfig: THorseLoggerLogFileConfig;
  LLogConsoleConfig: THorseLoggerConsoleConfig;
//  LLog              : string;
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
//  if ParamStr(1).Equals(EmptyStr)
//  then LLog := '--c'
//  else LLog := ParamStr(1);



  if ParamStr(1).Equals('--c') or ParamStr(1).Equals('--console') then
  begin
    LLogConsoleConfig := THorseLoggerConsoleConfig.New
      .SetLogFormat('${request_clientip} [${time}] ${response_status}');
    THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New());
    THorse
      .Use(THorseLoggerManager.HorseCallback);
  end

//------------------------------------------------------------------------------

  else if ParamStr(1).Equals('--f') or ParamStr(1).Equals('--file') then
  begin
    LLogFileConfig := THorseLoggerLogFileConfig.New
      .SetLogFormat('${request_clientip} [${time}] ${response_status}')
      .SetDir('C:\Servidor Horse\');
    THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New());
    THorse
      .Use(THorseLoggerManager.HorseCallback);
  end;

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
      Res.Send('Em execução...');
    end
    );

//------------------------------------------------------------------------------


  THorse
    .Listen(9000
//      procedure (Horse: THorse)
//        begin
//          WriteLn(Format('Servidor Comanda Eletronica 2.0 executando na porta %d ', [Horse.Port]));
//          WriteLn('Pronto para funcionameto!');
//          if LLog.Equals('--f') or LLog.Equals('--file') then
//            WriteLn('Atencao! Log salvando em arquivo!');
//        end
  )
end.
