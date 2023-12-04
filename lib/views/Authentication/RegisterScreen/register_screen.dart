import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_button.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:firebase_ecommerce_app/helpers/form_helper.dart';
import 'package:firebase_ecommerce_app/utils/config.dart';
import 'package:firebase_ecommerce_app/views/Authentication/LoginScreen/login_screen.dart';
import 'package:firebase_ecommerce_app/views/BottomNavBarView/bottom_view.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'Create an account so you can explore all the existing jobs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        isRequired: true,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        secured: obscureText,
                        suffixIcon: obscureText == true
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = false;
                              });
                            },
                            icon: const Icon(Icons.visibility),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = true;
                              });
                            },
                            icon: const Icon(Icons.visibility_off),
                          ),
                        isRequired: true,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: _confirmController,
                        hintText: 'Confirm Password',
                        secured: obscureText,
                        suffixIcon: obscureText == true
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = false;
                              });
                            },
                            icon: const Icon(Icons.visibility),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = true;
                              });
                            },
                            icon: const Icon(Icons.visibility_off),
                          ),
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        buttonTitle: 'Sign Up',
                        onTap: () async {
                          final form = _formKey.currentState!;
                          final userData = await FirebaseFirestore.instance.collection('users').where(
                                            'email', isEqualTo: _emailController.text
                                          ).get();

                          if(form.validate()) {
                            if(_passwordController.text != _confirmController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The passwords are not same')));
                            } else {
                              try {
                                _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text
                                );
                                if(userData.docs.isEmpty) {
                                  await FirebaseFirestore.instance.collection('users').doc(_emailController.text).set({
                                    'email': _emailController.text,
                                    'password': _passwordController.text,
                                    'balance': 0,
                                    'varified': true,
                                    'name': AppConfig.appName
                                  });
                                } else {
                                  await FirebaseFirestore.instance.collection('users').doc(_emailController.text).update({
                                    'email': _emailController.text,
                                    'password': _passwordController.text,
                                    'balance': 12,
                                    'varified': true,
                                    'name': 'Updated Name'
                                  });
                                }
                                
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomBarScreen()), (route) => false);
                              } catch(e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Already Have An Account',
                          style:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 16
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
