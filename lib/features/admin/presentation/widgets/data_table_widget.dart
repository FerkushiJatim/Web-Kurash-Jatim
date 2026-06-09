import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class AdminDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final List<Widget> Function(int rowIndex)? actionsBuilder;

  const AdminDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.actionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: context.colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.borderColor),
        ),
        child: Center(
          child: Text(
            'Tidak ada data',
            style: TextStyle(color: context.colors.textMuted, fontSize: 14),
          ),
        ),
      );
    }

    final allColumns = [
      ...columns.map((c) => DataColumn(
        label: Text(c, style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600, fontSize: 13)),
      )),
      if (actionsBuilder != null)
        DataColumn(
          label: Text('Aksi', style: TextStyle(color: context.colors.primaryGold, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(context.colors.surfaceElevated),
            columnSpacing: 20,
            horizontalMargin: 16,
            columns: allColumns,
            rows: List.generate(rows.length, (index) {
              final row = rows[index];
              final isEven = index % 2 == 0;
              return DataRow(
                color: WidgetStateProperty.all(
                  isEven ? context.colors.surfaceCard : context.colors.surfaceElevated.withValues(alpha: 0.3),
                ),
                cells: [
                  ...row.map((cell) => DataCell(
                    Text(cell, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                  )),
                  if (actionsBuilder != null)
                    DataCell(Row(children: actionsBuilder!(index))),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}


