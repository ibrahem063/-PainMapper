import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/resultpage.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart'; // تأكد من استيراد صفحة ResultPage

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String? uId;
  int? selectedPainLevel=0;
  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uId = prefs.getString('userId');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    getSelectedPainLevel();
  }

  Future<void> getSelectedPainLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      selectedPainLevel= prefs.getInt('pain level');
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.pink),
            onPressed: () {
              Navigator.pushNamed(context, '/contactus'); // الانتقال إلى صفحة Contact Us
            },
          ),
        ],
      ),
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
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Seven Dimensions of Pain',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                  const SizedBox(height: 70),
                  const Text(
                    'Scan QR code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Present this code to the doctor to view your results',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if(selectedPainLevel!<=3)
                    Container(
                      width: 120,
                      height: 40,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      
                      child:Text('Low Pain',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                    )
                  else if(selectedPainLevel!>3&&selectedPainLevel!<=7)
                    Container(
                      width: 120,
                      height: 40,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)
                      ),

                      child: Text('Medium Pain',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                    )
                  else if(selectedPainLevel!>7)
                      Container(
                        width: 120,
                        height: 40,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                        ),

                        child:Text('High Pain',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                      ),
                  const SizedBox(height: 50),

                  // عرض QR فقط إذا كانت uId متوفرة
                  uId != null
                      ? PrettyQr(
                    data: uId!,
                    size: 200,
                    roundEdges: true,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    elementColor: Colors.black,
                    typeNumber: 3,
                  )
                      : CircularProgressIndicator(
                    color:Colors.pink[300] ,
                  ), // مؤشر انتظار إذا كانت uId لم يتم جلبها بعد

                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResultPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('View Result', style: TextStyle(fontSize: 18)),
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

