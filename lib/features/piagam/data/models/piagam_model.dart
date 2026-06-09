class Piagam {
  final String id;
  final String turnamenNama;
  final DateTime tanggalTerbit;
  final String pdfUrl;

  Piagam({
    required this.id,
    required this.turnamenNama,
    required this.tanggalTerbit,
    required this.pdfUrl,
  });

  factory Piagam.fromJson(Map<String, dynamic> json) {
    return Piagam(
      id: json['id'] as String,
      turnamenNama: json['turnamen_nama'] ?? 'Turnamen Tidak Diketahui',
      tanggalTerbit: json['tanggal_terbit'] != null ? DateTime.parse(json['tanggal_terbit'] as String) : DateTime.now(),
      pdfUrl: json['pdf_url'] ?? json['google_drive_file_id'] ?? '', // Fallback to old property if exists
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'turnamen_nama': turnamenNama,
      'tanggal_terbit': tanggalTerbit.toIso8601String(),
      'pdf_url': pdfUrl,
    };
  }
}

