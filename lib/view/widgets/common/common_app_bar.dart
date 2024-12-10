import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar(
      {Key? key,
      this.title,
      this.onBackTap,
      this.titleWidget,
      this.centerTitle,
      this.shadowColor,
      this.systemUiOverlayStyle,
      this.backgroundColor,
      this.titleTextStyle,
      this.leading,
      this.actions,
      this.titleTextColor})
      : super(key: key);

  final String? title;
  final Widget? titleWidget;
  final bool? centerTitle;
  final Function()? onBackTap;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final Color? backgroundColor;
  final Color? shadowColor;
  final TextStyle? titleTextStyle;
  final Widget? leading;
  final Color? titleTextColor;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       boxShadow: [
         BoxShadow(
           color: shadowColor ?? Colors.white.withOpacity(0.1),
           spreadRadius: 8,
           blurRadius: 8
         )
       ]
      ),
      child: AppBar(
        systemOverlayStyle: systemUiOverlayStyle ??
            Theme.of(context).appBarTheme.systemOverlayStyle,
        leading: onBackTap == null
            ? const SizedBox()
            : IconButton(
                onPressed: onBackTap,
                icon: leading ??
                    SvgPicture.asset(
                      AppIcons.icBack,
                      height: 20,
                      colorFilter:
                         const  ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
              ),
        title: titleWidget ??
            Text(
              (title??'').tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 15.fontMultiplier,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
        titleTextStyle: titleTextStyle ??
            Theme.of(context)
                .appBarTheme
                .titleTextStyle
                ?.copyWith(color: titleTextColor ?? Colors.black),
        backgroundColor:
            backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: centerTitle ?? true,
        titleSpacing: 0,
        actions: actions,
      ),
    );
  }
}
