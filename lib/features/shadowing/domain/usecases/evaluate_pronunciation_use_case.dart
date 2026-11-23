import '../entities/shadowing_phrase.dart';
import '../services/pronunciation_evaluator.dart';

class EvaluatePronunciationUseCase {
  final PronunciationEvaluator _evaluator;

  const EvaluatePronunciationUseCase([this._evaluator = const PronunciationEvaluator()]);

  ShadowingEvaluation call({
    required String targetText,
    required String recognizedText,
  }) {
    return _evaluator.evaluate(
      targetText: targetText,
      recognizedText: recognizedText,
    );
  }
}
