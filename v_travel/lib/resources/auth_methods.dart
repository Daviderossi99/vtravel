import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:v_travel/models/user.dart' as model;
import 'package:v_travel/utils/utils.dart';

import '../providers/user_provider.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  Future<bool> signUpUser(
    BuildContext context,
    String email,
    String username,
    String password,
  ) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        model.User user = model.User(
          username: username.trim(),
          email: email.trim(),
          uid: cred.user!.uid,
        );
        await _userRef.doc(cred.user!.uid).set(user.toMap());
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
    return null;
  }

  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false)
            .setUser(model.User.fromMap(
          await getCurrentUser(cred.user!.uid) ?? {},
        ));
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> loginGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>['email']).signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential cred = await _auth.signInWithCredential(credential);

      if (cred.user != null) {
        model.User user = model.User(
          username: cred.user.toString(),
          email: googleUser.email.trim(),
          uid: cred.user!.uid,
        );
        await _userRef.doc(cred.user!.uid).set(user.toMap());
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false)
            .setUser(model.User.fromMap(
          await getCurrentUser(cred.user!.uid) ?? {},
        ));
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> loginTwitter(BuildContext context) async {
    bool res = false;
    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'fcQqGUcrQe1UIdDt0ExX4DZUH',
        apiSecretKey: 'LyxJ9p2jifXWSfjgdQ5tDgReCVdTuNdl8IuE2G95dWCoAq5od3',
        redirectURI: 'vtravel://',
      );

      await twitterLogin.loginV2().then((value) async {
        final credential = TwitterAuthProvider.credential(
            accessToken: value.authToken!, secret: value.authTokenSecret!);

        UserCredential cred = await _auth.signInWithCredential(credential);

        if (cred.user != null) {
          model.User user = model.User(
            username: cred.user.toString(),
            uid: cred.user!.uid,
          );
          await _userRef.doc(cred.user!.uid).set(user.toMap());
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false)
              .setUser(model.User.fromMap(
            await getCurrentUser(cred.user!.uid) ?? {},
          ));
          res = true;
        }
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> loginFacebook(BuildContext context) async {
    bool res = false;
    try {
      final facebookLogin = await FacebookAuth.instance.login();
      if (facebookLogin.status == LoginStatus.success) {
        final credential =
            FacebookAuthProvider.credential(facebookLogin.accessToken!.token);
        UserCredential cred = await _auth.signInWithCredential(credential);

        if (cred.user != null) {
          model.User user = model.User(
            username: cred.user.toString(),
            email: cred.user!.email?.trim(),
            uid: cred.user!.uid,
          );
          await _userRef.doc(cred.user!.uid).set(user.toMap());
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false)
              .setUser(model.User.fromMap(
            await getCurrentUser(cred.user!.uid) ?? {},
          ));
          res = true;
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }

  signOut() {
    _auth.signOut();
  }
}
