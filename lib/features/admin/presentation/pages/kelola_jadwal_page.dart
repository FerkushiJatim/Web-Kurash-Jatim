import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../app/theme.dart';
import '../../providers/admin_provider.dart';
import '../widgets/data_table_widget.dart';
import '../../../jadwal/data/models/event_model.dart';

class KelolaJadwalPage extends StatefulWidget {
  const KelolaJadwalPage({super.key});

  @override
  State<KelolaJadwalPage> createState() => _KelolaJadwalPageState();
}

class _KelolaJadwalPageState extends State<KelolaJadwalPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AdminProvider>().loadEvents();
    });
  }

  void _showAddEventDialog() {
    final judulCtrl = TextEditingController();
    final kategoriCtrl = TextEditingController();
    final lokasiCtrl = TextEditingController();
    final deskripsiCtrl = TextEditingController();
    final posterUrlCtrl = TextEditingController();
    String status = 'upcoming';
    DateTime tanggalMulai = DateTime.now();
    DateTime tanggalSelesai = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: ctx.colors.surfaceCard,
              title: Text('Tambah Event', style: TextStyle(color: ctx.colors.textPrimary)),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: judulCtrl,
                        style: TextStyle(color: ctx.colors.textPrimary),
                        decoration: const InputDecoration(hintText: 'Judul Event'),
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: kategoriCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Kategori')),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(context: ctx, initialDate: tanggalMulai, firstDate: DateTime(2020), lastDate: DateTime(2030));
                              if (picked != null) setDialogState(() => tanggalMulai = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(hintText: 'Tanggal Mulai'),
                              child: Text(DateFormatter.shortDate(tanggalMulai), style: TextStyle(color: ctx.colors.textPrimary)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(context: ctx, initialDate: tanggalSelesai, firstDate: DateTime(2020), lastDate: DateTime(2030));
                              if (picked != null) setDialogState(() => tanggalSelesai = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(hintText: 'Tanggal Selesai'),
                              child: Text(DateFormatter.shortDate(tanggalSelesai), style: TextStyle(color: ctx.colors.textPrimary)),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      TextField(controller: lokasiCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Lokasi')),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: status,
                        dropdownColor: ctx.colors.surfaceCard,
                        style: TextStyle(color: ctx.colors.textPrimary),
                        decoration: const InputDecoration(hintText: 'Status'),
                        items: ['upcoming', 'ongoing', 'completed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setDialogState(() => status = v!),
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: deskripsiCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Deskripsi'), maxLines: 3),
                      const SizedBox(height: 12),
                      TextField(controller: posterUrlCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Poster URL (opsional)')),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
                ElevatedButton(
                  onPressed: () {
                    if (judulCtrl.text.trim().isEmpty) return;
                    final data = {
                      'judul': judulCtrl.text.trim(),
                      'kategori': kategoriCtrl.text.trim(),
                      'tanggal_mulai': tanggalMulai.toIso8601String(),
                      'tanggal_selesai': tanggalSelesai.toIso8601String(),
                      'lokasi': lokasiCtrl.text.trim(),
                      'status': status,
                      'deskripsi': deskripsiCtrl.text.trim(),
                      'poster_url': posterUrlCtrl.text.trim(),
                    };
                    ctx.read<AdminProvider>().createEvent(data);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditEventDialog(Event event) {
    final judulCtrl = TextEditingController(text: event.judul);
    final kategoriCtrl = TextEditingController(text: event.kategori);
    final lokasiCtrl = TextEditingController(text: event.lokasi);
    final deskripsiCtrl = TextEditingController(text: event.deskripsi);
    final posterUrlCtrl = TextEditingController(text: event.posterUrl ?? '');
    String status = event.status;
    DateTime tanggalMulai = event.tanggalMulai;
    DateTime tanggalSelesai = event.tanggalSelesai;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: ctx.colors.surfaceCard,
              title: Text('Edit Event', style: TextStyle(color: ctx.colors.textPrimary)),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: judulCtrl,
                        style: TextStyle(color: ctx.colors.textPrimary),
                        decoration: const InputDecoration(hintText: 'Judul Event'),
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: kategoriCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Kategori')),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(context: ctx, initialDate: tanggalMulai, firstDate: DateTime(2020), lastDate: DateTime(2030));
                              if (picked != null) setDialogState(() => tanggalMulai = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(hintText: 'Tanggal Mulai'),
                              child: Text(DateFormatter.shortDate(tanggalMulai), style: TextStyle(color: ctx.colors.textPrimary)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(context: ctx, initialDate: tanggalSelesai, firstDate: DateTime(2020), lastDate: DateTime(2030));
                              if (picked != null) setDialogState(() => tanggalSelesai = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(hintText: 'Tanggal Selesai'),
                              child: Text(DateFormatter.shortDate(tanggalSelesai), style: TextStyle(color: ctx.colors.textPrimary)),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      TextField(controller: lokasiCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Lokasi')),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: status,
                        dropdownColor: ctx.colors.surfaceCard,
                        style: TextStyle(color: ctx.colors.textPrimary),
                        decoration: const InputDecoration(hintText: 'Status'),
                        items: ['upcoming', 'ongoing', 'completed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setDialogState(() => status = v!),
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: deskripsiCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Deskripsi'), maxLines: 3),
                      const SizedBox(height: 12),
                      TextField(controller: posterUrlCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Poster URL (opsional)')),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
                ElevatedButton(
                  onPressed: () {
                    if (judulCtrl.text.trim().isEmpty) return;
                    final data = {
                      'judul': judulCtrl.text.trim(),
                      'kategori': kategoriCtrl.text.trim(),
                      'tanggal_mulai': tanggalMulai.toIso8601String(),
                      'tanggal_selesai': tanggalSelesai.toIso8601String(),
                      'lokasi': lokasiCtrl.text.trim(),
                      'status': status,
                      'deskripsi': deskripsiCtrl.text.trim(),
                      'poster_url': posterUrlCtrl.text.trim(),
                    };
                    ctx.read<AdminProvider>().updateEvent(event.id, data);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.colors.surfaceCard,
        title: Text('Hapus Event', style: TextStyle(color: ctx.colors.textPrimary)),
        content: Text('Apakah Anda yakin?', style: TextStyle(color: ctx.colors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ctx.colors.errorRed),
            onPressed: () { context.read<AdminProvider>().deleteEvent(id); Navigator.pop(ctx); },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Kelola Jadwal Event', style: TextStyle(color: context.colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Manajemen data kalender kegiatan', style: TextStyle(color: context.colors.textSecondary, fontSize: 15)),
              ]),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // Trigger manual sync
                      context.read<AdminProvider>().syncTurnamenToJadwal();
                    },
                    icon: const Icon(Icons.sync),
                    tooltip: 'Sync Turnamen ke Jadwal',
                    style: IconButton.styleFrom(
                      backgroundColor: context.colors.primaryGold.withValues(alpha: 0.2),
                      foregroundColor: context.colors.primaryGold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: _showAddEventDialog, icon: const Icon(Icons.add), label: const Text('Tambah Event')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Consumer<AdminProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
              }
              if (provider.errorMessage != null) {
                return Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('Error: ${provider.errorMessage}', style: TextStyle(color: context.colors.errorRed))));
              }
              if (provider.events.isEmpty) {
                return Container(
                  width: double.infinity, padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(color: context.colors.surfaceCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.borderColor)),
                  child: Column(children: [
                    Icon(Icons.event_busy, size: 48, color: context.colors.textMuted),
                    const SizedBox(height: 12),
                    Text('Belum ada data event', style: TextStyle(color: context.colors.textMuted, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Klik "Tambah Event" untuk menambahkan data baru', style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
                  ]),
                );
              }

              if (provider.successMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.successMessage!), backgroundColor: context.colors.successGreen));
                  provider.clearMessages();
                });
              }

              final rows = provider.events.map((e) => [e.judul, DateFormatter.shortDate(e.tanggalMulai), DateFormatter.shortDate(e.tanggalSelesai), e.lokasi]).toList();
              return AdminDataTable(
                columns: ['Judul Event', 'Tgl Mulai', 'Tgl Selesai', 'Lokasi'],
                rows: rows,
                actionsBuilder: (index) {
                  final eventId = provider.events[index].id;
                  final event = provider.events[index];
                  return [
                    IconButton(icon: Icon(Icons.edit, color: context.colors.primaryGold, size: 18), onPressed: () => _showEditEventDialog(event), tooltip: 'Edit'),
                    IconButton(icon: Icon(Icons.delete, color: context.colors.errorRed, size: 18), onPressed: () => _showDeleteDialog(eventId), tooltip: 'Hapus'),
                  ];
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
