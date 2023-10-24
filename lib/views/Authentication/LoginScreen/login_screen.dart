import 'package:firebase_ecommerce_app/global_widgets/custom_button.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:firebase_ecommerce_app/helpers/form_helper.dart';
import 'package:firebase_ecommerce_app/utils/colors.dart';
import 'package:firebase_ecommerce_app/views/Authentication/RegisterScreen/register_screen.dart';
import 'package:firebase_ecommerce_app/views/BottomNavBarView/bottom_view.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      'Login here',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const Text(
                      "Welcome back you've\nbeen missed!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                Column(
                  children: [
                    const CustomTextField(
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: 'Password',
                      secured: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {}
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      buttonTitle: 'Login',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BottomBarScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Create new account',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
