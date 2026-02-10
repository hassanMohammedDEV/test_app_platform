import 'package:app_platform_core/core.dart';
import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/features/products/data/models/models.dart';
import 'package:test_pkg/features/products/data/repositories/product_repository.dart';
import 'package:test_pkg/features/products/data/repositories/product_repository_impl.dart';

final productCrudProvider =
    StateNotifierProvider<ProductCrudNotifier, ActionStore>(
      (ref) =>
          ProductCrudNotifier(repository: ref.read(productRepositoryProvider)),
    );

class ProductCrudNotifier extends StateNotifier<ActionStore> {
  final ProductRepository repository;

  ProductCrudNotifier({required this.repository}) : super(ActionStore());

  Future<void> delete(int id) async {
    final key = ActionKey(ActionType.delete, id.toString());

    if (state.isLoading(key.value)) return;

    state = state.start(key.value);

    await Future.delayed(const Duration(milliseconds: 500));

    state = state.success(key.value);
  }

  Future<void> check() async {
    final key = ActionKey(ActionType.check);

    if (state.isLoading(key.value)) return;

    state = state.start(key.value);

    await Future.delayed(const Duration(milliseconds: 1000));

    state = state.success(key.value);

    await Future.delayed(const Duration(milliseconds: 600));

    state = state.clear(key.value);
  }


  Future<void> create(Product input) async {
    final key = ActionKey(ActionType.create);

    if (state.isLoading(key.value)) return;

    state = state.start(key.value);

    final result = await repository.create(input);

    switch (result) {
      case Success():
        state = state.success(key.value);

      case Failure(:final error):
        state = state.fail(key.value, error);
    }
  }

  void clear(String key) {
    state = state.clear(key);
  }
}
