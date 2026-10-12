import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';
import 'models/course.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Tahap10Page(),
      ),
    ),
  );
}

class Tahap10Page extends StatefulWidget {
  const Tahap10Page({super.key});

  @override
  State<Tahap10Page> createState() => _Tahap10PageState();
}

class _Tahap10PageState extends State<Tahap10Page> {
  late final CourseRepository _repository;
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    final service = CourseService();
    _repository = CourseRepository(service);
    _coursesFuture = _repository.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 10: Repository Pattern')),
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
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data course'));
                  }

                  final courses = snapshot.data!;
                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.class_, color: Colors.blue),
                          title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
                        ),
                      );
                    },
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