import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/controller/account/edit_account_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/widgets/common/common_input_field.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../consts/app_icons.dart';
import '../../../utils/validations.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/common/common_button.dart';

class EditAccountScreen extends StatelessWidget {
  EditAccountScreen({Key? key}) : super(key: key);

  final _editAccountController = Get.find<EditAccountController>();

  final  inputBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white));

  final  errorInputBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red));




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          systemUiOverlayStyle:
              SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black),
          onBackTap: () {
            Get.back();
          },
          title: 'edit_account'.tr,
          titleTextColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => CommonInputField(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _editAccountController.profileEditingType.value =
                                ProfileEditingType.name;
                          },
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                AppIcons.icEdit,
                              )),
                        ),
                        prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              AppIcons.icPerson,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            )),
                        fillColor: Colors.transparent,
                            readOnly: _editAccountController.profileEditingType.value != ProfileEditingType.name,
                        validator: Validations.checkEmptyFiledValidations,
                        controller: _editAccountController.nameController,
                        inputBorder: inputBorder,
                        errorInputBorder: errorInputBorder,
                        hint: "hint_your_name",
                        hintTextStyle: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 15.fontMultiplier,
                                color: Colors.white.withOpacity(0.5))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Obx(
                      () => Visibility(
                        visible: _editAccountController.profileEditingType.value ==
                            ProfileEditingType.name,
                        child: Row(
                          children: [
                            Expanded(
                              child: CommonButton(
                                  borderRadius: 8.0,
                                  height: 40,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  text: "update".tr,
                                  clickAction: () {
                                    _editAccountController.updateUserName();
                                  }),
                            ),
                            Expanded(
                              child: CommonButton(
                                  borderWidth: 1.0,
                                  borderColor: Colors.white,
                                  borderRadius: 8.0,
                                  height: 40,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  text: "cancel".tr,
                                  clickAction: () {
                                    _editAccountController.nameController.text =  PreferenceManager.user?.name??'';
                                    _editAccountController
                                        .profileEditingType.value = null;
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => CommonInputField(

                        // suffixIcon: GestureDetector(
                        //   onTap: () {
                        //     _editAccountController.profileEditingType.value = ProfileEditingType.email;
                        //   },
                        //   child: Container(
                        //       padding: const EdgeInsets.all(12),
                        //       child: SvgPicture.asset(
                        //         AppIcons.icEdit,
                        //       )),
                        // ),
                        prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              AppIcons.icMail,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            )),
                        fillColor: Colors.transparent,
                        isEnable: false,
                        readOnly: _editAccountController.profileEditingType.value != ProfileEditingType.email,
                        validator: Validations.checkEmailValidations,
                        controller: _editAccountController.emailController,
                        inputBorder: inputBorder,
                        errorInputBorder: errorInputBorder,
                        hint: "hint_your_email",
                        hintTextStyle: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 15.fontMultiplier,
                                color: Colors.white.withOpacity(0.5))),
                  ),



                  Padding(
                    padding: const  EdgeInsets.only(top: 16),
                    child: Obx(
                      () => Visibility(
                        visible: _editAccountController.profileEditingType.value ==
                            ProfileEditingType.email,
                        child: Row(
                          children: [
                            Expanded(
                              child: CommonButton(
                                  borderRadius: 8.0,
                                  height: 40,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  text: "update".tr,
                                  clickAction: () {
                                    _editAccountController.updateUserEmail();
                                  }),
                            ),
                            Expanded(
                              child: CommonButton(
                                  borderWidth: 1.0,
                                  borderColor: Colors.white,
                                  borderRadius: 8.0,
                                  height: 40,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  text: "cancel".tr,
                                  clickAction: () {
                                   _editAccountController.emailController.text =  PreferenceManager.user?.email??'';
                                    _editAccountController.profileEditingType.value = null;
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // CommonInputField(
                  //   prefixIcon: Container(
                  //       height: 20,
                  //       padding: const EdgeInsets.all(12),
                  //       child: SvgPicture.asset(
                  //         AppIcons.icPhone,
                  //       )),
                  //   isEnable: false,
                  //   validator: Validations.checkPhoneValidations,
                  //   controller: _editAccountController.phoneController,
                  //   inputBorder: inputBorder,
                  //   errorInputBorder: errorInputBorder,
                  //   hint: "phone_number".tr,
                  //   fillColor: Colors.transparent,
                  //   hintTextStyle: Theme.of(context)
                  //       .textTheme
                  //       .headlineSmall
                  //       ?.copyWith(
                  //           fontSize: 15.fontMultiplier,
                  //           color: Colors.white.withOpacity(0.5)),
                  // ),
                ],
              ),
            ),

         Obx(()=> _editAccountController.isLoading.value?  const CommonProgressBar() : const SizedBox())
          ],
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            _editAccountController.showDeleteAccountAlert();
          },
          child: Container(
            color: Colors.black.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.icBin,
                    colorFilter:
                        const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'delete_account'.tr,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 16.fontMultiplier, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
