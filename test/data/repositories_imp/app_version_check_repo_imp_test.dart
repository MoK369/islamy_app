import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/data/models/check_app_version_model.dart';
import 'package:islamy_app/data/repositories_imp/app_version_check_repo_imp.dart';
import 'package:islamy_app/data/services/apis/api_manager.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/app_version_check/app_version_check_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_version_check_repo_imp_test.mocks.dart';

@GenerateMocks([ApiManager])
void main() {
  group(
    "Testing AppVersionCheckRepo",
    () {
      late CheckAppVersionModel checkAppVersionModel = CheckAppVersionModel(
          latestVersion: "2.0.0",
          updateUrl: "https://uptodown.com/your-app-page");
      late ApiManager apiManager;
      late AppVersionCheckRepo appVersionCheckRepo;
      setUpAll(
        () {
          apiManager = MockApiManager();
          appVersionCheckRepo = AppVersionCheckRepoImp(apiManager);
        },
      );
      test(
        "Testing checkForUpdate() mothed in AppVersionCheckRepo, if it would return the response when the api call successfully happens",
        () async {
          // arrange
          provideDummy<ApiResult<CheckAppVersionModel>>(
              Success(data: checkAppVersionModel));
          when(appVersionCheckRepo.checkForUpdate()).thenAnswer(
            (realInvocation) =>
                Future.value(Success(data: checkAppVersionModel)),
          );

          // act
          final result = await appVersionCheckRepo.checkForUpdate();

          // assert
          verify(apiManager.checkForUpdate()).called(1);
          switch (result) {
            case Success<CheckAppVersionModel>():
              expect(result, Success(data: checkAppVersionModel));

            case ServerError<CheckAppVersionModel>():
            case CodeError<CheckAppVersionModel>():
              debugPrint("Impossible Case");
          }
        },
      );
      test(
        "Testing checkForUpdate() mothed in AppVersionCheckRepo, if it would return the Server Error when the api call fails",
        () async {
          // arrange
          provideDummy<ApiResult<CheckAppVersionModel>>(
              ServerError(code: 400, message: "Bad Response"));
          when(appVersionCheckRepo.checkForUpdate()).thenAnswer(
            (realInvocation) =>
                Future.value(ServerError(code: 400, message: "Bad Response")),
          );

          // act
          final result = await appVersionCheckRepo.checkForUpdate();

          // assert
          verify(apiManager.checkForUpdate()).called(1);
          switch (result) {
            case Success<CheckAppVersionModel>():
            case CodeError<CheckAppVersionModel>():
              debugPrint("Impossible Case");

            case ServerError<CheckAppVersionModel>():
              expect(result, ServerError(code: 400, message: "Bad Response"));
          }
        },
      );
      test(
        "Testing checkForUpdate() mothed in AppVersionCheckRepo, if it would return the Code Error when the code of the api fails",
        () async {
          // arrange
          final Exception codeException = Exception("Something went wrong");
          provideDummy<ApiResult<CheckAppVersionModel>>(
              CodeError(exception: codeException));
          when(appVersionCheckRepo.checkForUpdate()).thenAnswer(
            (realInvocation) =>
                Future.value(CodeError(exception: codeException)),
          );

          // act
          final result = await appVersionCheckRepo.checkForUpdate();

          // assert
          verify(apiManager.checkForUpdate()).called(1);
          switch (result) {
            case Success<CheckAppVersionModel>():
            case ServerError<CheckAppVersionModel>():
              debugPrint("Impossible Case");
            case CodeError<CheckAppVersionModel>():
              expect(result, CodeError(exception: codeException));
          }
        },
      );
    },
  );
}
