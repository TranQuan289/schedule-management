import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/common/base_state_delegate/base_state_delegate.dart';
import 'package:schedule_management/common/widgets/item_doctor_widget.dart';
import 'package:schedule_management/features/profile/notifier/profile_notifier.dart';
import 'package:schedule_management/utils/color_utils.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  BaseStateDelegate<HomeView, ProfileNotifier> createState() =>
      _HomeViewState();
}

class _HomeViewState extends BaseStateDelegate<HomeView, ProfileNotifier>
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
          'List',
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
            return Column(
              children: [ItemDoctorWidget()],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
