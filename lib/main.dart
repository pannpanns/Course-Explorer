import 'package:flutter/material.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Tahap3Page(),
  ));
}

class Tahap3Page extends StatefulWidget {
  const Tahap3Page({super.key});

  @override
  State<Tahap3Page> createState() => _Tahap3PageState();
}

class _Tahap3PageState extends State<Tahap3Page> {
  final Set<String> _favoriteCourseCodes = {};

  final List<Map<String, String>> _courses = [
    {'code': 'MOB05', 'title': 'State Management'},
    {'code': 'MOB06', 'title': 'Local Storage'},
  ];

  void _toggleFavorite(String code) {
    setState(() {
      if (_favoriteCourseCodes.contains(code)) {
        _favoriteCourseCodes.remove(code);
      } else {
        _favoriteCourseCodes.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: Lifting State Up')),
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
            CourseSummary(favoriteCount: _favoriteCourseCodes.length),
            const SizedBox(height: 16),
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  final isFav = _favoriteCourseCodes.contains(course['code']);
                  return CourseCard(
                    title: course['title']!,
                    code: course['code']!,
                    isFavorite: isFav,
                    onFavoriteChanged: () => _toggleFavorite(course['code']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseSummary extends StatelessWidget {
  final int favoriteCount;

  const CourseSummary({super.key, required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Favorit (Single Source of Truth):',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              '$favoriteCount',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String code;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.title,
    required this.code,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: const Icon(Icons.menu_book, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(code),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onFavoriteChanged,
        ),
      ),
    );
  }
}