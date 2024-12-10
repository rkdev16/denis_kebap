import 'package:cached_network_image/cached_network_image.dart';
import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';

class CommonImageWidget extends StatelessWidget {
  CommonImageWidget({
    Key? key,
    required this.url,
    this.placeholder,
    this.errorPlaceholder,
    this.width,
    this.height,
    this.borderRadius
  }) : super(key: key);

  String? url;
  String? placeholder;
  String? errorPlaceholder;
  double? width;
  double? height;
  double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:BorderRadius.circular(borderRadius??0),
      child: url == null ?   Image.asset(
          width: width ?? 100,
          height: height ?? 100,
          fit: BoxFit.cover,
          placeholder??AppImages.imgPlaceholder) :  CachedNetworkImage(
        width: width ?? 100,
        height: height ?? 100,
        fit: BoxFit.cover,
        placeholderFadeInDuration: const Duration(milliseconds: 500),
        imageUrl: Helpers.getCompleteUrl(url),
        placeholder: (context, url) =>
           placeholder ==null ? const CommonProgressBar() :  Image.asset(placeholder ?? AppImages.imgPlaceholder,fit: BoxFit.cover,),
        errorWidget: (context, url, error) => Image.asset(
            errorPlaceholder ?? placeholder ?? AppImages.imgPlaceholder,fit: BoxFit.cover),
      ),
    );
  }
}
