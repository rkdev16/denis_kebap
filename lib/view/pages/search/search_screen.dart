import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/controller/search/search_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final _searchController = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        systemUiOverlayStyle:
            SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black),
        title: 'search'.tr,
        titleTextColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonInputField(
              margin: const  EdgeInsets.only(bottom: 16),


              controller: _searchController.searchTextController,
              hint: 'search'.tr,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  AppIcons.icSearch,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "recent_search".tr,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 16.fontMultiplier,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            Expanded(
              child: ListView.separated(
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.icSearch,
                              height: 19,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              _searchController.searchHistory[index].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 14.fontMultiplier,
                                      color: Colors.black.withOpacity(0.6)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        const Divider(),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8.0);
                  },
                  itemCount: _searchController.searchHistory.length),
            )
          ],
        ),
      ),
    );
  }
}
