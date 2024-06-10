class Pembayaran {
  final int siswaId;
  final String tanggalBayar;
  final String bulan;
  final int sppId;
  final String namaPenginput;

  Pembayaran({
    required this.siswaId,
    required this.tanggalBayar,
    required this.bulan,
    required this.sppId,
    required this.namaPenginput,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
      siswaId: json['siswa_id'],
      tanggalBayar: json['tanggal_bayar'],
      bulan: json['bulan'],
      sppId: json['spp_id'],
      namaPenginput: json['nama_penginput'],
    );
  }
}

