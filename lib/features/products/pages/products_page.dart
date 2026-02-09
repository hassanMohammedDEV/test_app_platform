import 'package:app_platform_state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_platform_core/core.dart';
import 'package:test_pkg/features/products/providers/products_notifier.dart';
import 'package:test_pkg/widgets/empty_state.dart';

import '../data/models/models.dart';
import '../providers/product_crud_notifier.dart';
import 'add_product_page.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    Future.microtask(() {
      ref.read(productsProvider.notifier).loadFirstPage();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final notifier = ref.read(productsProvider.notifier);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      notifier.loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsProvider);
    _listenForActions();

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) =>
            Center(child: Text(state.error?.message ?? 'Something went wrong')),
        success: (data) {
          if (state.data!.items.isEmpty) {
            return EmptyState(
              onRetry: () {
                ref.read(productsProvider.notifier).loadFirstPage();
              },
            );
          }
          return _ProductsList(
            products: state.data!.items,
            hasNext: state.data!.hasNext,
            isLoadingMore: state.data!.isLoadingMore,
            paginationError: state.data!.paginationError,
            scrollController: _scrollController,
            onRefresh: () async {
              await ref.read(productsProvider.notifier).loadFirstPage();
            },
            onRetry: () {
              ref.read(productsProvider.notifier).loadNextPage();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddProduct(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddProduct(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductPage()),
    );
  }

  void _listenForActions() {
    listenForActions(
      ref: ref,
      provider: productCrudProvider,
      reactions: {
        ActionKey(ActionType.create): ActionReaction(
          onSuccess: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('تمت الإضافة بنجاح')));
            ref.read(productsProvider.notifier).loadFirstPage();
          },
          onError: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error.message)));
          },
        ),

        ActionKey(ActionType.delete): ActionReaction(
          onSuccess: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('تم الحذف بنجاح')));
          },
          onError: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error.message)));
          },
        ),
      },
    );
  }
}

class _ProductsList extends ConsumerWidget {
  final List<Product> products;
  final bool hasNext;
  final bool isLoadingMore;
  final AppError? paginationError;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  const _ProductsList({
    required this.products,
    required this.hasNext,
    required this.isLoadingMore,
    required this.paginationError,
    required this.scrollController,
    required this.onRefresh,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          /// 🔻 Footer (Pagination)
          if (index == products.length) {
            if (paginationError != null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      paginationError!.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: onRetry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // 🔄 Loader pagination
            if (hasNext && isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return const SizedBox.shrink();
          }

          final product = products[index];

          final crud = ref.watch(productCrudProvider);
          final crudNotifier = ref.read(productCrudProvider.notifier);

          final key = ActionKey(ActionType.delete, product.id.toString());
          final isDeleting = crud.isLoading(key.value);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(product.title),
              subtitle: Text(product.description),
              leading: IconButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        await crudNotifier.delete(product.id);

                        ref.read(productCrudProvider.notifier).clear(key.value);
                      },
                icon: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete),
              ),
              trailing: Text(
                '\$${product.price}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
