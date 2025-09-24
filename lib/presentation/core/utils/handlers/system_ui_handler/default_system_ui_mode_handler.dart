import 'package:flutter/src/services/system_chrome.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/presentation/core/utils/handlers/system_ui_handler/system_ui_mode_handler.dart';

@Injectable(as: SystemUiModeHandler)
class DefaultSystemUiModeHandler implements SystemUiModeHandler {
  @override
  Future<void> setEnabledSystemUIMode(SystemUiMode mode) {
    return SystemChrome.setEnabledSystemUIMode(mode);
  }
}
