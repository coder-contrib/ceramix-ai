import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/parties_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/invoices_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/customers/customers_screen.dart';
import 'screens/suppliers/suppliers_screen.dart';
import 'screens/products/products_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'screens/sales/sales_screen.dart';
import 'screens/sales/create_sale_screen.dart';
import 'screens/purchases/purchases_screen.dart';
import 'screens/finance/finance_screen.dart';

void main() {
  runApp(const CeramixApp());
}

class CeramixApp extends StatelessWidget {
  const CeramixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CustomersProvider()),
        ChangeNotifierProvider(create: (_) => SuppliersProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => PurchasesProvider()),
      ],
      child: MaterialApp(
        title: 'Ceramix AI ERP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/dashboard': (_) => const DashboardScreen(),
          '/customers': (_) => const CustomersScreen(),
          '/suppliers': (_) => const SuppliersScreen(),
          '/products': (_) => const ProductsScreen(),
          '/inventory': (_) => const InventoryScreen(),
          '/sales': (_) => const SalesScreen(),
          '/sales/create': (_) => const CreateSaleScreen(),
          '/purchases': (_) => const PurchasesScreen(),
          '/finance': (_) => const FinanceScreen(),
        },
      ),
    );
  }
}
