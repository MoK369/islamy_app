import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/core/utils/gzip_decompressor/gzip_decompressor.dart';
import 'package:stash/stash_api.dart';

@injectable
class SurahTextPageViewModel extends ChangeNotifier {
  final Cache<String> _cachingFile;

  SurahTextPageViewModel(this._cachingFile);

  BaseViewState<List<List<String>>> surahVerses = IdleState();

  void readSurah({required int surahIndex, bool loadEnSurahToo = false}) async {
    try {
      surahVerses = LoadingState();
      notifyListeners();
      List<String> arSurahVersesList = [];
      List<String> enSurahVersesList = [];
      var [arSurahKey, enSurahKey] = <String>[
        AssetsPaths.getArSurahTextFile(surahIndex + 1),
        if (loadEnSurahToo) AssetsPaths.getEnSurahTextFile(surahIndex + 1)
      ].map((e) => e.split("/").last.replaceAll(RegExp(r'.gz'), '')).toList();
      String? cachedArSurah = await _cachingFile.get(arSurahKey);
      String? cachedEnSurah =
          loadEnSurahToo ? await _cachingFile.get(enSurahKey) : null;

      if (cachedArSurah != null && (cachedEnSurah != null || !loadEnSurahToo)) {
        arSurahVersesList = cachedArSurah.split('\n');
        enSurahVersesList = loadEnSurahToo ? cachedEnSurah!.split('\n') : [];
      } else {
        var [arSurah, enSurah] = await Future.wait([
          GzipDecompressor.loadCompressedInBackground(
              AssetsPaths.getArSurahTextFile(surahIndex + 1)),
          if (loadEnSurahToo)
            GzipDecompressor.loadCompressedInBackground(
                AssetsPaths.getEnSurahTextFile(surahIndex + 1))
        ]);
        print("enSurah: $enSurah");
        await _cachingFile.put(arSurahKey, arSurah.trim());
        if (loadEnSurahToo) await _cachingFile.put(enSurahKey, enSurah.trim());
        arSurahVersesList = arSurah.trim().split('\n');
        if (loadEnSurahToo) enSurahVersesList = enSurah.trim().split('\n');
      }
      arSurahVersesList = arSurahVersesList.map((e) => e = e.trim()).toList();
      if (loadEnSurahToo) {
        enSurahVersesList = enSurahVersesList.map((e) => e = e.trim()).toList();
      }
      surahVerses = SuccessState(
          data: [arSurahVersesList, if (loadEnSurahToo) enSurahVersesList]);
    } catch (e) {
      surahVerses =
          ErrorState(codeError: CodeError(exception: Exception(e.toString())));
    } finally {
      notifyListeners();
    }
  }

// void readEnSurah() async {
//   String enSurahKey =
//       AssetsPaths.getEnSurahTextFile(widget.args.surahIndex + 1)
//           .split('/')
//           .last
//           .replaceAll(RegExp(r'.gz'), '');
//   String? cachedSurah = await TextFileCaching.getCachedText(enSurahKey);
//
//   if (cachedSurah != null) {
//     enSurahVerses = cachedSurah.split('\n');
//   } else {
//     String enSurah = await GzipDecompressor.loadCompressedInBackground(
//         AssetsPaths.getEnSurahTextFile(widget.args.surahIndex + 1));
//     await TextFileCaching.cacheText(enSurahKey, enSurah.trim());
//     enSurahVerses = enSurah.trim().split('\n');
//   }
//
//   setState(() {
//     enSurahVerses = enSurahVerses.map((e) => e = e.trim()).toList();
//   });
// }

// void readArDoa() async {
//   String doaKey = AssetsPaths.arDoaCompletingTheQuran
//       .split('/')
//       .last
//       .replaceAll(RegExp(r'.gz'), '');
//
//   String? cachedDoa = await TextFileCaching.getCachedText(doaKey);
//
//   if (cachedDoa != null) {
//     eachDoaLine = cachedDoa.split("۞");
//   } else {
//     String doa = await GzipDecompressor.loadCompressedInBackground(
//         AssetsPaths.arDoaCompletingTheQuran);
//     await TextFileCaching.cacheText(doaKey, doa.trim());
//     eachDoaLine = doa.trim().split("۞");
//   }
//
//   setState(() {
//     eachDoaLine = eachDoaLine.map(
//       (e) {
//         return e = e.trim();
//       },
//     ).toList();
//   });
// }
//
// void readEnDoa() async {
//   String enDoaKey = AssetsPaths.enDoaCompletingTheQuran
//       .split('/')
//       .last
//       .replaceAll(RegExp(r'.gz'), '');
//
//   String? cachedDoa = await TextFileCaching.getCachedText(enDoaKey);
//
//   if (cachedDoa != null) {
//     eachEnDoaLine = cachedDoa.split("۞");
//   } else {
//     String doa = await GzipDecompressor.loadCompressedInBackground(
//         AssetsPaths.enDoaCompletingTheQuran);
//     await TextFileCaching.cacheText(enDoaKey, doa);
//     eachEnDoaLine = doa.trim().split("۞");
//   }
//
//   setState(() {
//     eachEnDoaLine = eachEnDoaLine.map(
//       (e) {
//         return e = e.trim();
//       },
//     ).toList();
//   });
// }
}
