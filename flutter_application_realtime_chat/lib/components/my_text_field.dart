// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  const MyTextField({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
