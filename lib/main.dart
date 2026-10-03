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
      home: GridViewPage(),
    );
  }
}

class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

  int columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {"code": "MOB01", "title": "Git & GitHub", "status": "Selesai"},
      {"code": "MOB02", "title": "Dart Fundamentals", "status": "Selesai"},
      {"code": "MOB03", "title": "Flutter UI", "status": "Berjalan"},
      {"code": "MOB04", "title": "Navigation", "status": "Rencana"},
      {"code": "MOB05", "title": "State Management", "status": "Rencana"},
      {"code": "MOB06", "title": "API & Database", "status": "Rencana"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5: GridView Responsif')),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnsFor(constraints.maxWidth),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              course['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(course['code']),
                            const Spacer(),
                            Text(
                              course['status'],
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}