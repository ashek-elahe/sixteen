class ConversationModel {
  String? id;
  String? users;
  String? user1Id;
  String? user1Email;
  String? user1Phone;
  String? user1Name;
  String? user1Image;
  int? user1Unread;
  String? user2Id;
  String? user2Email;
  String? user2Phone;
  String? user2Name;
  String? user2Image;
  int? user2Unread;
  String? lastMessage;
  DateTime? lastMessageTime;

  ConversationModel(
      {this.id,
        this.users,
        this.user1Id,
        this.user1Email,
        this.user1Phone,
        this.user1Name,
        this.user1Image,
        this.user1Unread,
        this.user2Id,
        this.user2Email,
        this.user2Phone,
        this.user2Name,
        this.user2Image,
        this.user2Unread,
        this.lastMessage,
        this.lastMessageTime});

  ConversationModel.fromJson(Map<String, dynamic> json, bool firebase) {
    id = json['id'];
    users = json['users'];
    user1Id = json['user_1_id'];
    user1Email = json['user_1_email'];
    user1Phone = json['user_1_phone'];
    user1Name = json['user_1_name'];
    user1Image = json['user_1_image'];
    user1Unread = json['user_1_unread'];
    user2Id = json['user_2_id'];
    user2Email = json['user_2_email'];
    user2Phone = json['user_2_phone'];
    user2Name = json['user_2_name'];
    user2Image = json['user_2_image'];
    user2Unread = json['user_2_unread'];
    lastMessage = json['last_message'];
    lastMessageTime = json['last_message_time'] != null ? firebase ? DateTime.parse(json['last_message_time'].toDate().toString())
        : DateTime.parse(json['last_message_time']) : null;
  }

  Map<String, dynamic> toJson(bool firebase) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['users'] = users;
    data['user_1_id'] = user1Id;
    data['user_1_email'] = user1Email;
    data['user_1_phone'] = user1Phone;
    data['user_1_name'] = user1Name;
    data['user_1_image'] = user1Image;
    data['user_1_unread'] = user1Unread;
    data['user_2_id'] = user2Id;
    data['user_2_email'] = user2Email;
    data['user_2_phone'] = user2Phone;
    data['user_2_name'] = user2Name;
    data['user_2_image'] = user2Image;
    data['user_2_unread'] = user2Unread;
    data['last_message'] = lastMessage;
    data['last_message_time'] = lastMessageTime != null ? firebase ? lastMessageTime : lastMessageTime!.toIso8601String() : null;
    return data;
  }

}
