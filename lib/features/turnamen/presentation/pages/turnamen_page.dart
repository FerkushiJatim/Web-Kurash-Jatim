import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../providers/turnamen_provider.dart';
import '../../data/models/turnamen_model.dart';
import '../widgets/klasemen_table_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../piagam/presentation/widgets/pdf_iframe_widget.dart';
class TurnamenPage extends StatefulWidget {
  const TurnamenPage({super.key});

  @override
  State<TurnamenPage> createState() => _TurnamenPageState();
}

class _TurnamenPageState extends State<TurnamenPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<TurnamenProvider>();
    Future.microtask(() {
      provider.clearSelection();
      provider.loadTurnamen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Portal Hasil Turnamen',
            style: TextStyle(
              color: context.colors.primaryGold,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Lihat hasil dan klasemen turnamen Kurash Jawa Timur',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          SizedBox(height: 32),
          // Content
          Consumer<TurnamenProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.turnamenList.isEmpty) {
                return SizedBox(
                  height: 300,
                  child: LoadingIndicator(message: 'Memuat data turnamen...'),
                );
              }

              if (provider.errorMessage != null && provider.turnamenList.isEmpty) {
                return _buildErrorState(provider.errorMessage!);
              }

              if (provider.turnamenList.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.borderColor),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 48, color: context.colors.textMuted),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada turnamen tersedia',
                          style: TextStyle(color: context.colors.textMuted, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 320,
                          child: _buildTurnamenList(provider),
                        ),
                        SizedBox(width: 24),
                        Expanded(child: _buildKlasemenSection(provider)),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildTurnamenList(provider),
                      SizedBox(height: 24),
                      _buildKlasemenSection(provider),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTurnamenList(TurnamenProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Turnamen',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...provider.turnamenList.map((t) => _buildTurnamenCard(t, provider)),
      ],
    );
  }

  Widget _buildTurnamenCard(Turnamen turnamen, TurnamenProvider provider) {
    final isSelected = provider.selectedTurnamen?.id == turnamen.id;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.primaryBlue.withValues(alpha: 0.15) : context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.colors.primaryBlue : context.colors.borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => provider.selectTurnamen(turnamen),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    turnamen.nama,
                    style: TextStyle(
                      color: isSelected ? context.colors.primaryGold : context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildStatusBadge(turnamen.status),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: context.colors.textMuted),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    turnamen.lokasi,
                    style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: context.colors.textMuted),
                SizedBox(width: 4),
                Text(
                  '${turnamen.jumlahPeserta} peserta',
                  style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'upcoming':
        color = context.colors.primaryGold;
        label = 'Akan Datang';
        break;
      case 'ongoing':
        color = context.colors.successGreen;
        label = 'Berlangsung';
        break;
      case 'completed':
        color = context.colors.textMuted;
        label = 'Selesai';
        break;
      default:
        color = context.colors.textMuted;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildKlasemenSection(TurnamenProvider provider) {
    if (provider.selectedTurnamen == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 42.0),
        child: Container(
          padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: context.colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.borderColor),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.emoji_events, size: 48, color: context.colors.textMuted),
              SizedBox(height: 16),
              Text(
                'Pilih turnamen untuk melihat klasemen',
                style: TextStyle(color: context.colors.textMuted, fontSize: 15),
              ),
            ],
          ),
        ),
       ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: SizedBox(
              height: 200,
              child: LoadingIndicator(message: 'Memuat klasemen...'),
            ),
          )
        else if (provider.filteredKlasemen.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: KlasemenTableWidget(klasemenList: provider.filteredKlasemen),
          ),
        
        if (provider.selectedTurnamen!.lampiranList.isNotEmpty) ...[
          ...provider.selectedTurnamen!.lampiranList.map((lampiran) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    lampiran.judul,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colors.borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Builder(
                      builder: (context) {
                        final url = lampiran.url;
                        final fileIdMatch = RegExp(r'id=([\w-]{25,})').firstMatch(url);
                        final dMatch = RegExp(r'd/([\w-]{25,})').firstMatch(url);
                        final fileId = fileIdMatch?.group(1) ?? dMatch?.group(1);
                        
                        if (fileId == null) {
                          return Container(
                            height: 100,
                            color: context.colors.surfaceCard,
                            child: Center(child: Text('Format link PDF tidak valid', style: TextStyle(color: context.colors.textMuted))),
                          );
                        }
                        
                        return PdfIframeWidget(
                          googleDriveFileId: fileId,
                          height: 600,
                        );
                      }
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (lampiran.url.isNotEmpty) {
                      final url = Uri.parse(lampiran.url);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    }
                  },
                  icon: Icon(Icons.download),
                  label: Text('Download PDF'),
                ),
                SizedBox(height: 32),
              ],
            );
          }),
        ],
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.colors.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.errorRed.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: context.colors.errorRed, fontSize: 14),
        ),
      ),
    );
  }
}


