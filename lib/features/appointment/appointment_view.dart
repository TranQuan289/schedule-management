import 'package:flutter/material.dart';
import 'package:schedule_management/features/appointment/widgets/appointment_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch Hẹn Của Tôi'),
      ),
      body: FutureBuilder<String?>(
        future: _getUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Lỗi: Không thể lấy được ID người dùng'));
          } else {
            return AppointmentListWidget(userId: snapshot.data!);
          }
        },
      ),
    );
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('_id');
  }
}
