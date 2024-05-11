import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:major_project/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'report_generation.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  AuthStatus authStatus = AuthStatus.uninitialized;
  late String userId;
  late ReportGeneration report;
  int mentalHealthScore = 0;
  String mentalHealthDayHighlight = "No response from server";
  late Future<String> _reportFuture;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
    userId = appwrite.userid!;
    // print("appwrite userid: ${appwrite.userid}");
    report = ReportGeneration(userid: userId);
    _reportFuture = getReport();
  }

  Future<String> getReport() async {
    Map<String,dynamic> reportScoreAndHighlight = await report.generateReport(_selectedDay);
    print('reportScoreAndHighlight : $reportScoreAndHighlight');
    mentalHealthScore = reportScoreAndHighlight['score'];
    mentalHealthDayHighlight = reportScoreAndHighlight['highlight'];
    return 'Data loaded';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _reportFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget w = const Placeholder();
        if (snapshot.hasData) {

          w = Scaffold(
                body: SingleChildScrollView(
                            child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) async {
                      _selectedDay = selectedDay;
                      late BuildContext dialogContext;
                            
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            dialogContext = context;
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          });
                            
                      await getReport();
                            
                      Navigator.of(dialogContext).pop();
                            
                      setState(() {
                        print('selected day : ' + _selectedDay.toString());
                        _focusedDay = focusedDay; // update '_focusedDay' here as well
                      });
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      // print("focused day on page change : " + focusedDay.toString());
                      _focusedDay = focusedDay;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                            
                      Text('${mentalHealthScore.toString()}/10'),
                            
                      Container(
                        width: MediaQuery.of(context).size.height * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: -90.0,
                            sections: [
                              PieChartSectionData(
                                value: mentalHealthScore.toDouble(),
                                color: (mentalHealthScore >= 7) ? Colors.green : (mentalHealthScore >= 5) ? Colors.yellow : Colors.red,
                              ),
                              PieChartSectionData(
                                value: 10.0-mentalHealthScore,
                                color: Colors.grey,
                              ),
                            ],
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: double.infinity,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E2E48),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(mentalHealthDayHighlight,textAlign: TextAlign.center,)
                  ),
                ],
                            
                            ),
                          ),
              );
        } else if (snapshot.hasError) {
          w = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ]
            ),
          );
        } else {
          w = const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Fetching Report...'),
                  ),
                ]
            ),
          );

        }
        return w;
      },
    );
  }
}
