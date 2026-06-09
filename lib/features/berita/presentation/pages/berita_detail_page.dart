import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../providers/berita_provider.dart';
import '../../../../shared/widgets/loading_indicator.dart';

class BeritaDetailPage extends StatefulWidget {
  final String id;
  const BeritaDetailPage({super.key, required this.id});

  @override
  State<BeritaDetailPage> createState() => _BeritaDetailPageState();
}

class _BeritaDetailPageState extends State<BeritaDetailPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<BeritaProvider>();
    Future.microtask(() => provider.fetchBeritaById(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BeritaProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: LoadingIndicator(message: 'Memuat artikel...'));
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Text(
              provider.errorMessage!,
              style: TextStyle(color: context.colors.errorRed),
            ),
          );
        }

        final berita = provider.selectedBerita;
        if (berita == null) {
          return Center(
            child: Text(
              'Berita tidak ditemukan',
              style: TextStyle(color: context.colors.textMuted),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/berita'),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: context.colors.primaryGold, size: 16),
                        SizedBox(width: 8),
                        Text('Kembali ke Indeks', style: TextStyle(color: context.colors.primaryGold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    berita.judul,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: context.colors.textMuted),
                      SizedBox(width: 4),
                      Text(berita.penulis, style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
                      SizedBox(width: 16),
                      Icon(Icons.calendar_today, size: 16, color: context.colors.textMuted),
                      SizedBox(width: 4),
                      Text(
                        '${berita.tanggalPublikasi.day}-${berita.tanggalPublikasi.month}-${berita.tanggalPublikasi.year}',
                        style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  if (berita.imageUrl != null)
                    Container(
                      width: double.infinity,
                      height: 400,
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(berita.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Text(
                    berita.konten,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
