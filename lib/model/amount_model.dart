class AmountModel {
  double? amount;
  String? note;
  String? userEmail;
  String? userName;
  String? userId;
  String? adminEmail;
  String? adminName;
  String? adminId;
  bool? isAdd;
  DateTime? date;

  AmountModel({
    this.amount, this.note, this.userEmail, this.userId, this.userName,
    this.adminEmail, this.adminName, this.adminId, this.isAdd, this.date,
  });

  AmountModel.fromJson(Map<String, dynamic> json, bool firebase) {
    amount = json['amount'];
    note = json['note'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userId = json['user_id'];
    adminEmail = json['admin_email'];
    adminId = json['admin_id'];
    adminName = json['admin_name'];
    isAdd = json['is_add'];
    date = json['date'] != null ? firebase ? DateTime.parse(json['date'].toDate().toString())
        : DateTime.parse(json['date']) : null;
  }

  Map<String, dynamic> toJson(bool firebase) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['note'] = note;
    data['user_email'] = userEmail;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['admin_email'] = adminEmail;
    data['admin_name'] = adminName;
    data['admin_id'] = adminId;
    data['is_add'] = isAdd;
    data['date'] = date != null ? firebase ? date : date!.toIso8601String() : null;
    return data;
  }
}
