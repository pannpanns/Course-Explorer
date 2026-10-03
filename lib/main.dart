import 'package:flutter/material.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 1: Responsive Problem')),
          body: Center(
          child: Container(
            width: double.infinity, // Berubah jadi fleksibel/responsif
            color: Colors.green[200], 
            padding: const EdgeInsets.all(16),
            child: const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}