class Conversation {
  final String id;
  List<String> members;
  final Message? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String nameDoctor;

  Conversation({
    required this.id,
    required this.members,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.nameDoctor,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      members: List<String>.from(json['members']),
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      nameDoctor: json['name_doctor'],
    );
  }
}

class Message {
  final String id;
  final String conversationId;
  final String content;
  final String sender;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.sender,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      conversationId: json['conversation_id'],
      content: json['content'],
      sender: json['sender'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
