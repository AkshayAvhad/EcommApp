import 'package:ecomm/core/database/app_database.dart';
import 'package:ecomm/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);

  Future<List<ProductModel>> getLastProducts();

  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;

  ProductLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final List<ProductLocal> itemsToCache = products
          .map(
            (model) => ProductLocal(
              id: model.id,
              title: model.title,
              price: model.price,
              description: model.description,
              category: model.category,
              thumbnail: model.thumbnail,
            ),
          )
          .toList();
      await database.insertProducts(itemsToCache);
      print('DRIFT: Cache Success!');
    } catch (exception) {
      print('DRIFT: Cache Failed!');
    }
  }

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final List<ProductLocal> results = await database.getAllProducts();
    print('DRIFT: Retrieved ${results.length} items from Local DB');
    return results
        .map(
          (row) => ProductModel(
            id: row.id,
            title: row.title,
            description: row.description,
            price: row.price,
            category: row.category,
            thumbnail: row.thumbnail,
          ),
        )
        .toList();
  }

  @override
  Future<void> clearCache() async {
    await database.deleteAllProducts();
  }
}
