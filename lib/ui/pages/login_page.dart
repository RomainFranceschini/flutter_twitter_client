import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login page',
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithTwitter,
          child: const Text('Login'),
        ),
      ),
    );
  }

  Future<void> _signInWithTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    final UserCredential credential;

    try {
      if (kIsWeb) {
        credential =
            await FirebaseAuth.instance.signInWithPopup(twitterProvider);
      } else {
        credential =
            await FirebaseAuth.instance.signInWithProvider(twitterProvider);
      }
    } catch (e) {
      log('ohno', error: e, name: runtimeType.toString());
    }
  }
}
