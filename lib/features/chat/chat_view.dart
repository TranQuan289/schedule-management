import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:schedule_management/utils/color_utils.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Chat',
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
              children: [
                BubbleSpecialOne(
                  text: 'Hello, how are you?',
                  isSender: true,
                  color: ColorUtils.primaryColor,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                BubbleSpecialOne(
                  text: 'I am good, thank you!',
                  isSender: false,
                  color: ColorUtils.blueMiddleColor,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
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
