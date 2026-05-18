import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/party.dart';

class CustomersProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  List<Customer> _customers = [];
  bool _isLoading = false;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.customers);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _customers = data.map((e) => Customer.fromJson(e)).toList();
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addCustomer(Map<String, dynamic> data) async {
    try {
      final response = await _api.post(ApiConstants.customers, data);
      if (response.statusCode == 201) {
        await fetchCustomers();
        return true;
      }
    } catch (_) {}
    return false;
  }
}

class SuppliersProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  List<Supplier> _suppliers = [];
  bool _isLoading = false;

  List<Supplier> get suppliers => _suppliers;
  bool get isLoading => _isLoading;

  Future<void> fetchSuppliers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.suppliers);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _suppliers = data.map((e) => Supplier.fromJson(e)).toList();
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addSupplier(Map<String, dynamic> data) async {
    try {
      final response = await _api.post(ApiConstants.suppliers, data);
      if (response.statusCode == 201) {
        await fetchSuppliers();
        return true;
      }
    } catch (_) {}
    return false;
  }
}
