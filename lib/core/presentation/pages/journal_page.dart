import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  final DateTime date;
  final String bodyText;

  const JournalPage({Key? key, required this.date, required this.bodyText})
      : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late TextEditingController _journalEntryController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _journalEntryController = TextEditingController(text: widget.bodyText);
  }

  @override
  void dispose() {
    _journalEntryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
        actions: [
          if (!_isEditing && isDateToday(widget.date))
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: JournalEntryForm(
        isEditable: _isEditing,
        initialText: widget.bodyText,
        onSaved: _saveJournalEntry,
      ),
    );
  }

  bool isDateToday(DateTime dateString) {
//  DateTime date = DateTime.parse(dateString);
    DateTime today = DateTime.now();
    return dateString.year == today.year &&
        dateString.month == today.month &&
        dateString.day == today.day;
  }

  void _saveJournalEntry(String entry) {
    print('Journal Entry Saved: $entry');
    setState(() {
      _isEditing = false;
    });
  }
}

class JournalEntryForm extends StatelessWidget {
  final bool isEditable;
  final String initialText;
  final Function(String) onSaved;

  const JournalEntryForm({
    Key? key,
    required this.isEditable,
    required this.initialText,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60.0,
                  vertical: 40.0,
                ),
                child: TextField(
                  controller: TextEditingController(text: initialText),
                  maxLines: 8,
                  textAlign: TextAlign.center,
                  enabled: isEditable,
                  decoration: InputDecoration(
                    hintText: 'Write your journal entry here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: isEditable ? _handleSave : null,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    String entry = '';
    onSaved(entry);
  }
}
