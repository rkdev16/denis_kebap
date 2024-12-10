import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NewUserWidget extends StatelessWidget {
  const NewUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 14,
          ),
          const Gap(8),
          Text(
            'new_user'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 12.fontMultiplier, color: Colors.green),
          )
        ],
      ),
    );
  }
}
