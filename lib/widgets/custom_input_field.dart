import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  // ignore: prefer_const_constructors_in_immutables
  CustomTextFormField(
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
        fillColor: Color.fromARGB(45, 255, 37, 157),
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