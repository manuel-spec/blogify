import 'package:blogify/Models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

const baseUrl = "http://192.168.201.112:9000";

const blogUrl = "$baseUrl/api/blogs";
const commentsUrl = "$baseUrl/comments";

const userUrl = "$baseUrl/api/users";
const registerUrl = "$baseUrl/api/register";
const loginUrl = "$baseUrl/api/login";

List<Widget> likeButton(Blog blog, likeHandler) {
	return [
		IconButton(
			onPressed: () {
				likeHandler(blog.id ?? 0);
			},
			icon: blog.likesCount > 0 ? Icon(Ionicons.heart) : Icon(Ionicons.heart_outline),
			color: blog.likesCount > 0 ? Colors.red : Color.fromARGB(255, 220, 220, 220),
		),
		Text('${blog.likesCount}'),
	];
}
