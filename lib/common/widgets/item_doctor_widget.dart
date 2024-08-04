import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/model/doctor_model.dart';
import 'package:schedule_management/service/conversation_service.dart';
import 'package:schedule_management/utils/color_utils.dart';

class ItemDoctorWidget extends HookWidget {
  final Doctor doctor;
  final String idUser;
  final void Function(DateTime start, DateTime end)? onBookAppointment;

  const ItemDoctorWidget({
    required this.doctor,
    required this.idUser,
    this.onBookAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final conversationService = useMemoized(() {
      final service = ConversationService();
      service.initSocket(idUser);
      return service;
    });

    useEffect(() {
      return () {
        conversationService.dispose();
      };
    }, []);

    Future<void> _handleChat(BuildContext context) async {
      TextEditingController chatController = TextEditingController();
      bool isLoading = false;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Gửi Tin Nhắn'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: chatController,
                      decoration: const InputDecoration(
                        labelText: 'Tin Nhắn',
                      ),
                    ),
                    if (isLoading) const CircularProgressIndicator(),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Gửi'),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      Navigator.of(context).pop();
                      try {
                        conversationService.sendMessage(
                            doctor.id, chatController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gửi tin nhắn thành công')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }

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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showDateTimePicker(context);
                  },
                  child: Text('Đặt lịch'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _handleChat(context);
                  },
                  child: Text('Nhắn tin'),
                ),
              ),
            ],
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
