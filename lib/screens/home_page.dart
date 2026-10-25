import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_form_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manajemen Course',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$studentName • $studentId',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: provider.loadCourses,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Data',
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CourseFormPage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Builder(
              builder: (context) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return ErrorView(
                    message: provider.error!,
                    onRetry: provider.loadCourses,
                  );
                }
                if (provider.courses.isEmpty) {
                  return const Center(
                    child: Text('Data course belum tersedia'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: provider.loadCourses,
                  child: ListView.builder(
                    itemCount: provider.courses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(course: provider.courses[index]);
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