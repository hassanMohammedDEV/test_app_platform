import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/common/api.dart';
import 'package:test_pkg/features/user/data/repositories/user_repository.dart';
import 'package:test_pkg/features/user/data/repositories/user_repository_impl.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(apiClient);
});
