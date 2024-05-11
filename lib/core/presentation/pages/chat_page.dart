import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:appwrite/appwrite.dart';
import 'package:major_project/appwrite/auth_api.dart';
import 'package:major_project/appwrite/database_api.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../widgets/messageList.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final database = DatabaseAPI();
  List<Document>? messages = [];
  AuthStatus authStatus = AuthStatus.uninitialized;
  final TextEditingController _controller = TextEditingController();
  late String userId;
  double height = 0.0;
  double width = 0.0;
  late Future<String> _chatFuture;

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
    userId = appwrite.userid!;
    print("appwrite userid: ${appwrite.userid}");
    _chatFuture = loadMessages();
  }

  Future<String> loadMessages() async {
    try {

      final value = await database.getMessages(userId);
      setState(() {
        messages = value.documents;
      });
    } catch (e) {
      print(e);
    }

    return "Data loaded";
  }

  addMessage(String text, bool is_user) async {
    try {
      await database.addMessage(message: text, isUser: is_user );
      // const snackbar = SnackBar(content: Text('Message added!'));
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
      _controller.clear();
      loadMessages();


    } on AppwriteException catch (e) {
      showAlert(title: 'Error', text: e.message.toString());
    }
  }

  deleteMessage(String id) async {
    try {
      await database.deleteMessage(id: id);
      loadMessages();
    } on AppwriteException catch (e) {
      showAlert(title: 'Error', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  //pragya's api key
  var apiKey="AIzaSyCu_6yYXaaUP1mA7iZUUuyLs9cY2DmjDmg";
  // @override
  // var apiKey="AIzaSyDY6juMaNQ8Xfh4XzZcZpWEQf97_mM6M_E"; //rishabh's api key

  Future talkWithGemini() async{
    final userMessage=_controller.text;
    print("input is $userMessage");
    if (userMessage.isNotEmpty) {
      try {
        Provider.of<AuthAPI>(context, listen: false).scrollToBottom();
        addMessage(userMessage, true);
        // setState(() {
        //   _messages.add(Message(isUser: true, message: userMessage, date: DateTime.now()));
        // });
      } catch (error) {
        print("Error adding message: $error");
      }
    }

    final userName=Provider.of<AuthAPI>(context, listen: false).getUsername()?? "";

<<<<<<< HEAD:lib/chatbot/presentation/pages/chat_page.dart
     // final model= GenerativeModel(model: 'gemini-pro', apiKey: apiKey,generationConfig: GenerationConfig(maxOutputTokens: 100));
=======
     //final model= GenerativeModel(model: 'gemini-pro', apiKey: apiKey,generationConfig: GenerationConfig(maxOutputTokens: 100));
>>>>>>> dc14eb20d55cf27fb90971c726a52f1e57633a83:lib/core/presentation/pages/chat_page.dart
   final model= GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final chat = model.startChat(
        history: [
        Content.text('Keep the length of your responses under 100 words. Always give short empathetic responses like an caring and understanding human being'),
        Content.model([TextPart('Okay')]),
      Content.text('hi'),
      Content.model([TextPart('Hi there! 👋 How can I help brighten your day? �')]),
      Content.text('I\'m sad'),
      Content.model([TextPart('Oh no, I\'m so sorry to hear that you\'re feeling sad. 😔 Would you like to talk about what\'s making you feel this way? Sometimes just expressing what\'s going on can help.\n If you\'d rather not talk about it, that\'s totally okay too! We can find another way to lift your spirits. Maybe a funny video, a calming breathing exercise, or some inspiring quotes? Just let me know what you need. ❤')]),
      Content.text(' what is your name'),
      Content.model([TextPart('My name is Sakha! It means "Close friend" or "associate" in Sanskrit and I think it\'s quite fitting because I hope to be a source of support and comfort, like a safe harbor in a storm. 😌 What\'s your name?')]),
      Content.text('My name is $userName'),
      // Content.model([TextPart(' Prajju, that\'s a lovely name! 😊 It has a nice ring to it. Does it have a special meaning?\n And just to be sure, is it pronounced as "Pra-ju" or "Pra-joo"? I want to make sure I say it right. �')]),
      // Content.text(' it\'s double j u'),
      Content.model([TextPart('$userName, got it! 👍 Thank you for letting me know. \n So, $userName, what would you like to do today? Is there anything I can do to help lift your spirits a bit?')]),

    ]

    );
    var content,response;

     content = Content.text(userMessage);
     response = await chat.sendMessage(content);


    print("response from gemini was:  ${response.text}");
    if (response.text!=null) {
      try {
        addMessage(response.text, false);
        // setState(() {
        //   _messages.add(Message(isUser: false, message: response.text ?? 'error getting response..try again later', date: DateTime.now()));
        // });
      } catch (error) {
        print("Error adding message: $error");
      }
    }
    else
    {
      addMessage("can you repeat what you said again? Sorry I couldn't receive it correctly earlier", false);
      print(response);
    }
  }

  signOut() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.signOut();
  }

  Widget chatPage() {

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            Expanded(child: Messages(messages:messages)),
            Container(
              // color:bottomContainerBgColor ,
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
                      onFieldSubmitted: (value) {
                        talkWithGemini();
                        _controller.clear();
                      },
                    ),
                  )),
                  IconButton(onPressed: (){
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

  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.height;

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AuthAPI>(context, listen: false).scrollToBottom();
        },
        child: Icon(Icons.arrow_drop_down),
      ),
      body: FutureBuilder<String>(
          future: _chatFuture,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            Widget w = const Placeholder();

            if(snapshot.hasData) {
              w = chatPage();
            } else if(snapshot.hasError) {
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
                        child: Text('Fetching messages...'),
                      ),
                    ]
                ),
              );
            }

            return w;
          }
      )
      ,
    );
  }

}
