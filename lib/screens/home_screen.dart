import 'package:chat_application/provider/auth_provider.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _auth = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut(context);
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
      body:  Center(
        child: Column(
          children: [
            Text('Home'),
            TextButton(onPressed: (){
            
            }, child: Text('press'))
          ],
        ),
      ),
    );
  }
}
