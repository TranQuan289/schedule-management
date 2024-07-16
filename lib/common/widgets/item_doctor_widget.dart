import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/model/doctor_model.dart';
import 'package:schedule_management/utils/color_utils.dart';

class ItemDoctorWidget extends StatelessWidget {
  final Doctor doctor;
  final void Function(DateTime start, DateTime end)? onBookAppointment;

  const ItemDoctorWidget({
    required this.doctor,
    this.onBookAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorUtils.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doctor.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            doctor.specialty,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorUtils.textColor,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Icon(Icons.phone, size: 20.sp, color: ColorUtils.textColor),
              SizedBox(width: 5.w),
              Text(
                doctor.phone,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorUtils.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Icon(Icons.email, size: 20.sp, color: ColorUtils.textColor),
              SizedBox(width: 5.w),
              Text(
                doctor.email,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorUtils.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 20.sp, color: ColorUtils.textColor),
              SizedBox(width: 5.w),
              Text(
                '${doctor.startTime} - ${doctor.endTime}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorUtils.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () {
              _showDateTimePicker(context);
            },
            child: Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (selectedDate != null) {
      TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (startTime != null) {
        DateTime startDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          startTime.hour,
          startTime.minute,
        );
        TimeOfDay? endTime = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute),
        );

        if (endTime != null) {
          DateTime endDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            endTime.hour,
            endTime.minute,
          );

          if (endDateTime.isAfter(startDateTime)) {
            if (onBookAppointment != null) {
              onBookAppointment!(startDateTime, endDateTime);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Thời gian kết thúc phải sau thời gian bắt đầu'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }
}
