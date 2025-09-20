import 'package:equatable/equatable.dart';

/// latest_version : "2.0.0"
/// update_url : "https://aptoide.com/your-app-page"
class CheckAppVersionModel extends Equatable {
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

  @override
  List<Object?> get props => [latestVersion, updateUrl];
}
