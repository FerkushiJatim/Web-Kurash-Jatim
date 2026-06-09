class AppConstants {
  static const String appName = 'Kurash Jatim';
  static const String appFullName = 'Portal Kurash Jawa Timur';
  static const String appDescription =
      'Portal Resmi & Sistem Manajemen Konten Kurash Jawa Timur';
  static const String googleDrivePreviewBase =
      'https://drive.google.com/file/d/';
  static const String googleDrivePreviewSuffix = '/preview';

  static String googleDrivePreviewUrl(String fileId) =>
      '$googleDrivePreviewBase$fileId$googleDrivePreviewSuffix';
}

