import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/dimensionpage.dart';
import 'package:flutter_application_2/pages/question.dart';


class BehavioralPage extends StatefulWidget {
  const BehavioralPage({Key? key}) : super(key: key);

  @override
  State<BehavioralPage> createState() => _BehavioralPageState();
}

class _BehavioralPageState extends State<BehavioralPage> {
  @override
  Widget build(BuildContext context) {
    return DimensionPage(
      title: 'Behavioral Dimension',
      questions: [
        Question(
          text:
              'To what extent does pain affect your ability to perform your daily activities and functions?',
          label1: 'Does not affect at all',
          label5: 'Strongly affects',
        ),
        Question(
          text:
              'To what extent have you noticed changes in your sleep pattern or appetite due to pain?',
          label1: 'No changes at all',
          label5: 'Significant and clear changes',
        ),
        Question(
          text:
              'To what extent do you avoid certain activities or confront specific situations due to pain?',
          label1: 'I do not avoid any activities',
          label5: 'I avoid many activities',
        ),
      ],
    );
  }
}
