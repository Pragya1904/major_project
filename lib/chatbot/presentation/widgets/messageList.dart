import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../data/models/messageModel.dart';


class Messages extends StatefulWidget {

  final List<Message> messages;

  const Messages({super.key, required this.messages});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.height;
    return ListView.separated(itemBuilder:(context,index){
      return Container(
        margin: EdgeInsets.symmetric(horizontal:width*0.014,vertical:height*0.01),
        child: Row(
            mainAxisAlignment: widget.messages[index].isUser ?MainAxisAlignment.end:MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  constraints: BoxConstraints(maxWidth: width*0.37),
                  padding: EdgeInsets.symmetric(
                      vertical: 14, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        20,
                      ),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(
                          widget.messages[index].isUser
                              ? 0
                              : 20),
                      topLeft: Radius.circular(
                          widget.messages[index].isUser
                              ? 20
                              : 0),
                    ),
                    color:  widget.messages[index].isUser
                        ? userMsgBubbleColor
                        : botMsgBubbleColor,),
                  child: Text(widget.messages[index].message,softWrap: true,maxLines: 20,))
            ]
        ),
      );
    } , separatorBuilder: (_,i)=>Padding(padding: EdgeInsets.only(top: 10)), itemCount: widget.messages.length);
  }
}