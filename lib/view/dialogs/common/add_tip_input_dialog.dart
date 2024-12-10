import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/validations.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddTipInputDialog {
  AddTipInputDialog._();

  static show({required Function(String? tip) onTipAdded}) {
    Get.dialog(Dialog(
      backgroundColor: Colors.black,
      child: _DialogContent(onTipAdded: onTipAdded),
    ));
  }
}

class _DialogContent extends StatelessWidget {
  _DialogContent({super.key, required this.onTipAdded});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Function(String? tip) onTipAdded;

  final TextEditingController tipController = TextEditingController();

  addTip(BuildContext context) {
    String tip = tipController.text.toString().trim();
    debugPrint("Tip=$tip");
    if (_formKey.currentState!.validate()) {
      onTipAdded(tip);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'add_tip'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18.fontMultiplier,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const Gap(16),
              Form(
                key: _formKey,
                child: CommonInputField(
                  prefixIcon: Container(

                    height: 24,
                      padding: const EdgeInsets.all(14),
                      child: SvgPicture.asset(
                        AppIcons.icEuro,

                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      )),
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  inputType: TextInputType.number,
                  hintTextColor: AppColors.color70,
                  validator: Validations.checkEmptyFiledValidations,
                  controller: tipController,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  hint: "amount",
                ),
              ),
              const Gap(16),
              CommonButton(
                  text: 'add'.tr,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  clickAction: () {
                    debugPrint("Add");
                    addTip(context);
                  })
            ],
          ),
        )
      ],
    );
  }
}
