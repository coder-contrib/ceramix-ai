import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/inventory.dart';

class ProductsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.products);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _products = data.map((e) => Product.fromJson(e)).toList();
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await _api.post(ApiConstants.products, data);
      if (response.statusCode == 201) {
        await fetchProducts();
        return true;
      }
    } catch (_) {}
    return false;
  }
}

class InventoryProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  List<InventoryItem> _items = [];
  List<Warehouse> _warehouses = [];
  bool _isLoading = false;

  List<InventoryItem> get items => _items;
  List<Warehouse> get warehouses => _warehouses;
  bool get isLoading => _isLoading;

  Future<void> fetchInventory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.inventory);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _items = data.map((e) => InventoryItem.fromJson(e)).toList();
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWarehouses() async {
    try {
      final response = await _api.get(ApiConstants.warehouses);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _warehouses = data.map((e) => Warehouse.fromJson(e)).toList();
      }
    } catch (_) {}
    notifyListeners();
  }
}
