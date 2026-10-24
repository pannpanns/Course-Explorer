import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_form_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Course?'),
        content: Text('Yakin ingin menghapus ${course.code} - ${course.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true) {
        if (!context.mounted) return;
        
        try {
          await context.read<CourseProvider>().deleteCourse(course.id!, course.code);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course berhasil dihapus'), backgroundColor: Colors.green),
          );
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
          );
        }
      }
    });
  }

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
              tooltip: 'Edit',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseFormPage(course: course)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Hapus',
              onPressed: () => _confirmDelete(context),
            ),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              tooltip: 'Favorite',
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