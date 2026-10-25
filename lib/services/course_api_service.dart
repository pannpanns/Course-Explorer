
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  final String baseUrl;

  CourseApiService(this.baseUrl);

  @override
  Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body) as List<dynamic>;

        return data
            .map(
              (e) => Course.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception(
          'HTTP 404: Endpoint tidak ditemukan. '
          'Periksa kembali URL dan path API.',
        );
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: '
          'Gagal mengambil data dari REST API.',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    } on FormatException {
      throw Exception(
        'Format response bukan JSON yang valid.',
      );
    }
  }

  @override
  Future<Course> createCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(course.toJson()),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return Course.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      throw Exception(
        'HTTP ${response.statusCode}: Gagal membuat course.',
      );
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet saat mengirim data.',
      );
    }
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/courses/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(course.toJson()),
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'HTTP ${response.statusCode}: '
          'Gagal memperbarui course.',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet saat memperbarui data.',
      );
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/courses/$id'),
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'HTTP ${response.statusCode}: '
          'Gagal menghapus course.',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet saat menghapus data.',
      );
    }
  }
}
