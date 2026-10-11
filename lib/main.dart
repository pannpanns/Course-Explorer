import 'package:flutter/material.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Tahap2Page(),
  ));
}

class Tahap2Page extends StatefulWidget {
  const Tahap2Page({super.key});

  @override
  State<Tahap2Page> createState() => _Tahap2PageState();
}

class _Tahap2PageState extends State<Tahap2Page> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2: Masalah setState')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CourseSummary(isFavorite: isFavorite),
            const SizedBox(height: 16),
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            CourseItem(
              title: 'State Management & Architecture',
              code: 'MOB05',
              isFavorite: isFavorite,
              onFavoriteToggle: toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}

class CourseSummary extends StatelessWidget {
  final bool isFavorite;

  const CourseSummary({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Course Favorit:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '${isFavorite ? 1 : 0}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final String title;
  final String code;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CourseItem({
    super.key,
    required this.title,
    required this.code,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.menu_book, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(code),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}