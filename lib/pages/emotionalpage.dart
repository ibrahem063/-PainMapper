import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/dimensionpage.dart';
import 'package:flutter_application_2/pages/question.dart';

class EmotionalPage extends StatelessWidget {
  const EmotionalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DimensionPage(
      title: 'Emotional Dimension',
      questions: [
        Question(
          text:
              'To what extent do you feel emotions such as frustration, anger, sadness, or fear when experiencing pain?',
          label1: 'I don\'t feel these emotions',
          label5: 'I feel them strongly',
        ),
        Question(
          text:
              'To what extent does pain affect your mood and emotional state?',
          label1: 'It doesn\'t affect my mood',
          label5: 'It affects strongly',
        ),
        Question(
          text:
              'To what extent do you use strategies or methods to cope with the emotional impact of pain?',
          label1: 'I do not use any strategies',
          label5: 'I use strategies effectively',
        ),
      ],
    );
  }
}
