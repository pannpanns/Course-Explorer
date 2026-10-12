import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favoriteCourses = provider.courses.where((c) => provider.favorites.contains(c.code)).toList();

    if (favoriteCourses.isEmpty) return const Center(child: Text('Belum ada course favorit'));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteCourses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) => CourseCard(course: favoriteCourses[index]),
          );
        }

        final int columns = constraints.maxWidth < 840 ? 2 : 3;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 215,
          ),
          itemCount: favoriteCourses.length,
          itemBuilder: (context, index) => CourseCard(course: favoriteCourses[index]),
        );
      },
    );
  }
}