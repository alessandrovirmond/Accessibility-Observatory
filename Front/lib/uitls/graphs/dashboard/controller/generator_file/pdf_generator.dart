import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as dart_ui;


///Package imports
import 'package:flutter/material.dart';

/// Chart import

/// Pdf import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../../services/file_save/save_file.dart';


class RenderPdf{
  
  Future<void> renderPdf(key, String name) async {
    final PdfDocument document = PdfDocument();
    final PdfBitmap bitmap = PdfBitmap(await _readImageData(key));
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 0;
    document.pageSettings.size =
        Size(bitmap.width.toDouble(), bitmap.height.toDouble());
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawImage(
        bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

    final List<int> bytes = document.saveSync();
    document.dispose();
    await FileSaveHelper.saveAndLaunchFile(bytes, '$name-${DateTime.now()}.pdf');
  }

  Future<List<int>> _readImageData(key) async {
    final dart_ui.Image data =
        await key.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }



}