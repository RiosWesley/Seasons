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
