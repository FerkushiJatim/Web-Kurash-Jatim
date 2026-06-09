import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../features/jadwal/presentation/pages/jadwal_page.dart';
import '../features/beranda/presentation/pages/beranda_page.dart';
import '../features/turnamen/presentation/pages/turnamen_page.dart';
import '../features/piagam/presentation/pages/piagam_page.dart';
import '../features/berita/presentation/pages/berita_page.dart';
import '../features/berita/presentation/pages/berita_detail_page.dart';
import '../features/admin/presentation/pages/login_page.dart';
import '../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../features/admin/presentation/pages/kelola_jadwal_page.dart';
import '../features/admin/presentation/pages/kelola_turnamen_page.dart';
import '../features/admin/presentation/pages/kelola_piagam_page.dart';
import '../features/admin/presentation/pages/kelola_berita_page.dart';
import '../features/admin/providers/admin_provider.dart';
import '../shared/layouts/public_layout.dart';
import '../shared/layouts/admin_layout.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {
    final adminProvider = context.read<AdminProvider>();

    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final isLoggedIn = adminProvider.isAuthenticated;
        final isAdminRoute = state.matchedLocation.startsWith('/admin');
        final isLoginRoute = state.matchedLocation == '/admin/login';

        if (isAdminRoute && !isLoginRoute && !isLoggedIn) {
          return '/admin/login';
        }
        if (isLoginRoute && isLoggedIn) {
          return '/admin';
        }
        return null;
      },
      routes: [
        // Public routes with shell
        ShellRoute(
          builder: (context, state, child) => PublicLayout(child: child),
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              pageBuilder: (context, state) => const NoTransitionPage(child: BerandaPage()),
            ),
            GoRoute(
              path: '/jadwal',
              name: 'jadwal',
              pageBuilder: (context, state) => const NoTransitionPage(child: JadwalPage()),
            ),
            GoRoute(
              path: '/turnamen',
              name: 'turnamen',
              pageBuilder: (context, state) => const NoTransitionPage(child: TurnamenPage()),
            ),
            GoRoute(
              path: '/piagam',
              name: 'piagam',
              pageBuilder: (context, state) => const NoTransitionPage(child: PiagamPage()),
            ),
            GoRoute(
              path: '/piagam/:id',
              name: 'piagam-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return NoTransitionPage(child: PiagamPage(turnamenNama: id));
              },
            ),
            GoRoute(
              path: '/berita',
              name: 'berita',
              pageBuilder: (context, state) => const NoTransitionPage(child: BeritaPage()),
            ),
            GoRoute(
              path: '/berita/:id',
              name: 'berita-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return NoTransitionPage(child: BeritaDetailPage(id: id));
              },
            ),
          ],
        ),
        // Admin login (no shell)
        GoRoute(
          path: '/admin/login',
          name: 'admin-login',
          builder: (context, state) => const LoginPage(),
        ),
        // Admin routes with sidebar shell
        ShellRoute(
          builder: (context, state, child) => AdminLayout(child: child),
          routes: [
            GoRoute(
              path: '/admin',
              name: 'admin-dashboard',
              pageBuilder: (context, state) => const NoTransitionPage(child: AdminDashboardPage()),
            ),
            GoRoute(
              path: '/admin/jadwal',
              name: 'admin-jadwal',
              pageBuilder: (context, state) => const NoTransitionPage(child: KelolaJadwalPage()),
            ),
            GoRoute(
              path: '/admin/turnamen',
              name: 'admin-turnamen',
              pageBuilder: (context, state) => const NoTransitionPage(child: KelolaTurnamenPage()),
            ),
            GoRoute(
              path: '/admin/piagam',
              name: 'admin-piagam',
              pageBuilder: (context, state) => const NoTransitionPage(child: KelolaPiagamPage()),
            ),
            GoRoute(
              path: '/admin/berita',
              name: 'admin-berita',
              pageBuilder: (context, state) => const NoTransitionPage(child: KelolaBeritaPage()),
            ),
          ],
        ),
      ],
    );
  }
}

