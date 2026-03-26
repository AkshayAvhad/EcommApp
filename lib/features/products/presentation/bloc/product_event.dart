import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends ProductEvent {}

class SearchProductsEvent extends ProductEvent {
  final String query;

  SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreProductsEvent extends ProductEvent {}

class ChangeCategoryEvent extends ProductEvent {
  final String category;

  ChangeCategoryEvent(this.category);
}
