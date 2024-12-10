import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TipTab extends StatelessWidget {
  const TipTab(
      {super.key,
      required this.isSelected,
      required this.title,
      required this.onTap,
        this.isDisabled = false});

  final bool isSelected;
  final String title;
  final VoidCallback onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(BorderSide(
              color: isSelected ? Colors.green : AppColors.colorDC,
            ))),
        child: Text(
          title.tr,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 14.fontMultiplier,
              color: isDisabled
                  ? AppColors.colorDC
                  : isSelected
                      ? Colors.white
                      : AppColors.colorTextPrimary),
        ),
      ),
    );
  }
}
