import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.colors.surfaceDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 3, color: context.colors.primaryBlue),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildBrandColumn(context)),
                          const SizedBox(width: 32),
                          Expanded(child: _buildKontakColumn(context)),
                          const SizedBox(width: 32),
                          Expanded(child: _buildSosmedColumn(context)),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrandColumn(context),
                        const SizedBox(height: 24),
                        _buildKontakColumn(context),
                        const SizedBox(height: 24),
                        _buildSosmedColumn(context),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Divider(height: 1, color: context.colors.borderColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '© 2026 Kurash Jawa Timur. Seluruh hak cipta dilindungi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('lib/assets/logo-kurash-jatim.png', height: 48),
            const SizedBox(width: 12),
            Text('KURASH JATIM', style: TextStyle(color: context.colors.primaryBlue, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Federasi Olahraga Kurash Provinsi Jawa Timur. Mengembangkan dan memajukan olahraga beladiri Kurash di seluruh wilayah Jawa Timur.',
          style: TextStyle(color: context.colors.textMuted, fontSize: 13, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildKontakColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kontak', style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _buildKontakItem(context, Icons.location_on_outlined, 'Jl. Contoh No. 123, Surabaya, Jawa Timur'),
        const SizedBox(height: 8),
        _buildKontakItem(context, Icons.email_outlined, 'ferkushijatim16@gmail.com'),
        const SizedBox(height: 8),
        _buildKontakItem(context, Icons.phone_outlined, '+62 812-3456-7890'),
      ],
    );
  }

  Widget _buildKontakItem(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.colors.textMuted),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: context.colors.textMuted, fontSize: 13))),
      ],
    );
  }

  Widget _buildSosmedColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ikuti Kami', style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSosmedIcon(context, FaIcon(FontAwesomeIcons.instagram, size: 18, color: context.colors.textSecondary), 'Instagram', () {}),
            const SizedBox(width: 12),
            _buildSosmedIcon(context, FaIcon(FontAwesomeIcons.youtube, size: 18, color: context.colors.textSecondary), 'YouTube', () async {
              final url = Uri.parse('https://www.youtube.com/@FerkushiJawaTimur');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            }),
            const SizedBox(width: 12),
            _buildSosmedIcon(context, FaIcon(FontAwesomeIcons.facebook, size: 18, color: context.colors.textSecondary), 'Facebook', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSosmedIcon(BuildContext context, Widget icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: context.colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: context.colors.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 36, height: 36,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
