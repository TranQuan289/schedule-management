import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/common/widgets/text_button_outline_widget.dart';
import 'package:schedule_management/common/widgets/text_button_widget.dart';
import 'package:schedule_management/utils/color_utils.dart';

class ItemDoctorWidget extends StatelessWidget {
  const ItemDoctorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        margin: EdgeInsets.only(
          right: 10.w,
          left: 10.w,
          top: 10.h,
          bottom: 30.h,
        ),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: ColorUtils.primaryColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/img_logo.png',
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "name",
                        style: TextStyle(
                          color: ColorUtils.primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'hihi',
                        style: TextStyle(
                          color: ColorUtils.primaryColor,
                          fontSize: 12.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 40.h,
                  width: 130.w,
                  child: TextButtonWidget(
                    onPressed: () => {},
                    label: 'View detail',
                  ),
                ),
                SizedBox(
                  height: 40.h,
                  width: 130.w,
                  child: const TextButtonOutlineWidget(
                    label: 'Booking',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}
