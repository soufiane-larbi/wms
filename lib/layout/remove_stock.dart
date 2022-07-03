import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';

class RemoveStock extends StatelessWidget {
  final TextEditingController _editingController = TextEditingController();
  final stock;
  RemoveStock({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Text(
            stock['name'],
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text('Quantity Disponible: ${stock['remain']}'),
        const SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          height: 50,
          child: TextField(
            controller: _editingController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Entrer La Valeur",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,6}')),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextButton(
          onPressed: () {
            double remain = _editingController.text != ''
                ? stock['remain'] - double.parse(_editingController.text)
                : -1;
            if (remain >= 0.0) {
              context.read<StockProvider>().setDB(
                    query:
                        "update stock set remain=$remain WHERE id=${stock['id']}",
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${_editingController.text} du ${stock['name']} a été déduit avec succès",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              DateTime now = DateTime.now();
              context.read<HistoryProvider>().setDB(
                query:
                    '''insert into history (name,type,provider,operation,date,time,stock,remain) 
      values(
        '${stock['name']}','${stock['type']}',
        '${stock['provider']}','-${_editingController.text}',
        '${now.day}/${now.month}/${now.year}','${now.hour}:${now.minute}',
        ${stock['quantity']},$remain
      )''',
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "La valeur saisie doit être égale ou inférieure à la quantité disponible",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
            Navigator.of(context).pop();
          },
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
