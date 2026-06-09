import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class PdfIframeWidget extends StatefulWidget {
  final String googleDriveFileId;
  final double height;

  const PdfIframeWidget({
    super.key,
    required this.googleDriveFileId,
    this.height = 600,
  });

  @override
  State<PdfIframeWidget> createState() => _PdfIframeWidgetState();
}

class _PdfIframeWidgetState extends State<PdfIframeWidget> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'pdf-iframe-${widget.googleDriveFileId}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId, {Object? params}) {
        final url =
            'https://drive.google.com/file/d/${widget.googleDriveFileId}/preview';
        final iframe = web.HTMLIFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..setAttribute('allowfullscreen', 'true');
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: HtmlElementView(viewType: _viewType),
      ),
    );
  }
}

