import '../entities/analytics_models.dart';

class SkillRadarCalculator {
  const SkillRadarCalculator();

  SkillRadarMetrics calculate({
    required int cardsCount,
    required int dialoguesCount,
    required int listeningAttemptsCount,
    required int grammarPracticeCount,
  }) {
    // Эталонные планки прогресса
    const targetCards = 250.0;
    const targetDialogues = 8.0;
    const targetListening = 8.0;
    const targetGrammar = 12.0;

    final vocab = (cardsCount / targetCards).clamp(0.1, 1.0);
    final speaking = (dialoguesCount / targetDialogues).clamp(0.1, 1.0);
    final listening = (listeningAttemptsCount / targetListening).clamp(0.1, 1.0);
    final grammar = (grammarPracticeCount / targetGrammar).clamp(0.1, 1.0);

    return SkillRadarMetrics(
      vocabularyScore: vocab,
      speakingScore: speaking,
      listeningScore: listening,
      grammarScore: grammar,
    );
  }
}
