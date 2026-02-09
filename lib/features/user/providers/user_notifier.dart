import 'package:app_platform_core/core.dart';
import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/features/user/data/models/user.dart';
import 'package:test_pkg/features/user/data/repositories/user_repository.dart';
import 'package:test_pkg/features/user/providers/user_repository_provider.dart';

final usersProvider =
StateNotifierProvider<UserNotifier, BaseState<List<User>>>(
      (ref) {
    final repository = ref.read(userRepositoryProvider);
    return UserNotifier(repository);
  },
);

class UserNotifier extends BaseNotifier<List<User>> {
  final UserRepository repository;

  UserNotifier(this.repository);

  Future<void> getUsers() async {
    setLoading();
    final result = await repository.getUsers();

    switch (result) {
      case Success(:final data):
        setSuccess(data);

      case Failure(:final error):
        setError(error);
    }
  }
}
