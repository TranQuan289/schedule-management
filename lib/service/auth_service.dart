import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_management/model/user_model.dart';

class UserService {
  static const String baseUrl = "http://10.0.2.2:3000/api/u/register";

  Future<Map<String, dynamic>> registerUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }
}
