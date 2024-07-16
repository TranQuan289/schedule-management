import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/common/widgets/item_doctor_widget.dart';
import 'package:schedule_management/common/widgets/search_form_field.dart';
import 'package:schedule_management/model/doctor_model.dart';
import 'package:schedule_management/service/doctor_service.dart';
import 'package:schedule_management/service/appointment_service.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late List<Doctor> _searchResults = [];
  bool _isLoading = false;
  final AppointmentService appointmentService = AppointmentService();

  void _searchDoctors(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Doctor> results = await DoctorService().searchDoctorsByName(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
      print('Error searching doctors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Search',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            SearchFormField(
              prefixIcon: Icon(Icons.search),
              onChanged: _searchDoctors,
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? Center(child: Text('No results found'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return ItemDoctorWidget(
                              doctor: _searchResults[index],
                              onBookAppointment: (start, end) =>
                                  _bookAppointment(context,
                                      _searchResults[index], start, end),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _bookAppointment(
      BuildContext context, Doctor doctor, DateTime start, DateTime end) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('_id');
      await appointmentService.bookAppointment(
        doctorId: doctor.id,
        userId: id ?? "",
        startTime: start,
        endTime: end,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment booked successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
