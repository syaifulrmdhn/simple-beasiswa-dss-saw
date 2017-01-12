-- Normalisasi
SELECT
	nilai.kd_kriteria,
    kriteria.sifat,
    (SELECT bobot FROM model WHERE kd_kriteria=kriteria.kd_kriteria) AS bobot,
	ROUND(IF(kriteria.sifat='max', MAX(nilai.nilai), MIN(nilai.nilai)), 1) AS normalization
FROM nilai
JOIN kriteria USING(kd_kriteria)
GROUP BY nilai.kd_kriteria

-- Rangking
SELECT
	(SELECT nama FROM mahasiswa WHERE nim=mhs.nim) AS nama,
	(SELECT nim FROM mahasiswa WHERE nim=mhs.nim) AS nim,
	(SELECT tahun_mengajukan FROM mahasiswa WHERE nim=mhs.nim) AS tahun,
	SUM(
		IF(
				c.sifat = 'max',
				nilai.nilai / c.normalization,
				c.normalization / nilai.nilai
		) * c.bobot
	) AS rangking
FROM
	nilai
	JOIN mahasiswa mhs USING(nim)
	JOIN (
		SELECT
				nilai.kd_kriteria AS kd_kriteria,
				kriteria.sifat AS sifat,
				(
					SELECT bobot FROM model WHERE kd_kriteria=kriteria.kd_kriteria
				) AS bobot,
				ROUND(
					IF(kriteria.sifat='max', MAX(nilai.nilai), MIN(nilai.nilai)), 1
				) AS normalization
			FROM nilai
			JOIN kriteria USING(kd_kriteria)
		GROUP BY nilai.kd_kriteria
	) c USING(kd_kriteria)
WHERE kd_beasiswa=1
GROUP BY nilai.nim
ORDER BY rangking DESC

-- Rangking dengan menampilkan nilai perkriteria
SELECT
	(SELECT nama FROM mahasiswa WHERE nim=mhs.nim) AS nama,
	(SELECT nim FROM mahasiswa WHERE nim=mhs.nim) AS nim,
	(SELECT tahun_mengajukan FROM mahasiswa WHERE nim=mhs.nim) AS tahun,
	SUM(
		IF(
			c.kd_kriteria=1,
			IF(c.sifat='max', nilai.nilai/c.normalization, c.normalization / nilai.nilai), 0
		)
	) AS C1,
	SUM(
		IF(
			c.kd_kriteria=2,
			IF(c.sifat='max', nilai.nilai/c.normalization, c.normalization / nilai.nilai), 0
		)
	) AS C2,
	SUM(
		IF(
			c.kd_kriteria=3,
			IF(c.sifat='max', nilai.nilai/c.normalization, c.normalization / nilai.nilai), 0
		)
	) AS C3,
	SUM(
		IF(
				c.sifat = 'max',
				nilai.nilai / c.normalization,
				c.normalization / nilai.nilai
		) * c.bobot
	) AS rangking
FROM
	nilai
	JOIN mahasiswa mhs USING(nim)
	JOIN (
		SELECT
				nilai.kd_kriteria AS kd_kriteria,
				kriteria.sifat AS sifat,
				(
					SELECT bobot FROM model WHERE kd_kriteria=kriteria.kd_kriteria
				) AS bobot,
				ROUND(
					IF(kriteria.sifat='max', MAX(nilai.nilai), MIN(nilai.nilai)), 1
				) AS normalization
			FROM nilai
			JOIN kriteria USING(kd_kriteria)
		GROUP BY nilai.kd_kriteria
	) c USING(kd_kriteria)
WHERE kd_beasiswa=1
GROUP BY nilai.nim
ORDER BY rangking DESC
