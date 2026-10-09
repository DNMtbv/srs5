import 'package:flutter/material.dart';

import '../models/user.dart';

class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Card(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(user.story.isEmpty ? '—' : user.story),
              trailing: Text(user.country),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(user.phone),
            ),
            ListTile(
              leading: const Icon(Icons.mail),
              title: Text(user.email),
            ),
          ],
        ),
      ),
    );
  }
}
