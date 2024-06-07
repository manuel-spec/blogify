import 'dart:convert';

import 'package:blogify/Models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class MyBlogsWidget extends StatefulWidget {
  const MyBlogsWidget({super.key});

  @override
  State<MyBlogsWidget> createState() => _MyBlogsWidgetState();
}

class _MyBlogsWidgetState extends State<MyBlogsWidget> {
  Future<List<Blog>> _getPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    String id = prefs.getInt('id').toString();

    var url = "http://192.168.201.112:9000/api/blogs/my/$id";
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      // print(json);
      return json.map((data) => Blog.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  void _updateBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    String id = prefs.getInt('id').toString();

    var url = "http://192.168.201.112:9000/api/blogs/";
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
                              child: Text(
                                blog.user.name,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Text("@" + blog.user.username),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 100),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          height: 500,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Edit Blog",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                initialValue: blog.title,
                                                decoration: InputDecoration(
                                                  labelText: 'Title',
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black26),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .lightBlueAccent),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                initialValue: blog.description,
                                                decoration: InputDecoration(
                                                  labelText: 'Description',
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black26),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .lightBlueAccent),
                                                  ),
                                                ),
                                                maxLines: 3,
                                              ),
                                              SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Add your update logic here
                                                  _updateBlog(
                                                      blog.id,
                                                      blog.title,
                                                      blog.description,
                                                      blog.content);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Update"),
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 16),
                                                  textStyle:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
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
                              Ionicons.heart_outline,
                              color: Color.fromARGB(255, 220, 220, 220),
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: Icon(
                              Icons.message_outlined,
                              color: Color.fromARGB(255, 220, 220, 220),
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: Icon(
                              Icons.share,
                              color: Color.fromARGB(255, 220, 220, 220),
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
