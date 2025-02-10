// ignore_for_file: library_private_types_in_public_api

import 'package:example/screen/home.dart';
import 'package:example/screen/signup.dart';
import 'package:flutter/material.dart';
import 'package:getx/getx.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          MaterialButton(
            minWidth: Get.width / 2,
            height: 56,
            color: context.theme.colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              Get.off(() => Home());
            },
            child: AnimationExtension(Text(
              'Login',
              style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 14.sp),
            )).rotate(begin: 0, end: 6.3),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text.rich(
                TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(fontSize: 10.sp),
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => SignUp());
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline, // Optional underline for emphasis
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).paddingOnly(
                left: context.mediaQuery.size.width * 0.24,
              ),
            ],
          ),
          SizedBox(height: 20),
          MaterialButton(
            minWidth: Get.width / 2,
            height: 56,
            color: context.theme.colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              Get.showSnackbar(
                GetSnackBar(
                  title: 'Error',
                  message: 'Internet connection failed.',
                  icon: Icon(Icons.error, color: Colors.red),
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(20.0),
                  mainButton: TextButton(
                    child: Text('Retry', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // Perform operation to reconnect
                      Get.back(); // Close the snackbar
                    },
                  ),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.grey[800]!,
                ),
              );
            },
            child: Text('Sanakbar'),
          ),
        ],
      ).paddingAll(20.0),
    );
  }
}
