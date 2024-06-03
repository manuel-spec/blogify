import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      scrollDirection: Axis.vertical,
      children: [
        Column(
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
        )
      ],
    ));
  }
}
