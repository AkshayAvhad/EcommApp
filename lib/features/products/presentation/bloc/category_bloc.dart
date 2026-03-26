import 'package:ecomm/features/products/domain/repositories/product_repository.dart';
import 'package:ecomm/features/products/presentation/bloc/category_event.dart';
import 'package:ecomm/features/products/presentation/bloc/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryInitial()) {
    on<GetCategoriesEvent>(_onGetCategoriesEvent);
    on<SelectCategoryEvent>(_onSelectCategoryEvent);
  }

  void _onGetCategoriesEvent(
    GetCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await repository.getCategories();
      emit(CategoryLoaded(categories: ['All', ...categories]));
    } catch (exception) {
      emit(CategoryError(exception.toString()));
    }
  }

  void _onSelectCategoryEvent(
    SelectCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      emit(
        CategoryLoaded(
          categories: currentState.categories,
          selectedCategory: event.category,
        ),
      );
    }
  }
}
