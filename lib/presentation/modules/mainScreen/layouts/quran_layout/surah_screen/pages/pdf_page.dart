import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

class PDFPage extends StatefulWidget {
  final SendSurahInfo args;

  const PDFPage({super.key, required this.args});

  @override
  State<PDFPage> createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  late PdfController pdfController;
  late double sliderCurrentValue;
  late int startPage, endPage;
  late SurahScreenProvider surahScreenProvider;
  late String currentSurahID;

  @override
  void initState() {
    super.initState();
    pdfController = PdfController(
        document: PdfDocument.openAsset(widget.args.surahIndex == 114
            ? "assets/doas/doas_pdf/doa_completing_the_quran.pdf"
            : "assets/suras/suras_pdf/E-Quran.pdf"),
        initialPage: Suras.rangeOfPagesToView[widget.args.surahIndex][0]);
    sliderCurrentValue =
        Suras.rangeOfPagesToView[widget.args.surahIndex][0].toDouble();
    startPage = Suras.rangeOfPagesToView[widget.args.surahIndex][0];
    endPage = Suras.rangeOfPagesToView[widget.args.surahIndex][1];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    surahScreenProvider = Provider.of<SurahScreenProvider>(context);
    currentSurahID = '${widget.args.surahIndex} ${sliderCurrentValue.toInt()}';
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        GestureDetector(
          onTap: () {
            surahScreenProvider.changeSurahOrHadeethScreenAppBarStatus(
                !surahScreenProvider.isSurahOrHadeethScreenAppBarVisible);
          },
          onLongPress: () {
            if (surahScreenProvider.markedSurahPDFPageIndex == currentSurahID) {
              surahScreenProvider.changeMarkedSurahPDFPage('');
            } else if (surahScreenProvider.markedSurahPDFPageIndex == '') {
              surahScreenProvider.changeMarkedSurahPDFPage(currentSurahID);
            } else {
              surahScreenProvider.showAlertAboutMarkedSurahPDFPage(
                  context, theme, currentSurahID);
            }
          },
          child: PdfView(
            controller: pdfController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            builders: PdfViewBuilders<DefaultBuilderOptions>(
              options: const DefaultBuilderOptions(),
              documentLoaderBuilder: (_) => Center(
                  child:
                      CircularProgressIndicator(color: theme.indicatorColor)),
              pageLoaderBuilder: (_) => Center(
                  child:
                      CircularProgressIndicator(color: theme.indicatorColor)),
            ),
            onPageChanged: (page) {
              if (page < startPage) {
                pdfController.jumpToPage(page + 1);
              } else if (page > endPage) {
                pdfController.jumpToPage(page - 1);
              } else {
                setState(() {
                  sliderCurrentValue = page.toDouble();
                });
              }
            },
          ),
        ),
        Visibility(
            visible:
                surahScreenProvider.markedSurahPDFPageIndex == currentSurahID,
            child: Icon(
              Icons.bookmark,
              size: size.height * 0.1,
              color: theme.indicatorColor.withAlpha(125),
            )),
        Positioned(
          width: size.width * 0.95,
          bottom: 5,
          child: Slider(
            allowedInteraction: SliderInteraction.slideThumb,
            divisions: startPage == endPage ? null : (endPage - startPage),
            min: startPage.toDouble(),
            max: startPage == endPage
                ? endPage.toDouble() + 1
                : endPage.toDouble(),
            value: startPage == endPage ? startPage + 1 : sliderCurrentValue,
            label: '${sliderCurrentValue.toInt()}',
            onChanged: (value) {
              setState(() {
                sliderCurrentValue = value;
                pdfController.animateToPage(sliderCurrentValue.toInt(),
                    duration: const Duration(milliseconds: 50),
                    curve: Curves.bounceIn);
              });
            },
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    pdfController.dispose();
  }
}
