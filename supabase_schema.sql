-- =========================================================
-- SIMAK — Skema Database untuk Supabase
-- Cara pakai: buka Supabase Dashboard > SQL Editor > New Query
-- lalu tempel seluruh isi file ini dan klik "Run".
-- =========================================================

create extension if not exists "uuid-ossp";

-- ---------- GURU ----------
create table if not exists guru (
  id uuid primary key default uuid_generate_v4(),
  nip text,
  nama_lengkap text not null,
  jenis_kelamin text default 'L',
  mata_pelajaran text,
  no_hp text,
  email text,
  status text default 'aktif',
  dibuat_pada timestamptz default now()
);

-- ---------- KELAS ----------
create table if not exists kelas (
  id uuid primary key default uuid_generate_v4(),
  nama_kelas text not null,
  tingkat text,
  wali_kelas_id uuid references guru(id) on delete set null,
  tahun_ajaran text,
  dibuat_pada timestamptz default now()
);

-- ---------- SISWA ----------
create table if not exists siswa (
  id uuid primary key default uuid_generate_v4(),
  nis text,
  nisn text,
  nama_lengkap text not null,
  jenis_kelamin text default 'L',
  tempat_lahir text,
  tanggal_lahir date,
  alamat text,
  nama_orang_tua text,
  no_hp_orang_tua text,
  kelas_id uuid references kelas(id) on delete set null,
  status text default 'aktif',
  dibuat_pada timestamptz default now()
);

-- ---------- JADWAL PELAJARAN ----------
create table if not exists jadwal (
  id uuid primary key default uuid_generate_v4(),
  kelas_id uuid references kelas(id) on delete cascade,
  mata_pelajaran text not null,
  guru_id uuid references guru(id) on delete set null,
  hari text not null,
  jam_mulai time not null,
  jam_selesai time not null,
  dibuat_pada timestamptz default now()
);

-- ---------- PRESENSI SISWA ----------
create table if not exists presensi_siswa (
  id uuid primary key default uuid_generate_v4(),
  siswa_id uuid references siswa(id) on delete cascade,
  tanggal date not null,
  status text not null default 'hadir', -- hadir | izin | sakit | alpa
  catatan text,
  dibuat_pada timestamptz default now(),
  unique (siswa_id, tanggal)
);

-- ---------- PRESENSI GURU ----------
create table if not exists presensi_guru (
  id uuid primary key default uuid_generate_v4(),
  guru_id uuid references guru(id) on delete cascade,
  tanggal date not null,
  status text not null default 'hadir',
  catatan text,
  dibuat_pada timestamptz default now(),
  unique (guru_id, tanggal)
);

-- ---------- NILAI ----------
create table if not exists nilai (
  id uuid primary key default uuid_generate_v4(),
  siswa_id uuid references siswa(id) on delete cascade,
  mata_pelajaran text not null,
  jenis text not null default 'UH', -- Tugas | UH | UTS | UAS
  semester text not null default 'Ganjil',
  tahun_ajaran text not null default '',
  nilai numeric not null,
  dibuat_pada timestamptz default now(),
  unique (siswa_id, mata_pelajaran, jenis, semester, tahun_ajaran)
);

-- ---------- PENGUMUMAN ----------
create table if not exists pengumuman (
  id uuid primary key default uuid_generate_v4(),
  judul text not null,
  isi text,
  dibuat_pada timestamptz default now()
);

-- =========================================================
-- ROW LEVEL SECURITY
-- Aplikasi ini ditujukan untuk staf sekolah yang sudah login.
-- Semua tabel dikunci: hanya pengguna yang SUDAH LOGIN (authenticated)
-- lewat Supabase Auth yang boleh membaca & mengubah data.
-- =========================================================

alter table guru enable row level security;
alter table kelas enable row level security;
alter table siswa enable row level security;
alter table jadwal enable row level security;
alter table presensi_siswa enable row level security;
alter table presensi_guru enable row level security;
alter table nilai enable row level security;
alter table pengumuman enable row level security;

do $$
declare
  t text;
begin
  for t in select unnest(array['guru','kelas','siswa','jadwal','presensi_siswa','presensi_guru','nilai','pengumuman'])
  loop
    execute format('drop policy if exists "akses_penuh_untuk_admin_login" on %I', t);
    execute format(
      'create policy "akses_penuh_untuk_admin_login" on %I for all using (auth.role() = ''authenticated'') with check (auth.role() = ''authenticated'')',
      t
    );
  end loop;
end $$;

-- =========================================================
-- Selesai. Langkah berikutnya: buat akun admin login lewat
-- Authentication > Users > Add User di Supabase Dashboard.
-- =========================================================
