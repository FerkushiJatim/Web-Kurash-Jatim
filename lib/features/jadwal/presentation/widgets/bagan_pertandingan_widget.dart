import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/models/pertandingan_model.dart';

class BaganPertandinganWidget extends StatelessWidget {
  final List<Pertandingan> pertandingan;

  const BaganPertandinganWidget({super.key, required this.pertandingan});

  @override
  Widget build(BuildContext context) {
    if (pertandingan.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: context.colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.borderColor),
        ),
        child: Center(
          child: Text(
            'Belum ada data pertandingan',
            style: TextStyle(color: context.colors.textMuted, fontSize: 14),
          ),
        ),
      );
    }

    // Group by fase
    final Map<String, List<Pertandingan>> grouped = {};
    for (final p in pertandingan) {
      grouped.putIfAbsent(p.fase, () => []).add(p);
    }

    final faseOrder = ['penyisihan', 'perempat_final', 'semifinal', 'final'];
    final orderedFases = faseOrder.where((f) => grouped.containsKey(f)).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bagan Pertandingan',
            style: TextStyle(
              color: context.colors.primaryGold,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: orderedFases.map((fase) {
                final matches = grouped[fase]!;
                final faseLabel = _formatFaseLabel(fase);
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: context.colors.primaryBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          faseLabel,
                          style: TextStyle(
                            color: context.colors.primaryGold,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      ...matches.map((match) => _buildMatchCard(context, match)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, Pertandingan match) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: Column(
        children: [
          _buildAtletRow(
            context,
            match.atletMerah,
            Colors.red.shade400,
            isWinner: match.pemenangId == match.atletMerah.atletId,
          ),
          Container(height: 1, color: context.colors.borderColor),
          _buildAtletRow(
            context,
            match.atletBiru,
            Colors.blue.shade400,
            isWinner: match.pemenangId == match.atletBiru.atletId,
          ),
        ],
      ),
    );
  }

  Widget _buildAtletRow(BuildContext context, Peserta peserta, Color sideColor, {required bool isWinner}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isWinner ? context.colors.primaryGold.withValues(alpha: 0.08) : Colors.transparent,
        border: Border(left: BorderSide(color: sideColor, width: 3)),
      ),
      child: Row(
        children: [
          if (isWinner)
            Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.emoji_events, size: 14, color: context.colors.primaryGold),
            ),
          Expanded(
            child: Text(
              peserta.nama,
              style: TextStyle(
                color: isWinner ? context.colors.primaryGold : context.colors.textPrimary,
                fontSize: 13,
                fontWeight: isWinner ? FontWeight.w600 : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${peserta.skor}',
            style: TextStyle(
              color: isWinner ? context.colors.primaryGold : context.colors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFaseLabel(String fase) {
    switch (fase) {
      case 'penyisihan': return 'Penyisihan';
      case 'perempat_final': return 'Perempat Final';
      case 'semifinal': return 'Semifinal';
      case 'final': return 'Final';
      default: return fase;
    }
  }
}


