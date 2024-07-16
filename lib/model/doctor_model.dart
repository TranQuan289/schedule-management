class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String startTime;
  final String endTime;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    required this.startTime,
    required this.endTime,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'],
      name: json['name'],
      specialty: json['specialty'],
      phone: json['phone'],
      email: json['email'],
      startTime: json['working_hours']['start_time'],
      endTime: json['working_hours']['end_time'],
    );
  }
   factory Doctor.fromJsonSearch(Map<String, dynamic> json) {
    var workingHours = json['working_hours'] as List;
    var firstWorkingHour = workingHours.isNotEmpty ? workingHours[0] : null;

    return Doctor(
      id: json['_id'],
      name: json['name'],
      specialty: json['specialty'],
      phone: json['phone'],
      email: json['email'],
      startTime: firstWorkingHour != null ? firstWorkingHour['start_time'] : '',
      endTime: firstWorkingHour != null ? firstWorkingHour['end_time'] : '',
    );
  }
}
