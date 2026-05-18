import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/invoice.dart';

class SalesProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  List<SalesInvoice> _invoices = [];
  bool _isLoading = false;

  List<SalesInvoice> get invoices => _invoices;
  bool get isLoading => _isLoading;

  Future<void> fetchInvoices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.sales);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _invoices = data.map((e) => SalesInvoice.fromJson(e)).toList();
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createInvoice(Map<String, dynamic> data) async {
    try {
      final response = await _api.post(ApiConstants.sales, data);
      if (response.statusCode == 201) {
        await fetchInvoices();
        return true;
      }
    } catch (_) {}
    return false;
  }
}

class PurchasesProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  List<PurchaseInvoice> _invoices = [];
  bool _isLoading = false;

  List<PurchaseInvoice> get invoices => _invoices;
  bool get isLoading => _isLoading;

  Future<void> fetchInvoices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.purchases);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _invoices = data.map((e) => PurchaseInvoice.fromJson(e)).toList();
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createInvoice(Map<String, dynamic> data) async {
    try {
      final response = await _api.post(ApiConstants.purchases, data);
      if (response.statusCode == 201) {
        await fetchInvoices();
        return true;
      }
    } catch (_) {}
    return false;
  }
}
