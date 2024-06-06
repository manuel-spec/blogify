import 'dart:convert';

import 'package:blogify/Models/apiResponse.dart';
import 'package:blogify/Models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> toggleLike(int blogId) async {
	ApiResponse apiResponse = ApiResponse();
	try {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		String token = prefs.getString("token")!;

		var url = "http://127.0.0.1:8000/api/blogs/$blogId/likes";
		final response = await http.post(
		Uri.parse(url),
		headers: {
			'Accept': 'application/json',
			'Authorization': 'Bearer $token',
			}
		);

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

