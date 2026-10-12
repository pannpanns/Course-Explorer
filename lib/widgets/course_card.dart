import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  Color getStatusColor() {
    if (course.status.toLowerCase() == 'selesai') return Colors.green;
    if (course.status.toLowerCase() == 'berjalan' || course.status.toLowerCase() == 'active') return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final statusColor = getStatusColor();
    final isFav = context.watch<CourseProvider>().favorites.contains(course.code);

    return Card(
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                    child: Icon(Icons.school, color: primaryColor),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
                    onPressed: () => context.read<CourseProvider>().toggleFavorite(course.code),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(course.code, style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(course.status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(course.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${course.credits} SKS', style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}