import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:intl/intl.dart';

class SighnUp extends StatefulWidget {
  const SighnUp({super.key});

  @override
  _SighnUpState createState() => _SighnUpState();
}

class _SighnUpState extends State<SighnUp> {
  bool hasDiabetes = false;
  bool hasBloodPressure = false;

  // استخدام GlobalKey لـ FormState
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  Future<void> signUp() async {
    // التحقق من صحة البيانات قبل التسجيل
    if (_formKey.currentState?.validate() ?? false) {
      // التحقق من تطابق كلمتي المرور
      if (passwordController.text != confirmPasswordController.text) {
        // إظهار رسالة خطأ إذا لم تتطابق كلمتا المرور
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Passwords do not match'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // إنشاء حساب مستخدم جديد في Firebase Authentication
      try {
        String password = passwordController.text.trim();
        String email = emailController.text;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // تخزين بيانات المستخدم في Firestore
        await FirebaseFirestore.instance
            .collection('patient')
            .doc(userCredential.user!.uid)
            .set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'gender': genderController.text.trim(),
          'age': int.parse(ageController.text.trim()),
          'nationality': nationalityController.text.trim(),
          'birthDate': birthDateController.text.trim(),
          'hasDiabetes': hasDiabetes,
          'hasBloodPressure': hasBloodPressure,
        });

        // الانتقال إلى صفحة تسجيل الدخول بعد إتمام التسجيل
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred, please try again.';
        if (e.code == 'email-already-in-use') {
          message = 'The ID is already in use.';
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Form(
              key: _formKey, // إضافة FormKey
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Sign Up" text
                      Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[300],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // حقول التسجيل مع Validator
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'First & Last name',
                          hintText: 'John Doe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@domain.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '05XXXXXXXX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          // التحقق من أن الرقم يتكون من 10 أرقام
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Please enter a valid phone number with 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Gender and Age fields
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: genderController.text.isNotEmpty
                                  ? genderController.text
                                  : null,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Male', child: Text('Male')),
                                DropdownMenuItem(
                                    value: 'Female', child: Text('Female')),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  genderController.text = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your gender';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: ageController,
                              decoration: InputDecoration(
                                labelText: 'Age',
                                hintText: 'e.g., 25',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your age';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid age';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nationalityController,
                        decoration: InputDecoration(
                          labelText: 'Nationality',
                          hintText: 'e.g., Saudi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              nationalityController.text = country.name;
                            },
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your nationality';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: birthDateController,
                        decoration: InputDecoration(
                          labelText: 'Birth Date',
                          hintText: 'yyyy-mm-dd',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            birthDateController.text =
                                DateFormat('yyyy-MM-dd').format(date);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your birth date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Password fields
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      // Diabetes question
                      const Text(
                        'Do you have diabetes?',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text('Yes'),
                              value: true,
                              groupValue: hasDiabetes,
                              onChanged: (value) {
                                setState(() {
                                  hasDiabetes = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text('No'),
                              value: false,
                              groupValue: hasDiabetes,
                              onChanged: (value) {
                                setState(() {
                                  hasDiabetes = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      // Blood pressure question
                      const Text(
                        'Do you have high blood pressure?',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text('Yes'),
                              value: true,
                              groupValue: hasBloodPressure,
                              onChanged: (value) {
                                setState(() {
                                  hasBloodPressure = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text('No'),
                              value: false,
                              groupValue: hasBloodPressure,
                              onChanged: (value) {
                                setState(() {
                                  hasBloodPressure = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: signUp,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.pink[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
