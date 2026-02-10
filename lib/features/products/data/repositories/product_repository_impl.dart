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

  Map<String, String> _buildQuery({
    required Pagination pagination,
    QueryFilters? filters,
  }) {
    return {
      'limit': pagination.limit.toString(),
      'skip': ((pagination.page - 1) * pagination.limit).toString(),

      if (filters != null && !filters.isEmpty)
        ...filters.toQuery(),
    };
  }


  @override
  Future<Result<Paginated<Product>>> getProducts({
    required Pagination pagination,
    QueryFilters? filters,
  }) {
    final query = _buildQuery(
      pagination: pagination,
      filters: filters,
    );

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
