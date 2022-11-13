import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;

  final IconData? icon;

  final Function(String)? onSubmitted;

  final void Function()? togglePassword;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.onSubmitted,
      this.icon,
      this.togglePassword});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool passwordVisible = false;

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPassword = widget.icon == Icons.lock;
    return SizedBox(
      height: 50,
      child: TextField(
        obscureText: isPassword & !passwordVisible,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        onSubmitted: widget.onSubmitted,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  size: 20.0,
                )
              : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    size: 20.0,
                  ),
                  onPressed: togglePassword,
                )
              : null,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: buttonColor,
              width: 2,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: secondaryBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
