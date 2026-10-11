import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';
import 'models/course.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Tahap8Page(),
      ),
    ),
  );
}

class Tahap8Page extends StatelessWidget {
  const Tahap8Page({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> jsonMataKuliah = {
      "code": "MOB05",
      "title": "State Management",
      "credits": 3,
      "status": "active"
    };

    final Course course = Course.fromJson(jsonMataKuliah);

    final favoriteCount = context.watch<CourseProvider>().favorites.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8: Model Course')),
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
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Favorit:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$favoriteCount',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.class_, color: Colors.blue),
                title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<CourseProvider>(
                      builder: (context, provider, child) {
                        final isFav = provider.favorites.contains(course.code);
                        return Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.touch_app),
                      onPressed: () {
                        context.read<CourseProvider>().toggleFavorite(course.code);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}