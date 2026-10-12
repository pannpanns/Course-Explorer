import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'screens/main_screen.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';
const Color primaryColor = Color(0xFF4F46E5);

void main() {
  final service = CourseService();
  final repository = CourseRepository(service);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(repository),
      child: MaterialApp(
        title: 'Course Explorer V2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1F2937),
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        home: const MainScreen(),
      ),
    ),
  );
}