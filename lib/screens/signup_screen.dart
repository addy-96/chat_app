import 'dart:developer';
import 'package:chat_application/core/color_pallet.dart';
import 'package:chat_application/core/custom_snack.dart';
import 'package:chat_application/core/text_style.dart';
import 'package:chat_application/provider/auth_provider.dart';
import 'package:chat_application/provider/image_provider.dart';
import 'package:chat_application/screens/home_screen.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:chat_application/widgets/custom_dividor.dart';
import 'package:chat_application/widgets/custom_textfield.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthProvider();

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool signUPtaped = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void onSignUp() async {
    
    
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      log('invalid');
    }
    final profileIamgeProvider =
        Provider.of<ProfileImageProvider>(context, listen: false);

    if (profileIamgeProvider.selectedImage == null) {
      getSnack(
          'Please select an image for profile', context, snackType.failure);
      return;
    }

    if (isValid && profileIamgeProvider.selectedImage != null) {
      await _auth.createWithEmailAndPass(
        context,
        emailController.text,
        passController.text,
        usernameController.text,
        profileIamgeProvider.selectedImage!,
      );
    }
    if (_auth.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 12,
              right: 12,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'SignUp',
                      style: CustomTextStyle.getCustomStyle(50),
                    ),
                    Consumer<ProfileImageProvider>(
                      builder: (context, profileImageProvider, child) =>
                          InkWell(
                        onTap: () {
                          profileImageProvider.getImage();
                        },
                        borderRadius: BorderRadius.circular(60),
                        child: DashedCircle(
                          dashes: 25,
                          color: themeColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  profileImageProvider.selectedImage != null
                                      ? FileImage(
                                          profileImageProvider.selectedImage!)
                                      : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      hintText: 'Username',
                      textController: usernameController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      hintText: 'Email',
                      textController: emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      hintText: 'Password',
                      textController: passController,
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: onSignUp,
                      enableFeedback: true,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'Create Account',
                            style: CustomTextStyle.getButtonText(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomDividor(text: 'OR'),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an Account? Login.',
                        style: CustomTextStyle.normaltext(
                          18,
                          Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
