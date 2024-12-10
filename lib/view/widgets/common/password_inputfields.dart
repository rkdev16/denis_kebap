import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CommonPasswordField extends StatelessWidget {
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
  Widget? leading;
  Widget? trailing;
  List<TextInputFormatter>? inputFormatter;
  TextCapitalization? textCapitalization;
  String? errorText;
  bool? isEnable;
  RxBool? isShowTrailing;
  Color? fillColor;
  Color? borderColor;
  int? maxLines;
  FocusNode? focusNode;
  bool? autoFocus;
  bool? obscure;

  TextInputAction? textInputAction;
  UnderlineInputBorder? underLineBorder;
  EdgeInsets? edgesInsects;

  var inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)));
  var errorInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red));

  CommonPasswordField(
      {Key? key,
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
        this.leading,
        this.trailing,
        this.textCapitalization,
        this.errorText,
        this.isEnable,
        this.isShowTrailing,
        this.fillColor,
        this.borderColor,
        this.maxLines,
        this.focusNode,
        this.onFieldSubmitted,
        this.autoFocus,
        this.underLineBorder,
        this.edgesInsects,
        this.obscure = false,
        this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    //  color: Colors.pink,
      margin: EdgeInsets.only(
          left: marginLeft ?? 16,
          right: marginRight ?? 16,
          top: marginTop ?? 8,
          bottom: marginBottom ?? 16
      ),
      child: TextFormField(
        obscureText:true,
        obscuringCharacter: "*",
        enabled: isEnable ?? true,
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus ?? false,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontSize: 16.fontMultiplier, color: Colors.black),
        keyboardType: TextInputType.text,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        cursorColor: AppColors.kPrimaryColor,
        maxLines: maxLines ?? 1,
        textInputAction: textInputAction,
        decoration: InputDecoration(

            hintText: hint.tr,
            hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: AppConsts.commonFontSizeFactor * 15,

                color: Colors.black.withOpacity(0.7)),
            fillColor: fillColor ?? Colors.white,
            filled: true,
            errorText: null,
            prefixIcon: leading,
            suffixIcon:
            isShowTrailing?.value ?? RxBool(false).value ? trailing : null,
            border: underLineBorder ?? inputBorder,

            errorBorder: underLineBorder ?? inputBorder,
            enabledBorder: underLineBorder ?? inputBorder,
            disabledBorder: underLineBorder ?? inputBorder,
            focusedBorder: underLineBorder ?? inputBorder,
            focusedErrorBorder: underLineBorder ?? inputBorder,
            errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: AppConsts.commonFontSizeFactor * 12,
                fontWeight: FontWeight.w300,
                color: Colors.red),
            contentPadding: edgesInsects ??
                EdgeInsets.symmetric(horizontal: 16, vertical: 16)
        ),
        inputFormatters: inputFormatter,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
