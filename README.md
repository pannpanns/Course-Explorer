
# Course Data Manager

Aplikasi manajemen mata kuliah berbasis Flutter yang dikembangkan dari Course Explorer v2. Aplikasi ini mengintegrasikan Supabase sebagai backend dan database untuk mengelola data mata kuliah melalui operasi CRUD (Create, Read, Update, Delete).

## Deskripsi Aplikasi

Course Data Manager merupakan aplikasi mobile yang memungkinkan pengguna melihat, menambahkan, mengubah, dan menghapus data mata kuliah. Aplikasi menggunakan arsitektur berlapis agar kode antarmuka, pengelolaan state, logika bisnis, dan akses database memiliki tanggung jawab yang terpisah.

Project ini dikembangkan sebagai bagian dari praktikum Pemrograman Mobile dengan materi RESTful API, backend services, dan database integration.

## Fitur Utama

- Menampilkan daftar mata kuliah dari Supabase.
- Menambahkan data mata kuliah.
- Mengedit data mata kuliah.
- Menghapus mata kuliah dengan dialog konfirmasi.
- Memperbarui daftar data melalui refresh.
- Menampilkan loading, empty, success, dan error state.
- Menampilkan feedback operasi melalui SnackBar.
- Menyediakan tombol retry ketika terjadi kegagalan pengambilan data.
- Menampilkan detail mata kuliah.
- Mengelola daftar favorites berdasarkan kode mata kuliah.
- Mendukung navigasi responsif sesuai ukuran layar.
- Memisahkan implementasi REST API dan Supabase melalui abstraksi data source.

## Teknologi yang Digunakan

- **Flutter** sebagai framework aplikasi.
- **Dart** sebagai bahasa pemrograman.
- **Supabase** sebagai backend dan database PostgreSQL.
- **supabase_flutter** untuk integrasi aplikasi dengan Supabase.
- **http** untuk komunikasi dengan REST API.
- **Provider** untuk pengelolaan state.
- **Git dan GitHub** untuk version control dan penyimpanan source code.

## Arsitektur Aplikasi

Aplikasi menerapkan pemisahan tanggung jawab dengan alur berikut:

UI / Screen → Provider → Repository → Data Source / Service → Backend / Database

Setiap lapisan memiliki tanggung jawab yang berbeda.

| Komponen | Tanggung Jawab |
|---|---|
| Model | Merepresentasikan data mata kuliah dalam objek Dart. |
| Service / Data Source | Menangani komunikasi dengan REST API atau Supabase. |
| Repository | Menyediakan akses data kepada provider dan memisahkan logika akses data dari UI. |
| Provider | Mengelola state dan menghubungkan UI dengan repository. |
| Screen / Widget | Menampilkan data, form, navigasi, dan feedback kepada pengguna. |

Sumber data aktif ditentukan melalui `main.dart`. Implementasi `CourseApiService` tetap tersedia sebagai alternatif REST API, sedangkan `CourseSupabaseService` digunakan sebagai sumber data utama aplikasi.

## Struktur Folder

```text
lib/
├── models/
│   └── course.dart
├── providers/
│   └── course_provider.dart
├── repositories/
│   └── course_repository.dart
├── screens/
│   ├── course_detail_page.dart
│   ├── course_form_page.dart
│   ├── dashboard_page.dart
│   ├── favorites_page.dart
│   ├── home_page.dart
│   └── main_screen.dart
├── services/
│   ├── course_api_service.dart
│   ├── course_data_source.dart
│   └── course_supabase_service.dart
├── widgets/
└── main.dart
```

## Struktur Database

Aplikasi menggunakan tabel `courses` pada Supabase dengan struktur data utama berikut.

| Kolom | Tipe Data | Keterangan |
|---|---|---|
| `id` | Bigint | Primary key |
| `code` | Text | Kode mata kuliah, harus unik |
| `title` | Text | Nama mata kuliah |
| `credits` | Integer | Jumlah SKS |
| `status` | Text | Status mata kuliah |
| `created_at` | Timestamp | Waktu pembuatan data |

Nilai status yang digunakan adalah `planned`, `active`, dan `done`.

## Persyaratan Sistem

Sebelum menjalankan aplikasi, pastikan perangkat pengembangan telah memiliki:

- Flutter SDK.
- Dart SDK yang sesuai dengan versi Flutter.
- Android Studio atau Visual Studio Code.
- Emulator Android atau perangkat Android.
- Akun dan project Supabase.
- Git untuk pengelolaan versi.

## Cara Menjalankan Aplikasi

### 1. Clone repository

```bash
git clone https://github.com/pannpanns/Course-Explorer.git
cd Course-Explorer
```

### 2. Instal dependency

```bash
flutter pub get
```

### 3. Konfigurasi Supabase

Buat file `.env` di direktori utama project sesuai dengan konfigurasi yang digunakan aplikasi.

Isi dengan konfigurasi client Supabase milik project kamu:

```dotenv
SUPABASE_URL=URL_PROJECT_SUPABASE
SUPABASE_ANON_KEY=SUPABASE_CLIENT_KEY
```

Ganti nilai contoh tersebut dengan URL dan key client yang sesuai. Jangan memasukkan `service_role` key, password database, atau secret server ke dalam aplikasi Flutter.

Pastikan nama variabel sesuai dengan kode inisialisasi pada `lib/main.dart` dan konfigurasi dotenv di `pubspec.yaml`.

### 4. Jalankan aplikasi

```bash
flutter run
```

Pilih emulator atau perangkat yang tersedia ketika Flutter meminta target perangkat.

## Pengujian Aplikasi

Pengujian dilakukan untuk memastikan aplikasi dan backend bekerja sesuai kebutuhan.

- **Read:** mengambil daftar mata kuliah dari Supabase.
- **Create:** menambahkan data mata kuliah.
- **Update:** mengubah data mata kuliah.
- **Delete:** menghapus data setelah konfirmasi pengguna.
- **HTTP 404:** menguji penanganan endpoint yang tidak ditemukan.
- **Network failure:** menguji kondisi ketika koneksi internet terputus.
- **JSON mapping:** menguji kesesuaian struktur JSON dengan model Dart.
- **RLS / permission:** menguji penolakan operasi oleh kebijakan keamanan backend.
- **Duplicate data:** menguji pencegahan kode mata kuliah yang sama.

Pengujian negatif dilakukan pada lingkungan praktikum dan konfigurasi harus dipulihkan setelah pengujian selesai.

## Keamanan

- Tidak menyimpan `service_role` key atau secret server dalam source code aplikasi.
- Tidak memasukkan file `.env` yang berisi konfigurasi ke repository Git.
- Menggunakan `.gitignore` untuk mengecualikan konfigurasi lokal dan hasil build.
- Menggunakan validasi input pada form.
- Menggunakan constraint database untuk mencegah kode mata kuliah duplikat.
- Memahami bahwa validasi UI tidak menggantikan validasi dan authorization backend.
- Menggunakan Row Level Security (RLS) dan policy Supabase sesuai kebutuhan akses.

Supabase client key bukan pengganti kebijakan keamanan database. Akses data harus dikendalikan melalui konfigurasi backend yang sesuai.

## Version Control

Repository project:

https://github.com/pannpanns/Course-Explorer

Untuk memeriksa perubahan dan riwayat commit, gunakan:

```bash
git status
git log --oneline -12
```

Untuk menyimpan perubahan README ke GitHub:

```bash
git add README.md
git commit -m "Finalisasi README dan dokumentasi aplikasi"
git push
```

## Penutup

Course Data Manager merupakan pengembangan Course Explorer v2 yang mengintegrasikan Flutter dengan Supabase melalui arsitektur berlapis. Pemisahan model, service, repository, provider, dan UI membantu menjaga kode lebih terstruktur serta mempermudah pemeliharaan dan pengembangan fitur.

Project ini menjadi penerapan materi RESTful API, backend services, database integration, error handling, dan version control dalam pengembangan aplikasi mobile.
