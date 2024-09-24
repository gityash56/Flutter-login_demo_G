import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:login_demo/screens/signup_screen.dart';
import '../widget/text_formfild.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail == _emailController.text &&
        savedPassword == _passwordController.text) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);

      await prefs.setBool('isLoggedIn', true);

      // Navigate to dashboard if email and password match
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${prefs.getString('firstName')} Success.!')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else if (_emailController.text != savedEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email does not match')),
      );
      return;
    } else if (_passwordController.text != savedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password does not match')),
      );
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login Page',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Email',
                    suffixIcon: const Icon(Icons.email_outlined),
                    controller: _emailController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    textInputAction: TextInputAction.done,
                    labelText: 'Password',
                    controller: _passwordController,
                    obscureText: passwordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process data
                        _login();
                        print('Email: ${_emailController.text}');
                        print('Password: ${_passwordController.text}');
                      }
                    },
                    // onPressed: _login,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account.?'),
                      const SizedBox(width: 1),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
