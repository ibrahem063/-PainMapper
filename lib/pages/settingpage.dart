import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error during logout: $e');
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
          // اللوح الأبيض في الوسط
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // الأيقونة في الجزء العلوي
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pink[100],
                    child: const Icon(Icons.settings, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // عنوان الصفحة "Setting"
                  Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // زر "My Record"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // الانتقال إلى صفحة RecordsPage عند النقر على "My Records"
                          Navigator.pushNamed(context, "/records");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.pink[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'My Record',
                          style:
                              TextStyle(fontSize: 18, color: Colors.pink[300]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // زر "Edit Profile"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // الانتقال إلى صفحة MyProfile عند النقر على "Edit Profile"
                          Navigator.pushNamed(context, "/myprofile");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.pink[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style:
                              TextStyle(fontSize: 18, color: Colors.pink[300]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // زر "Logout"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _logout();
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.pink[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // نص في الأسفل
                  Text(
                    'Welcome to PainMapper',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink[300],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
