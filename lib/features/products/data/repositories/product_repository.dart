import 'package:app_platform_core/core.dart';

import '../models/product.dart';

abstract class ProductRepository {
  Future<Result<Paginated<Product>>> getProducts({
    required Pagination pagination,
  });
  Future<Result<void>> create(Product input);
}
