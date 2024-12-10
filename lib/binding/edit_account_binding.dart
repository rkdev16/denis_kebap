
import 'package:denis_kebap/controller/account/edit_account_controller.dart';
import 'package:get/get.dart';


class EditAccountBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => EditAccountController());
  }

}