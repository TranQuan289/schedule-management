import 'package:schedule_management/model/doctor_model.dart';
import 'package:schedule_management/model/user_model.dart';

class Appointment {
  final String id;
  final Doctor doctor;
  final User user;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  Appointment({
    required this.id,
    required this.doctor,
    required this.user,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'],
      doctor: Doctor.fromJsonSearch(json['doctor_id']),
      user: User.fromJson(json['user_id']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
    );
  }
}
