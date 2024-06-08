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
    int blogId = prefs.getInt('blog_id')!;

    final response = await http.post(
      Uri.parse('http://192.168.201.112:9000/api/comments/get/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'blog_id':
            '$blogId', // Assuming you want comments for blog ID 1, change as needed
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      // If the server returns a 200 OK response, parse the JSON
      return jsonDecode(response.body);
    } else {
      print(response.body);
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load comments');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComments = fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Wrap with SizedBox to provide bounded height
      height:
          MediaQuery.of(context).size.height * 0.6, // Set the height as needed
      child: FutureBuilder<List<dynamic>>(
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
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(comment['content']),
                  subtitle: Text('Commented by: '),
                );
              },
            );
          }
        },
      ),
    );
  }
}
