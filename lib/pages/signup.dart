import 'dart:convert';
import 'package:blogify/Services/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();

    super.dispose();
  }

  bool _isLoading = false;

  void _signUp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final Map<String, String> body = {
      'name': _fullNameController.text,
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text
    };

    final response = await http.post(
      Uri.parse(registerUrl),
      body: json.encode(body),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    final Map<String, dynamic> res = json.decode(response.body);

    if (response.statusCode == 201) {
      preferences.setString("token", res['access_token']);
      preferences.setInt('id', res['user']['id']);
      preferences.setString('name', res['user']['name']);
      preferences.setString('username', res['user']['username']);
      preferences.setString('email', res['user']['email']);

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
      print(response.body);
    } else {
      print(response.body);
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
        color: Color(0xFF1A1A2E),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Let\'s Get',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE94560)),
                textAlign: TextAlign.left,
              ),
              const Text(
                'Started',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFE94560),
                ),
                textAlign: TextAlign.start,
              ),
              Container(
                height: 20,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE94560)),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF16213E),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE94560)),
                  ),
                  prefixIcon: Icon(Icons.mail, color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF16213E),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE94560)),
                  ),
                  prefixIcon: Icon(Icons.mail, color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF16213E),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE94560)),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF16213E),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
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
                    Future.delayed(Duration(seconds: 3), () {
                      _signUp();
                    });
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Sign up'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 10),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    elevation: 3,
                    backgroundColor: const Color(0xFFE94560),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(47),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.go('/signin');
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xFFE94560)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                ),
                child: Text('Already have an account? Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
