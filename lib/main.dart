import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_application_2/pages/behavioralpage.dart';
import 'package:flutter_application_2/pages/cognitivepage.dart';
import 'package:flutter_application_2/pages/contactus.dart';
import 'package:flutter_application_2/pages/dimensionpage.dart';
import 'package:flutter_application_2/pages/eegsignalspage.dart';
import 'package:flutter_application_2/pages/emotionalpage.dart';
import 'package:flutter_application_2/pages/homepage.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:flutter_application_2/pages/myprofile.dart';
import 'package:flutter_application_2/pages/physicaldimensionpage.dart';
import 'package:flutter_application_2/pages/qrcodepage.dart';
import 'package:flutter_application_2/pages/question.dart';
import 'package:flutter_application_2/pages/recordspage.dart';
import 'package:flutter_application_2/pages/resultpage.dart';
import 'package:flutter_application_2/pages/settingpage.dart';
import 'package:flutter_application_2/pages/seven_dimensions_page.dart';
import 'package:flutter_application_2/pages/sighnup.dart';
import 'package:flutter_application_2/pages/socioculturalpage.dart';
import 'package:flutter_application_2/pages/spiritualpage.dart';
import 'package:flutter_application_2/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const Welcome(),
        "/login": (context) =>  Login(),
        "/sighnup": (context) => const SighnUp(),
        "/home": (context) => const HomePage(),
        "/seven_dimensions": (context) => const SevenDimensionsPage(),
        "/contactus": (context) => const ContactUs(),
        "/myprofile": (context) => const MyProfile(),
        "/setting": (context) => const SettingPage(), // صفحة الإعدادات
        "/records": (context) => RecordsPage(),
        "/behavioral": (context) => const BehavioralPage(),
        "/sociocultural": (context) => const SocioculturalPage(),
        "/Cognitive": (context) => const CognitivePage(),
        "/emotional": (context) => const EmotionalPage(),
        "/spiritual": (context) => const SpiritualPage(),
        "/eegsignalspage": (context) => EEGSignalsPage(),
        "/physical": (context) => PhysicalDimensionPage(),
        "/qrcode": (context) => QRCodePage(),
        "/result": (context) => const ResultPage(),
        "/dimension": (context) => DimensionPage(
              title: 'Dimension Title Here',
              questions: [
                Question(
                  text: 'Sample question text',
                  label1: 'Label 1',
                  label5: 'Label 5',
                ),
              ],
            ), // إضافة صفحة DimensionPage في التوجيهات
      },
    );
  }
}
