class SettingsModel {
  List<String>? admins;
  int? minimumVersion;
  String? appUrl;
  bool? maintenance;

  SettingsModel({this.admins, this.minimumVersion, this.appUrl, this.maintenance});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    admins = json['admins'].cast<String>();
    minimumVersion = json['minimum_version'];
    appUrl = json['app_url'];
    maintenance = json['maintenance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admins'] = admins;
    data['minimum_version'] = minimumVersion;
    data['app_url'] = appUrl;
    data['maintenance'] = maintenance;
    return data;
  }
}
