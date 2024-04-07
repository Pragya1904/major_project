import 'package:flutter/material.dart';
import 'package:major_project/chatbot/presentation/pages/chat_page.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: appBarThemeColor),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: scaffoldBgColor

      ),
      home: const ChatPage(),
    );
  }
}

