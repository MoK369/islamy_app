import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/data/data_sources/quran_radio_channnels_data_sources/quran_radio_channels_remote_data_source.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/data/repositories_imp/quran_radio_channels_repository_imp.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'quran_radio_channels_repository_imp_test.mocks.dart';

@GenerateNiceMocks([MockSpec<QuranRadioChannelsRemoteDataSource>()])
void main() {
  group("Testing QuranRadioChannelsRemoteDataSource", () {
    final QuranRadioModel quranRadioModel = QuranRadioModel(
      radios: [
        RadioChannel(
            id: 1,
            name: "إذاعة إبراهيم الأخضر",
            url: "https://backup.qurango.net/radio/ibrahim_alakdar"),
        RadioChannel(
            id: 2,
            name: "إذاعة شيخ أبو بكر الشاطري",
            url: "https://backup.qurango.net/radio/shaik_abu_bakr_al_shatri"),
        RadioChannel(
            id: 3,
            name: "إذاعة أحمد العجمي",
            url: "https://backup.qurango.net/radio/ahmad_alajmy")
      ],
    );
    late QuranRadioChannelsRemoteDataSource quranRadioChannelsRemoteDataSource;
    late QuranRadioChannelsRepository quranRadioChannelsRepository;
    setUpAll(
      () {
        quranRadioChannelsRemoteDataSource =
            MockQuranRadioChannelsRemoteDataSource();
        quranRadioChannelsRepository =
            QuranRadioChannelsRepositoryImp(quranRadioChannelsRemoteDataSource);
      },
    );
    test(
        'test the method getQuranRadioChannels() will return success, when the api call returns the success response',
        () async {
      // arrange:
      provideDummy<ApiResult<List<RadioChannel>>>(
          Success(data: quranRadioModel.radios!));
      // when(_apiManager.getQuranRadioChannels("ar")).thenAnswer(
      //   (realInvocation) =>
      //       Future.value(Success(data: quranRadioModel.radios!)),
      // );
      // act
      final result =
          await quranRadioChannelsRepository.getQuranRadioChannels('ar');
      // assert
      switch (result) {
        case Success<List<RadioChannel>>():
          verify(quranRadioChannelsRemoteDataSource.getQuranRadioChannels("ar"))
              .called(1);
          expect(result, Success(data: quranRadioModel.radios));
        case ServerError<List<RadioChannel>>():
        case CodeError<List<RadioChannel>>():
          debugPrint("Impossible Case");
      }
    });
    test(
        'test the method getQuranRadioChannels() will return server error, when the api call returns the an error',
        () async {
      // arrange:
      provideDummy<ApiResult<List<RadioChannel>>>(
          ServerError(code: 400, message: "Bad Response"));
      // when(_apiManager.getQuranRadioChannels("ar")).thenAnswer(
      //   (realInvocation) =>
      //       Future.value(Success(data: quranRadioModel.radios!)),
      // );
      // act
      final result =
          await quranRadioChannelsRepository.getQuranRadioChannels('ar');
      // assert
      switch (result) {
        case Success<List<RadioChannel>>():
        case CodeError<List<RadioChannel>>():
          debugPrint("Impossible Case");
        case ServerError<List<RadioChannel>>():
          verify(quranRadioChannelsRemoteDataSource.getQuranRadioChannels("ar"))
              .called(1);
          expect(result, ServerError(code: 400, message: "Bad Response"));
      }
    });
    test(
        'test the method getQuranRadioChannels() will return code error, when something goes wrong in the code of the api call',
        () async {
      // arrange:
      final codeException = Exception("something went wrong");
      provideDummy<ApiResult<List<RadioChannel>>>(
          CodeError(exception: codeException));
      // when(_apiManager.getQuranRadioChannels("ar")).thenAnswer(
      //   (realInvocation) =>
      //       Future.value(Success(data: quranRadioModel.radios!)),
      // );
      // act
      final result =
          await quranRadioChannelsRepository.getQuranRadioChannels('ar');
      // assert
      switch (result) {
        case Success<List<RadioChannel>>():
        case ServerError<List<RadioChannel>>():
          debugPrint("Impossible Case");
        case CodeError<List<RadioChannel>>():
          verify(quranRadioChannelsRemoteDataSource.getQuranRadioChannels('ar'))
              .called(1);
          expect(result, CodeError(exception: codeException));
      }
    });
  });
}
