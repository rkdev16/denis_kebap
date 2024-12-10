import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/controller/restaurant_locations/restaurant_locations_controller.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'components/location_list_tile.dart';

class RestaurantLocationsScreen extends StatelessWidget {
  RestaurantLocationsScreen({Key? key}) : super(key: key);

  final _locationsController = Get.find<RestaurantLocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.imgBgChooseLocation),
                fit: BoxFit.cover)),
        child:   AnimatedSwitcher(
          duration: const  Duration(milliseconds: 400),
          child: Obx(
              ()=> AnimatedSwitcher(

                duration: const  Duration(milliseconds: 400),
                child: _locationsController.isLoading.value ? const CommonProgressBar() : Column(
                children: [
                  CommonAppBar(
                    systemUiOverlayStyle: SystemUiOverlayStyle.light
                        .copyWith(statusBarColor: Colors.transparent),
                    titleTextColor: Colors.white,
                    title: '',
                    backgroundColor: Colors.transparent,
                    onBackTap: () {
                      Get.back();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 50, bottom: 32),
                    child: Image.asset(
                      AppImages.imgLocationPin,
                      height: 120,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: const Border.fromBorderSide(
                            BorderSide(color: Colors.white))),
                    child: Row(
                    mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.icLocationPin,
                          height: 40,
                          colorFilter:
                              const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        Obx(
                          () =>
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                            _locationsController.selectedLocation.value?.name??'Select Location',
                            style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        fontSize: 14.fontMultiplier,
                                        color: Colors.white),
                          ),
                                  const SizedBox(height:4.0),
                                  Text(
                                    _locationsController.selectedLocation.value?.address??'',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                        fontSize: 14.fontMultiplier,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                      ()=> Expanded(
                        child: ListView.separated(
                          padding:const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return  LocationListTile(
                              restaurantLocation: _locationsController.restaurantLocations[index],
                              onTap: (location){
                                _locationsController.selectRestaurantLocation(location);
                                Get.back();
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
                          //  itemCount: 2,
                          itemCount: _locationsController.restaurantLocations.length),
                      ),
                  )
                ],
            ),
              ),
          ),
        ),
      ),
    );
  }
}
