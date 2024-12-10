


import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/config/size_config.dart';
import 'package:denis_kebap/consts/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class CommonBgBottomSheet extends StatelessWidget {
  const CommonBgBottomSheet({
    super.key,
    required this.child
  });

 final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: AppColors.color21,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.3),spreadRadius: 4,blurRadius: 16)
          ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Column(
        // alignment: Alignment.topCenter,
        //  mainAxisSize: MainAxisSize.min,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.icNotch,width: 120,),
            child,
          ],
        ),
      ),
    );
  }
}




//
// @override
// Widget build(BuildContext context) {
//   return Stack(
//     alignment: Alignment.topCenter,
//     children: [
//       Container(
//         margin:  EdgeInsets.only(top: SizeConfig.heightMultiplier *30),
//         decoration: BoxDecoration(
//           // color: Colors.black,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(35),
//               topRight: Radius.circular(35),
//             ),
//             boxShadow: [
//               BoxShadow(color: Colors.white.withOpacity(0.3),spreadRadius: 4,blurRadius: 16)
//             ]
//         ),
//         child: Container(
//           margin: const EdgeInsets.only(top: 4),
//
//           decoration: const  BoxDecoration(
//             color: AppColors.color21,
//
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40),
//               topRight: Radius.circular(40),
//             ),
//
//
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(40),
//             child: Column(
//               // alignment: Alignment.topCenter,
//               //  mainAxisSize: MainAxisSize.min,
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(AppIcons.icNotch,width: 120,),
//
//                 child,
//               ],
//             ),
//           ),),
//       ),
//
//
//
//
//
//
//
//
//
//
//
//     ],
//   );
// }
// }



