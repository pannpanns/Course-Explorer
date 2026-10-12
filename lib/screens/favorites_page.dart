import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favoriteCourses = provider.courses
        .where((course) => provider.favorites.contains(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites Page')),
      body: favoriteCourses.isEmpty
          ? const Center(child: Text('Belum ada course favorit'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: favoriteCourses[index]);
              },
            ),
    );
  }
}