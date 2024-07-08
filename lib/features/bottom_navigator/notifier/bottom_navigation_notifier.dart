import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:schedule_management/features/bottom_navigator/state/bottom_navigation_state.dart';

part 'bottom_navigation_notifier.g.dart';

@riverpod
class BottomNavigationNotifier extends _$BottomNavigationNotifier {
  @override
  BottomNavigationState build() =>  const BottomNavigationState();

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
