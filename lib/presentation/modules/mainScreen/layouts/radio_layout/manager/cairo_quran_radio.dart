abstract class CairoQuranRadio {
  static num id = 0;
  static String urlStr = "https://stream.radiojar.com/8s5u5tpdtwzuv";

  static String title(String languageCode) {
    if (languageCode == "ar") {
      return "إذاعة القران الكريم القاهرة";
    } else {
      return "Radio Quran Kareem Cairo";
    }
  }
}
