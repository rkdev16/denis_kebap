

import 'package:denis_kebap/controller/signup/signup_controller.dart';
import 'package:get/get.dart';


class SignupBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController());
  }

}