import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';

void main() {
  group(
    "Quran Radio Model Testing",
    () {
      String strResponse = """{
"radios": [
  {
      "id": 1,
      "name": "إذاعة إبراهيم الأخضر",
      "url": "https://backup.qurango.net/radio/ibrahim_alakdar",
      "recent_date": "2020-04-25 22:04:04"
  },
  {
      "id": 2,
      "name": "إذاعة شيخ أبو بكر الشاطري",
      "url": "https://backup.qurango.net/radio/shaik_abu_bakr_al_shatri",
      "recent_date": "2020-04-25 22:04:04"
  },
  {
      "id": 3,
      "name": "إذاعة أحمد العجمي",
      "url": "https://backup.qurango.net/radio/ahmad_alajmy",
      "recent_date": "2020-04-25 22:04:04"
  }]
  }""";

      test(
          "Test the parsing of QuranRadio Channels API's Json Response, suppose the response is as expected",
          () {
        // arrange

        // act
        final QuranRadioModel quranRadioModel =
            QuranRadioModel.fromJson(jsonDecode(strResponse));

        // assert
        expect(
          quranRadioModel,
          QuranRadioModel(
            radios: [
              RadioChannel(
                  id: 1,
                  name: "إذاعة إبراهيم الأخضر",
                  url: "https://backup.qurango.net/radio/ibrahim_alakdar"),
              RadioChannel(
                  id: 2,
                  name: "إذاعة شيخ أبو بكر الشاطري",
                  url:
                      "https://backup.qurango.net/radio/shaik_abu_bakr_al_shatri"),
              RadioChannel(
                  id: 3,
                  name: "إذاعة أحمد العجمي",
                  url: "https://backup.qurango.net/radio/ahmad_alajmy")
            ],
          ),
        );
      });

      test(
          "Test the parsing of QuranRadio Channels API's Json Response, suppose the response is not there or not as expected",
          () {
        // arrange

        // act
        final QuranRadioModel quranRadioModel1 =
            QuranRadioModel.fromJson(jsonDecode("{}"));
        final QuranRadioModel quranRadioModel2 = QuranRadioModel.fromJson(
            jsonDecode(strResponse.replaceFirst("radios", "channels")));

        // assert
        expect(
          quranRadioModel1,
          QuranRadioModel(),
        );
        expect(
          quranRadioModel2,
          QuranRadioModel(),
        );
      });
    },
  );
}
