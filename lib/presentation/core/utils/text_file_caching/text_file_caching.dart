import 'package:injectable/injectable.dart';
import 'package:islamy_app/di.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_file/stash_file.dart';

@module
abstract class TextFileCaching {
  @preResolve
  Future<Cache<String>> createFileCache() async {
    final dir = await getApplicationDocumentsDirectory();

    final store = await newFileLocalCacheStore(
      path: dir.path,
    );

    final cache = store.cache<String>(
        name: 'surahHadeethTextCache',
        expiryPolicy: const CreatedExpiryPolicy(Duration(days: 15)),
        maxEntries: 30 // Limit to 50 items
        );

    return cache;
  }

  static Future<String?> getCachedText(String textKey) {
    final Cache<String> fileCache = getIt.get<Cache<String>>();
    return fileCache.get(textKey);
  }

  static Future<void> cacheText(String textKey, String text) {
    final Cache<String> fileCache = getIt.get<Cache<String>>();
    return fileCache.put(textKey, text);
  }
}
