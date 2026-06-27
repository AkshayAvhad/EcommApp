import 'package:ecomm/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:ecomm/features/auth/presentation/pages/profile_page.dart';
import 'package:ecomm/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomm/features/cart/presentation/bloc/cart_state.dart';
import 'package:ecomm/features/cart/presentation/pages/cart_page.dart';
import 'package:ecomm/features/products/presentation/bloc/category_bloc.dart';
import 'package:ecomm/features/products/presentation/bloc/category_event.dart';
import 'package:ecomm/features/products/presentation/bloc/category_state.dart';
import 'package:ecomm/features/products/presentation/bloc/product_bloc.dart';
import 'package:ecomm/features/products/presentation/bloc/product_event.dart';
import 'package:ecomm/features/products/presentation/bloc/product_state.dart';
import 'package:ecomm/features/products/presentation/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomm/core/di/injection_container.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProductBloc>()..add(GetProductsEvent()),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(GetCategoriesEvent()),
        ),
      ],
      child: ProductListScaffold(),
    );
  }
}

class ProductListScaffold extends StatelessWidget {
  const ProductListScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Stack(
                alignment: .center,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    ),
                  ),
                  if (state.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: .all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: .circular(10),
                        ),
                        constraints: const BoxConstraints(
                          maxWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${state.items.length}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => sl<ProfileBloc>(),
                    child: const ProfilePage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: .all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: .circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) {
                context.read<ProductBloc>().add(SearchProductsEvent(query));
              },
            ),
          ),
        ),
      ),
      body: const ProductView(),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Trigger load more when user is 90% down the list
      context.read<ProductBloc>().add(LoadMoreProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .max,
      children: [
        CategoryBar(),
        const Divider(height: 1),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) => switch (state) {
              ProductLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ProductLoaded() => BlocListener<CategoryBloc, CategoryState>(
                listener: (context, state) {
                  if (state is CategoryLoaded) {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                child: GridView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: state.hasReachedMax
                      ? state.products.length
                      : state.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.products.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final product = state.products[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: Hero(
                                tag: product.id,
                                child: Image.network(product.thumbnail),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(product.title, maxLines: 1),
                            ),
                            Text('\$${product.price}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ProductError() => Text(state.message),
              ProductState() => const SizedBox.shrink(),
            },
          ),
        ),
      ],
    );
  }
}

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) => switch (state) {
          CategoryLoading() => const LinearProgressIndicator(),
          CategoryError() => Text(state.message),
          CategoryLoaded() => SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: .symmetric(horizontal: 10),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final isSelected = state.selectedCategory == category;
                return Padding(
                  padding: .symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<CategoryBloc>().add(
                        SelectCategoryEvent(category),
                      );
                      context.read<ProductBloc>().add(
                        ChangeCategoryEvent(category),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          CategoryState() => SizedBox.shrink(),
        },
      ),
    );
  }
}
