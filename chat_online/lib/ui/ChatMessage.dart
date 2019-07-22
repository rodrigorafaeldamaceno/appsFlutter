import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  dynamic data;

  ChatMessage(this.data) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["senderName"],
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: data["imgurl"] != null
                      ? Image.network(
                          data["imgurl"],
                          width: 250,
                        )
                      : Text(data["text"]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
