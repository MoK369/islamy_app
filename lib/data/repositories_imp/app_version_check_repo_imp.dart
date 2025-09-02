import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/models/check_app_version_model.dart';
import 'package:islamy_app/data/services/apis/api_manager.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/app_version_check/app_version_check_repo.dart';

@Injectable(as: AppVersionCheckRepo)
class AppVersionCheckRepoImp implements AppVersionCheckRepo {
  final ApiManager _apiManager;

  AppVersionCheckRepoImp(this._apiManager);

  @override
  Future<ApiResult<CheckAppVersionModel>> checkForUpdate() {
    return _apiManager.checkForUpdate();
  }
}
