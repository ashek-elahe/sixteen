class MessageModel {
  String? id;
  String? userId;
  String? userEmail;
  String? userPhone;
  String? message;
  List<String>? attachments;
  DateTime? time;

  MessageModel(
      {this.id,
        this.userId,
        this.userEmail,
        this.userPhone,
        this.message,
        this.attachments,
        this.time});

  MessageModel.fromJson(Map<String, dynamic> json, bool firebase) {
    id = json['id'];
    userId = json['user_id'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    message = json['message'];
    attachments = json['attachments'].cast<String>();
    time = json['time'] != null ? firebase ? DateTime.parse(json['time'].toDate().toString())
        : DateTime.parse(json['time']) : null;
  }

  Map<String, dynamic> toJson(bool firebase) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    data['message'] = message;
    data['attachments'] = attachments;
    data['time'] = time != null ? firebase ? time : time!.toIso8601String() : null;
    return data;
  }
}
