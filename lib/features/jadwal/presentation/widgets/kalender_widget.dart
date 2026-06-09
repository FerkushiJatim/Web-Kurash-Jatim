import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme.dart';
import '../../data/models/event_model.dart';
import '../../providers/jadwal_provider.dart';

class KalenderWidget extends StatelessWidget {
  final Function(DateTime date, List<Event> events)? onDateTap;

  const KalenderWidget({super.key, this.onDateTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<JadwalProvider>(
      builder: (context, provider, child) {
        final selectedMonth = provider.selectedMonth;
        final year = selectedMonth.year;
        final month = selectedMonth.month;

        final firstDay = DateTime(year, month, 1);
        final lastDay = DateTime(year, month + 1, 0);
        final startWeekday = firstDay.weekday; // 1=Monday

        final dayLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
        final monthNames = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.borderColor),
          ),
          child: Column(
            children: [
              // Month navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => provider.changeMonth(-1),
                    icon: Icon(Icons.chevron_left, color: context.colors.primaryGold),
                  ),
                  Text(
                    '${monthNames[month - 1]} $year',
                    style: TextStyle(
                      color: context.colors.primaryGold,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => provider.changeMonth(1),
                    icon: Icon(Icons.chevron_right, color: context.colors.primaryGold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Day labels row
              Row(
                children: dayLabels.map((label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )).toList(),
              ),
              SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Column(
                  key: ValueKey<int>(year * 100 + month),
                  children: _buildWeeks(context, year, month, startWeekday, lastDay.day, provider),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildWeeks(BuildContext context, int year, int month, int startWeekday, int daysInMonth, JadwalProvider provider) {
    final today = DateTime.now();
    final weeks = <Widget>[];
    int dayCounter = 1;

    for (int week = 0; week < 6; week++) {
      if (dayCounter > daysInMonth) break;

      final dayCells = <Widget>[];
      for (int weekday = 1; weekday <= 7; weekday++) {
        if ((week == 0 && weekday < startWeekday) || dayCounter > daysInMonth) {
          dayCells.add(Expanded(child: SizedBox(height: 48)));
        } else {
          final day = dayCounter;
          final date = DateTime(year, month, day);
          final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
          final eventsOnDay = provider.getEventsForDate(date);
          final hasEvents = eventsOnDay.isNotEmpty;

          dayCells.add(
            Expanded(
              child: GestureDetector(
                onTap: hasEvents ? () => onDateTap?.call(date, eventsOnDay) : null,
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday ? context.colors.primaryGold.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday ? Border.all(color: context.colors.primaryGold, width: 1) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          color: isToday ? context.colors.primaryGold : context.colors.textPrimary,
                          fontSize: 14,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      if (hasEvents)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: context.colors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }

      weeks.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(children: dayCells),
        ),
      );
    }

    return weeks;
  }
}


