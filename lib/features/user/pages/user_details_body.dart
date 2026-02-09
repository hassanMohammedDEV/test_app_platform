import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../../../widgets/info_tile.dart';

class UserDetailsBody extends StatelessWidget {
  final UserDetails user;

  const UserDetailsBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user.image != null
                ? NetworkImage(user.image!)
                : null,
          ),

          const SizedBox(height: 16),

          Text(user.fullName, style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 24),

          InfoTile(title: 'Email', value: user.email),

          InfoTile(title: 'Phone', value: user.phone),

          InfoTile(title: 'Age', value: user.age?.toString()),

          InfoTile(title: 'Blood Group', value: user.bloodGroup),

          InfoTile(
            title: 'Height',
            value: user.height != null ? '${user.height} cm' : null,
          ),

          InfoTile(
            title: 'Weight',
            value: user.weight != null ? '${user.weight} kg' : null,
          ),

          InfoTile(title: 'Eye Color', value: user.eyeColor),
        ],
      ),
    );
  }
}
