import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Course>> _apiCoursesFuture;

  @override
  void initState() {
    super.initState();
    _apiCoursesFuture = fetchCourses();
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('HTTP ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final primaryColor = Theme.of(context).colorScheme.primary;

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
                  'Welcome to\nCourse Data Manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Integrasi REST API & Backend Database pada Flutter.',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    '$studentName • $studentId',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 520) {
                return Column(
                  children: [
                    OverviewCard(
                      icon: Icons.school,
                      title: '${provider.courses.length} Courses',
                      subtitle: 'Tersedia di State Provider',
                    ),
                    const SizedBox(height: 12),
                    OverviewCard(
                      icon: Icons.favorite,
                      title: '${provider.favorites.length} Favorites',
                      subtitle: 'Course Disukai',
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.school,
                      title: '${provider.courses.length} Courses',
                      subtitle: 'Tersedia di State Provider',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.favorite,
                      title: '${provider.favorites.length} Favorites',
                      subtitle: 'Course Disukai',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Daftar Course dari REST API (Tahap 3)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          FutureBuilder<List<Course>>(
            future: _apiCoursesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              final apiCourses = snapshot.data ?? [];
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apiCourses.length,
                itemBuilder: (context, index) {
                  return CourseCard(course: apiCourses[index]);
                },
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

  const OverviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

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
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}