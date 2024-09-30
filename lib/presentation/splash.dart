import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cubit_project/util/context_extension.dart';
import 'package:flutter/material.dart';

import '../di/module.dart';

class Splash extends StatelessWidget {
  Splash({super.key});
  final FirebaseAuth _auth = getIt<FirebaseAuth>();

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        if (_auth.currentUser != null) {
          context.navigateTo('/home');
        } else {
          context.navigateTo('/login');
        }
      },
    );
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Firebase App',
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
