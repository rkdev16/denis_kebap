import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/controller/home/home_controller.dart';
import 'package:denis_kebap/controller/restaurant_locations/restaurant_locations_controller.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/pages/home/components/home_page_widget.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';



class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(
        systemUiOverlayStyle:
            SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.black,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light
            ),
        centerTitle: false,
        backgroundColor: Colors.black,
        leading: SvgPicture.asset(
          AppIcons.icRestaurant,
        ),
        onBackTap: () {
          Get.toNamed(AppRoutes.routeRestaurantLocationsScreen);
        },
        titleWidget: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.routeRestaurantLocationsScreen);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () =>
                    Text(
                  Get.find<RestaurantLocationController>()
                          .selectedLocation
                          .value
                          ?.name ??
                      '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 14.fontMultiplier, color: Colors.white),
                ),
              ),
              Obx(
                () => Text(
                  Get.find<RestaurantLocationController>()
                          .selectedLocation
                          .value
                          ?.address ??
                      '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12.fontMultiplier, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      body:  Obx(
        () => AnimatedSwitcher(
          duration: const  Duration(milliseconds: 400),
          child: _homeController.isLoading.value ? const CommonProgressBar() :

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Obx(
                  ()=> Text(
                   _homeController.restaurantTagLine.value?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 24.fontMultiplier,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4)

                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                          controller: _homeController.tabController,
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.white.withOpacity(0.4),
                          labelColor: Colors.white,
                          unselectedLabelStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 14.fontMultiplier),
                          labelStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 14.fontMultiplier),
                          labelPadding: const  EdgeInsets.symmetric(horizontal: 8),
                          isScrollable: true ,
                          onTap: (int index) {
                            _homeController.onTab;
                          },
                          tabAlignment: TabAlignment.start,
                          padding: const  EdgeInsets.symmetric(horizontal: 8),
                          tabs: List.generate(
                              _homeController.categories.length,
                                  (index) => Tab(
                                    text:  _homeController.categories[index].name.toUpperCase() ,

                                // child: Obx(
                                //     ()=> Text(
                                //     _homeController.categories[index].name.toUpperCase(),
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .headlineMedium
                                //         ?.copyWith(
                                //
                                //       color:
                                //       _homeController.selectTab.value == index
                                //           ? Colors.white
                                //           : Colors.white.withOpacity(0.3),
                                //       fontSize: 13.fontMultiplier,
                                //     ),
                                //   ),
                                // ),
                              ))),
                    ),
                  ],
                ),
              ),



              Expanded(
                child: TabBarView(
                    controller: _homeController.tabController,
                    children: List.generate(
                        _homeController.categories.length, (index) => HomePageWidget(category:  _homeController.categories[index],
                    ))),
              )


            ],
          ),
        ),
      ),
    );
  }
}
