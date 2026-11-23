import 'dart:async';
import 'dart:math' as math;
import '../entities/arena_models.dart';

class DuelResult {
  final bool isPlayerWinner;
  final bool isDraw;
  final int playerScore;
  final int botScore;
  final int trophiesDelta;
  final int xpEarned;

  const DuelResult({
    required this.isPlayerWinner,
    required this.isDraw,
    required this.playerScore,
    required this.botScore,
    required this.trophiesDelta,
    required this.xpEarned,
  });
}

class ArenaDuelEngine {
  final ArenaOpponentBot opponent;
  final List<ArenaQuestion> questions;
  final void Function(int playerScore, int botScore, int timeLeft) onTick;
  final void Function(DuelResult result) onFinished;

  Timer? _gameTimer;
  Timer? _botTimer;

  int _playerScore = 0;
  int _botScore = 0;
  int _streak = 0;
  int _timeLeftSeconds = 60;
  int _currentQuestionIndex = 0;
  bool _isGameOver = false;

  ArenaDuelEngine({
    required this.opponent,
    required this.questions,
    required this.onTick,
    required this.onFinished,
  });

  int get playerScore => _playerScore;
  int get botScore => _botScore;
  int get streak => _streak;
  int get timeLeft => _timeLeftSeconds;
  ArenaQuestion get currentQuestion => questions[_currentQuestionIndex % questions.length];

  void start() {
    _playerScore = 0;
    _botScore = 0;
    _streak = 0;
    _timeLeftSeconds = 60;
    _isGameOver = false;
    _currentQuestionIndex = 0;

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeftSeconds > 0) {
        _timeLeftSeconds--;
        onTick(_playerScore, _botScore, _timeLeftSeconds);
      } else {
        finish();
      }
    });

    _startBotLogic();
  }

  void _startBotLogic() {
    _botTimer = Timer.periodic(Duration(milliseconds: opponent.reactionMs), (timer) {
      if (_isGameOver) {
        timer.cancel();
        return;
      }
      final isBotCorrect = math.Random().nextDouble() <= opponent.botAccuracy;
      if (isBotCorrect) {
        _botScore += 10;
        onTick(_playerScore, _botScore, _timeLeftSeconds);
      }
    });
  }

  bool answerQuestion(int selectedIndex) {
    if (_isGameOver) return false;

    final q = currentQuestion;
    final isCorrect = selectedIndex == q.correctIndex;

    if (isCorrect) {
      _streak++;
      final multiplier = _streak >= 5 ? 3 : (_streak >= 3 ? 2 : 1);
      _playerScore += 10 * multiplier;
    } else {
      _streak = 0;
    }

    _currentQuestionIndex++;
    onTick(_playerScore, _botScore, _timeLeftSeconds);
    return isCorrect;
  }

  void finish() {
    if (_isGameOver) return;
    _isGameOver = true;
    _gameTimer?.cancel();
    _botTimer?.cancel();

    final isWinner = _playerScore > _botScore;
    final isDraw = _playerScore == _botScore;

    int trophiesDelta = 0;
    int xp = 20;

    if (isWinner) {
      trophiesDelta = opponent.trophyReward;
      xp = 100 + (_playerScore / 2).round();
    } else if (isDraw) {
      trophiesDelta = 5;
      xp = 50;
    } else {
      trophiesDelta = -10;
      xp = 30;
    }

    final result = DuelResult(
      isPlayerWinner: isWinner,
      isDraw: isDraw,
      playerScore: _playerScore,
      botScore: _botScore,
      trophiesDelta: trophiesDelta,
      xpEarned: xp,
    );

    onFinished(result);
  }

  void dispose() {
    _gameTimer?.cancel();
    _botTimer?.cancel();
  }
}
