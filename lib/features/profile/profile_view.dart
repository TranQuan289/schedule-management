import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schedule_management/common/base_state_delegate/base_state_delegate.dart';
import 'package:schedule_management/common/widgets/text_button_widget.dart';
import 'package:schedule_management/features/profile/notifier/profile_notifier.dart';
import 'package:schedule_management/features/profile/widgets/button_settings_widget.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'package:schedule_management/utils/routes/routes.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  BaseStateDelegate<ProfileView, ProfileNotifier> createState() =>
      _ProfileViewState();
}

class _ProfileViewState extends BaseStateDelegate<ProfileView, ProfileNotifier>
    with AutomaticKeepAliveClientMixin {
  @override
  void initNotifier() {
    notifier = ref.read(profileNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(bottom: 40),
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            // final user = ref.watch(
            //   profileNotifierProvider.select((value) => value.user),
            // );
            return Column(
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
                          'assets/images/avatar_empty.svg',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "user.name",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorUtils.whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            " user.email",
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
                    onPressed: () => {}),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: ColorUtils.textColor,
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
                    onPressed: () => {}),
                const Expanded(
                  child: SizedBox.shrink(),
                ),
                TextButtonWidget(
                  label: 'Logout',
                  onPressed: () => Routes.goToSignInScreen(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
