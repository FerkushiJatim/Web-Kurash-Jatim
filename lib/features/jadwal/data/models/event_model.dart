class Event {
  final String id;
  final String judul;
  final String kategori;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String lokasi;
  final String status;
  final String deskripsi;
  final String? posterUrl;

  Event({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.lokasi,
    required this.status,
    required this.deskripsi,
    this.posterUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      judul: json['judul'] as String,
      kategori: json['kategori'] as String,
      tanggalMulai: DateTime.parse(json['tanggal_mulai'] as String),
      tanggalSelesai: DateTime.parse(json['tanggal_selesai'] as String),
      lokasi: json['lokasi'] as String,
      status: json['status'] as String? ?? 'upcoming',
      deskripsi: json['deskripsi'] as String? ?? '',
      posterUrl: json['poster_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_selesai': tanggalSelesai.toIso8601String(),
      'lokasi': lokasi,
      'status': status,
      'deskripsi': deskripsi,
      'poster_url': posterUrl,
    };
  }
}

