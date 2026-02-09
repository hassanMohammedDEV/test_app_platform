import 'package:app_platform_core/core.dart';
import 'package:app_platform_network/network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/common/api.dart';

import '../models/product.dart';
import 'product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(apiClient);
});

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl(this.apiClient);

  Map<String, String> _mapPagination(Pagination p) {
    return {
      'limit': p.limit.toString(),
      'skip': ((p.page - 1) * p.limit).toString(),
    };
  }


  @override
  Future<Result<Paginated<Product>>> getProducts({
    required Pagination pagination,
  }) {
    final query = _mapPagination(pagination);

    return apiClient.get(
      '/products',
      query: query,
      parser: (json) {
        final items = (json['products'] as List)
            .map((e) => Product.fromJson(e))
            .toList();

        final total = json['total'] as int;

        return Paginated<Product>(
          items: items,
          pagination: pagination,
          hasNext: pagination.page * pagination.limit < total,
        );
      },
    );
  }

  @override
  Future<Result<void>> create(Product input) async {
    return apiClient.post(
      '/products/add',
      body: input.toJson(),
      parser: (_) {},
    );
  }
}
