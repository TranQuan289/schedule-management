import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schedule_management/features/conversation/chat_view.dart';
import 'package:schedule_management/model/conversation_model.dart';
import 'package:schedule_management/service/auth_service.dart';
import 'package:schedule_management/service/conversation_service.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'dart:math' show min;

class ConversationsView extends HookWidget {
  const ConversationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conversationService = useMemoized(() => ConversationService());
    final currentUserId = useState<String?>(null);
    final conversationsStream = useState<Stream<List<Conversation>>?>(null);

    useEffect(() {
      AuthService().getUser().then((user) {
        if (user != null) {
          currentUserId.value = user.id;
          conversationsStream.value =
              conversationService.getConversationsStream(user.id);
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Conversations',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: conversationsStream.value == null
          ? Center(
              child: CircularProgressIndicator(color: ColorUtils.primaryColor))
          : StreamBuilder<List<Conversation>>(
              stream: conversationsStream.value,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: ColorUtils.primaryColor));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text('Error loading conversations',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 48, color: ColorUtils.primaryColor),
                        SizedBox(height: 16),
                        Text('No conversations yet',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  );
                }

                final conversations = snapshot.data!;

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    final lastMessage = conversation.lastMessage;
                    final formattedDate = lastMessage != null
                        ? DateFormat('dd/MM/yyyy HH:mm')
                            .format(lastMessage.createdAt)
                        : '';

                    String messagePreview = lastMessage != null
                        ? '${lastMessage.sender == currentUserId.value ? 'You: ' : ''}${lastMessage.content}'
                        : 'No messages yet';

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatView(
                                name: _getConversationTitle(
                                  conversationService,
                                  conversation,
                                  currentUserId.value,
                                ),
                                conversationId: conversation.id,
                                currentUserId: currentUserId.value!,
                                recipientId: conversation.members.firstWhere(
                                    (id) => id != currentUserId.value),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorUtils.blueLightColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.r,
                                  backgroundColor: ColorUtils.primaryColor,
                                  child: Text(
                                    _getInitials(_getConversationTitle(
                                      conversationService,
                                      conversation,
                                      currentUserId.value,
                                    )),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getConversationTitle(
                                          conversationService,
                                          conversation,
                                          currentUserId.value,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        messagePreview,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    if (lastMessage != null &&
                                        lastMessage.sender !=
                                            currentUserId.value)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: ColorUtils.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'New',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _getConversationTitle(ConversationService service,
      Conversation conversation, String? currentUserId) {
    final otherMemberId = conversation.members
        .firstWhere((id) => id != currentUserId, orElse: () => '');
    final otherUser = service.getUserFromCache(otherMemberId);
    return otherUser?.name ?? otherMemberId;
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else {
      return name.substring(0, min(name.length, 2)).toUpperCase();
    }
  }
}
