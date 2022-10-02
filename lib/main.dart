import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usersapp/controllers/user/user_controller.dart';
import 'package:usersapp/views/user/user_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: const Color.fromRGBO(237, 31, 36, 1),
          ),
          home: const UserView()),
    );
  }
}
