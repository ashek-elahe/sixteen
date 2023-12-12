class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phone;
  DateTime? joiningDate;
  String? image;
  bool? isActive;
  DateTime? lastActive;
  String? address;
  double? balance;
  String? deviceToken;

  UserModel({
    this.uid, this.name, this.email, this.phone, this.joiningDate, this.image,
    this.isActive, this.lastActive, this.address, this.balance, this.deviceToken,
  });

  UserModel.fromJson(Map<String, dynamic> json, bool firebase) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    joiningDate = json['joining_date'] != null ? firebase ? DateTime.parse(json['joining_date'].toDate().toString())
        : DateTime.parse(json['joining_date']) : null;
    image = json['image'];
    isActive = json['is_active'];
    lastActive = json['last_active'] != null ? firebase ? DateTime.parse(json['last_active'].toDate().toString())
        : DateTime.parse(json['last_active']) : null;
    address = json['address'];
    balance = json['balance']?.toDouble();
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson(bool firebase) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['joining_date'] = joiningDate != null ? firebase ? joiningDate : joiningDate!.toIso8601String() : null;
    data['image'] = image;
    data['is_active'] = isActive;
    data['last_active'] = lastActive != null ? firebase ? lastActive : lastActive!.toIso8601String() : null;
    data['address'] = address;
    data['balance'] = balance;
    data['device_token'] = deviceToken;
    return data;
  }

  Map<String, dynamic> toJsonForShared(UserModel? user) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(uid != null) {
      data['uid'] = uid;
    }else if(user != null) {
      data['uid'] = user.uid;
    }
    if(name != null) {
      data['name'] = name;
    }else if(user != null) {
      data['name'] = user.name;
    }
    if(image != null) {
      data['image'] = image;
    }else if(user != null) {
      data['image'] = user.image;
    }
    if(joiningDate != null) {
      data['joining_date'] = joiningDate!.toIso8601String();
    }else if(user != null && user.joiningDate != null) {
      data['joining_date'] = user.joiningDate!.toIso8601String();
    }
    if(email != null) {
      data['email'] = email;
    }else if(user != null && user.email != null) {
      data['email'] = user.email!;
    }
    if(phone != null) {
      data['phone'] = phone;
    }else if(user != null && user.phone != null) {
      data['phone'] = user.phone!;
    }
    if(isActive != null) {
      data['is_active'] = isActive;
    }else if(user != null && user.isActive != null) {
      data['is_active'] = user.isActive!;
    }
    if(lastActive != null) {
      data['last_active'] = lastActive!.toIso8601String();
    }else if(user != null && user.lastActive != null) {
      data['last_active'] = user.lastActive!.toIso8601String();
    }
    if(address != null) {
      data['address'] = address;
    }else if(user != null && user.address != null) {
      data['address'] = user.address!;
    }
    if(balance != null) {
      data['balance'] = balance;
    }else if(user != null && user.balance != null) {
      data['balance'] = user.balance!;
    }
    if(deviceToken != null) {
      data['device_token'] = deviceToken;
    }else if(user != null && user.deviceToken != null) {
      data['device_token'] = user.deviceToken!;
    }
    return data;
  }

  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(uid != null) {
      data['uid'] = uid;
    }
    if(name != null) {
      data['name'] = name;
    }
    if(image != null) {
      data['image'] = image;
    }
    if(email != null) {
      data['email'] = email;
    }
    if(phone != null) {
      data['phone'] = phone;
    }
    if(joiningDate != null) {
      data['joining_date'] = joiningDate;
    }
    if(isActive != null) {
      data['is_active'] = isActive;
    }
    if(lastActive != null) {
      data['last_active'] = lastActive;
    }
    if(address != null) {
      data['address'] = address;
    }
    if(balance != null) {
      data['balance'] = balance;
    }
    if(deviceToken != null) {
      data['device_token'] = deviceToken;
    }
    return data;
  }

}
