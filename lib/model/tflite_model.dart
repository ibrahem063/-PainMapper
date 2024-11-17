import 'package:tflite_flutter/tflite_flutter.dart';

class EEGModel {
  Interpreter? _interpreter;

  // تحميل النموذج من ملف محلي
  Future<void> loadModel() async {
    try {
      // تمكين Flex Delegate

      // تحميل النموذج مع Flex Delegate
      _interpreter = await Interpreter.fromAsset('assets/model.tflite',);
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // إجراء التنبؤ باستخدام النموذج
  Future<void> predict(List<List<List<double>>> eegData) async {
    try {
      // تحويل البيانات إلى شكل مناسب للمدخلات في النموذج
      var input = eegData;  // يجب تنسيقها حسب ما يتطلبه النموذج

      var output = List.filled(1, List.filled(10, 0.0));  // استبدل 10 بحجم النتيجة المطلوبة
      _interpreter?.run(input, output);

      print("Prediction result: $output");
    } catch (e) {
      print("Error during prediction: $e");
    }
  }
}
