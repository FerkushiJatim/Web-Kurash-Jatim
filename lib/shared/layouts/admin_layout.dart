import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../features/admin/presentation/widgets/admin_sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: context.colors.darkBg,
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text('Kurash Jatim Admin', style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              backgroundColor: context.colors.surfaceDark,
              iconTheme: IconThemeData(color: context.colors.textPrimary),
              elevation: 1,
            ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: Container(
                width: 260,
                color: context.colors.surfaceDark,
                child: const AdminSidebar(),
              ),
            ),
      body: Row(
        children: [
          // Sidebar
          if (isDesktop)
            Container(
              width: 260,
              decoration: BoxDecoration(
                color: context.colors.surfaceDark,
                border: Border(
                  right: BorderSide(color: context.colors.borderColor, width: 1),
                ),
              ),
              child: const AdminSidebar(),
            ),
          // Content area
          Expanded(
            child: Container(
              color: context.colors.darkBg,
              padding: EdgeInsets.all(isDesktop ? 24 : 8),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}


