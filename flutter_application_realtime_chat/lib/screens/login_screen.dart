import 'package:flutter/material.dart';
import 'package:flutter_application_realtime_chat/auth/auth_service.dart';
import 'package:flutter_application_realtime_chat/components/my_text_field.dart';

import '../components/my_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  Future<void> login(BuildContext context) async {
    final authService = AuthService();
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(
    //         color: Colors.black,
    //       ),
    //     );
    //   },
    // );
    try {
      await authService.signInWithEmailPasword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
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
            'Welcome back , you\'have been missed!',
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
            height: 25,
          ),
          MyButton(
            text: 'Login',
            ontap: () => login(context),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not a member? ',
                style: TextStyle(color: Colors.grey),
              ),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Register now',
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
