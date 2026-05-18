import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/invoices_provider.dart';

class CreateSaleScreen extends StatefulWidget {
  const CreateSaleScreen({super.key});

  @override
  State<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen> {
  final _customerIdCtrl = TextEditingController();
  final _discountCtrl = TextEditingController(text: '0');
  final _paidCtrl = TextEditingController(text: '0');
  String _paymentType = 'cash';
  final List<Map<String, dynamic>> _items = [];

  void _addItem() {
    final productIdCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: productIdCtrl, decoration: const InputDecoration(labelText: 'Product ID'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Unit Price'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.add({
                  'product_id': int.tryParse(productIdCtrl.text) ?? 0,
                  'quantity': double.tryParse(qtyCtrl.text) ?? 0,
                  'unit_price': double.tryParse(priceCtrl.text) ?? 0,
                });
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_customerIdCtrl.text.isEmpty || _items.isEmpty) return;

    final success = await context.read<SalesProvider>().createInvoice({
      'customer_id': int.parse(_customerIdCtrl.text),
      'discount': double.tryParse(_discountCtrl.text) ?? 0,
      'paid': double.tryParse(_paidCtrl.text) ?? 0,
      'payment_type': _paymentType,
      'items': _items,
    });

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Sales Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _customerIdCtrl, decoration: const InputDecoration(labelText: 'Customer ID *'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: _discountCtrl, decoration: const InputDecoration(labelText: 'Discount'), keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: _paidCtrl, decoration: const InputDecoration(labelText: 'Paid Amount'), keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _paymentType,
              decoration: const InputDecoration(labelText: 'Payment Type'),
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(value: 'credit', child: Text('Credit')),
              ],
              onChanged: (v) => setState(() => _paymentType = v!),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items (${_items.length})', style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton.icon(onPressed: _addItem, icon: const Icon(Icons.add), label: const Text('Add Item')),
              ],
            ),
            const SizedBox(height: 8),
            ..._items.asMap().entries.map((entry) => Card(
                  child: ListTile(
                    title: Text('Product #${entry.value['product_id']}'),
                    subtitle: Text('Qty: ${entry.value['quantity']} x ${entry.value['unit_price']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _items.removeAt(entry.key)),
                    ),
                  ),
                )),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Invoice'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
