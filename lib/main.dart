import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Tahap6Page(),
      ),
    ),
  );
}

class Tahap6Page extends StatelessWidget {
  const Tahap6Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6: Setup Provider')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'ChangeNotifierProvider berhasil dipasang!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}