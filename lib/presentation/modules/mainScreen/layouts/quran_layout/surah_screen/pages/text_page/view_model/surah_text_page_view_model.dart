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

  BaseViewState<List<List<String>>> surahVersesState = IdleState();
  BaseViewState<List<List<String>>> doaState = IdleState();

  void readSurah({required int surahIndex, bool loadEnSurahToo = false}) async {
    try {
      surahVersesState = LoadingState();
      notifyListeners();
      List<String> arSurahVersesList = [];
      List<String> enSurahVersesList = [];
      var [arSurahKey, enSurahKey] = <String>[
        AssetsPaths.getArSurahTextFile(surahIndex + 1),
        loadEnSurahToo ? AssetsPaths.getEnSurahTextFile(surahIndex + 1) : ""
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
          loadEnSurahToo
              ? GzipDecompressor.loadCompressedInBackground(
                  AssetsPaths.getEnSurahTextFile(surahIndex + 1))
              : Future.value("")
        ]);
        await _cachingFile.put(arSurahKey, arSurah.trim());
        if (loadEnSurahToo) await _cachingFile.put(enSurahKey, enSurah.trim());
        arSurahVersesList = arSurah.trim().split('\n');
        if (loadEnSurahToo) enSurahVersesList = enSurah.trim().split('\n');
      }
      arSurahVersesList = arSurahVersesList.map((e) => e = e.trim()).toList();
      if (loadEnSurahToo) {
        enSurahVersesList = enSurahVersesList.map((e) => e = e.trim()).toList();
      }
      surahVersesState =
          SuccessState(data: [arSurahVersesList, enSurahVersesList]);
    } catch (e) {
      debugPrint(e.toString());
      surahVersesState =
          ErrorState(codeError: CodeError(exception: Exception(e.toString())));
    } finally {
      notifyListeners();
    }
  }

  void readDoa({bool loadEnDoaToo = false}) async {
    try {
      doaState = LoadingState();
      notifyListeners();
      List<String> eachArDoaLine = [];
      List<String> eachEnDoaLine = [];
      var [arDoaKey, enDoaKey] = [
        AssetsPaths.arDoaCompletingTheQuran,
        loadEnDoaToo ? AssetsPaths.enDoaCompletingTheQuran : ""
      ]
          .map(
            (e) => e.split('/').last.replaceAll(RegExp(r'.gz'), ''),
          )
          .toList();

      String? cachedArDoa = await _cachingFile.get(arDoaKey);
      String? cachedEnDoa =
          loadEnDoaToo ? await _cachingFile.get(enDoaKey) : null;

      if (cachedArDoa != null && (cachedEnDoa != null || !loadEnDoaToo)) {
        eachArDoaLine = cachedArDoa.split("۞");
        eachEnDoaLine = loadEnDoaToo ? cachedEnDoa!.split("۞") : [];
      } else {
        var [arDoa, enDoa] = await Future.wait([
          GzipDecompressor.loadCompressedInBackground(
              AssetsPaths.arDoaCompletingTheQuran),
          loadEnDoaToo
              ? GzipDecompressor.loadCompressedInBackground(
                  AssetsPaths.enDoaCompletingTheQuran)
              : Future.value("")
        ]);
        await _cachingFile.put(arDoaKey, arDoa.trim());
        if (loadEnDoaToo) await _cachingFile.put(enDoaKey, enDoa.trim());
        eachArDoaLine = arDoa.trim().split("۞");
        if (loadEnDoaToo) eachEnDoaLine = enDoa.trim().split("۞");
      }
      eachArDoaLine = eachArDoaLine.map(
        (e) {
          return e = e.trim();
        },
      ).toList();
      if (loadEnDoaToo) {
        eachEnDoaLine = eachEnDoaLine.map(
          (e) {
            return e = e.trim();
          },
        ).toList();
      }
      doaState = SuccessState(data: [eachArDoaLine, eachEnDoaLine]);
    } catch (e) {
      debugPrint(e.toString());
      doaState =
          ErrorState(codeError: CodeError(exception: Exception(e.toString())));
    } finally {
      notifyListeners();
    }
  }
}
