import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {}

class SelectCategoryEvent extends CategoryEvent {
  final String category;

  SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
