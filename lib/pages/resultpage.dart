import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // متغيرات لتخزين البيانات المسترجعة
  String name = "Loading...";
  int age = 0;
  String gender = "Loading...";
  bool diabetes = false;
  bool hypertension = false;
  double totalPercentage = 0;
  String? uId;
  Map<String, dynamic> painDimensions = {};
  String image = 'else';
  int num=1;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getDataFromFirebase(String uid) async {
    try {
      // الحصول على البيانات من Firebase باستخدام uid الخاص بالمريض
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('patient') // مجموعة المرضى
          .doc(uid) // الوثيقة الخاصة بالمريض باستخدام الـ uid
          .collection('dimension') // مجموعة الأبعاد
          .orderBy('timestamp', descending: true) // ترتيب حسب الوقت
          .limit(1) // فقط آخر سجل
          .get()
          .then((querySnapshot) =>
              querySnapshot.docs.first); // الحصول على أول سجل

      // إذا كانت هناك بيانات
      if (snapshot.exists) {
        // جلب البيانات من الوثيقة
        painDimensions = snapshot.data() as Map<String, dynamic>;
        totalPercentage = (painDimensions['Behavioral']) +
            (painDimensions['Cognitive']) +
            (painDimensions['Emotional']) +
            (painDimensions['Sociocultural']) +
            (painDimensions['Spiritual'])+
            ((painDimensions['Pain Level'])/10)
    ;
        image = painDimensions['Selected Body Part'];
        if(totalPercentage * 100 /5<=30)
        {
          num=3;
        }
        else if(totalPercentage * 100 /5>30&&totalPercentage * 100 /5<=70)
        {
          num=2;
        }
        else{
          num=1;
        }
          {

          }
      } else {
        print("No data found.");
      }
    } catch (e) {
      print("Error retrieving data: $e");
    }
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uId = prefs.getString('userId');
      if (uId != null) {
        fetchDataFromFirebase();
        getDataFromFirebase(uId!);
      }
    });
  }

  // استرجاع البيانات
  Future<void> fetchDataFromFirebase() async {
    try {
      // استرجاع بيانات المستخدم (تعديل Document ID بما يناسبك)
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('patient')
              .doc(uId) // استبدل patientId بمعرّف المستخدم
              .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          name = data['name'] ?? "Unknown";
          age = data['age'] ?? 0;
          gender = data['gender'] ?? "Unknown";
          diabetes = data['hasDiabetes'] ?? false;
          hypertension = data['hasBloodPressure'] ?? false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
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
            Navigator.pop(context); // Return to the previous page
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.pink),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/contactus'); // Navigate to Contact Us page
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'), // Neuron background image
                fit: BoxFit.cover,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'PainMapper',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Body image and pain score
                  Row(
                    children: [
                      image == 'else'
                          ? Image.asset(
                              'assets/images/else.png', // Placeholder image path
                              height: 150,
                              width: 100,
                            )
                          : image.isNotEmpty
                              ? Image.asset(
                                  'assets/images/$image.$num.png', // Placeholder image path
                                  height: 150,
                                  width: 100,
                                )
                              : Image.asset(
                                  'assets/images/else.png',
                                  // Fallback to 'else.png' when image is null or empty
                                  height: 150,
                                  width: 100,
                                ),
                      const SizedBox(width: 20),
                      // Pain score
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '7 dimensions of pain:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[300],
                              ),
                            ),
                            Text(
                              '${((totalPercentage * 100) /6).round()} %',
                              // Pain percentage
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Patient information
                  Text(
                    'Patient information:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Name: $name',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Age: $age',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gender: $gender',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    diabetes ? 'Diabetes: Yas' : 'Diabetes: No',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hypertension ? 'hypertension: Yas' : 'hypertension: No',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  // Pain dimension details
                  Text(
                    'Pain information:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 20, // المسافة بين العناصر
                    runSpacing: 10, // المسافة بين الصفوف
                    children: painDimensions.entries
                        .where((entry) => entry.key != 'timestamp')
                        .where((entry) => entry.key != 'Selected Body Part')// استبعاد "timestamp"
                        .map((entry) {
                      String value = '';

                      // إذا كانت القيمة رقمية (double)
                      if (entry.value is double) {
                        value = (entry.value * 100).toStringAsFixed(0) + '%'; // عرض النسبة المئوية
                      }
                      // إذا كانت القيمة رقمية وتمثل "Pain Level"
                      else if (entry.key == 'Pain Level') {
                        value = '${entry.value * 10}%'; // ضرب القيمة في 10 وعرض النسبة
                      }
                      // إذا كانت القيمة نصية أو تمثل "Selected Body Part"
                      return _buildPainDimensionItem(entry.key, value);
                    })
                        .toList(),
                  ),

                  const Spacer(),
                  // Records button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/records");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Records',
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
    );
  }

  // Helper method for displaying pain dimensions
  Widget _buildPainDimensionItem(String title, String percentage) {
    return SizedBox(
      width: 150, // Adjust the width as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title == 'Pain Level' ? 'sensory: ' : '$title:',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Text(
            percentage,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
