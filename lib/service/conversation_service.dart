import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_management/model/conversation_model.dart';
import 'package:schedule_management/model/user_model.dart';
import 'package:schedule_management/service/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConversationService {
  static String conversationsUrl = "${Config.base}/api/conversation/u";
  static String userUrl = "${Config.base}/api/u";
  static String messagesUrl = "${Config.base}/api/message";
  static String doctorUrl = "${Config.base}/api/doctor";

  Map<String, User> _userCache = {};
  List<Message> _messages = [];
  final _messagesController = StreamController<List<Message>>.broadcast();
  IO.Socket? _socket;

  Stream<List<Conversation>> getConversationsStream(String userId) async* {
    while (true) {
      yield await fetchConversations(userId);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future<List<Conversation>> fetchConversations(String userId) async {
    final response = await http.get(Uri.parse('$conversationsUrl/$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 1) {
        List<dynamic> data = responseBody['data'];

        List<Conversation> conversations = [];
        for (var json in data) {
          List<String> memberIds = List<String>.from(json['members']);
          await Future.forEach(memberIds, (memberId) async {
            if (!_userCache.containsKey(memberId)) {
              try {
                User user = await fetchUserDetails(memberId);
                _userCache[memberId] = user;
              } catch (e) {
                print(
                    'Lỗi khi lấy thông tin người dùng cho thành viên $memberId: $e');
              }
            }
          });
          Conversation conversation = Conversation.fromJson(json);
          conversations.add(conversation);
        }

        return conversations;
      } else {
        throw Exception(responseBody['msg']);
      }
    } else {
      throw Exception('Không thể lấy cuộc trò chuyện');
    }
  }

  User? getUserFromCache(String userId) {
    return _userCache[userId];
  }

  Future<User> fetchUserDetails(String userId) async {
    final response = await http.get(Uri.parse('$userUrl/$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 1) {
        Map<String, dynamic> userData = responseBody['data'];
        return User.fromJson(userData);
      } else {
        throw Exception(responseBody['msg']);
      }
    } else {
      throw Exception('Không thể lấy thông tin người dùng');
    }
  }

  Future<List<Message>> fetchMessages(String conversationId) async {
    final response = await http.get(Uri.parse('$messagesUrl/$conversationId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        return (data['data'] as List)
            .map((item) => Message.fromJson(item))
            .toList();
      } else {
        throw Exception(data['msg']);
      }
    } else {
      throw Exception('Không thể lấy tin nhắn');
    }
  }

  Stream<List<Message>> getMessagesStream(String conversationId) async* {
    while (true) {
      yield await fetchMessages(conversationId);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void addMessageToStream(Message message) {
    _messages.add(message);
    _messagesController.add(List.unmodifiable(_messages));
  }

  void initSocket(String currentUserId) {
    _socket = IO.io(Config.base, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();
    _socket!.on('connect', (_) {
      print('Kết nối thành công với máy chủ socket');
      _socket!.emit('authenticate', {'userId': currentUserId});
    });

    _socket!.on('connect_error', (error) {
      print('Lỗi kết nối: $error');
    });

    _socket!.on('authenticated', (response) {
      if (response['success']) {
        print('Xác thực thành công');
      } else {
        print('Xác thực thất bại: ${response['message']}');
      }
    });

    _socket!.on('new message', (data) {
      print('Nhận tin nhắn mới: $data');
      addMessageToStream(Message.fromJson(data['message']));
    });

    _socket!.on('message sent', (message) {
      print('Tin nhắn đã gửi thành công: $message');
      addMessageToStream(Message.fromJson(message));
    });

    _socket!.on('error', (error) {
      print('Lỗi socket: $error');
    });
  }

  void sendMessage(String recipientId, String content) {
    if (_socket != null && _socket!.connected) {
      print('Gửi tin nhắn: $content đến người nhận: $recipientId');
      _socket!.emit('send message', {
        'recipientId': recipientId,
        'content': content,
      });
    } else {
      print('Socket chưa kết nối. Không thể gửi tin nhắn.');
    }
  }

  void disconnectSocket() {
    _socket?.disconnect();
  }

  void dispose() {
    disconnectSocket();
    _messagesController.close();
  }
}
