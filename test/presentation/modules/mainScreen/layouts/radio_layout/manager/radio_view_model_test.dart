import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/use_cases/get_radio_channels_use_case.dart';
import 'package:islamy_app/main.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/utils/toasts/toasts.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'radio_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AudioPlayer>(),
  MockSpec<GetRadioChannelsUseCase>(),
  MockSpec<InternetConnection>(),
  MockSpec<CustomToasts>()
])
void main() {
  group(
    "Testing RadioLayoutViewModel",
    () {
      late RadioViewModel radioViewModel;
      late MockAudioPlayer mockAudioPlayer;
      late MockGetRadioChannelsUseCase getRadioChannelsUseCase;
      late MockInternetConnection internetConnection;
      late AppLocalizations appLocalizations;
      late StreamController<PlayerState> playerStateController;
      late MockCustomToasts customToasts;
      final Exception somethingWentWrongException =
          Exception("Something went wrong");
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
      // RadioChannel cairoRadioChannel(String languageCode) => RadioChannel(
      //     id: CairoQuranRadio.id,
      //     name: CairoQuranRadio.title(languageCode),
      //     url: CairoQuranRadio.urlStr);

      setUpAll(
        () async {
          internetConnection = MockInternetConnection();
          customToasts = MockCustomToasts();
          getIt.registerFactory<CustomToasts>(
            () => customToasts,
          );
          appLocalizations =
              await AppLocalizations.delegate.load(const Locale("ar"));
          getIt.registerLazySingleton(
            () => appLocalizations,
          );
        },
      );
      setUp(
        () {
          mockAudioPlayer = MockAudioPlayer();
          playerStateController = StreamController<PlayerState>();
          when(mockAudioPlayer.playerStateStream).thenAnswer(
            (realInvocation) => playerStateController.stream,
          );
          getRadioChannelsUseCase = MockGetRadioChannelsUseCase();
          radioViewModel = RadioViewModel(getRadioChannelsUseCase,
              mockAudioPlayer, internetConnection, customToasts);
        },
      );
      tearDown(
        () {
          playerStateController.close();
          audioSession = null;
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
            expect(
                (getChannelsStates.last as SuccessState<List<RadioChannel>>)
                    .data,
                quranRadioModel.radios);
            expect(radioViewModel.mediaItems.length, 3);
            expect(radioViewModel.audioSources.length, 3);
            expect(
                radioViewModel.currentRadioChannel, quranRadioModel.radios![0]);
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
      group(
        "Testing startMonitoringConnectivity() method",
        () {
          test(
            "Testing startMonitoringConnectivity() method that will be called when audio player status is buffering and that audio player will continue to play if internet connection is back",
            () async {
              // arrange
              StreamController<InternetStatus> internetStatusController =
                  StreamController<InternetStatus>();
              when(internetConnection.onStatusChange).thenAnswer(
                (realInvocation) => internetStatusController.stream,
              );
              // act
              playerStateController
                  .add(PlayerState(false, ProcessingState.buffering));
              internetStatusController.add(InternetStatus.connected);
              await Future.delayed(const Duration(seconds: 1));
              // assert
              expect(radioViewModel.listenOnInternetChangeStream, isNotNull);
              verify(internetConnection.onStatusChange).called(1);
              verify(mockAudioPlayer.stop()).called(1);
              verify(mockAudioPlayer.play()).called(1);
              internetStatusController.close();
            },
          );
          test(
            "Testing startMonitoringConnectivity() method that will be called when audio player status is buffering and that audio player will NOT continue to play if internet connection isn't back",
            () async {
              // arrange
              StreamController<InternetStatus> internetStatusController =
                  StreamController<InternetStatus>();
              when(internetConnection.onStatusChange).thenAnswer(
                (realInvocation) => internetStatusController.stream,
              );
              // act
              playerStateController
                  .add(PlayerState(false, ProcessingState.buffering));
              internetStatusController.add(InternetStatus.disconnected);
              await Future.delayed(const Duration(seconds: 1));
              // assert
              expect(radioViewModel.listenOnInternetChangeStream, isNotNull);
              verify(internetConnection.onStatusChange).called(1);
              verifyNever(mockAudioPlayer.stop());
              verifyNever(mockAudioPlayer.play());
              internetStatusController.close();
            },
          );
        },
      );
      group(
        "Testing play() method",
        () {
          test(
            "Testing play() method, that the audio player won't play when there is no internet connection",
            () async {
              // arrange
              when(internetConnection.hasInternetAccess).thenAnswer(
                (realInvocation) => Future.value(false),
              );
              // act
              await radioViewModel.play();

              // assert
              verify(customToasts.showErrorToast(
                      argThat(equals(appLocalizations.noInternetConnection))))
                  .called(1);
              verifyNever(mockAudioPlayer.play());
            },
          );
          test(
            "Testing play() method, that the audio player will play when there internet connection",
            () async {
              // arrange
              WidgetsFlutterBinding.ensureInitialized();
              await setupAudioSession();
              when(internetConnection.hasInternetAccess).thenAnswer(
                (realInvocation) => Future.value(true),
              );
              // act
              await radioViewModel.play();
              // assert
              verifyNever(customToasts.showErrorToast(
                  argThat(equals(appLocalizations.noInternetConnection))));
              verify(
                mockAudioPlayer.setAudioSources(
                  any,
                  initialIndex: anyNamed("initialIndex"),
                  initialPosition: anyNamed("initialPosition"),
                  preload: anyNamed("preload"),
                  shuffleOrder: anyNamed("shuffleOrder"),
                ),
              ).called(1);
              verify(mockAudioPlayer.play()).called(1);
              expect(radioViewModel.allowChangeOfCurrentRadioChannel, true);
            },
          );
          test(
            "Testing play() method, that the audio player won't play when audio session is not active",
            () async {
              // arrange
              when(internetConnection.hasInternetAccess).thenAnswer(
                (realInvocation) => Future.value(true),
              );
              // act
              await radioViewModel.play();
              // assert
              verifyNever(customToasts.showErrorToast(
                  argThat(equals(appLocalizations.noInternetConnection))));
              verifyNever(
                mockAudioPlayer.setAudioSources(
                  any,
                  initialIndex: anyNamed("initialIndex"),
                  initialPosition: anyNamed("initialPosition"),
                  preload: anyNamed("preload"),
                  shuffleOrder: anyNamed("shuffleOrder"),
                ),
              );
              verifyNever(mockAudioPlayer.play());
              expect(radioViewModel.allowChangeOfCurrentRadioChannel, true);
              verify(customToasts.showErrorToast(
                      argThat(equals(appLocalizations.audioSessionNotActive))))
                  .called(1);
            },
          );
          test(
            "Testing play() method, that the audio player won't play when an Exception happens",
            () async {
              // arrange
              when(internetConnection.hasInternetAccess)
                  .thenThrow(somethingWentWrongException);
              // act
              await radioViewModel.play();
              // assert
              verifyNever(customToasts.showErrorToast(
                  argThat(equals(appLocalizations.noInternetConnection))));
              verifyNever(
                mockAudioPlayer.setAudioSources(
                  any,
                  initialIndex: anyNamed("initialIndex"),
                  initialPosition: anyNamed("initialPosition"),
                  preload: anyNamed("preload"),
                  shuffleOrder: anyNamed("shuffleOrder"),
                ),
              );
              verifyNever(mockAudioPlayer.play());
              expect(radioViewModel.allowChangeOfCurrentRadioChannel, true);
              verify(customToasts.showErrorToast(
                      argThat(equals(appLocalizations.errorPlayingAudio))))
                  .called(1);
            },
          );
        },
      );
      group(
        "Testing skipToNext() method",
        () {
          test(
            "Testing skipToNext method, when the last audio channel reached",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [quranRadioModel.radios!.first]));
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToNext();
              // assert
              verifyNever(mockAudioPlayer.seekToNext());
              expect(radioViewModel.currentRadioChannelIndex, 0);
            },
          );
          test(
            "Testing skipToNext() method, that audio player will move to the next channel when the last audio channel NOT reached and the audio player is paused",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [...quranRadioModel.radios!]));
              when(mockAudioPlayer.playing).thenAnswer(
                (realInvocation) => false,
              );
              when(mockAudioPlayer.processingState).thenAnswer(
                (realInvocation) => ProcessingState.ready,
              );
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToNext();
              // assert
              expect(radioViewModel.isLastAudioChannel, false);
              expect(radioViewModel.currentRadioChannelIndex, 1);
              expect(radioViewModel.currentRadioChannel,
                  quranRadioModel.radios![1]);
              verify(mockAudioPlayer.stop()).called(1);
              verify(mockAudioPlayer.seekToNext()).called(1);
            },
          );
          test(
            "Testing skipToNext() method, that audio player will move to the next channel when the last audio channel NOT reached and the audio player is playing",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [...quranRadioModel.radios!]));
              when(mockAudioPlayer.playing).thenAnswer(
                (realInvocation) => true,
              );
              when(mockAudioPlayer.processingState).thenAnswer(
                (realInvocation) => ProcessingState.ready,
              );
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToNext();
              // assert
              expect(radioViewModel.isLastAudioChannel, false);
              expect(radioViewModel.currentRadioChannelIndex, 1);
              expect(radioViewModel.currentRadioChannel,
                  quranRadioModel.radios![1]);
              verifyNever(mockAudioPlayer.stop());
              verify(mockAudioPlayer.seekToNext()).called(1);
            },
          );
          test(
            "Testing skipToNext() method, that audio player will move to the next channel but an exception happens",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [...quranRadioModel.radios!]));
              when(mockAudioPlayer.playing).thenThrow(
                (realInvocation) => somethingWentWrongException,
              );
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToNext();
              // assert
              expect(radioViewModel.isLastAudioChannel, false);
              expect(radioViewModel.currentRadioChannelIndex, 1);
              expect(radioViewModel.currentRadioChannel,
                  quranRadioModel.radios![0]);
              verifyNever(mockAudioPlayer.stop());
              verifyNever(mockAudioPlayer.seekToNext());
              verify(customToasts.showErrorToast(
                  argThat(equals(appLocalizations.errorMovingToNextChannel))));
            },
          );
        },
      );
      group(
        "Testing skipToPrevious() method",
        () {
          test(
            "Testing skipToPrevious() method, when the first audio channel reached",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [quranRadioModel.radios!.first]));
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToPrevious();
              // assert
              verifyNever(mockAudioPlayer.seekToPrevious());
              expect(radioViewModel.currentRadioChannelIndex, 0);
            },
          );
          test(
            "Testing skipToPrevious() method, that audio player will move to the previous channel when the first audio channel NOT reached and the audio player is paused",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [...quranRadioModel.radios!]));
              when(mockAudioPlayer.playing).thenAnswer(
                (realInvocation) => false,
              );
              when(mockAudioPlayer.processingState).thenAnswer(
                (realInvocation) => ProcessingState.ready,
              );
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToNext();
              await radioViewModel.skipToPrevious();
              // assert
              expect(radioViewModel.isLastAudioChannel, false);
              expect(radioViewModel.isFirstAudioChannel, true);
              expect(radioViewModel.currentRadioChannelIndex, 0);
              expect(radioViewModel.currentRadioChannel,
                  quranRadioModel.radios![0]);
              verify(mockAudioPlayer.stop()).called(2);
              verify(mockAudioPlayer.seekToPrevious()).called(1);
            },
          );
          test(
            "Testing skipToPrevious() method, that audio player will move to the previous channel when the first audio channel NOT reached and the audio player is playing",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [...quranRadioModel.radios!]));
              when(mockAudioPlayer.playing).thenAnswer(
                (realInvocation) => true,
              );
              when(mockAudioPlayer.processingState).thenAnswer(
                (realInvocation) => ProcessingState.ready,
              );
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToNext();
              await radioViewModel.skipToPrevious();
              // assert
              expect(radioViewModel.isLastAudioChannel, false);
              expect(radioViewModel.isFirstAudioChannel, true);
              expect(radioViewModel.currentRadioChannelIndex, 0);
              expect(radioViewModel.currentRadioChannel,
                  quranRadioModel.radios![0]);
              verifyNever(mockAudioPlayer.stop());
              verify(mockAudioPlayer.seekToPrevious()).called(1);
            },
          );
          test(
            "Testing skipToPrevious() method, that audio player will move to the previous channel when the first audio channel NOT reached and the audio player is playing",
            () async {
              // arrange
              const String languageCode = "ar";
              provideDummy<ApiResult<List<RadioChannel>>>(
                  Success(data: [...quranRadioModel.radios!]));
              when(mockAudioPlayer.playing).thenThrow(
                (realInvocation) => somethingWentWrongException,
              );
              // act
              await radioViewModel.getQuranRadioChannels(languageCode);
              await radioViewModel.skipToNext();
              await radioViewModel.skipToPrevious();
              // assert
              expect(radioViewModel.isLastAudioChannel, false);
              expect(radioViewModel.currentRadioChannelIndex, 0);
              expect(radioViewModel.currentRadioChannel,
                  quranRadioModel.radios![0]);
              verifyNever(mockAudioPlayer.stop());
              verifyNever(mockAudioPlayer.seekToPrevious());
              verify(customToasts.showErrorToast(argThat(
                  equals(appLocalizations.errorMovingToPreviousChannel))));
            },
          );
        },
      );
    },
  );
}
