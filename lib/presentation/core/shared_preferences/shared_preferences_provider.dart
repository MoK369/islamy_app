import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class SharedPreferencesProvider {
  @preResolve
  Future<SharedPreferences> provide() {
    return SharedPreferences.getInstance();
  }
}
