import 'package:ecomm/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
  }

  void _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) {
    final updatedItems = List<CartItem>.from(state.items);

    // Check if product already exists in cart
    final index = updatedItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (index >= 0) {
      // Increment quantity
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: updatedItems[index].quantity + 1,
      );
    } else {
      // Add new item
      updatedItems.add(CartItem(product: event.product, quantity: 1));
    }
    emit(CartState(items: updatedItems));
  }

  void _onRemoveProductFromCart(
    RemoveProductFromCart event,
    Emitter<CartState> emit,
  ) {
    final updatedItems = state.items
        .where((item) => item.product.id != event.product.id)
        .toList();
    emit(CartState(items: updatedItems));
  }
}
