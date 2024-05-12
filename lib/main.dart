import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appwrite/auth_api.dart';


import 'constants.dart';
import 'core/presentation/pages/home_page.dart';
import 'core/presentation/pages/login_page.dart';

void main() {

  runApp(
    ChangeNotifierProvider(
      create: ((context) => AuthAPI()), child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    final value = context.watch<AuthAPI>().status;
    print('TOP CHANGE Value changed to: $value!');

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: appBarThemeColor),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: scaffoldBgColor,
      ),
      home: value == AuthStatus.uninitialized
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : value == AuthStatus.authenticated
          ? const HomePage()
          : const LoginPage(),
    );
  }
}

