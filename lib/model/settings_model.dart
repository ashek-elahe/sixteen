class SettingsModel {
  List<String>? admins;
  double? minimumVersion;
  String? appUrl;
  bool? maintenance;
  double? installments;
  double? others;
  double? cost;

  SettingsModel({this.admins, this.minimumVersion, this.appUrl, this.maintenance, this.installments, this.others, this.cost});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    admins = json['admins'].cast<String>();
    minimumVersion = json['minimum_version'].toDouble();
    appUrl = json['app_url'];
    maintenance = json['maintenance'];
    installments = json['installments'].toDouble();
    others = json['others'].toDouble();
    cost = json['cost'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admins'] = admins;
    data['minimum_version'] = minimumVersion;
    data['app_url'] = appUrl;
    data['maintenance'] = maintenance;
    data['installments'] = installments;
    data['others'] = others;
    data['cost'] = cost;
    return data;
  }
}
