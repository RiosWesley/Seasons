# Seasons — Resumo do Pré-Projeto

**Entrega:** 17/09/2026 | **Equipe:** até 6 integrantes — [preencher nomes + RA]
**App:** Seasons (retrospectiva de conversas do WhatsApp) | **Tipo:** aplicativo móvel multiplataforma

## 1. Modelo de negócio atual

Negócio base: WhatsApp (mensageria, 2B+ usuários). O recurso usado é a **Exportação de conversa**: Conversa > ⋮ > Mais > Exportar conversa > Sem mídia → gera arquivo `.txt` ou `.zip` (`_chat.txt`) com timestamps, autores e mensagens.

Hoje esse arquivo não tem função analítica: fica salvo no e-mail/arquivos, ilegível, sem métricas, sem visualização e sem compartilhamento.

## 2. Problema e oportunidade de melhoria

- Exportação gera dado bruto sem valor (sem totais, rankings, horários de pico, emojis, tempos de resposta, vácuos).
- Não existe retrospectiva nativa no WhatsApp, embora o desejo por esse formato seja provado (Spotify Wrapped).
- Oportunidade: intervenção externa via app, sem API e sem servidor — apenas leitura e análise local do arquivo exportado, com foco em memória, insights sociais e compartilhamento.

## 3. Proposta de intervenção

O Seasons importa o `.txt`/`.zip` por file-picker ou Share Intent direto do WhatsApp, analisa 100% offline e devolve uma retrospectiva em Stories 9:16 compartilhável.

Modos de análise por nº de participantes detectado:

- **Casal (2):** love language, compatibilidade, ritmo a dois, passaporte do casal. 18 slides (c1–c18).
- **Amigos/Squad (3–5):** arquétipos, caos, floods, pôster do squad. 18 slides (a1–a18).
- **Grupo (6+):** leaderboard, Pareto 80/20, matriz de interação, certificado da comunidade. 16 slides (g1–g16).

Total: 52 slides + exportação de imagem 9:16 com share nativo (Status/Instagram). Sem paywall, sem tracking.

## 4. Escolha tecnológica

**Multiplataforma com Flutter + Dart** (um código → Android/iOS/Web/Desktop).

- Nativo (Kotlin/Swift): descartado — duas bases de código, custo 2x, inviável no prazo.
- Híbrido (WebView/Ionic): descartado — performance inferior para animações 60fps e gestos dos Stories, acesso limitado a arquivo/Share Intent. Critério do enunciado prioriza multiplataforma sobre híbrido.
- Multiplataforma Flutter: escolhido — performance nativa, acesso a APIs via plugins, ideal para MVP acadêmico com equipe única.

## 5. Telas (mínimo 3 atendido — 6 entregues)

1. **Onboarding editorial (4 páginas):** boas-vindas/privacidade → 3 modos + Stories → como exportar em 4 passos → garantia local + CTA. PageView, Pular/Avançar, persiste `hasSeenOnboarding`.
2. **Home + Importação:** empty state, progresso por estágio (descompactar → parse → analisar), erro com recuperação. Bottom nav flutuante frosted-glass.
3. **Seleção de Modo:** cards bento por modo (Casal rose `#E11D48`, Amigos sky `#2563EB`, Grupo violet `#7C3AED`) + selo "Recomendado para esta conversa".
4. **Dashboard:** totais, rankings, timelines, heatmaps.
5. **Stories Viewer 9:16:** progresso calibrado, tap esq/dir, hold-pausa, swipe-down fecha, rodapé `seasons` serifado.
6. **Configurações:** rever onboarding, sobre/privacidade.

Protótipos/mockups e app funcional são aceitos como comprovação — o projeto já possui protótipo navegável.

## 6. Jornada do usuário

Ana exporta conversa Sem mídia no WhatsApp → compartilha o arquivo no Seasons (ou importa pelo file-picker) → app detecta 2 participantes e recomenda modo Casal → confirma → vê Dashboard (total com count-up, timeline, heatmap "A Nossa Hora") → abre Stories, navega por tap/hold → no slide final gera o Passaporte do Casal e compartilha no Status.

Fluxos alternativos cobertos: arquivo `.zip` com mídia (ignora mídia sem crash), formato 24h/12h BR, mensagens multiline, `<Mídia oculta>`, voltar/pular onboarding, rever onboarding depois.

## 7. Interface

**Princípios de design:** Warm Ivory `#FBF9F5` + papel texturizado, serif editorial, squircle contínuo, 1 acento por modo, ícones Lucide (zero emoji como ícone). Responsivo 9:16 fluido com `MediaQuery`, scroll com compensação do dock, numerais tabulares sem jitter.

**Heurísticas de Nielsen:** status visível (progresso + barra stories), linguagem do mundo real (Vácuo, Flood, Passaporte), controle (pular/voltar/fechar), consistência (mesmo rodapé e gestos nos 52 slides), prevenção de erro (exige Sem mídia, filtra mensagens de sistema), reconhecimento (badge Recomendado), estética minimalista sem paywall.

**Acessibilidade (WCAG 2.2 AA):** contraste AA texto-em-fundo, alvos ≥48dp, feedback háptico + visual (não só cor), texto escalável, heatmaps com número + intensidade, CTAs com semântica.

## 8. Aplicação

**Linguagem e dependências:** Flutter 3.x + Dart 3.13. `file_picker, archive, path_provider, receive_sharing_intent, share_plus, provider, shared_preferences, flutter_animate, lucide_icons_flutter`. Coerentes com offline-first: sem Firebase, sem billing, sem rede.

**Engenharia de software:** `core/` (parse + analytics determinísticos), `stories/adapters/` (derivam stats sem quebrar modelo), `widgets/stories/shared/` (scaffold, footer, gauge, count-up reutilizáveis), `story_card_factory` + 1 arquivo por slide. Separação de responsabilidades, testabilidade.

**Eficiência:** parse tolerante com regex, ZIP em cache temporário sem estourar memória, 60fps com animações físicas, 0 chamadas de rede. Evidência: `dart analyze` 0 erros, `flutter test` 100%, `flutter build apk --release` + instalação ADB.

## 9. Documentação

- **Manutenção médio-longo prazo:** `PROJECT.md` (arquitetura, 60 features M1–M5, contratos adapters), `ORIGINAL_REQUEST.md` (requisitos R1–R7 e aceitação), `TEST_*.md`, código nomeado por convenção (c/a/g + número).
- **Cliente/usuário final:** onboarding pág. 3 (guia exportar), empty/error states explicativos, opção Rever Onboarding.
