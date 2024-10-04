import 'package:firebase_cubit_project/util/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/module.dart';
import '../logic/auth/auth_cubit.dart';
import '../logic/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state is AuthSuccess) {
          context.navigateTo("/home");
        } else if (state is AuthFailure) {
          context.showSnackBar(state.error);
        }
      }, builder: (context, state) {
        if (state is Loading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () => _login('marwax@gmail.com', '123456'),
                ),
                const SizedBox(
                  height: 120,
                ),
                TextButton(
                  child: Text("Don't have account? Register Now"),
                  onPressed: () {
                    context.navigateTo("/register");
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  _login(String email, String password) {
    getIt<AuthCubit>().login(email, password);
  }
}
