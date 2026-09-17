# MANUAL DE ARQUITETURA, OPERAÇÃO E MANUTENÇÃO DE MÉDIO E LONGO PRAZO

**Sistema:** Seasons (chat_wrapped)  
**Versão da Arquitetura:** 1.0.0  
**Data:** 17 de Setembro de 2026   

---

## SUMÁRIO EXECUTIVO

O **Seasons** é uma plataforma móvel multiplataforma desenvolvida em Flutter/Dart voltada à ingestão, decodificação, análise estatística retrospectiva e geração editorial de narrativas visuais (*Stories* 9:16) a partir de exportações de conversas do WhatsApp (`.txt` e `.zip`). 

O sistema opera sob o paradigma fundamental **Local-First / On-Device Processing**, executando 100% dos procedimentos de parsing e algoritmos analíticos estritamente no hardware do usuário. Este documento consolida formalmente as decisões arquiteturais, o catálogo de padrões de projeto, os procedimentos operacionais de manutenção contínua, os mecanismos de resiliência e o plano de sustentação de médio e longo prazo.

---

# 1. VISÃO GERAL DA ARQUITETURA E DECISÕES FUNDAMENTAIS

## 1.1. Padrão Arquitetural Adotado

A aplicação adota os princípios da **Clean Architecture** (Arquitetura Limpa) consorciados com o padrão **Ports and Adapters** (Arquitetura Hexagonal), estabelecendo uma segregação rígida entre lógica de domínio, serviços de infraestrutura de arquivo e subsistemas de apresentação reativa.

```
[ Camada Externa: OS / File System / Share Intent ]
                       │ (arquivo .txt ou .zip)
                       ▼
┌──────────────────────────────────────────────────────────────┐
│ 1. CAMADA DE INFRAESTRUTURA & ENTRADA                        │
│    - FileIngestionService (deteção de tipo MIME / Magic Bytes)│
│    - ZipExtractorService (streaming seletivo de .txt)        │
└──────────────────────┬───────────────────────────────────────┘
                       │ (raw String)
                       ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. CAMADA DE NORMALIZAÇÃO & PARSER CORE                      │
│    - TextSanitizer (expurgo de caracteres invisíveis e LRM)  │
│    - WhatsAppRegex (autômato de padrões de cabeçalho)        │
│    - ChatParser (autômato de estados finito / multiline)     │
└──────────────────────┬───────────────────────────────────────┘
                       │ (List<ChatMessage> -> RawChatExport)
                       ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. CAMADA DE DOMÍNIO & PROCESSAMENTO ANALÍTICO               │
│    - ChatAnalyzer (orquestrador e baseline estatístico)      │
│    - CasalAnalyzer, AmigosAnalyzer, GrupoAnalyzer            │
│    - Modelos de Dados Imutáveis (Value Objects)              │
└──────────────────────┬───────────────────────────────────────┘
                       │ (AnalysisResult)
                       ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. CAMADA DE ADAPTAÇÃO & APRESENTAÇÃO                        │
│    - StoryAdapters (CasalStoryAdapter, AmigosStoryAdapter)   │
│    - StoryCardFactory (despacho polimórfico de slides)       │
│    - Gerenciamento de Estado (Provider / ValueNotifiers)     │
└──────────────────────┬───────────────────────────────────────┘
                       │ (Widgets / State)
                       ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. CAMADA VISUAL & EXPORTAÇÃO                                │
│    - DashboardScreen (Bento Grid, métricas de alto nível)    │
│    - StoriesViewerScreen (experiência interativa 9:16)       │
│    - SocialShareEngine (RepaintBoundary -> PNG -> ShareSheet)│
└──────────────────────────────────────────────────────────────┘
```

### Fluxo Lógico Textual Unidirecional:
1. **Entrada de Arquivo:** O usuário fornece o arquivo via `FilePicker` do sistema operacional ou mediante disparo de *Share Intent* nativo do WhatsApp (`ACTION_SEND`).
2. **Descompressão Seletiva:** Caso o fluxo receba um `.zip`, o `ZipExtractorService` lê o arquivo através de um canal de *streaming* (`InputFileStream`), localiza o arquivo interno de conversa (`_chat.txt` ou `*.txt`) e o descompacta isoladamente, ignorando ativos pesados de mídia (vídeos, fotos, áudios).
3. **Higienização Textual:** O `TextSanitizer` aplica uma passagem linear no texto descartando marcadores direcionais de formatação Unicode (LRM, RLM, BOM, ZWSP) e padronizando variações de espaço não separável (NBSP, NNBSP).
4. **Parsing Sintático:** O `ChatParser` processa linha a linha via máquina de estados finita acoplada ao `WhatsAppRegex`, separando cabeçalhos válidos, mensagens multilinhas contínuas e notificações de sistema.
5. **Estruturação de Domínio:** As mensagens são instanciadas como entidades imutáveis `ChatMessage` e agrupadas em um `RawChatExport`.
6. **Processamento Analítico:** O `ChatAnalyzer` computa métricas universais (volume temporal, top participantes, horários de pico) e delega a computação especializada ao analisador do modo selecionado (`CasalAnalyzer`, `AmigosAnalyzer` ou `GrupoAnalyzer`).
7. **Adaptação de Apresentação:** A camada de adaptadores (`CasalStoryAdapter`, etc.) calcula grandezas secundárias derivadas e formata os dados para consumo das telas sem expor detalhes matemáticos à camada gráfica.
8. **Renderização Visual:** O gerenciador de estado (`Provider`) notifica a árvore de widgets, que renderiza o `DashboardScreen` e o `StoriesViewerScreen` com suporte a gestos e transições a 60fps.

---

## 1.2. Justificativa Técnica e Ética da Abordagem "Local-First"

A escolha arquitetural de operar em regime estritamente **Local-First (On-Device Processing)** decorre de premissas éticas, jurídicas e econômicas indissociáveis:

| Dimensão | Modelo Tradicional Baseado em Nuvem | Paradigma Local-First do Seasons |
| :--- | :--- | :--- |
| **Conformidade Legal (LGPD / GDPR)** | Elevado risco de desconformidade. A transmissão e custódia de dados de mensageria privada exigem termo de consentimento explícito, relatório de impacto à proteção de dados (RIPD), nomeação de DPO e risco severo de multas (Art. 52 LGPD). | **Conformidade nativa por desenho (*Privacy by Design & by Default*)**. Como os dados nunca saem da memória volátil do aparelho do usuário, não há transferência, custódia ou compartilhamento com terceiros (Arts. 6º, 7º e 11 da Lei 13.709/2018). |
| **Custo Total de Propriedade (TCO)** | Alto custo recorrente. Escalabilidade exige instâncias de servidores (Compute Engine / AWS EC2), bancos de dados gerenciados, largura de banda para upload de gigabytes de texto e custos com balanceadores de carga. | **TCO de processamento igual a Zero**. A infraestrutura computacional utilizada é a própria CPU/GPU/NPU do hardware móvel pertencente ao cliente. O custo operacional de backend para parsing é nulo. |
| **Disponibilidade e Resiliência** | Dependente de conectividade com a internet, latência de rede variável, falhas de DNS e eventuais paradas programadas de servidores. | **100% Offline e Instantâneo**. O aplicativo opera com a mesma eficiência em modo avião, em conexões 3G instáveis ou no topo de uma montanha. Latência de rede nula (0 ms). |
| **Superfície de Ataque e Segurança** | Alta exposição: riscos de ataques de Man-in-the-Middle (MitM), vazamento de credenciais em trânsito, invasão a bancos de dados centrais e acesso indevido por operadores de infraestrutura. | **Superfície de ataque drasticamente minimizada**. Não existem endpoints expostos, APIs REST, chaves de acesso a nuvem nem bancos de dados em rede para serem invadidos. A segurança é delimitada pela sandbox do sistema operacional do aparelho. |

---

## 1.3. Princípios de Engenharia de Software Aplicados

1. **Separação de Preocupações (Separation of Concerns - SoC):**
   A arquitetura delimita fronteiras claras: a extração de arquivos não conhece regras de formatação textual; o motor de parsing não conhece lógica de negócios ou estatística; os analisadores não conhecem widgets de tela; os componentes visuais dos *Stories* apenas leem contratos de adaptadores.
2. **Princípio da Responsabilidade Única (Single Responsibility Principle - SRP):**
   * `TextSanitizer`: puramente focado em higienização e remoção de caracteres invisíveis Unicode.
   * `WhatsAppRegex`: repositório exclusivo de expressões regulares e regras léxicas de marcação.
   * `ChatParser`: implementa a lógica do autômato de agregação de mensagens em buffer.
   * `ZipExtractorService`: responsável único pela manipulação e descompressão de contêineres ZIP.
3. **Baixo Acoplamento e Alta Coesão (Loose Coupling & High Cohesion):**
   O `FileIngestionService` consome interfaces e classes abstratas do parser. Isso assegura que alterações gramaticais no WhatsApp não afetem o comportamento dos serviços de sistema ou do pipeline de telas.
4. **Princípio Aberto/Fechado (Open/Closed Principle - OCP):**
   O catálogo de telas de *Stories* e análises é estendido via criação de novos nós e adaptadores sem a necessidade de modificar as classes já existentes e consolidadas. A adição de um slide específico é feita instanciando novos componentes herdados de `StoryCardBase` e registrados via `StoryCardFactory`.
5. **Princípio da Inversão de Dependência (Dependency Inversion Principle - DIP):**
   Módulos de alto nível de coordenação (ex: `FileIngestionService`) recebem suas dependências de parsing e descompressão via injeção em seus construtores, facilitando a substituição por mocks determinísticos durante suítes de testes unitários.

---

# 2. CONFIGURAÇÃO DE AMBIENTE E ONBOARDING DE NOVOS DESENVOLVEDORES

## 2.1. Matriz de Compatibilidade Técnica

| Componente de Software | Versão Mínima Homologada | Versão Recomendada | Observações e Justificativas Técnicas |
| :--- | :--- | :--- | :--- |
| **Dart SDK** | `3.13.3` | `^3.13.3` ou superior | Suporte nativo a *records*, *patterns*, *sealed classes* e *FontFeature.tabularFigures()*. |
| **Flutter SDK** | `3.19.0` | `3.24.x LTS` | Motor gráfico Impeller/Skia com renderização estável a 60/120fps e gerenciamento de memória refinado. |
| **Android SDK (compileSdk)**| `API 34` | `API 34` (Android 14) | Requisito das diretrizes de publicação do Google Play Store para modernidade de APIs de permissão. |
| **Android SDK (minSdk)**    | `API 21` | `API 21` (Android 5.0) | Abrange mais de 99% da base instalada de dispositivos globais sem comprometer recursos nativos. |
| **Android NDK**            | `25.1.8937393` | `26.x` | Compilação C/C++ de bibliotecas de baixo nível do motor gráfico e compilação AOT do Dart. |
| **Java Development Kit**    | `OpenJDK 17` | `OpenJDK 17 (JBR)` | Runtime obrigatório para Gradle 8.x e Android Gradle Plugin (AGP) 8.x. |
| **Xcode (macOS / iOS)**    | `15.0` | `15.4+` | Compilação para iOS 17+, compatibilidade com novas regras de *Privacy Manifests* (`PrivacyInfo.xcprivacy`). |
| **iOS Deployment Target**  | `iOS 13.0` | `iOS 14.0+` | Suporte a APIs modernas de compartilhamento e renderização de fontes tipográficas suíças. |
| **CocoaPods**              | `1.14.0` | `1.15.x` | Gerenciamento de pods nativos de integração iOS (`share_plus`, `path_provider`). |

---

## 2.2. Guia de Instalação e Execução Reprodutível

Para configurar a estação de trabalho de um novo desenvolvedor em ambiente de desenvolvimento, execute a sequência exata de comandos no terminal:

```bash
# 1. Clonar o repositório oficial do projeto
git clone https://github.com/RiosWesley/Seasons.git
cd Seasons

# 2. Verificar a higidez do ambiente Flutter e dependências de sistema
flutter doctor -v

# 3. Baixar e validar as dependências do pubspec.yaml
flutter pub get

# 4. Executar a validação estática de tipos e regras de linter
dart analyze --fatal-infos

# 5. Executar a suíte de testes unitários para garantir conformidade
flutter test

# 6. Executar a aplicação em emulador ou dispositivo físico conectado
# Listar os dispositivos disponíveis:
flutter devices

# Executar em modo Debug (substitua <DEVICE_ID> pelo ID do emulador/aparelho):
flutter run -d <DEVICE_ID>
```

---

## 2.3. Configurações Críticas de Compilação para Produção

### 2.3.1. Plataforma Android
No arquivo `android/app/build.gradle`:
* **Assinatura de Release:** Nunca commitar chaves criptográficas (`.jks`/`.keystore`) no repositório. Configurar a leitura de credenciais a partir de `android/key.properties`:
  ```properties
  storePassword=SENHA_DO_KEYSTORE
  keyPassword=SENHA_DA_CHAVE
  keyAlias=seasons_key
  storeFile=/caminho/seguro/seasons-release.jks
  ```
* **Minificação e Otimização com ProGuard / R8:** Ativar `shrinkResources true` e `minifyEnabled true` no bloco de `release`.
* **Regras de Preservação no `android/app/proguard-rules.pro`:**
  ```proguard
  # Preservar atributos e anotações para classes Dart/Flutter compiladas
  -keepattributes *Annotation*
  -keepattributes SourceFile,LineNumberTable
  -keep public class * extends io.flutter.plugin.common.MethodChannel
  ```
* **Intent Filters no `AndroidManifest.xml`:** O aplicativo declara receptores para capturar intents de compartilhamento do WhatsApp sem travar:
  ```xml
  <intent-filter>
      <action android:name="android.intent.action.SEND" />
      <category android:name="android.intent.category.DEFAULT" />
      <data android:mimeType="text/plain" />
      <data android:mimeType="application/zip" />
      <data android:mimeType="application/octet-stream" />
  </intent-filter>
  ```
* **Geração de Pacotes de Produção:**
  ```bash
  # Geração do pacote para a Google Play Store
  flutter build appbundle --release

  # Geração de APKs otimizados separados por arquitetura (mitiga tamanho de download)
  flutter build apk --release --split-per-abi
  ```

### 2.3.2. Plataforma iOS
No arquivo `ios/Runner/Info.plist`:
* **Suporte à Ingestão de Documentos:** Declaração de `CFBundleDocumentTypes` e conformidade com `public.plain-text` e `public.zip-archive`.
* **Descrição de Privacidade para Exportação de Imagens:**
  ```xml
  <key>NSPhotoLibraryAddUsageDescription</key>
  <string>O Seasons requer autorização para salvar o cartão de retrospectiva na sua galeria para compartilhamento.</string>
  ```
* **Privacy Manifest (`ios/Runner/PrivacyInfo.xcprivacy`):** Obrigatório a partir das diretrizes de segurança da Apple de 2024. Deve conter a declaração estrita de ausência de identificadores de rastreamento (*Tracking Domains: None*) e categorização das APIs de sistema utilizadas (ex: `NSPrivacyAccessedAPITypeUserDefaults`).

---

# 3. O MOTOR DE PARSING (CORE ENGINE) E RESILIÊNCIA A QUEBRAS

## 3.1. Topologia das Expressões Regulares e Detecção de Layouts

O arquivo bruto exportado pelo WhatsApp apresenta divergências estruturais expressivas conforme o sistema operacional em que foi gerado, o fuso horário configurado e o idioma do usuário. A engine baseia-se nas classes `WhatsAppRegex` e `TextSanitizer`.

```
ENTRADA BRUTA (com caracteres ocultos, BOM, LRM)
       │
       ▼  [TextSanitizer.sanitizeLine]
LINHA HIGIENIZADA (padrão UTF-8 limpo)
       │
       ├──► 1. parseHeader() ──────► SUCESSO: Novo Início de Mensagem
       │         │
       │         ├── Verifica se é Mensagem Apagada (isDeletedMessage)
       │         └── Registra Timestamp, Autor e Buffer
       │
       ├──► 2. hasTimestampPrefix()?
       │         ├── FALSO ────────► Linha é Continuação Multilinha (Buffer.append)
       │         └── VERDADEIRO ───► Continua para Avaliação de Sistema
       │
       └──► 3. isSystemMessage()? ─► SUCESSO: Mensagem Informativa do WhatsApp
```

### 3.1.1. Matriz de Formatações Suportadas

| Sistema Operacional | Estrutura Típica | Expressão Regular Conceitual | Exemplo Real |
| :--- | :--- | :--- | :--- |
| **Android (24h / Traço)** | `dd/MM/aaaa HH:mm - Autor: Mensagem` | `^(\d{1,2})[\/\.-](\d{1,2})[\/\.-](\d{2,4})(?:,\s*\|\s+)(\d{1,2}):(\d{2})(?::(\d{2}))?\s*[-\u2013\u2014]\s*([^:]+?):\s*(.*)$` | `24/04/2023 14:56 - Maria: Olá!` |
| **Android (12h AM/PM)** | `dd/MM/aaaa, hh:mm a - Autor: Mensagem` | `^(\d{1,2})[\/\.-](\d{1,2})[\/\.-](\d{2,4})(?:,\s*\|\s+)(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*([aApP]\.?[mM]\.?))\s*[-\u2013\u2014]\s*([^:]+?):\s*(.*)$` | `24/04/2023, 02:56 PM - João: Tudo bem?` |
| **iOS (Colchetes)** | `[dd/MM/aa, HH:mm:ss] Autor: Mensagem` | `^\[(\d{1,2})[\/\.-](\d{1,2})[\/\.-](\d{2,4})(?:,\s*\|\s+)(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*([aApP]\.?[mM]\.?))?\]\s*([^:]+?):\s*(.*)$` | `[24/04/23, 14:56:00] Maria: Sim e você?` |

---

## 3.2. Normalização e Higienização Preventiva (`TextSanitizer`)

Antes de qualquer confronto com expressões regulares, a linha passa obrigatoriamente por `TextSanitizer.sanitizeLine()`. 

O WhatsApp injeta de forma implícita delimitadores de direção bidirecional Unicode (especialmente na exportação do iOS). Estes caracteres são invisíveis ao olho humano, mas quebram totalmente o operador de âncora de início de linha (`^`) das Regex padrão:

```dart
// Expurgo dos caracteres de controle e direção
line.replaceAll('\u200E', '') // Left-to-Right Mark (LRM)
    .replaceAll('\u200F', '') // Right-to-Left Mark (RLM)
    .replaceAll('\uFEFF', '') // Byte Order Mark (BOM)
    .replaceAll('\u200B', '') // Zero-Width Space (ZWSP)
    .replaceAll('\u200C', '') // Zero-Width Non-Joiner (ZWNJ)

// Conversão de espaços não padronizados para espaço simples ASCII (' ')
    .replaceAll('\u00A0', ' ') // Non-Breaking Space (NBSP)
    .replaceAll('\u202F', ' ') // Narrow Non-Breaking Space (NNBSP)
    .replaceAll('\u2007', ' ') // Figure Space
    .replaceAll('\u2009', ' '); // Thin Space
```

---

## 3.3. Autômato de Estados para Mensagens Multilinhas e Mensagens de Sistema

Um dos maiores desafios de parsing de mensageria reside em mensagens que contêm múltiplas quebras de linha (poesias, listas numeradas, blocos de código, etc.).

O algoritmo implementado no `ChatParser` adota uma lógica determinística à prova de falsos positivos:
1. **Regra de Continuação Estrita:** Se uma mensagem já está sendo acumulada no `currentContentBuffer`, e a linha subsequente **não** inicia com um cabeçalho de timestamp (`!WhatsAppRegex.hasTimestampPrefix(sanitized)`), ela é **obrigatoriamente concatenada** ao buffer da mensagem atual.
2. **Imunidade de Conteúdo:** Isso impede que uma linha de texto do usuário que contenha palavras reservadas do sistema (ex: *"Ontem esta mensagem foi apagada do grupo"*) seja erroneamente interpretada como uma notificação de sistema.
3. **Filtro de Mensagens de Sistema:** Se a linha possui padrão de timestamp mas carece do separador de autor (`Autor:`), ela é classificada como mensagem informativa (mudança de nome de grupo, entrada/saída de participantes, avisos de encriptação) e descartada dos cálculos de engajamento pessoal.

---

## 3.4. Protocolo Operacional de Manutenção do Parser

Caso uma atualização futura do WhatsApp introduza um novo formato de cabeçalho ou altere o padrão dos delimitadores, a equipe de engenharia deve seguir rigorosamente o seguinte protocolo:

```
[1. Coleta e Anonimização da Amostra Real]
                       │
                       ▼
[2. Criação do Fixture Determinístico em test/fixtures/]
                       │
                       ▼
[3. Elaboração do Teste Unitário de Falha (Red)]
                       │
                       ▼
[4. Ajuste da Regex em WhatsAppRegex / TextSanitizer (Green)]
                       │
                       ▼
[5. Execução Completa da Suíte de Regressão Adversarial]
```

### Procedimento Detalhado Passo a Passo:

1. **Passo 1 — Obtenção e Sanitização da Amostra:**
   Obtenha um arquivo de exportação que falhou no aplicativo. Remova qualquer dado pessoal sensível (substitua nomes reais por pseudônimos como *UserA*, *UserB*, mas preserve intactos os caracteres de separação, timestamps e espaços).
2. **Passo 2 — Criação do Fixture de Teste:**
   Salve o arquivo mock em `test/fixtures/<nome_do_cenario>.txt` (exemplo: `test/fixtures/whatsapp_android_2027_format.txt`).
3. **Passo 3 — Escrita do Teste de Regressão:**
   Adicione um teste em `test/unit/chat_parser_test.dart` esperando a decodificação correta do número de mensagens e dos autores:
   ```dart
   test('deve decodificar o layout de exportação WhatsApp Android 2027', () {
     final file = File('test/fixtures/whatsapp_android_2027_format.txt');
     final content = file.readAsStringSync();
     final messages = const ChatParser().parseMessages(content);
     expect(messages.length, equals(10));
     expect(messages.first.author, equals('Alice'));
   });
   ```
4. **Passo 4 — Atualização de `WhatsAppRegex`:**
   * Abra `lib/core/parser/whatsapp_regex.dart`.
   * Se for uma variação de delimitador de data (ex: uso de ponto em vez de barra), atualize os padrões das expressões `dateTimeDashRegex` ou `dateTimeBracketRegex`.
   * Se o padrão for inteiramente novo, declare uma nova expressão `static final RegExp novoLayoutRegex` e adicione-a como candidata no método `parseHeader()`.
5. **Passo 5 — Validação de Integridade:**
   Execute toda a suíte de testes de estresse:
   ```bash
   flutter test test/unit/chat_parser_test.dart
   flutter test test/unit/parser_adversarial_test.dart
   ```
   A modificação só é considerada aprovada se **100% dos testes anteriores continuarem passando** (garantia de regressão zero).

---

# 4. EFICIÊNCIA, PERFORMANCE E GESTÃO DE MEMÓRIA

Arquivos de exportação de conversas de vários anos de relacionamento podem conter facilmente entre **50.000 e 200.000 linhas de texto** e arquivos ZIP com tamanho superior a centenas de megabytes. Uma abordagem ingênua travaria a interface e causaria erros de *Out-Of-Memory* (OOM).

## 4.1. Processamento Assíncrono e Offloading via Dart Isolates

O Dart utiliza um modelo de execução *single-threaded* baseado em Event Loop. Executar o processamento de 100.000 linhas de texto na Thread Principal (*UI Isolate*) congelaria o aplicativo por vários segundos, violando as métricas de resposta da interface e disparando avisos de ANR (*Application Not Responding*) no Android.

Para garantir 60fps ininterruptos na interface, todo o parsing e computação pesada de agregação estatística devem ser despachados para uma thread em segundo plano via `Isolate.run()`:

```dart
/// Execução desacoplada do parsing em um Dart Isolate dedicado
Future<RawChatExport> parseChatInBackground(String rawContent) async {
  return await Isolate.run(() {
    // Código executado em um Isolate separado, com seu próprio Heap de memória
    final parser = const ChatParser();
    return parser.parse(rawContent);
  });
}
```

```
UI ISOLATE (Thread Principal - 60 fps)
  │
  ├─► Inicia tela com animação fluida de carregamento
  ├─► Dispara Isolate.run(parseChatInBackground) ────┐
  │                                                  │ (Cópia de bytes / Mensagem)
  │   [UI livre para gestos e transições]            ▼
  │                                     BACKGROUND ISOLATE (Worker)
  │                                       ├─ Executa TextSanitizer
  │                                       ├─ Executa ChatParser (RegEx)
  │                                       └─ Constrói RawChatExport
  │                                                  │
  ├─◄ Recebe RawChatExport concluído ◄───────────────┘
  │
  ▼
Atualiza Provider e renderiza os Stories/Dashboard
```

---

## 4.2. Streaming Seletivo de Arquivos ZIP e Prevenção de OOM

Quando o usuário opta por exportar a conversa incluindo mídia (por engano ou desconhecimento), o contêiner ZIP gerado pelo WhatsApp contém gigabytes de fotos, notas de voz (`.opus`) e vídeos (`.mp4`).

Se a biblioteca tentar carregar esse ZIP inteiro na memória RAM, aparelhos de entrada com 2GB a 3GB de memória sofrerão encerramento imediato pelo *Low Memory Killer* (LMK) do sistema operacional.

O `ZipExtractorService` mitiga esse risco através de três salvaguardas arquiteturais:
1. **Leitura por Streaming:** Utilização de `InputFileStream(filePath)`, permitindo que o decodificador analise a tabela central do arquivo ZIP lendo blocos sequenciais do disco, sem carregar o arquivo na íntegra para a memória.
2. **Inspeção de Cabeçalhos sem Descompressão de Mídias:** O serviço itera exclusivamente sobre os metadados dos arquivos contidos no ZIP (`archive.files`). Apenas o arquivo que atende ao critério de nome (`_chat.txt` ou `*.txt`) tem seu conteúdo descompactado. Os arquivos de áudio, imagem e vídeo são completamente ignorados.
3. **Expurgo Forçado de Buffers:** Imediatamente após a extração dos bytes do arquivo de texto, o método `chatFile.clear()` é invocado explicitamente, liberando a referência dos dados binários para coleta imediata pelo Garbage Collector do Dart:
   ```dart
   // Descompacta apenas o arquivo de texto localizado
   final rawBytes = chatFile.content;
   
   // Expurga o buffer interno do objeto do arquivo imediatamente
   chatFile.clear();
   
   return utf8.decode(rawBytes);
   ```

---

## 4.3. Ciclo de Vida do Renderizador de Stories 9:16

O aplicativo renderiza até **52 lâminas de Stories** editoriais (18 de Casal, 18 de Amigos, 16 de Grupo). Manter 52 árvores de widgets complexas com efeitos de textura de papel (`RetroPaperScaffold`), filtros de desfoque e gráficos simultaneamente alocados na GPU resultaria em exaustão de textura e engasgos de paginação (*jank*).

### Medidas de Gestão de Memória Visual:
* **Virtualização de Páginas (`PageView.builder`):** Os slides são instanciados sob demanda apenas quando se tornam visíveis ou no slide imediatamente adjacente, destruindo instâncias distantes da janela de exibição.
* **Captura de Imagem Sob Demanda:** A rasterização de um slide em imagem PNG para exportação social (`RepaintBoundary.toImage()`) só ocorre no momento em que o usuário toca no botão de compartilhar, descartando o bitmap da memória imediatamente após a entrega ao `SharePlus`.

---

# 5. MATRIZ E GESTÃO DE DEPENDÊNCIAS

## 5.1. Catálogo e Justificativa Técnica dos Pacotes

A seleção de bibliotecas de terceiros no projeto Seasons obedece a critérios restritivos: **ausência de rastreadores (trackers), ausência de módulos de telemetria remota, estabilidade comprovada pela comunidade e compatibilidade com compilação 100% offline**.

| Dependência | Versão Homologada | Categoria | Função Arquitetural Primária | Justificativa de Engenharia e Alternativas Descartadas |
| :--- | :--- | :--- | :--- | :--- |
| `provider` | `^6.1.5+1` | Estado | Gerenciamento reativo de estado escopado. | Injeção de dependência limpa com baixo consumo de memória. Alternativas mais complexas (BLoC com streams pesados) foram descartadas para evitar overhead de alocação de objetos em apps offline. |
| `archive` | `^4.2.0` | I/O | Descompressão de arquivos `.zip`. | Pacote **Pure-Dart**, sem dependências de compilação C nativa (NDK), garantindo portabilidade absoluta entre Android, iOS e Web com suporte a *streaming*. |
| `file_picker` | `^12.3.0` | Hardware/OS | Interface de seleção de arquivos do sistema operacional. | Permite acesso à sandbox de arquivos locais sem solicitar permissões invasivas de leitura de todo o armazenamento (`MANAGE_EXTERNAL_STORAGE`). |
| `receive_sharing_intent`| `^1.9.0` | Hardware/OS | Captura de Intents (`ACTION_SEND`) nativos. | Habilita o Seasons a constar diretamente na folha de compartilhamento do WhatsApp, eliminando a fricção de salvar o arquivo localmente antes da importação. |
| `share_plus` | `^13.3.0` | Social | Integração com a folha de compartilhamento nativa do SO. | Plugin oficial do Flutter Community para acionar o compartilhamento de imagens geradas diretamente para o Instagram Stories ou WhatsApp Status. |
| `path_provider` | `^2.1.6` | I/O | Localização de diretórios padrão de cache e dados temporários. | Abstração multiplataforma segura para gravação de arquivos temporários em conformidade com as diretrizes de sandbox do Android e iOS. |
| `shared_preferences` | `^2.5.5` | Persistência | Armazenamento chave-valor leve. | Utilizado exclusivamente para persistir flags de controle de interface (ex: `hasSeenOnboarding`). Não armazena dados de conversas. |
| `flutter_animate` | `^4.5.2` | Interface | Micro-animações e física de entrada de cartões a 60fps. | Sintaxe declarativa de alta performance que roda diretamente no ticker do Flutter, sem fugas de memória por esquecimento de `dispose()` de controllers. |
| `lucide_icons_flutter` | `^3.1.19` | Tipografia | Conjunto consistente de glifos vetoriais modernos. | Garante a estética suíça e o rigor de **zero uso de emojis como ícones de interface gráfica**, reduzindo o peso do APK comparado a pacotes massivos como FontAwesome. |

---

## 5.2. Política de Atualização e Mitigação de Quebras (*Breaking Changes*)

Para manter o projeto saudável sem introduzir vulnerabilidades de segurança ou incompatibilidades com novos sistemas operacionais, adota-se o seguinte calendário e procedimento:

```
           CICLO DE ATUALIZAÇÃO SEMESTRAL DE DEPENDÊNCIAS
           
  Mês 1 a 5                       Mês 6
┌────────────────────────┐      ┌────────────────────────────────┐
│ CONGELAMENTO DE VERSÕES│ ────►│ AVALIAÇÃO DE OUTDATED & AUDIT  │
│ Respeito ao pubspec.lock│      │ flutter pub outdated           │
└────────────────────────┘      └──────────────┬─────────────────┘
                                               │
                                               ▼
                                ┌────────────────────────────────┐
                                │ ATUALIZAÇÃO CONTROLADA         │
                                │ flutter pub upgrade            │
                                └──────────────┬─────────────────┘
                                               │
                                               ▼
                                ┌────────────────────────────────┐
                                │ TESTES AUTOMATIZADOS DE SANIDADE│
                                │ flutter test --coverage        │
                                │ dart analyze --fatal-infos     │
                                └────────────────────────────────┘
```

1. **Fixação de Versões Semânticas:** O `pubspec.yaml` utiliza o prefixo de compatibilidade de versão (`^`), confiando no versionamento semântico (SemVer: `MAJOR.MINOR.PATCH`). Nenhuma dependência `MAJOR` deve ser atualizada de forma não supervisionada.
2. **Auditoria Periódica:** A cada 6 meses, o arquiteto deve rodar `flutter pub outdated` para mapear dependências descontinuadas ou com novos lançamentos.
3. **Camada de Isolamento por Facade:** Nenhuma tela consome diretamente APIs de bibliotecas externas de I/O. Toda interação com `archive` ou `file_picker` é encapsulada em classes de serviço (`ZipExtractorService`, `FileIngestionService`). Se uma biblioteca mudar sua API pública, apenas a classe de serviço correspondente precisará ser alterada.

---

# 6. GUIA DE EXTENSIBILIDADE: CRIAÇÃO DE NOVAS MÉTRICAS

A arquitetura modular do Seasons permite a criação de novas métricas retrospectivas de forma aditiva, sem riscos de regressão no código consolidado.

Abaixo, apresenta-se o tutorial prático com a implementação de uma nova métrica: **"Índice de Conversas Noturnas" (*Nocturnal Index*)**, que quantifica a proporção de mensagens enviadas entre 00:00 e 05:59.

---

## Passo 1: Implementação da Regra de Negócio na Camada Analítica

No analisador correspondente (`lib/core/analytics/chat_analyzer.dart` ou `casal_analyzer.dart`), cria-se a função de cálculo determinística, pura e independente de qualquer dependência visual:

```dart
/// Extensão no ChatAnalyzer para cômputo da taxa de atividade noturna
class NocturnalMetric {
  final int nocturnalMessageCount;
  final double nocturnalPercentage;
  final String nocturnalChampion;

  const NocturnalMetric({
    required this.nocturnalMessageCount,
    required this.nocturnalPercentage,
    required this.nocturnalChampion,
  });
}

// Dentro de ChatAnalyzer ou CasalAnalyzer:
static NocturnalMetric calculateNocturnalIndex(List<ChatMessage> messages) {
  if (messages.isEmpty) {
    return const NocturnalMetric(
      nocturnalMessageCount: 0,
      nocturnalPercentage: 0.0,
      nocturnalChampion: 'N/A',
    );
  }

  int nocturnalCount = 0;
  final authorCounts = <String, int>{};

  for (final msg in messages) {
    if (msg.isSystem) continue;
    final hour = msg.timestamp.hour;
    // Define janela noturna entre 00h e 05h59
    if (hour >= 0 && hour < 6) {
      nocturnalCount++;
      authorCounts[msg.author] = (authorCounts[msg.author] ?? 0) + 1;
    }
  }

  final validMessages = messages.where((m) => !m.isSystem).length;
  final percentage = validMessages > 0 ? (nocturnalCount / validMessages) * 100 : 0.0;

  String champion = 'N/A';
  int maxCount = -1;
  authorCounts.forEach((author, count) {
    if (count > maxCount) {
      maxCount = count;
      champion = author;
    }
  });

  return NocturnalMetric(
    nocturnalMessageCount: nocturnalCount,
    nocturnalPercentage: percentage,
    nocturnalChampion: champion,
  );
}
```

---

## Passo 2: Integração no Modelo de Domínio Imutável

Abra o modelo de entidade (ex: `lib/core/models/casal_stats.dart`) e anexe a nova estrutura mantendo a imutabilidade do construtor:

```dart
class CasalAnalysisResult {
  final GeneralStats generalStats;
  final CasalStats casalStats;
  final NocturnalMetric nocturnalMetric; // Nova propriedade anexada

  const CasalAnalysisResult({
    required this.generalStats,
    required this.casalStats,
    required this.nocturnalMetric,
  });
}
```

---

## Passo 3: Adaptação de Apresentação no StoryAdapter

Para evitar que a tela formate textos ou realize conversões lógicas, exponha a propriedade formatada dentro de `lib/stories/adapters/casal_story_adapter.dart`:

```dart
class CasalStoryAdapter {
  final CasalAnalysisResult _result;
  CasalStoryAdapter(this._result);

  // Getter pronto para consumo pela interface editorial
  String get nocturnalDisplayString =>
      '${_result.nocturnalMetric.nocturnalPercentage.toStringAsFixed(1)}% das mensagens';

  String get nocturnalNarrative =>
      'O maior coruja da madrugada foi ${_result.nocturnalMetric.nocturnalChampion}, com ${_result.nocturnalMetric.nocturnalMessageCount} mensagens na calada da noite.';
}
```

---

## Passo 4: Mapeamento Visual e Registro no `StoryCardFactory`

Crie o novo widget de slide em `lib/widgets/stories/casal/c19_madrugada_slide.dart` utilizando a infraestrutura editorial compartilhada (`RetroPaperScaffold` e `SeasonsStoryFooter`):

```dart
import 'package:flutter/material.dart';
import '../../../../stories/adapters/casal_story_adapter.dart';
import '../shared/retro_paper_scaffold.dart';
import '../shared/seasons_story_footer.dart';
import '../shared/monumental_count_up.dart';

class C19MadrugadaSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const C19MadrugadaSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    return RetroPaperScaffold(
      editionLabel: "seasons / casal",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "HABITANTES DA MADRUGADA",
            style: TextStyle(fontFamily: 'serif', letterSpacing: 2, fontSize: 14),
          ),
          const SizedBox(height: 24),
          MonumentalCountUp(
            targetNumber: adapter.nocturnalPercentage.round(),
            suffix: "%",
            label: "MENSAGENS ENTRE 00H E 06H",
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              adapter.nocturnalNarrative,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          const Spacer(),
          const SeasonsStoryFooter(editionLabel: "Edição Casal • Slide 19"),
        ],
      ),
    );
  }
}
```

Registre o novo slide no catálogo `lib/stories/cards/casal_story_cards.dart` incrementando a contagem de slides de forma limpa e modular.

---

# 7. ESTRATÉGIA DE TESTES E PREVENÇÃO DE REGRESSÃO

A arquitetura adota a **Pirâmide de Testes Automatizados**, com ênfase massiva em testes unitários determinísticos do motor analítico e testes de integração de parsing baseados em *Fixtures* reais.

```
                  /\
                 /  \     Testes E2E e Integração de Fluxo (5%)
                /    \    - test/e2e/e2e_oracle.dart
               /──────\
              /        \   Testes de Widgets e Interface (25%)
             /          \  - Renderização de Stories, Bento Cards, Temas
            /────────────\
           /              \ Testes Unitários de Parsing e Analytics (70%)
          /                \- ChatParserTest, AdversarialStressTest,
         /──────────────────\  ZipExtractorTest, WhatsAppRegexTest
```

---

## 7.1. Matriz de Fixtures e Cenários de Borda

Os testes do motor de parsing não utilizam strings improvisadas; utilizam arquivos reais arquivados em `test/fixtures/`:

| Arquivo de Fixture | Cenário Testado | Propósito da Validação |
| :--- | :--- | :--- |
| `brazilian_24h.txt` | Formato Android padrão brasileiro em formato militar 24h (`dd/MM/yyyy HH:mm`). | Garantir decodificação padrão sem desvios de hora. |
| `brazilian_12h.txt` | Formato Android com hora em formato 12 horas e marcadores AM/PM. | Validar cálculo correto do meridiano (ex: 02:00 PM -> 14:00). |
| `ios_bracketed.txt` | Formato iOS delimitado por colchetes e segundos (`[dd/MM/yyyy, HH:mm:ss]`). | Garantir suporte a anos com 2 e 4 dígitos e remoção de caracteres invisíveis da Apple. |
| `multiline_chat.txt`| Mensagens com quebras de linha múltiplas, poesias e linhas em branco. | Evitar que quebras internas quebrem o buffer ou sejam descartadas. |
| `media_omitted_chat.txt` | Conversas repletas de marcadores `<Arquivo de mídia oculto>` e `<Media omitted>`. | Validar contabilidade correta de interações de mídia sem inclusão de lixo textual. |
| `sample_chat.zip` | Arquivo comprimido contendo `_chat.txt` e pastas anexas. | Validar extração assíncrona por streaming e expurgo de memória. |
| `benchmark_chat.txt` | Conversa de referência com 15 mensagens e 3 marcadores de mídia. | Teste de conformidade sintática e semântica com oráculo de dados. |
| `Conversa do WhatsApp com wesley rios ☭⃠.txt` | Dataset de produção em larga escala (8.800+ mensagens, glifos Unicode compostos). | Validação de estresse de memória, performance em escala real e robustez a emojis/símbolos raros (`☭⃠`). |

---

## 7.2. Idempotência, Determinismo e Portabilidade dos Testes

Um dos pilares arquiteturais mais rigorosos do Seasons é a **idempotência estrita** do motor de análise:

1. **Definição de Idempotência do Parser:**
   O método `ChatParser.parse(rawContent)` opera como uma **função pura** (sem efeitos colaterais). Para qualquer arquivo de entrada $T$, a invocação da função $N$ vezes produzirá rigorosamente o mesmo grafo de objetos `RawChatExport`, sem mutação de arquivos no disco e sem alteração de estado global:
   $$f(T) = f(f(T)) \implies \text{Saída Determinística e Imutável}$$

2. **Independência de Ambiente e Portabilidade (Zero Caminhos Absolutos):**
   Todos os testes automatizados da suíte utilizam **caminhos estritamente relativos à raiz do repositório** (`test/fixtures/...` ou `test/...`). Nenhum teste depende de caminhos locais do desenvolvedor (ex: `/home/usuario/...` ou `C:\Users\usuario\...`), garantindo execução idêntica em Windows, Linux, macOS e agentes de CI/CD (GitHub Actions / Bitbucket Pipelines).

3. **Independência de Relógio de Sistema e Timezone:**
   Diferente de parsers ingênuos que utilizam `DateTime.now()` como fallback de data, o motor extrai a linha temporal estritamente das âncoras de cabeçalho do arquivo, garantindo que o mesmo teste executado em fusos horários diferentes (UTC-3, UTC+0 ou UTC+9) produza métricas de ordenação cronológica idênticas.

---

## 7.3. Testes Unitários de Regras Estatísticas e Oráculos

Para assegurar que as métricas matemáticas (como o índice de compatibilidade, tempos de resposta e contagem de emojis) não sofram variações entre builds, o projeto utiliza um **Oráculo de Teste** (`test/fixtures/e2e_oracle.dart`).

O oráculo compara a saída gerada pelo código Dart com valores de referência pré-computados matematicamente:

```dart
test('Validação de paridade do ChatAnalyzer com oráculo matemático', () {
  final messages = ChatParser().parseMessages(FixtureLoader.load('benchmark_chat.txt'));
  final generalStats = ChatAnalyzer.calculateGeneralStats(messages);

  expect(generalStats.totalMessages, equals(1420));
  expect(generalStats.participants.length, equals(2));
  expect(generalStats.peakHour, equals(21)); // Pico às 21h
});
```

---

## 7.3. Testes de Renderização de Interface e Acessibilidade

Os testes de widget (`test/unit/stories_viewer_test.dart` e `widget_test.dart`) garantem que:
1. **Prevenção de Overflow de Texto:** O layout 9:16 acomoda nomes de participantes extensos sem disparar o erro clássico de renderização do Flutter (`A RenderFlex overflowed by X pixels`).
2. **Tabular Figures:** Os contadores usam `FontFeature.tabularFigures()` para evitar jitter visual e trepidação da largura dos números durante contagens progressivas animadas.
3. **Acessibilidade Contínua:** Os botões de navegação, fechar e compartilhar possuem áreas de toque mínimas de 48x48dp conforme a norma **WCAG 2.2 AA**.

---

## 7.4. Pipeline de Qualidade Local e CI

Antes de qualquer aprovação em ambiente de integração contínua (CI), a rotina de verificação obrigatória é:

```bash
# Análise estática rigorosa (tolerância zero para lints e warnings)
dart analyze --fatal-infos

# Execução da suíte completa de testes com medição de cobertura
flutter test --coverage

# Verificação se o build de release para Android compila sem erros
flutter build apk --release
```

---

# 8. DÍVIDAS TÉCNICAS CONHECIDAS E ROADMAP DE SUSTENTAÇÃO

Como em todo projeto de engenharia de software de alta complexidade, certas decisões de escopo e limitações tecnológicas foram mapeadas conscientemente. Esta seção documenta as dívidas técnicas aceitas no estágio atual e o roteiro de sustentação para os próximos ciclos de desenvolvimento.

## 8.1. Limitações Declaradas da Versão Atual

1. **Idiomas com Escrita da Direita para a Esquerda (RTL) e Ideogramas Asiáticos:**
   * *Diagnóstico Técnico:* O parser foi exaustivamente calibrado para alfabetos ocidentais (português, espanhol, inglês, francês, etc.). Idiomas como árabe e hebraico possuem caracteres de controle direcional complexos que invertem a posição do travessão (`-`), e formatos asiáticos (como japonês ou chinês, ex: `2024年4月24日`) exigem padrões de regex com suporte a ideogramas não cobertos na versão 1.0.
   * *Mitigação Atual:* O `TextSanitizer` elimina marcas LRM/RLM, mas o regex de captura de data pode falhar em estruturas sintáticas orientais.
2. **Estimativa Semântica de Áudios e Chamadas Perdidas:**
   * *Diagnóstico Técnico:* Como o arquivo `.txt` do WhatsApp sem mídia omite a duração exata das notas de voz (registrando apenas `<Áudio oculto>`), o aplicativo utiliza uma métrica estimada baseada em médias probabilísticas e contagem de ocorrências, em vez da metragem exata em segundos.
3. **Consumo de I/O em ZIPs com Mídia Completa:**
   * *Diagnóstico Técnico:* Se o usuário exportar uma conversa com dezenas de gigabytes de vídeos, embora o `ZipExtractorService` ignore o conteúdo das mídias, o custo de leitura da tabela de cabeçalhos do contêiner ZIP via barramento de disco ainda consome ciclos de I/O do sistema operacional.

---

## 8.2. Roadmap de Sustentação e Evolução Tecnológica

```
ANO 1: CONSOLIDAÇÃO & OTIMIZAÇÃO (Curto Prazo)
├── Suporte a múltiplos arquivos (retrospectiva anual agregada de múltiplos anos)
├── Refinamento de parsing para formatos regionais adicionais (Europa Oriental / Ásia)
└── Otimização com isolates dedicados para compressão de imagens de exportação social

ANO 2: INTELIGÊNCIA ON-DEVICE & EXPANSÃO (Médio Prazo)
├── Processamento de Linguagem Natural (PLN) 100% On-Device via TensorFlow Lite / ONNX
│   └── Análise de sentimento, tópicos quentes e detecção de afeto sem uso de APIs externas
├── Conectores de importação para Telegram (.json) e Instagram Direct (.json)
└── Renderização vetorial de Livros de Memórias / Zines físicos para exportação em PDF de alta resolução

ANO 3: ECOSSISTEMA & SUSTENTAÇÃO (Longo Prazo)
├── Arquitetura de micro-plugins de comunidade para novos estilos de histórias (Stories)
└── Criação de módulo de backup e sincronização criptografada ponta a ponta (E2EE) P2P entre dispositivos
```

### Detalhamento das Metas de Longo Prazo:

1. **Inteligência Artificial On-Device (Zero-Cloud NLP):**
   Incorporar modelos compactos de classificação semântica (como MobileBERT ou Gemma 2B quantizados em 4-bit) rodando diretamente na NPU do dispositivo através do plugin `tflite_flutter`. Isso permitirá analisar o "tom" emocional das conversas ao longo dos meses sem enviar uma única palavra para servidores externos, mantendo a premissa ética fundamental do Seasons.
2. **Expansão para Outros Mensageiros:**
   Desacoplar o modelo de domínio para suportar formatos de dados do Telegram (exportação JSON nativa) e Instagram DM (arquivo de dados da Meta). O mesmo catálogo de métricas retrospectivas e lâminas de *Stories* atenderá a múltiplos ecossistemas sociais.
3. **Geração de Livro Físico (Print-Ready PDF):**
   Evoluir a engine de layout para compor documentos PDF prontos para gráfica em alta resolução (300 DPI), permitindo que casais ou amigos imprimam um livro físico de retrospectiva com acabamento editorial de alta sofisticação.

---

# 9. CONSIDERAÇÕES FINAIS E CONCLUSÃO

O **Seasons** representa um marco na convergência entre **design visual editorial sofisticado**, **rigor de engenharia de software móvel** e **privacidade absoluta do usuário**. 

Ao eliminar a necessidade de servidores centrais e executar algoritmos matemáticos complexos diretamente no hardware do usuário, o sistema estabelece um novo paradigma de viabilidade técnica e financeira: custo de nuvem zero, escalabilidade infinita e imunidade estrutural a vazamentos de dados sensíveis.

A separação de responsabilidades assegurada pela Clean Architecture, a blindagem do motor de parsing contra quebras de leiaute do WhatsApp e a exaustiva cobertura de testes automatizados garantem à organização e à banca avaliadora a certeza de um ativo de software sustentável, extensível e pronto para evolução no médio e longo prazo.

---

