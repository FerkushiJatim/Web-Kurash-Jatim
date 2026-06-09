import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../app/theme.dart';
import '../../providers/admin_provider.dart';
import '../widgets/data_table_widget.dart';
import '../../../piagam/data/models/piagam_model.dart';
// Removed unused imports

class KelolaPiagamPage extends StatefulWidget {
  const KelolaPiagamPage({super.key});

  @override
  State<KelolaPiagamPage> createState() => _KelolaPiagamPageState();
}

class _KelolaPiagamPageState extends State<KelolaPiagamPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AdminProvider>().loadPiagam();
    });
  }

  void _showAddDialog() {
    final turnamenNamaCtrl = TextEditingController();
    final gdriveLinkCtrl = TextEditingController();
    DateTime tanggalTerbit = DateTime.now();
    bool isSaving = false;

    String? extractGDriveId(String url) {
      final regExp = RegExp(r'(?:file\/d\/|id=)([\w-]{25,})');
      final match = regExp.firstMatch(url);
      return match?.group(1);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.colors.surfaceCard,
          title: Text('Terbitkan Piagam', style: TextStyle(color: ctx.colors.textPrimary)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextField(controller: turnamenNamaCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Nama Turnamen')),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(context: ctx, initialDate: tanggalTerbit, firstDate: DateTime(2020), lastDate: DateTime(2030));
                    if (picked != null) setDialogState(() => tanggalTerbit = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(hintText: 'Tanggal Terbit'),
                    child: Text(DateFormatter.shortDate(tanggalTerbit), style: TextStyle(color: ctx.colors.textPrimary)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(controller: gdriveLinkCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Link Google Drive PDF')),
                if (isSaving) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 8),
                  Center(child: Text('Menyimpan data...', style: TextStyle(color: ctx.colors.textMuted))),
                ],
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: isSaving ? null : () => Navigator.pop(dialogContext), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
            ElevatedButton(
              onPressed: isSaving ? null : () async {
                if (turnamenNamaCtrl.text.trim().isEmpty || gdriveLinkCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Masukkan Nama Turnamen dan Link Google Drive')));
                  return;
                }
                
                final fileId = extractGDriveId(gdriveLinkCtrl.text.trim());
                if (fileId == null) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Format Link Google Drive tidak valid')));
                  return;
                }

                setDialogState(() => isSaving = true);
                try {
                  final directLink = 'https://drive.google.com/uc?export=download&id=$fileId';

                  final data = {
                    'turnamen_nama': turnamenNamaCtrl.text.trim(),
                    'tanggal_terbit': tanggalTerbit.toIso8601String(),
                    'pdf_url': directLink,
                  };
                  ctx.read<AdminProvider>().createPiagam(data);
                  Navigator.pop(dialogContext);
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
                }
              },
              child: const Text('Terbitkan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Piagam piagam) {
    final turnamenNamaCtrl = TextEditingController(text: piagam.turnamenNama);
    final gdriveLinkCtrl = TextEditingController(text: piagam.pdfUrl);
    DateTime tanggalTerbit = piagam.tanggalTerbit;
    bool isSaving = false;

    String? extractGDriveId(String url) {
      final regExp = RegExp(r'(?:file\/d\/|id=)([\w-]{25,})');
      final match = regExp.firstMatch(url);
      return match?.group(1);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.colors.surfaceCard,
          title: Text('Edit Piagam', style: TextStyle(color: ctx.colors.textPrimary)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextField(controller: turnamenNamaCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Nama Turnamen')),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(context: ctx, initialDate: tanggalTerbit, firstDate: DateTime(2020), lastDate: DateTime(2030));
                    if (picked != null) setDialogState(() => tanggalTerbit = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(hintText: 'Tanggal Terbit'),
                    child: Text(DateFormatter.shortDate(tanggalTerbit), style: TextStyle(color: ctx.colors.textPrimary)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(controller: gdriveLinkCtrl, style: TextStyle(color: ctx.colors.textPrimary), decoration: const InputDecoration(hintText: 'Link Google Drive PDF')),
                if (isSaving) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 8),
                  Center(child: Text('Menyimpan data...', style: TextStyle(color: ctx.colors.textMuted))),
                ],
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: isSaving ? null : () => Navigator.pop(dialogContext), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
            ElevatedButton(
              onPressed: isSaving ? null : () async {
                if (turnamenNamaCtrl.text.trim().isEmpty || gdriveLinkCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Masukkan Nama Turnamen dan Link Google Drive')));
                  return;
                }
                
                String finalUrl = gdriveLinkCtrl.text.trim();
                final fileId = extractGDriveId(finalUrl);
                if (fileId != null) {
                  finalUrl = 'https://drive.google.com/uc?export=download&id=$fileId';
                }

                setDialogState(() => isSaving = true);
                try {
                  final data = {
                    'turnamen_nama': turnamenNamaCtrl.text.trim(),
                    'tanggal_terbit': tanggalTerbit.toIso8601String(),
                    'pdf_url': finalUrl,
                  };
                  ctx.read<AdminProvider>().updatePiagam(piagam.id, data);
                  Navigator.pop(dialogContext);
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
                }
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
        title: Text('Hapus Piagam', style: TextStyle(color: ctx.colors.textPrimary)),
        content: Text('Apakah Anda yakin?', style: TextStyle(color: ctx.colors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal', style: TextStyle(color: ctx.colors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ctx.colors.errorRed),
            onPressed: () { context.read<AdminProvider>().deletePiagam(id); Navigator.pop(ctx); },
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
              Text('Kelola E-Piagam', style: TextStyle(color: context.colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Manajemen penerbitan sertifikat dan piagam atlet', style: TextStyle(color: context.colors.textSecondary, fontSize: 15)),
            ]),
            ElevatedButton.icon(onPressed: _showAddDialog, icon: const Icon(Icons.add), label: const Text('Terbitkan Piagam')),
          ],
        ),
        const SizedBox(height: 32),
        Consumer<AdminProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
            if (provider.errorMessage != null) return Center(child: Text('Error: ${provider.errorMessage}', style: TextStyle(color: context.colors.errorRed)));
            if (provider.piagamList.isEmpty) {
              return Container(
                width: double.infinity, padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(color: context.colors.surfaceCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.borderColor)),
                child: Column(children: [
                  Icon(Icons.verified_outlined, size: 48, color: context.colors.textMuted),
                  const SizedBox(height: 12),
                  Text('Belum ada piagam diterbitkan', style: TextStyle(color: context.colors.textMuted, fontSize: 16)),
                ]),
              );
            }

            if (provider.successMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.successMessage!), backgroundColor: context.colors.successGreen));
                provider.clearMessages();
              });
            }

            final rows = provider.piagamList.map((p) => [p.turnamenNama, DateFormatter.shortDate(p.tanggalTerbit)]).toList();
            return AdminDataTable(
              columns: ['Nama Turnamen', 'Tgl Terbit'],
              rows: rows,
              actionsBuilder: (index) {
                final id = provider.piagamList[index].id;
                final piagam = provider.piagamList[index];
                return [
                  IconButton(icon: Icon(Icons.edit, color: context.colors.primaryGold, size: 18), onPressed: () => _showEditDialog(piagam), tooltip: 'Edit'),
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
