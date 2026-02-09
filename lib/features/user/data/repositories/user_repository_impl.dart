import 'package:app_platform_core/core.dart';
import 'package:app_platform_network/network.dart';

import '../models/models.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl(this.apiClient);

  @override
  Future<Result<List<User>>> getUsers() {
    return apiClient.get(
      '/users',
      parser: (json) =>
          (json['users'] as List).map((e) => User.fromJson(e)).toList(),
    );
  }

  @override
  Future<Result<UserDetails>> getUserDetails(int id) {
    return apiClient.get(
      '/users/$id',
      parser: (json) => UserDetails.fromJson(json),
    );
  }

  @override
  Future<Result<void>> deleteUser(int id) {
    return apiClient.delete('/users/$id', parser: (_) {});
  }

  @override
  Future<Result<User>> updateUser(User user) {
    return apiClient.put(
      '/users/${user.id}',
      parser: (_) {
        return User(id: 1, name: 'name');
      },
    );
  }

  /// ترجمة Pagination → API query
  Map<String, dynamic> _mapPagination(Pagination p) {
    return {
      // API المستخدمين يستخدم page / limit
      'page': p.page,
      'limit': p.limit,
    };
  }

  @override
  Future<Result<Paginated<User>>> getUsersPagination({
    required Pagination pagination,
    UserFilters? filters,
  }) {
    final query = {
      ..._mapPagination(pagination),
      ...?filters?.toQuery(),
    };

    return apiClient.get(
      '/users',
      query: query,
      parser: (json) {
        final users = (json['users'] as List)
            .map((e) => User.fromJson(e))
            .toList();

        /// any another parameters add..
        final hasNext = json['hasMore'] == true;

        return Paginated<User>(
          items: users,
          pagination: pagination,
          hasNext: hasNext,
        );
      },
    );
  }
}
