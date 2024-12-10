import 'package:denis_kebap/config/size_config.dart';
import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/model/time_slots_res_model.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_bg_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:denis_kebap/view/widgets/common/shop_closed_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../controller/cart/cart_controller.dart';

class SelectTimeBottomSheet {
  static show() {
    Get.bottomSheet(TimeBottomSheet(),
        isDismissible: false, enableDrag: false, isScrollControlled: true);
  }
}

class TimeBottomSheet extends StatefulWidget {
  TimeBottomSheet({Key? key}) : super(key: key);

  @override
  State<TimeBottomSheet> createState() => _TimeBottomSheetState();
}

class _TimeBottomSheetState extends State<TimeBottomSheet> {
  final _cartController = Get.find<CartController>();
  TimeSlot? selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _cartController.timeSlots.clear();
    _cartController.getTimeSlots();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgBottomSheet(
        child: SizedBox(
          height: SizeConfig.screenHeight - 200,
          child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                Image.asset(
                  AppIcons.icWatch,
                  height: 28,
                ),
                const Gap(16),
                Text(
                  'pickup_time'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18.fontMultiplier),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                Get.back();
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              icon: const Icon(
                Icons.cancel,
                size: 32,
                color: Colors.white,
              ))
                        ],
                      ),
                      const Gap(16),
                      Expanded(
                        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _cartController.isLoadingTimeSlots.value
                ? const CommonProgressBar()
                : _cartController.timeSlots.isEmpty
                    ? const ShopClosedWidget()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 16,
                                        mainAxisExtent: 40,
                                        crossAxisCount: 3),
                                itemCount: _cartController.timeSlots.length,
                                itemBuilder: (context, index) {
                                  return TimeSlotTile(
                                    timeSlot:
                                        _cartController.timeSlots[index],
                                    onTap: (TimeSlot slot) {
                                      _cartController.selectTimeSlot(index);
                                      selectedTimeSlot = slot;
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
          visible: _cartController.timeSlots.isNotEmpty,
          child: SafeArea(
            child: CommonButton(
                text: 'confirm'.tr,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                clickAction: () {
                  if (selectedTimeSlot == null) {
                    AppAlerts.alert(
                        message: 'message_please_select_time_slot'.tr);
                    return;
                  } else {
                    _cartController.selectedTimeSlot.value =
                        selectedTimeSlot;
                    Get.back();
                  }
                }),
          ),
                        ),
                      )
                    ],
          ),
        ));
  }
}

class TimeSlotTile extends StatelessWidget {
  const TimeSlotTile({super.key, required this.timeSlot, required this.onTap});

  final TimeSlot timeSlot;
  final Function(TimeSlot slot) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (timeSlot.isAvailable) {
          onTap(timeSlot);
        }
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(
                color: timeSlot.isAvailable
                    ? timeSlot.isSelected
                        ? Colors.green
                        : Colors.white
                    : Colors.red)),
            borderRadius: BorderRadius.circular(10),
            color: timeSlot.isAvailable
                ? timeSlot.isSelected
                    ? Colors.green
                    : Colors.black
                : Colors.red),
        duration: const Duration(milliseconds: 400),
        child: Text(
          timeSlot.time ?? '',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 16.fontMultiplier,
                color: timeSlot.isAvailable
                    ? timeSlot.isSelected
                        ? Colors.white
                        : Colors.white
                    : Colors.white,
              ),
        ),
      ),
    );
  }
}
