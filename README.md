# course_explorer

Memulai Worksheet 6 

# Course Explorer v2

## Tanggung Jawab Folder

Pemisahan folder dilakukan berdasarkan prinsip *Separation of Concerns* agar kode mudah dipelihara dan dikembangkan:

*   **`models/`**: Menyimpan kelas *blueprint* struktur data (contoh: `Course`). Bertanggung jawab untuk mengubah format data mentah (seperti JSON) menjadi objek Dart (melalui *factory method* `fromJson`).
*   **`services/`**: Berfungsi sebagai *Data Source*. Bertanggung jawab menangani komunikasi dengan sumber data eksternal, seperti membaca file aset lokal (`rootBundle`) atau melakukan *request HTTP* ke REST API. 
*   **`repositories/`**: Berperan sebagai lapisan abstraksi antara *Service* dan aplikasi. Bertanggung jawab mengelola aliran data dari berbagai *Service* agar UI/Provider tidak perlu tahu asal usul datanya secara teknis.
*   **`providers/`**: Menyimpan logika bisnis dan *State Management* terpusat (menggunakan `ChangeNotifier`). Bertanggung jawab menyimpan *state* (loading, error, list data) dan memberitahukan UI (`notifyListeners`) jika ada perubahan data.
*   **`screens/`**: Berisi sekumpulan halaman penuh (*full page*) atau antarmuka utama aplikasi (contoh: `HomePage`, `DashboardPage`, `MainScreen`). Lapisan ini dilarang berisi logika pengolahan data mentah.
*   **`widgets/`**: Menyimpan komponen antarmuka kecil yang dapat digunakan kembali (*reusable components*), seperti `CourseCard`. Membantu menjaga ukuran file di *screens* tetap ringkas.