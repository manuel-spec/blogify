import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  void _getPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    var url = "http://10.240.69.35:9000/api/blogs";
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> res = json.decode(response.body);
    print(res['blogs'][0]);
  }

  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
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
                            child: Text("User243435"),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Text("@user2044"),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                softWrap: true,
                                maxLines: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          width: 290,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 144, 224, 239),
                          ),
                        )
                      ],
                    ),
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
            )
          ],
        ));
  }
}
