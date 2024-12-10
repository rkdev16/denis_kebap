import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CommonInputField extends StatefulWidget {
  final String hint;
  final TextStyle? hintTextStyle;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? inputType;
  final EdgeInsets? margin;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatter;
  final TextCapitalization? textCapitalization;
  final String? errorText;
  final bool? isEnable;
  final RxBool? isShowTrailing;
  final Color? fillColor;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final bool? obscure;
  final bool? readOnly;

  TextInputAction? textInputAction;
  UnderlineInputBorder? underLineBorder;
  EdgeInsets? contentPadding;
  InputBorder? inputBorder;
  InputBorder? errorInputBorder;
  Color? inputBorderColor;
  Color? errorInputBorderColor;
  Color? hintTextColor;
  Color? textColor;
  Color? cursorColor;
  String? prefixText;
  TextStyle? prefixStyle;

  CommonInputField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.hintTextStyle,
      this.onChanged,
      this.validator,
      this.inputType,
      this.inputFormatter,
      this.margin,
      this.prefixIcon,
      this.suffixIcon,
      this.textCapitalization,
      this.errorText,
      this.isEnable,
      this.isShowTrailing,
      this.fillColor,
      this.maxLines,
      this.focusNode,
      this.onFieldSubmitted,
      this.autoFocus,
      this.contentPadding,
      this.obscure = false,
      this.textInputAction,
      this.inputBorder,
      this.errorInputBorder,
      this.readOnly,
      this.inputBorderColor,
      this.errorInputBorderColor,
      this.hintTextColor,
        this.textColor,
        this.cursorColor,
        this.prefixText,
        this.prefixStyle
      })
      : super(key: key);

  @override
  State<CommonInputField> createState() => _CommonInputFieldState();
}

class _CommonInputFieldState extends State<CommonInputField> {
  late InputBorder inputBorder;
  late InputBorder errorInputBorder;

  @override
  void initState() {
    super.initState();

    inputBorder = widget.inputBorder ??= OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: widget.inputBorderColor ?? Colors.white));

    errorInputBorder = widget.errorInputBorder ??= OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: widget.inputBorderColor ?? Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: TextFormField(
        enabled: widget.isEnable ?? true,
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofocus: widget.autoFocus ?? false,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 16.fontMultiplier,
            color: (widget.isEnable ?? true)
                ? widget.textColor ?? Colors.white
                : (widget.textColor ?? Colors.white).withOpacity(0.5)),
        keyboardType: widget.inputType?? TextInputType.text,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        cursorColor: widget.cursorColor ?? Colors.white,
        maxLines: widget.maxLines ?? 1,
        textInputAction: widget.textInputAction,
        readOnly: widget.readOnly ?? false,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            hintText: widget.hint.tr,
            hintStyle: widget.hintTextStyle ??
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 15.fontMultiplier,
                    color: widget.hintTextColor ?? Colors.white),
            fillColor: widget.fillColor ?? Colors.black,
            filled: true,
            errorText: null,
            prefixText: widget.prefixText,
            prefixStyle: widget.prefixStyle,
            border: inputBorder,
            errorBorder: errorInputBorder,
            enabledBorder: inputBorder,
            disabledBorder: inputBorder,
            focusedBorder: inputBorder,
            focusedErrorBorder: inputBorder,
            errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: AppConsts.commonFontSizeFactor * 12,
                fontWeight: FontWeight.w300,
                color: Colors.red),
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12
                )),
        inputFormatters: widget.inputFormatter,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
