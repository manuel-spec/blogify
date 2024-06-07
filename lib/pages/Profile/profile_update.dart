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

  void _fetchUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String id = prefs.getInt('id').toString();

    var url = 'http://192.168.201.112:9000/api/users/$id';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = json.decode(response.body);
      print(res['user']);
      setState(() {
        name = res['user']['name'];
        username = res['user']['username'];
        email = res['user']['email'];
      });
    } else {
      print(response.body);
      throw Exception('Failed to load user information');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserInformation();
  }

  void _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String id = prefs.getInt('id').toString();

    var url = 'http://192.168.201.112:9000/api/users/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'username': username,
        'email': email,
      }),
    );

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
      body: Padding(
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
              initialValue: name.toString(),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Username'),
            TextFormField(
              initialValue: username,
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Email'),
            TextFormField(
              initialValue: email,
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
    );
  }
}
