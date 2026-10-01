import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import 'lab_quiz_data.dart';

class LabQuizScreen extends StatefulWidget {
  const LabQuizScreen({required this.labId, required this.labTitle, super.key});

  final String labId;
  final String labTitle;

  @override
  State<LabQuizScreen> createState() => _LabQuizScreenState();
}

class _LabQuizScreenState extends State<LabQuizScreen> {
  int _questionIndex = 0;
  int? _selectedAnswer;
  bool _isAnswerChecked = false;
  int _score = 0;

  List<LabQuizQuestion> get _questions {
    final questions = labQuizzes[widget.labId];
    if (questions == null || questions.isEmpty) {
      throw StateError('No quiz questions configured for ${widget.labId}.');
    }
    return questions;
  }

  void _checkAnswer() {
    if (_selectedAnswer == null || _isAnswerChecked) return;
    setState(() {
      _isAnswerChecked = true;
      if (_selectedAnswer == _questions[_questionIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _continueQuiz() {
    if (!_isAnswerChecked) return;
    if (_questionIndex == _questions.length - 1) {
      setState(() => _questionIndex = _questions.length);
      return;
    }
    setState(() {
      _questionIndex++;
      _selectedAnswer = null;
      _isAnswerChecked = false;
    });
  }

  void _restartQuiz() {
    setState(() {
      _questionIndex = 0;
      _selectedAnswer = null;
      _isAnswerChecked = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;
    final strings = locale.strings;
    final isFinished = _questionIndex >= _questions.length;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(isArabic ? 'اختبر نفسك' : 'Test yourself')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: isFinished
                    ? _buildResult(isArabic)
                    : _buildQuestion(isArabic: isArabic, strings: strings),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion({required bool isArabic, required AppStrings strings}) {
    final question = _questions[_questionIndex];
    final progress = (_questionIndex + 1) / _questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.labTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: const Color(0xFF5EEAD4)),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFF24324A),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF14B8A6)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_questionIndex + 1}/${_questions.length}',
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          question.question.value(isArabic),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white, height: 1.5),
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < question.options.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildOption(
              question: question,
              index: index,
              isArabic: isArabic,
            ),
          ),
        if (_isAnswerChecked) ...[
          const SizedBox(height: 6),
          _buildAnswerFeedback(question, isArabic),
        ],
        const SizedBox(height: 18),
        FilledButton.icon(
          key: const ValueKey('check-quiz-answer'),
          onPressed: _isAnswerChecked
              ? _continueQuiz
              : _selectedAnswer == null
              ? null
              : _checkAnswer,
          icon: Icon(
            _isAnswerChecked
                ? _questionIndex == _questions.length - 1
                      ? Icons.flag_rounded
                      : Icons.arrow_forward_rounded
                : Icons.check_rounded,
          ),
          label: Text(
            _isAnswerChecked
                ? _questionIndex == _questions.length - 1
                      ? (isArabic ? 'عرض النتيجة' : 'See results')
                      : (isArabic ? 'السؤال التالي' : 'Next question')
                : strings.t('checkAnswer'),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required LabQuizQuestion question,
    required int index,
    required bool isArabic,
  }) {
    final isSelected = _selectedAnswer == index;
    final isCorrectOption = _isAnswerChecked && index == question.correctIndex;
    final isWrongSelection =
        _isAnswerChecked && isSelected && index != question.correctIndex;
    final borderColor = isCorrectOption
        ? const Color(0xFF14B8A6)
        : isWrongSelection
        ? const Color(0xFFEF4444)
        : isSelected
        ? const Color(0xFF14B8A6)
        : const Color(0xFF24324A);

    return Material(
      key: ValueKey('quiz-option-$index'),
      color: isCorrectOption
          ? const Color(0xFF14B8A6).withValues(alpha: 0.12)
          : isWrongSelection
          ? const Color(0xFFEF4444).withValues(alpha: 0.1)
          : const Color(0xFF101828),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: _isAnswerChecked
            ? null
            : () => setState(() => _selectedAnswer = index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                isCorrectOption
                    ? Icons.check_circle_rounded
                    : isWrongSelection
                    ? Icons.cancel_rounded
                    : isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isCorrectOption
                    ? const Color(0xFF5EEAD4)
                    : isWrongSelection
                    ? const Color(0xFFFCA5A5)
                    : isSelected
                    ? const Color(0xFF5EEAD4)
                    : const Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.options[index].value(isArabic),
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerFeedback(LabQuizQuestion question, bool isArabic) {
    final isCorrect = _selectedAnswer == question.correctIndex;
    final color = isCorrect ? const Color(0xFF5EEAD4) : const Color(0xFFFCA5A5);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect
                ? (isArabic ? 'إجابة صحيحة' : 'Correct answer')
                : (isArabic
                      ? 'الإجابة الصحيحة موضحة بالأخضر'
                      : 'The correct answer is highlighted'),
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            question.explanation.value(isArabic),
            style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(bool isArabic) {
    final percentage = (_score / _questions.length * 100).round();
    final message = percentage == 100
        ? (isArabic
              ? 'ممتاز! إجاباتك كلها صحيحة.'
              : 'Excellent! Every answer is correct.')
        : percentage >= 50
        ? (isArabic
              ? 'أداء جيد، راجع الشرح لتثبيت المعلومة.'
              : 'Good work. Review the explanations to reinforce what you learned.')
        : (isArabic
              ? 'راجع المختبر وحاول مرة أخرى.'
              : 'Review the lab and give it another try.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),
        const Icon(
          Icons.emoji_events_rounded,
          color: Color(0xFFF59E0B),
          size: 56,
        ),
        const SizedBox(height: 16),
        Text(
          isArabic ? 'انتهى الاختبار' : 'Quiz complete',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          isArabic
              ? 'نتيجتك $_score من ${_questions.length} ($percentage٪)'
              : 'Your score: $_score of ${_questions.length} ($percentage%)',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF5EEAD4),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.5),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _restartQuiz,
          icon: const Icon(Icons.replay_rounded),
          label: Text(isArabic ? 'إعادة الاختبار' : 'Try again'),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          label: Text(isArabic ? 'العودة للمختبرات' : 'Back to labs'),
        ),
      ],
    );
  }
}
