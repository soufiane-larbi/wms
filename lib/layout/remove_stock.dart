import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/bon_provider.dart';

class RemoveStock extends StatefulWidget {
  final String? pdrID, ticket, beneficiary;
  final double pdrPrice;
  final int quantity;
  const RemoveStock({
    Key? key,
    required this.pdrID,
    required this.pdrPrice,
    required this.ticket,
    required this.beneficiary,
    required this.quantity,
  }) : super(key: key);

  @override
  State<RemoveStock> createState() => _RemoveStockState();
}

class _RemoveStockState extends State<RemoveStock> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _beneficiaryController = TextEditingController();
  final TextEditingController _ticketController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _warranty = false;
  String _quantityHint = 'Quantitie',
      _ticketHint = 'Numero De Ticket',
      _beneficiaryHint = 'Beneficaire';
  @override
  void initState() {
    super.initState();
    _idController.text = widget.pdrID ?? 'ERROR';
    context.read<BonProvider>().temBonList.isNotEmpty
        ? _beneficiaryController.text = widget.beneficiary ?? ''
        : '';
    context.read<BonProvider>().temBonList.isNotEmpty
        ? _ticketController.text = widget.ticket ?? ''
        : '';
    _priceController.text = widget.pdrPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Code Article"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  enabled: false,
                  controller: _idController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Code Article",
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Ticket"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  enabled: context.read<BonProvider>().temBonList.isEmpty,
                  controller: _ticketController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _ticketHint,
                    hintStyle: TextStyle(
                      color: _ticketHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Beneficaire"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                    enabled: context.read<BonProvider>().temBonList.isEmpty,
                    controller: _beneficiaryController,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _beneficiaryHint,
                      hintStyle: TextStyle(
                        color: _beneficiaryHint.contains('Est Requis')
                            ? Colors.red
                            : Colors.grey[700],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Prix"),
              ),
              const Spacer(),
              SizedBox(
                height: 40,
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 145,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        enabled: false,
                        controller: _priceController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "0.0 DZD",
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,6}'),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _warranty = !_warranty;
                          _priceController.text =
                              _warranty ? "0.0" : widget.pdrPrice.toString();
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 145,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              _warranty ? Colors.green[300] : Colors.red[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _warranty ? "Sous Garantie" : "Hors Garantie",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Quantite"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _quantityController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _quantityHint,
                    hintStyle: TextStyle(
                      color: _quantityHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'\d{0,6}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Annuler',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        int result = add();
                        if (result == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${_beneficiaryController.text} a été ajouter a list d'attende.",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                          return;
                        }
                        if (result == 1) {
                          setState(() {
                            _quantityHint += ' Est Requis';
                            _ticketHint += ' Est Requis';
                            _beneficiaryHint += ' Est Requis';
                          });
                          return;
                        }
                        setState(
                          () {
                            _quantityHint =
                                'La quantité doit être dans [1~${widget.quantity}]';
                            _quantityController.text = '';
                          },
                        );
                      },
                      child: const Text('Ajouter a la liste'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int add() {
    if (_beneficiaryController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _ticketController.text.isEmpty ||
        _idController.text.isEmpty) {
      return 1;
    }
    if (int.parse(_quantityController.text) > widget.quantity ||
        int.parse(_quantityController.text) == 0) return 2;
    context.read<BonProvider>().beneficiary = _beneficiaryController.text;
    context.read<BonProvider>().ticket = _ticketController.text;
    context.read<BonProvider>().addTempBon(
          pdrId: _idController.text,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
        );
    return 0;
  }
}
