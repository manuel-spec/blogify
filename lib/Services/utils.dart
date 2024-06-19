import 'package:blogify/Models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

const baseUrl = "http://192.168.231.6:9000/api";

const blogUrl = "$baseUrl/blogs";
const commentsUrl = "$baseUrl/comments";

const userUrl = "$baseUrl/users";
const registerUrl = "$baseUrl/register";
const loginUrl = "$baseUrl/login";

List<Widget> likeButton(Blog blog, likeHandler) {
  return [
    IconButton(
      onPressed: () {
        likeHandler(blog.id ?? 0);
      },
      icon: blog.likesCount > 0
          ? Icon(Ionicons.heart)
          : Icon(Ionicons.heart_outline),
      color:
          blog.likesCount > 0 ? Colors.red : Color.fromARGB(255, 220, 220, 220),
    ),
    Text('${blog.likesCount}'),
  ];
}
