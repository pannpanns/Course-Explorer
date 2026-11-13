import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../services/kos_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserProfile?> _profileFuture;
  late Future<List<Map<String, dynamic>>> _kosFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _profileFuture = ProfileService().getMyProfile();
    _kosFuture = KosService().fetchAll();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _showAddDialog() async {
    final nameC = TextEditingController();
    final addressC = TextEditingController();
    final priceC = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Kos Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Nama Kos'),
              ),
              TextField(
                controller: addressC,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: priceC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga per Bulan (Rp)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == true && nameC.text.isNotEmpty) {
      try {
        await KosService().add(
          name: nameC.text.trim(),
          address: addressC.text.trim(),
          price: int.tryParse(priceC.text.trim()) ?? 0,
        );
        setState(() {
          _kosFuture = KosService().fetchAll();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kos berhasil ditambahkan!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambah kos: $e')),
          );
        }
      }
    }
  }

  Future<void> _showEditDialog(Map<String, dynamic> kos) async {
    final nameC = TextEditingController(text: kos['name']);
    final addressC = TextEditingController(text: kos['address']);
    final priceC = TextEditingController(text: kos['price'].toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Kos'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Nama Kos'),
              ),
              TextField(
                controller: addressC,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: priceC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga per Bulan (Rp)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Perbarui'),
          ),
        ],
      ),
    );

    if (result == true && nameC.text.isNotEmpty) {
      final success = await KosService().update(kos['id'], {
        'name': nameC.text.trim(),
        'address': addressC.text.trim(),
        'price': int.tryParse(priceC.text.trim()) ?? 0,
      });

      setState(() {
        _kosFuture = KosService().fetchAll();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Kos berhasil diperbarui!' : 'Gagal / Ditolak oleh RLS'),
          ),
        );
      }
    }
  }

  Future<void> _deleteKos(String id) async {
    final success = await KosService().delete(id);
    setState(() {
      _kosFuture = KosService().fetchAll();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Kos berhasil dihapus!' : 'Gagal / Ditolak oleh RLS'),
        ),
      );
    }
  }

  Future<void> _testSecurityOnKos(Map<String, dynamic> kos) async {
    // 1. User mencoba mengubah data orang lain -> harus DENIED
    final updated = await KosService().update(kos['id'], {'name': 'DIUBAH SECARA ILEGAL'});
    debugPrint(updated
        ? '[FAIL] User berhasil mengubah data user lain'
        : '[PASS] UPDATE ditolak oleh RLS');

    // 2. User mencoba menghapus data orang lain -> harus DENIED
    final deleted = await KosService().delete(kos['id']);
    debugPrint(deleted
        ? '[FAIL] User berhasil menghapus data user lain'
        : '[PASS] DELETE ditolak oleh RLS');

    // 3. User mencoba INSERT atas nama pemilik data -> harus ERROR 42501
    String insertResult = '';
    try {
      await Supabase.instance.client.from('kos').insert({
        'owner_id': kos['owner_id'],
        'name': 'Kos Palsu Ilegal',
      });
      insertResult = '[FAIL] INSERT atas nama user lain berhasil';
      debugPrint(insertResult);
    } on PostgrestException catch (e) {
      insertResult = '[PASS] INSERT ditolak: ${e.code} - ${e.message}';
      debugPrint(insertResult);
    } catch (e) {
      insertResult = '[PASS] INSERT ditolak: $e';
      debugPrint(insertResult);
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.green),
            SizedBox(width: 8),
            Text('Hasil Security Testing RLS', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mencoba memodifikasi data milik User lain:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text(
              updated
                  ? '❌ [FAIL] User berhasil mengubah data'
                  : '✅ [PASS] UPDATE ditolak oleh RLS (0 baris berubah)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: updated ? Colors.red : Colors.green[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              deleted
                  ? '❌ [FAIL] User berhasil menghapus data'
                  : '✅ [PASS] DELETE ditolak oleh RLS (0 baris dihapus)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: deleted ? Colors.red : Colors.green[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              insertResult.startsWith('[PASS]')
                  ? '✅ $insertResult'
                  : '❌ $insertResult',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: insertResult.startsWith('[PASS]') ? Colors.green[800] : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myId = Supabase.instance.client.auth.currentUser?.id;

    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = snap.data;
        if (snap.hasError || p == null) {
          return const Scaffold(
            body: Center(child: Text('Gagal memuat profil')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role})'),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: () => setState(() => _loadData()),
              ),
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() => _loadData());
            },
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(p.isOwner ? Icons.home_work : Icons.person),
                    ),
                    title: Text(p.name.isEmpty ? p.email : p.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${p.email} • Role: ${p.role.toUpperCase()}'),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'Daftar Kos Tersedia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _kosFuture,
                  builder: (context, kosSnap) {
                    if (kosSnap.connectionState != ConnectionState.done) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (kosSnap.hasError) {
                      return Center(
                        child: Text('Error memuat data kos: ${kosSnap.error}'),
                      );
                    }
                    final items = kosSnap.data ?? [];
                    if (items.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('Belum ada data kos.'),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final kos = items[i];
                        final isMine = kos['owner_id'] == myId;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.home, color: Colors.indigo),
                            title: Text(
                              kos['name'] ?? '-',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${kos['address'] ?? '-'} • Rp ${kos['price'] ?? 0}/bulan\nOwner: ${isMine ? "Anda Sendiri" : "User Lain"}',
                            ),
                            isThreeLine: true,
                            trailing: isMine
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        tooltip: 'Edit Kos Milik Sendiri',
                                        onPressed: () => _showEditDialog(kos),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        tooltip: 'Hapus Kos Milik Sendiri',
                                        onPressed: () => _deleteKos(kos['id']),
                                      ),
                                    ],
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.shield_outlined, color: Colors.deepOrange),
                                    tooltip: 'Uji Keamanan RLS (Coba Retas Data Ini)',
                                    onPressed: () => _testSecurityOnKos(kos),
                                  ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}
