/// latest_version : "2.0.0"
/// update_url : "https://aptoide.com/your-app-page"
class CheckAppVersionModel {
  CheckAppVersionModel({
    this.latestVersion,
    this.updateUrl,
  });

  CheckAppVersionModel.fromJson(dynamic json) {
    latestVersion = json['latest_version'];
    updateUrl = json['update_url'];
  }

  String? latestVersion;
  String? updateUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latest_version'] = latestVersion;
    map['update_url'] = updateUrl;
    return map;
  }
}
