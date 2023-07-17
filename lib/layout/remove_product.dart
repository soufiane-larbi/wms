import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/product_type.dart';
import 'package:whm/helper/provider/product_provider.dart';

class RemoveProduct extends StatefulWidget {
  const RemoveProduct({Key? key}) : super(key: key);

  @override
  State<RemoveProduct> createState() => _RemoveProductState();
}

class _RemoveProductState extends State<RemoveProduct> {
  final TextEditingController _quantityController = TextEditingController();
  String? _quantityHint;
  @override
  void initState() {
    _quantityHint =
        "Max: ${context.read<ProductProvider>().productList[context.read<ProductProvider>().selected].quantity}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Quantity"),
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
                      color: _quantityHint!.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,6}'),
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
                      onPressed: () async {
                        ProductType product =
                            context.read<ProductProvider>().productList[
                                context.read<ProductProvider>().selected];
                        product.updateQuantity(
                          double.parse(_quantityController.text),
                        );
                        context.read<ProductProvider>().addRemove(product);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Remove'),
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
}
