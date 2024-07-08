import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schedule_management/features/bottom_navigator/notifier/bottom_navigation_notifier.dart';
import 'package:schedule_management/features/chat/chat_view.dart';
import 'package:schedule_management/features/home/home_view.dart';
import 'package:schedule_management/features/profile/profile_view.dart';
import 'package:schedule_management/features/search/search_view.dart';
import 'package:schedule_management/utils/assets_utils.dart';
import 'package:schedule_management/utils/color_utils.dart';
import '../../common/base_state_delegate/base_state_delegate.dart';

class BottomNavigationView extends ConsumerStatefulWidget {
  const BottomNavigationView({super.key});

  @override
  BaseStateDelegate<BottomNavigationView, BottomNavigationNotifier>
      createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState
    extends BaseStateDelegate<BottomNavigationView, BottomNavigationNotifier> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initNotifier() {
    notifier = ref.read(bottomNavigationNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Consumer(
          builder: (context, ref, child) {
            ref.watch(
              bottomNavigationNotifierProvider.select(
                (value) => value.currentIndex,
              ),
            );
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                HomeView(),
                ChatView(),
                SearchView(),
                ProfileView(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: ColorUtils.primaryBackgroundColor,
        child: BottomAppBar(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: const EdgeInsets.all(0),
          shape: AutomaticNotchedShape(
            const RoundedRectangleBorder(),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final index = ref.watch(
                bottomNavigationNotifierProvider.select(
                  (value) => value.currentIndex,
                ),
              );
              return BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.home,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.homeActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "home",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.chat,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.chatActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "Chat",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.search,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.searchActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.profile,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.profileActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "profile",
                  ),
                ],
                backgroundColor: ColorUtils.whiteColor,
                selectedItemColor: ColorUtils.blueColor,
                unselectedItemColor: ColorUtils.primaryColor,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: index,
                type: BottomNavigationBarType.fixed,
                onTap: (value) => {
                  _pageController.jumpToPage(value),
                  notifier.setCurrentIndex(value),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
