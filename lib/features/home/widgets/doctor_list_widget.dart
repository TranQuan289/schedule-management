import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:schedule_management/common/widgets/item_doctor_widget.dart';
import 'package:schedule_management/features/home/doctor_detail_screen.dart';
import 'package:schedule_management/model/doctor_model.dart';
import 'package:schedule_management/service/appointment_service.dart';
import 'package:schedule_management/service/doctor_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorListWidget extends StatefulHookWidget {
  @override
  _DoctorListWidgetState createState() => _DoctorListWidgetState();
}

class _DoctorListWidgetState extends State<DoctorListWidget> {
  late Future<List<Doctor>> _doctorListFuture;
  final AppointmentService appointmentService = AppointmentService();
  late String id;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _doctorListFuture = DoctorService().getAllDoctors();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('_id') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: _doctorListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Doctor> doctors = snapshot.data!;
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              Doctor doctor = doctors[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailScreen(doctor: doctor),
                  ),
                ),
                child: ItemDoctorWidget(
                  idUser: id,
                  doctor: doctor,
                  onBookAppointment: (start, end) =>
                      _bookAppointment(context, doctor, start, end),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Lỗi: ${snapshot.error}'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _bookAppointment(
      BuildContext context, Doctor doctor, DateTime start, DateTime end) async {
    try {
      await appointmentService.bookAppointment(
        doctorId: doctor.id,
        userId: id,
        startTime: start,
        endTime: end,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đặt lịch hẹn thành công'),
          backgroundColor: Colors.grey,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.toString()}'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }
}
