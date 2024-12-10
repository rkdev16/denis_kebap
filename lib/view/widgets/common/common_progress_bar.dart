


import 'package:denis_kebap/config/app_colors.dart';
import 'package:flutter/material.dart';

class CommonProgressBar extends StatelessWidget {
  const CommonProgressBar({
    Key? key,
    this.size,
    this.strokeWidth
  }) : super(key: key);

 final  double? size;
final   double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return  Center(child: SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey,
        color: Colors.black,




        strokeWidth: strokeWidth??4.0,

      ),
    ),);
  }
}
