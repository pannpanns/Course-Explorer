import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'favorites_page.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(
        title: const Text('Tahap 13: Shared State'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),
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
                    return CourseCard(course: provider.courses[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}