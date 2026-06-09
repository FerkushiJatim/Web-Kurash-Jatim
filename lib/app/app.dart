import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'theme_provider.dart';
import 'router.dart';
import '../features/jadwal/providers/jadwal_provider.dart';
import '../features/jadwal/data/repositories/jadwal_repository.dart';
import '../features/turnamen/providers/turnamen_provider.dart';
import '../features/turnamen/data/repositories/turnamen_repository.dart';
import '../features/piagam/providers/piagam_provider.dart';
import '../features/piagam/data/repositories/piagam_repository.dart';
import '../features/berita/providers/berita_provider.dart';
import '../features/berita/data/repositories/berita_repository.dart';
import '../features/admin/providers/admin_provider.dart';
import '../features/admin/data/repositories/admin_repository.dart';
import '../features/beranda/providers/beranda_provider.dart';
import '../features/beranda/data/repositories/beranda_repository.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;
  bool _routerInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AdminProvider(AdminRepository(null)),
        ),
        ChangeNotifierProvider(
          create: (_) => JadwalProvider(JadwalRepository(null)),
        ),
        ChangeNotifierProvider(
          create: (_) => TurnamenProvider(TurnamenRepository(null)),
        ),
        ChangeNotifierProvider(
          create: (_) => PiagamProvider(PiagamRepository(null)),
        ),
        ChangeNotifierProvider(
          create: (_) => BeritaProvider(BeritaRepository(null)),
        ),
        ChangeNotifierProvider(
          create: (_) => BerandaProvider(BerandaRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          if (!_routerInitialized) {
            _router = AppRouter.router(context);
            _routerInitialized = true;
          }
          final themeProvider = context.watch<ThemeProvider>();
          return MaterialApp.router(
            title: 'Kurash Jatim',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

