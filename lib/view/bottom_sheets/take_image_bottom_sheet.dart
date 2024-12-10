import 'package:denis_kebap/view/widgets/common/common_bg_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';


enum ImageSourceOptions{
  camera,gallery
}

class TakeImageBottomSheet {
  static show({required BuildContext context, required Function(ImageSource) imageSource}) {

    Get.bottomSheet(
        _TakeImageBottomSheetContent(imageSource: imageSource),
      isDismissible: true,
      isScrollControlled: false

    );


    // showModalBottomSheet(
    //     context: context,
    //     builder: (context) {
    //       return TakeImageBottomSheetContent(imageSource: imageSource,);
    //       },
    //     shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(24), topRight: Radius.circular(24))));
  }
}

class _TakeImageBottomSheetContent extends StatelessWidget {
   _TakeImageBottomSheetContent({
     Key? key,
    required this.imageSource
   }) : super(key: key);

   Function(ImageSource) imageSource;

  @override
  Widget build(BuildContext context) {
    return CommonBgBottomSheet(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          CommonButton(text: 'take_a_photo'.tr, clickAction: () {
            imageSource(ImageSource.camera);
            Navigator.of(context).pop();
          }),

        const Gap(16),

          CommonButton(text: 'choose_from_gallery'.tr, clickAction: () {
            imageSource(ImageSource.gallery);
            Navigator.of(context).pop();
          }),

          const Gap(32),
        ],
      ),
    );
  }
}
