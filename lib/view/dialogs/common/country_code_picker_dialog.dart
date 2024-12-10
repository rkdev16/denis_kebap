


import 'package:country_picker/country_picker.dart';
import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CountryCodePickerDialog{
  CountryCodePickerDialog._();

  static show({
    required BuildContext context,
  required Function(Country) onSelect}){

    var inputBorderSearchCountryCode = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const  BorderSide(color: Colors.white));


      FocusManager.instance.primaryFocus?.unfocus();

      showCountryPicker(
        context: context,
        //Optional.  Can be used to exclude(remove) one ore
        // more country from the countries list (optional).
        exclude: <String>['KN', 'MF'],
        favorite: <String>['US'],
        //Optional. Shows phone code before the country name.
        showPhoneCode: true,
        onSelect: onSelect,
        // Optional. Sets the theme for the country list picker.
        countryListTheme: CountryListThemeData(
          flagSize: 15,


          // Optional. Sets the border radius for the bottomsheet.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          textStyle: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white,fontSize: 15.fontMultiplier),
          // Optional. Styles the search field.
          inputDecoration: InputDecoration(
              hintText: 'search'.tr,
              hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize:  12.fontMultiplier,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8),
                child: SvgPicture.asset(
                  AppIcons.icSearch,
                  height: 18,
                  width: 18,
                  colorFilter: const  ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
              prefixIconConstraints:
              const BoxConstraints(minWidth: 18, minHeight: 18),
              filled: true,
              fillColor: AppColors.kPrimaryColor.withOpacity(0.02),
              border: inputBorderSearchCountryCode,
              errorBorder: inputBorderSearchCountryCode,
              enabledBorder: inputBorderSearchCountryCode,
              disabledBorder: inputBorderSearchCountryCode,
              focusedBorder: inputBorderSearchCountryCode,
              focusedErrorBorder: inputBorderSearchCountryCode),
        ),
      );
    }
  }

