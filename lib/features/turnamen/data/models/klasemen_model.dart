class Klasemen {
  final int peringkat;
  final String atletId;
  final String namaAtlet;
  final String klubAsal;
  final String kategori;
  final int poin;
  final int menang;
  final int kalah;
  final int seri;
  final String? medali; // 'emas', 'perak', 'perunggu', null

  Klasemen({
    required this.peringkat,
    required this.atletId,
    required this.namaAtlet,
    required this.klubAsal,
    required this.kategori,
    required this.poin,
    required this.menang,
    required this.kalah,
    required this.seri,
    this.medali,
  });

  factory Klasemen.fromJson(Map<String, dynamic> json) {
    return Klasemen(
      peringkat: json['peringkat'] as int,
      atletId: json['atlet_id'] as String,
      namaAtlet: json['nama_atlet'] as String,
      klubAsal: json['klub_asal'] as String,
      kategori: json['kategori'] as String,
      poin: json['poin'] as int,
      menang: json['menang'] as int,
      kalah: json['kalah'] as int,
      seri: json['seri'] as int,
      medali: json['medali'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peringkat': peringkat,
      'atlet_id': atletId,
      'nama_atlet': namaAtlet,
      'klub_asal': klubAsal,
      'kategori': kategori,
      'poin': poin,
      'menang': menang,
      'kalah': kalah,
      'seri': seri,
      'medali': medali,
    };
  }
}

