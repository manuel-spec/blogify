import 'dart:convert';

import 'package:blogify/Models/userModel.dart';
import 'package:blogify/Models/apiResponse.dart';
import 'package:blogify/pages/Home/all_comments.dart';
import 'package:blogify/Services/blogService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class BlogsWidget extends StatefulWidget {
  const BlogsWidget({super.key});

  @override
  State<BlogsWidget> createState() => _BlogsWidgetState();
}

class _BlogsWidgetState extends State<BlogsWidget> {
  Future<List<Blog>> _getPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    print(token);

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
      print(response.body);
      throw Exception('Failed to load blogs');
    }
  }

	void _handleLikes(int blogId) async {
		ApiResponse response = await toggleLike(blogId);

		if (response.error == null) {
			setState(() {
				_getPosts();
			});
		} else {
			ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  height: 800,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            blog.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            blog.description,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            blog.content,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'Author: ${blog.user.name}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Username: @${blog.user.username}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
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
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
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
                    ),
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: Row(
															mainAxisAlignment: MainAxisAlignment.center,
															children: [
																IconButton(
																	onPressed: () {
																		_handleLikes(blog.id ?? 0);
																	},
																	icon: blog.likesCount > 0 ? Icon(Ionicons.heart) : Icon(Ionicons.heart_outline),
																	color: blog.likesCount > 0 ? Colors.red : Color.fromARGB(255, 220, 220, 220),
																),
																Text('${blog.likesCount}'),
															],
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: IconButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt("blog_id", blog.id);
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          height: 1000,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text(
                                                  "Comments",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              AllComments(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.message_outlined),
                              color: Color.fromARGB(255, 220, 220, 220),
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                            child: IconButton(
                              onPressed: () {
                                print("share");
                              },
                              icon: Icon(Icons.share),
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
