import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _status = 'planned';
  bool _isSaving = false;

  bool get isEditMode => widget.course != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _codeController.text = widget.course!.code;
      _titleController.text = widget.course!.title;
      _creditsController.text = widget.course!.credits.toString();
      _status = widget.course!.status;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final courseData = Course(
      id: isEditMode ? widget.course!.id : null,
      code: _codeController.text,
      title: _titleController.text,
      credits: int.parse(_creditsController.text),
      status: _status,
    );

    try {
      if (isEditMode) {
        await context.read<CourseProvider>().updateCourse(widget.course!.id!, courseData);
      } else {
        await context.read<CourseProvider>().createCourse(courseData);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode ? 'Course berhasil diperbarui!' : 'Course berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Course' : 'Tambah Course Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Kode Course', border: OutlineInputBorder()),
                enabled: !isEditMode && !_isSaving,
                validator: (value) => value == null || value.isEmpty ? 'Kode tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Course', border: OutlineInputBorder()),
                enabled: !_isSaving,
                validator: (value) => value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'SKS (Credits)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                enabled: !_isSaving,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'SKS tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'SKS harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: _isSaving ? null : (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditMode ? 'Update Course' : 'Simpan Course', style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}