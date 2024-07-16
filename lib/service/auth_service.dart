import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_management/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
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

  static const String loginUrl = "http://10.0.2.2:3000/api/u/login";

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 0) {
        User user = User.fromJson(responseBody['data']['user']);
        await saveUser(user);
        return responseBody;
      } else {
        throw Exception(responseBody['msg']);
      }
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('phone', user.phone);
    await prefs.setString('email', user.email);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('_id');
    String? name = prefs.getString('name');
    String? phone = prefs.getString('phone');
    String? email = prefs.getString('email');

    if (id != null && name != null && phone != null && email != null) {
      return User(
        id: id,
        name: name,
        phone: phone,
        email: email,
        password: '',
        dateOfBirth: '',
      );
    }
    return null;
  }

  static const String profileUrl = "http://10.0.2.2:3000/api/u";

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    final response = await http.get(Uri.parse('$profileUrl/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String userId, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$profileUrl/updateUser/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> updatedUserData = jsonDecode(response.body)['data'];
      await saveUser(User.fromJson(updatedUserData));

      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user');
    }
  }
}
