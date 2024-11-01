import 'package:chat_application/provider/auth_provider.dart';
import 'package:chat_application/provider/chat_provider.dart';
import 'package:chat_application/provider/image_provider.dart';
import 'package:chat_application/screens/home_screen.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that Firebase is initialized properly
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Colors.transparent, // Make it transparent or any color you prefer
    statusBarIconBrightness: Brightness.dark, // Set the icon brightness
  ));

  runApp(const ChatApplication());
}

class ChatApplication extends StatelessWidget {
  const ChatApplication({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: authProvider.isSignedIn
                ? const HomeScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
