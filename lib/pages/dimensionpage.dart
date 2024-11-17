import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/dimension_result_model.dart';
import 'question.dart'; // تأكد من استيراد الكلاس Question
import 'package:http/http.dart' as http;

class DimensionPage extends StatefulWidget {
  final String title;
  final List<Question> questions;

  const DimensionPage(
      {super.key, required this.title, required this.questions});

  @override
  _DimensionPageState createState() => _DimensionPageState();
}

class _DimensionPageState extends State<DimensionPage> {
  List<int?> selectedOptions = []; // لتخزين خيارات المستخدم المحددة
  List<DimensionResult> results = [];
  String? uId;

  @override
  void initState() {
    super.initState();
    selectedOptions = List.filled(
        widget.questions.length, null); // تهيئة قائمة الخيارات المحددة
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uId = prefs.getString('userId');
    });
  }

  Future<void> submitAnswers() async {
    List<double> answers =
    selectedOptions.map((option) => option?.toDouble() ?? 0).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // إرسال البيانات إلى الخادم
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/fuzzy'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'answer1': answers[0],
        'answer2': answers[1],
        'answer3': answers[2],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final output = data['output']; // استخراج الناتج من الاستجابة

      print('Output from fuzzy logic: $output');

      // حفظ الناتج في SharedPreferences
      await prefs.setDouble('${widget.title}-output', output);

    } else {
      throw Exception('Failed to load output');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ..._buildQuestions(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      submitAnswers(); // استدعاء دالة إرسال الإجابات
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.pink[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Done', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildQuestions() {
    return widget.questions.asMap().entries.map((entry) {
      int index = entry.key;
      Question question = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildRadioOptionsWithLabels(
                index,
                question.label1,
                question.label5,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildRadioOptionsWithLabels(
      int questionIndex, String label1, String label5) {
    return Column(
      children: [
        RadioListTile<int>(
          title: Row(
            children: [
              const Text('1'),
              const SizedBox(width: 8),
              Text(label1),
            ],
          ),
          value: 1,
          groupValue: selectedOptions[questionIndex],
          onChanged: (value) {
            setState(() {
              selectedOptions[questionIndex] = value; // تخزين القيمة المحددة
            });
          },
        ),
        for (int i = 2; i <= 4; i++)
          RadioListTile<int>(
            title: Text('$i'),
            value: i,
            groupValue: selectedOptions[questionIndex],
            onChanged: (value) {
              setState(() {
                selectedOptions[questionIndex] = value; // تخزين القيمة المحددة
              });
            },
          ),
        RadioListTile<int>(
          title: Row(
            children: [
              const Text('5'),
              const SizedBox(width: 8),
              Text(label5),
            ],
          ),
          value: 5,
          groupValue: selectedOptions[questionIndex],
          onChanged: (value) {
            setState(() {
              selectedOptions[questionIndex] = value; // تخزين القيمة المحددة
            });
          },
        ),
      ],
    );
  }
}
