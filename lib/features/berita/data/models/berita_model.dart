class Berita {
  final String id;
  final String judul;
  final String slug;
  final String konten;
  final String penulis;
  final DateTime tanggalPublikasi;
  final String? imageUrl;

  Berita({
    required this.id,
    required this.judul,
    required this.slug,
    required this.konten,
    required this.penulis,
    required this.tanggalPublikasi,
    this.imageUrl,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'] as String,
      judul: json['judul'] as String,
      slug: json['slug'] as String,
      konten: json['konten'] as String,
      penulis: json['penulis'] as String,
      tanggalPublikasi: DateTime.parse(json['tanggal_publikasi'] as String),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'slug': slug,
      'konten': konten,
      'penulis': penulis,
      'tanggal_publikasi': tanggalPublikasi.toIso8601String(),
      'image_url': imageUrl,
    };
  }
}
