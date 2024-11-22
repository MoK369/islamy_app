import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';

abstract class QuranRadioChannelsRepository {
  Future<ApiResult<List<RadioChannel>>> getQuranRadioChannels(
      String languageCode);
}
