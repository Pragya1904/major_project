import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:major_project/constants.dart';


class JournalCard extends StatelessWidget {
  final String date, body;
  final VoidCallback ontap;
  final int index;
  const JournalCard({super.key, required this.date, required this.ontap, required this.body, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: canvasColor,
            image: DecorationImage(
              image: AssetImage(index%2==1 ? "assets/orbs1.jpg" : "assets/orbs0.jpg"), // Replace with your image path
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
          padding: const EdgeInsets.all(16.0), // Added padding inside the container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 8.0), // Space between date and body text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  body,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );}
}
