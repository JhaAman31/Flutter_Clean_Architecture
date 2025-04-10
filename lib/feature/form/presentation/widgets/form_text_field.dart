import 'dart:ffi';

import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final TextEditingController controller;
  final bool obscureText;

  const FormTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false, required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is null";
        }
        if (hintText == "Email" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }

        if (hintText == "Phone" && value.length < 10) {
          return "Enter a valid phone number";
        }
        return null;
      },
      keyboardType: inputType,
      obscureText: obscureText,
    );
  }
}
