import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/widgets/common/common_bg_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_button_outline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';



class LanguageOptionsBottomSheet {
  static show({required BuildContext context}) {
    Get.bottomSheet(_LanguageOptionsBottomSheetContent(),
      isDismissible: true,
      isScrollControlled: true,
     // barrierColor: Colors.transparent


    );
    // showModalBottomSheet(
    //     context: context,
    //     builder: (context) {
    //       return LanguageOptionsBottomSheetContent();
    //     },
    //     shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(24), topRight: Radius.circular(24))));
  }
}


class _LanguageOptionsBottomSheetContent extends StatelessWidget {
  _LanguageOptionsBottomSheetContent({
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return CommonBgBottomSheet(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
        const   Gap(8),
          CommonButton(text: 'German',
              backgroundColor: PreferenceManager.appLanguage == AppLanguage.german ? Colors.green : Colors.black12,
              clickAction: () {
           PreferenceManager.appLanguage = AppLanguage.german;
           Get.updateLocale(const Locale('de', 'AT'));
           Navigator.pop(context);
          }),
        const  Gap(16),
          CommonButton(text: 'English',
              backgroundColor: PreferenceManager.appLanguage == AppLanguage.english ? Colors.green : Colors.black12,
              clickAction: () {
            PreferenceManager.appLanguage = AppLanguage.english;
            Get.updateLocale(const Locale('en', 'US'));
            Navigator.pop(context);
          }),

         const  Gap(16)

        ],
      ),
    );
  }
}
