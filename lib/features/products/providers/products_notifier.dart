import 'package:app_platform_core/core.dart';
import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/features/products/providers/product_filters_provider.dart';

import '../data/models/product.dart';
import '../data/repositories/repositories.dart';

final productsProvider =
    StateNotifierProvider.autoDispose<ProductsNotifier, BaseState<Paginated<Product>>>((
      ref,
    ) {
      final repo = ref.read(productRepositoryProvider);
      final filters = ref.watch(productFiltersProvider);
      final notifier = ProductsNotifier(repo, filters);

      Future.microtask(() {
        notifier.loadFirstPage();
      });

      return notifier;
    });

class ProductsNotifier extends BaseNotifier<Paginated<Product>> {
  final ProductRepository repository;
  final QueryFilters filters;

  Pagination _pagination = const Pagination(page: 1, limit: 10);

  ProductsNotifier(this.repository, this.filters);

  Future<void> loadFirstPage() async {
    _pagination = _pagination.first();
    setLoading();

    final result = await repository.getProducts(
      pagination: _pagination,
      filters: filters,
    );

    _handle(result, reset: true);
  }

  Future<void> loadNextPage() async {
    final current = state.data;
    if (current == null) return;
    if (!current.hasNext) return;
    if (current.isLoadingMore) return;

    setSuccess(current.copyWith(isLoadingMore: true, paginationError: null));

    _pagination = _pagination.next();

    final result = await repository.getProducts(
      pagination: _pagination,
      filters: filters,
    );

    switch (result) {
      case Success():
        _handle(result);

      case Failure(:final error):
        setSuccess(
          current.copyWith(isLoadingMore: false, paginationError: error),
        );
    }
  }

  void _handle(Result<Paginated<Product>> result, {bool reset = false}) {
    switch (result) {
      case Success(:final data):
        final List<Product> items = reset
            ? data.items
            : [...state.data?.items ?? <Product>[], ...data.items];

        setSuccess(
          data.copyWith(
            items: items,
            isLoadingMore: false,
            paginationError: null,
          ),
        );

      case Failure(:final error):
        setError(error);
    }
  }
}
