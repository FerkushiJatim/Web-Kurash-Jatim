class Atlet {
  final String id;
  final String nama;
  final String kategori;
  final String klubAsal;
  final double berat;
  final String? fotoUrl;
  final String? provinsi;
  final DateTime? tanggalLahir;

  Atlet({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.klubAsal,
    required this.berat,
    this.fotoUrl,
    this.provinsi,
    this.tanggalLahir,
  });

  factory Atlet.fromJson(Map<String, dynamic> json) {
    return Atlet(
      id: json['id'] as String,
      nama: json['nama'] as String,
      kategori: json['kategori'] as String,
      klubAsal: json['klub_asal'] as String,
      berat: (json['berat'] as num).toDouble(),
      fotoUrl: json['foto_url'] as String?,
      provinsi: json['provinsi'] as String?,
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.parse(json['tanggal_lahir'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'klub_asal': klubAsal,
      'berat': berat,
      'foto_url': fotoUrl,
      'provinsi': provinsi,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
    };
  }

  Atlet copyWith({
    String? id,
    String? nama,
    String? kategori,
    String? klubAsal,
    double? berat,
    String? fotoUrl,
    String? provinsi,
    DateTime? tanggalLahir,
  }) {
    return Atlet(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      klubAsal: klubAsal ?? this.klubAsal,
      berat: berat ?? this.berat,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      provinsi: provinsi ?? this.provinsi,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
    );
  }
}

