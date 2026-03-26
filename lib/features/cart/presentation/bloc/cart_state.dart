import 'package:ecomm/features/cart/domain/entities/cart_item.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  @override
  List<Object?> get props => [items];
}
