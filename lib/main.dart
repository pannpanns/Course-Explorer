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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScrollablePage(),
    );
  }
}

class ScrollablePage extends StatelessWidget {
  const ScrollablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6: Scrollable Content')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: const Text('Konten Bagian Atas', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              color: Colors.orange[100],
              alignment: Alignment.center,
              child: const Text('Konten Bagian Tengah', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Klik untuk buka keyboard...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              color: Colors.green[100],
              alignment: Alignment.center,
              child: const Text('Konten Bagian Bawah', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}