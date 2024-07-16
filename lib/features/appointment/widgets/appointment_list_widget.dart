import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_management/model/appointment_model.dart';
import 'package:schedule_management/service/appointment_service.dart';

class AppointmentListWidget extends StatefulWidget {
  final String userId;

  AppointmentListWidget({required this.userId});

  @override
  _AppointmentListWidgetState createState() => _AppointmentListWidgetState();
}

class _AppointmentListWidgetState extends State<AppointmentListWidget> {
  late Future<List<Appointment>> _appointmentsFuture;
  final AppointmentService _appointmentService = AppointmentService();

  @override
  void initState() {
    super.initState();
    _appointmentsFuture =
        _appointmentService.getUserAppointments(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: _appointmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No appointments found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final appointment = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Dr. ${appointment.doctor.name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Specialty: ${appointment.doctor.specialty}'),
                      Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(appointment.startTime)}'),
                      Text(
                          'Time: ${DateFormat('HH:mm').format(appointment.startTime)} - ${DateFormat('HH:mm').format(appointment.endTime)}'),
                      Text('Status: ${appointment.status}'),
                    ],
                  ),
                  trailing: Icon(
                    appointment.status == 'Confirmed'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: appointment.status == 'Confirmed'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
