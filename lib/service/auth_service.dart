import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_management/model/user_model.dart';
import 'package:schedule_management/service/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String baseUrl = "${Config.base}/api/u/register";

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
      throw Exception('Không thể đăng ký người dùng');
    }
  }

  static String loginUrl = "${Config.base}/api/u/login";

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
      if (responseBody['status'] == 1) {
        User user = User.fromJson(responseBody['data']['user']);
        await saveUser(user);
        return responseBody;
      } else {
        throw Exception(responseBody['msg']);
      }
    } else {
      throw Exception('Không thể đăng nhập người dùng');
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

  static String profileUrl = "${Config.base}/api/u";

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    final response = await http.get(Uri.parse('$profileUrl/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Không thể tải thông tin người dùng');
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
      throw Exception('Không thể cập nhật thông tin người dùng');
    }
  }

  static String deleteUrl = "${Config.base}/api/u/delete";

  Future<Map<String, dynamic>> deleteUser(
      String userId, String password) async {
    final response = await http.post(
      Uri.parse('$deleteUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể xóa người dùng');
    }
  }
}
