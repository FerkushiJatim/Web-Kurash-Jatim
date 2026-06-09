import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme.dart';
import '../../providers/piagam_provider.dart';
import '../../data/models/piagam_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../widgets/pdf_iframe_widget.dart';

class PiagamPage extends StatefulWidget {
  final String? turnamenNama;
  const PiagamPage({super.key, this.turnamenNama});

  @override
  State<PiagamPage> createState() => _PiagamPageState();
}

class _PiagamPageState extends State<PiagamPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<PiagamProvider>();
    Future.microtask(() {
      provider.clearSelection();
      provider.loadPiagam();
      if (widget.turnamenNama != null) {
        _searchController.text = widget.turnamenNama!;
        provider.searchByTurnamen(widget.turnamenNama!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<PiagamProvider>().searchByTurnamen(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header and Search Section
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final headerTexts = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arsip Piagam Turnamen',
                    style: TextStyle(
                      color: context.colors.primaryGold,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cari dan lihat arsip piagam atlet berdasarkan nama turnamen',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
                  ),
                ],
              );

              final searchField = Container(
                width: isWide ? 340 : double.infinity,
                margin: EdgeInsets.only(top: isWide ? 0 : 20),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: context.colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Cari nama turnamen...',
                    prefixIcon: Icon(Icons.search, color: context.colors.textMuted),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.colors.primaryGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 16, color: context.colors.primaryGold),
                        onPressed: _handleSearch,
                      ),
                    ),
                    filled: true,
                    fillColor: context.colors.surfaceCard,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.colors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.colors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.colors.primaryGold),
                    ),
                  ),
                  onSubmitted: (_) => _handleSearch(),
                ),
              );

              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: headerTexts),
                    SizedBox(width: 24),
                    searchField,
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerTexts,
                    searchField,
                  ],
                );
              }
            },
          ),
          SizedBox(height: 32),
          // Result section
          Consumer<PiagamProvider>(
            builder: (context, provider, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 320,
                          child: _buildPiagamList(provider),
                        ),
                        SizedBox(width: 24),
                        Expanded(child: _buildPiagamContent(provider)),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPiagamList(provider),
                      SizedBox(height: 24),
                      _buildPiagamContent(provider),
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

  Widget _buildPiagamList(PiagamProvider provider) {
    if (provider.isSearching) {
      return SizedBox(
        height: 200,
        child: LoadingIndicator(message: 'Mencari piagam...'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Piagam',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        if (provider.piagamList.isEmpty)
          Text('Belum ada arsip piagam.', style: TextStyle(color: context.colors.textMuted))
        else
          ...provider.piagamList.map((p) => _buildPiagamCard(p, provider)),
      ],
    );
  }

  Widget _buildPiagamCard(Piagam piagam, PiagamProvider provider) {
    final isSelected = provider.selectedPiagam?.id == piagam.id;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.primaryGold.withValues(alpha: 0.15) : context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.colors.primaryGold : context.colors.borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => provider.selectPiagam(piagam),
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
                        piagam.turnamenNama,
                        style: TextStyle(
                          color: isSelected ? context.colors.primaryGold : context.colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: context.colors.textMuted),
                    SizedBox(width: 6),
                    Text(
                      'Diterbitkan: ${piagam.tanggalTerbit.toString().split(' ')[0]}',
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

  Widget _buildPiagamContent(PiagamProvider provider) {
    if (provider.errorMessage != null && provider.selectedPiagam == null) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.colors.errorRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.errorRed.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: context.colors.errorRed),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(color: context.colors.errorRed, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.selectedPiagam == null) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf, size: 64, color: context.colors.textMuted.withValues(alpha: 0.5)),
                SizedBox(height: 16),
                Text(
                  'Pilih piagam untuk melihat pratinjau',
                  style: TextStyle(color: context.colors.textMuted, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final piagam = provider.selectedPiagam!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Pratinjau Piagam',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.borderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Builder(
              builder: (context) {
                if (piagam.pdfUrl.isEmpty) {
                  return Center(child: Text('PDF tidak tersedia', style: TextStyle(color: context.colors.textMuted)));
                }
                
                final fileIdMatch = RegExp(r'id=([\w-]{25,})').firstMatch(piagam.pdfUrl);
                final fileId = fileIdMatch?.group(1);
                
                if (fileId == null) {
                   return Center(child: Text('Format link PDF tidak valid', style: TextStyle(color: context.colors.textMuted)));
                }

                return PdfIframeWidget(
                  googleDriveFileId: fileId,
                  height: 600,
                );
              }
            ),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            if (piagam.pdfUrl.isNotEmpty) {
              final url = Uri.parse(piagam.pdfUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            }
          },
          icon: Icon(Icons.download),
          label: Text('Download PDF'),
        ),
      ],
    );
  }
}


