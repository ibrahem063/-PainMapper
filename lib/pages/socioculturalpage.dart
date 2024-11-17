import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/dimensionpage.dart';
import 'package:flutter_application_2/pages/question.dart';

class SocioculturalPage extends StatelessWidget {
  const SocioculturalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DimensionPage(
      title: 'Sociocultural Dimension',
      questions: [
        Question(
          text:
              'To what extent does your pain affect your relationships with family, friends, or colleagues?',
          label1: 'Does not affect at all',
          label5: 'Significantly affects relationships',
        ),
        Question(
          text:
              'To what extent do cultural or societal beliefs about pain influence your experience or management of pain?',
          label1: 'Does not influence my experience',
          label5: 'Influences significantly',
        ),
        Question(
          text:
              'To what extent do you turn to support systems or communities for guidance or understanding regarding your pain?',
          label1: 'Do not turn to them at all',
          label5: 'Turn to them consistently',
        ),
      ],
    );
  }
}
