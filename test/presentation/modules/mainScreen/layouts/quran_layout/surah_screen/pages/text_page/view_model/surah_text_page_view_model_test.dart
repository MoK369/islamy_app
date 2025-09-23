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
  const completingQuranArDoa =
      """اللَّهُمَّ ارْحَمْنِي بالقُرْءَانِ وَاجْعَلهُ لِي إِمَاماً وَنُوراً وَهُدًى وَرَحْمَةً
اللَّهُمَّ ذَكِّرْنِي مِنْهُ مَانَسِيتُ وَعَلِّمْنِي مِنْهُ مَاجَهِلْتُ وَارْزُقْنِي تِلاَوَتَهُ آنَاءَ اللَّيْلِ وَأَطْرَافَ النَّهَارِ وَاجْعَلْهُ لِي حُجَّةً يَارَبَّ العَالَمِينَ
اللَّهُمَّ أَصْلِحْ لِي دِينِي الَّذِي هُوَ عِصْمَةُ أَمْرِي وَأَصْلِحْ لِي دُنْيَايَ الَّتِي فِيهَا مَعَاشِي وَأَصْلِحْ لِي آخِرَتِي الَّتِي فِيهَا مَعَادِي وَاجْعَلِ الحَيَاةَ زِيَادَةً لِي فِي كُلِّ خَيْرٍ وَاجْعَلِ المَوْتَ رَاحَةً لِي مِنْ كُلِّ شَرٍّ
اللَّهُمَّ اجْعَلْ خَيْرَ عُمْرِي آخِرَهُ وَخَيْرَ عَمَلِي خَوَاتِمَهُ وَخَيْرَ أَيَّامِي يَوْمَ أَلْقَاكَ فِيهِ
اللَّهُمَّ إِنِّي أَسْأَلُكَ عِيشَةً هَنِيَّةً وَمِيتَةً سَوِيَّةً وَمَرَدًّا غَيْرَ مُخْزٍ وَلاَ فَاضِحٍ
اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ المَسْأَلةِ وَخَيْرَ الدُّعَاءِ وَخَيْرَ النَّجَاحِ وَخَيْرَ العِلْمِ وَخَيْرَ العَمَلِ وَخَيْرَ  الثَّوَابِ وَخَيْرَ الحَيَاةِ وَخيْرَ المَمَاتِ وَثَبِّتْنِي وَثَقِّلْ مَوَازِينِي وَحَقِّقْ إِيمَانِي وَارْفَعْ دَرَجَتِي وَتَقَبَّلْ صَلاَتِي وَاغْفِرْ خَطِيئَاتِي وَأَسْأَلُكَ العُلَا مِنَ الجَنَّةِ
اللَّهُمَّ إِنِّي أَسْأَلُكَ مُوجِبَاتِ رَحْمَتِكَ وَعَزَائِمِ مَغْفِرَتِكَ وَالسَّلاَمَةَ مِنْ كُلِّ إِثْمٍ وَالغَنِيمَةَ مِنْ كُلِّ بِرٍّ وَالفَوْزَ بِالجَنَّةِ وَالنَّجَاةَ مِنَ النَّارِ
اللَّهُمَّ أَحْسِنْ عَاقِبَتَنَا فِي الأُمُورِ كُلِّهَا وَأجِرْنَا مِنْ خِزْيِ الدُّنْيَا وَعَذَابِ الآخِرَةِ
اللَّهُمَّ اقْسِمْ لَنَا مِنْ خَشْيَتِكَ مَاتَحُولُ بِهِ بَيْنَنَا وَبَيْنَ مَعْصِيَتِكَ وَمِنْ طَاعَتِكَ مَاتُبَلِّغُنَا بِهَا جَنَّتَكَ وَمِنَ اليَقِينِ مَاتُهَوِّنُ بِهِ عَلَيْنَا مَصَائِبَ الدُّنْيَا وَمَتِّعْنَا بِأَسْمَاعِنَا وَأَبْصَارِنَا وَقُوَّتِنَا مَاأَحْيَيْتَنَا وَاجْعَلْهُ الوَارِثَ مِنَّا وَاجْعَلْ ثَأْرَنَا عَلَى مَنْ ظَلَمَنَا وَانْصُرْنَا عَلَى مَنْ عَادَانَا وَلاَ تجْعَلْ مُصِيبَتَنَا فِي دِينِنَا وَلاَ تَجْعَلِ الدُّنْيَا أَكْبَرَ هَمِّنَا وَلَا مَبْلَغَ عِلْمِنَا وَلاَ تُسَلِّطْ عَلَيْنَا مَنْ لَا يَرْحَمُنَا
اللَّهُمَّ لَا تَدَعْ لَنَا ذَنْبًا إِلَّا غَفَرْتَهُ وَلَا هَمَّا إِلَّا فَرَّجْتَهُ وَلَا دَيْنًا إِلَّا قَضَيْتَهُ وَلَا حَاجَةً مِنْ حَوَائِجِ الدُّنْيَا وَالآخِرَةِ إِلَّا قَضَيْتَهَا يَاأَرْحَمَ الرَّاحِمِينَ
رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ وَصَلَّى اللهُ عَلَى سَيِّدِنَا وَنَبِيِّنَا مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ الأَخْيَارِ وَسَلَّمَ تَسْلِيمًا كَثِيراً.
""";
  const completingQuranEnDoa =
      """Oh God have mercy on me with the Quran and make it for me an imam, light, guidance and mercy
Oh God remind me of him what I forgot and teach me from him what I did not know and grant me his recitation at night and the edges of the day and make it my excuse Oh God of the worlds
Oh God, fix for me my religion, which is my infallibility, and fix for me my world, which contains my pension, and fix for me my hereafter, which contains my hostility, and make life an increase for me in all good, and make death a rest for me from all evil
Oh God make the best of my life the end of it and the best of my work its ends and the best of my days the day I meet you
Oh God, I ask you to live a good life and die together and a return that is not shameful or revealing
Oh God, I ask you the best of the matter, the best of supplication, the best of success, the best of knowledge, the best of work, the best of reward, the best of life, the best of death, the steadfastness of me, the weight of my scales, the achievement of my faith, raise my degree, accept my prayers, forgive my sins, and ask you the highest from Paradise
O God, I ask You for Your mercy, the intentions of Your forgiveness, safety from all iniquity, booty from all righteousness, winning Paradise and deliverance from Hell.
Oh God, improve our punishment in all things and protect us from the shame of this world and the torture of the hereafter
Oh God, divide for us from your fear what you prevent between us and your disobedience, and from your obedience what your paradise will inform us of, and from certainty what the calamities of the world will be easy for us, and our enjoyment of our hearing, our sights, and our strength, what revives us, and make him our inheritor and make our revenge on those who wronged us, and make us victorious over our enemies, and do not make our disaster in our religion, and do not make the world our biggest concern, nor the amount of our knowledge, nor You dominate us who do not have mercy on us
O God, do not leave us a sin except his forgiveness, and they are nothing but his relief, and no religion except his cause, and none of the needs of this world and the hereafter except its cause, O Most Merciful of the Merciful
Our Lord has brought us good in this world and in the hereafter is good and saved us from the torment of fire, and may Allah's prayers be upon our master and prophet Muhammad and his family and good companions.
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
  group(
    "Testing readDoa() method of SurahTextViewModel",
    () {
      group(
        "with reading ar Doa only",
        () {
          test(
            "Testing the readDoa() method to read a the ar Doa successfully and that Doa text isn't cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>()))).thenAnswer(
                (realInvocation) => Future.value(null),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingDoaStates = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingDoaStates.add(surahTextPageViewModel.doaState);
                },
              );
              await surahTextPageViewModel.readDoa();
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              verify(stringCaching.put(
                      argThat(isA<String>()), argThat(isA<String>())))
                  .called(1);
              expect(readingDoaStates.length, 2);
              expect(readingDoaStates.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingDoaStates.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n'),
                  completingQuranArDoa.trim());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .length,
                  0);
            },
          );
          test(
            "Testing the readDoa() method to read a the ar surah successfully and that Doa text is cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>()))).thenAnswer(
                (realInvocation) => Future.value(completingQuranArDoa),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingDoaStates = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingDoaStates.add(surahTextPageViewModel.doaState);
                },
              );
              await surahTextPageViewModel.readDoa();
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              verifyNever(stringCaching.put(
                  argThat(isA<String>()), argThat(isA<String>())));
              expect(readingDoaStates.length, 2);
              expect(readingDoaStates.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingDoaStates.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n')
                      .trim(),
                  completingQuranArDoa.trim());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .length,
                  0);
            },
          );
          test(
            "Testing the readDoa() method to read the ar Doa when a failure happens",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>())))
                  .thenThrow(readingException);
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingDoaStates = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingDoaStates.add(surahTextPageViewModel.doaState);
                },
              );
              await surahTextPageViewModel.readDoa();
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              expect(readingDoaStates.length, 2);
              expect(readingDoaStates.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(
                  readingDoaStates.last, isA<ErrorState<List<List<String>>>>());
              expect(
                  (readingDoaStates.last as ErrorState<List<List<String>>>)
                      .codeError
                      ?.exception,
                  isNot(Null));
              expect(
                  (readingDoaStates.last as ErrorState<List<List<String>>>)
                      .codeError
                      ?.exception
                      .toString(),
                  readingException.toString());
            },
          );
        },
      );
      group(
        "with reading both ar and en Doas",
        () {
          test(
            "Testing the readDoa() method to read the ar and en Doas successfully and that doa texts aren't cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>()))).thenAnswer(
                (realInvocation) => Future.value(null),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingDoaStates = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingDoaStates.add(surahTextPageViewModel.doaState);
                },
              );
              await surahTextPageViewModel.readDoa(loadEnDoaToo: true);
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(2);
              verify(stringCaching.put(
                      argThat(isA<String>()), argThat(isA<String>())))
                  .called(2);
              expect(readingDoaStates.length, 2);
              expect(readingDoaStates.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingDoaStates.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n'),
                  completingQuranArDoa.trim());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .join('\n'),
                  completingQuranEnDoa.trim());
            },
          );
          test(
            "Testing the readDoa() method to read the ar and en Doas successfully and that doa texts are cached",
            () async {
              // arrange
              when(stringCaching.get(argThat(predicate<String>(
                (arg) => !arg.contains('en'),
              )))).thenAnswer(
                (realInvocation) => Future.value(completingQuranArDoa),
              );
              when(stringCaching.get(argThat(predicate<String>(
                (arg) => arg.contains('en'),
              )))).thenAnswer(
                (realInvocation) => Future.value(completingQuranEnDoa),
              );
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingDoaStates = [];

              // act
              surahTextPageViewModel.addListener(
                () {
                  readingDoaStates.add(surahTextPageViewModel.doaState);
                },
              );
              await surahTextPageViewModel.readDoa(loadEnDoaToo: true);

              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(2);
              verifyNever(stringCaching.put(
                  argThat(isA<String>()), argThat(isA<String>())));
              expect(readingDoaStates.length, 2);
              expect(readingDoaStates.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(readingDoaStates.last,
                  isA<SuccessState<List<List<String>>>>());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .first
                      .join('\n')
                      .trim(),
                  completingQuranArDoa.trim());
              expect(
                  (readingDoaStates.last as SuccessState<List<List<String>>>)
                      .data
                      .last
                      .join('\n')
                      .trim(),
                  completingQuranEnDoa.trim());
            },
          );
          test(
            "Testing the readDoa() method to read the ar and en Doas when a failure happens",
            () async {
              // arrange
              when(stringCaching.get(argThat(isA<String>())))
                  .thenThrow(readingException);
              WidgetsFlutterBinding.ensureInitialized();
              List<BaseViewState<List<List<String>>>> readingDoaStates = [];
              // act
              surahTextPageViewModel.addListener(
                () {
                  readingDoaStates.add(surahTextPageViewModel.doaState);
                },
              );
              await surahTextPageViewModel.readDoa(loadEnDoaToo: true);
              // assert
              verify(stringCaching.get(argThat(isA<String>()))).called(1);
              expect(readingDoaStates.length, 2);
              expect(readingDoaStates.first,
                  isA<LoadingState<List<List<String>>>>());
              expect(
                  readingDoaStates.last, isA<ErrorState<List<List<String>>>>());
              expect(
                  (readingDoaStates.last as ErrorState<List<List<String>>>)
                      .codeError
                      ?.exception,
                  isNot(Null));
              expect(
                  (readingDoaStates.last as ErrorState<List<List<String>>>)
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
