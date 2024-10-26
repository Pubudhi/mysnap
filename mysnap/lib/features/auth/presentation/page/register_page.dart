/*
Story: 
User can: register with name, email and pw. 
when:successful registration user redirected to home page. 
else: exixting users nevigates to login 

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/presentation/component/my_button.dart';
import 'package:mysnap/features/auth/presentation/component/my_textfield.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../responsive/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    // prepare info
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();

    //fields empty check

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        name.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      // password and confirm passowrd check
      if (password == confirmPassword) {
        authCubit.register(email, password, name);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Passwords do not match. Please ensure both passwords are the same.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all fields")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

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

                // create an acc msg
                Text(
                  "Let's create an account",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                // name field
                MyTextfield(
                    controller: nameController,
                    hintText: "Name",
                    obscureText: false),

                const SizedBox(
                  height: 10,
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
                  height: 10,
                ),

                //password field
                MyTextfield(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true),

                const SizedBox(
                  height: 25,
                ),

                // register btn
                MyButton(onTap: register, text: "Register"),

                const SizedBox(
                  height: 25,
                ),

                //existing user redirect to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text("Login now.",
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
