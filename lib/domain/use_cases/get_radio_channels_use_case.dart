import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart';

import '../../presentation/modules/mainScreen/layouts/radio_layout/manager/cairo_quran_radio.dart';

@injectable
class GetRadioChannelsUseCase {
  final QuranRadioChannelsRepository _quranRadioChannelsRepository;

  GetRadioChannelsUseCase(this._quranRadioChannelsRepository);

  Future<ApiResult<List<RadioChannel>>> call(String languageCode) async {
    var quranRadioRepoResult =
        await _quranRadioChannelsRepository.getQuranRadioChannels(languageCode);

    switch (quranRadioRepoResult) {
      case Success<List<RadioChannel>>():
        quranRadioRepoResult.data.insert(
            0,
            RadioChannel(
                id: CairoQuranRadio.id,
                name: CairoQuranRadio.title(languageCode),
                url: CairoQuranRadio.urlStr));
        break;
      case ServerError<List<RadioChannel>>():
      case CodeError<List<RadioChannel>>():
        break;
    }
    return quranRadioRepoResult;
  }
}
