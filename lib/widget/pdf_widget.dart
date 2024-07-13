import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/widget/custom_snackbar.dart';

class PDFGenerator {
  static void generatePdfView(String fileName) async {
    final img = await rootBundle.load(Constants.logo);
    final imageBytes = img.buffer.asUint8List();

    final fallbackFontByteData = await rootBundle.load("assets/fonts/FiraSans-Regular.ttf");
    final ttf = pw.Font.ttf(fallbackFontByteData);
    // var doc = PdfDocument();
    // var font = PdfTtfFont(doc, imuButter);

    final pw.Document pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: ttf,
      bold: ttf,
      italic: ttf,
      boldItalic: ttf,
    ));

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.portrait,
      margin: const pw.EdgeInsets.all(Constants.padding),
      build: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(style: pw.BorderStyle.dashed),
            borderRadius: pw.BorderRadius.circular(10),
          ),
          padding: const pw.EdgeInsets.all(Constants.padding),
          child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [

            pw.Row(children: [
              pw.Image(pw.MemoryImage(imageBytes), height: 50, width: 50),
              pw.SizedBox(width: 20),
              pw.Text('Projonmo-16 Foundation', style: pw.TextStyle(fontSize: 40,
                  letterSpacing: 0.5,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                  fontFallback: [
                    pw.Font.ttf(fallbackFontByteData)
                  ])),
            ]),

          ]),
        ); // Center
      },
    ));

    final Directory? output = await getDownloadsDirectory();
    if (output != null) {
      final file = File('${output.path}/$fileName.pdf');
      print('---------:${file.path}');
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
      showSnackBar(message: '${'receipt_saved_to'.tr} ${file.path}', isError: false);
    } else {
      showSnackBar(message: 'can_not_download_the_receipt'.tr);
    }
  }
}