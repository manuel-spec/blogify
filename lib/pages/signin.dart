import 'dart:convert';

import 'package:blogify/Models/userModel.dart';
import 'package:blogify/Services/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    final Map<String, String> body = {
      'email': _emailController.text,
      'password': _passwordController.text
    };

    final response = await http.post(
      Uri.parse(loginUrl),
      body: json.encode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final Map<String, dynamic> res = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", res['access_token']);
      prefs.setInt('id', res['user']['id']);
      prefs.setString('name', res['user']['name']);
      prefs.setString('username', res['user']['username']);
      prefs.setString('email', res['user']['email']);
      prefs.setBool('isLoggedIn', true);
      context.go('/home');
    } else {
      print(response.statusCode);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
        child: Text("Invalid Credentials"),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF03045E)),
                textAlign: TextAlign.left,
              ),
              const Text(
                'Back',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF03045E)),
                textAlign: TextAlign.start,
              ),
              Container(
                height: 100,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Color(0xFF03045E),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0xFF03045E),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFF03045E),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      _signIn();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 10),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    elevation: 3,
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(47),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Sign in'),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate to signup screen
                  context.go('/signup');
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                ),
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
