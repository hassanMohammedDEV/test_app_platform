import 'package:app_platform_core/core.dart';
import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/features/user/data/repositories/user_repository.dart';
import 'package:test_pkg/features/user/providers/user_repository_provider.dart';

import '../data/models/models.dart';

final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, BaseState<UserDetails>>((ref) {
      final repository = ref.read(userRepositoryProvider);
      return UserDetailsNotifier(repository);
    });

class UserDetailsNotifier extends BaseNotifier<UserDetails> {
  UserDetailsNotifier(this.repository);

  final UserRepository repository;

  Future<void> getUserDetails(int userId) async {
    setLoading();
    final result = await repository.getUserDetails(userId);

    switch (result) {
      case Success(:final data):
        setSuccess(data);

      case Failure(:final error):
        setError(error);
    }
  }
}
