import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [throw UnimplementedError()];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;
  final String selectedCategory;

  CategoryLoaded({required this.categories, this.selectedCategory = 'All'});

  @override
  List<Object?> get props => [categories, selectedCategory];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
