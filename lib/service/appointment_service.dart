import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_management/model/appointment_model.dart';
import 'package:schedule_management/service/config.dart';

class AppointmentService {
  final String baseUrl = '${Config.base}/api';

  Future<void> bookAppointment({
    required String doctorId,
    required String userId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final url = Uri.parse('$baseUrl/appointment/addAppointment');
    final formattedStartTime = startTime.toIso8601String();
    final formattedEndTime = endTime.toIso8601String();

    final body = jsonEncode({
      'doctor_id': doctorId,
      'user_id': userId,
      'start_time': formattedStartTime,
      'end_time': formattedEndTime,
    });

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 0) {
        throw Exception(responseData['msg']);
      }
    } else {
      throw Exception('Không thể đặt lịch hẹn');
    }
  }

  Future<List<Appointment>> getUserAppointments(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/appointment/u/$userId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 1) {
        final List<dynamic> appointmentsJson = jsonData['data'];
        return appointmentsJson
            .map((json) => Appointment.fromJson(json))
            .toList();
      } else {
        throw Exception(jsonData['msg']);
      }
    } else {
      throw Exception('Không thể tải lịch hẹn');
    }
  }
}
