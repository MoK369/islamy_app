import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/cairo_quran_radio.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'radio_view_model_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<AudioPlayer>(), MockSpec<QuranRadioChannelsRepository>()])
void main() {
  group(
    "Testing RadioLayoutViewModel",
    () {
      late RadioViewModel radioViewModel;
      late MockAudioPlayer mockAudioPlayer;
      late MockQuranRadioChannelsRepository quranRadioChannelsRepository;
      late AppLocalizations appLocalizations;
      QuranRadioModel quranRadioModel = QuranRadioModel(
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
      RadioChannel cairoRadioChannel(String languageCode) => RadioChannel(
          id: CairoQuranRadio.id,
          name: CairoQuranRadio.title(languageCode),
          url: CairoQuranRadio.urlStr);

      setUpAll(
        () async {
          appLocalizations =
              await AppLocalizations.delegate.load(const Locale("ar"));
          getIt.registerLazySingleton(
            () => appLocalizations,
          );
        },
      );
      setUp(
        () {
          quranRadioChannelsRepository = MockQuranRadioChannelsRepository();
          mockAudioPlayer = MockAudioPlayer();
          radioViewModel =
              RadioViewModel(quranRadioChannelsRepository, mockAudioPlayer);
        },
      );
      group(
        "Testing getQuranRadioChannels() method",
        () {
          test(
              "Testing getQuranRadioChannels() method, if it would successfully get the Arabic Quran Radio Channels and audio sources get initialized",
              () async {
            // arrange
            List<BaseViewState<List<RadioChannel>>> getChannelsStates = [];
            const String languageCode = "ar";
            provideDummy<ApiResult<List<RadioChannel>>>(
                Success(data: [...quranRadioModel.radios!]));

            // act
            radioViewModel.addListener(
              () {
                getChannelsStates.add(radioViewModel.quranRadioChannelsState);
              },
            );
            await radioViewModel.getQuranRadioChannels(languageCode);

            // assert
            verify(mockAudioPlayer.playerStateStream).called(1);
            verify(mockAudioPlayer.currentIndexStream).called(1);
            verify(mockAudioPlayer
                    .setShuffleModeEnabled(argThat(equals(false))))
                .called(1);
            expect(getChannelsStates.length, 2);
            expect(getChannelsStates.first,
                isA<LoadingState<List<RadioChannel>>>());
            expect(getChannelsStates.last,
                isA<SuccessState<List<RadioChannel>>>());
            final List<RadioChannel> newRadioChannelList = [
              ...quranRadioModel.radios!
            ]..insert(0, cairoRadioChannel(languageCode));
            expect(
                (getChannelsStates.last as SuccessState<List<RadioChannel>>)
                    .data,
                newRadioChannelList);
            expect(radioViewModel.mediaItems.length, 4);
            expect(radioViewModel.audioSources.length, 4);
            expect(radioViewModel.currentRadioChannel, newRadioChannelList[0]);
          });
          test(
              "Testing getQuranRadioChannels() method, if it would successfully get the Arabic Quran Radio Channels but doesn't initialize the audio sources because the radio channels list is empty ",
              () async {
            // arrange
            List<BaseViewState<List<RadioChannel>>> getChannelsStates = [];
            const String languageCode = "ar";
            provideDummy<ApiResult<List<RadioChannel>>>(Success(data: []));

            // act
            radioViewModel.addListener(
              () {
                getChannelsStates.add(radioViewModel.quranRadioChannelsState);
              },
            );
            await radioViewModel.getQuranRadioChannels(languageCode);

            // assert
            verify(mockAudioPlayer.playerStateStream).called(1);
            verify(mockAudioPlayer.currentIndexStream).called(1);
            verifyNever(
                mockAudioPlayer.setShuffleModeEnabled(argThat(equals(false))));
            expect(getChannelsStates.length, 2);
            expect(getChannelsStates.first,
                isA<LoadingState<List<RadioChannel>>>());
            expect(getChannelsStates.last,
                isA<SuccessState<List<RadioChannel>>>());
            expect(
                (getChannelsStates.last as SuccessState<List<RadioChannel>>)
                    .data,
                []);
            expect(radioViewModel.mediaItems.length, 0);
            expect(radioViewModel.audioSources.length, 0);
            expect(radioViewModel.currentRadioChannel, isNull);
          });
          test(
              "Testing getQuranRadioChannels() method, if it would get the Quran Radio Channels but a code error happens with the call",
              () async {
            // arrange
            final ServerError<List<RadioChannel>> serverError =
                ServerError(message: "Bad Request", code: 400);
            List<BaseViewState<List<RadioChannel>>> getChannelsStates = [];
            const String languageCode = "ar";
            provideDummy<ApiResult<List<RadioChannel>>>(serverError);

            // act
            radioViewModel.addListener(
              () {
                getChannelsStates.add(radioViewModel.quranRadioChannelsState);
              },
            );
            await radioViewModel.getQuranRadioChannels(languageCode);

            // assert
            verify(mockAudioPlayer.playerStateStream).called(1);
            verify(mockAudioPlayer.currentIndexStream).called(1);
            expect(getChannelsStates.length, 2);
            expect(getChannelsStates.first,
                isA<LoadingState<List<RadioChannel>>>());
            expect(
                getChannelsStates.last, isA<ErrorState<List<RadioChannel>>>());
            expect(
                getChannelsStates.last, ErrorState(serverError: serverError));
            expect(radioViewModel.mediaItems.length, 0);
            expect(radioViewModel.audioSources.length, 0);
            expect(radioViewModel.currentRadioChannel, isNull);
          });
          test(
              "Testing getQuranRadioChannels() method, if it would get the Quran Radio Channels but a server error happens with the call",
              () async {
            // arrange
            final CodeError<List<RadioChannel>> codeError =
                CodeError(exception: Exception("something went wrong"));
            List<BaseViewState<List<RadioChannel>>> getChannelsStates = [];
            const String languageCode = "ar";
            provideDummy<ApiResult<List<RadioChannel>>>(codeError);

            // act
            radioViewModel.addListener(
              () {
                getChannelsStates.add(radioViewModel.quranRadioChannelsState);
              },
            );
            await radioViewModel.getQuranRadioChannels(languageCode);

            // assert
            verify(mockAudioPlayer.playerStateStream).called(1);
            verify(mockAudioPlayer.currentIndexStream).called(1);
            expect(getChannelsStates.length, 2);
            expect(getChannelsStates.first,
                isA<LoadingState<List<RadioChannel>>>());
            expect(
                getChannelsStates.last, isA<ErrorState<List<RadioChannel>>>());
            expect(getChannelsStates.last, ErrorState(codeError: codeError));
            expect(radioViewModel.mediaItems.length, 0);
            expect(radioViewModel.audioSources.length, 0);
            expect(radioViewModel.currentRadioChannel, isNull);
          });
        },
      );
    },
  );
}
