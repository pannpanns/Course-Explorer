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
      home: CourseListPage(),
    );
  }
}

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {"code": "MOB01", "title": "Git & GitHub", "status": "Selesai"},
      {"code": "MOB02", "title": "Dart Fundamentals", "status": "Selesai"},
      {"code": "MOB03", "title": "Flutter UI", "status": "Berjalan"},
      {"code": "MOB04", "title": "Navigation", "status": "Rencana"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8: Passing Data')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(course['code']),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailPage(courseData: course),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const CourseDetailPage({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseData['title'])),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kode Mata Kuliah: ${courseData['code']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Status: ${courseData['status']}',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 30),
            const Text(
              'Mahasiswa:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}