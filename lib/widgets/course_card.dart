import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_form_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<CourseProvider>().favorites.contains(course.code);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: const Icon(Icons.class_, color: Colors.blue),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${course.code} • ${course.credits} SKS\nStatus: ${course.status}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseFormPage(course: course)),
                );
              },
            ),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                context.read<CourseProvider>().toggleFavorite(course.code);
              },
            ),
          ],
        ),
      ),
    );
  }
}