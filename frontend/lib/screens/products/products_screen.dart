import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsProvider>().fetchProducts();
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final skuCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    final sellCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name *')),
              const SizedBox(height: 12),
              TextField(controller: skuCtrl, decoration: const InputDecoration(labelText: 'SKU *')),
              const SizedBox(height: 12),
              TextField(controller: costCtrl, decoration: const InputDecoration(labelText: 'Cost Price *'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: sellCtrl, decoration: const InputDecoration(labelText: 'Sell Price *'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty || skuCtrl.text.isEmpty) return;
              final success = await context.read<ProductsProvider>().addProduct({
                'name': nameCtrl.text,
                'sku': skuCtrl.text,
                'cost_price': double.tryParse(costCtrl.text) ?? 0,
                'sell_price': double.tryParse(sellCtrl.text) ?? 0,
                'category': categoryCtrl.text.isEmpty ? null : categoryCtrl.text,
              });
              if (success && ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.products.isEmpty) {
            return const Center(child: Text('No products yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
                  title: Text(product.name),
                  subtitle: Text('SKU: ${product.sku} | ${product.category ?? "No category"}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Cost: ${product.costPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                      Text('Sell: ${product.sellPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
