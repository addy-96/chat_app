import 'package:chat_application/core/color_pallet.dart';
import 'package:chat_application/core/text_style.dart';
import 'package:chat_application/provider/auth_provider.dart';
import 'package:chat_application/screens/home_screen.dart';
import 'package:chat_application/screens/signup_screen.dart';
import 'package:chat_application/widgets/custom_dividor.dart';
import 'package:chat_application/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  onLogin() async {
    bool isValid = _formKey.currentState!.validate();
    final auth = AuthProvider();

    if (isValid) {
      await auth.signinUserWithEmailPass(
          context, emailController.text, passController.text);
    }

    if (auth.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Padding(
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
                    'Login',
                    style: CustomTextStyle.getCustomStyle(50),
                  ),
                  const SizedBox(height: 40),
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
                    onTap: () {
                      onLogin();
                    },
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
                          'Login',
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
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Create an Account? SignUp.',
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
    );
  }
}
