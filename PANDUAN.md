# Panduan Menjalankan SIMAK (Sistem Informasi Manajemen Sekolah)

Ikuti langkah-langkah ini secara berurutan. Perkiraan waktu total: 20–30 menit.

---

## BAGIAN 1 — Siapkan Database di Supabase (sudah punya akun ✅)

1. Buka [supabase.com/dashboard](https://supabase.com/dashboard) dan masuk ke project Anda (atau buat project baru bila belum ada).
2. Di sidebar kiri, klik **SQL Editor** → **New query**.
3. Buka file `supabase_schema.sql` yang ada di folder proyek ini, salin **seluruh isinya**, tempel ke SQL Editor, lalu klik **Run**.
   - Ini akan membuat 8 tabel (guru, kelas, siswa, jadwal, presensi_siswa, presensi_guru, nilai, pengumuman) beserta aturan keamanannya.
4. Buat akun admin (Kepala Sekolah) untuk login:
   - Di sidebar, klik **Authentication** → **Users** → **Add user** → **Create new user**.
   - Isi email dan password, centang **Auto Confirm User**, lalu **Create user**.
   - Ini adalah akun yang nanti dipakai login di aplikasi.
5. Ambil kunci API:
   - Klik ikon gerigi **Project Settings** → **API**.
   - Salin nilai **Project URL** dan **anon public key** — akan dipakai di Bagian 3.

---

## BAGIAN 2 — Siapkan komputer Anda

1. Pastikan **Node.js** sudah terpasang (versi 18 ke atas).
   - Cek dengan membuka Terminal/Command Prompt, ketik: `node -v`
   - Jika belum ada, unduh di [nodejs.org](https://nodejs.org) (pilih versi **LTS**), install seperti biasa.
2. Ekstrak/salin folder proyek ini (`simak-app`) ke komputer Anda, misalnya ke Desktop.
3. Buka Terminal/Command Prompt, arahkan ke folder tersebut:
   ```bash
   cd Desktop/simak-app
   ```
4. Install semua library yang dibutuhkan:
   ```bash
   npm install
   ```
   Tunggu sampai selesai (1–3 menit).

---

## BAGIAN 3 — Hubungkan ke Supabase

1. Di dalam folder proyek, cari file `.env.example`. Buat salinannya dan beri nama `.env` (tanpa akhiran apa pun).
   - Windows: copy file, rename jadi `.env`
   - Mac/Linux: `cp .env.example .env`
2. Buka file `.env` dengan text editor, isi dengan data dari Bagian 1 langkah 5:
   ```
   VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
   VITE_SUPABASE_ANON_KEY=isi_dengan_anon_public_key_anda
   ```
3. Simpan file.

---

## BAGIAN 4 — Jalankan aplikasi di komputer Anda

1. Di Terminal (masih di folder `simak-app`), jalankan:
   ```bash
   npm run dev
   ```
2. Akan muncul tulisan seperti `Local: http://localhost:5173/`. Buka alamat itu di browser.
3. Login menggunakan email & password admin yang dibuat di Bagian 1 langkah 4.
4. Aplikasi siap dipakai: tambah kelas terlebih dahulu, lalu input data guru dan siswa (satu per satu atau impor massal lewat Excel).

**Tips input massal:** di halaman Data Siswa / Data Guru, klik **Impor Massal** → **Unduh Template Kosong** → isi file Excel tersebut → unggah kembali.

---

## BAGIAN 5 — Supaya bisa diakses dari HP/perangkat lain (opsional, disarankan)

Menjalankan `npm run dev` hanya bisa diakses dari komputer itu sendiri. Agar bisa dibuka dari HP atau di mana saja lewat internet, publikasikan aplikasinya secara gratis lewat **Vercel**:

1. Buat akun gratis di [vercel.com](https://vercel.com) (bisa langsung pakai akun GitHub/Google).
2. Unggah folder proyek ini ke GitHub (buat repository baru, lalu upload semua file — atau minta bantuan saya kalau butuh panduan Git).
3. Di Vercel, klik **Add New → Project**, pilih repository GitHub Anda tadi.
4. Saat konfigurasi muncul, buka bagian **Environment Variables**, tambahkan dua variabel ini (nilainya sama seperti file `.env` Anda):
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
5. Klik **Deploy**. Setelah selesai (1–2 menit), Anda akan mendapat alamat seperti `https://simak-sekolah-anda.vercel.app` yang bisa dibuka dari perangkat mana pun.

Setiap kali Anda ingin menambah admin lain (misalnya wakil kepala sekolah), cukup buat user baru lewat **Supabase Dashboard → Authentication → Users**, tidak perlu ubah kode.

---

## Kalau ada kendala

- **Layar putih / error saat `npm run dev`** → cek kembali isi file `.env`, pastikan tidak ada spasi tambahan.
- **Login gagal terus** → pastikan user sudah dibuat di Supabase dan opsi "Auto Confirm User" dicentang saat membuatnya.
- **Data tidak muncul setelah impor** → refresh halaman; pastikan format tanggal lahir di Excel `YYYY-MM-DD` (contoh: 2015-08-17).

Beri tahu saya jika Anda ingin saya membantu langkah tertentu (misalnya deploy ke Vercel) secara lebih rinci.
