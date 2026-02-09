import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_platform_ui/ui.dart';
import 'package:test_pkg/features/user/pages/user_details_body.dart';
import 'package:test_pkg/features/user/providers/user_details_provider.dart';

import '../data/models/models.dart';

class UserDetailsPage extends ConsumerStatefulWidget {
  final int userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  ConsumerState<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userDetailsProvider.notifier).getUserDetails(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userDetailsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: AsyncView<UserDetails>(
        status: state.status,
        data: state.data,
        error: state.error,

        onLoading: () => const Center(child: CircularProgressIndicator()),

        onError: (error) => Center(child: Text(error.message)),

        onEmpty: () => const Center(child: Text('No data')),

        onSuccess: (user) => UserDetailsBody(user: user),
      ),
    );
  }
}
