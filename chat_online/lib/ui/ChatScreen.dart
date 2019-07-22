import 'package:chat_online/ui/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_online/ui/TextCompose.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          centerTitle: true,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection("messages").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                        break;
                      default:
                        ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data.documents.lenght,
                          itemBuilder: (BuildContext context, int index) {
                            List r = snapshot.data.documents.reversed.toList();
                            return ChatMessage(r[index].data);
                          },
                        );
                        break;
                    }
                  }),
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: TextCompose(),
            )
          ],
        ),
      ),
    );
  }
}
