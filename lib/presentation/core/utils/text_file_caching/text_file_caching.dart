import 'package:injectable/injectable.dart';
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

    return store.cache<String>(
        name: 'surahHadeethTextCache',
        expiryPolicy: const CreatedExpiryPolicy(Duration(days: 15)),
        maxEntries: 30 // Limit to 50 items
        );
  }
}
