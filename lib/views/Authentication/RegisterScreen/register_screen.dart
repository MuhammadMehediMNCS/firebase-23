import 'package:firebase_ecommerce_app/global_widgets/custom_button.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:firebase_ecommerce_app/helpers/form_helper.dart';
import 'package:firebase_ecommerce_app/views/Authentication/LoginScreen/login_screen.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                Column(
                  children: [
                    const CustomTextField(hintText: 'Email'),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: 'Password',
                      secured: true,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: 'Confirm Password',
                      secured: true,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CustomButton(buttonTitle: 'Sign Up'),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
