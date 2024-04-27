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


    final model= GenerativeModel(model: 'gemini-pro', apiKey: apiKey,generationConfig: GenerationConfig(maxOutputTokens: 100));
    final chat = model.startChat(history: [
            Content.text('hi'),
            Content.model([TextPart('Hi there! 👋 How can I help brighten your day? �')]),
            Content.text('I\'m sad'),
            Content.model([TextPart('Oh no, I\'m so sorry to hear that you\'re feeling sad. 😔 Would you like to talk about what\'s making you feel this way? Sometimes just expressing what\'s going on can help.\n If you\'d rather not talk about it, that\'s totally okay too! We can find another way to lift your spirits. Maybe a funny video, a calming breathing exercise, or some inspiring quotes? Just let me know what you need. ❤')]),
      Content.text(' what is your name'),
      Content.model([TextPart('My name is Musa! It means "Moses" in Arabic and is said to signify someone who is drawn from the water, just like baby Moses was from the Nile River. I think it\'s quite fitting because I hope to be a source of support and comfort, like a safe harbor in a storm. 😌 What\'s your name?')]),
      Content.text('My name is prajju'),
      Content.model([TextPart(' Prajju, that\'s a lovely name! 😊 It has a nice ring to it. Does it have a special meaning?\n And just to be sure, is it pronounced as "Pra-ju" or "Pra-joo"? I want to make sure I say it right. �')]),
      Content.text(' it\'s double j u'),
      Content.model([TextPart('Prajj-u, got it! 👍 Thank you for letting me know. \n So, Prajj-u, what would you like to do today? Is there anything I can do to help lift your spirits a bit?')]),

    ]);
    var content,response;

       content = Content.text(userMessage);
       response = await chat.sendMessage(content);


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
    else
    {
      print(response);
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
