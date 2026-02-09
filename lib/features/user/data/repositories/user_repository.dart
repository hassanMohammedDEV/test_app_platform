import 'package:app_platform_core/core.dart';

import '../models/models.dart';

abstract class UserRepository {
  Future<Result<List<User>>> getUsers();
  Future<Result<UserDetails>> getUserDetails(int id);
  Future<Result<void>> deleteUser(int id);
  Future<Result<User>> updateUser(User user);

  Future<Result<Paginated<User>>> getUsersPagination({
    required Pagination pagination,
    UserFilters? filters,
  });
}