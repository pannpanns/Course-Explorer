import 'package:flutter/material.dart';

const String studentName = 'Putu Evan Jagadish Satriana';
const String studentId = '2415051069';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: DebuggingPage(),
));

class DebuggingPage extends StatefulWidget {
  const DebuggingPage({super.key});

  @override
  State<DebuggingPage> createState() => _DebuggingPageState();
}

class _DebuggingPageState extends State<DebuggingPage> {
  bool _isActionRunning = false; 

  void _safeNavigate(BuildContext context) async {
    if (_isActionRunning) return; 

    setState(() {
      _isActionRunning = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aksi dijalankan dengan aman (Klik ganda dicegah)!')),
      );
    }

    setState(() {
      _isActionRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 16: Kasus A, B, C, D')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ============================
            // Solusi Kasus A: RenderFlex Overflow
            // ============================
            const Text('Kasus A: Teks Panjang di Row', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info, color: Colors.blue, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Teks ini sengaja dibuat sangat amat panjang sekali untuk mendemonstrasikan secara jelas dan nyata bagaimana widget Expanded berfungsi di dalam sebuah Row. Jika kita tidak menggunakan widget Expanded, teks yang sangat panjang seperti paragraf ini pasti akan langsung menabrak batas tepi kanan layar emulator Anda dan memunculkan error bergaris kuning-hitam yang dikenal dengan nama peringatan RenderFlex overflow.',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 2),

            // ============================
            // Solusi Kasus B: Vertical Viewport Unbounded
            // ============================
            const Text('Kasus B: ListView Unbounded Height', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Item Data ke-${index + 1}'),
                  ),
                );
              },
            ),
            const Divider(height: 30, thickness: 2),

            // ============================
            // Solusi Kasus D: Navigasi Ganda
            // ============================
            const Text('Kasus D: Navigasi/Klik Ganda', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _safeNavigate(context),
              icon: _isActionRunning 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.touch_app),
              label: Text(_isActionRunning ? 'Memproses...' : 'Uji Klik Cepat Berkali-kali!'),
            ),
            const Divider(height: 30, thickness: 2),

            // ============================
            // Solusi Kasus C: Keyboard Overflow
            // ============================
            const Text('Kasus C: Keyboard Memakan Layar', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Klik untuk tes keyboard',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}