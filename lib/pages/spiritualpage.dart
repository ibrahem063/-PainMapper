import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/dimensionpage.dart';
import 'package:flutter_application_2/pages/question.dart';

class SpiritualPage extends StatelessWidget {
  const SpiritualPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DimensionPage(
      title: 'Spiritual Dimension',
      questions: [
        Question(
          text:
              'To what extent does pain affect your spiritual beliefs or spirituality?',
          label1: 'Does not affect at all',
          label5: 'Affects significantly',
        ),
        Question(
          text:
              'To what extent does pain affect your sense of purpose or meaning in life?',
          label1: 'Does not impact purpose',
          label5: 'Affects significantly',
        ),
        Question(
          text:
              'To what extent do spiritual practices or beliefs provide you with comfort or support during painful episodes?',
          label1: 'Does not provide comfort',
          label5: 'Does provide significant comfort',
        ),
      ],
    );
  }
}
