# seasons — Retrospectiva Editorial de Conversas do WhatsApp

Aplicativo móvel **multiplataforma (Flutter + Dart)** de engenharia avançada que decodifica arquivos de exportação do WhatsApp (`.txt` e `.zip`) e os transforma em uma experiência retrospectiva imersiva (estilo *Spotify Wrapped*), composta por dashboards analíticos e narrativas visuais em **Stories 9:16 compartilháveis**.

O sistema é construído sob o paradigma fundamental **Local-First / On-Device Processing**: 100% das análises são executadas na CPU/GPU do próprio dispositivo do usuário, sem qualquer dependência de servidores, APIs externas, bancos de dados em nuvem ou modelos de assinatura/paywall.

---

## Destaques Arquiteturais & Engenharia

- **100% Offline & Privacidade por Desenho (Privacy by Design):** Zero chamadas de rede durante a importação, descompressão, parsing e renderização. Conformidade estrutural com LGPD (Lei 13.709/2018) e GDPR.
- **Motor de Parsing Resiliente & Multiformato:** Autômato de estados com suporte a formatos Android (24h e 12h AM/PM com traço/hífen), iOS (delimitado por colchetes), mensagens multilinhas complexas, sanitização de caracteres invisíveis Unicode (LRM, BOM, ZWSP) e filtros de notificações de sistema.
- **Streaming Seletivo de ZIP:** Descompressão em streaming via pure-Dart `archive` com expurgo forçado de memória (`chatFile.clear()`), ignorando arquivos de mídia para prevenir falhas de Out-Of-Memory (OOM).
- **Três Lentes Analíticas Dedicadas:**
  - **Casal (2 participantes):** Métricas de *love language*, índice de compatibilidade, ritmo diário e o "Passaporte do Casal" (18 slides c1..c18).
  - **Amigos / Squad (3 a 5 participantes):** Arquétipos individuais, medidor de caos, recordes de *flood*, ranking do vácuo e pôster do squad (18 slides a1..a18).
  - **Grupo (6+ participantes):** Pódio monumental 3D, distribuição de Pareto 80/20, matriz de interação social e certificado da comunidade (16 slides g1..g16).
- **Design Suíço Editorial:** Identidade visual baseada em papel texturizado Warm Ivory (`#FBF9F5`), tipografia serifada com numerais tabulares anti-jitter (`FontFeature.tabularFigures()`), animações físicas fluidas a 60fps e ausência de emojis como ícones de interface (uso restrito a ícones vetoriais Lucide).

---

## Telas Principais

1. **Onboarding Editorial (4 Páginas):** Apresentação do produto, prévia dos 3 modos de análise, guia visual de exportação do WhatsApp em 4 passos e compromisso de privacidade local.
2. **Home & Ingestão com Dock Flutuante:** Estado vazio (*empty state*), barra de progresso por estágios de descompressão/parsing, tratamento de erros com recuperação e barra de navegação flutuante *frosted-glass* com desfoque nativo.
3. **Seleção de Modos:** Grade Bento interativa com cards temáticos (Casal em Rose `#E11D48`, Amigos em Sky `#2563EB` e Grupo em Violet `#7C3AED`) e selo inteligente de "Recomendado".
4. **Dashboard de Estatísticas:** Totais gerais com contagem animada (*count-up*), timeline histórica mensal, matriz de intensidade horária (*Heatmap 24h*) e rankings de engajamento.
5. **Stories Viewer 9:16 (52 Slides Exclusivos):** Navegação por toques laterais, pausa tátil contínua (*hold-to-pause*), fechamento por gesto vertical (*swipe down*) e exportação sob demanda para WhatsApp Status e Instagram Stories via `share_plus`.
6. **Configurações & Sobre:** Opção de rever o tutorial de onboarding e manifesto de garantia local.

---

## Estrutura do Repositório

```
Seasons/
├── lib/
│   ├── core/
│   │   ├── analytics/        # Motores de análise (ChatAnalyzer, Casal, Amigos, Grupo)
│   │   ├── models/           # Entidades imutáveis e value objects (ChatMessage, RawChatExport)
│   │   ├── parser/           # Engine de parsing (ChatParser, WhatsAppRegex, TextSanitizer)
│   │   └── services/         # Ingestão de arquivos, streaming ZIP e Share Intent
│   ├── screens/              # Telas (Onboarding, Home, ModeSelection, Dashboard)
│   ├── stories/              # Adapters de apresentação, fábrica de cards e viewer 9:16
│   ├── widgets/              # Componentes de UI, dock flutuante e slides editoriais (c1..c18, a1..a18, g1..g16)
│   ├── theme/                # Sistema de design suíço minimalista (SwissTheme)
│   └── main.dart             # Inicialização de preferências, navegação e Share Intent
├── test/
│   ├── fixtures/             # Mocks determinísticos (.txt, .zip, benchmark_chat.txt)
│   ├── unit/                 # Suíte unitária e testes adversariais (100% determinísticos)
│   └── e2e/                  # Oráculos matemáticos de integração
└── docs/
    ├── arquitetura/
    │   └── manual_arquitetura_operacao_manutencao.md # Manual formal para banca avaliadora
    ├── jornada-do-usuario.md # Jornada detalhada da persona, heurísticas e fluxos
    ├── resumo-projeto.md     # Síntese acadêmica com critérios de avaliação
    ├── PROJECT.md            # Arquitetura de transição e inventário de features
    └── ORIGINAL_REQUEST.md   # Especificação e critérios de aceitação originais
```

---

## Instalação e Execução

### Pré-requisitos
- **Flutter SDK:** `>= 3.19.0` (Dart SDK `>= 3.13.3`)
- **Android:** Android Studio com SDK 34 / Java 17 OpenJDK
- **iOS (macOS):** Xcode 15+ com CocoaPods instalado
- *Nota para Windows:* Requer **Modo de Desenvolvedor** ativado nas Configurações do Windows para suporte a links simbólicos de plugins nativos (`start ms-settings:developers`).

### Comandos de Inicialização

```bash
# 1. Clonar o repositório
git clone https://github.com/RiosWesley/Seasons.git
cd Seasons

# 2. Obter as dependências
flutter pub get

# 3. Executar o aplicativo em modo de desenvolvimento
flutter run
```

---

## Testes Automatizados & Qualidade de Código

A aplicação conta com suítes de testes determinísticos e **idempotentes**, empregando caminhos relativos portáteis sem dependências de ambientes locais:

```bash
# Análise estática rigorosa (zero warnings e zero erros)
dart analyze --fatal-infos

# Execução da suíte completa de testes unitários e de parsing
flutter test

# Execução direcionada do motor de parsing
flutter test test/unit/chat_parser_test.dart

# Compilação de produção para Android
flutter build apk --release
```

---

## Mapa da Documentação Técnica

Para uma compreensão aprofundada da arquitetura e das diretrizes de engenharia do projeto, consulte os documentos disponíveis no diretório `docs/`:

1. **[Manual de Arquitetura, Operação e Manutenção](docs/arquitetura/manual_arquitetura_operacao_manutencao.md):**  
   Documento formal completo cobrindo:
   - Padrão arquitetural (Clean Architecture + Hexagonal Ports & Adapters) e justificativa ética/técnica *Local-First*.
   - Matriz de compatibilidade de SDKs e guia de onboarding.
   - Detalhamento do motor de parsing, matriz de Regex e **Protocolo de Manutenção do Parser** caso o WhatsApp altere o layout.
   - Gestão de memória, mitigação de OOM e offloading de CPU com Dart Isolates.
   - Matriz de dependências e política de atualização de pacotes.
   - Guia de extensibilidade para criação de novas métricas sem regressão.
   - Estratégia de testes automatizados, oráculos determinísticos e garantia de idempotência.
   - Dívidas técnicas mapeadas e roadmap de evolução tecnológica de longo prazo.

2. **[Jornada do Usuário](docs/jornada-do-usuario.md):**  
   Mapeamento integral da experiência do usuário, fluxos de contingência, conformidade com as 10 Heurísticas de Nielsen e diretrizes de acessibilidade WCAG 2.2 AA.

3. **[Resumo do Projeto](docs/resumo-projeto.md):**  
   Síntese do modelo de negócio, problema, proposta de valor e decisões fundamentais de engenharia de software.
