import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme.dart';
import '../../data/models/event_model.dart';
import '../../providers/jadwal_provider.dart';
import '../widgets/kalender_widget.dart';
import '../widgets/bagan_pertandingan_widget.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<JadwalProvider>();
    Future.microtask(
      () => provider.loadEvents(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JadwalProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 32),
              if (provider.isLoading && provider.events.isEmpty)
                const _LoadingIndicator()
              else if (provider.errorMessage != null && provider.events.isEmpty)
                _ErrorCard(message: provider.errorMessage!)
              else ...[
                KalenderWidget(
                  onDateTap: (date, eventsOnDate) {
                    if (eventsOnDate.isNotEmpty) {
                      provider.selectEvent(eventsOnDate.first);
                      provider.loadPertandingan(eventsOnDate.first.id);
                    }
                  },
                ),
                SizedBox(height: 32),
                if (provider.selectedEvent != null) ...[
                  _buildSelectedEventDetails(provider),
                  SizedBox(height: 24),
                  if (provider.isLoading)
                    const _LoadingIndicator()
                  else
                    BaganPertandinganWidget(
                      pertandingan: provider.pertandingan,
                    ),
                ] else
                  _buildMonthEventsList(provider),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 36,
              decoration: BoxDecoration(
                color: context.colors.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pusat Jadwal Acara',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Lihat informasi kalender kegiatan mulai dari turnamen, rapat, pelatihan, latihan gabungan, dan agenda penting Kurash Jawa Timur lainnya.',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedEventDetails(JadwalProvider provider) {
    final event = provider.selectedEvent!;
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatusBadge(event.status),
                        SizedBox(width: 8),
                        _buildKategoriBadge(event.kategori),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      event.judul,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => provider.clearSelectedEvent(),
                icon: Icon(Icons.close, color: context.colors.textMuted),
                tooltip: 'Tutup detail',
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDetailRow(
            Icons.calendar_today,
            '${dateFormat.format(event.tanggalMulai)} — ${dateFormat.format(event.tanggalSelesai)}',
          ),
          SizedBox(height: 8),
          _buildDetailRow(Icons.location_on, event.lokasi),
          SizedBox(height: 12),
          Text(
            event.deskripsi,
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textSecondary,
              height: 1.6,
            ),
          ),
          if (event.posterUrl != null && event.posterUrl!.isNotEmpty) ...[
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                event.posterUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.broken_image,
                      color: context.colors.textMuted,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.colors.primaryGold),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'ongoing':
        bgColor = context.colors.successGreen.withValues(alpha: 0.2);
        textColor = context.colors.successGreen;
        label = 'Berlangsung';
        break;
      case 'completed':
        bgColor = context.colors.textMuted.withValues(alpha: 0.2);
        textColor = context.colors.textMuted;
        label = 'Selesai';
        break;
      case 'upcoming':
      default:
        bgColor = context.colors.primaryGold.withValues(alpha: 0.2);
        textColor = context.colors.primaryGold;
        label = 'Akan Datang';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  Widget _buildKategoriBadge(String kategori) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.primaryBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        kategori,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: context.colors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildMonthEventsList(JadwalProvider provider) {
    final selectedMonth = provider.selectedMonth;
    final monthEvents = provider.events
        .where((e) => e.tanggalMulai.year == selectedMonth.year && e.tanggalMulai.month == selectedMonth.month)
        .toList()
      ..sort((a, b) => a.tanggalMulai.compareTo(b.tanggalMulai));

    if (monthEvents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: context.colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.borderColor),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_busy, size: 48, color: context.colors.textMuted),
              SizedBox(height: 12),
              Text(
                'Tidak ada jadwal acara pada bulan ini',
                style: TextStyle(fontSize: 16, color: context.colors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Acara',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: 16),
        ...monthEvents.map((event) => _buildEventCard(event, provider)),
      ],
    );
  }

  Widget _buildEventCard(Event event, JadwalProvider provider) {
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            provider.selectEvent(event);
            provider.loadPertandingan(event.id);
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: context.colors.primaryBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d').format(event.tanggalMulai),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: context.colors.primaryBlue,
                          height: 1,
                        ),
                      ),
                      Text(
                        DateFormat('MMM', 'id_ID').format(event.tanggalMulai),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.colors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.judul,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 13, color: context.colors.textMuted),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.lokasi,
                              style: TextStyle(
                                fontSize: 12,
                                color: context.colors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${dateFormat.format(event.tanggalMulai)} — ${dateFormat.format(event.tanggalSelesai)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                _buildStatusBadge(event.status),
                SizedBox(width: 8),
                Icon(Icons.chevron_right,
                    color: context.colors.textMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(
          color: context.colors.primaryGold,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.errorRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.colors.errorRed, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gagal memuat data',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.colors.errorRed,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 12, color: context.colors.textMuted),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          IconButton(
            onPressed: () => context.read<JadwalProvider>().loadEvents(),
            icon: Icon(Icons.refresh, color: context.colors.primaryGold),
            tooltip: 'Coba lagi',
          ),
        ],
      ),
    );
  }
}


