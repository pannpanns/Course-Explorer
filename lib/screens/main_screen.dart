import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../main.dart'; 
import 'dashboard_page.dart';
import 'home_page.dart';
import 'favorites_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = ['Course Explorer V2', 'All Courses', 'Favorites'];
  final List<Widget> _pages = const [DashboardPage(), HomePage(), FavoritesPage()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isExpanded = constraints.maxWidth >= 840;
        final bool showFullProfile = constraints.maxWidth >= 600; 

        return Scaffold(
          appBar: AppBar(
            title: Text(_titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: EdgeInsets.symmetric(horizontal: showFullProfile ? 10 : 8, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 16, color: primaryColor),
                    if (showFullProfile) ...[
                      const SizedBox(width: 6),
                      const Text(
                        '$studentName ($studentId)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor),
                      ),
                    ]
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
                      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                        NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: Text('Courses')),
                        NavigationRailDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: Text('Favorites')),
                      ],
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: _pages[_selectedIndex]),
                  ],
                )
              : _pages[_selectedIndex],
          bottomNavigationBar: isExpanded
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                    NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Favorites'),
                  ],
                ),
        );
      },
    );
  }
}