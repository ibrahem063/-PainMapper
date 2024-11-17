import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/myprofile.dart';
import 'package:flutter_application_2/pages/settingpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
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
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // أيقونة الملف الشخصي في الأعلى
          Positioned(
            top: 30,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfile(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.pink[100],
                child: const Icon(Icons.person, size: 30, color: Colors.white),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار
                  Image.asset(
                    'assets/images/Mapper.png',
                    height: 300,
                  ),
                  const SizedBox(height: 30),
                  // زر Ready
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/seven_dimensions");
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                      backgroundColor: Colors.pink[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Ready',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // زر Contact us
                  SizedBox(
                    width: double.infinity, // العرض بالكامل
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/contactus");
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Contact us'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.pink[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // زر Settings
                  SizedBox(
                    width: double.infinity, // العرض بالكامل
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.pink[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // النص الترحيبي في الأسفل
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Welcome to PainMapper',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.pink[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
