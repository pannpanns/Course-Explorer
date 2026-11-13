import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_keys.dart';
import '../firebase_options.dart';

/// Handler top-level untuk pesan saat aplikasi berada di BACKGROUND atau TERMINATED
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('[BACKGROUND] Notification received');
  debugPrint('[BACKGROUND] Title: ${message.notification?.title}');
  debugPrint('[BACKGROUND] Body : ${message.notification?.body}');
  debugPrint('[BACKGROUND] Data : ${message.data}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Meminta izin notifikasi dan mengembalikan statusnya:
  /// authorized | provisional | denied | notDetermined
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }

  /// Mendapatkan FCM Registration Token dari perangkat
  Future<String?> getToken() async {
    // ignore: deprecated_member_use
    final token = await _messaging.getToken();
    debugPrint('==================================================');
    debugPrint('FCM Token: $token');
    debugPrint('==================================================');
    return token;
  }

  /// Token dapat berubah, sehingga perubahan perlu didengarkan.
  void listenTokenRefresh(void Function(String token) onRefresh) {
    // ignore: deprecated_member_use
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui: $newToken');
      onRefresh(newToken);
    });
  }

  /// Menyimpan token ke Supabase (Device Registration)
  Future<void> saveTokenToSupabase(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    try {
      await Supabase.instance.client.from('device_tokens').upsert({
        'token': token,
        'user_id': user.id,
        'platform': defaultTargetPlatform.name,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      debugPrint('FCM Token berhasil disimpan ke Supabase');
    } catch (e) {
      debugPrint('Catatan: Gagal simpan token ke Supabase: $e');
    }
  }

  /// Inisialisasi listener notifikasi Foreground & Background
  Future<void> init() async {
    await requestPermission();
    final token = await getToken();
    if (token != null) await saveTokenToSupabase(token);
    listenTokenRefresh(saveTokenToSupabase);

    // iOS: tampilkan banner saat aplikasi di foreground
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FOREGROUND: aplikasi sedang terbuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body : ${message.notification?.body}');
      debugPrint('data : ${message.data}');

      // Android tidak otomatis memunculkan status bar saat foreground,
      // sehingga ditampilkan di dalam aplikasi menggunakan SnackBar.
      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}
