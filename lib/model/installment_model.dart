class InstallmentModel {
  String? id;
  String? userId;
  String? userEmail;
  String? userName;
  String? userImage;
  double? amount;
  DateTime? month;
  String? medium;
  String? reference;
  String? receiverId;
  String? receiverEmail;
  String? receiverName;
  String? receiverImage;
  DateTime? createdAt;

  InstallmentModel({
    this.id, this.userId, this.userEmail, this.userName, this.userImage, this.amount, this.month, this.medium, this.reference,
    this.receiverId, this.receiverEmail, this.receiverName, this.receiverImage, this.createdAt,
  });

  InstallmentModel.fromJson(Map<String, dynamic> json, bool firebase) {
    id = json['id'];
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userImage = json['user_image'];
    amount = json['amount']?.toDouble();
    month = json['month'] != null ? firebase ? DateTime.parse(json['month'].toDate().toString())
        : DateTime.parse(json['month']) : null;
    medium = json['medium'];
    reference = json['reference'];
    receiverId = json['receiver_id'];
    receiverEmail = json['receiver_email'];
    receiverName = json['receiver_name'];
    receiverImage = json['receiver_image'];
    createdAt = json['created_at'] != null ? firebase ? DateTime.parse(json['created_at'].toDate().toString())
        : DateTime.parse(json['created_at']) : null;
  }

  Map<String, dynamic> toJson(bool firebase) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    data['amount'] = amount;
    data['month'] = month != null ? firebase ? month : month!.toIso8601String() : null;
    data['medium'] = medium;
    data['reference'] = reference;
    data['receiver_id'] = receiverId;
    data['receiver_email'] = receiverEmail;
    data['receiver_name'] = receiverName;
    data['receiver_image'] = receiverImage;
    data['created_at'] = createdAt != null ? firebase ? createdAt : createdAt!.toIso8601String() : null;
    return data;
  }

}
