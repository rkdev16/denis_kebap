

class ApiUrls {
  ApiUrls._();
 //static const String baseUrl = "https://deniskebapapi.appdeft.biz/"; //dev
  static const String baseUrl = "https://apiv2.denis-kebap.at/"; //prod
  static const String baseUrlImage = baseUrl;
  static const urlRequestOtp = 'api/user/request-otp';  //older one
  static const urlRequestOtpEmail = 'api/user/request-otp-email'; //new one
  static const urlVerifyOtp = 'api/user/verify-otp';
  static const urlOtpSignIn = 'api/user/otp-signin';  //old
  static const urlEmailOtpSignIn = 'api/user/email-otp-signin';  //new
  static const createPin = 'api/user/pin-setup';
  static const urlForgotPassword = 'api/user/forget-password';
  static const urlLogin = 'api/user/login';
  static const urlFetchRestaurantLocations = 'api/user/location';
  static const urlFetchCategories = 'api/user/category';
  static const urlFetchProducts = 'api/user/product';
  static const urlUserUpdate = 'api/user/update';
  static const urlAddToCart = 'api/user/cart';
  static const urlEditProductInCart = 'api/user/cart/';
  static const urlDecreaseProductQuantityProductList = 'api/user/cart/decrease-product/';
  static const urlDecreaseProductQuantityCart = 'api/user/cart/decrease/';
  static const urlIncreaseProductQuantityCart = 'api/user/cart/increase/';
  static const urlFetchProductVariant = 'api/user/product/';
  static const urlCartBulkUpdate = 'api/user/cart/bulk-update';
  static const urlFetchCart = 'api/user/cart';
  static const urlFetchTimeSlots = 'api/user/location-slots';
  static const urlPlaceOrder = 'api/user/place-order';
  static const urlUploadProfileImage = 'api/user/update-profile';
  static const urlFetchOrders = 'api/user/order';
  static const urlCancelOrder = 'api/user/order/';
  static const urlCartState = 'api/user/cart-status';
  static const urlFetchUserProfile = 'api/user/profile';
  static const urlUpdateFcmToken = 'api/user/update/fcm';
  static const urlDeleteAccount = 'api/user/delete-profile';
  static const urlLogoutProfile = 'api/user/logout';
  static const urlCheckEmailExists = 'api/user/check-email';
  static const urlCheckPhoneExists = 'api/user/check-phone';
  static const urlGetPaymentLink = 'api/user/order-payment-link/';
  static const urlGetInvoiceLink = 'api/user/order-invoice-link/';

}
