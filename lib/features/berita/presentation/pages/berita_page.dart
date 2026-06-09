import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../providers/berita_provider.dart';
import '../../../../shared/widgets/loading_indicator.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<BeritaProvider>();
    Future.microtask(() => provider.fetchBerita());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berita & Pembaruan',
            style: TextStyle(
              color: context.colors.primaryGold,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ikuti kabar terbaru dan pengumuman resmi seputar Kurash di Jawa Timur',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          SizedBox(height: 32),
          Consumer<BeritaProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const SizedBox(
                  height: 300,
                  child: LoadingIndicator(message: 'Memuat berita...'),
                );
              }

              if (provider.errorMessage != null) {
                return Center(
                  child: Text(
                    provider.errorMessage!,
                    style: TextStyle(color: context.colors.errorRed),
                  ),
                );
              }

              if (provider.beritaList.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.borderColor),
                    ),
                    child: Text(
                      'Belum ada berita yang dipublikasikan.',
                      style: TextStyle(color: context.colors.textMuted, fontSize: 16),
                    ),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 600) crossAxisCount = 2;
                  if (constraints.maxWidth > 900) crossAxisCount = 3;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: provider.beritaList.length,
                    itemBuilder: (context, index) {
                      final berita = provider.beritaList[index];
                      return GestureDetector(
                        onTap: () => context.go('/berita/${berita.id}'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.colors.surfaceCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.colors.borderColor),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 160,
                                width: double.infinity,
                                color: context.colors.surfaceElevated,
                                child: berita.imageUrl != null
                                    ? Image.network(berita.imageUrl!, fit: BoxFit.cover)
                                    : Icon(Icons.newspaper, size: 60, color: context.colors.textMuted),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${berita.tanggalPublikasi.day}-${berita.tanggalPublikasi.month}-${berita.tanggalPublikasi.year}',
                                      style: TextStyle(color: context.colors.primaryGold, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      berita.judul,
                                      style: TextStyle(
                                        color: context.colors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      berita.konten,
                                      style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
