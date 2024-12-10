import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/controller/cart/cart_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatefulWidget {
  CustomBottomNavBar(
      {super.key, required this.selectedIndex, required this.onTabChange});

  int selectedIndex;
  Function(int position) onTabChange;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 8,
            blurRadius: 8
          )
        ]
      ),
      child: SafeArea(
        child: Table(
          children: [
            TableRow(children: [
              InkWell(
                onTap: () {
                  setState(() {
                    widget.selectedIndex = 0;
                  });

                  widget.onTabChange(widget.selectedIndex);
                },
                child: CustomTabItem(
                  title: 'home'.tr,
                  icon: Image.asset(
                    AppIcons.icDKLogo,
                    height: 24,
                  ),
                  tabPosition: 0,
                  isSelected: widget.selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      widget.selectedIndex = 0;
                    });

                    widget.onTabChange(widget.selectedIndex);
                  },
                ),
              ),
              CustomTabItem(
                title: 'shopping_cart'.tr,
                icon: SvgPicture.asset(AppIcons.icCart,
                  colorFilter: ColorFilter.mode(
                      widget.selectedIndex == 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      BlendMode.srcIn),
                ),
                isSelected: widget.selectedIndex == 1,
                tabPosition: 1,
                onTap: () {
                  setState(() {
                    widget.selectedIndex = 1;
                  });

                  widget.onTabChange(widget.selectedIndex);
                },
              ),
              InkWell(
                onTap: () {},
                child: CustomTabItem(
                  title: 'orders'.tr,
                  icon: SvgPicture.asset(
                    AppIcons.icAvatar,
                    colorFilter: ColorFilter.mode(
                        widget.selectedIndex == 2
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        BlendMode.srcIn),
                  ),
                  isSelected: widget.selectedIndex == 2,
                  tabPosition: 2,
                  onTap: () {
                    setState(() {
                      widget.selectedIndex = 2;
                    });

                    widget.onTabChange(widget.selectedIndex);
                  },
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}

class CustomTabItem extends StatelessWidget {
  const CustomTabItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.isSelected,
      required this.tabPosition,
      required this.onTap});

  final String title;
  final Widget icon;
  final bool isSelected;
  final int tabPosition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [

        if(isSelected)  Image.asset(AppImages.imgBottomNavBarShadow),




          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Container(
                margin: const EdgeInsets.symmetric(horizontal: 24,),
                height: 3,
                decoration: BoxDecoration(
                  color: isSelected ?  Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(24)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    icon,

                    if(tabPosition ==1)  Obx(
                       ()=> !Get.find<CartController>().isCartEmpty.value ?  Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),) : const  SizedBox(),
                    ) ,
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 10.fontMultiplier,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.4)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
