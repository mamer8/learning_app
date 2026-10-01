import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import 'lab_quiz_data.dart';
import 'lab_quiz_screen.dart';

class LabQuizAction extends StatelessWidget {
  const LabQuizAction({required this.labId, super.key});

  final String labId;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final labTitle = labQuizTitles[labId];
    if (labTitle == null) {
      throw StateError('No quiz title configured for $labId.');
    }

    return IconButton(
      key: ValueKey('lab-quiz-action-$labId'),
      tooltip: locale.strings.t('takeQuiz'),
      icon: const Icon(Icons.quiz_outlined, color: Color(0xFF5EEAD4)),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => LabQuizScreen(
              labId: labId,
              labTitle: labTitle.value(locale.isArabic),
            ),
          ),
        );
      },
    );
  }
}
