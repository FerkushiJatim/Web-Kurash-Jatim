import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_footer.dart';
import 'package:go_router/go_router.dart';

class PublicLayout extends StatelessWidget {
  final Widget child;
  const PublicLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.darkBg,
      drawer: Drawer(
        backgroundColor: context.colors.surfaceDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 24,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: context.colors.surfaceElevated,
                border: Border(bottom: BorderSide(color: context.colors.borderColor)),
              ),
              child: Row(
                children: [
                  Image.asset('lib/assets/logo-kurash-jatim.png', height: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'KURASH JATIM',
                      style: TextStyle(
                        color: context.colors.primaryBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, 'Beranda', '/', Icons.home),
            _buildDrawerItem(context, 'Jadwal', '/jadwal', Icons.calendar_month),
            _buildDrawerItem(context, 'Turnamen', '/turnamen', Icons.emoji_events),
            _buildDrawerItem(context, 'Piagam', '/piagam', Icons.workspace_premium),
            _buildDrawerItem(context, 'Berita', '/berita', Icons.newspaper),
          ],
        ),
      ),
      body: Column(
        children: [
          const AppNavbar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        child,
                        const AppFooter(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: context.colors.textSecondary),
      title: Text(title, style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        context.go(route);
      },
    );
  }
}


