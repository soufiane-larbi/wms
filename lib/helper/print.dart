import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<bool> printDoc({required context, required product}) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      build: (pw.Context cnt) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                "ROVAC",
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                "État de stock",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Text('Produit'),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Type'),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Fournisseur'),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Stock Initial'),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Operation'),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Restant'),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text('Date'),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Text("${product['name']}"),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text("${product['type']}"),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text("${product['provider']}"),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text("${product['stock']}"),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text("${product['operation']}"),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text("${product['remain']}"),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text("${product['date']}:${product['time']}"),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
  try {
    final file = File('generated.pdf');
    await file.writeAsBytes(await pdf.save());
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
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
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Impression",
        textAlign: TextAlign.center,
      ),
    ),
  );
  return true;
}
