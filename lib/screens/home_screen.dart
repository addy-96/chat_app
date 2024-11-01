import 'dart:developer';

import 'package:chat_application/core/color_pallet.dart';
import 'package:chat_application/provider/auth_provider.dart' as authentication;
import 'package:chat_application/provider/chat_provider.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:chat_application/screens/search_screen.dart';
import 'package:chat_application/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;

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

  Future<Map<String, dynamic>> _getUserChats(String chatId) async {
    final chatDoc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    final users = chatData!['users'] as List<dynamic>;
    final receiverId = users.firstWhere((id) => id != loggedInUser!.uid);
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    final userData = userDoc.data();

    final result = {
      'chatId': chatId,
      'lastMessage': chatData['lastMessage'] ?? '',
      'timestamp': chatData['timestamp'].toDate() ?? DateTime.now(),
      'userData': userData
    };

  

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<authentication.AuthProvider>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const SearchScreen(),
              ),
            );
          },
          backgroundColor: themeColor,
          child: const Icon(
            Icons.search_sharp,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: themeColor,
          title: const Text(
            'Chats',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await authProvider.signOut(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatProvider.getChats(loggedInUser!.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final chatDocs = snapshot.data!.docs; // list

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(
                      chatDocs.map(
                        (chatDoc) => _getUserChats(
                          chatDoc.id,
                        ),
                      ),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final chatDataList = snapshot.data!;
                      return ListView.builder(
                        itemCount: chatDataList.length,
                        itemBuilder: (context, index) {
                          final chatData = chatDataList[index];
                          return ChatTile(
                            chatId: chatData['chatId'],
                            lastMessage: chatData['lastMessage'],
                            timestamp: chatData['timestamp'],
                            receievedData: chatData['userData'],
                          );
                        },
                      );
                    },
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
