import 'package:ecomm/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int limit = 20, int skip = 0});

  Future<List<Product>> getProductsByCategory(
    String category, {
    int limit = 20,
    skip = 0,
  });

  Future<List<String>> getCategories();

  Future<Product> getProductById(int id);

  Future<List<Product>> searchProducts(String query);
}
