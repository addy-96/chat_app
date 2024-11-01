import 'dart:developer';

import 'package:chat_application/screens/chatting_screen.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile(
      {super.key,
      required this.chatId,
      required this.lastMessage,
      required this.timestamp,
      required this.receievedData});
  final String chatId;
  final String lastMessage;
  final DateTime timestamp;
  final Map<String, dynamic> receievedData;

  @override
  Widget build(BuildContext context) {
    return lastMessage != ""
        ? ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                receievedData['imageurl'],
              ),
            ),
            title: Text(receievedData['username']),
            subtitle: Text(
              lastMessage,
              maxLines: 2,
            ),
            trailing: Text(
              '${timestamp.hour} : ${timestamp.minute}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ChattingScreen(
                    chatId: chatId,
                    receiverId: receievedData['userId'],
                  ),
                ),
              );
            },
          )
        : Container();
  }
}
