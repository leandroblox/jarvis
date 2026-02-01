#define MyAppName "Jarvis"
#define MyAppVersion "1.0"
#define MyAppPublisher "Leandro Berchielli"
#define MyAppExeName "start_jarvis.bat"

[Setup]
; Identificador único (não mude isso depois de lançar)
AppId={{A1B2C3D4-E5F6-7890-1234-567890ABCDEF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={userpf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=JarvisSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
; Ícone do instalador (se houver, senão usa padrão)
; SetupIconFile=assets\icon.ico

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
; Copia todos os arquivos do repositório
Source: "*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: ".git,.github,*.exe,*.iss,node_modules"
; Copia o Node.js portátil (será baixado pelo GitHub Action antes de compilar)
Source: "bin\*"; DestDir: "{app}\bin"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\assets\icon.ico"
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Iniciar o Jarvis agora"; Flags: nowait postinstall skipifsilent

[Code]
var
  Page: TInputQueryWizardPage;

// --- CRIAÇÃO DA PÁGINA DE CONFIGURAÇÃO (WIZARD) ---
procedure InitializeWizard;
begin
  // Cria uma página após a tela de "Bem-vindo"
  Page := CreateInputQueryWizardPage(wpWelcome,
    'Configuração da Inteligência', 'Conecte o Jarvis ao cérebro da Google',
    'Para funcionar, o Jarvis precisa de uma chave de API do Gemini (Gratuita).');

  // Adiciona o campo de texto
  Page.Add('Chave da API Gemini (Começa com AIza...):', False);
  
  // Define um valor padrão vazio
  Page.Values[0] := '';
end;

// --- GRAVAÇÃO DA CONFIGURAÇÃO (JSON) ---
procedure CurStepChanged(CurStep: TSetupStep);
var
  ConfigPath: String;
  JsonContent: String;
  ApiKey: String;
begin
  // Executa após a cópia dos arquivos (ssPostInstall)
  if CurStep = ssPostInstall then
  begin
    ApiKey := Page.Values[0];
    
    // Se o usuário digitou algo, vamos configurar
    if Length(ApiKey) > 5 then
    begin
      ConfigPath := ExpandConstant('{userappdata}\.openclaw\openclaw.json');
      
      // Garante que a pasta existe
      ForceDirectories(ExpandConstant('{userappdata}\.openclaw'));

      // Cria o JSON de configuração (Simplificado para o exemplo)
      // Isso evita que o Jarvis pergunte na linha de comando
      JsonContent := '{' + #13#10 +
        '  "auth": {' + #13#10 +
        '    "profiles": {' + #13#10 +
        '      "google:default": {' + #13#10 +
        '        "provider": "google",' + #13#10 +
        '        "mode": "api_key",' + #13#10 +
        '        "apiKey": "' + ApiKey + '"' + #13#10 +
        '      }' + #13#10 +
        '    }' + #13#10 +
        '  },' + #13#10 +
        '  "agents": {' + #13#10 +
        '    "defaults": {' + #13#10 +
        '      "model": { "primary": "google/gemini-3-pro-preview" }' + #13#10 +
        '    }' + #13#10 +
        '  }' + #13#10 +
        '}';

      // Salva o arquivo
      SaveStringToFile(ConfigPath, JsonContent, False);
    end;
  end;
end;
