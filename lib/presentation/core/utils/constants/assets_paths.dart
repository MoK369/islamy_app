abstract class AssetsPaths {
  static const String _ayatNumberIcon = "assets/icons/ayat_number_icon.webp";
  static const String _bodyOfSebha = "assets/icons/body_of_sebha.webp";
  static const String _hadeethIcon = "assets/icons/hadeeth_icon.webp";
  static const String _headOfSebha = "assets/icons/head_of_sebha.webp";
  static const String _iconNext = "assets/icons/icon_next.webp";
  static const String _iconPlay = "assets/icons/icon_play.webp";
  static const String _iconPrevious = "assets/icons/icon_previous.webp";
  static const String _launcherIcon = "assets/icons/launcher_icon.webp";
  static const String _quranHeaderIcon = "assets/icons/quran_header_icon.webp";
  static const String _quranIcon = "assets/icons/quran_icon.webp";
  static const String _radioIcon = "assets/icons/radio_icon.webp";
  static const String _sebhaIcon = "assets/icons/sebha_icon.webp";
  static const String _bgImage = "assets/images/bg.webp";
  static const String _bgDarkImage = "assets/images/bg_dark.webp";
  static const String _bgPlashImage = "assets/images/bg_splash.webp";
  static const String _bgPlashDarkImage = "assets/images/bg_splash_dark.webp";
  static const String _brandingImage = "assets/images/branding.webp";
  static const String _brandingDarkImage = "assets/images/branding_dark.webp";
  static const String _hadithHeaderImage = "assets/images/hadith_header.webp";
  static const String _logoImage = "assets/images/logo.webp";
  static const String _logBgImage = "assets/images/logo_bg.webp";
  static const String _logDarkImage = "assets/images/logo_dark.webp";
  static const String _radioImage = "assets/images/radio_image.webp";

  static const String _ahadeethTextFile = "assets/hadeeths/ahadeeth.txt";
  static const String _arDoaCompletingTheQuran =
      "assets/doas/doas_text/doa_completing_the_quran.txt";
  static const String _enDoaCompletingTheQuran =
      "assets/doas/doas_text/doa_completing_the_quran_en.txt";
  static const String _doasPDFFile =
      "assets/doas/doas_pdf/doa_completing_the_quran.pdf";
  static const String _surasPDFFile = "assets/suras/suras_pdf/E-Quran.pdf";

  static String getArSurahTextFile(int surahNumber) {
    return "assets/suras/suras_text/$surahNumber.txt";
  }

  static String getEnSurahTextFile(int surahNumber) {
    return "assets/suras/suras_text/${surahNumber}_en.txt";
  }

  static String get ayatNumberIcon => _ayatNumberIcon;

  static String get bodyOfSebha => _bodyOfSebha;

  static String get radioImage => _radioImage;

  static String get logDarkImage => _logDarkImage;

  static String get logBgImage => _logBgImage;

  static String get logoImage => _logoImage;

  static String get hadithHeaderImage => _hadithHeaderImage;

  static String get brandingDarkImage => _brandingDarkImage;

  static String get brandingImage => _brandingImage;

  static String get bgPlashDarkImage => _bgPlashDarkImage;

  static String get bgPlashImage => _bgPlashImage;

  static String get bgDarkImage => _bgDarkImage;

  static String get bgImage => _bgImage;

  static String get sebhaIcon => _sebhaIcon;

  static String get radioIcon => _radioIcon;

  static String get quranIcon => _quranIcon;

  static String get quranHeaderIcon => _quranHeaderIcon;

  static String get launcherIcon => _launcherIcon;

  static String get iconPrevious => _iconPrevious;

  static String get iconPlay => _iconPlay;

  static String get iconNext => _iconNext;

  static String get headOfSebha => _headOfSebha;

  static String get hadeethIcon => _hadeethIcon;

  static String get ahadeethTextFile => _ahadeethTextFile;

  static String get arDoaCompletingTheQuran => _arDoaCompletingTheQuran;

  static String get enDoaCompletingTheQuran => _enDoaCompletingTheQuran;

  static String get doasPDFFile => _doasPDFFile;

  static String get surasPDFFile => _surasPDFFile;
}
