import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../main.dart'; 

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return Center(child: Text('Error: ${provider.error}'));

    final int activeCount = provider.courses.where((c) => c.status.toLowerCase() == 'active').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, const Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.explore, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Welcome to\nCourse Explorer V2',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.15),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kelola state management pada aplikasi mobile.',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
                  child: const Text(
                    '$studentName • $studentId',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 520) {
                return Column(
                  children: [
                    OverviewCard(icon: Icons.school, title: '${provider.courses.length} Courses', subtitle: 'Tersedia di Data'),
                    const SizedBox(height: 12),
                    OverviewCard(icon: Icons.favorite, title: '${provider.favorites.length} Favorites', subtitle: 'Course Disukai'),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: OverviewCard(icon: Icons.school, title: '${provider.courses.length} Courses', subtitle: 'Tersedia di Data')),
                  const SizedBox(width: 12),
                  Expanded(child: OverviewCard(icon: Icons.favorite, title: '${provider.favorites.length} Favorites', subtitle: 'Course Disukai')),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const OverviewCard({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}