import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? uId;

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uId = prefs.getString('userId');
      print(uId);
    });

    // التحقق من أن uId ليس null قبل محاولة جلب البيانات
    if (uId != null) {
      await fetchDataFromFirebase();
    } else {
      print("userId غير موجود في SharedPreferences");
    }
  }

  Future<void> fetchDataFromFirebase() async {
    if (uId == null) return; // التأكد مرة أخرى أن uId ليس null

    final userDoc = await FirebaseFirestore.instance
        .collection('patient')
        .doc(uId)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      nameController.text = data['name'] ?? "User Name";
      numberController.text = data['phone'] ?? "0000000000";
      genderController.text = data['gender'] ?? "Not Specified";
      ageController.text = data['age']?.toString() ?? "Not Specified";
      nationalityController.text = data['nationality'] ?? "Not Specified";
      birthdateController.text = data['birthDate'] ?? "Not Specified";
      passwordController.text = data['password'] ?? "********";
    } else {
      print("لم يتم العثور على مستند المستخدم");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }


  Future<void> updateProfile() async {
    if (uId == null) {
      print("User ID is null.");
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('patient').doc(uId);

    // تحقق مما إذا كانت الوثيقة موجودة
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      // إذا لم تكن موجودة، يمكنك إنشاء واحدة جديدة
      await userDoc.set({
        'name': nameController.text,
        'phone': numberController.text,
        'gender': genderController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'nationality': nationalityController.text,
        'birthDate': birthdateController.text,
        'password': passwordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile created successfully!')),
      );
    } else {
      // إذا كانت موجودة، قم بتحديثها
      await userDoc.update({
        'name': nameController.text,
        'phone': numberController.text,
        'gender': genderController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'nationality': nationalityController.text,
        'birthDate': birthdateController.text,
        'password': newPasswordController.text.isNotEmpty ? newPasswordController.text : passwordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }



  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
      body: FutureBuilder(
        future: fetchDataFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: Colors.pink[300],
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }


          return Stack(
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
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.pink[100],
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'My Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // بيانات المستخدم
                      _buildEditableInfoRow('Name:', nameController),
                      _buildEditableInfoRow('Number:', numberController),
                      _buildEditableInfoRow('Gender:', genderController),
                      _buildEditableInfoRow('Age:', ageController),
                      _buildEditableInfoRow('Nationality:', nationalityController),
                      _buildEditableInfoRow('BirthDate:', birthdateController,
                          functino:() {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.utc(2006),
                                firstDate: DateTime.utc(1900),
                                lastDate: DateTime.parse('2050-05-03'),
                              ).then((value) {
                                if (value != null) {
                                  birthdateController.text = DateFormat.yMd().format(value).toString();
                                }
                              });
                          }, ),
                      _buildEditableInfoRow('Password:', passwordController,
                          isPassword: true),
                      if (isEditing) ...[
                        _buildEditableInfoRow(
                            'New Password:', newPasswordController,
                            isPassword: true),
                        _buildEditableInfoRow(
                            'Confirm Password:', confirmPasswordController,
                            isPassword: true),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // الانتقال إلى صفحة السجلات RecordsPage
                          Navigator.pushNamed(context, '/records');
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          backgroundColor: Colors.pink[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Records',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome to PainMapper',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.pink[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditing = !isEditing; // عكس حالة التعديل

            if (!isEditing) {
              updateProfile();
              // إذا كان المستخدم قد انتهى من التعديل، تحقق من صحة كلمات المرور
            }
          });
        },
        backgroundColor: Colors.pink[300],
        child: Icon(isEditing ? Icons.save : Icons.edit),
      ),
    );
  }

  // دالة لإنشاء صف من المعلومات الشخصية القابلة للتعديل
  Widget _buildEditableInfoRow(String label, TextEditingController controller,
      {bool isPassword = false,Function()? functino} ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onTap:functino  ,
              controller: controller,
              obscureText: isPassword,
              readOnly: !isEditing,
              decoration: InputDecoration(
                border: isEditing ? const UnderlineInputBorder() : InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
