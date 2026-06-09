class ApiEndpoints {
  static const String baseUrl = 'https://api.kurashjatim.com/v1';

  // Jadwal / Events
  static const String events = '/events';
  static String eventById(String id) => '/events/$id';

  // Turnamen / Tournament
  static const String turnamen = '/turnamen';
  static String turnamenById(String id) => '/turnamen/$id';
  static String klasemen(String turnamenId) =>
      '/turnamen/$turnamenId/klasemen';

  // Pertandingan / Matches
  static const String pertandingan = '/pertandingan';
  static String pertandinganByEvent(String eventId) =>
      '/events/$eventId/pertandingan';

  // Atlet / Athletes
  static const String atlet = '/atlet';
  static String atletById(String id) => '/atlet/$id';

  // Piagam / Certificates
  static const String piagam = '/piagam';
  static String piagamById(String id) => '/piagam/$id';
  static String piagamByReferensi(String ref) => '/piagam/referensi/$ref';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  // Berita
  static const String berita = '/berita';
  static String beritaById(String id) => '/berita/$id';
}

