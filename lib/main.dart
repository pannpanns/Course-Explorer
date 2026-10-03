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
      home: ExpandedWrapPage(),
    );
  }
}

class ExpandedWrapPage extends StatelessWidget {
  const ExpandedWrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> skills = [
      'Flutter', 'Dart', 'Firebase', 'Git', 'UI/UX', 'REST API', 'JSON'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4: Expanded & Wrap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text('Expanded Layout (Flex 2:1):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 80,
                    color: Colors.blue[300],
                    alignment: Alignment.center,
                    child: const Text('Flex: 2', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1, // Mengambil 1 bagian ruang
                  child: Container(
                    height: 80,
                    color: Colors.orange[300],
                    alignment: Alignment.center,
                    child: const Text('Flex: 1', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Uji Coba Wrap untuk kumpulan Chip
            const Text('Wrap Layout (Skills):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0, // Jarak antar Chip secara horizontal
              runSpacing: 8.0, // Jarak antar Chip secara vertikal
              children: skills.map((e) => Chip(label: Text(e))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}