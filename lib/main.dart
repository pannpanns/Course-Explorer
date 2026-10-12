import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  final service = CourseService();
  final repository = CourseRepository(service);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(repository),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Tahap11Page(),
      ),
    ),
  );
}

class Tahap11Page extends StatefulWidget {
  const Tahap11Page({super.key});

  @override
  State<Tahap11Page> createState() => _Tahap11PageState();
}

class _Tahap11PageState extends State<Tahap11Page> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 11: Async State')),
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
            if (provider.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (provider.error != null)
              Expanded(child: Center(child: Text('Error: ${provider.error}')))
            else if (provider.courses.isEmpty)
              const Expanded(child: Center(child: Text('Tidak ada data course')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    final isFav = provider.favorites.contains(course.code);
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.class_, color: Colors.blue),
                        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            context.read<CourseProvider>().toggleFavorite(course.code);
                          },
                        ),
                      ),
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