import 'dart:developer';

import 'package:chat_application/core/color_pallet.dart';
import 'package:chat_application/provider/chat_provider.dart';
import 'package:chat_application/screens/chatting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    log(searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            TextField(
              onChanged: handleSearch,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: 'Search',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: themeColor,
                    width: 4,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: searchQuery.isEmpty
                    ? const Stream.empty()
                    : chatProvider.searchUser(searchQuery),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final users = snapshot.data!.docs;

                  List<UserTile> userList = [];

                  for (var user in users) {
                    final userData = user.data() as Map<String, dynamic>;
                    if (userData['userId'] != loggedInUser!.uid) {
                      final userWidget = UserTile(
                        userId: userData['userId'],
                        name: userData['username'],
                        email: userData['email'],
                        imageUrl: userData['imageurl'],
                      );
                      userList.add(userWidget);
                    }
                  }

                  return ListView(
                    children: userList,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile(
      {super.key,
      required this.userId,
      required this.name,
      required this.email,
      required this.imageUrl});
  final String userId;
  final String name;
  final String email;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Text(email),
      onTap: () async {
        final chatId = await chatProvider.getChatRoom(userId) ??
            await chatProvider.createChatRoom(userId);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ChattingScreen(
              chatId: chatId,
              receiverId: userId,
            ),
          ),
        );
      },
    );
  }
}
