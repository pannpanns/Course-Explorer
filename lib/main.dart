import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart'; // Import service baru
import 'screens/main_screen.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';
const Color primaryColor = Color(0xFF4F46E5);

// Base URL tanpa akhiran /courses
const String apiBaseUrl = 'https://course-api-pearl.vercel.app'; 

void main() {
  // Hubungkan API Service ke Repository
  final service = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(service);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Data Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1F2937),
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}