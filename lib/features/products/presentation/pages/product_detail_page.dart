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
      // appBar: AppBar(title: Text(product.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            primary: true,
            // This builds the dynamic title that fades in ONLY when collapsed
            // title: LayoutBuilder(
            //   builder: (context, constraints) {
            //     final systemBarHeight =
            //         kToolbarHeight + MediaQuery.of(context).padding.top;
            //
            //     // Look familiar? We are reading the incoming layout constraints in real-time!
            //     // If the height drops down near the minimum status bar level, show the title.
            //     final isCollapsed =
            //         constraints.biggest.height <= (systemBarHeight + 20.0);
            //
            //     return AnimatedOpacity(
            //       duration: const Duration(milliseconds: 200),
            //       opacity: isCollapsed ? 1.0 : 0.0,
            //       child: Text(
            //         product.title,
            //         style: const TextStyle(
            //           fontSize: 18,
            //           fontWeight: .bold,
            //           color: Colors.black,
            //         ),
            //       ),
            //     );
            //   },
            // ),

            // This is the actual canvas area that scales and transforms on scroll
            flexibleSpace: FlexibleSpaceBar(
              // centerTitle: true,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final statusBarHeight = MediaQuery.of(context).padding.top;
                  final systemBarHeight = kToolbarHeight + statusBarHeight;

                  // Look familiar? We are reading the incoming layout constraints in real-time!
                  // If the height drops down near the minimum status bar level, show the title.
                  final isCollapsed =
                      constraints.biggest.height <= (systemBarHeight + 20.0);

                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: isCollapsed ? 1.0 : 0.0,
                    child: Text(
                      product.title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: .bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
              background: Hero(
                tag: product.id,
                child: SafeArea(
                  top: true,
                  bottom: false,
                  child: Image.network(product.thumbnail, fit: .contain),
                ),
              ),
              collapseMode: .parallax, // Adds a premium parallax slide effect
            ),
          ),

          // 2. THE CONTENT LAYER: Standard non-sliver widgets must be wrapped in a adapter
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const .all(24.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: TextStyle(fontSize: 24, fontWeight: .bold),
                        ),
                      ),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: .bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: .w600,
                      color: Colors.grey[500],
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Divider(height: 40, thickness: 1),
                  const Text(
                    'Product Description',
                    style: TextStyle(fontSize: 18, fontWeight: .bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Adding a massive placeholder block so the page is long enough to let us scroll!
                  Container(
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: .circular(16),
                    ),
                    alignment: .center,
                    child: Text(
                      'Customer Reviews Placeholder',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
