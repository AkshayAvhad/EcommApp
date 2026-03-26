import 'package:ecomm/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomm/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecomm/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Hero(
              tag: product.id,
              child: Image.network(
                product.thumbnail,
                width: double.infinity,
                height: 300,
                fit: .cover,
              ),
            ),
            Padding(
              padding: .all(16.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green[700],
                      fontWeight: .bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: .bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(product.description),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: .symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // Dispatch the event to the global CartBloc
                        context.read<CartBloc>().add(AddProductToCart(product));

                        // Show a snackbar for feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart'),
                          ),
                        );
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
