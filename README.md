Tugas Indexing SMBD

Proyek ini menguji pengaruh index terhadap waktu eksekusi query pada database bioskop_smbd (MySQL 8.0). Lima query dijalankan dengan EXPLAIN ANALYZE sebelum dan sesudah index dibuat, lalu hasilnya dievaluasi.

Tugas mata kuliah Sistem Manajemen Basis Data (SMBD).

Anggota Kelompok
Nama	NIM
Faizah Zahra Aqilah	103052500092
Ruli Septianur	103052530007
Nasyifa Ameila Zahwa	103052500010
Rahmawati Kusuma Dewi	103052500017

Isi Repository
File	Keterangan
database_bioskop_smbd.sql	Script pembuatan database dan data (struktur tabel + isi data)
Query-SMBD-Fix-Kelompok.sql	Lima query (3 non-key, 2 key) beserta perintah CREATE INDEX
Database

Database bioskop_smbd terdiri dari 6 tabel:

Tabel	Jenis	Jumlah record
Film	Master	3.000
Pelanggan	Master	3.500
JadwalTayang	Master	3.000
Transaksi	Transaksi	6.000
Cabang	Master	15
MetodeBayar	Master	8
Query dan Index
No	Jenis	Deskripsi	Index yang dibuat
Q1	Non-key	Film dengan rating SU dan rilis setelah 2010	idx_film_rating_tahun (rating, tahun_rilis)
Q2	Non-key	Pelanggan dari kota Bandung	idx_pelanggan_kota (kota)
Q3	Non-key	Transaksi berhasil Agustus 2026 dengan total > 200.000	idx_trx_status_tanggal_total (status, tanggal, total)
Q4	Key	Total pendapatan per metode pembayaran (join)	idx_transaksi_metode (id_metodeBayar)
Q5	Key	Film beserta jumlah jadwal tayangnya (left join)	idx_jadwaltayang_id_film (id_film)
Hasil Singkat

Waktu diambil dari actual time baris paling atas pada EXPLAIN ANALYZE.

Query	Sebelum (ms)	Sesudah (ms)	Hasil
Q1	0,874	0,914	Hampir sama
Q2	3,24	11,3	Lebih lambat
Q3	12,2	2,09	Lebih cepat ±5,8×
Q4	41,8	35,7	Lebih cepat ±14,6%
Q5	54,3	18,1	Lebih cepat ±3×

Temuan utama:

Index paling efektif pada kondisi gabungan yang selektif dengan composite index yang urutan kolomnya sesuai kondisi (Q3).
Index tidak membantu pada kolom dengan selektivitas rendah (Q2: 64% pelanggan berasal dari Bandung) dan pada tabel yang kecil (Q1).
Kolom foreign key sudah memiliki index otomatis di InnoDB, sehingga index tambahan pada Q4 dan Q5 bersifat duplikat dan perbedaan waktunya lebih dipengaruhi cache dan variasi eksekusi.

Cara Menjalankan
Import database:
   SOURCE database_bioskop_smbd.sql;
Pastikan kondisi awal tanpa index buatan (abaikan error jika index belum ada):
   USE bioskop_smbd;
   DROP INDEX idx_film_rating_tahun        ON Film;
   DROP INDEX idx_pelanggan_kota           ON Pelanggan;
   DROP INDEX idx_trx_status_tanggal_total ON Transaksi;
   DROP INDEX idx_transaksi_metode         ON Transaksi;
   DROP INDEX idx_jadwaltayang_id_film     ON JadwalTayang;
   
Jalankan tiap EXPLAIN ANALYZE pada Query-SMBD-Fix-Kelompok.sql dan catat actual time baris paling atas.
Jalankan perintah CREATE INDEX, lalu ulangi EXPLAIN ANALYZE yang sama.
Cek index yang aktif dengan SHOW INDEX FROM <nama_tabel>;.

Tips: jalankan tiap query beberapa kali dan abaikan run pertama (cache belum terisi) agar hasil lebih stabil.

Tools
MySQL 8.0.46
HeidiSQL 12.17
