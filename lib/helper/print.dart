import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<bool> printDoc({required context, required List<dynamic> bon}) async {
  final pdf = pw.Document();
  final logo = pw.MemoryImage(
    File('assets/logo.png').readAsBytesSync(),
  );
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      build: (pw.Context cnt) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
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
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Text(
                    'SARL RAYLAN\n'
                    'Fabrication et Montage de Produits Electriques, Electroniques et Electroménagers\n'
                    'Zone Industrielle M.I.N Lot N° 105. El Bouni Annaba Algerie\n'
                    'Tél: (+213) 661 850 850  / Fax: (+213) 38 86 15 79 / Email: contact@raylandz.com\n',
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Center(
              child: pw.Text(
                "BON DE LIVRAISON",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                    "Beneficaire: ${bon[0]['beneficiary']}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text(
                    "Le: ${timeFormater()}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 4,
                  child: pw.Text(
                    'Ticket',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 4,
                  child: pw.Text(
                    'Code Article',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    'Prix/U',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Quantity',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    'Prix Sous Total',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.ListView.builder(
              itemCount: bon.length,
              itemBuilder: (context, index) {
                return pw.Container(
                  height: 30,
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Text('${bon[index]['ticket']}'),
                      ),
                      pw.Expanded(
                        flex: 4,
                        child: pw.Text('${bon[index]['pdrId']}'),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(warranty(price: bon[index]['price'])),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text('${bon[index]['quantity']}'),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          warranty(
                            price: bon[index]['price'],
                            quantity: bon[index]['quantity'],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Spacer(),
                pw.Text(
                  'Total: ${total(bon)}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Spacer(),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 30),
              height: 200,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    'Visa SAV',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'Visa Chauffeur',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'Visa Client',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  try {
    final file = File('generated.pdf');
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

String timeFormater() {
  String day = DateTime.now().day.toString().padLeft(2, '0');
  String month = DateTime.now().month.toString().padLeft(2, '0');
  String year = DateTime.now().year.toString();
  String hour = DateTime.now().hour.toString().padLeft(2, '0');
  String minute = DateTime.now().minute.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute';
}

String total(bon) {
  double total = 0;
  for (var b in bon) {
    total += b['price'] * b['quantity'];
  }
  return '$total DZD';
}
