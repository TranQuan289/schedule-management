import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schedule_management/common/widgets/text_button_widget.dart';
import 'package:schedule_management/features/appointment/appointment_view.dart';
import 'package:schedule_management/features/profile/profile_detail_view.dart';
import 'package:schedule_management/features/profile/widgets/button_settings_widget.dart';
import 'package:schedule_management/model/user_model.dart';
import 'package:schedule_management/service/auth_service.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'package:schedule_management/utils/routes/routes.dart';

class ProfileView extends HookWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = useMemoized(() => AuthService());
    final user = useState<User?>(null);

    useEffect(() {
      _loadUser(authService, user);
      return null;
    }, []);

    Future<void> _handleUpdateUser() async {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileDetailView(
            userId: user.value!.id,
          ),
        ),
      );
      if (result == true) {
        await _loadUser(authService, user);
      }
    }

    return Scaffold(
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Profile',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: user.value != null
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          ColorUtils.blueColor,
                          ColorUtils.blueMiddleColor,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20.r),
                          width: 55.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.whiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/ic_user_account.svg',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              user.value!.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorUtils.whiteColor,
                                fontSize: 16.sp,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.value!.email,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorUtils.whiteColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ButtonSettingsWidget(
                    icon: SvgPicture.asset(
                      'assets/icons/ic_user_account.svg',
                    ),
                    title: 'Account profile',
                    onPressed: _handleUpdateUser,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: ColorUtils.textColor,
                  ),
                  ButtonSettingsWidget(
                    icon: SvgPicture.asset(
                      'assets/icons/ic_calender.svg',
                    ),
                    title: 'My Appointments',
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentsView(),
                        ),
                      )
                    },
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: ColorUtils.textColor,
                  ),
                  ButtonSettingsWidget(
                    icon: SvgPicture.asset(
                      'assets/icons/ic_delete.svg',
                    ),
                    title: 'Delete Account',
                    onPressed: () => {},
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  TextButtonWidget(
                    label: 'Logout',
                    onPressed: () => Routes.goToSignInScreen(context),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _loadUser(
      AuthService authService, ValueNotifier<User?> user) async {
    User? loadedUser = await authService.getUser();
    user.value = loadedUser;
  }
}
