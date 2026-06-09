import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme.dart';
import '../../providers/admin_provider.dart';
import '../widgets/data_table_widget.dart';
import '../../../berita/data/models/berita_model.dart';

class KelolaBeritaPage extends StatefulWidget {
  const KelolaBeritaPage({super.key});

  @override
  State<KelolaBeritaPage> createState() => _KelolaBeritaPageState();
}

class _KelolaBeritaPageState extends State<KelolaBeritaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AdminProvider>().loadBerita();
    });
  }

  void _showAddDialog() {
    final judulCtrl = TextEditingController();
    final slugCtrl = TextEditingController();
    final kontenCtrl = TextEditingController();
    final penulisCtrl = TextEditingController(text: 'Admin');
    final imageUrlCtrl = TextEditingController();
    DateTime tanggalPublikasi = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.colors.surfaceCard,
          title: Text('Tulis Berita', style: TextStyle(color: ctx.colors.textPrimary)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: judulCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Judul Berita')),
                const SizedBox(height: 12),
                TextField(
                  controller: slugCtrl,
                  style: TextStyle(color: ctx.colors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Slug (contoh: judul-berita-ini)'),
                ),
                const SizedBox(height: 12),
                TextField(controller: kontenCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Isi Konten Berita'), maxLines: 5),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: penulisCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Penulis'))),
                  const SizedBox(width: 12),
                  Expanded(child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(context: ctx, initialDate: tanggalPublikasi, firstDate: DateTime(2020), lastDate: DateTime(2030));
                      if (picked != null) setDialogState(() => tanggalPublikasi = picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(hintText: 'Tanggal Publikasi'),
                      child: Text('${tanggalPublikasi.day}/${tanggalPublikasi.month}/${tanggalPublikasi.year}', style: TextStyle(color: ctx.colors.textPrimary)),
                    ),
                  )),
                ]),
                const SizedBox(height: 12),
                TextField(controller: imageUrlCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Image URL (opsional)')),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
            ElevatedButton(
              onPressed: () {
                if (judulCtrl.text.trim().isEmpty) return;
                final slug = slugCtrl.text.trim().isEmpty ? judulCtrl.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-') : slugCtrl.text.trim();
                final data = {
                  'judul': judulCtrl.text.trim(),
                  'slug': slug,
                  'konten': kontenCtrl.text.trim(),
                  'penulis': penulisCtrl.text.trim(),
                  'tanggal_publikasi': tanggalPublikasi.toIso8601String(),
                  'image_url': imageUrlCtrl.text.trim(),
                };
                ctx.read<AdminProvider>().createBerita(data);
                Navigator.pop(dialogContext);
              },
              child: const Text('Publikasikan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Berita berita) {
    final judulCtrl = TextEditingController(text: berita.judul);
    final slugCtrl = TextEditingController(text: berita.slug);
    final kontenCtrl = TextEditingController(text: berita.konten);
    final penulisCtrl = TextEditingController(text: berita.penulis);
    final imageUrlCtrl = TextEditingController(text: berita.imageUrl ?? '');
    DateTime tanggalPublikasi = berita.tanggalPublikasi;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.colors.surfaceCard,
          title: Text('Edit Berita', style: TextStyle(color: ctx.colors.textPrimary)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: judulCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Judul Berita')),
                const SizedBox(height: 12),
                TextField(
                  controller: slugCtrl,
                  style: TextStyle(color: ctx.colors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Slug (contoh: judul-berita-ini)'),
                ),
                const SizedBox(height: 12),
                TextField(controller: kontenCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Isi Konten Berita'), maxLines: 5),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: penulisCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Penulis'))),
                  const SizedBox(width: 12),
                  Expanded(child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(context: ctx, initialDate: tanggalPublikasi, firstDate: DateTime(2020), lastDate: DateTime(2030));
                      if (picked != null) setDialogState(() => tanggalPublikasi = picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(hintText: 'Tanggal Publikasi'),
                      child: Text('${tanggalPublikasi.day}/${tanggalPublikasi.month}/${tanggalPublikasi.year}', style: TextStyle(color: ctx.colors.textPrimary)),
                    ),
                  )),
                ]),
                const SizedBox(height: 12),
                TextField(controller: imageUrlCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Image URL (opsional)')),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
            ElevatedButton(
              onPressed: () {
                if (judulCtrl.text.trim().isEmpty) return;
                final slug = slugCtrl.text.trim().isEmpty ? judulCtrl.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-') : slugCtrl.text.trim();
                final data = {
                  'judul': judulCtrl.text.trim(),
                  'slug': slug,
                  'konten': kontenCtrl.text.trim(),
                  'penulis': penulisCtrl.text.trim(),
                  'tanggal_publikasi': tanggalPublikasi.toIso8601String(),
                  'image_url': imageUrlCtrl.text.trim(),
                };
                ctx.read<AdminProvider>().updateBerita(berita.id, data);
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
        title: Text('Hapus Berita', style: TextStyle(color: ctx.colors.textPrimary)),
        content: Text('Apakah Anda yakin?', style: TextStyle(color: ctx.colors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ctx.colors.errorRed),
            onPressed: () { context.read<AdminProvider>().deleteBerita(id); Navigator.pop(ctx); },
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
              Text('Kelola Berita', style: TextStyle(color: context.colors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Manajemen publikasi artikel dan pengumuman', style: TextStyle(color: context.colors.textMuted, fontSize: 14)),
            ]),
            ElevatedButton.icon(onPressed: _showAddDialog, icon: const Icon(Icons.add), label: const Text('Tulis Berita')),
          ],
        ),
        const SizedBox(height: 32),
        Consumer<AdminProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
            if (provider.errorMessage != null) return Center(child: Text('Error: ${provider.errorMessage}', style: TextStyle(color: context.colors.errorRed)));
            if (provider.beritaList.isEmpty) {
              return Container(
                width: double.infinity, padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(color: context.colors.surfaceCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.borderColor)),
                child: Column(children: [
                  Icon(Icons.article_outlined, size: 48, color: context.colors.textMuted),
                  const SizedBox(height: 12),
                  Text('Belum ada berita dipublikasikan', style: TextStyle(color: context.colors.textMuted, fontSize: 16)),
                ]),
              );
            }

            if (provider.successMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.successMessage!), backgroundColor: context.colors.successGreen));
                provider.clearMessages();
              });
            }

            final rows = provider.beritaList.map((b) => [b.judul, b.penulis, '${b.tanggalPublikasi.day}/${b.tanggalPublikasi.month}/${b.tanggalPublikasi.year}']).toList();
            return AdminDataTable(
              columns: const ['Judul', 'Penulis', 'Tgl Publikasi'],
              rows: rows,
              actionsBuilder: (index) {
                final b = provider.beritaList[index];
                return [
                  IconButton(icon: Icon(Icons.edit, color: context.colors.primaryGold, size: 18), onPressed: () => _showEditDialog(b), tooltip: 'Edit'),
                  IconButton(icon: Icon(Icons.delete, color: context.colors.errorRed, size: 18), onPressed: () => _showDeleteDialog(b.id), tooltip: 'Hapus'),
                ];
              },
            );
          },
        ),
      ]),
    );
  }
}
