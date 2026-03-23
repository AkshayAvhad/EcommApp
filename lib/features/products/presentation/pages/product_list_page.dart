import 'package:ecomm/features/products/presentation/bloc/product_bloc.dart';
import 'package:ecomm/features/products/presentation/bloc/product_event.dart';
import 'package:ecomm/features/products/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomm/core/di/injection_container.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store')),
      body: BlocProvider(
        create: (_) => sl<ProductBloc>()..add(GetProductsEvent()),
        child: const ProductView(),
      ),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) => switch (state) {
        ProductLoading() => const Center(child: CircularProgressIndicator()),
        ProductLoaded() => GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return Card(
              child: Column(
                children: [
                  Expanded(child: Image.network(product.thumbnail)),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(product.title, maxLines: 1),
                  ),
                  Text('\$${product.price}'),
                ],
              ),
            );
          },
        ),
        ProductError() => Center(child: Text(state.message)),
        ProductState() => const SizedBox.shrink(),
      },
    );
  }
}
