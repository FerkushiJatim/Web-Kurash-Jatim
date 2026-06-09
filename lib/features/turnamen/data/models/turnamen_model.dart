class Lampiran {
  final String judul;
  final String url;

  Lampiran({required this.judul, required this.url});

  factory Lampiran.fromJson(Map<String, dynamic> json) {
    return Lampiran(
      judul: json['judul'] as String? ?? 'Lampiran',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'url': url,
    };
  }
}

class Turnamen {
  final String id;
  final String nama;
  final String lokasi;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final int jumlahPeserta;
  final String status;
  final String? deskripsi;
  final String? bannerUrl;
  final List<Lampiran> lampiranList;

  Turnamen({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.jumlahPeserta,
    required this.status,
    this.deskripsi,
    this.bannerUrl,
    required this.lampiranList,
  });

  factory Turnamen.fromJson(Map<String, dynamic> json) {
    return Turnamen(
      id: json['id'] as String,
      nama: json['nama'] as String,
      lokasi: json['lokasi'] as String,
      tanggalMulai: DateTime.parse(json['tanggal_mulai'] as String),
      tanggalSelesai: DateTime.parse(json['tanggal_selesai'] as String),
      jumlahPeserta: json['jumlah_peserta'] as int? ?? 0,
      status: json['status'] as String? ?? 'upcoming',
      deskripsi: json['deskripsi'] as String?,
      bannerUrl: json['banner_url'] as String?,
      lampiranList: (json['lampiran_list'] as List<dynamic>?)
              ?.map((e) => Lampiran.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'lokasi': lokasi,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_selesai': tanggalSelesai.toIso8601String(),
      'jumlah_peserta': jumlahPeserta,
      'status': status,
      'deskripsi': deskripsi,
      'banner_url': bannerUrl,
      'lampiran_list': lampiranList.map((e) => e.toJson()).toList(),
    };
  }
}

