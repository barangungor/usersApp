import 'package:flutter/material.dart';
import 'package:usersapp/views/user/layouts/list_page.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, title: const Text('Kullanıcılar')),
      body: const ListPage(),
    );
  }
}
