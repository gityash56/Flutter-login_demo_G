import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<Map<String, String>> _getCredentials() async {
    await Future(
      () {
        const Duration(seconds: 3);
      },
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String firstName = prefs.getString('firstName') ?? '';
    final String lastName = prefs.getString('lastName') ?? '';
    final String gender = prefs.getString('gender') ?? '';
    final String email = prefs.getString('email') ?? '';
    final String password = prefs.getString('password') ?? '';
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'email': email,
      'password': password,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder<Map<String, String>>(
          future: _getCredentials(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading credentials'));
            } else {
              final credentials = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('FirstName: ${credentials['firstName']}'),
                      const SizedBox(height: 10),
                      Text('LastName: ${credentials['lastName']}'),
                      const SizedBox(height: 10),
                      Text('Gender: ${credentials['gender']}'),
                      const SizedBox(height: 10),
                      Text('Email: ${credentials['email']}'),
                      const SizedBox(height: 10),
                      Text('Password: ${credentials['password']}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _logout(context),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
