import 'dart:convert';

import 'package:blogify/Models/apiResponse.dart';
import 'package:blogify/Models/userModel.dart';
import 'package:blogify/Services/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> getBlogs() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    final response = await http.get(Uri.parse(blogUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['blogs']
            .map((b) => Blog.fromJson(b))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = "Unauthorized";
        break;
      default:
        apiResponse.error = "Something went wrong.";
        break;
    }
  } catch (e) {
    apiResponse.error = "Internal Server Error.";
  }
  return apiResponse;
}

Future<ApiResponse> createBlog(Blog blog) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    int userId = prefs.getInt("id")!;

    final Map<String, String> body = {
      'title': blog.title,
      'description': blog.description,
      'content': blog.content,
      'user_id': '$userId',
      'category_id': '${blog.categoryId}',
    };

    final response = await http.post(
      Uri.parse(blogUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = "Unauthorized";
        break;
      default:
        apiResponse.error = "Something went wrong.";
        break;
    }
  } catch (e) {
    apiResponse.error = "Internal Server Error.";
  }
  return apiResponse;
}

Future<ApiResponse> editBlog(int blogId, Blog blog) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    final response = await http.put(
      Uri.parse("$blogUrl/$blogId"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(blog),
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = "Unauthorized";
        break;
      default:
        apiResponse.error = "Something went wrong.";
        break;
    }
  } catch (e) {
    apiResponse.error = "Internal Server Error.";
  }
  return apiResponse;
}

Future<ApiResponse> deleteBlog(int blogId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    final response = await http.delete(Uri.parse("$blogUrl/$blogId"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = "Unauthorized";
        break;
      default:
        apiResponse.error = "Something went wrong.";
        break;
    }
  } catch (e) {
    apiResponse.error = "Internal Server Error.";
  }
  return apiResponse;
}

Future<ApiResponse> toggleLike(int blogId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    final response =
        await http.post(Uri.parse("$blogUrl/$blogId/likes"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = "Unauthorized";
        break;
      default:
        apiResponse.error = "Something went wrong.";
        break;
    }
  } catch (e) {
    apiResponse.error = "Internal Server Error.";
  }
  return apiResponse;
}
