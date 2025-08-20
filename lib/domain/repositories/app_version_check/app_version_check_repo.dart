import 'package:islamy_app/data/models/check_app_version_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';

abstract interface class AppVersionCheckRepo {
  Future<ApiResult<CheckAppVersionModel>> checkForUpdate();
}
