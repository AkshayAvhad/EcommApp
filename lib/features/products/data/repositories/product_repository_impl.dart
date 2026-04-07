import 'package:ecomm/core/network/network_info.dart';
import 'package:ecomm/features/products/data/datasources/product_local_data_source.dart';
import 'package:ecomm/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecomm/features/products/domain/repositories/product_repository.dart';

import '../../domain/entities/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getProducts({int limit = 20, int skip = 20}) async {
    // Check if we have internet (using a connectivity package)
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts(
          limit: limit,
          skip: skip,
        );

        await localDataSource.cacheProducts(remoteProducts);
        print('CALLING PRODUCTS API');
        return remoteProducts.map((model) => model.toEntity()).toList();
      } catch (exception) {
        return _fetchFromLocal(); // Fallback if API is down
      }
    } else {
      return _fetchFromLocal(); // Offline Mode
    }
  }

  Future<List<Product>> _fetchFromLocal() async {
    final localData = await localDataSource.getLastProducts();
    return localData.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      return model.toEntity();
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final models = await remoteDataSource.searchProducts(query);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
    String category, {
    int limit = 20,
    skip = 0,
  }) async {
    try {
      final models = await remoteDataSource.getProductByCategory(
        category,
        limit: limit,
        skip: skip,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (exception) {
      rethrow;
    }
  }
}
