import 'dart:convert';

import 'package:blogify/pages/Profile/profile_info.dart';
import 'package:blogify/pages/Profile/profile_update.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Profile(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0, // Remove the default AppBar height
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Profile",
              ),
              Tab(
                text: "Update",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProfileInfo(),
            ProfileUpdate(),
          ],
        ),
      ),
    );
  }
}
