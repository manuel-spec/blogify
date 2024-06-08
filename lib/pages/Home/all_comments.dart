import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllComments extends StatefulWidget {
  const AllComments({Key? key}) : super(key: key);

  @override
  State<AllComments> createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  late Future<List<dynamic>> _fetchComments;

  Future<List<dynamic>> fetchComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    int? blogId = prefs.getInt('blog_id');

    if (blogId == null) {
      throw Exception('Blog ID not found in shared preferences');
    }

    final response = await http.post(
      Uri.parse('http://192.168.201.112:9000/api/comments/get/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'blog_id': blogId, // Use the correct blogId
      }),
    );

    if (response.statusCode == 200) {
      // Parse the JSON
      return jsonDecode(response.body);
    } else {
      // Handle errors
      throw Exception('Failed to load comments');
    }
  }

  Future<String> fetchUserInfo(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    final response = await http.get(
      Uri.parse('http://192.168.201.112:9000/api/users/$uid'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      print(user);

      // Return the user's name
      return user['user']['username'];
    } else {
      throw Exception('Failed to load user information');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComments = fetchComments();
  }

  void _postComment() async {
    print("here");
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    int? blogId = prefs.getInt('blog_id');

    if (token == null || blogId == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blog ID or token not found')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.201.112:9000/api/comments/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'content': _commentController.text,
        'blog_id': blogId.toString(),
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment posted successfully!')),
      );
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment')),
      );
    }
  }

  bool _isLoading = false;
  TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Wrap with SizedBox to provide bounded height
      height:
          MediaQuery.of(context).size.height * 0.6, // Set the height as needed
      child: Column(children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Your Comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 8.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _postComment,
                      child: Text('Post Comment'),
                    ),
            ],
          ),
        ),
        FutureBuilder<List<dynamic>>(
          future: _fetchComments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No comments found'));
            } else {
              final comments = snapshot.data!;
              return Column(children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          subtitle: FutureBuilder<String>(
                            future:
                                fetchUserInfo(comment['user_id'].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Row(
                                  children: [CircularProgressIndicator()],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(snapshot.data ?? 'Unknown user');
                              }
                            },
                          ),
                          title: Text(comment['content']),
                        );
                      },
                    ),
                  ),
                ),
              ]);
            }
          },
        ),
      ]),
    );
  }
}
