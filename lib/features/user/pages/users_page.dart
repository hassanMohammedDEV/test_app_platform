import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_platform_ui/ui.dart';

import '../providers/user_notifier.dart';
import 'user_details_page.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(usersProvider.notifier).getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(usersProvider, (previous, next) {
    //
    //   if (previous?.status != LoadStatus.success &&
    //       next.status == LoadStatus.success) {
    //
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => const ProfilePage(),
    //       ),
    //     );
    //   }
    // });

    final state = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: AsyncView<List>(
        status: state.status,
        data: state.data,
        error: state.error,
        onLoading: () => const LoadingView(),
        onError: (e) => ErrorView(error: e),
        onEmpty: () => const Center(child: Text('No data')),
        onSuccess: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserDetailsPage(
                    userId: state.data![i].id,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(users[i].name),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(usersProvider.notifier).getUsers(),
        child: const Icon(Icons.download),
      ),
    );
  }
}
