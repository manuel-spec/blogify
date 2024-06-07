import 'dart:convert';

import 'package:blogify/Models/userModel.dart';
import 'package:blogify/pages/Home/blogs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
                text: "For You",
              ),
              Tab(
                text: "Mine",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BlogsWidget(),
            Text("text2"),
          ],
        ),
      ),
    );
  }
}
