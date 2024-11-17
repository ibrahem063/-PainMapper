import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SevenDimensionsPage extends StatefulWidget {
  const SevenDimensionsPage({super.key});

  @override
  State<SevenDimensionsPage> createState() => _SevenDimensionsPageState();
}

class _SevenDimensionsPageState extends State<SevenDimensionsPage> {
  String? uId;
  bool isUploading = false;

  Future<Map<String, double>> getAllOutputs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, double> allOutputs = {};

    // جمع النواتج المخزنة من جميع الشاشات
    allOutputs['Behavioral'] =
        prefs.getDouble('Behavioral Dimension-output') ?? 0;
    allOutputs['Sociocultural'] =
        prefs.getDouble('Sociocultural Dimension-output') ?? 0;
    allOutputs['Cognitive'] =
        prefs.getDouble('Cognitive Dimension-output') ?? 0;
    allOutputs['Emotional'] =
        prefs.getDouble('Emotional Dimension-output') ?? 0;
    allOutputs['Spiritual'] =
        prefs.getDouble('Spiritual Dimension-output') ?? 0;

    return allOutputs;
  }

  Future<String?> getSelectedBodyPart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedBodyPart');
  }

  Future<int?> getSelectedPainLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('pain level');
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print("User ID is missing");
      return;
    }

    setState(() {
      uId = userId;
    });
  }

  Future<void> uploadDataToFirebase(String uId) async {
    try {
      setState(() {
        isUploading = true;
      });

      // الحصول على القيم المخزنة
      Map<String, double> allOutputs = await getAllOutputs();
      String? selectedBodyPart = await getSelectedBodyPart();
      int? selectedPainLevel = await getSelectedPainLevel();

      // التحقق من أن القيم ليست فارغة أو غير صالحة
      if (allOutputs.isEmpty ||
          selectedBodyPart == null ||
          selectedPainLevel == null) {
        print("Cannot upload data: Some values are missing.");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Some values are missing.')));
        setState(() {
          isUploading = false;
        });
        return; // الخروج إذا كانت القيم غير صالحة
      } else {
        final data = {
          'Behavioral': allOutputs['Behavioral'],
          'Sociocultural': allOutputs['Sociocultural'],
          'Cognitive': allOutputs['Cognitive'],
          'Emotional': allOutputs['Emotional'],
          'Spiritual': allOutputs['Spiritual'],
          'Selected Body Part': selectedBodyPart,
          'Pain Level': selectedPainLevel,
          'timestamp': FieldValue.serverTimestamp(),
        };

        // مرجع المسار في Firestore
        final docRef = FirebaseFirestore.instance
            .collection('patient')
            .doc(uId)
            .collection('dimension')
            .doc();

        // رفع البيانات إلى Firebase
        await docRef.set(data);
        print("Data uploaded successfully!");

        // عرض إشعار بنجاح رفع البيانات
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data uploaded successfully!')));

        // حذف القيم من SharedPreferences بعد نجاح الرفع
        await clearSharedPreferences();
        Navigator.pushNamed(context, '/qrcode');
      }

      setState(() {
        isUploading = false;
      });
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      print("Failed to upload data: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload data.')));
    }
  }

  // دالة لحذف القيم من SharedPreferences
  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('Behavioral Dimension-output');
    await prefs.remove('Sociocultural Dimension-output');
    await prefs.remove('Cognitive Dimension-output');
    await prefs.remove('Emotional Dimension-output');
    await prefs.remove('Spiritual Dimension-output');
    await prefs.remove('selectedBodyPart');
  }

  @override
  void initState() {
    super.initState();
    getUserId();
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
            Navigator.pop(context); // العودة إلى الصفحة السابقة
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.pink),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/contactus'); // الانتقال إلى صفحة الاتصال
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // الخلفية العصبية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Seven dimensions of Pain',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // قائمة بالأبعاد السبعة للألم
                    buildDimensionItem('Sensory', context),
                    buildDimensionItem('Behavioral', context),
                    buildDimensionItem('Sociocultural', context),
                    buildDimensionItem('Cognitive', context),
                    buildDimensionItem('Emotional', context),
                    buildDimensionItem('Spiritual', context),
                    buildDimensionItem('Physical', context),
                    const SizedBox(height: 20),
                    // زر Done
                    if (!isUploading)
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (uId != null) {
                              await uploadDataToFirebase(uId!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('User ID is missing.')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                            backgroundColor: Colors.pink[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'DONE',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    else
                      Center(
                          child: CircularProgressIndicator(
                              color: Colors.pink[300])),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget لبناء عناصر الأبعاد السبعة للألم
  Widget buildDimensionItem(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Colors.pink[50],
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.pink[300],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.pink[300]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () {
          // الانتقال إلى الصفحة المناسبة بناءً على العنوان
          if (title == 'Sensory') {
            Navigator.pushNamed(context, "/eegsignalspage");
          } else if (title == 'Behavioral') {
            Navigator.pushNamed(context, "/behavioral");
          } else if (title == 'Sociocultural') {
            Navigator.pushNamed(context, "/sociocultural");
          } else if (title == 'Cognitive') {
            Navigator.pushNamed(context, "/Cognitive");
          } else if (title == 'Emotional') {
            Navigator.pushNamed(context, "/emotional");
          } else if (title == 'Spiritual') {
            Navigator.pushNamed(context, "/spiritual");
          } else if (title == 'Physical') {
            Navigator.pushNamed(context, "/physical");
          }
        },
      ),
    );
  }
}
