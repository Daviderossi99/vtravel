import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_travel/resources/auth_methods.dart';
import 'package:v_travel/responsive/responsive.dart';
import 'package:v_travel/screens/home_screen.dart';
import 'package:v_travel/widgets/loading_indicator.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _authMethods.loginUser(
      context,
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  void signUpGoogleUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _authMethods.loginGoogle(context);
    setState(() {
      _isLoading = false;
    });
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  void signUpTwitterUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _authMethods.loginTwitter(context);
    setState(() {
      _isLoading = false;
    });
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  void signUpFacebookUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _authMethods.loginFacebook(context);
    setState(() {
      _isLoading = false;
    });
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: _isLoading
            ? const LoadingIndicator()
            : Responsive(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 58.0, bottom: 28),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: signUpGoogleUser,
                              elevation: 2.0,
                              fillColor: Colors.red,
                              padding: const EdgeInsets.all(15.0),
                              shape: const CircleBorder(),
                              child: const Icon(
                                FontAwesomeIcons.google,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: signUpTwitterUser,
                              elevation: 2.0,
                              fillColor: Colors.blue[600],
                              padding: const EdgeInsets.all(15.0),
                              shape: const CircleBorder(),
                              child: const Icon(
                                FontAwesomeIcons.twitter,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                            /*RawMaterialButton(
                              onPressed: () {},
                              elevation: 2.0,
                              fillColor: Colors.black,
                              padding: const EdgeInsets.all(15.0),
                              shape: const CircleBorder(),
                              child: const Icon(
                                FontAwesomeIcons.apple,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),*/
                            RawMaterialButton(
                              onPressed: signUpFacebookUser,
                              elevation: 2.0,
                              fillColor: Colors.blue[800],
                              padding: const EdgeInsets.all(15.0),
                              shape: const CircleBorder(),
                              child: const Icon(
                                FontAwesomeIcons.facebookF,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomTextField(
                                controller: _emailController,
                                icon: Icons.email,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomTextField(
                                  controller: _passwordController,
                                  icon: Icons.lock),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                                top: 60,
                              ),
                              child:
                                  CustomButton(onTap: loginUser, text: 'Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
