
import 'package:denis_kebap/controller/otp_verification/otp_verification_controller.dart';
import 'package:get/get.dart';

class OtpVerificationBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OtpVerificationController());
  }

}