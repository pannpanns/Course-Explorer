import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.courses.isEmpty) return const Center(child: Text('Tidak ada data'));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.courses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) => CourseCard(course: provider.courses[index]),
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
          itemCount: provider.courses.length,
          itemBuilder: (context, index) => CourseCard(course: provider.courses[index]),
        );
      },
    );
  }
}