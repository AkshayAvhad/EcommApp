import 'package:ecomm/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  final String selectedCategory;

  ProductLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.selectedCategory = 'All',
  });

  // copyWith is essential for Pagination to "append" items
  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    String? selectedCategory,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}
