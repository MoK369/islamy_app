import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';

@singleton
class ApiManager {
  static final Dio dio = Dio();
  static const String baseUrl = "mp3quran.net";
  static const String quranRadioEndPoint = "/api/v3/radios";

  Future<ApiResult<List<RadioChannel>>> getQuranRadioChannels(
      String languageCode) async {
    try {
      Uri url =
          Uri.http(baseUrl, quranRadioEndPoint, {"language": languageCode});
      final response = await dio.getUri(url);
      QuranRadioModel quranRadioModel = QuranRadioModel.fromJson(response.data);
      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return Success(data: quranRadioModel.radios ?? []);
      } else {
        return ServerError(code: -1, message: "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }
}
