import 'package:ecomm/features/products/domain/entities/product.dart';

abstract class CartEvent {}

class AddProductToCart extends CartEvent {
  final Product product;

  AddProductToCart(this.product);
}

class RemoveProductFromCart extends CartEvent {
  final Product product;

  RemoveProductFromCart(this.product);
}
