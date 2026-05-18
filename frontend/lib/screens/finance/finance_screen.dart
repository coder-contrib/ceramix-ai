import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiClient _api = ApiClient();
  List<dynamic> _treasury = [];
  List<dynamic> _expenses = [];
  List<dynamic> _returns = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _api.get(ApiConstants.treasury),
        _api.get(ApiConstants.expenses),
        _api.get(ApiConstants.returns),
      ]);
      if (results[0].statusCode == 200) _treasury = jsonDecode(results[0].body);
      if (results[1].statusCode == 200) _expenses = jsonDecode(results[1].body);
      if (results[2].statusCode == 200) _returns = jsonDecode(results[2].body);
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Treasury'),
            Tab(text: 'Expenses'),
            Tab(text: 'Returns'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTreasuryTab(),
                _buildExpensesTab(),
                _buildReturnsTab(),
              ],
            ),
    );
  }

  Widget _buildTreasuryTab() {
    if (_treasury.isEmpty) return const Center(child: Text('No treasury records'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _treasury.length,
      itemBuilder: (context, index) {
        final t = _treasury[index];
        final isIn = t['transaction_type'] == 'in';
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isIn ? Colors.green[100] : Colors.red[100],
              child: Icon(isIn ? Icons.arrow_downward : Icons.arrow_upward, color: isIn ? Colors.green : Colors.red),
            ),
            title: Text('${t['amount']} EGP'),
            subtitle: Text(t['reference'] ?? 'No reference'),
            trailing: Chip(label: Text(t['transaction_type'].toUpperCase())),
          ),
        );
      },
    );
  }

  Widget _buildExpensesTab() {
    if (_expenses.isEmpty) return const Center(child: Text('No expenses'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final e = _expenses[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
            title: Text('${e['amount']} EGP'),
            subtitle: Text(e['category']),
            trailing: Text(e['description'] ?? ''),
          ),
        );
      },
    );
  }

  Widget _buildReturnsTab() {
    if (_returns.isEmpty) return const Center(child: Text('No returns'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _returns.length,
      itemBuilder: (context, index) {
        final r = _returns[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.assignment_return)),
            title: Text('${r['amount']} EGP - ${r['return_type']}'),
            subtitle: Text('Product #${r['product_id']} | Qty: ${r['quantity']}'),
          ),
        );
      },
    );
  }
}
