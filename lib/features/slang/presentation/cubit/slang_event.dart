import 'package:equatable/equatable.dart';
import '../../domain/entities/slang_item.dart';

abstract class SlangEvent extends Equatable {
  const SlangEvent();

  @override
  List<Object?> get props => [];
}

class LoadSlangItemsEvent extends SlangEvent {
  final String? category;
  final String? level;
  final String? query;

  const LoadSlangItemsEvent({this.category, this.level, this.query});

  @override
  List<Object?> get props => [category, level, query];
}

class ChangeSlangCategoryEvent extends SlangEvent {
  final String category;

  const ChangeSlangCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchSlangEvent extends SlangEvent {
  final String query;

  const SearchSlangEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddSlangToSrsEvent extends SlangEvent {
  final SlangItem item;

  const AddSlangToSrsEvent(this.item);

  @override
  List<Object?> get props => [item];
}
