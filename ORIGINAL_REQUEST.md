# Original User Request

## 2026-09-11T16:18:46Z

Build a brand-new, production-grade Flutter Android app for WhatsApp Chat Wrapped from scratch, featuring a sober Swiss-minimalist aesthetic (adaptive light/dark), fluid 60fps micro-animations, comprehensive offline analytics (Casal, Amigos, Grupo), zero paywalls, zero emoji-as-icon slop, full ZIP/Share Intent ingestion, and automated ADB deployment to a physical device.

Working directory: /home/wesley/Documents/chat_wrapped_flutter
Reference project directory: /home/wesley/Documents/chat-wrapped-mobile
Integrity mode: development

Environment & Tooling:
- Flutter binary: /home/wesley/development/flutter/bin/flutter (or add /home/wesley/development/flutter/bin to PATH)
- Android SDK: /home/wesley/Android/Sdk
- Java JBR: /opt/android-studio/jbr (set JAVA_HOME=/opt/android-studio/jbr)
- ADB: /home/wesley/Android/Sdk/platform-tools/adb

## Requirements

### R1. WhatsApp Export Ingestion & Extraction Engine
Support seamless import of WhatsApp chats through two primary vectors:
1. Direct file picker for `.txt` or `.zip` files.
2. Android Send/Share Intent (receiving shared `.zip` or `.txt` directly from WhatsApp when the user selects "Export Chat").
When a `.zip` file is received, decompress it in temporary cache, locate the chat text file (`_chat.txt` or `*.txt`), and parse it with high-tolerance regex handling multiple WhatsApp timestamp conventions (Brazilian 24h `dd/MM/yyyy HH:mm - Author: message`, 12h `dd/MM/yyyy, hh:mm a - Author: message`, etc.), multi-line messages, system notification filtering, and `<Mídia oculta>` media markers.

### R2. Deterministic Local Analytics Engine (100% Offline)
Port and faithfully reproduce all analysis algorithms from the reference codebase (`utils/chatAnalyzer.ts` and `types/chat.ts`) without any remote network transmission:
- **Casal Mode (2 participants):** Love language breakdown (hearts, romantic lexicon, memes, direct messages), compatibility index score & custom description, hourly/daily activity heatmaps, chronological timeline, message balance, and response time metrics.
- **Amigos Mode (3-5 participants):** Communication personas/styles, fastest replier, ghosting/ignoring metrics (unanswered streaks, response delays), conversation initiator, biggest message flooder, and group dynamics.
- **Grupo Mode (6+ participants):** Member activity leaderboard, percentage contribution, interaction matrix (who replies to whom), silent members, late-night chatter ranking, topic keyword clusters, and emoji frequency breakdown.

### R3. Sober Swiss-Minimalist UI & Motion Architecture
Build an entirely new visual identity and UX adhering to the `appllama-app-design-skill` guidelines:
- **Visual Style:** Sober, architectural Swiss-minimal design. Monotone neutral surfaces (cool graphite / crisp off-white), a single disciplined accent token, strict continuous squircle corner radii (`borderCurve: continuous`), and clear typographic hierarchy using tabular numerals for counting and timestamps.
- **Iconography & Visual Assets:** Zero emoji-as-icon in UI chrome. Use dedicated vector iconography (Phosphor / Lucide / Material Symbols) and high-quality generated vector/illustration assets. Emojis appear exclusively when rendering raw user chat data or emoji frequency charts.
- **Micro-Animations & Physics:** Smooth 60fps physics springs on card entrances, staggered list reveals, interactive count-up number animations on stat reveals, tactile button press scaling (0.97 scale-down), and seamless screen transitions.
- **Full State Cycles:** Complete design for empty states, file decompression/parsing progress bars with stage feedback, error recovery dialogues, and result dashboards.

### R4. Immersive 9:16 Stories Experience & Social Export
- Interactive full-screen (9:16) Stories viewer inspired by Spotify Wrapped: segmented progress indicators with automatic timer advance, tap left/right to navigate cards, tap-and-hold to pause, and downward swipe to dismiss.
- High-fidelity visual story cards for each metric milestone with bespoke animations.
- Off-screen or widget capture to export crisp 9:16 images directly to Android storage and trigger the native Android share sheet (`share_plus`) for WhatsApp Status / Instagram Stories.

### R5. Complete Paywall Elimination & 100% Free Experience
All features, modes, premium insights, ignoring/ghosting stats, and story cards must be completely unlocked. Remove all billing references, subscription screens, Google Play In-App Purchase logic, and paywall gates.

### R6. Android SDK & Flutter Build Pipeline
The project must compile cleanly with modern Flutter and Android SDK (Java JBR in `/opt/android-studio/jbr`, SDK in `/home/wesley/Android/Sdk`). Ensure debug and release APKs build successfully (`flutter build apk`).

### R7. Physical Device ADB Installation Flow
Upon successful build verification, prompt the user to ensure their Android device is connected via USB with USB Debugging enabled, detect the device via `/home/wesley/Android/Sdk/platform-tools/adb devices`, install the APK via `adb install -r`, and launch the app.

---

## Acceptance Criteria

### Data Ingestion & Analytics Verification
- [ ] Automated Dart unit test validates parsing of sample export file (`Conversa do WhatsApp com João Arthur Britto.txt`).
- [ ] ZIP extraction correctly parses archived `.txt` and ignores unnecessary media without crashing or running out of memory.
- [ ] Analytical outputs (total messages, participant rankings, compatibility score, love language counts) match expected formulas from `chatAnalyzer.ts`.
- [ ] 0 network calls are initiated during import, parsing, or report viewing (100% offline privacy verified).

### UI & Motion Verification
- [ ] Audit confirms 0 emojis used as icons in buttons, headers, tabs, or badges.
- [ ] Color tokens conform to sober Swiss-minimalist palette in both Dark and Light modes.
- [ ] Micro-animations (counters, spring reveals, story progress bars) run smoothly without dropped frames.
- [ ] Stories viewer properly handles tap-forward, tap-back, hold-to-pause, and exit swipe gestures.
- [ ] Complete absence of paywall screens, lock icons, purchase triggers, or subscription banners.

### Build & Deployment Verification
- [ ] `flutter analyze` passes with zero errors.
- [ ] `flutter build apk` completes with exit code 0.
- [ ] ADB deployment command executes cleanly onto connected Android device.

## 2026-09-11T23:57:46Z

This is a focused UI and navigation implementation; keep it clean and focused.
Implement an editorial 4-page onboarding experience explaining app capabilities and WhatsApp export instructions, redesign the Mode Selection screen to match the warm editorial visual identity (Casal, Amigos, Grupo), and transform the bottom navigation bar into a modern frosted-glass floating navigation bar.

Working directory: /home/wesley/Documents/chat_wrapped_flutter
Integrity mode: development

## Requirements

### R1. Editorial 4-Page Onboarding Experience
Implement an interactive, fluid 4-page onboarding flow following the warm ivory aesthetic (`#FBF9F5`), serif editorial typography, continuous squircles, and Lucide iconography:
1. **Página 1 (Boas-Vindas & Apresentação):** Introdução marcante ao Chat Wrapped como o arquivo pessoal e retrospectiva de conversas, 100% offline e com privacidade inegociável.
2. **Página 2 (O que o App Faz & Modos):** Visão dos 3 modelos de análise calibrados (Casal com sintonia e love language, Amigos/Squad com arquétipos e vácuo, Grupo com rankings e dinâmica de rede) e os Stories 9:16 interativos.
3. **Página 3 (Como Exportar Conversa do WhatsApp):** Guia visual passo a passo simplificado ensinando como exportar do WhatsApp:
   - Passo 1: Abra a conversa desejada no WhatsApp.
   - Passo 2: Toque nos três pontinhos (⋮) > **Mais** > **Exportar conversa**.
   - Passo 3: Escolha obrigatoriamente **"Sem mídia"** para processamento instantâneo.
   - Passo 4: Salve ou compartilhe o arquivo gerado (`.txt` ou `.zip`) diretamente no Chat Wrapped.
4. **Página 4 (Privacidade & Início):** Selo de garantia local (zero servidores, zero tracking, dados nunca saem do celular) e CTA principal para começar ("Começar a Explorar" / "Importar Minha Conversa").
- Navegação fluida com PageView, indicador de passos em pílula suave, botão "Pular" e botão de avanço tátil.
- **Persistência de Primeiro Acesso:** Salvar a visualização no armazenamento local (`shared_preferences`) para não exibir novamente em aberturas subsequentes, e disponibilizar um botão/opção "Rever Onboarding" no menu/configurações.

### R2. Frosted-Glass Floating Bottom Navigation Bar
Transform the pinned bottom navigation bar into a floating dock with frosted glassmorphism:
- Margens flutuantes (`margin: EdgeInsets.fromLTRB(20, 0, 20, 16)`) e cantos arredondados contínuos (`SquircleBorder` / `BorderRadius.circular(26)`).
- Efeito **Glassmorphism**: `ClipRRect` com `BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12))`, fundo semitranslúcido (`Colors.white.withValues(alpha: 0.82)`), borda sutil (`Border.all(color: Colors.white.withValues(alpha: 0.6))`) e sombra difusa elegante (`BoxShadow(color: Color(0x1A0F172A), blurRadius: 20, offset: Offset(0, 8))`).
- Ícones Lucide (`house`, `trendingUp`, `layoutGrid`, `settings`), feedback tátil (`HapticFeedback.selectionClick()`), e pílula de seleção ativa suave com transição fluida.
- Compensação adequada de padding no final do scroll das páginas da Home para garantir que nenhum conteúdo fique oculto sob o dock flutuante.

### R3. Mode Selection Screen Redesign (Casal, Amigos, Grupo)
Redesign the `ModeSelectionScreen` to seamlessly continue the warm editorial identity and visual craft of the Home screen:
- Substituição dos cards minimalistas genéricos por cards bento expressivos com texturas sutis, tipografia serifada, cantos squircle contínuos e paletas dedicadas:
  - **Casal (2 participantes):** Acentos rose/coral (`#E11D48`), micro-badge de afinidade e ritmo a dois.
  - **Amigos (3-5 participantes):** Acentos sky/blue (`#2563EB`), micro-badge de arquétipos do squad e dinâmica de grupo.
  - **Grupo (6+ participantes):** Acentos violet/iris (`#7C3AED`), micro-badge de leaderboard geral e radar de vibes.
- Tag visual indicativa de **"Recomendado para esta conversa"** destacada automaticamente no modo correspondente ao número de participantes detectados.
- Seletor de modo interativo com indicador de rádio estilizado e botão primário tátil de continuação para o Dashboard.

### R4. Test Suite Integrity & Build Verification
- Manter 100% dos testes existentes (536 testes) passando sem quebras de regressão.
- Criar novos testes de unidade e widgets cobrindo:
  - Exibição, paginação e conclusão do Onboarding (4 páginas).
  - Persistência da flag de primeiro acesso (`hasSeenOnboarding`).
  - Renderização e interatividade da Floating Bottom Bar.
  - Seleção e confirmação de modo na nova `ModeSelectionScreen`.
- `dart analyze .` deve passar com 0 erros e 0 warnings.
- O build de release deve compilar com sucesso (`flutter build apk --release`).

---

## Acceptance Criteria

### Onboarding Experience
- [ ] O onboarding de 4 páginas é exibido apenas no primeiro acesso do app e redireciona para a Home ao concluir.
- [ ] O estado de conclusão é persistido localmente e não reaparece ao reabrir o app.
- [ ] É possível rever o onboarding a qualquer momento através das opções/configurações.
- [ ] O guia de exportação do WhatsApp (Página 3) detalha os passos com clareza visual.
- [ ] Gestos de deslizar, indicador de progresso e botões "Pular" / "Avançar" funcionam com suavidade e haptics.

### Floating Bottom Navigation Bar
- [ ] A barra inferior é flutuante com margens laterais e inferiores sobre o canvas.
- [ ] O efeito frosted-glass (BackdropFilter blur + semitransparência) é renderizado de forma fluida sem queda de FPS.
- [ ] O scroll das telas compensa a altura do dock para não sobrepor conteúdos no rodapé.
- [ ] A seleção de abas aciona feedback háptico e destaca a pílula ativa.

### Mode Selection Redesign
- [ ] Cada modo (Casal, Amigos, Grupo) apresenta layout bento dedicado com cores semânticas e tipografia refinada.
- [ ] O modo recomendado é destacado visualmente com base no número de participantes do arquivo importado.
- [ ] A confirmação do modo mantém o fluxo de transição íntegro para o `DashboardScreen`.

### Quality & Performance Verification
- [ ] `dart analyze .` retorna 0 erros e 0 avisos.
- [ ] 100% dos testes passam no `flutter test` (incluindo novos testes de onboarding e UI).
- [ ] `flutter build apk --release` finaliza com código 0 e gera o APK otimizado.

