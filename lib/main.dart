import 'package:flutter/material.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilderPage(),
    );
  }
}

class LayoutBuilderPage extends StatelessWidget {
  const LayoutBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: LayoutBuilder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const CompactLayout();
          } else if (constraints.maxWidth < 840) {
            return const MediumLayout();
          } else {
            return const ExpandedLayout();
          }
        },
      ),
    );
  }
}

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[100],
      width: double.infinity,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$studentId - $studentName', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Compact Layout', style: TextStyle(fontSize: 24, color: Colors.red)),
          Icon(Icons.smartphone, size: 64, color: Colors.red),
        ],
      ),
    );
  }
}

// 2. Tampilan Medium (Tablet Kecil / Landscape Phone)
class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      width: double.infinity,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$studentId - $studentName', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Medium Layout', style: TextStyle(fontSize: 28, color: Colors.orange)),
          Icon(Icons.tablet_mac, size: 80, color: Colors.orange),
        ],
      ),
    );
  }
}

// 3. Tampilan Expanded (Desktop / Tablet Besar)
class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
      width: double.infinity,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.desktop_windows, size: 100, color: Colors.green),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$studentId - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Expanded Layout', style: TextStyle(fontSize: 32, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }
}