import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../consts/app_images.dart';

class PageNotFoundWidget extends StatelessWidget {
  const PageNotFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Image.asset(AppImages.imgPageNotFound, scale: 5),
        ],
      ),
    );
  }
}
