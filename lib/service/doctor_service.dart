import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_management/model/doctor_model.dart';

class DoctorService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/doctor';

  Future<List<Doctor>> getAllDoctors() async {
    final response = await http.get(Uri.parse('$baseUrl/getAll'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      return list.map((model) => Doctor.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<List<Doctor>> searchDoctorsByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/search/name/$name'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        List<dynamic> doctorsData = jsonResponse['data'];
        return doctorsData
            .map((doctorJson) => Doctor.fromJsonSearch(doctorJson))
            .toList();
      } else {
        throw Exception(jsonResponse['msg'] ?? 'Failed to search doctors');
      }
    } else {
      throw Exception('Failed to search doctors');
    }
  }
}
