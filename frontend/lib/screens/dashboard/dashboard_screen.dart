import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ceramix AI ERP'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  user.fullName,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.fullName ?? "User"}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _DashboardCard(
                    icon: Icons.people,
                    title: 'Customers',
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/customers'),
                  ),
                  _DashboardCard(
                    icon: Icons.local_shipping,
                    title: 'Suppliers',
                    color: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/suppliers'),
                  ),
                  _DashboardCard(
                    icon: Icons.inventory_2,
                    title: 'Products',
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/products'),
                  ),
                  _DashboardCard(
                    icon: Icons.warehouse,
                    title: 'Inventory',
                    color: Colors.purple,
                    onTap: () => Navigator.pushNamed(context, '/inventory'),
                  ),
                  _DashboardCard(
                    icon: Icons.point_of_sale,
                    title: 'Sales',
                    color: Colors.teal,
                    onTap: () => Navigator.pushNamed(context, '/sales'),
                  ),
                  _DashboardCard(
                    icon: Icons.shopping_cart,
                    title: 'Purchases',
                    color: Colors.indigo,
                    onTap: () => Navigator.pushNamed(context, '/purchases'),
                  ),
                  _DashboardCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Treasury',
                    color: Colors.amber,
                    onTap: () => Navigator.pushNamed(context, '/finance'),
                  ),
                  _DashboardCard(
                    icon: Icons.receipt_long,
                    title: 'Expenses',
                    color: Colors.red,
                    onTap: () => Navigator.pushNamed(context, '/finance'),
                  ),
                  _DashboardCard(
                    icon: Icons.assignment_return,
                    title: 'Returns',
                    color: Colors.brown,
                    onTap: () => Navigator.pushNamed(context, '/finance'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
