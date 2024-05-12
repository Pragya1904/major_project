import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:major_project/appwrite/database_api.dart';
import 'package:major_project/constants.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/models.dart';

import '../../../appwrite/auth_api.dart';
import '../widgets/journal_card.dart';
import 'journal_page.dart';

class JournalListPage extends StatefulWidget {
  const JournalListPage({super.key});

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  final database = DatabaseAPI();
  late String userId;
  List<Document>? journals = [];
  late Future<String> _journalFuture;

  Future<String> fetchJournals() async {
    try {
      final value = await database.getJournals(userId);
      setState(() {
        journals = value.documents;
      });
    } catch (e) {
      print(e);
    }

    return 'Data Loaded';
  }

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    userId = appwrite.userid!;
    _journalFuture = fetchJournals();
  }

  @override
  @override
  Widget build(BuildContext context) {
    DateTime latestJournalDate = DateTime.now();
    if (journals != null && journals!.isNotEmpty) {
      latestJournalDate = DateTime.parse(journals!.last.data['datetime']);
    }
    DateTime today = DateTime.now();
    bool isLatestJournalToday = false;
    if (journals != null && journals!.isNotEmpty) {
      isLatestJournalToday = (latestJournalDate.year == today.year &&
          latestJournalDate.month == today.month &&
          latestJournalDate.day == today.day);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalPage(
                !isLatestJournalToday,
                journals != null && journals!.isNotEmpty
                    ? journals!.last.$id
                    : "",
                date: DateTime.now(),
                bodyText:
                    isLatestJournalToday ? journals!.last.data['bodyText'] : "",
              ),
            ),
          );
          if (result != null && result == 'refresh') {
            setState(() {
              _journalFuture = fetchJournals();
            });
          }
        },
        child: const Icon(Icons.edit_outlined),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: FutureBuilder<String>(
            future: _journalFuture,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              Widget w = const Placeholder();

              if (snapshot.hasData) {
                w =  ListView.builder(
                    itemCount: journals != null ? journals!.length : 0,
                    itemBuilder: (context, index) {
                      if (journals != null && journals!.isNotEmpty) {
                        DateTime day =
                            DateTime.parse(journals![index].data['datetime']);
                        String bodyText = journals![index].data['bodyText'];
                        String monthName =
                            DateFormat('MMMM').format(DateTime(0, day.month));
                        String dateInText = '${day.day} $monthName';
                        return JournalCard(
                          date: dateInText,
                          ontap: () {
                            bool b = (today.year == day.year &&
                                today.month == day.month &&
                                today.day == day.day);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JournalPage(
                                  b,
                                  journals != null && journals!.isNotEmpty
                                      ? journals![index].$id
                                      : "",
                                  date: day,
                                  bodyText: bodyText,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    });
              } else if (snapshot.hasError) {
                w = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData) {
                w = Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/emptyJournal.gif"),
                        )),
                      ),
                      Text(
                        "Whether it's sunny, stormy, or somewhere in between, jot down your mood. Let's map your emotional journey!",
                        style:
                            TextStyle(color: canvasColor, fontSize: 15,letterSpacing: 2, fontFamily: 'Vanera'),
                      )
                    ],
                  ),
                );
              } else {
                w = const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Fetching Journals...'),
                      ),
                    ],
                  ),
                );
              }
              return w;
            },
          ),
        ),
      ),
    );
  }

// Widget build(BuildContext context) {
  //
  //   DateTime latestJournalDate = DateTime.parse(journals!.last.data['datetime']);
  //   DateTime today = DateTime.now();
  //   bool isLatestJournalToday = (latestJournalDate.year == today.year && latestJournalDate.month == today.month && latestJournalDate.day == today.day);
  //
  //   return Scaffold(
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         Navigator.push(context,MaterialPageRoute(builder: (context) => JournalPage(!isLatestJournalToday, journals!.last.$id, date: DateTime.now(), bodyText: isLatestJournalToday ? journals!.last.data['bodyText'] : "",)));
  //
  //       },
  //       child: const Icon(Icons.edit_outlined),
  //     ),
  //     body: Center(
  //       child: SizedBox(
  //
  //             width: MediaQuery.of(context).size.width * 0.2,
  //             child: FutureBuilder<String>(
  //               future: _journalFuture,
  //               builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
  //                 Widget w = const Placeholder();
  //                 if(snapshot.hasData) {
  //                   w = ListView.builder(
  //                       itemCount: journals!.length,
  //                       itemBuilder: (context,index) {
  //                         DateTime day = DateTime.parse(journals![index].data['datetime']);
  //                         String bodyText = journals![index].data['bodyText'];
  //                         String monthName = DateFormat('MMMM').format(DateTime(0, day.month));
  //                         String dateInText = '${day.day} $monthName';
  //                         return JournalCard(
  //                           date:  dateInText,
  //                           ontap: () {
  //                             bool b = (today.year == day.year && today.month == day.month && today.day == day.day);
  //                             Navigator.push(context,MaterialPageRoute(builder: (context) => JournalPage(b, journals![index].$id, date: day, bodyText: bodyText,)));
  //                           },
  //                         );
  //                       }
  //                   );
  //                 } else if(snapshot.hasError) {
  //                   w = Center(
  //                     child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children : [
  //                           const Icon(
  //                             Icons.error_outline,
  //                             color: Colors.red,
  //                             size: 60,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 16),
  //                             child: Text('Error: ${snapshot.error}'),
  //                           ),
  //                         ]
  //                     ),
  //                   );
  //                 } else {
  //                   w = const Center(
  //                     child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children : [
  //                           SizedBox(
  //                             width: 60,
  //                             height: 60,
  //                             child: CircularProgressIndicator(),
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.only(top: 16),
  //                             child: Text('Fetching Journals...'),
  //                           ),
  //                         ]
  //                     ),
  //                   );
  //                 }
  //                 return w;
  //               },
  //             )
  //       ),
  //     ),
  //   );
  // }
}
