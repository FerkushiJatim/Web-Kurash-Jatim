import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme.dart';
import '../../../../app/theme_provider.dart';
import '../../providers/admin_provider.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('lib/assets/logo-kurash-jatim.png', height: 32),
                  const SizedBox(width: 12),
                  Text(
                    'KURASH JATIM',
                    style: TextStyle(
                      color: context.colors.primaryGold,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Panel Admin',
                style: TextStyle(color: context.colors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
        Divider(color: context.colors.borderColor, height: 1),
        SizedBox(height: 8),
        // Menu items
        _SidebarItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
          route: '/admin',
          isActive: currentPath == '/admin',
        ),
        _SidebarItem(
          icon: Icons.calendar_today,
          label: 'Kelola Jadwal',
          route: '/admin/jadwal',
          isActive: currentPath == '/admin/jadwal',
        ),
        _SidebarItem(
          icon: Icons.emoji_events,
          label: 'Kelola Turnamen',
          route: '/admin/turnamen',
          isActive: currentPath == '/admin/turnamen',
        ),
        _SidebarItem(
          icon: Icons.description,
          label: 'Kelola Piagam',
          route: '/admin/piagam',
          isActive: currentPath == '/admin/piagam',
        ),
        _SidebarItem(
          icon: Icons.newspaper,
          label: 'Kelola Berita',
          route: '/admin/berita',
          isActive: currentPath == '/admin/berita',
        ),
        SizedBox(height: 16),
        // Theme Toggle
        Consumer<ThemeProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => provider.toggleTheme(),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          provider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                          size: 20,
                          color: context.colors.textMuted,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          provider.isDarkMode ? 'Mode Terang' : 'Mode Gelap',
                          style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
        // Logout
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final scaffold = Scaffold.maybeOf(context);
                if (scaffold != null && scaffold.isDrawerOpen) {
                  scaffold.closeDrawer();
                }
                context.read<AdminProvider>().logout();
                context.go('/admin/login');
              },
              icon: Icon(Icons.logout, size: 18),
              label: Text('Keluar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.errorRed,
                side: BorderSide(color: context.colors.errorRed),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? context.colors.primaryBlue.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              final scaffold = Scaffold.maybeOf(context);
              if (scaffold != null && scaffold.isDrawerOpen) {
                scaffold.closeDrawer();
              }
              context.go(route);
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isActive ? context.colors.primaryGold : context.colors.textMuted,
                  ),
                  SizedBox(width: 12),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isActive ? context.colors.textPrimary : context.colors.textSecondary,
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


