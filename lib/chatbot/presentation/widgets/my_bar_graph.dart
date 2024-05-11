import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:major_project/chatbot/data/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> weeklyReport;
  const MyBarGraph({super.key, required this.weeklyReport});

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    Widget text ;

    switch(value.toInt()) {
      case 0:
        text = const Text('Mon', style: style,);
        break;
      case 1:
        text = const Text('Tue', style: style,);
        break;
      case 2:
        text = const Text('Wed', style: style,);
        break;
      case 3:
        text = const Text('Thu', style: style,);
        break;
      case 4:
        text = const Text('Fri', style: style,);
        break;
      case 5:
        text = const Text('Sat', style: style,);
        break;
      case 6:
        text = const Text('Sun', style: style,);
        break;
      default:
        text = const Text('', style: style,);
        break;
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);

  }

  @override
  Widget build(BuildContext context) {

    BarData myBarData = BarData(
        sunAmount: weeklyReport[0],
        monAmount: weeklyReport[1],
        tueAmount: weeklyReport[2],
        wedAmount: weeklyReport[3],
        thursAmount: weeklyReport[4],
        friAmount: weeklyReport[5],
        satAmount: weeklyReport[6]
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 10,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles)),
        ),
        barGroups: myBarData.barData
          .map(
                (data) => BarChartGroupData(
                    x: data.x,
                    barRods: [
                      BarChartRodData(
                        toY: data.y,
                        color: (data.y >= 7) ? Colors.green[400] : (data.y >= 5) ? Colors.yellow[400] : Colors.red[400],
                        width: 25,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 10,
                          color: Colors.grey[200]
                        )
                      ),
                    ]
                )
          )
          .toList(),
      )
    );
  }
}
