import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/utils/download_service.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  PdfViewer({super.key, required this.url});

  String url;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final _downloadService = DownloadService();

  RxBool isDownloading = false.obs;
  RxBool documentLoaded = false.obs;

  @override
  void initState() {
    super.initState();
    _downloadService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CommonAppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          onBackTap: () {
            Get.back();
          },
          leading: SvgPicture.asset(
            AppIcons.icBack,
            height: 20,
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SfPdfViewer.network(
              widget.url,
              interactionMode: PdfInteractionMode.pan,
              onDocumentLoaded: (value) {
                documentLoaded.value = true;
              },
            ),
            CommonButton(
                text: 'download'.tr,
                isLoading: isDownloading,
                isEnable: documentLoaded,
                clickAction: () {
                  try {
                    isDownloading.value = true;
                    _downloadService.downloadLink(widget.url);
                  } finally {
                    Future.delayed(Duration(seconds: 1),
                        () => isDownloading.value = false);
                    setState(() {});
                  }
                }).paddingSymmetric(vertical: 30)
          ],
        ));
  }
}
