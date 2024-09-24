import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_demo/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateLogin();
  }

  _navigateLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            width: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.jpg'),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: BorderSide.strokeAlignOutside,
              ),
            ],
          )
        ],
      ),
    );
  }
}
