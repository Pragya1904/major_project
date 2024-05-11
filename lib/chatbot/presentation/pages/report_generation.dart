import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:major_project/appwrite/auth_api.dart';
import 'package:major_project/appwrite/database_api.dart';
import 'package:table_calendar/table_calendar.dart';

class ReportGeneration {

  ReportGeneration({required this.userid});

  final String userid;
  late DateTime selectedDay;
  final database = DatabaseAPI();
  late List<Document>? messages = [];
  String journalText = "";
  final model= GenerativeModel(model: 'gemini-pro', apiKey: "AIzaSyDY6juMaNQ8Xfh4XzZcZpWEQf97_mM6M_E");

  String fetchMessagesFromDocuments() {
    String fetchedMessages = "";
    print('messages length = ' + (messages!.length).toString());

    for(Document d in messages!) {
      // print('isUser  ' + d.data['isUser']);
      if(d.data['isUser']) {
        String text = d.data['messageText'];
        print('text : $text');
        fetchedMessages = fetchedMessages + text + '\n';
      }
    }

    return fetchedMessages;
  }

  fetchDataFromDatabase() async {
    print('fetching data of ' + selectedDay.toString());
    try {
      final value = await database.getDateWiseMessages(userid,selectedDay);
      messages = value.documents;
    } catch(e) {
      print('error fetching messages in report generation');
      print(e);
    }

    try {
      final value = await database.getDateWiseJournal(userid, selectedDay);
      List<Document>? journal = value.documents;
      if(journal.isNotEmpty) journalText = journal[0].data['bodyText'];
    } catch(e) {
      print('error fetching journal in report generation');
      print(e);
    }

  }

  Future< Map<String,dynamic> > talkWithGemini() async{
    final chat = model.startChat(
        history: [
          Content.text(
              'I will send you a text. You have to do the sentiment and mood analysis of it. Return two parameters in the following format and nothing else.\n\n one number out of 10 depicting the mental health of the user who\'s text it is and one paragraph (max 100 words) as the summary of the day. Use first person and past tense in the summary, use "you" and "your". Do not use "I" in your sentence. Remember your result should contain only two lines. First line should contain only one number (don\'t use n/10 format, write the number n only, in first line). Second line should be a paragraph (max 100 words). No matter what text is sent you always and always have to reply with one number in first line and an at max 100 words summary of the day sentence in second line even if sent text is empty, or it is a question, or even if it doesn\'t make any sense at all '
          ),
          Content.model([TextPart('Okay.')])
        ]
    );
    var content,response;
    String s = fetchMessagesFromDocuments();
    if(journalText != "") s = s + journalText;
    journalText = "";
    print("sent text for report : $s");

    Map<String,dynamic> data = {
      'score' : 0,
      'highlight' : "There is no text to analyze"
    };

    if(s.isEmpty) {

      return data;
    } else {

      //search report in database
      final value = await database.fetchReports(userid, selectedDay);
      List<Document>? reports = [];
      reports = value.documents;
      if(reports.length > 0) {
        //report found
        print("REPORT FOUND");
        Document report = reports[0];
        data['score'] = report.data['score'];
        data['highlight'] = report.data['highlight'];
      } else {
        //report not found
        print("REPORT NOT FOUND");
        //generate report
        content = Content.text(s);
        response = await chat.sendMessage(content);

        if (response.text!=null) {
          try {
            print("generated report :  ${response.text}");
            String generatedReport = response.text;
            bool isScoreTen = (generatedReport[0] == '1' && generatedReport[1] == '0');
            data['score'] = isScoreTen ? 10 : int.parse(generatedReport[0]);
            data['highlight'] = isScoreTen ? generatedReport.substring(3) : generatedReport.substring(2);

            //store report in appwrite only if selected day is not today
            if(isSameDay(selectedDay, DateTime.now()) == false) await database.addReport(score: data['score'], highlight: data['highlight'], reportTime: selectedDay);

            return data;
          } catch (error) {
            print("Error generating report : $error");
            return data;
          }
        }
        else
        {
          print(response);
          print('received nothing');
          return data;
        }
      }



    }
    return data;

  }

  Future< Map<String,dynamic> > generateReport(DateTime selectedDay) async {
    this.selectedDay = selectedDay;

    await fetchDataFromDatabase();
    return await talkWithGemini();
  }

}