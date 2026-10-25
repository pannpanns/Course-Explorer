# Course Data Manager (Course Explorer v2)

Aplikasi Flutter untuk eksplorasi dan manajemen data mata kuliah (CRUD), dibangun menggunakan Clean Architecture, Provider State Management, REST API, dan Supabase.
## Dokumentasi REST Endpoint (Tahap 1)

* **Base URL (`apiBaseUrl`):** `https://course-api-pearl.vercel.app`
* **Endpoint URL (GET):** `https://course-api-pearl.vercel.app/courses`
* **HTTP Method:** `GET`
* **Status Code:** `200 OK`
* **Resource:** `courses`

### Daftar Endpoint CRUD:
* `GET /courses` — Mengambil seluruh daftar course (diurutkan berdasarkan `id`).
* `GET /courses?status=active` — Mengambil daftar course berdasarkan filter status.
* `GET /courses/:id` — Mengambil detail satu course berdasarkan `id`.
* `POST /courses` — Membuat course baru (mengembalikan status `201 Created`).
* `PUT /courses/:id` — Memperbarui seluruh data course berdasarkan `id` (`200 OK`).
* `PATCH /courses/:id` — Memperbarui sebagian field course berdasarkan `id` (`200 OK`).
* `DELETE /courses/:id` — Menghapus course berdasarkan `id` (`204 No Content`).

### Struktur Field JSON:
1. `id` (int): Identifier unik untuk setiap data mata kuliah.
2. `code` (String): Kode unik mata kuliah (contoh: `"MOB01"`).
3. `title` (String): Nama atau judul mata kuliah (contoh: `"Git & GitHub"`).
4. `credits` (int): Jumlah beban SKS mata kuliah (contoh: `2`).
5. `status` (String): Status pembelajaran mata kuliah (`"planned"`, `"active"`, atau `"done"`).

### Contoh Response Body JSON:
```json
[
  {
    "id": 1,
    "code": "MOB01",
    "title": "Git & GitHub",
    "credits": 2,
    "status": "active"
  }
]