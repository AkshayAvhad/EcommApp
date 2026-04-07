import 'package:dio/dio.dart';
import 'package:ecomm/features/products/data/models/product_model.dart';

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
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0}) async {
    final response = await dio.get(
      '/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = response.data['products'];
      return list.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception(
        response.data.toString().contains('message')
            ? response.data['message']
            : 'Failed to load products!',
      );
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
    final response = await dio.get(
      '/products/search',
      queryParameters: {'q': query, 'limit': limit, 'skip': skip},
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = response.data['products'];
      return list.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Search failed');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await dio.get('/products/categories');

    if (response.statusCode == 200) {
      final List<dynamic> list = response.data;
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
    final response = await dio.get(
      '/products/category/$category',
      queryParameters: {'limit': limit, 'skip': skip},
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = response.data['products'];
      return list.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products for category: $category');
    }
  }
}
