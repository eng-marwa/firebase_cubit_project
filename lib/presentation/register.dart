import 'package:firebase_cubit_project/util/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/module.dart';
import '../logic/auth/auth_cubit.dart';
import '../logic/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                child: Text('Register'),
                onPressed: () => _register('marwax@gmail.com', '123456'),
              ),
              SizedBox(
                height: 120,
              ),
              TextButton(
                child: Text("Already have account? Login Now"),
                onPressed: () {
                  context.navigateTo("/login");
                },
              ),
            ],
          ),
        );
      }
    }));
  }

  _register(String email, String password) {
    getIt<AuthCubit>().register(email, password);
  }
}
