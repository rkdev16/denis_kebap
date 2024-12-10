import 'package:denis_kebap/model/restaurant_locations_res_model.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../controller/restaurant_locations/restaurant_locations_controller.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile(
      {Key? key, required this.restaurantLocation, this.onTap})
      : super(key: key);

  final Function(RestaurantLocation location)? onTap;
  final RestaurantLocation restaurantLocation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!(restaurantLocation);
      },
      child: Container(

        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if(restaurantLocation.id ==
                PreferenceManager.restaurantLocation?.id) BoxShadow(
              blurRadius: 8,spreadRadius: 8,color: Colors.white.withOpacity(0.3)
            )
          ],
          border: Border.fromBorderSide(BorderSide(
              color: restaurantLocation.id ==
                      PreferenceManager.restaurantLocation?.id
                  ? Colors.white
                  : Colors.transparent)),
          color: Colors.black.withOpacity(0.5),
          // boxShadow:  restaurantLocation.id == PreferenceManager.restaurantLocation?.id
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurantLocation.name ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16.fontMultiplier,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                restaurantLocation.address ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 14.fontMultiplier, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
