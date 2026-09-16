# seasons — retrospectiva de conversas do WhatsApp

App móvel **multiplataforma (Flutter + Dart)** que transforma a exportação do WhatsApp (`.txt`/`.zip`) em uma retrospectiva estilo Spotify Wrapped: dashboards + Stories 9:16 compartilháveis. **100% offline, sem paywall, sem tracking.**

Pré-projeto acadêmico — entrega 17/09/2026. Detalhes da avaliação em `docs/resumo-projeto.md`.

## Como funciona

1. No WhatsApp: Conversa > ⋮ > Mais > **Exportar conversa > Sem mídia** → gera `.txt` ou `.zip`.
2. No seasons: importe pelo file-picker ou via **Compartilhar > seasons** direto do WhatsApp (Share Intent).
3. O app detecta o nº de participantes e recomenda o modo:
   - **Casal (2):** love language, compatibilidade, passaporte do casal — 18 stories
   - **Amigos (3–5):** arquétipos, caos, floods, pôster do squad — 18 stories
   - **Grupo (6+):** pódio, Pareto 80/20, matriz de interação, certificado — 16 stories
4. Navegue no viewer 9:16 (tap esq/dir, hold-pausa, swipe fecha) e compartilhe o card final no Status/Instagram.

## Telas

- Onboarding editorial 4 páginas (com guia de exportação + privacidade, persiste `hasSeenOnboarding`)
- Home + importação (empty / progresso por estágio / erro com recuperação) + bottom nav flutuante frosted-glass
- Seleção de modo (cards bento + selo "Recomendado")
- Dashboard (totais, rankings, timelines, heatmaps)
- Stories viewer 9:16 (52 slides únicos, rodapé `seasons`)
- Configurações (rever onboarding)

## Stack

- **Flutter 3.x + Dart 3.13** — decisão multiplataforma: um código → Android/iOS/Web/Desktop (ver `docs/resumo-projeto.md §4`)
- Deps: `file_picker, archive, path_provider, receive_sharing_intent, share_plus, provider, shared_preferences, flutter_animate, lucide_icons_flutter`
- Identidade: Warm Ivory `#FBF9F5`, serif editorial, squircle contínuo, 1 acento por modo (rose/sky/violet), ícones Lucide

## Estrutura

```
lib/
├── core/          # parser (regex BR 24h/12h, multiline, <Mídia oculta>), analytics, models, services
├── screens/       # onboarding, home, mode_selection, dashboard
├── stories/       # adapters (casal/amigos/grupo), cards (factory + c1-18/a1-18/g1-16), viewer, progress
├── widgets/stories/# shared (paper scaffold, footer, gauge, count-up, share) + casal/amigos/grupo
├── theme/         # SwissTheme light/dark
└── main.dart      # checa onboarding, registra ShareIntentService
test/              # unit + widget + e2e, fixtures (conversa real)
docs/resumo-projeto.md  # resumo cobrado na avaliação
PROJECT.md / ORIGINAL_REQUEST.md  # arquitetura, features M1-M5, requisitos R1-R7
```

## Como rodar

```bash
flutter pub get
flutter run
```

Receber arquivo do WhatsApp no emulador: compartilhe o `.txt`/`.zip` com o app (Share Intent) ou use o file-picker na Home.

## Testes e qualidade

```bash
dart analyze .          # 0 erros, 0 warnings
flutter test            # suíte unit + widget + e2e
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

## Privacidade

Zero chamadas de rede durante import/parse/visualização. ZIP extraído em cache temporário, dados nunca saem do celular.

## Docs

- `docs/resumo-projeto.md` — modelo de negócio, problema, proposta, telas, jornada, interface (heurísticas + WCAG), aplicação e documentação
- `PROJECT.md` — arquitetura e inventário de 60 features
- `ORIGINAL_REQUEST.md` — requisitos e critérios de aceitação
