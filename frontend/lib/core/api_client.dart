import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final _storage = const FlutterSecureStorage();
  String? _token;

  Future<String?> get token async {
    _token ??= await _storage.read(key: 'access_token');
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'access_token');
  }

  Future<Map<String, String>> _headers() async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  Future<http.Response> get(String url) async {
    return http.get(Uri.parse(url), headers: await _headers());
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    return http.put(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String url) async {
    return http.delete(Uri.parse(url), headers: await _headers());
  }
}
