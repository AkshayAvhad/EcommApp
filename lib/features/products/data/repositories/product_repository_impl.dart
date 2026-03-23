import 'package:ecomm/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecomm/features/products/domain/repositories/product_repository.dart';

import '../../domain/entities/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    final models = await remoteDataSource.getProducts();
    return models.map((model) => model.toEntity()).toList();
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
}
