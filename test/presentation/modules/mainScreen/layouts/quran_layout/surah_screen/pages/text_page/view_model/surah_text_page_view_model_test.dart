import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/pages/text_page/view_model/surah_text_page_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stash/stash_api.dart';

import '../../../../../hadeeth_layout/view_models/hadeeth_layout_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Cache<String>>()])
void main() {
  late MockCache stringCaching;
  late SurahTextPageViewModel surahTextPageViewModel;
  final Exception readingException =
      Exception("something when wrong when reading data");
  const alFathaArSurah = """
بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ
الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ
الرَّحْمَنِ الرَّحِيمِ
مَالِكِ يَوْمِ الدِّينِ
إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ
اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ
صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّين
""";
  const alFathaEnSurah = """
In the Name of Allah—the Most Compassionate, Most Merciful.
All praise is for Allah—Lord of all worlds,
the Most Compassionate, Most Merciful,
Master of the Day of Judgment.
You ˹alone˺ we worship and You ˹alone˺ we ask for help.
Guide us along the Straight Path,
the Path of those You have blessed—not those You are displeased with, or those who are astray.
""";
  setUpAll(
    () {
      stringCaching = MockCache();
    },
  );
  setUp(
    () {
      surahTextPageViewModel = SurahTextPageViewModel(stringCaching);
    },
  );
  group(
    "Testing readSurah() method of SurahTextViewModel",
    () {
      group(
        "with reading ar surahs only",
        () {
          test(
            "Testing the readSurah() method to read a specific ar surah index successfully and that surah text isn't cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>()))).thenAnswer(
                (realInvocation) => Future.value(null),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingSurahStats = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingSurahStats
                      .add(surahTextPageViewModel.surahVersesState);
                },
              );
              await surahTextPageViewModel.readSurah(surahIndex: 0);
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              verify(stringCaching.put(
                      argThat(isA<String>()), argThat(isA<String>())))
                  .called(1);
              expect(readingSurahStats.length, 2);
              expect(readingSurahStats.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingSurahStats.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n'),
                  alFathaArSurah.trim());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .length,
                  0);
            },
          );
          test(
            "Testing the readSurah() method to read a specific ar surah index successfully and that surah text is cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>()))).thenAnswer(
                (realInvocation) => Future.value(alFathaArSurah),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingSurahStats = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingSurahStats
                      .add(surahTextPageViewModel.surahVersesState);
                },
              );
              await surahTextPageViewModel.readSurah(surahIndex: 0);
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              verifyNever(stringCaching.put(
                  argThat(isA<String>()), argThat(isA<String>())));
              expect(readingSurahStats.length, 2);
              expect(readingSurahStats.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingSurahStats.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n')
                      .trim(),
                  alFathaArSurah.trim());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .length,
                  0);
            },
          );
          test(
            "Testing the readSurah() method to read a specific ar surah index when a failure happens",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>())))
                  .thenThrow(readingException);
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingSurahStats = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingSurahStats
                      .add(surahTextPageViewModel.surahVersesState);
                },
              );
              await surahTextPageViewModel.readSurah(surahIndex: 0);
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              expect(readingSurahStats.length, 2);
              expect(readingSurahStats.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingSurahStats.last,
                  isA<ErrorState<List<List<String>>>>());
              expect(
                  (readingSurahStats.last as ErrorState<List<List<String>>>)
                      .codeError
                      ?.exception,
                  isNot(Null));
              expect(
                  (readingSurahStats.last as ErrorState<List<List<String>>>)
                      .codeError
                      ?.exception
                      .toString(),
                  readingException.toString());
            },
          );
        },
      );
      group(
        "with reading both ar and en surahs",
        () {
          test(
            "Testing the readSurah() method to read a specific ar and en surah index successfully and that surah texts aren't cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>()))).thenAnswer(
                (realInvocation) => Future.value(null),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingSurahStats = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingSurahStats
                      .add(surahTextPageViewModel.surahVersesState);
                },
              );
              await surahTextPageViewModel.readSurah(
                  surahIndex: 0, loadEnSurahToo: true);
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(2);
              verify(stringCaching.put(
                      argThat(isA<String>()), argThat(isA<String>())))
                  .called(2);
              expect(readingSurahStats.length, 2);
              expect(readingSurahStats.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingSurahStats.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n'),
                  alFathaArSurah.trim());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .join('\n'),
                  alFathaEnSurah.trim());
            },
          );
          test(
            "Testing the readSurah() method to read a specific ar and en surah index successfully and that surah texts are cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(predicate<String>(
                (arg) => !arg.contains('en'),
              )))).thenAnswer(
                (realInvocation) => Future.value(alFathaArSurah),
              );
              when(stringCaching.get(argThat(predicate<String>(
                (arg) => arg.contains('en'),
              )))).thenAnswer(
                (realInvocation) => Future.value(alFathaEnSurah),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingSurahStats = [];

              // act
              surahTextPageViewModel.addListener(
                () {
                  readingSurahStats
                      .add(surahTextPageViewModel.surahVersesState);
                },
              );
              await surahTextPageViewModel.readSurah(
                  surahIndex: 0, loadEnSurahToo: true);

              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(2);
              verifyNever(stringCaching.put(
                  argThat(isA<String>()), argThat(isA<String>())));
              expect(readingSurahStats.length, 2);
              expect(readingSurahStats.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingSurahStats.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n')
                      .trim(),
                  alFathaArSurah.trim());
              expect(
                  (readingSurahStats.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .join('\n')
                      .trim(),
                  alFathaEnSurah.trim());
            },
          );
          test(
            "Testing the readSurah() method to read a specific ar and en surah index when a failure happens",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>())))
                  .thenThrow(readingException);
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingSurahStats = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingSurahStats
                      .add(surahTextPageViewModel.surahVersesState);
                },
              );
              await surahTextPageViewModel.readSurah(
                  surahIndex: 0, loadEnSurahToo: true);
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              expect(readingSurahStats.length, 2);
              expect(readingSurahStats.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingSurahStats.last,
                  isA<ErrorState<List<List<String>>>>());
              expect(
                  (readingSurahStats.last as ErrorState<List<List<String>>>)
                      .codeError
                      ?.exception,
                  isNot(Null));
              expect(
                  (readingSurahStats.last as ErrorState<List<List<String>>>)
                      .codeError
                      ?.exception
                      .toString(),
                  readingException.toString());
            },
          );
        },
      );
    },
  );
}
