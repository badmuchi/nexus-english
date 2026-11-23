import 'package:equatable/equatable.dart';
import '../../domain/entities/slang_item.dart';

enum SlangStatus { initial, loading, success, failure }

class SlangState extends Equatable {
  final SlangStatus status;
  final List<SlangItem> items;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const SlangState({
    this.status = SlangStatus.initial,
    this.items = const [],
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.errorMessage,
  });

  SlangState copyWith({
    SlangStatus? status,
    List<SlangItem>? items,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return SlangState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}
