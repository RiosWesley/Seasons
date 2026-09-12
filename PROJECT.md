# Project: Stories 9:16 Editorial Revamp (Seasons)

## Architecture
- **Art Direction**: Physical editorial aesthetic based on Warm Ivory (`#FBF9F5`), tactile creased paper texture (`assets/images/home_paper_texture.jpg`), serif typography (`fontFamily: 'serif'`), tabular figures (`FontFeature.tabularFigures()`), and custom seals/stamps/wax motifs.
- **Chrome & Branding**: Complete elimination of legacy `"CHAT WRAPPED"` and `"100% OFFLINE"` in favor of clean lowercase serif `"seasons"` branding with mode edition labels.
- **Modality Visual Themes**:
  - **Casal (Mémoire d'Amour)**: Rose/Coral palette (`#FFF1F2`, `#E11D48`, `#FB7185`), wax seals, epistolary cards, couple passport.
  - **Amigos (Squad Indie Zine)**: Sky/Electric Blue palette (`#EFF6FF`, `#2563EB`, `#38BDF8`), rubber stamps, trading cards, festival poster.
  - **Grupo (Gazeta da Comunidade)**: Imperial Violet/Cyber-Grape palette (`#FAF5FF`, `#7C3AED`, `#A855F7`), broadsheet layout, 3D podiums, community certificate.
- **Adapter Architecture**: Dedicated zero-breaking-change adapters (`CasalStoryAdapter`, `AmigosStoryAdapter`, `GrupoStoryAdapter`) to expose realistic, deterministic derivations for audio durations, print counts, memes, unsent drafts, and interaction matrix without mutating core model constructors.

## Code Layout
```
lib/
├── widgets/
│   └── stories/
│       ├── shared/
│       │   ├── retro_paper_scaffold.dart      # Warm Ivory paper base, creased texture, organic gradients
│       │   ├── seasons_story_footer.dart      # Minimal 'seasons' serif signature, slide indicator
│       │   ├── story_paper_background.dart    # Tactile paper texture canvas
│       │   ├── editorial_stamp.dart           # Rubber stamp / wax seal / postal graphics
│       │   ├── monumental_count_up.dart       # Giant serif/tabular count-up numeral
│       │   ├── story_gauge_meter.dart         # Semi-circular retro gauge for compatibility
│       │   └── story_share_action.dart        # Tactile export & native share button (preserves Icons.share_rounded)
│       ├── casal/                             # c1..c18 slides (18 files)
│       ├── amigos/                            # a1..a18 slides (18 files)
│       └── grupo/                             # g1..g16 slides (16 files)
├── stories/
│   ├── adapters/                              # casal, amigos, grupo story adapters
│   ├── cards/
│   │   ├── story_card_base.dart               # Base container updated to Warm Ivory & seasons footer
│   │   ├── casal_story_cards.dart             # Facade routing c1..c18
│   │   ├── amigos_story_cards.dart            # Facade routing a1..a18
│   │   ├── grupo_story_cards.dart             # Facade routing g1..g16
│   │   └── story_card_factory.dart            # Factory dispatching by mode
│   ├── story_progress_bar.dart                # Calibrated progress bar
│   └── stories_viewer_screen.dart             # Fullscreen 9:16 viewer
```

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Shared Paper Engine | Warm Ivory canvas with creased paper texture & gradients | M1 | Survey |
| 2 | seasons Footer Branding | Minimal lowercase serif 'seasons' footer replacing legacy text | M1 | Survey |
| 3 | Calibrated Progress Bar | Mode-tinted active segments & refined timing | M1 | Survey |
| 4 | Reusable Editorial Stamps | Wax seal, rubber stamp, and imperial medal widgets | M1 | Survey |
| 5 | Tabular Metric Count-Up | Jitter-free CountUpText with FontFeature.tabularFigures() | M1 | Survey |
| 6 | Zero-Breaking Adapter Layer | Adapters for derived stats (audio min, prints, memes, unsent) | M1 | Survey |
| 7 | Casal c1: Capa | Book cover poster with couple names & wax seal | M2 | Survey |
| 8 | Casal c2: Total Mensagens | Monumental count-up, percentage balance, daily pace | M2 | Survey |
| 9 | Casal c3: Love Language | Asymmetric 2x2 cards with love language bars | M2 | Survey |
| 10 | Casal c4: Compatibilidade | Semi-circular affinity gauge & lyrical diagnosis | M2 | Survey |
| 11 | Casal c5: Timeline | Activity spline curve with golden peak marker | M2 | Survey |
| 12 | Casal c6: Top Palavras | Movable-type letterpress cloud with nicknames | M2 | Survey |
| 13 | Casal c7: Heatmap | "A Nossa Hora" 24h intensity matrix | M2 | Survey |
| 14 | Casal c8: Evolução Emojis | 3-pedestal triptych altar with beating heart emoji | M2 | Survey |
| 15 | Casal c9: Momentos Especiais | Scrapbook cards with washi tape & record days | M2 | Survey |
| 16 | Casal c10: Comparação Hábitos | Bipartite editorial balance on texting habits | M2 | Survey |
| 17 | Casal c11: Estatísticas Cotidiano | Dotted-rule tabular stats for reply speed & consistency | M2 | Survey |
| 18 | Casal c12: Insight Afeto | Editorial chronicle with illuminated quote marks | M2 | Survey |
| 19 | Casal c13: Interações Ocultas | Playful waiting-time note with worn red stamp | M2 | Survey |
| 20 | Casal c14: Áudios no Vácuo | Vinyl/cassette sleeve with audio duration minutes | M2 | Survey |
| 21 | Casal c15: Prints e Arquivos | Polaroid frame with silver washi tape | M2 | Survey |
| 22 | Casal c16: Encaminhamentos | Airmail envelope with chevron pattern for memes | M2 | Survey |
| 23 | Casal c17: Digitou mas não enviou | Censored draft note with pulsing ellipsis | M2 | Survey |
| 24 | Casal c18: Conclusão & Passaporte | Official Couple Passport collectible card with share trigger | M2 | Survey |
| 25 | Amigos a1: Capa do Squad | Indie zine cover with circular rubber stamp | M3 | Survey |
| 26 | Amigos a2: Total de Mensagens | Graph paper poster with member volume bars | M3 | Survey |
| 27 | Amigos a3: Estilos Comunicação | Trading cards for member archetypes | M3 | Survey |
| 28 | Amigos a4: Compatibilidade Squad | Chaos meter / radar on kraft paper | M3 | Survey |
| 29 | Amigos a5: Timeline | Seismograph activity curve with highlighter spikes | M3 | Survey |
| 30 | Amigos a6: Top Conversas | Bulletin board with pushpins & hot topics | M3 | Survey |
| 31 | Amigos a7: Heatmap do Squad | Subway-style 24h block clock | M3 | Survey |
| 32 | Amigos a8: Emoji Culture | Pop-art die-cut sticker album | M3 | Survey |
| 33 | Amigos a9: Flood Moments | Comic book monologue explosion graphic | M3 | Survey |
| 34 | Amigos a10: Personalidades | Honorary squad titles and condecorations | M3 | Survey |
| 35 | Amigos a11: Estatísticas Squad | Telemetry speedometer for response speeds | M3 | Survey |
| 36 | Amigos a12: Insight do Squad | Zine editorial manifesto with white correction tape | M3 | Survey |
| 37 | Amigos a13: Interações Ocultas | FBI Wanted Poster for vacuum champions | M3 | Survey |
| 38 | Amigos a14: Áudios no Vácuo | Podcast episode sleeve with vertical soundwaves | M3 | Survey |
| 39 | Amigos a15: Prints Tirados | Confidential detective dossier | M3 | Survey |
| 40 | Amigos a16: Encaminhamentos | Broadcast news tower with teletype | M3 | Survey |
| 41 | Amigos a17: Digitou mas não enviou | Warning isolation tape on near-crisis drafts | M3 | Survey |
| 42 | Amigos a18: Conclusão & Pôster | Festival tour poster with barcode & share trigger | M3 | Survey |
| 43 | Grupo g1: Capa da Gazeta | Broadsheet front page with imperial seal | M4 | Survey |
| 44 | Grupo g2: Total de Mensagens | Census plaque with literary book volume equivalence | M4 | Survey |
| 45 | Grupo g3: Top 3 do Grupo | Monumental 3D podium with medals and laurels | M4 | Survey |
| 46 | Grupo g4: Dinâmicas do Grupo | Pareto 80/20 distribution diagram | M4 | Survey |
| 47 | Grupo g5: Timeline Coletiva | Four-season annual calendar with 12 monthly columns | M4 | Survey |
| 48 | Grupo g6: Top Conversas | Legislative assembly docket with items | M4 | Survey |
| 49 | Grupo g7: Heatmap de Atividade | 24x7 temperature matrix with compass rose | M4 | Survey |
| 50 | Grupo g8: Evolução de Emojis | Stock exchange currency ticker panel | M4 | Survey |
| 51 | Grupo g9: Flood Moments | Extraordinary news alert edition | M4 | Survey |
| 52 | Grupo g10: Análise de Rede | Constellation star chart / interaction matrix graph | M4 | Survey |
| 53 | Grupo g11: Insight Coletivo | Sociological feature essay with illuminated drop-cap | M4 | Survey |
| 54 | Grupo g12: Quem Mais Ignora | Golden Vacuum Trophy on carved stone pedestal | M4 | Survey |
| 55 | Grupo g13: Quem Mais Tira Print | Investigative press badge with photographic filmstrip | M4 | Survey |
| 56 | Grupo g14: Quem Mais Encaminha | Telegraph central news relay station | M4 | Survey |
| 57 | Grupo g15: Quem Mais Apaga | Invisible chat ghost with fading smoke effect | M4 | Survey |
| 58 | Grupo g16: Conclusão & Certificado | Formal community certificate with guilloche borders & share trigger | M4 | Survey |
| 59 | E2E & Full Verification | 100% passing tests (flutter test) & 0 analyze issues | M5 | Survey |
| 60 | Release Build & ADB Deployment | flutter build apk --release & adb install without git commit | M5 | Survey |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Shared Editorial Infrastructure & Adapters | Paper engine, SeasonsStoryFooter, ProgressBar, Adapters, StoryCardBase test alignment | none | DONE |
| M2 | Casal Mode Stories (18 Slides) | c1..c18 bespoke slides, romantic editorial identity, couple passport | M1 | DONE |
| M3 | Amigos Mode Stories (18 Slides) | a1..a18 bespoke slides, squad zine identity, squad tour poster | M1 | DONE |
| M4 | Grupo Mode Stories (16 Slides) | g1..g16 bespoke slides, periodical identity, community certificate | M1 | DONE |
| M5 | Verification, Build & ADB Deploy | dart analyze (0/0), flutter test (100%), release APK, ADB install, 0 git commit | M1, M2, M3, M4 | DONE |

## Interface Contracts
### Story Adapters ↔ Story Cards
- `CasalStoryAdapter(CasalAnalysisResult result)`: provides formatted partners, daily pace, love languages, lyrical compatibility, top words, peak intimacy hour, top emojis, habits balance, audio duration estimate, prints estimate, memes estimate, drafts estimate.
- `AmigosStoryAdapter(AmigosAnalysisResult result)`: provides member list, volume balance, archetypes, chaos score, timeline spikes, top slang, peak hour, emoji dictionary, flood record, honorary titles, telemetry speeds, vacuum rankings, podcaster stats, detective prints, news forwarder, drafts estimate.
- `GrupoStoryAdapter(GrupoAnalysisResult result)`: provides active population, literary book volumes, top 3 podium members, Pareto ratio, 12-month calendar, assembly topics, 24x7 peak quadrant, collective emojis, chaotic flood peak, interaction network pairs, drop-cap essay, golden vacuum trophy, press archivist, telegraph relay, unsend ghost.

### Shared Widgets ↔ Slide Builders
- `RetroPaperScaffold(modeTheme, children)`: renders 4-layer paper background with Warm Ivory and hairline border.
- `SeasonsStoryFooter(editionLabel)`: renders lowercase serif `seasons` with edition tag.
- `MonumentalCountUp(targetNumber, label)`: jitter-free CountUpText with `FontFeature.tabularFigures()`.
- `StoryShareAction(onShare)`: interactive share button with `Icons.share_rounded` preserved.
