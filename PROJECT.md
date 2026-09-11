# Project: WhatsApp Chat Wrapped Flutter Android App

## Architecture
- **Framework**: Flutter 3.47.3 / Dart 3.13.3
- **Design Philosophy**: Sober Swiss-Minimalist (adaptive dark/light, G2 continuous squircles, tabular figures, zero emoji in UI chrome, 60fps micro-animations).
- **Privacy Model**: 100% Offline, deterministic local processing, zero network permissions (`android.permission.INTERNET` omitted).
- **Core Modules**:
  1. `lib/core/models/`: Strongly-typed chat messages, participant stats, and mode-specific analytic models (`CasalStats`, `AmigosStats`, `GrupoStats`).
  2. `lib/core/parser/`: Resilient WhatsApp export regex parser (Brazilian 24h & 12h, Unicode zero-width stripping, multiline accumulation, system & media markers).
  3. `lib/core/services/`: ZIP decompression, file ingestion, Android Send/Share intent handling (`receive_sharing_intent`).
  4. `lib/core/analytics/`: Local deterministic analysis engines for Casal, Amigos, and Grupo.
  5. `lib/theme/`: Swiss-minimalist tokens (Dark/Light colors, emerald accent, continuous squircle shapes, typography with tabular numerals).
  6. `lib/widgets/`: Reusable Swiss components (Squircle cards, metric stat cards with count-up animations, buttons with 0.97 scale feedback, vector icons).
  7. `lib/screens/`: App shell, Home/Import screen with stage feedback, Mode Selector, Dashboard overview.
  8. `lib/stories/`: 9:16 Fullscreen Stories viewer (segmented progress, gesture navigation, hold-to-pause, swipe-down dismiss, story cards).
  9. `lib/export/`: Offscreen/RepaintBoundary 1080x1920 image generation and `share_plus` native Android share sheet trigger.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Chat File Ingestion | Direct file picker for `.txt` and `.zip` files | M1 | R1 |
| 2 | Zip Decompression | In-memory/temp decompress `.zip`, locate `_chat.txt` or `*.txt`, ignore heavy media | M1 | R1 |
| 3 | Brazilian 24h Regex Parser | Parse `dd/MM/yyyy HH:mm - Author: msg` and `dd/MM/yyyy, HH:mm - Author: msg` | M1 | R1 |
| 4 | Brazilian 12h Regex Parser | Parse `dd/MM/yyyy, hh:mm a - Author: msg` and `dd/MM/yy` 2-digit years | M1 | R1 |
| 5 | Unicode Sanitization | Strip zero-width and directional characters (`\u200E`, `\u200F`, `\uFEFF`, `\u00A0`, `\u202F`) | M1 | R1 |
| 6 | Multiline Accumulation | Accumulate multi-line paragraphs into previous message body | M1 | R1 |
| 7 | System Message Filter | Detect and filter encryption notices, group creation, member added/left messages | M1 | R1 |
| 8 | Media Marker Detection | Detect `<Mídia oculta>`, `<Media omitted>`, audio notes, stickers | M1 | R1 |
| 9 | Casal Love Language Breakdown | Count hearts, romantic words, memes, direct messages per participant | M2 | R2 |
| 10 | Casal Compatibility Score | Weighted compatibility index ($0.3 S_{len} + 0.3 S_{emoji} + 0.4 S_{resp}$) and classification | M2 | R2 |
| 11 | Casal Activity & Timeline | Hourly/daily heatmaps, chronological timeline, message balance, response times | M2 | R2 |
| 12 | Casal Ghosting Metrics | 2h ignoring streaks, 1h audio ignoring streaks, and response turnaround stats | M2 | R2 |
| 13 | Amigos Personas Tree | Assign personas (engraçado, expressivo, detalhista, objetivo, carinhoso) | M2 | R2 |
| 14 | Amigos Group Dynamics | Fastest replier, ghosting streaks, conversation initiator, biggest flooder | M2 | R2 |
| 15 | Amigos Superlatives | Friend superlatives and vibe compatibility index | M2 | R2 |
| 16 | Grupo Leaderboard | Member activity ranking, percentage contribution, medal badges | M2 | R2 |
| 17 | Grupo Interaction Triad | Interaction matrix (who replies to whom), reactions, topic starters | M2 | R2 |
| 18 | Grupo Dynamics & Vibes | Silent members, late-night chatter (22h-06h), 4-vibe ranking, keyword clusters | M2 | R2 |
| 19 | 100% Offline Guarantee | 0 network requests initiated; zero telemetry | M2 | R2 |
| 20 | Swiss Neutral Color Tokens | Adaptive Light (`#F8F9FA`/`#FFFFFF`) and Dark (`#0B0C0E`/`#14171A`) monotone palettes | M3 | R3 |
| 21 | Disciplined Accent Token | Swiss Precision Emerald (`#00DC82` / `#10B981`) single accent | M3 | R3 |
| 22 | Continuous Squircle Geometry | Strict `ContinuousRectangleBorder` (G2 squircle) on cards and buttons | M3 | R3 |
| 23 | Tabular Figures Typography | Mandatory `FontFeature.tabularFigures()` for all stats and counters | M3 | R3 |
| 24 | Zero-Emoji Chrome Iconography | 100% Lucide/Phosphor/Material Symbols vector icons in UI; emojis only in chat data | M3 | R3 |
| 25 | 60fps Micro-Animations | Physics springs, count-up numbers, 0.97 press-scale feedback | M3 | R3 |
| 26 | Stage Feedback Cycles | Empty states, decompression/parsing progress bars with stage indicators | M3 | R3 |
| 27 | 100% Free / Zero Paywalls | Completely unlocked: no paywalls, no billing, no locked cards | M3 | R5 |
| 28 | 9:16 Fullscreen Stories Viewer | Spotify Wrapped-style viewer with segmented progress bars & 5s auto-advance | M4 | R4 |
| 29 | Stories Gesture Navigation | Tap left 30% (prev), tap right 70% (next), hold (pause), swipe down (dismiss) | M4 | R4 |
| 30 | Bespoke Story Slide Cards | Visual story cards for Casal (18), Amigos (18), and Grupo (16) | M4 | R4 |
| 31 | 9:16 Social Export Pipeline | Render 1080x1920 crisp PNG via `RepaintBoundary` & save to cache | M4 | R4 |
| 32 | Native Android Share Sheet | Trigger native Android share sheet (`share_plus`) for WhatsApp/Instagram | M4 | R4 |
| 33 | Android Send/Share Intent | Receive shared `.zip` or `.txt` directly from WhatsApp via Android share sheet | M5 | R1 |
| 34 | Android Manifest & Permissions | Clean manifest without internet permission, `singleTask` launchMode | M5 | R1, R6 |
| 35 | Production Build Pipeline | Clean `flutter analyze` (0 errors) and `flutter build apk --release` (exit 0) | M5 | R6 |
| 36 | Physical Device ADB Flow | Detect device via `adb devices`, `adb install -r`, launch app | M6 | R7 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Ingestion & Parsing Engine | File picker, ZIP decompress, multi-format regex parser, Unicode sanitization | None | DONE |
| M2 | Deterministic Analytics Engine | Casal, Amigos, Grupo local algorithms, models, 100% offline | M1 | DONE |
| M3 | Swiss-Minimal UI & Design System | Dark/Light themes, squircle cards, count-up stats, home/dashboard, 0 paywall | M2 | DONE |
| M4 | 9:16 Stories & Social Export | Fullscreen viewer, gestures, story cards, 1080x1920 capture, native share | M3 | DONE |
| M5 | Android Intent Filter & Release Build | AndroidManifest SEND intent, singleTask, pubspec deps, release APK | M4 | DONE |
| M6 | Physical Device ADB Deployment | `adb devices` detection, `adb install -r`, app launch verification | M5 | DONE |

## Interface Contracts
### `lib/core/parser/` ↔ `lib/core/analytics/`
```dart
class RawChatExport {
  final List<ChatMessage> messages;
  final Set<String> participants;
  final DateTime startDate;
  final DateTime endDate;
}

class ChatMessage {
  final DateTime timestamp;
  final String author;
  final String content;
  final bool isMedia;
  final String? mediaType; // 'image', 'audio', 'video', 'sticker'
  final bool isSystem;
}
```

### `lib/core/analytics/` ↔ `lib/screens/` & `lib/stories/`
```dart
abstract class ChatAnalysisResult {
  GeneralStats get generalStats;
  ChatMode get mode; // casal, amigos, grupo
}

class CasalAnalysisResult extends ChatAnalysisResult { ... }
class AmigosAnalysisResult extends ChatAnalysisResult { ... }
class GrupoAnalysisResult extends ChatAnalysisResult { ... }
```

### `lib/stories/` ↔ `lib/export/`
```dart
class StoryExportService {
  static Future<String?> captureStoryCardToPng(GlobalKey boundaryKey);
  static Future<void> shareStoryImage(String imagePath);
}
```

## Code Layout
```
lib/
├── core/
│   ├── models/
│   │   ├── chat_message.dart
│   │   ├── general_stats.dart
│   │   ├── casal_stats.dart
│   │   ├── amigos_stats.dart
│   │   └── grupo_stats.dart
│   ├── parser/
│   │   ├── chat_parser.dart
│   │   ├── whatsapp_regex.dart
│   │   └── text_sanitizer.dart
│   ├── services/
│   │   ├── file_ingestion_service.dart
│   │   └── zip_extractor_service.dart
│   └── analytics/
│       ├── chat_analyzer.dart
│       ├── casal_analyzer.dart
│       ├── amigos_analyzer.dart
│       └── grupo_analyzer.dart
├── theme/
│   ├── swiss_colors.dart
│   ├── swiss_typography.dart
│   ├── swiss_theme.dart
│   └── squircle_border.dart
├── widgets/
│   ├── swiss_card.dart
│   ├── swiss_button.dart
│   ├── count_up_text.dart
│   ├── metric_badge.dart
│   └── stage_progress_indicator.dart
├── screens/
│   ├── home_screen.dart
│   ├── mode_selection_screen.dart
│   └── dashboard_screen.dart
├── stories/
│   ├── stories_viewer_screen.dart
│   ├── story_progress_bar.dart
│   └── cards/
│       ├── casal/
│       ├── amigos/
│       └── grupo/
├── export/
│   └── story_export_service.dart
└── main.dart
```
