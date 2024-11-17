import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EEGSignalsPage extends StatefulWidget {
  const EEGSignalsPage({super.key});

  @override
  _EEGSignalsPageState createState() => _EEGSignalsPageState();
}

class _EEGSignalsPageState extends State<EEGSignalsPage> {
  bool isRecording = false;
  bool isLoading = false;
  bool isOptionSelected = false;
  String? selectedOption;
  int? painLevel;

  void startRecording() {
    setState(() {
      isRecording = true;
      isLoading = true;
      selectedOption = 'record';

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void uploadRecording() {
    setState(() {
      selectedOption = 'upload';
      isLoading = false;
    });
  }

  void submitPainLevel() {
    setState(() {
      selectedOption = 'manual';
      isLoading = false;
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
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.pink[50],
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
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Sensory Dimensions',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[300],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.85,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'EEG Signals',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[300],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Choose an option to proceed:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Divider(height: 40, color: Colors.grey[300]),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOptionButton(
                                context,
                                'Start Recording',
                                Icons.play_arrow,
                                    () {
                                  setState(() {
                                    isOptionSelected = true;
                                    startRecording();
                                  });
                                },
                              ),
                              _buildOptionButton(
                                context,
                                'Upload Recording',
                                Icons.upload_file,
                                    () {
                                  setState(() {
                                    isOptionSelected = true;
                                    uploadRecording();
                                  });
                                },
                              ),
                              _buildOptionButton(
                                context,
                                'Enter Pain Level Manually',
                                Icons.edit,
                                    () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title:
                                            const Text('Enter Pain Level'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                    'Select your pain level from 1 to 10:'),
                                                Slider(
                                                  value: (painLevel ?? 1)
                                                      .toDouble(),
                                                  min: 1,
                                                  max: 10,
                                                  divisions: 9,
                                                  label: (painLevel ?? 1)
                                                      .toString(),
                                                  onChanged: (double value) {
                                                    setState((){
                                                      painLevel = value.toInt();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  submitPainLevel();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 40, color: Colors.grey[300]),
                        if (isOptionSelected && isLoading)
                          Column(
                            children: [
                              Text(
                                'LOADING ...',
                                style: TextStyle(
                                  color: Colors.pink[300],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                color: Colors.black,
                              ),
                            ],
                          )
                        else if (selectedOption == 'record' && !isLoading)
                          const Text(
                            'Recording Completed',
                            style: TextStyle(color: Colors.green),
                          )
                        else if (selectedOption == 'upload' && !isLoading)
                            const Text(
                              'Upload Completed',
                              style: TextStyle(color: Colors.green),
                            )
                          else if (selectedOption == 'manual' && !isLoading)
                              Text(
                                'Pain Level Recorded: ${painLevel ?? 1}',
                                style: const TextStyle(color: Colors.green),
                              ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed:() async{
                            Navigator.pushReplacementNamed(
                                context, '/seven_dimensions');
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if (painLevel != null) {
                              prefs.setInt('pain level', painLevel!);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[300],
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 40,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('DONE',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.pink[300],
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
