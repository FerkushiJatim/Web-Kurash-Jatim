import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme.dart';
import '../../providers/admin_provider.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<AdminProvider>();
    Future.microtask(() {
      provider.loadEvents();
      provider.loadTurnamen();
      provider.loadPiagam();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AdminProvider>(
            builder: (context, provider, child) {
              return Text(
                'Selamat Datang, ${provider.adminName ?? 'Admin'}',
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              );
            },
          ),
          SizedBox(height: 8),
          Text(
            'Ringkasan sistem manajemen konten Kurash Jawa Timur',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          SizedBox(height: 32),
          Consumer<AdminProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1);
                  return GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      mainAxisExtent: 180, // Increased to prevent overflow
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard(
                        'Total Event',
                        '${provider.events.length}',
                        Icons.calendar_month,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Total Turnamen',
                        '${provider.turnamenList.length}',
                        Icons.emoji_events,
                        context.colors.primaryGold,
                      ),
                      _buildStatCard(
                        'Piagam Terbit',
                        '${provider.piagamList.length}',
                        Icons.verified,
                        context.colors.successGreen,
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(height: 48),
          Text(
            'Aktivitas Terbaru',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: context.colors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.borderColor),
            ),
            child: Center(
              child: Text(
                'Belum ada aktivitas terbaru',
                style: TextStyle(color: context.colors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


