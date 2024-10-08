import 'package:dio/dio.dart';
import 'package:islamy_app/core/models/quran_radio_model.dart';
import 'package:islamy_app/core/services/apis/api_result.dart';

class ApiManager {
  static const String baseUrl = "mp3quran.net";
  static const String quranRadioEndPoint = "/api/v3/radios";

  static Future<ApiResult<List<RadioChannel>>> getQuranRadioChannels(
      String languageCode) async {
    try {
      Uri url =
          Uri.http(baseUrl, quranRadioEndPoint, {"language": languageCode});
      final Dio dio = Dio();
      final response = await dio.getUri(url);
      QuranRadioModel quranRadioModel = QuranRadioModel.fromJson(response.data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Success(data: quranRadioModel.radios ?? []);
      } else {
        return ServerError(code: -1, message: "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }
}
