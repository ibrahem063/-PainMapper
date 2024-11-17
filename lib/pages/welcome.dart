import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    // الانتقال إلى الصفحة الثانية بعد 3 ثوانٍ
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, "/login"); // الانتقال إلى الصفحة الثانية
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // اللوحة البيضاء الشفافة
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // قسم الشعار
                  Image.asset(
                    'assets/images/Mapper.png', // ضع هنا مسار الصورة للشعار
                    height: 300, // تعديل حسب الحاجة
                  ),
                  const SizedBox(height: 60),
                  // النص "PainMapper" مع خطوط فوق وتحت
                  Column(
                    children: [
                      Divider(
                        color: Colors.pink[300],
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Text(
                        'PainMapper',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[400],
                        ),
                      ),
                      Divider(
                        color: Colors.pink[300],
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // النص الترحيبي
                  Text(
                    'Welcome to PainMapper',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.pink[300],
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
}
