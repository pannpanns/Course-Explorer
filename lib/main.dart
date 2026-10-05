import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);

    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
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
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
      home: const ResponsiveShell(),
    );
  }
}

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _coursesData = [];
  bool _isLoading = true;

  final List<String> _titles = [
    'Course Explorer',
    'All Courses',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _loadCoursesFromJson();
  }

  Future<void> _loadCoursesFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> data = jsonDecode(response);
      setState(() {
        _coursesData = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<Widget> pages = [
      HomePage(courses: _coursesData),
      CoursesPage(courses: _coursesData),
      const ProfilePage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isExpanded = constraints.maxWidth >= 840;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 16, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 6),
                    Text(
                      '$studentName ($studentId)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: isExpanded
              ? Row(
                  children: [
                    NavigationRail(
                      backgroundColor: Colors.white,
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.school_outlined),
                          selectedIcon: Icon(Icons.school),
                          label: Text('Courses'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: Text('Profile'),
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                    ),
                    Expanded(
                      child: pages[_selectedIndex],
                    ),
                  ],
                )
              : pages[_selectedIndex],
          bottomNavigationBar: isExpanded
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: 'Courses',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      label: 'Profile',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;

  const HomePage({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final int completedCount = courses.where((c) => c['status'] == 'Selesai').length;

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
                colors: [
                  primaryColor,
                  const Color(0xFF7C3AED),
                ],
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
                  child: Icon(
                    Icons.explore,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Welcome to\nCourse Explorer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Temukan berbagai course pembelajaran mobile.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    '$studentName • $studentId',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 520) {
                return Column(
                  children: [
                    OverviewCard(
                      icon: Icons.school,
                      title: '${courses.length} Courses',
                      subtitle: 'Tersedia di Platform',
                    ),
                    const SizedBox(height: 12),
                    OverviewCard(
                      icon: Icons.task_alt,
                      title: '$completedCount Selesai',
                      subtitle: 'Status Pembelajaran',
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.school,
                      title: '${courses.length} Courses',
                      subtitle: 'Tersedia di Platform',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.task_alt,
                      title: '$completedCount Selesai',
                      subtitle: 'Status Pembelajaran',
                    ),
                  ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
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
              child: Icon(
                icon,
                color: primaryColor,
              ),
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
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
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

class CoursesPage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;

  const CoursesPage({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 14);
            },
            itemBuilder: (context, index) {
              return CourseCard(
                course: courses[index],
              );
            },
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
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return CourseCard(
              course: courses[index],
            );
          },
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({
    super.key,
    required this.course,
  });

  Color getStatusColor() {
    if (course['status'] == 'Selesai') {
      return Colors.green;
    }

    if (course['status'] == 'Berjalan') {
      return Colors.orange;
    }

    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final statusColor = getStatusColor();

    return Card(
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailPage(
                course: course,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.school,
                      color: primaryColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      course['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                course['code'],
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                course['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                course['desc'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    const Color(0xFF7C3AED),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 44,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.course['code'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.course['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Course',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    DetailRow(
                      icon: Icons.tag,
                      label: 'Kode',
                      value: widget.course['code'],
                    ),
                    DetailRow(
                      icon: Icons.info_outline,
                      label: 'Status',
                      value: widget.course['status'],
                    ),
                    DetailRow(
                      icon: Icons.description_outlined,
                      label: 'Deskripsi',
                      value: widget.course['desc'],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mahasiswa',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIM: $studentId',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        isFavorite
                            ? 'Course ditambahkan ke favorite.'
                            : 'Course dihapus dari favorite.',
                      ),
                    ),
                  );
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                  isFavorite
                      ? 'Favorite Aktif'
                      : 'Tambah ke Favorite',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(text: studentName);

  final TextEditingController _nimController =
      TextEditingController(text: studentId);

  final TextEditingController _commentController =
      TextEditingController();

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Feedback Terkirim'),
          content: Text(
            'Terima kasih, ${_nameController.text}!\nFeedback Anda: "${_commentController.text}" berhasil dikirim.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _commentController.clear();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: primaryColor,
                    backgroundImage: const AssetImage('assets/images/profile.jpg'),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profil Mahasiswa',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          studentName,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          studentId,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Feedback',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Berikan pendapat Anda mengenai aplikasi ini.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _nameController,
              label: 'Nama',
              hint: 'Nama mahasiswa',
              readOnly: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _nimController,
              label: 'NIM',
              hint: 'NIM mahasiswa',
              readOnly: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _commentController,
              label: 'Komentar',
              hint: 'Masukkan minimal 5 karakter',
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().length < 5) {
                  return 'Komentar minimal 5 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool readOnly;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      validator: validator,
    );
  }
}