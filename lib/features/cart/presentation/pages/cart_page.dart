import 'package:ecomm/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomm/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecomm/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty!'));
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return ListTile(
                leading: Image.network(item.product.thumbnail),
                title: Text(item.product.title),
                subtitle: Text(
                  'Qty: ${item.quantity} x \$${item.product.price}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<CartBloc>().add(
                      RemoveProductFromCart(item.product),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: .all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Total: \$${state.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: .bold),
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
              ],
            ),
          );
        },
      ),
    );
  }
}
