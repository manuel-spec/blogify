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
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: const Text(
                    "Hey User Let's",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 70, 62, 62),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: const Text(
                    "Find you a post",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200),
                  ),
                ),
              ],
            ),
            Container(
              // padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              width: 300,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search for Blogs',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.grey, // Default border color
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.blue, // Enabled border color
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.grey, // Focused border color
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.red, // Error border color
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.red, // Focused error border color
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(
                      10, 20, 0, 0), // Adjust margin as needed
                  padding: const EdgeInsets.fromLTRB(
                      10, 5, 10, 5), // Adjust padding as needed
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 1.0, // Border width
                    ),
                    color: Color.fromARGB(255, 49, 49, 51),
                    borderRadius: BorderRadius.circular(30.0), // Border radius
                  ),
                  child: const Center(
                    child: Text(
                      "Top rated",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 253, 253, 253),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: const Text(
                    "Popular",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 70, 62, 62),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  width: 318,
                  height: 317,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 241, 242, 244),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                    child: const Column(
                      children: [
                        Text(
                          "Inner Thoughts",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(50, 10, 0, 0),
                  child: Text("1500"),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                  child: Text(
                    "by user21221",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                )
              ],
            )
          ],
        )
      ],
    ));
  }
}
