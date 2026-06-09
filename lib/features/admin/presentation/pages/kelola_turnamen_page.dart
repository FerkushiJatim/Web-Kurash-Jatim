import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../app/theme.dart';
import '../../providers/admin_provider.dart';
import '../widgets/data_table_widget.dart';

class KelolaTurnamenPage extends StatefulWidget {
  const KelolaTurnamenPage({super.key});

  @override
  State<KelolaTurnamenPage> createState() => _KelolaTurnamenPageState();
}

class _KelolaTurnamenPageState extends State<KelolaTurnamenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AdminProvider>().loadTurnamen();
    });
  }

  void _showAddDialog() {
    final namaCtrl = TextEditingController();
    final lokasiCtrl = TextEditingController();
    final pesertaCtrl = TextEditingController(text: '0');
    final deskripsiCtrl = TextEditingController();
    final bannerUrlCtrl = TextEditingController();
    final List<Map<String, TextEditingController>> lampiranCtrls = [];
    String status = 'upcoming';
    DateTime tanggalMulai = DateTime.now();
    DateTime tanggalSelesai = DateTime.now().add(const Duration(days: 3));

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.colors.surfaceCard,
          title: Text('Tambah Turnamen', style: TextStyle(color: ctx.colors.textPrimary)),
          content: SizedBox(
            width: 800,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: namaCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Nama Turnamen')),
                const SizedBox(height: 12),
                TextField(controller: lokasiCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Lokasi')),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(context: ctx, initialDate: tanggalMulai, firstDate: DateTime(2020), lastDate: DateTime(2030));
                      if (picked != null) setDialogState(() => tanggalMulai = picked);
                    },
                    child: InputDecorator(decoration: const InputDecoration(hintText: 'Tgl Mulai'), child: Text(DateFormatter.shortDate(tanggalMulai), style: TextStyle(color: ctx.colors.textPrimary))),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(context: ctx, initialDate: tanggalSelesai, firstDate: DateTime(2020), lastDate: DateTime(2030));
                      if (picked != null) setDialogState(() => tanggalSelesai = picked);
                    },
                    child: InputDecorator(decoration: const InputDecoration(hintText: 'Tgl Selesai'), child: Text(DateFormatter.shortDate(tanggalSelesai), style: TextStyle(color: ctx.colors.textPrimary))),
                  )),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: pesertaCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Jumlah Peserta'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: DropdownButtonFormField<String>(
                    initialValue: status, dropdownColor: ctx.colors.surfaceCard, style: TextStyle(color: ctx.colors.textPrimary),
                    decoration: const InputDecoration(hintText: 'Status'),
                    items: ['upcoming', 'ongoing', 'completed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setDialogState(() => status = v!),
                  )),
                ]),
                const SizedBox(height: 12),
                TextField(controller: deskripsiCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Deskripsi'), maxLines: 6),
                const SizedBox(height: 12),
                TextField(controller: bannerUrlCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Banner URL (opsional)')),
                const SizedBox(height: 24),
                // Lampiran Dinamis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lampiran PDF (Google Drive)', style: TextStyle(color: ctx.colors.textPrimary, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          lampiranCtrls.add({
                            'judul': TextEditingController(),
                            'url': TextEditingController(),
                          });
                        });
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah Lampiran'),
                    ),
                  ],
                ),
                if (lampiranCtrls.isNotEmpty) const SizedBox(height: 8),
                ...lampiranCtrls.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ctrl = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: ctrl['judul'],
                            style: TextStyle(color: ctx.colors.textPrimary),
                            decoration: const InputDecoration(hintText: 'Judul (cth: Bagan Tanding)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: ctrl['url'],
                            style: TextStyle(color: ctx.colors.textPrimary),
                            decoration: const InputDecoration(hintText: 'Link GDrive'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: ctx.colors.errorRed),
                          onPressed: () {
                            setDialogState(() {
                              lampiranCtrls.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
            ElevatedButton(
              onPressed: () {
                if (namaCtrl.text.trim().isEmpty) return;
                final data = {
                  'nama': namaCtrl.text.trim(),
                  'lokasi': lokasiCtrl.text.trim(),
                  'tanggal_mulai': tanggalMulai.toIso8601String(),
                  'tanggal_selesai': tanggalSelesai.toIso8601String(),
                  'jumlah_peserta': int.tryParse(pesertaCtrl.text) ?? 0,
                  'status': status,
                  'deskripsi': deskripsiCtrl.text.trim(),
                  'banner_url': bannerUrlCtrl.text.trim(),
                  'lampiran_list': lampiranCtrls.map((c) => {
                    'judul': c['judul']!.text.trim(),
                    'url': c['url']!.text.trim(),
                  }).where((l) => l['judul']!.isNotEmpty && l['url']!.isNotEmpty).toList(),
                };
                ctx.read<AdminProvider>().createTurnamen(data);
                Navigator.pop(dialogContext);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.colors.surfaceCard,
        title: Text('Hapus Turnamen', style: TextStyle(color: ctx.colors.textPrimary)),
        content: Text('Apakah Anda yakin?', style: TextStyle(color: ctx.colors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ctx.colors.errorRed),
            onPressed: () { context.read<AdminProvider>().deleteTurnamen(id); Navigator.pop(ctx); },
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Kelola Turnamen', style: TextStyle(color: context.colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Manajemen data hasil turnamen dan klasemen', style: TextStyle(color: context.colors.textSecondary, fontSize: 15)),
            ]),
            ElevatedButton.icon(onPressed: _showAddDialog, icon: const Icon(Icons.add), label: const Text('Tambah Turnamen')),
          ],
        ),
        const SizedBox(height: 32),
        Consumer<AdminProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
            if (provider.errorMessage != null) return Center(child: Text('Error: ${provider.errorMessage}', style: TextStyle(color: context.colors.errorRed)));
            if (provider.turnamenList.isEmpty) {
              return Container(
                width: double.infinity, padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(color: context.colors.surfaceCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.borderColor)),
                child: Column(children: [
                  Icon(Icons.emoji_events_outlined, size: 48, color: context.colors.textMuted),
                  const SizedBox(height: 12),
                  Text('Belum ada data turnamen', style: TextStyle(color: context.colors.textMuted, fontSize: 16)),
                ]),
              );
            }

            if (provider.successMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.successMessage!), backgroundColor: context.colors.successGreen));
                provider.clearMessages();
              });
            }

            final rows = provider.turnamenList.map((t) => [t.nama, t.lokasi, DateFormatter.shortDate(t.tanggalMulai), t.status, '${t.jumlahPeserta} Peserta']).toList();
            return AdminDataTable(
              columns: ['Nama Turnamen', 'Lokasi', 'Tgl Mulai', 'Status', 'Peserta'],
              rows: rows,
              actionsBuilder: (index) {
                final id = provider.turnamenList[index].id;
                return [
                  IconButton(icon: Icon(Icons.edit, color: context.colors.primaryGold, size: 18), onPressed: () {}, tooltip: 'Edit'),
                  IconButton(icon: Icon(Icons.delete, color: context.colors.errorRed, size: 18), onPressed: () => _showDeleteDialog(id), tooltip: 'Hapus'),
                ];
              },
            );
          },
        ),
      ]),
    );
  }
}
