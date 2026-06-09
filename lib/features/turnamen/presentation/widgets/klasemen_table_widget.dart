import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../data/models/klasemen_model.dart';

class KlasemenTableWidget extends StatelessWidget {
  final List<Klasemen> klasemenList;

  const KlasemenTableWidget({super.key, required this.klasemenList});

  @override
  Widget build(BuildContext context) {
    if (klasemenList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(context.colors.surfaceElevated),
            dataRowColor: WidgetStateProperty.all(context.colors.surfaceCard),
            columnSpacing: 24,
            horizontalMargin: 20,
            columns: [
              DataColumn(label: Text('#', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600))),
              DataColumn(label: Text('Nama Atlet', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600))),
              DataColumn(label: Text('Klub Asal', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600))),
              DataColumn(label: Text('Poin', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600)), numeric: true),
              DataColumn(label: Text('M', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600)), numeric: true),
              DataColumn(label: Text('K', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600)), numeric: true),
              DataColumn(label: Text('S', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600)), numeric: true),
              DataColumn(label: Text('Medali', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600))),
            ],
            rows: klasemenList.map((k) {
              Color? rowColor;
              if (k.peringkat == 1) rowColor = Colors.amber.withValues(alpha: 0.06);
              if (k.peringkat == 2) rowColor = Colors.grey.shade300.withValues(alpha: 0.06);
              if (k.peringkat == 3) rowColor = Colors.brown.shade300.withValues(alpha: 0.06);

              String medaliText;
              switch (k.medali) {
                case 'emas': medaliText = '🥇'; break;
                case 'perak': medaliText = '🥈'; break;
                case 'perunggu': medaliText = '🥉'; break;
                default: medaliText = '-';
              }

              return DataRow(
                color: rowColor != null ? WidgetStateProperty.all(rowColor) : null,
                cells: [
                  DataCell(Text('${k.peringkat}', style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600))),
                  DataCell(Text(k.namaAtlet, style: TextStyle(color: context.colors.textPrimary))),
                  DataCell(Text(k.klubAsal, style: TextStyle(color: context.colors.textSecondary))),
                  DataCell(Text('${k.poin}', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w700))),
                  DataCell(Text('${k.menang}', style: TextStyle(color: context.colors.successGreen))),
                  DataCell(Text('${k.kalah}', style: TextStyle(color: context.colors.errorRed))),
                  DataCell(Text('${k.seri}', style: TextStyle(color: context.colors.textSecondary))),
                  DataCell(Text(medaliText, style: TextStyle(fontSize: 18))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


