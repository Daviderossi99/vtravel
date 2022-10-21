import 'package:flutter/material.dart';
import 'package:v_travel/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: const Size(double.infinity, 40),
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }
}
