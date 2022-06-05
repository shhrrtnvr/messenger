import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  const CustomTextFormField(
      {Key? key,
      required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (newValue) => onSaved(newValue!),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!) ? null : 'Enter a valid value';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(16, 37, 255, 233),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onUpdate;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField(
      {Key? key,
      required this.onUpdate,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (text) => onUpdate(text),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(184, 129, 187, 237),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
      ),
    );
  }
}
