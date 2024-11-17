import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            Navigator.pop(context); // الرجوع إلى الصفحة السابقة
          },
        ),
      ),
      body: Stack(
        children: [
          // الخلفية العصبية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/background.png'), // خلفية الأعصاب
                fit: BoxFit.cover,
              ),
            ),
          ),
          // اللوح الأبيض في وسط الشاشة
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(0.9), // جعل اللوح أبيض شفاف قليلاً
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // جعل العناصر تبدأ من الأعلى
                children: [
                  // نص "Contact Us"
                  Center(
                    child: Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // النص الوصفي
                  Text(
                    'We believe in the power of PainMapper to improve people\'s lives and facilitate daily tasks. Therefore, we work diligently to develop our application that meets users\' needs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  // بيانات الاتصال
                  const Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.pink),
                        title: Text('PainMapper@gmail.com'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.pink),
                        title: Text('+966 599536193'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
