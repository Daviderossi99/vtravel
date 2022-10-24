import 'package:flutter/material.dart';
import 'package:v_travel/responsive/responsive.dart';
import 'package:v_travel/screens/login_screen.dart';
import 'package:v_travel/screens/signup_screen.dart';

import '../widgets/custom_button.dart';

class OnBoardingScreen extends StatelessWidget {
  static const routeName = '/onBoarding';
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              'Welcome to \n VTravel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  text: 'Log in'),
            ),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, SignUpScreen.routeName);
                },
                text: 'Sign up'),
          ]),
        ),
      ),
    );
  }
}
