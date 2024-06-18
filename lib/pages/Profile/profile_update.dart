import 'package:blogify/Services/utils.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  String name = '';
  String username = '';
  String email = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInformation();
  }

  void _fetchUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String id = prefs.getInt('id').toString();

    var url = '$userUrl/$id';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = json.decode(response.body);
      setState(() {
        name = res['user']['name'];
        username = res['user']['username'];
        email = res['user']['email'];
      });
      // Set initial values for text form fields
      nameController.text = name;
      usernameController.text = username;
      emailController.text = email;
    } else {
      print(response.body);
      throw Exception('Failed to load user information');
    }
  }

  void _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String id = prefs.getInt('id').toString();

    final Map<String, String> body = {
      'name': nameController.text,
      'username': usernameController.text,
      'email': emailController.text,
    };

    var url = '$userUrl/$id';
    final response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);

    if (response.statusCode == 200) {
      // Update successful
      // Handle success accordingly (e.g., show a success message)
    } else {
      // Update failed
      // Handle failure accordingly (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), // Replace with your profile image URL
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '@$username',
                  style: TextStyle(
                    fontSize: 18,
                    // color: Colors.white70,
                  ),
                ),
              ),
              Text('Name'),
              TextFormField(
                controller: nameController,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Username'),
              TextFormField(
                controller: usernameController,
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Email'),
              TextFormField(
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
