import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/data/models/check_app_version_model.dart';

void main() {
  group(
    "Test CheckAppVersionModel",
    () {
      String strResponse = """
{
  "latest_version": "2.0.0",
  "update_url": "https://uptodown.com/your-app-page"
  }
""";
      test(
          "Test the parsing of App Version API's Json Response, suppose the response is as expected",
          () {
        // arrange
        var jsonResponse = jsonDecode(strResponse);
        // act
        CheckAppVersionModel checkAppVersionModel =
            CheckAppVersionModel.fromJson(jsonResponse);

        // assert
        expect(
            checkAppVersionModel,
            CheckAppVersionModel(
                latestVersion: "2.0.0",
                updateUrl: "https://uptodown.com/your-app-page"));
      });
      test(
          "Test the parsing of App Version API's Json Response, suppose the response isn't there or not as expected",
          () {
        // arrange
        // act
        CheckAppVersionModel checkAppVersionModel =
            CheckAppVersionModel.fromJson(jsonDecode("{}"));

        // assert
        expect(checkAppVersionModel, CheckAppVersionModel());
      });
    },
  );
}
