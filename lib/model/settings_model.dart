class SettingsModel {
  List<String>? admins;
  double? minimumVersion;
  String? appUrl;
  bool? maintenance;
  bool? autoPay;
  double? installments;
  double? others;
  double? cost;
  List<Map<String, dynamic>>? accounts;

  SettingsModel({
    this.admins, this.minimumVersion, this.appUrl, this.maintenance, this.autoPay,
    this.installments, this.others, this.cost, this.accounts,
  });

  SettingsModel.fromJson(Map<String, dynamic> json) {
    admins = json['admins'].cast<String>();
    minimumVersion = json['minimum_version'].toDouble();
    appUrl = json['app_url'];
    maintenance = json['maintenance'];
    autoPay = json['auto_pay'];
    installments = json['installments'].toDouble();
    others = json['others'].toDouble();
    cost = json['cost'].toDouble();
    accounts = <Map<String, dynamic>>[];
    if (json['accounts'] != null) {
      json['accounts'].forEach((v) {
        accounts!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admins'] = admins;
    data['minimum_version'] = minimumVersion;
    data['app_url'] = appUrl;
    data['maintenance'] = maintenance;
    data['auto_pay'] = autoPay;
    data['installments'] = installments;
    data['others'] = others;
    data['cost'] = cost;
    if (accounts != null) {
      data['accounts'] = accounts!.map((v) => v).toList();
    }
    return data;
  }
}
