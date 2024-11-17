class DimensionResult {
  String title;
  double output;

  DimensionResult({required this.title, required this.output});

  Map<String, dynamic> toMap() {
    return {
      title: output,
    };
  }
}
