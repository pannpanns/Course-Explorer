import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    try {
      final data = await supabase
          .from('courses')
          .select()
          .order('id');
      return (data as List)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error (${e.code}): ${e.message}');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Gagal terhubung ke Supabase.');
    }
  }

  @override
  Future<Course> createCourse(Course course) async {
    try {
      final row = await supabase
          .from('courses')
          .insert(course.toJson())
          .select()
          .single();
      return Course.fromJson(row);
    } on PostgrestException catch (e) {
      throw Exception('Gagal menyimpan ke database (${e.code}): ${e.message}');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet saat menyimpan data.');
    }
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    try {
      await supabase
          .from('courses')
          .update(course.toJson())
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Gagal memperbarui database (${e.code}): ${e.message}');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet saat memperbarui data.');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    try {
      await supabase
          .from('courses')
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Gagal menghapus dari database (${e.code}): ${e.message}');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet saat menghapus data.');
    }
  }
}