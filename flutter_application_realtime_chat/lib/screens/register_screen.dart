import 'package:flutter/material.dart';
import 'package:flutter_application_realtime_chat/auth/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final void Function()? onTap;
  RegisterPage({
    Key? key,
    this.onTap,
  }) : super(key: key);

  void register(BuildContext context) {
    final auth = AuthService();

    if (passwordController.text == confirmPasswordController.text) {
      try {
        auth.signUpWithEmailPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Password don\'t match!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 219, 219),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.newspaper_rounded,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Let\'s create an account for you',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
            hintText: 'Email',
            obscureText: false,
            controller: emailController,
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: 'Password',
            obscureText: true,
            controller: passwordController,
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: 'Confirm password',
            obscureText: true,
            controller: confirmPasswordController,
          ),
          const SizedBox(
            height: 25,
          ),
          MyButton(
            text: 'Register',
            ontap: () => register(context),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: Colors.grey),
              ),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Login now',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
