import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:schedule_management/service/conversation_service.dart';
import 'package:schedule_management/model/conversation_model.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatView extends HookWidget {
  final String conversationId;
  final String currentUserId;
  final String name;
  final String recipientId;

  const ChatView({
    Key? key,
    required this.conversationId,
    required this.currentUserId,
    required this.name,
    required this.recipientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conversationService = useMemoized(() {
      final service = ConversationService();
      service.initSocket(currentUserId);
      return service;
    });

    final messagesStream = useMemoized(
        () => conversationService.getMessagesStream(conversationId));
    final scrollController = useScrollController();

    // useEffect(() {
    //   return () {
    //     conversationService.dispose();
    //   };
    // }, []);

    return Scaffold(
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          name,
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có tin nhắn'));
                }

                final messages = snapshot.data!.reversed.toList();

                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message.sender == currentUserId;

                    return BubbleSpecialThree(
                      text: message.content,
                      color: isSender
                          ? ColorUtils.primaryColor
                          : Colors.grey[300]!,
                      tail: true,
                      isSender: isSender,
                      textStyle: TextStyle(
                        color: isSender ? Colors.white : Colors.black,
                        fontSize: 16.sp,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          MessageBar(
            onSend: (String message) async {
              print('MessageBar onSend called with message: $message');
              conversationService.sendMessage(recipientId, message);
            },
          ),
        ],
      ),
    );
  }
}
