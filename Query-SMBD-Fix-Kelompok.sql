# QUERY NON-KEY
USE bioskop_smbd
-- 1. Menampilkan daftar film dengan rating 'SU' (Semua Umur) dan tahun rilis setelah tahun 2010
EXPLAIN ANALYZE
SELECT id_film, judul, genre, tahun_rilis, rating
FROM Film
WHERE rating = 'SU' AND tahun_rilis > 2010;
CREATE INDEX idx_film_rating_tahun ON Film(rating, tahun_rilis);


-- 2. Menampilkan daftar pelanggan yang berasal dari kota Bandung
EXPLAIN ANALYZE
SELECT id_pelanggan, nama, email, kota, status_keanggotaan
FROM Pelanggan
WHERE kota = 'Bandung';
CREATE INDEX idx_pelanggan_kota ON Pelanggan(kota);

-- 3. Menampilkan jadwal tayang film di cabang 'CBG01' dengan harga tiket di bawah Rp 50.000
EXPLAIN ANALYZE
SELECT id_transaksi, id_pelanggan, id_jadwal, jumlah_tiket, total, tanggal, status
FROM Transaksi
WHERE status = 'Berhasil'
  AND tanggal BETWEEN '2026-08-01' AND '2026-08-31'
  AND total > 200000;
CREATE INDEX idx_trx_status_tanggal_total
ON Transaksi (status, tanggal, total);

# QUERY WITH KEY

-- 1. Menghitung total pendapatan (penjualan tiket) berdasarkan masing-masing metode pembayaran
EXPLAIN ANALYZE 
SELECT 
    m.nama_metodeBayar, 
    COUNT(t.id_transaksi) AS total_transaksi, 
    SUM(t.total) AS total_pendapatan
FROM Transaksi t
JOIN MetodeBayar m ON t.id_metodeBayar = m.id_metodeBayar
GROUP BY m.id_metodeBayar, m.nama_metodeBayar;
CREATE INDEX idx_transaksi_metode ON Transaksi(id_metodeBayar);

-- 2. Menampilkan daftar film beserta jumlah jadwal tayang yang tersedia untuk setiap film tersebut
EXPLAIN ANALYZE
SELECT 
    f.id_film, 
    f.judul, 
    f.genre, 
    COUNT(j.id_jadwal) AS jumlah_jadwal_tayang
FROM Film f
LEFT JOIN JadwalTayang j ON f.id_film = j.id_film
GROUP BY f.id_film, f.judul, f.genre;
CREATE INDEX idx_jadwaltayang_id_film ON JadwalTayang(id_film);
