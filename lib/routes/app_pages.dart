import 'package:denis_kebap/binding/dashboard_binding.dart';
import 'package:denis_kebap/binding/otp_verification_binding.dart';
import 'package:denis_kebap/binding/splash_binding.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/pdf_viewer.dart';
import 'package:denis_kebap/view/pages/dashboard/dashboard_screen.dart';
import 'package:denis_kebap/view/pages/login/login_screen.dart';
import 'package:denis_kebap/view/pages/order/order_confirmation_screen.dart';
import 'package:denis_kebap/view/pages/payment_form_screen.dart';
import 'package:denis_kebap/view/pages/restaurant_location/restaurant_locations_screen.dart';
import 'package:denis_kebap/view/pages/signup/enter_phone_num_screen.dart';
import 'package:denis_kebap/view/pages/otp_verification/otp_verification_screen.dart';
import 'package:denis_kebap/view/pages/signup/setup_pin_screen.dart';
import 'package:denis_kebap/view/pages/splash/splash_screen.dart';
import 'package:denis_kebap/view/web_view/common_web_view_screen.dart';
import 'package:get/get.dart';
import '../binding/signup_binding.dart';
import '../binding/edit_account_binding.dart';
import '../binding/login_binding.dart';
import '../view/pages/account/edit_account_screen.dart';

import '../view/pages/cart/components/card_details.dart';
import '../view/pages/order/order_detail_screen.dart';

class AppPages {
  AppPages._();

  static const int _transitionDuration = 300;

  static List<GetPage> get pages => <GetPage>[
        GetPage(
            name: AppRoutes.routeSplashScreen,
            page: () => const SplashScreen(),
            binding: SplashBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeLoginScreen,
            page: () => LoginScreen(),
            binding: LoginBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeEnterPhoneNumScreen,
            page: () => EnterPhoneNumScreen(),
            binding: SignupBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeOtpVerificationScreen,
            page: () => OtpVerificationScreen(),
            binding: OtpVerificationBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeSetupPinScreen,
            page: () => SetupPinScreen(),
            binding: SignupBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeRestaurantLocationsScreen,
            page: () => RestaurantLocationsScreen(),
            binding: DashboardBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeDashboardScreen,
            page: () => DashboardScreen(),
            binding: DashboardBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeEditAccountScreen,
            page: () => EditAccountScreen(),
            binding: EditAccountBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),
        GetPage(
            name: AppRoutes.routeCardDetailsScreen,
            page: () => CardDetailsScreen(),
            // binding: DashboardBinding(),
            transition: Transition.rightToLeft,
            transitionDuration:
                const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeOrderConfirmationScreen,
        page: () =>  const OrderConfirmationScreen(),
        transition: Transition.rightToLeft,
        transitionDuration:
        const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeOrderDetailScreenScreen,
        page: () =>   OrderDetailScreen(),
        transition: Transition.rightToLeft,
        transitionDuration:
        const Duration(milliseconds: _transitionDuration)),

    GetPage(
      name: AppRoutes.routeWebViewScreen,
      page: () =>  const   CommonWebViewScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: _transitionDuration),
    ),

    GetPage(
      name: AppRoutes.routePaymentFormScreen,
      page: () =>  const   PaymentFormScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: _transitionDuration),
    ),



    // GetPage(
    //     name: AppRoutes.routeUpdateScreen,
    //     page: () => UpdateAccountScreen(),
    //     // binding: DashboardBinding(),
    //     transition: Transition.rightToLeft,
    //     transitionDuration:
    //     const Duration(milliseconds: _transitionDuration)),
      ];
}
