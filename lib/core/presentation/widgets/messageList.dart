import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:major_project/appwrite/auth_api.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../data/models/messageModel.dart';


class Messages extends StatefulWidget {

  // when changed from List<Message> to List<Document>? , messages started loading slowly
  final List<Document>? messages;

  const Messages({super.key, required this.messages});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.height;

    final scrollControllerProvider = Provider.of<AuthAPI>(context);
    final scrollController = scrollControllerProvider.scrollController;

    return ListView.separated(
      reverse: true,
      shrinkWrap: true,
      controller: scrollController,
      itemBuilder:(context,index){
        return Container(
          margin: EdgeInsets.symmetric(horizontal:width*0.014,vertical:height*0.01),
          child: Row(
              mainAxisAlignment: widget.messages![index].data['isUser'] ? MainAxisAlignment.end : MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: widget.messages![index].data['isUser'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(widget.messages![index].data['isUser']?"You" : "Sakha",style: TextStyle(color: canvasColor,fontSize: 12)),
                    Container(
                        constraints: BoxConstraints(maxWidth: width*0.37),
                        padding: EdgeInsets.symmetric(
                            vertical: 7, horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              20,
                            ),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(
                                widget.messages![index].data['isUser']
                                    ? 0
                                    : 20),
                            topLeft: Radius.circular(
                                widget.messages![index].data['isUser']
                                    ? 20
                                    : 0),
                          ),
                          color:  widget.messages![index].data['isUser']
                              ? userMsgBubbleColor
                              : botMsgBubbleColor,),
                        child: Text(widget.messages![index].data['messageText'],softWrap: true,maxLines: 20,)),
                  ],
                )
              ]
          ),
        );
      } ,
      separatorBuilder: (_,i)=>Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages!.length
    );
  }
}