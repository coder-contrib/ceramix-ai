import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/invoices_provider.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PurchasesProvider>().fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Invoices')),
      body: Consumer<PurchasesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.invoices.isEmpty) {
            return const Center(child: Text('No purchase invoices yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.invoices.length,
            itemBuilder: (context, index) {
              final invoice = provider.invoices[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.shopping_cart)),
                  title: Text(invoice.invoiceNumber),
                  subtitle: Text('Supplier #${invoice.supplierId} | ${invoice.paymentType}'),
                  trailing: Text(
                    '${invoice.total.toStringAsFixed(2)} EGP',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
