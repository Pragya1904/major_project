import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:major_project/core/presentation/pages/home_page.dart';
import 'package:major_project/core/presentation/pages/journal_list_page.dart';
import 'package:provider/provider.dart';

import '../../../appwrite/auth_api.dart';
import '../../../appwrite/database_api.dart';

class JournalPage extends StatefulWidget {
  final DateTime date;
  final String bodyText;
  bool isNew = true;
  String documentid = "";

  JournalPage(this.isNew, this.documentid, {Key? key, required this.date, required this.bodyText})
      : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late TextEditingController _journalEntryController;
  bool _isEditing = false;
  final database = DatabaseAPI();
  late String userId;

  @override
  void initState() {
    super.initState();
    _isEditing = isDateToday(widget.date);
    _journalEntryController = TextEditingController(text: widget.bodyText);
    final AuthAPI appwrite = context.read<AuthAPI>();
    userId = appwrite.userid!;
  }

  @override
  void dispose() {
    _journalEntryController.dispose();
    super.dispose();
  }

  _saveJournalEntry() async {
    if(_journalEntryController.text.isEmpty) return;


    late BuildContext dialogContext;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });

    try {
      if(widget.isNew) {
        Document d = await database.addJournal(bodyText: _journalEntryController.text);
        widget.documentid = d.$id;
      } else {
        await database.updateJournal(documentid: widget.documentid, bodyText: _journalEntryController.text);
      }
    } catch(e) {
      print('error while adding/updating journal : $e');
    }

    Navigator.of(dialogContext).pop();

    widget.isNew = false;
  }

  bool isDateToday(DateTime date) {
    DateTime today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  String getFormattedDate() {
    String formattedDate = DateFormat('dd MMM, yyyy').format(widget.date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(!didPop) {
          Navigator.pop(context,"refresh");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Journal'),
          actions: [
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveJournalEntry,
              ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child:
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text(_isEditing ? "How was your day ?" : getFormattedDate(), style: const TextStyle(fontSize: 80, color: Colors.black, fontFamily: 'Valera'),),
                  Container(
                    width: screenWidth * 0.6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60.0,
                        vertical: 40.0,
                      ),
                      child: TextField(
                        controller: _journalEntryController,
                        maxLines: null,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          hintText: 'Write your journal entry here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}