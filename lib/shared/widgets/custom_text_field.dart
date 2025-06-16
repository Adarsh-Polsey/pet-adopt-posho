import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hint = "",
    this.controller,
    this.onChange,
    this.focusNode,
  });

  final String hint;
  final TextEditingController? controller;
  final Function(String?)? onChange;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      onChanged: onChange,
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.grey, fontSize: 15, height: 0.1),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
      ),
    );
  }
}
