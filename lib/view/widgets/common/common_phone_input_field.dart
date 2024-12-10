import 'package:country_picker/country_picker.dart';
import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CommonPhoneInputField extends StatelessWidget {
  String hint;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;
  TextEditingController controller;
  TextInputType? inputType;
  double? marginLeft;
  double? marginRight;
  double? marginTop;
  double? marginBottom;
  List<TextInputFormatter>? inputFormatter;
  VoidCallback countryCodePickerCallback;
  var selectedCountry = Rx<Country?>(null);
  Widget? leading;
  FocusNode? focusNode;
  bool? autoFocus;
  TextInputAction? textInputAction;
  Color? fillColor;
  Color? hintTextColor;
  Color? textColor;
  InputBorderType? inputBorderType;
  Widget? suffixIcon;




  var inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white));

  var errorInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red));


  CommonPhoneInputField({
    Key? key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.validator,
    this.inputType,
    this.inputFormatter,
    this.marginLeft,
    this.marginRight,
    this.marginTop,
    this.marginBottom,
    required this.countryCodePickerCallback,
    required this.selectedCountry,
    this.leading,
    this.focusNode,
    this.autoFocus,
    this.textInputAction,
    this.onFieldSubmitted,
    this.fillColor,
    this.hintTextColor,
    this.textColor,
    this.inputBorderType,
    this.suffixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(
          left: marginLeft ?? 16,
          right: marginRight ?? 16,
          top: marginTop ?? 8,
          bottom: marginBottom ?? 8),
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autoFocus??false,
            textInputAction: textInputAction,
            style: Theme.of(context)
                .textTheme
                .headlineSmall?.copyWith(
                fontSize: AppConsts.commonFontSizeFactor *16,
                color: textColor??Colors.white),
            keyboardType: inputType,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              alignLabelWithHint: true,
                hintText: hint.tr,
                hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                    fontSize:15.fontMultiplier,
                    color: hintTextColor??Colors.white),
                prefixIcon:Obx(
                 ()=> SizedBox(
                   width: 102,
                 // width: 100,
                   child: TextButton.icon(
                       onPressed: countryCodePickerCallback,
                       style: ButtonStyle(
                           overlayColor: MaterialStateProperty.all(Colors.transparent)
                       ),
                       icon: Text( selectedCountry.value?.flagEmoji??""),
                       label: Row(
                         children: [
                           Text(
                             '+${selectedCountry.value?.phoneCode??''}',
                             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                               fontSize: 12.fontMultiplier,
                               color: textColor??Colors.white,
                             ),
                           ),
                           const   Icon(Icons.arrow_drop_down,color: Colors.white,)
                         ],
                       )),
                 ),
               ),



                suffixIcon: suffixIcon,
                fillColor: fillColor?? Colors.transparent,
                filled: true,
                border: inputBorder,
                errorBorder:errorInputBorder,
                enabledBorder:inputBorder,
                disabledBorder: inputBorder,
                focusedBorder:inputBorder,
                focusedErrorBorder: errorInputBorder,
                errorStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 12.fontMultiplier,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),

               contentPadding:  const EdgeInsets.only(left:0, right: 0)
            ),
            inputFormatters: inputFormatter,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
          ),

        ],
      ),
    );
  }
}



