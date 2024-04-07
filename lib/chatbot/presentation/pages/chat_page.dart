import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../constants.dart';
import '../../data/models/messageModel.dart';
import '../widgets/messageList.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  var apiKey="AIzaSyCu_6yYXaaUP1mA7iZUUuyLs9cY2DmjDmg";
  TextEditingController _controller=TextEditingController();
  List<Message> _messages=[];

  Future talkWithGemini() async{
    final userMessage=_controller.text;
    print("input is $userMessage");
    if (userMessage.isNotEmpty) {
      try {
        setState(() {
          _messages.add(Message(isUser: true, message: userMessage, date: DateTime.now()));
        });
      } catch (error) {
        print("Error adding message: $error");
      }
    }
    print("message list is ${_messages.isNotEmpty ? _messages[0].message : "No messages"}");

    final model= GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
        final content= Content.text(userMessage);
        final response= await model.generateContent([content]);
        print("response from gemini was:  ${response.text}");
    if (response.text!=null) {
      try {
        setState(() {
          _messages.add(Message(isUser: false, message: response.text ?? 'error getting response..try again later', date: DateTime.now()));
        });
      } catch (error) {
        print("Error adding message: $error");
      }
    }
  }



  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sakha - Ur true Buddy"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages(messages:_messages)),
            Container(
              color:bottomContainerBgColor ,
              padding: EdgeInsets.symmetric(horizontal:width*0.005,vertical: height*0.02),
              child: Row(
                children: [
                  Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: height*0.002),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color:  textFieldBgColor,),
                    //Color(0xff2877ef),
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: "Enter your message",border: InputBorder.none),
                      style: TextStyle(color: textFieldTextColor,),
                    ),
                  )),
                  IconButton(onPressed: (){
                    //sendMessage(_controller.text);
                    talkWithGemini();
                    _controller.clear();
                  }, icon: const Icon(Icons.send,color: iconColor,),)
                ],
              ),

            )
          ],
        ),
      ),
    );
  }

}
