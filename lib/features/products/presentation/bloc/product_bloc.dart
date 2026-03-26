import 'package:ecomm/features/products/domain/entities/product.dart';
import 'package:ecomm/features/products/domain/repositories/product_repository.dart';
import 'package:ecomm/features/products/presentation/bloc/product_event.dart';
import 'package:ecomm/features/products/presentation/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<GetProductsEvent>(_onGetProductsEvent);
    on<SearchProductsEvent>(
      _onSearchProductEvent,
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .flatMap(mapper);
      },
    );
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<ChangeCategoryEvent>(_onChangeCategoryEvent);
  }

  Future<void> _onGetProductsEvent(
    GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts(limit: 20, skip: 0);
      emit(
        ProductLoaded(products: products, hasReachedMax: products.length < 20),
      );
    } catch (exception) {
      emit(
        ProductError(
          message: 'Failed to fetch products: ${exception.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductLoaded && !currentState.hasReachedMax) {
      try {
        List<Product> newProducts;

        final int skip = currentState.products.length;

        if (currentState.selectedCategory == 'All') {
          newProducts = await repository.getProducts(
            limit: 20,
            skip: currentState.products.length,
          );
        } else {
          newProducts = await repository.getProductsByCategory(
            currentState.selectedCategory,
            limit: 20,
            skip: skip,
          );
        }
        emit(
          newProducts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : currentState.copyWith(
                  products: currentState.products + newProducts,
                  hasReachedMax: newProducts.length < 20,
                ),
        );
      } catch (exception) {
        emit(
          ProductError(
            message: 'Failed to fetch products: ${exception.toString()}',
          ),
        );
      }
    }
  }

  Future<void> _onSearchProductEvent(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(GetProductsEvent());
      return;
    }

    emit(ProductLoading());
    try {
      final products = await repository.searchProducts(event.query);
      emit(ProductLoaded(products: products));
    } catch (exception) {
      emit(ProductError(message: exception.toString()));
    }
  }

  void _onChangeCategoryEvent(
    ChangeCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      emit(ProductLoading());
      try {
        List<Product> products;

        if (event.category == 'All') {
          products = await repository.getProducts(limit: 20, skip: 0);
        } else {
          products = await repository.getProductsByCategory(
            event.category.toLowerCase(),
            limit: 20,
            skip: 0,
          );
        }
        emit(
          ProductLoaded(
            products: products,
            selectedCategory: event.category,
            hasReachedMax: products.length < 20,
          ),
        );
      } catch (exception) {
        emit(ProductError(message: exception.toString()));
      }
    }
  }
}
