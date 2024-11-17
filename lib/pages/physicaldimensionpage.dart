import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhysicalDimensionPage extends StatefulWidget {
  const PhysicalDimensionPage({super.key});

  @override
  _PhysicalDimensionPageState createState() => _PhysicalDimensionPageState();
}

class _PhysicalDimensionPageState extends State<PhysicalDimensionPage> {
  final List<String> bodyParts = [
    'Head', 'Eyes', 'Ears', 'Nose', 'Neck', 'Shoulders', 'Hands',
    'Chest', 'Abdomen', 'Legs', 'Back', 'foot', 'else'
  ];

  String? selectedBodyPart;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.pink),
            onPressed: () {
              Navigator.pushNamed(context, '/contactus');
            },
          ),
        ],
      ),
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0 ,bottom: 12),
                child: Center(
                  child: Text(
                    'Physical Dimension',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: bodyParts.map((part) {
                                    return RadioListTile<String>(
                                      title: Text(part),
                                      value: part,
                                      groupValue: selectedBodyPart,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedBodyPart = value;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: ModelViewer(
                                  src: 'assets/models/man.glb',
                                  alt: "3D Model of Human Body",
                                  autoRotate: true,
                                  cameraControls: true,
                                  backgroundColor: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF)
                                  ,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // تخزين القيمة في SharedPreferences
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if (selectedBodyPart != null) {
                              prefs.setString('selectedBodyPart', selectedBodyPart!);
                            }

                            // الانتقال إلى الشاشة الأخرى بعد حفظ القيمة
                            Navigator.pushReplacementNamed(context, '/seven_dimensions');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            backgroundColor: Colors.pink[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
