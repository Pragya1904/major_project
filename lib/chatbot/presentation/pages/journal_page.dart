import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  final String date;
  final String bodyText;
  const JournalPage({super.key, required this.date, required this.bodyText});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {Navigator.pop(context);},
        child: Text('go back')
    );
  }
}
