import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../providers/beranda_provider.dart';
import '../../../../shared/widgets/hover_scale_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<BerandaProvider>().loadBeranda();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BerandaProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroSection(context),
            const SizedBox(height: 48),
            _buildStatistikSection(context, provider),
            const SizedBox(height: 56),
            _buildBeritaSection(context, provider),
            const SizedBox(height: 56),
            _buildAgendaSection(context, provider),
            const SizedBox(height: 64),
          ],
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      color: context.colors.primaryBlue,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text(
                'KURASH JAWA TIMUR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Federasi Olahraga Kurash Provinsi Jawa Timur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () => context.go('/jadwal'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Lihat Agenda', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistikSection(BuildContext context, BerandaProvider provider) {
    final stats = provider.statistik;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              final children = [
                _buildStatCard(context, '${stats['events'] ?? 0}', 'Total Event', context.colors.primaryBlue, isWide),
                _buildStatCard(context, '${stats['turnamen'] ?? 0}', 'Total Turnamen', const Color(0xFFD4AF37), isWide),
                _buildStatCard(context, '${stats['piagam'] ?? 0}', 'Piagam Terbit', context.colors.successGreen, isWide),
              ];
              return Row(
                children: children.map((c) => Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: isWide ? 8 : 4), child: c))).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color accentColor, bool isWide) {
    return HoverScaleCard(
      scale: 1.03,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isWide ? 28 : 16, horizontal: isWide ? 24 : 8),
        decoration: BoxDecoration(
          color: context.colors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.colors.borderColor),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: isWide ? 36 : 24, fontWeight: FontWeight.w800, color: accentColor),
            ),
            SizedBox(height: isWide ? 6 : 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isWide ? 14 : 11, fontWeight: FontWeight.w500, color: context.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeritaSection(BuildContext context, BerandaProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Berita Terbaru', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                  TextButton(
                    onPressed: () => context.go('/berita'),
                    child: Text('Lihat Semua →', style: TextStyle(color: context.colors.primaryBlue, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(width: 40, height: 3, color: context.colors.primaryBlue),
              const SizedBox(height: 24),
              if (provider.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
              else if (provider.beritaTerbaru.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(color: context.colors.surfaceCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.colors.borderColor)),
                  child: Text('Belum ada berita dipublikasikan.', textAlign: TextAlign.center, style: TextStyle(color: context.colors.textMuted)),
                )
              else
                LayoutBuilder(
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
                        childAspectRatio: 0.9,
                      ),
                      itemCount: provider.beritaTerbaru.length,
                      itemBuilder: (context, index) {
                        final berita = provider.beritaTerbaru[index];
                        return _buildBeritaCard(context, berita);
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeritaCard(BuildContext context, dynamic berita) {
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return HoverScaleCard(
      onTap: () => context.go('/berita/${berita.id}'),
      child: Container(
          decoration: BoxDecoration(
            color: context.colors.surfaceCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.colors.borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                color: context.colors.surfaceElevated,
                child: berita.imageUrl != null && berita.imageUrl!.isNotEmpty
                    ? Image.network(berita.imageUrl!, fit: BoxFit.cover, errorBuilder: (ctx, error, stackTrace) => Center(child: Icon(Icons.image, size: 40, color: context.colors.textMuted)))
                    : Center(child: Icon(Icons.newspaper, size: 40, color: context.colors.textMuted)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateFormat.format(berita.tanggalPublikasi), style: TextStyle(color: context.colors.primaryBlue, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(berita.judul, style: TextStyle(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(berita.konten, style: TextStyle(color: context.colors.textSecondary, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildAgendaSection(BuildContext context, BerandaProvider provider) {
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Agenda Mendatang', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
              const SizedBox(height: 4),
              Container(width: 40, height: 3, color: context.colors.primaryBlue),
              const SizedBox(height: 24),
              if (provider.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
              else if (provider.agendaMendatang.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(color: context.colors.surfaceCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.colors.borderColor)),
                  child: Text('Belum ada agenda mendatang.', textAlign: TextAlign.center, style: TextStyle(color: context.colors.textMuted)),
                )
              else
                ...provider.agendaMendatang.map((event) => HoverScaleCard(
                  onTap: () => context.go('/jadwal'),
                  scale: 1.01,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 1),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceCard,
                      border: Border(bottom: BorderSide(color: context.colors.borderColor)),
                    ),
                  child: Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(color: context.colors.primaryBlue, borderRadius: BorderRadius.circular(8)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(DateFormat('d').format(event.tanggalMulai), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, height: 1)),
                          Text(DateFormat('MMM').format(event.tanggalMulai), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(event.judul, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.colors.textPrimary)),
                          const SizedBox(height: 4),
                          Row(children: [
                            Icon(Icons.location_on, size: 13, color: context.colors.textMuted),
                            const SizedBox(width: 4),
                            Text(event.lokasi, style: TextStyle(fontSize: 13, color: context.colors.textMuted)),
                            const SizedBox(width: 12),
                            Text(dateFormat.format(event.tanggalMulai), style: TextStyle(fontSize: 12, color: context.colors.textMuted)),
                          ]),
                        ]),
                      ),
                    ],
                  ),
                ))),
            ],
          ),
        ),
      ),
    );
  }
}
