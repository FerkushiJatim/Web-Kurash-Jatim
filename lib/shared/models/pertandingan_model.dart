enum StatusPertandingan { belumMulai, berlangsung, selesai }

class Pertandingan {
  final String id;
  final String eventId;
  final Peserta atletMerah;
  final Peserta atletBiru;
  final String kategori;
  final int babak;
  final String fase; // 'penyisihan', 'perempat_final', 'semifinal', 'final'
  final DateTime waktu;
  final StatusPertandingan status;
  final String? pemenangId;

  Pertandingan({
    required this.id,
    required this.eventId,
    required this.atletMerah,
    required this.atletBiru,
    required this.kategori,
    required this.babak,
    required this.fase,
    required this.waktu,
    required this.status,
    this.pemenangId,
  });

  factory Pertandingan.fromJson(Map<String, dynamic> json) {
    return Pertandingan(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      atletMerah: Peserta.fromJson(json['atlet_merah'] as Map<String, dynamic>),
      atletBiru: Peserta.fromJson(json['atlet_biru'] as Map<String, dynamic>),
      kategori: json['kategori'] as String,
      babak: json['babak'] as int,
      fase: json['fase'] as String,
      waktu: DateTime.parse(json['waktu'] as String),
      status: StatusPertandingan.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StatusPertandingan.belumMulai,
      ),
      pemenangId: json['pemenang_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'atlet_merah': atletMerah.toJson(),
      'atlet_biru': atletBiru.toJson(),
      'kategori': kategori,
      'babak': babak,
      'fase': fase,
      'waktu': waktu.toIso8601String(),
      'status': status.name,
      'pemenang_id': pemenangId,
    };
  }
}

class Peserta {
  final String atletId;
  final String nama;
  final int skor;

  Peserta({
    required this.atletId,
    required this.nama,
    required this.skor,
  });

  factory Peserta.fromJson(Map<String, dynamic> json) {
    return Peserta(
      atletId: json['atlet_id'] as String,
      nama: json['nama'] as String,
      skor: json['skor'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atlet_id': atletId,
      'nama': nama,
      'skor': skor,
    };
  }
}

