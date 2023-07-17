import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:whm/helper/provider/product_provider.dart';
import 'package:provider/provider.dart';

Future<bool> printDoc({required context}) async {
  pw.TextStyle bold = pw.TextStyle(
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
  );
  pw.TextStyle normal = const pw.TextStyle(
    fontSize: 12,
  );
  pw.TextStyle product = const pw.TextStyle(
    fontSize: 12,
    background: pw.BoxDecoration(color: PdfColors.white),
  );
  final pdf = pw.Document();
  final logo = pw.MemoryImage(
    File('assets/logo.jpg').readAsBytesSync(),
  );
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      build: (pw.Context cntx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.SizedBox(height: 30),
            pw.Row(
              children: [
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.only(bottom: 22),
                    height: 90,
                    width: 100,
                    child: pw.Image(logo, width: 100, height: 90),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "ACTIVITE EXPLORATION PRODUCTION",
                    style: bold,
                  ),
                  pw.Text(
                    "DIVISION PRODUCTION",
                    style: bold,
                  ),
                  pw.Text(
                    "DIRECTION REGIONALE",
                    style: bold,
                  ),
                  pw.Text(
                    "HASSI MESSAOUD",
                    style: bold,
                  ),
                  pw.Text(
                    "DIRECTION LOGISTIQUE",
                    style: bold,
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Text(
                "Le 16/07/2023 17:33",
                style: normal,
              ),
            ]),
            pw.Spacer(),
            pw.Text(
              "Je soussigne Mr: X",
              style: bold,
            ),
            pw.Text(
              "Avoir autorise Mr: Y",
              style: bold,
            ),
            pw.Text(
              "Avoir autorise Mr: Y",
              style: bold,
            ),
            pw.Text(
              "A faire sortie de: L",
              style: bold,
            ),
            pw.SizedBox(
              height: 150,
              child: pw.Stack(
                children: [
                  pw.SizedBox(
                    height: 150,
                    width: 800,
                    child: pw.CustomPaint(painter: (graphic, size) {
                      graphic
                        ..moveTo(0, 0)
                        ..lineTo(size.x / 4, size.y)
                        ..moveTo(1 * size.x / 4, 0)
                        ..lineTo(2 * size.x / 4, size.y)
                        ..moveTo(2 * size.x / 4, 0)
                        ..lineTo(3 * size.x / 4, size.y)
                        ..moveTo(3 * size.x / 4, 0)
                        ..lineTo(4 * size.x / 4, size.y)
                        ..setColor(PdfColors.black)
                        ..strokePath();
                    }),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                    child: pw.Text(
                      "Le materiel suivant: P",
                      style: bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table(border: pw.TableBorder.all(width: 1), children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Lieu d'enlevement",
                      style: bold,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Lieude destination",
                      style: bold,
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text("L1"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text("L2"),
                  ),
                ],
              ),
            ]),
            pw.SizedBox(height: 16),
            pw.Table(border: pw.TableBorder.all(width: 1), children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Responsable Habilite",
                      style: bold,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Le preneur",
                      style: bold,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Controle Par",
                      style: bold,
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Date 23/06/2023'\nStructure: LOG\nNom  et   Visa",
                      style: normal,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Date 23/06/2023'\nStructure: \nNom  et   Visa",
                      style: normal,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Date 23/06/2023'\nStructure: LOG\nNom  et   Visa",
                      style: normal,
                    ),
                  ),
                ],
              ),
            ]),
            pw.Text(
              "Instruction particulieres: ",
              style: bold,
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "A Etablir en triple exampliare",
              style: normal,
            ),
            pw.Text(
              "Deux e xa mplaires doivent etre retournes vers  la structure emetrice",
              style: normal,
            ),
          ],
        );
      },
    ),
  );

  try {
    final file =
        File('Bons - ${timeFormater(date: '').replaceAll(':', '.')}.pdf');
    await file.writeAsBytes(await pdf.save());
    bool print = await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    if (print) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Impression...",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Impression annulée.",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.orange,
      ),
    );
    return false;
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        ),
      ),
    );
    return false;
  }
}

String warranty({price, quantity = 1}) {
  return price == 0 ? "Sous Garantie" : '${price * quantity} DZD';
}

String timeFormater({String date = ''}) {
  if (date == '') {
    String day = DateTime.now().day.toString().padLeft(2, '0');
    String month = DateTime.now().month.toString().padLeft(2, '0');
    String year = DateTime.now().year.toString();
    String hour = DateTime.now().hour.toString().padLeft(2, '0');
    String minute = DateTime.now().minute.toString().padLeft(2, '0');

    return '$day-$month-$year $hour:$minute';
  }
  String year = date.split(' ')[0];
  String time = (date.split(' ')[1]).split('.')[0];
  return '$year $time';
}

String total(bon) {
  double total = 0;
  for (var b in bon) {
    total += b['price'] * b['quantity'];
  }
  return '$total DZD';
}
