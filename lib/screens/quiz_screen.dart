// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/quiz_repository.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswerSubmitted = false;
  bool _isQuizCompleted = false;

  void _submitAnswer(int index) {
    if (_isAnswerSubmitted) return;
    final q = QuizRepository.questions[_currentIndex];
    setState(() {
      _selectedOptionIndex = index;
      _isAnswerSubmitted = true;
      if (index == q.correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < QuizRepository.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _isAnswerSubmitted = false;
      });
    } else {
      setState(() {
        _isQuizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOptionIndex = null;
      _isAnswerSubmitted = false;
      _isQuizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = QuizRepository.questions;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Heritage Trivia & Quiz'),
      ),
      body: _isQuizCompleted
          ? _buildCompletionScreen()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QUESTION ${_currentIndex + 1} OF ${questions.length}',
                        style: GoogleFonts.cinzel(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Score: $_score',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGoldLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / questions.length,
                      backgroundColor: AppTheme.surfaceDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.darkCardGradient,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      questions[_currentIndex].question,
                      style: GoogleFonts.marcellus(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGoldLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options
                  ...questions[_currentIndex].options.asMap().entries.map((entry) {
                    int optIdx = entry.key;
                    String optText = entry.value;
                    bool isSelected = _selectedOptionIndex == optIdx;
                    bool isCorrect = optIdx == questions[_currentIndex].correctIndex;

                    Color borderCol = Colors.white12;
                    Color bgCol = AppTheme.cardDark;
                    if (_isAnswerSubmitted) {
                      if (isCorrect) {
                        borderCol = AppTheme.emeraldGreen;
                        bgCol = AppTheme.emeraldGreen.withValues(alpha: 0.15);
                      } else if (isSelected) {
                        borderCol = AppTheme.crimsonRed;
                        bgCol = AppTheme.crimsonRed.withValues(alpha: 0.15);
                      }
                    }

                    return GestureDetector(
                      onTap: () => _submitAnswer(optIdx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: bgCol,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderCol, width: 1.4),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.surfaceDark,
                                border: Border.all(color: borderCol),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + optIdx),
                                  style: GoogleFonts.cinzel(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                optText,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ),
                            if (_isAnswerSubmitted && isCorrect)
                              const Icon(Icons.check_circle, color: AppTheme.emeraldGreen, size: 20)
                            else if (_isAnswerSubmitted && isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: AppTheme.crimsonRed, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Explanation Card after submission
                  if (_isAnswerSubmitted) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, color: AppTheme.accentGold, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Chronicle Fact & Explanation',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            questions[_currentIndex].explanation,
                            style: GoogleFonts.outfit(fontSize: 12.5, color: AppTheme.textLight, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                      child: Text(
                        _currentIndex < questions.length - 1 ? 'NEXT QUESTION' : 'SEE RESULTS',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildCompletionScreen() {
    final questions = QuizRepository.questions;
    final isMaster = _score >= 4;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppTheme.darkCardGradient,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.accentGold, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: 0.25),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.goldGradient,
                ),
                child: Icon(
                  isMaster ? Icons.workspace_premium : Icons.stars,
                  color: AppTheme.backgroundDark,
                  size: 54,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isMaster ? 'Royal Heritage Scholar!' : 'Heritage Explorer!',
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGoldLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored $_score out of ${questions.length} questions correctly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 14, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _restartQuiz,
                icon: const Icon(Icons.replay),
                label: const Text('RETAKE QUIZ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
