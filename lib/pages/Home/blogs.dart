import 'dart:convert';

import 'package:blogify/Models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BlogsWidget extends StatefulWidget {
  const BlogsWidget({super.key});

  @override
  State<BlogsWidget> createState() => _BlogsWidgetState();
}

class _BlogsWidgetState extends State<BlogsWidget> {
  Future<List<Blog>> _getPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    var url = "http://192.168.201.112:9000/api/blogs";
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['blogs'];
      // print(json);
      return json.map((data) => Blog.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Blog>>(
      future: _getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color.fromARGB(255, 144, 224, 239),
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No blogs found'));
        } else {
          final blogs = snapshot.data!;
          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return Container(
                // margin: EdgeInsets.symmetric(vertical: 40),
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                              ),
                            ),
                            Container(
                              child: Text(blog.user.name),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Text("@" + blog.user.username),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  blog.title,
                                  softWrap: true,
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 6),
                                child: Text(
                                  blog.description,
                                  softWrap: true,
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: Icon(
                              Icons.thumb_up_alt,
                              color: Color.fromARGB(255, 0, 119, 182),
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: Icon(
                              Icons.message,
                              color: Color.fromARGB(255, 0, 119, 182),
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: Icon(
                              Icons.share,
                              color: Color.fromARGB(255, 0, 119, 182),
                            )),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
