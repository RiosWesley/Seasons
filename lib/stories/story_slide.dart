import '../core/models/general_stats.dart';

/// Representation of a single story slide in the 9:16 Stories Experience.
class StorySlide {
  final String id;
  final String type;
  final String title;
  final ChatMode mode;
  final bool isLocked;
  final bool isDarkTheme;

  const StorySlide({
    required this.id,
    required this.type,
    required this.title,
    required this.mode,
    this.isLocked = false,
    this.isDarkTheme = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorySlide &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          mode == other.mode &&
          isLocked == other.isLocked &&
          isDarkTheme == other.isDarkTheme;

  @override
  int get hashCode => Object.hash(id, type, title, mode, isLocked, isDarkTheme);

  @override
  String toString() => 'StorySlide(id: $id, type: $type, title: "$title", isDark: $isDarkTheme)';
}

/// Definitive Story Catalog for WhatsApp Chat Wrapped.
/// All 52 slides are 100% unlocked (zero paywalls).
class StoryCatalog {
  StoryCatalog._();

  static List<StorySlide> getSlidesForMode(ChatMode mode) {
    switch (mode) {
      case ChatMode.casal:
        return getCasalSlides();
      case ChatMode.amigos:
        return getAmigosSlides();
      case ChatMode.grupo:
        return getGrupoSlides();
    }
  }

  /// 18 Bespoke Slides for Casal Mode
  static List<StorySlide> getCasalSlides() => const [
        StorySlide(id: 'c1', type: 'header', title: 'Capa', mode: ChatMode.casal),
        StorySlide(id: 'c2', type: 'total', title: 'Total de Mensagens', mode: ChatMode.casal),
        StorySlide(id: 'c3', type: 'love-language', title: 'Love Language', mode: ChatMode.casal),
        StorySlide(id: 'c4', type: 'compatibility', title: 'Compatibilidade', mode: ChatMode.casal),
        StorySlide(id: 'c5', type: 'timeline', title: 'Atividade no Tempo', mode: ChatMode.casal),
        StorySlide(id: 'c6', type: 'top-words', title: 'Top Palavras', mode: ChatMode.casal),
        StorySlide(id: 'c7', type: 'heatmap', title: 'Heatmap de Atividade', mode: ChatMode.casal, isDarkTheme: true),
        StorySlide(id: 'c8', type: 'emoji-evolution', title: 'Evolução de Emojis', mode: ChatMode.casal),
        StorySlide(id: 'c9', type: 'special-moments', title: 'Momentos Especiais', mode: ChatMode.casal),
        StorySlide(id: 'c10', type: 'comparison', title: 'Comparação', mode: ChatMode.casal),
        StorySlide(id: 'c11', type: 'stats', title: 'Estatísticas', mode: ChatMode.casal),
        StorySlide(id: 'c12', type: 'insight', title: 'Insight', mode: ChatMode.casal, isDarkTheme: true),
        StorySlide(id: 'c13', type: 'ignoring', title: 'Interações Ocultas', mode: ChatMode.casal),
        StorySlide(id: 'c14', type: 'audio-ignoring', title: 'Áudios Ignorados', mode: ChatMode.casal, isDarkTheme: true),
        StorySlide(id: 'c15', type: 'fake-screenshots', title: 'Prints Tirados', mode: ChatMode.casal, isDarkTheme: true),
        StorySlide(id: 'c16', type: 'fake-forwarded', title: 'Encaminhamentos', mode: ChatMode.casal),
        StorySlide(id: 'c17', type: 'fake-typed', title: 'Digitou mas não enviou', mode: ChatMode.casal),
        StorySlide(id: 'c18', type: 'final', title: 'Conclusão', mode: ChatMode.casal),
      ];

  /// 18 Bespoke Slides for Amigos Mode
  static List<StorySlide> getAmigosSlides() => const [
        StorySlide(id: 'a1', type: 'header', title: 'Capa', mode: ChatMode.amigos),
        StorySlide(id: 'a2', type: 'total', title: 'Total de Mensagens', mode: ChatMode.amigos),
        StorySlide(id: 'a3', type: 'styles', title: 'Estilos de Comunicação', mode: ChatMode.amigos),
        StorySlide(id: 'a4', type: 'compatibility', title: 'Compatibilidade', mode: ChatMode.amigos),
        StorySlide(id: 'a5', type: 'timeline', title: 'Atividade no Tempo', mode: ChatMode.amigos),
        StorySlide(id: 'a6', type: 'topics', title: 'Top Conversas', mode: ChatMode.amigos),
        StorySlide(id: 'a7', type: 'heatmap', title: 'Heatmap de Atividade', mode: ChatMode.amigos, isDarkTheme: true),
        StorySlide(id: 'a8', type: 'emoji-culture', title: 'Emoji Culture', mode: ChatMode.amigos),
        StorySlide(id: 'a9', type: 'floods', title: 'Flood Moments', mode: ChatMode.amigos, isDarkTheme: true),
        StorySlide(id: 'a10', type: 'personalities', title: 'Personalidades', mode: ChatMode.amigos, isDarkTheme: true),
        StorySlide(id: 'a11', type: 'stats', title: 'Estatísticas do Squad', mode: ChatMode.amigos),
        StorySlide(id: 'a12', type: 'insight', title: 'Insight', mode: ChatMode.amigos),
        StorySlide(id: 'a13', type: 'ignoring', title: 'Interações Ocultas', mode: ChatMode.amigos),
        StorySlide(id: 'a14', type: 'audio-ignoring', title: 'Áudios no Vácuo', mode: ChatMode.amigos, isDarkTheme: true),
        StorySlide(id: 'a15', type: 'fake-screenshots', title: 'Prints Tirados', mode: ChatMode.amigos, isDarkTheme: true),
        StorySlide(id: 'a16', type: 'fake-forwarded', title: 'Encaminhamentos', mode: ChatMode.amigos),
        StorySlide(id: 'a17', type: 'fake-typed', title: 'Digitou mas não enviou', mode: ChatMode.amigos),
        StorySlide(id: 'a18', type: 'final', title: 'Conclusão', mode: ChatMode.amigos),
      ];

  /// 16 Bespoke Slides for Grupo Mode
  static List<StorySlide> getGrupoSlides() => const [
        StorySlide(id: 'g1', type: 'header', title: 'Capa', mode: ChatMode.grupo),
        StorySlide(id: 'g2', type: 'total', title: 'Total de Mensagens', mode: ChatMode.grupo),
        StorySlide(id: 'g3', type: 'ranking', title: 'Top 3 Membros', mode: ChatMode.grupo),
        StorySlide(id: 'g4', type: 'dynamics', title: 'Dinâmicas do Grupo', mode: ChatMode.grupo),
        StorySlide(id: 'g5', type: 'timeline', title: 'Atividade no Tempo', mode: ChatMode.grupo),
        StorySlide(id: 'g6', type: 'topics', title: 'Top Conversas', mode: ChatMode.grupo),
        StorySlide(id: 'g7', type: 'heatmap', title: 'Heatmap de Atividade', mode: ChatMode.grupo, isDarkTheme: true),
        StorySlide(id: 'g8', type: 'emoji-evolution', title: 'Evolução de Emojis', mode: ChatMode.grupo),
        StorySlide(id: 'g9', type: 'floods', title: 'Flood Moments', mode: ChatMode.grupo, isDarkTheme: true),
        StorySlide(id: 'g10', type: 'network', title: 'Análise de Rede', mode: ChatMode.grupo, isDarkTheme: true),
        StorySlide(id: 'g11', type: 'insight', title: 'Insight', mode: ChatMode.grupo),
        StorySlide(id: 'g12', type: 'ignoring', title: 'Quem Mais Ignora', mode: ChatMode.grupo, isDarkTheme: true),
        StorySlide(id: 'g13', type: 'fake-screenshots', title: 'Quem Mais Tira Print', mode: ChatMode.grupo, isDarkTheme: true),
        StorySlide(id: 'g14', type: 'fake-forwarded', title: 'Quem Mais Encaminha', mode: ChatMode.grupo),
        StorySlide(id: 'g15', type: 'fake-deleted', title: 'Quem Mais Apaga', mode: ChatMode.grupo, isDarkTheme: true),
        StorySlide(id: 'g16', type: 'final', title: 'Conclusão', mode: ChatMode.grupo),
      ];

  /// Total count across all 3 modes
  static int get totalSlidesCount =>
      getCasalSlides().length + getAmigosSlides().length + getGrupoSlides().length;
}
