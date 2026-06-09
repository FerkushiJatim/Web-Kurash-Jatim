import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../app/theme_provider.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Container(
      height: 64,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surfaceDark,
        border: Border(bottom: BorderSide(color: context.colors.borderColor, width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
            child: Row(
            children: [
              if (isMobile) ...[
                IconButton(
                  icon: Icon(Icons.menu, color: context.colors.textPrimary),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: 'Menu',
                  splashRadius: 18,
                ),
                const SizedBox(width: 16),
              ],
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Row(
                    children: [
                      Image.asset('lib/assets/logo-kurash-jatim.png', height: 40),
                      const SizedBox(width: 12),
                      Text(
                        'KURASH JATIM',
                        style: TextStyle(
                          color: context.colors.primaryBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (!isMobile) ...[
                _NavItem(label: 'Beranda', route: '/', isActive: currentPath == '/'),
                _NavItem(label: 'Jadwal', route: '/jadwal', isActive: currentPath.startsWith('/jadwal')),
                _NavItem(label: 'Turnamen', route: '/turnamen', isActive: currentPath.startsWith('/turnamen')),
                _NavItem(label: 'Piagam', route: '/piagam', isActive: currentPath.startsWith('/piagam')),
                _NavItem(label: 'Berita', route: '/berita', isActive: currentPath.startsWith('/berita')),
                const SizedBox(width: 8),
              ],
              Consumer<ThemeProvider>(
                builder: (context, provider, _) {
                  return IconButton(
                    icon: Icon(
                      provider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: context.colors.textMuted,
                      size: 20,
                    ),
                    onPressed: () => provider.toggleTheme(),
                    tooltip: provider.isDarkMode ? 'Mode Terang' : 'Mode Gelap',
                    splashRadius: 18,
                  );
                },
              ),
            ],
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isActive;

  const _NavItem({required this.label, required this.route, required this.isActive});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    if (widget.isActive) {
      textColor = context.colors.primaryBlue;
    } else if (_isHovered) {
      textColor = context.colors.primaryBlue;
    } else {
      textColor = context.colors.textSecondary;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? context.colors.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
