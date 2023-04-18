import 'package:chat_app/shared/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Widgets/message_tile.dart';
import '../Widgets/text_widget.dart';
import '../Widgets/widget.dart';
import '../services/database_services.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  Constant constant = Constant();

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseServices().getChat(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseServices().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        title: TextWidget(
          title: widget.groupName,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                ),
              );
            },
            icon: const Icon(
              Icons.info,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: chats,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data!.docs[index]['message'],
                      sender: snapshot.data!.docs[index]["sender"],
                      sentByMe: widget.userName ==
                          snapshot.data!.docs[index]['sender'],
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: width,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: constant.defaultPadding,
                  vertical: constant.defaultPadding - 2),
              width: width,
              color: const Color(0xff6B728E),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseServices().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
