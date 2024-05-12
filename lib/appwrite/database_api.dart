import 'dart:html';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'auth_api.dart';
import 'package:major_project/constants.dart';


class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> getMessages(String userid) {
    // print("userid: ${auth.userid}");
    return databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES,
      queries: [
        Query.equal('user_id', [userid]),
        Query.limit(200),
      ]
    );
  }

  Future<DocumentList> getDateWiseMessages(String userid, DateTime currentDate) {
    // print("userid: ${auth.userid}");

    DateTime temp = currentDate.add(const Duration(hours: 24));
    DateTime right = DateTime(temp.year, temp.month, temp.day, 1, 0, 0, 0); // 1 AM current day to 1 AM next day
    DateTime left = DateTime(currentDate.year, currentDate.month, currentDate.day, 1, 0, 0, 0);

    return databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        queries: [
          Query.equal('user_id', [userid]),
          Query.limit(200),
          Query.greaterThanEqual('datetime', left.toString()),
          Query.lessThan('datetime', right.toString()),
        ]
    );
  }
  
  Future<DocumentList> fetchReports(String userid, DateTime date) {

    DateTime temp = DateTime(date.year, date.month, date.day, 12, 0, 0, 0);
    
    return databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID, 
        collectionId: COLLECTION_REPORTS,
        queries: [
          Query.equal('user_id', [userid]),
          Query.equal('datetime',temp.toString()),
        ] 
    
    );
    
  }

  Future<DocumentList> fetchWeekReports(String userid, DateTime date) {


    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    DateTime left = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 12, 0, 0, 0);
    DateTime endOfWeek = date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
    DateTime right = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 12, 0, 0, 0);

    print('\n\n');
    print(startOfWeek.toString() + '\n' + endOfWeek.toString());
    print('\n');

    return databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_REPORTS,
        queries: [
          Query.equal('user_id', [userid]),
          Query.greaterThanEqual('datetime', left.toString()),
          Query.lessThanEqual('datetime', right.toString()),
        ]

    );

  }

  Future<DocumentList> getJournals(String userid) {

    return databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_JOURNALS,
        queries: [
          Query.equal('user_id', userid),
        ]
    );
  }

  Future<DocumentList> getDateWiseJournal(String userid, DateTime date) {

    DateTime temp = DateTime(date.year, date.month, date.day, 12, 0, 0, 0);

    return databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_JOURNALS,
        queries: [
          Query.equal('user_id', userid),
          Query.equal('datetime', temp.toString()),
        ]
    );
  }

  Future<Document> addMessage({required String message, required bool isUser}) {
    // print('adding message : $message');
    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: ID.unique(),
        data: {
          'isUser' : isUser,
          'messageText': message,
          'datetime': DateTime.now().toString(),
          'user_id': auth.userid
        });
  }

  Future<dynamic> deleteMessage({required String id}) {
    return databases.deleteDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: id
    );
  }

  Future<Document> addReport({required int score, required String highlight, required DateTime reportTime}) {
    DateTime temp = DateTime(reportTime.year, reportTime.month, reportTime.day, 12, 0, 0, 0);

    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_REPORTS,
        documentId: ID.unique(),
        data: {
          'highlight' : highlight,
          'score' : score,
          'datetime' : temp.toString(),
          'user_id' : auth.userid,
        }
    );
  }

  Future<Document> addJournal({required String bodyText}) {
    DateTime now = DateTime.now();
    DateTime temp = DateTime(now.year, now.month, now.day, 12, 0, 0, 0);

    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_JOURNALS,
        documentId: ID.unique(),
        data: {
          'bodyText' : bodyText,
          'datetime' : temp.toString(),
          'user_id' : auth.userid,
        }
    );
  }

  Future<Document> updateJournal({required String documentid, required String bodyText}) {

    return databases.updateDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_JOURNALS,
        documentId: documentid,
        data: {
          'bodyText' : bodyText,
        }
    );
  }


}