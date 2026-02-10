import 'package:app_platform_core/core.dart';
import 'package:test_pkg/features/products/data/models/models.dart';
import 'package:test_pkg/features/products/data/repositories/product_repository.dart';

class FakeProductRepository implements ProductRepository {
  int callCount = 0;

  @override
  Future<Result<Paginated<Product>>> getProducts({
    required Pagination pagination,
    QueryFilters? filters
  }) async {
    callCount++;

    return Success(
      Paginated<Product>(
        items: List.generate(
          pagination.limit,
              (i) => Product(
            id: i,
            title: 'Product $i',
            description: 'Desc $i',
            price: 10,
          ),
        ),
        pagination: pagination,
        hasNext: true,
      ),
    );
  }

  @override
  Future<Result<void>> create(Product input) {
    // TODO: implement create
    throw UnimplementedError();
  }
}
