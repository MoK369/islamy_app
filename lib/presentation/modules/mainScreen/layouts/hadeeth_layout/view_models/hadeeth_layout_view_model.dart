import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/core/utils/gzip_decompressor/gzip_decompressor.dart';
import 'package:islamy_app/presentation/core/utils/text_file_caching/text_file_caching.dart';

@injectable
class HadeethLayoutViewModel extends ChangeNotifier {
  BaseViewState<List<HadethData>> readAhadeethState =
      LoadingState<List<HadethData>>();

  void readAhadeeth() async {
    try {
      readAhadeethState = LoadingState<List<HadethData>>();
      notifyListeners();
      String ahadeethKey = AssetsPaths.ahadeethTextFile
          .split('/')
          .last
          .replaceAll(RegExp(r'.gz'), '');
      String? cachedAhadeeth = await TextFileCaching.getCachedText(ahadeethKey);
      List<String> eachHadeethList = [];
      if (cachedAhadeeth != null) {
        eachHadeethList = cachedAhadeeth.split('#');
      } else {
        String hadeeths = await GzipDecompressor.loadCompressedInBackground(
            AssetsPaths.ahadeethTextFile);
        await TextFileCaching.cacheText(ahadeethKey, hadeeths.trim());
        eachHadeethList = hadeeths.trim().split('#');
      }
      List<HadethData> ahadeeth = [];
      for (int i = 0; i < eachHadeethList.length; i++) {
        List<String> singleHadeeth = eachHadeethList[i].trim().split('\n');
        String hadethTitle = singleHadeeth[0];
        singleHadeeth.removeAt(0);
        String hadeethBody = singleHadeeth.join(' ');
        HadethData h =
            HadethData(hadeethTitle: hadethTitle, hadeethBody: hadeethBody);
        ahadeeth.add(h);
        readAhadeethState = SuccessState<List<HadethData>>(data: ahadeeth);
      }
    } catch (e) {
      readAhadeethState = ErrorState<List<HadethData>>(
          codeError: CodeError(exception: Exception(e.toString())));
    } finally {
      notifyListeners();
    }
  }
}

class HadethData {
  String hadeethTitle;
  String hadeethBody;

  HadethData({required this.hadeethTitle, required this.hadeethBody});
}
