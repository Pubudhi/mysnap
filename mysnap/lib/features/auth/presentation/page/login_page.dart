/*
Story: 
User can: login with email and pw. 
when:successful login user redirected to home page. 
else: prospective users nevigates to register 

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/presentation/component/my_button.dart';
import 'package:mysnap/features/auth/presentation/component/my_textfield.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../responsive/constrained_scaffold.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// login fuction executes login btn
  void login() {
    final String email = emailController.text;
    final String password = passwordController.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();
    // null check
    if (email.isNotEmpty && password.isNotEmpty) {
      //login
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid username or password. Please try again.')));
    }
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //build UI
  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      //body
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //primary logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(
                  height: 50,
                ),

                // welcome msg
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                // email field
                MyTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false),

                const SizedBox(
                  height: 10,
                ),

                //password field
                MyTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true),

                const SizedBox(
                  height: 25,
                ),

                // login btn
                MyButton(onTap: login, text: "Login"),

                const SizedBox(
                  height: 25,
                ),

                //redirect to register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text("Register now.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
