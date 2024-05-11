import 'package:flutter/material.dart';
import 'package:major_project/chatbot/presentation/pages/journal_page.dart';

class JournalCard extends StatelessWidget {
  final String date;
  final VoidCallback ontap;
  const JournalCard({super.key, required this.date, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueAccent,
          ),
          height: 100.0,
          width: 50.0,
          child: Center(child: Text(date)),
        ),
      ),
    );
  }
}
