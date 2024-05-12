import 'package:flutter/material.dart';


//root
const primaryColor = Color(0xFF6252DA);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xffC5C4FE);
                        // Colors.purple.shade50;

//gradient in  loader screens
 var radialGradient = RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
            Color(0xFF2E2E48).withOpacity(0.5),
            ],
            stops: [1.0],
          );

//appwrite
const String APPWRITE_PROJECT_ID = "6637ad0b002483ef1fb6";
const String APPWRITE_URL = "https://cloud.appwrite.io/v1";
const String APPWRITE_DATABASE_ID = "66386f7c000028e08974";
const String COLLECTION_MESSAGES = "6638b36200211fd6669f";
const String COLLECTION_REPORTS = "6638b36f000519102577";
const String COLLECTION_JOURNALS = "663e05dc00056f946488";

//main screen
const appBarThemeColor = Color(0xff262933);
const scaffoldBgColor = Color(0xff191e2e);

//home_page
const iconColor = Color(0xff90948d);
const bottomContainerBgColor = Color(0xff1f2432);
// const textFieldBgColor = Color(0xff0f141e);
const textFieldBgColor = Colors.grey;
const textFieldTextColor = Colors.white;

//messages_page
const userMsgBubbleColor = Color(0xff8B7CDB);
const botMsgBubbleColor = Color(0xff0D0F27);