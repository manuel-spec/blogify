import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  String name = "";
  String username = "";
  String bio = "";

  void _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    context.go('/profile');
  }

  void _fetchUserInformation() async {
    // Fetch user information from the server http://192.168.201.112:9000/api/users/:id

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    String id = prefs.getInt('id').toString();

    var url = "http://192.168.201.112:9000/api/users/$id";
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
      });

      print(res['user']);
    } else {
      print(response.body);
      throw Exception('Failed to load blogs');
    }
  }

  void initState() {
    super.initState();
    _fetchUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
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
                SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _logout,
                    child: Text('logout'),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
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
