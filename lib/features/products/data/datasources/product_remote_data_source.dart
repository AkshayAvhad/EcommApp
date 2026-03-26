import 'dart:convert';

import 'package:ecomm/features/products/data/models/product_model.dart';
import 'package:http/http.dart' as http;

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0});

  Future<ProductModel> getProductById(int id);

  Future<List<ProductModel>> searchProducts(
    String query, {
    int limit = 20,
    int skip = 0,
  });

  Future<List<String>> getCategories();

  Future<List<ProductModel>> getProductByCategory(
    String category, {
    int limit = 20,
    int skip = 0,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0}) async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List<dynamic> list = decoded['products'];
      return list.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> searchProducts(
    String query, {
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await client.get(
      Uri.parse(
        'https://dummyjson.com/products/search?q=$query?limit=$limit&skip=$skip',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List<dynamic> list = decoded['products'];
      return list.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Search failed');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products/categories'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((item) => item['name'].toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<List<ProductModel>> getProductByCategory(
    String category, {
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await client.get(
      Uri.parse(
        'https://dummyjson.com/products/category/$category?limit=$limit&skip=$skip',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List<dynamic> list = decoded['products'];
      return list.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products for category: $category');
    }
  }
}
