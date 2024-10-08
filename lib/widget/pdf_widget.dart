import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'dart:ui' as ui;

class PDFGenerator {

  static Future<Uint8List> createImageFromText(String text, {double fontSize = 40, FontWeight? fontWeight, double width = 400, double height = 80, Color color = Colors.black}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(const Offset(0, 0), Offset(width, height)));
    final paint = Paint();

    // You can set background color if needed
    paint.color = Colors.transparent;
    canvas.drawPaint(paint);

    // Paint the Bengali text
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: 'NotoSansBengali', // Use the Bengali font here
        ),
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 0));

    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  static void generatePdfView(InstallmentModel installment) async {
    final img = await rootBundle.load(Constants.logo);
    final logo = img.buffer.asUint8List();

    final name = await createImageFromText(
      'প্রজন্ম - ১৬ ফাউন্ডেশন',
      width: 450, height: 60, fontSize: 50,
    );
    final address = await createImageFromText(
      'ডাকঘর: সোনাগাজী, ইউনিয়ন/পৌরসভা: সোনাগাজী, উপজেলা: সোনাগাজী, জেলা: ফেনী',
      fontSize: 15, width: 520, height: 25,
    );
    final mobile = await createImageFromText(
      'মোবাইল: ০১৬২১৭৫৭৬৫৫, ০১৮৩৫২৯০৮০',
      fontSize: 17, width: 290, height: 25,
    );
    final check = await createImageFromText(
      'চাঁদা আদায়ের রশিদ',
      fontSize: 22, width: 175, height: 25, color: Colors.white,
    );
    final sl = await createImageFromText(
      'ক্রমিক নং:',
      fontSize: 18, width: 85, height: 22,
    );
    final date = await createImageFromText(
      'তারিখ:',
      fontSize: 18, width: 60, height: 20,
    );
    final mr = await createImageFromText(
      'জনাব:',
      fontSize: 18, width: 60, height: 20,
    );
    final month = await createImageFromText(
      'মাসের নাম:',
      fontSize: 18, width: 90, height: 20,
    );
    final moneyAmount = await createImageFromText(
      'টাকার পরিমাণ:',
      fontSize: 18, width: 115, height: 20,
    );
    final spelling = await createImageFromText(
      'কথায়:',
      fontSize: 18, width: 60, height: 20,
    );
    final medium = await createImageFromText(
      'মাধ্যম:',
      fontSize: 18, width: 60, height: 20,
    );
    final receiverName = await createImageFromText(
      'আদায়কারীর নাম',
      fontSize: 18, width: 130, height: 20,
    );
    final receivedWithThanks = await createImageFromText(
      'ধন্যবাদের সাথে গৃহীত হইল।',
      fontSize: 20, width: 400, height: 30, fontWeight: FontWeight.bold,
    );
    final reference = await createImageFromText(
      installment.reference ?? '',
      fontSize: 18, width: 200, height: 20, fontWeight: FontWeight.bold,
    );
    final amount = await createImageFromText(
      Converter.convertAmount(installment.amount ?? 0),
      fontSize: 18, width: 200, height: 20, fontWeight: FontWeight.bold,
    );

    final pw.Document pdf = pw.Document();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      margin: const pw.EdgeInsets.all(Constants.padding),
      build: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(style: pw.BorderStyle.dashed, width: 2),
            borderRadius: pw.BorderRadius.circular(10),
          ),
          alignment: pw.Alignment.center,
          padding: const pw.EdgeInsets.all(Constants.padding),
          child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [

            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Image(pw.MemoryImage(logo), width: 60, height: 60),
              pw.SizedBox(width: 20),
              pw.Image(pw.MemoryImage(name)),
            ]),

            pw.Image(pw.MemoryImage(address)),

            pw.Image(pw.MemoryImage(mobile)),
            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.only(topLeft: pw.Radius.circular(20), bottomRight: pw.Radius.circular(20)),
                color: PdfColor.fromInt(0xFF005953),
              ),
              child: pw.Image(pw.MemoryImage(check)),
            ),
            pw.SizedBox(height: 30),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Image(pw.MemoryImage(sl)),
              pw.Text(installment.id ?? '', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Expanded(child: pw.SizedBox()),
              pw.Image(pw.MemoryImage(date)),
              pw.Text(
                Converter.dateToDateShortString(installment.createdAt ?? DateTime.now()),
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ]),
            pw.SizedBox(height: 15),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Image(pw.MemoryImage(mr)),
              pw.Text(installment.userName ?? '', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ]),
            pw.SizedBox(height: 15),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Image(pw.MemoryImage(month)),
              pw.Image(pw.MemoryImage(reference)),
            ]),
            pw.SizedBox(height: 15),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Image(pw.MemoryImage(moneyAmount)),
              pw.Image(pw.MemoryImage(amount)),
            ]),
            pw.SizedBox(height: 15),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Image(pw.MemoryImage(spelling)),
              pw.Text(
                '${Converter.numberToWords(installment.amount!.toInt())} Taka Only',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ]),
            pw.SizedBox(height: 15),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Image(pw.MemoryImage(medium)),
              pw.Text(
                installment.medium ?? '',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ]),
            pw.SizedBox(height: 20),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.Expanded(child: pw.Image(pw.MemoryImage(receivedWithThanks))),
              pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
                pw.Text(
                  installment.receiverName ?? '',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.Container(height: 1, width: 200, color: const PdfColor.fromInt(0xFF000000)),
                pw.Image(pw.MemoryImage(receiverName)),
              ]),
            ]),

          ]),
        ); // Center
      },
    ));

    final Directory? output = await getDownloadsDirectory();
    if (output != null) {
      String fileName = '${Converter.dateToMonth(installment.month!)}:${installment.userEmail}';
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