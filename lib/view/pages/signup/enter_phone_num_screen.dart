import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/controller/signup/signup_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/validations.dart';

class EnterPhoneNumScreen extends StatelessWidget {
  EnterPhoneNumScreen({Key? key}) : super(key: key);


  final _signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value:  SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body:  Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              image:  DecorationImage(image: AssetImage(AppImages.imgBgSignup),fit: BoxFit.cover)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _signupController.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                CommonAppBar(
                  systemUiOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
                  titleTextColor: Colors.white,
                  title: _signupController.registrationType == RegistrationType.existingCustomer
                               ? 'existing_customer'.tr
                           : 'new_customer'.tr,
                  backgroundColor: Colors.transparent,
                  onBackTap: (){
                  Get.back();
                },),

                Align(
                  alignment: Alignment.center,
                    child: Image.asset(AppImages.imgAppLogo,height: 135,)),
                const SizedBox(height: 45.0),

                Text('enter_phone_number'.tr,style:Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20.fontMultiplier,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ) ,),
                CommonPhoneInputField(
                  inputType: TextInputType.number,
                  marginLeft: 0,
                  validator: Validations.checkPhoneValidations,
                    controller: _signupController.phoneController,
                    hint: 'phone_number'.tr,
                    fillColor: Colors.transparent,
                    marginTop: 16,
                    marginBottom: 16,
                    countryCodePickerCallback: () {
                      _signupController.pickCountryCode(context);
                    },
                    selectedCountry: _signupController.selectedCountry),
                CommonButton(
                  isLoading:  _signupController.isLoading,
                  margin: const EdgeInsets.only(left: 0,right:16),
                    text: 'next'.tr,
                    clickAction: (){
                      _signupController.validatePhoneNumForm();

                })




        ],),
            ),
          ),),
      ),
    );
  }
}
