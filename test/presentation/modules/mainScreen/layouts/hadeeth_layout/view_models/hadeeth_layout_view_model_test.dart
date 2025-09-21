import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/view_models/hadeeth_layout_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stash/stash_api.dart';

import 'hadeeth_layout_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Cache<String>>()])
void main() {
  group(
    "Testing HadeethLayoutViewModel",
    () {
      late HadeethLayoutViewModel hadeethLayoutViewModel;
      late MockCache stringCaching;
      String cachedAhadeeth = """
   الحد يث الأول
 عن أمـيـر المؤمنـين عمر بن الخطاب رضي الله عنه ، قال : سمعت رسول الله صلى الله عـليه وسلم يـقـول : ( إنـما الأعـمـال بالنيات وإنـمـا لكـل امـرئ ما نـوى . فمن كـانت هجرته إلى الله ورسولـه فهجرتـه إلى الله ورسـوله ومن كانت هجرته لـدنيا يصـيبها أو امرأة ينكحها فهجرته إلى ما هاجر إليه ).
رواه إمام المحد ثين أبـو عـبـد الله محمد بن إسماعـيل بن ابراهـيـم بن المغـيره بن بـرد زبه البخاري الجعـفي،[رقم:1] وابـو الحسـيـن مسلم بن الحجاج بن مـسلم القـشـيري الـنيسـابـوري [رقم :1907] رضي الله عنهما في صحيحيهما اللذين هما أصح الكتب المصنفه. 
#
الحد يث الثاني
عن عمر رضي الله عنه أيضا ، قال : بينما نحن جلوس عـند رسـول الله صلى الله عليه وسلم ذات يوم اذ طلع علينا رجل شديد بياض الثياب ، شديد سواد الشعر لا يرى عليه أثـر السفر ولا يعـرفه منا احـد. حتى جـلـس إلى النبي صلي الله عليه وسلم فـأسند ركبـتيه إلى ركبتـيه ووضع كفيه على فخذيه، وقـال: " يا محمد أخبرني عن الإسلام ".
فقـال رسـول الله صـلى الله عـليه وسـلـم :(الإسـلام أن تـشـهـد أن لا إلـه إلا الله وأن محـمـد رسـول الله وتـقـيـم الصلاة وتـؤتي الـزكاة وتـصوم رمضان وتـحـج البيت إن اسـتـطـعت اليه سبيلا).
قال : صدقت.
فعجبنا له ، يسأله ويصدقه ‌؟
قال : فأخبرني عن الإيمان .
قال : أن تؤمن بالله وملائكته وكتبه ورسله واليوم الاخر وتؤمن بالقدر خيره وشره .
قال : صدقت .
قال : فأخبرني عن الإحسان .
قال : ان تعبد الله كأنك تراه ، فإن لم تكن تراه فإنه يراك .
قال : فأخبرني عن الساعة .
قال : "ما المسؤول عنها بأعلم من السائل "
قال : فأخبرني عن أماراتها .
قال : " أن تلد الأم ربتها ، وان ترى الحفاة العراة العالة رعاء الشاء يتطاولون في البنيان"
ثم انطلق ، فلبثت مليا ،ثم قال :" يا عمر أتدري من السائل ؟"
قلت : "الله ورسوله أعلم ".
قال : فإنه جبريل ، اتاكم يعلمكم دينكم "رواه مسلم [ رقم : 8 ].
""";
      setUpAll(
        () {
          stringCaching = MockCache();
        },
      );
      setUp(
        () async {
          hadeethLayoutViewModel = HadeethLayoutViewModel(stringCaching);
        },
      );
      test(
          'Test readAhadeeth() method, when reading ahadeeth and not cached in the string caching file',
          () async {
        // arrange
        when(stringCaching.get(argThat(isA<String>())))
            .thenAnswer((realInvocation) => Future.value(null));
        WidgetsFlutterBinding.ensureInitialized();
        // act
        List<BaseViewState<List<HadethData>>> states = [];
        hadeethLayoutViewModel.addListener(
          () {
            states.add(hadeethLayoutViewModel.readAhadeethState);
          },
        );
        await hadeethLayoutViewModel.readAhadeeth();

        expect(states.length, 2);
        expect(states.first, isA<LoadingState<List<HadethData>>>());
        expect(states.last, isA<SuccessState<List<HadethData>>>());
        expect((states.last as SuccessState<List<HadethData>>).data.length, 50);
      });
      test(
          'Test readAhadeeth() method, when reading ahadeeth and cached in the string caching file',
          () async {
        // arrange
        when(stringCaching.get(argThat(isA<String>())))
            .thenAnswer((realInvocation) => Future.value(cachedAhadeeth));
        WidgetsFlutterBinding.ensureInitialized();
        // act
        List<BaseViewState<List<HadethData>>> states = [];
        hadeethLayoutViewModel.addListener(
          () {
            states.add(hadeethLayoutViewModel.readAhadeethState);
          },
        );
        await hadeethLayoutViewModel.readAhadeeth();

        expect(states.length, 2);
        expect(states.first, isA<LoadingState<List<HadethData>>>());
        expect(states.last, isA<SuccessState<List<HadethData>>>());
        expect((states.last as SuccessState<List<HadethData>>).data.length, 2);
      });
      test(
          'Test readAhadeeth() method, when reading ahadeeth and some error happens in this process',
          () async {
        // arrange
        final Exception getCachedStringException =
            Exception("Error retrieving cached string");
        when(stringCaching.get(argThat(isA<String>())))
            .thenThrow(getCachedStringException);
        WidgetsFlutterBinding.ensureInitialized();
        // act
        List<BaseViewState<List<HadethData>>> states = [];
        hadeethLayoutViewModel.addListener(
          () {
            states.add(hadeethLayoutViewModel.readAhadeethState);
          },
        );
        await hadeethLayoutViewModel.readAhadeeth();

        expect(states.length, 2);
        expect(states.first, isA<LoadingState<List<HadethData>>>());
        expect(states.last, isA<ErrorState<List<HadethData>>>());
        expect(
            (states.last as ErrorState<List<HadethData>>).codeError?.exception,
            isNot(Null));
        expect(
            (states.last as ErrorState<List<HadethData>>)
                .codeError
                ?.exception
                .toString(),
            getCachedStringException.toString());
      });
    },
  );
}
