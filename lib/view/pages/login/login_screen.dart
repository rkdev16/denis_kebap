import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/controller/login/login_controller.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/validations.dart';
import 'package:denis_kebap/view/dialogs/common/country_code_picker_dialog.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_input_field.dart';
import 'package:denis_kebap/view/widgets/common/common_phone_input_field.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:denis_kebap/view/widgets/common/new_user_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:denis_kebap/config/size_config.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(builder: (context, constraints) {
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context)
                  .copyWith(scrollbars: false, overscroll: false),
              child: SingleChildScrollView(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppImages.imgBgLogin,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: SizeConfig.heightMultiplier * 58,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 32.0, bottom: 8),
                        child: Text(
                          'login'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.fontMultiplier,
                                  color: Colors.white),
                        ),
                      ),

                      //   Obx(()=>

                      Form(
                        key: _loginController.formKey,
                        child: CommonInputField(
                          prefixIcon: Container(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                AppIcons.icMail,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              )),

                          // suffixIcon: _loginController.isLoadingCheckEmail.value ? const   SizedBox(width: 12, child:   CommonProgressBar(strokeWidth: 2,size: 16,)) : const  SizedBox.shrink(),
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          hintTextColor: AppColors.color70,
                          onChanged: (String value) {
                            // _loginController.enteredEmail.value = value;
                          },
                          validator: Validations.checkEmailValidations,
                          controller: _loginController.emailController,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          hint: "hint_your_email",
                        ),
                      ),
                      // ),

                      Obx(() => _loginController.isNewUser.value
                          ? const NewUserWidget()
                          : const SizedBox.shrink()),

                      Obx(() => _loginController.isNewUser.value
                          ? CommonPhoneInputField(
                              inputType: TextInputType.number,
                              controller: _loginController.phoneController,
                              hint: 'phone_number'.tr,
                              marginLeft: 24,
                              marginRight: 24,
                              onChanged: (String value) {
                                _loginController.enteredPhone.value = value;
                              },
                              suffixIcon: _loginController.isNewUser.value &&
                                      _loginController.isLoadingCheckPhone.value
                                  ? const SizedBox(
                                      width: 12,
                                      child: CommonProgressBar(
                                        strokeWidth: 2,
                                        size: 12,
                                      ))
                                  : const SizedBox.shrink(),
                              hintTextColor: AppColors.color70,
                              fillColor: Colors.transparent,
                              countryCodePickerCallback: () =>
                                  CountryCodePickerDialog.show(
                                      context: context,
                                      onSelect: _loginController.selectCountry),
                              selectedCountry: _loginController.selectedCountry)
                          : const SizedBox.shrink()),

                      Obx(() => _loginController.isNewUser.value &&
                              _loginController.isPhoneExists.value
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'message_phone_already_exists'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontSize: 12.fontMultiplier,
                                        color: Colors.red),
                              ),
                            )
                          : const SizedBox.shrink()),

                      CommonButton(
                        text: 'send_otp'.tr,
                        isLoading: _loginController.isLoading,
                        clickAction: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_loginController.formKey.currentState!
                              .validate()) {
                            _loginController.requestOtp();
                          }
                        },
                        textColor: Colors.black,
                        backgroundColor: Colors.white,
                        margin:
                            const EdgeInsets.only(top: 16, left: 24, right: 24),
                      ),

                      //todo social logins removed for nowszz
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70.0, vertical: 16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Divider(
                              height: 2,
                              color: Colors.white,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              color: Colors.black,
                              child: Text(
                                'or'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        fontSize: 15.fontMultiplier,
                                        color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      CommonButton(
                        text: 'continue_as_guest'.tr,
                        clickAction: () {
                          Get.offAllNamed(AppRoutes.routeDashboardScreen);
                        },
                        textColor: Colors.white,
                        borderColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        margin:
                        const EdgeInsets.only(top: 16, left: 24, right: 24),
                      ),

                      // GestureDetector(
                      //   onTap: (){
                      //     if(Platform.isAndroid){
                      //       _loginController.googleLogin();
                      //     }else if(Platform.isIOS){
                      //       _loginController.appleLogin();
                      //     }
                      //   },
                      //   child: Container(
                      //     height: 45,
                      //     margin: const EdgeInsets.symmetric(horizontal: 24),
                      //     alignment: Alignment.center,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         border: const Border.fromBorderSide(
                      //             BorderSide(color: Colors.white))),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Text(
                      //           'sign_in_with'.tr,
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .headlineMedium
                      //               ?.copyWith(
                      //                 fontSize: 15.fontMultiplier,
                      //                 color: Colors.white,
                      //               ),
                      //         ),
                      //         const SizedBox(
                      //           width: 8,
                      //         ),
                      //         SvgPicture.asset(
                      //           Platform.isAndroid
                      //               ? AppIcons.icGoogle
                      //               : AppIcons.icApple,
                      //           height: 20,
                      //           colorFilter: const ColorFilter.mode(
                      //               Colors.white, BlendMode.srcIn),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 12),
                        child: TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.routeWebViewScreen,
                                  arguments: {
                                    'title': 'terms_and_privacy',
                                    'url': AppConsts.urlTerms
                                  });
                            },
                            child: Text(
                              'terms_and_privacy'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 12.fontMultiplier,
                                      color: Colors.white),
                            )),
                      )

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 24.0),
                      //   child: RichText(
                      //     text: TextSpan(
                      //         text: '${'new_customer'.tr}? ',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headlineSmall
                      //             ?.copyWith(
                      //                 fontSize: 12.fontMultiplier,
                      //                 color: Colors.white),
                      //         children: [
                      //           TextSpan(
                      //               text: 'register_here'.tr,
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .headlineLarge
                      //                   ?.copyWith(
                      //                       fontWeight: FontWeight.w700,
                      //                       fontSize: 12.fontMultiplier,
                      //                       color: Colors.white),
                      //               recognizer: TapGestureRecognizer()
                      //                 ..onTap = () {
                      //                   FocusManager.instance.primaryFocus
                      //                       ?.unfocus();
                      //                   Get.toNamed(
                      //                       AppRoutes.routeEnterPhoneNumScreen,
                      //                       arguments: {
                      //                         AppConsts.keyRegistrationType:
                      //                             RegistrationType.newCustomer
                      //                       });
                      //                 })
                      //         ]),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 24.0, bottom: 30),
                      //   child: RichText(
                      //     text: TextSpan(
                      //         text: '${'existing_customer'.tr}? ',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headlineSmall
                      //             ?.copyWith(
                      //                 fontSize: 12.fontMultiplier,
                      //                 color: Colors.white),
                      //         children: [
                      //           TextSpan(
                      //               text: 'create_reset_your_login_pin'.tr,
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .headlineLarge
                      //                   ?.copyWith(
                      //                       fontWeight: FontWeight.w700,
                      //                       fontSize: 12.fontMultiplier,
                      //                       color: Colors.white),
                      //               recognizer: TapGestureRecognizer()
                      //                 ..onTap = () {
                      //                   FocusManager.instance.primaryFocus
                      //                       ?.unfocus();
                      //                   Get.toNamed(
                      //                       AppRoutes.routeEnterPhoneNumScreen,
                      //                       arguments: {
                      //                         AppConsts.keyRegistrationType:
                      //                             RegistrationType
                      //                                 .existingCustomer
                      //                       });
                      //                 })
                      //         ]),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
