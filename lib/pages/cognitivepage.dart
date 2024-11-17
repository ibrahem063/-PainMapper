import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/dimensionpage.dart';
import 'package:flutter_application_2/pages/question.dart';

class CognitivePage extends StatelessWidget {
  const CognitivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DimensionPage(
      title: 'Cognitive Dimension',
      questions: [
        Question(
          text:
              'To what extent does pain affect your ability to concentrate and pay attention during tasks or conversations?',
          label1: 'Does not affect at all',
          label5: 'Affects significantly',
        ),
        Question(
          text:
              'To what extent do you find it difficult to remember things or experience mental fog due to pain?',
          label1: 'No difficulty at all',
          label5: 'Experience significant difficulty',
        ),
        Question(
          text:
              'To what extent have you noticed changes in your problem-solving skills or decision-making ability during painful episodes?',
          label1: 'No changes observed',
          label5: 'Significant and clear changes',
        ),
      ],
    );
  }
}
