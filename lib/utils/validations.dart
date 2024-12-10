

import 'package:denis_kebap/consts/app_formatters.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Validations {
  Validations._(){}


  static String? checkEmailValidations(String? value){
    var enteredValue =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_email".tr;
    }
    // else if(!AppFormatters.validEmailExp.hasMatch(enteredValue)){
    //   return 'message_invalid_email'.tr;
    // }
    else{
      return null;
    }
  }



  static String? checkDOBValidations(String? value){
    var enteredValue =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_dob".tr;
    }
    else{
      return null;
    }
  }

  static String? checkEmptyFiledValidations(String? value){
    var enteredValue =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_value".tr;
  }
    else{
      return null;
    }
  }


  static String? checkPasswordValidations(String? value){
    var enteredValue   =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_password".tr;
    }else if(!AppFormatters.validPasswordExp.hasMatch(enteredValue)){
      return 'message_password_helper'.tr;
    }
    else{
      return null;
    }
  }


  static String? checkConfirmPasswordValidations(String? value,String? password){
    var enteredValue   =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_password".tr;
    }/*else if(!AppFormatters.validPasswordExp.hasMatch(enteredValue)){
      return 'message_password_helper'.tr;
    }*/ else if(enteredValue != password){
      return 'message_password_must_be_same'.tr;
    }
    else{
      return null;
    }
  }




  static String? checkFirstNameValidations(String? value){
    var enteredValue   =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_name".tr;
    }
    // else if(!AppFormatters.validNameExp.hasMatch(enteredValue)){
    //   return 'Enter Valid Name'.tr;
    // }
    else{
      return null;
    }
  }


  static String? checkLastNameValidations(String? value){
    var enteredValue   =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_last_name".tr;
    }else if(!AppFormatters.validNameExp.hasMatch(enteredValue)){
      return 'message_enter_valid_name'.tr;
    }
    else{
      return null;
    }
  }


  static String? checkUsernameValidations(String? value){
    var enteredValue   =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_username".tr;
    }/*else if(!AppFormatters.validNameExp.hasMatch(enteredValue)){
      return 'message_enter_valid_name'.tr;
    }*/
    else{
      return null;
    }
  }


  static String? checkPhoneValidations(String? value){
    var enteredValue   =  value?.trim()??'';
    if(enteredValue.isEmpty){
      return  "message_enter_phone_number".tr;
    }else if(!AppFormatters.validPhoneExp.hasMatch(enteredValue)){
      return 'message_enter_valid_phone_number'.tr;
    }
    else{
      return null;
    }
  }

}