import 'package:ecomm/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<Product> getProductById(int id);
}
