import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<Map<String, dynamic>> records=[];
  String? uId;
  bool isLoading = true; // مؤشر التحميل
  double totalPercentage = 0;

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uId = prefs.getString('userId');
    });
    if (uId != null) {
      await fetchRecords();

    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // إحضار السجلات من Firebase
  Future<void> fetchRecords() async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('patient')
          .doc(uId)
          .collection('dimension')
          .orderBy('timestamp',descending:true)
          .get();
      setState(() {
        records = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        isLoading = false;
        print(records);

      });
    } catch (e) {
      print("Error fetching records: $e");
      setState(() {
        isLoading = false;
      });
    }
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
            Navigator.pop(context); // الرجوع إلى الصفحة السابقة
          },
        ),
      ),
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: isLoading
                ? const CircularProgressIndicator() // عرض مؤشر تحميل أثناء انتظار البيانات
                : records.isEmpty
                ? const Text(
              'No records available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
                : Container(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // الأيقونة
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pink[100],
                    child: const Icon(Icons.library_books,
                        size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // عنوان الصفحة
                  Text(
                    'Records',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // عرض السجلات
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.pink[200]!,
                          ),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.pink[50]),
                              children: [
                                _buildTableHeader('Records'),
                                _buildTableHeader('Date'),
                                _buildTableHeader('Percent'),
                                _buildTableHeader('Details'),
                              ],
                            ),
                            ...records
                                .asMap()
                                .entries
                                .map((entry) => _buildTableRow(entry.value, entry.key, context))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // نص ترحيبي
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

  // إنشاء صف للجدول
  TableRow _buildTableRow(Map<String, dynamic> record, int index, BuildContext context) {
    // تحويل timestamp إلى تاريخ قابل للقراءة
    String formattedDate = record['timestamp'] != null
        ? (record['timestamp'] as Timestamp).toDate().toString().split(' ')[0]
        : 'Unknown';

    return TableRow(
      children: [
        _buildTableCell('Record ${index + 1}'), // عرض الرقم بناءً على الفهرس
        _buildTableCell(formattedDate),
        _buildTableCell((((record['Behavioral'] +
            record['Cognitive'] +
            record['Emotional'] +
            record['Sociocultural'] +
            (record['Pain Level']/10) +
            record['Spiritual']) *
            100 /
            6))
            .toStringAsFixed(0) +
            '%' ??
            '0'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              // عرض التفاصيل عند الضغط
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Details'),
                    content: Text(
                        'Physical: ${record['Selected Body Part'] ?? 'N/A'}\n'
                            'sensory: ${(record['Pain Level']*10)?.toStringAsFixed(0)+'%'?? '0'}\n'
                            'Behavioral: ${(record['Behavioral'] * 100)?.toStringAsFixed(0) + '%' ?? '0'}\n'
                            'Emotional: ${(record['Emotional'] * 100)?.toStringAsFixed(0) + '%' ?? '0'}\n'
                            'Spiritual: ${(record['Spiritual'] * 100)?.toStringAsFixed(0) + '%' ?? '0'}\n'
                            'Cognitive: ${(record['Cognitive'] * 100)?.toStringAsFixed(0) + '%' ?? '0'}\n'
                            'Sociocultural: ${(record['Sociocultural'] * 100)?.toStringAsFixed(0) + '%' ?? '0'}\n'
                            'Date: $formattedDate'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.pink[100],
            ),
            child: const Text('Show', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }



  // إنشاء خلية للجدول
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  // إنشاء رأس الجدول
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.pink[300],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
