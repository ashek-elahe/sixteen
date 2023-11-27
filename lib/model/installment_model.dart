class InstallmentModel {
  String? userId;
  String? userName;
  String? userImage;
  double? amount;
  DateTime? month;
  String? receiverId;
  String? receiverName;
  String? receiverImage;
  DateTime? createdAt;

  InstallmentModel({
    this.userId, this.userName, this.userImage, this.amount, this.month,
    this.receiverId, this.receiverName, this.receiverImage, this.createdAt,
  });

  InstallmentModel.fromJson(Map<String, dynamic> json, bool firebase) {
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    amount = json['amount']?.toDouble();
    month = json['month'] != null ? firebase ? DateTime.parse(json['month'].toDate().toString())
        : DateTime.parse(json['month']) : null;
    receiverId = json['receiver_id'];
    receiverName = json['receiver_name'];
    receiverImage = json['receiver_image'];
    createdAt = json['created_at'] != null ? firebase ? DateTime.parse(json['created_at'].toDate().toString())
        : DateTime.parse(json['created_at']) : null;
  }

  Map<String, dynamic> toJson(bool firebase) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    data['amount'] = amount;
    data['month'] = month != null ? firebase ? month : month!.toIso8601String() : null;
    data['receiver_id'] = receiverId;
    data['receiver_name'] = receiverName;
    data['receiver_image'] = receiverImage;
    data['created_at'] = createdAt != null ? firebase ? createdAt : createdAt!.toIso8601String() : null;
    return data;
  }

  Map<String, dynamic> toJsonForShared(InstallmentModel? install) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(userId != null) {
      data['user_id'] = userId;
    }else if(install?.userId != null) {
      data['user_id'] = install?.userId;
    }
    if(userName != null) {
      data['user_name'] = userName;
    }else if(install?.userName != null) {
      data['user_name'] = install?.userName;
    }
    if(userImage != null) {
      data['user_image'] = userImage;
    }else if(install?.userImage != null) {
      data['user_image'] = install?.userImage;
    }
    if(amount != null) {
      data['amount'] = amount;
    }else if(install?.amount != null) {
      data['amount'] = install?.amount;
    }
    if(month != null) {
      data['month'] = month!.toIso8601String();
    }else if(install?.month != null) {
      data['month'] = install?.month!.toIso8601String();
    }
    if(receiverId != null) {
      data['receiver_id'] = receiverId;
    }else if(install?.receiverId != null) {
      data['receiver_id'] = install?.receiverId!;
    }
    if(receiverName != null) {
      data['receiver_name'] = receiverName;
    }else if(install?.receiverName != null) {
      data['receiver_name'] = install?.receiverName!;
    }
    if(receiverImage != null) {
      data['receiver_image'] = receiverImage;
    }else if(install?.receiverImage != null) {
      data['receiver_image'] = install?.receiverImage!;
    }
    if(createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }else if(install?.createdAt != null) {
      data['created_at'] = install?.createdAt!.toIso8601String();
    }
    return data;
  }

  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(userId != null) {
      data['user_id'] = userId;
    }
    if(userName != null) {
      data['user_name'] = userName;
    }
    if(userName != null) {
      data['user_image'] = userImage;
    }
    if(amount != null) {
      data['amount'] = amount;
    }
    if(month != null) {
      data['month'] = month;
    }
    if(receiverId != null) {
      data['receiver_id'] = receiverId;
    }
    if(receiverName != null) {
      data['receiver_name'] = receiverName;
    }
    if(receiverImage != null) {
      data['receiver_image'] = receiverImage;
    }
    if(createdAt != null) {
      data['created_at'] = createdAt;
    }
    return data;
  }

}
