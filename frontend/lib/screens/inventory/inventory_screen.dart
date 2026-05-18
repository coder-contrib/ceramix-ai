import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<InventoryProvider>();
    provider.fetchInventory();
    provider.fetchWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.items.isEmpty) {
            return const Center(child: Text('No inventory records'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              final item = provider.items[index];
              final warehouse = provider.warehouses
                  .where((w) => w.id == item.warehouseId)
                  .firstOrNull;
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.warehouse)),
                  title: Text('Product #${item.productId}'),
                  subtitle: Text('Warehouse: ${warehouse?.name ?? "#${item.warehouseId}"}'),
                  trailing: Chip(
                    label: Text('${item.quantity.toStringAsFixed(0)} units'),
                    backgroundColor: item.quantity > 10
                        ? Colors.green[100]
                        : item.quantity > 0
                            ? Colors.orange[100]
                            : Colors.red[100],
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
