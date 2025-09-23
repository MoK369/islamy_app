import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/core/utils/gzip_decompressor/gzip_decompressor.dart';
import 'package:stash/stash_api.dart';

@injectable
class HadeethLayoutViewModel extends ChangeNotifier {
  final Cache<String> _cachingFile;

  HadeethLayoutViewModel(this._cachingFile);
  BaseViewState<List<HadethData>> readAhadeethState =
      LoadingState<List<HadethData>>();

  Future<void> readAhadeeth() async {
    Completer<void> readingDoneCompleter = Completer();
    try {
      readAhadeethState = LoadingState<List<HadethData>>();
      notifyListeners();
      String ahadeethKey = AssetsPaths.ahadeethTextFile
          .split('/')
          .last
          .replaceAll(RegExp(r'.gz'), '');
      String? cachedAhadeeth = await _cachingFile.get(ahadeethKey);
      List<String> eachHadeethList = [];
      if (cachedAhadeeth != null) {
        eachHadeethList = cachedAhadeeth.split('#');
      } else {
        String hadeeths = await GzipDecompressor.loadCompressedInBackground(
            AssetsPaths.ahadeethTextFile);
        await _cachingFile.put(ahadeethKey, hadeeths.trim());
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
      debugPrint("=======${e.toString()}=======");
      readAhadeethState = e is Exception
          ? ErrorState<List<HadethData>>(codeError: CodeError(exception: e))
          : ErrorState<List<HadethData>>(
              codeError: CodeError(exception: Exception(e.toString())));
    } finally {
      notifyListeners();
      readingDoneCompleter.complete();
    }
    return await readingDoneCompleter.future;
  }
}

class HadethData {
  String hadeethTitle;
  String hadeethBody;

  HadethData({required this.hadeethTitle, required this.hadeethBody});
}
