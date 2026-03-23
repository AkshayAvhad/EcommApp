import 'package:ecomm/features/products/domain/repositories/product_repository.dart';
import 'package:ecomm/features/products/presentation/bloc/product_event.dart';
import 'package:ecomm/features/products/presentation/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<GetProductsEvent>(_onGetProductsEvent);
  }

  Future<void> _onGetProductsEvent(
    GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (exception) {
      emit(
        ProductError(
          message: 'Failed to fetch products: ${exception.toString()}',
        ),
      );
    }
  }
}
