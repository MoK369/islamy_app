import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
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
  late int markedPageNumber;

  @override
  void initState() {
    super.initState();
    pdfController = PdfController(
      document: PdfDocument.openAsset(widget.args.surahIndex == 114
          ? AssetsPaths.doasPDFFile
          : AssetsPaths.surasPDFFile),
      initialPage: Suras.rangeOfPagesToView[widget.args.surahIndex][0],
    );
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
    markedPageNumber = int.tryParse(
            surahScreenProvider.markedSurahPDFPageIndex.split(' ').last) ??
        -1;
    return SafeArea(
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              surahScreenProvider.changeSurahOrHadeethScreenAppBarStatus(
                  !surahScreenProvider.isSurahOrHadeethScreenAppBarVisible);
            },
            onLongPress: () {
              if (surahScreenProvider.markedSurahPDFPageIndex ==
                  currentSurahID) {
                surahScreenProvider.changeMarkedSurahPDFPage('');
              } else if (surahScreenProvider.markedSurahPDFPageIndex == '') {
                surahScreenProvider.changeMarkedSurahPDFPage(currentSurahID);
              } else {
                surahScreenProvider.showAlertAboutMarkedSurahPDFPage(
                    theme, currentSurahID);
              }
            },
            child: PdfView(
              controller: pdfController,
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              renderer: (page) {
                return page.render(
                  width: page.width * 2,
                  height: page.height * 2,
                  format: PdfPageImageFormat.webp,
                  backgroundColor: '#FFFFFF',
                );
              },
              builders: PdfViewBuilders<DefaultBuilderOptions>(
                options: const DefaultBuilderOptions(),
                documentLoaderBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                pageLoaderBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
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
          if (markedPageNumber >= startPage && markedPageNumber <= endPage)
            Positioned(
              top: 5,
              child: Center(
                  child: IconButton(
                      onPressed: () {
                        pdfController.jumpToPage(markedPageNumber);
                      },
                      icon: const Icon(Icons.flag))),
            ),
          Positioned(
            left: 3,
            child: Visibility(
                visible: surahScreenProvider.markedSurahPDFPageIndex ==
                    currentSurahID,
                child: Icon(
                  Icons.bookmark,
                  size: size.longestSide * 0.1,
                  color: theme.progressIndicatorTheme.color?.withAlpha(125),
                )),
          ),
          Positioned(
            //width: size.width * 0.95,
            top: 5,
            bottom: 25,
            right: -10,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  allowedInteraction: SliderInteraction.slideThumb,
                  divisions:
                      startPage == endPage ? null : (endPage - startPage),
                  min: startPage.toDouble(),
                  max: startPage == endPage
                      ? endPage.toDouble() + 1
                      : endPage.toDouble(),
                  value:
                      startPage == endPage ? startPage + 1 : sliderCurrentValue,
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
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pdfController.dispose();
  }
}
