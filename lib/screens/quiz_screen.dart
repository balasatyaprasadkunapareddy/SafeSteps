import 'package:flutter/material.dart';
import 'dart:async';
import '../data/app_data.dart';
import '../models/quiz_question.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import '../widgets/quiz_option_tile.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Questions are shuffled for variety
  late final List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _hasAnswered = false;
  bool _isFinished = false;
  bool _isSaving = false;

  // Timer
  int _secondsLeft = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final shuffled = List<QuizQuestion>.from(AppData.quizQuestions)..shuffle();
    _questions = shuffled.take(10).toList();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft > 0 && !_hasAnswered) {
        setState(() => _secondsLeft--);
      } else if (_secondsLeft == 0 && !_hasAnswered) {
        _submitAnswer(-1); // Time expired — no answer
      }
    });
  }

  void _submitAnswer(int selectedIndex) {
    if (_hasAnswered) return;
    _timer?.cancel();

    final correct = _questions[_currentIndex].correctAnswerIndex;
    final isCorrect = selectedIndex == correct;

    setState(() {
      _selectedIndex = selectedIndex;
      _hasAnswered = true;
      if (isCorrect) _score++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _hasAnswered = false;
      });
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    setState(() => _isSaving = true);

    final updated = await DatabaseService().recordQuizResult(
      score: _score,
      totalQuestions: _questions.length,
    );
    DatabaseService().updateLocalProfile(updated);

    if (mounted) {
      setState(() {
        _isSaving = false;
        _isFinished = true;
      });
    }
  }

  OptionState _getOptionState(int optionIndex) {
    if (!_hasAnswered) return OptionState.idle;
    final correct = _questions[_currentIndex].correctAnswerIndex;
    if (optionIndex == _selectedIndex && optionIndex == correct) {
      return OptionState.correct;
    }
    if (optionIndex == _selectedIndex && optionIndex != correct) {
      return OptionState.incorrect;
    }
    if (optionIndex == correct) {
      return OptionState.revealed;
    }
    return OptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaving) {
      return const Scaffold(
        backgroundColor: AppTheme.surface,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppTheme.primary),
              SizedBox(height: 16),
              Text('Saving your score...'),
            ],
          ),
        ),
      );
    }

    if (_isFinished) {
      return _ResultScreen(
        score: _score,
        total: _questions.length,
        profile: DatabaseService().localProfile,
        onRetry: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const QuizScreen()),
          );
        },
        onHome: () => Navigator.pop(context),
      );
    }

    final question = _questions[_currentIndex];
    final isWide = MediaQuery.of(context).size.width >= 700;
    final progress = (_currentIndex + 1) / _questions.length;
    final timerColor = _secondsLeft <= 5
        ? AppTheme.danger
        : _secondsLeft <= 10
            ? AppTheme.warning
            : AppTheme.secondary;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Quit Quiz?'),
                content: const Text(
                    'Your progress will be lost. Are you sure?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue Quiz'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Quit',
                        style: TextStyle(color: AppTheme.danger)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isWide ? 32 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Progress row ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1} of ${_questions.length}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: AppTheme.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Timer
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: timerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: timerColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: timerColor),
                        const SizedBox(width: 4),
                        Text(
                          '${_secondsLeft}s',
                          style: TextStyle(
                            color: timerColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Score
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '⭐ Score: $_score',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Category chip ─────────────────────────────────────
              Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      question.category,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Question text ─────────────────────────────────────
              Text(
                question.question,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
              ),
              const SizedBox(height: 24),

              // ── Answer options ─────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    return QuizOptionTile(
                      text: question.options[i],
                      state: _getOptionState(i),
                      onTap: () => _submitAnswer(i),
                    );
                  },
                ),
              ),

              // ── Explanation & Next ─────────────────────────────────
              if (_hasAnswered) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.explanation,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    _currentIndex < _questions.length - 1
                        ? 'Next Question →'
                        : 'See Results 🏁',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  RESULT SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class _ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final dynamic profile;
  final VoidCallback onRetry;
  final VoidCallback onHome;

  const _ResultScreen({
    required this.score,
    required this.total,
    required this.profile,
    required this.onRetry,
    required this.onHome,
  });

  String get _resultEmoji {
    final pct = score / total;
    if (pct >= 0.9) return '🏆';
    if (pct >= 0.7) return '🎓';
    if (pct >= 0.5) return '👍';
    return '📚';
  }

  String get _resultTitle {
    final pct = score / total;
    if (pct >= 0.9) return 'Outstanding!';
    if (pct >= 0.7) return 'Great Job!';
    if (pct >= 0.5) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  String get _resultMessage {
    final pct = score / total;
    if (pct >= 0.9) {
      return 'You are a true Traffic Expert. You know India\'s road rules inside out!';
    }
    if (pct >= 0.7) {
      return 'You have a solid understanding of road safety. Review the modules you missed.';
    }
    if (pct >= 0.5) {
      return 'Good start! Read through the Learning Modules to improve your score.';
    }
    return 'Road safety takes practice! Study the modules and try again.';
  }

  Color get _resultColor {
    final pct = score / total;
    if (pct >= 0.9) return AppTheme.warning;
    if (pct >= 0.7) return AppTheme.secondary;
    if (pct >= 0.5) return AppTheme.primary;
    return AppTheme.danger;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (score / total * 100).round();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Trophy / Emoji
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _resultColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _resultColor.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _resultEmoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _resultTitle,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: _resultColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _resultMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),

              // Score card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '$score / $total',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        color: _resultColor,
                        letterSpacing: -2,
                      ),
                    ),
                    Text(
                      '$pct% correct',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: score / total,
                        minHeight: 8,
                        backgroundColor: AppTheme.border,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_resultColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ResultStat(
                          label: 'Best Score',
                          value: '${profile.highestScore}%',
                          icon: Icons.emoji_events_outlined,
                        ),
                        _ResultStat(
                          label: 'Total XP',
                          value: '${profile.xp} XP',
                          icon: Icons.bolt_rounded,
                        ),
                        _ResultStat(
                          label: 'Badges',
                          value: '${profile.earnedBadges.length}',
                          icon: Icons.workspace_premium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // New badges
              if (profile.earnedBadges.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppTheme.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium,
                          color: AppTheme.warning, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You have ${profile.earnedBadges.length} badge(s)! Check the Badges tab.',
                          style: const TextStyle(
                            color: Color(0xFF92400E),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onHome,
                icon: const Icon(Icons.home_outlined),
                label: const Text('Back to Home'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.textMuted),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 15),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
