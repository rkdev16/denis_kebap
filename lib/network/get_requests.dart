

import 'package:denis_kebap/model/base_res_model.dart';
import 'package:denis_kebap/model/cart_res_model.dart';
import 'package:denis_kebap/model/cart_status_res_model.dart';
import 'package:denis_kebap/model/invoice_link_res_model.dart';
import 'package:denis_kebap/model/order/orders_res_model.dart';
import 'package:denis_kebap/model/payment_link_res_model.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/model/product_variants_res_model.dart';
import 'package:denis_kebap/model/products_res_model.dart';
import 'package:denis_kebap/model/profile_res_model.dart';
import 'package:denis_kebap/model/restaurant_locations_res_model.dart';
import 'package:denis_kebap/model/time_slots_res_model.dart';
import 'package:denis_kebap/network/ApiUrls.dart';
import 'package:denis_kebap/network/remote_service.dart';

import '../model/categories_res_model.dart';

class GetRequests {
  GetRequests._();

  static Future<Temperatures?> fetchRestaurantLocations() async {
    var apiResponse = await RemoteService.simpleGet(
        ApiUrls.urlFetchRestaurantLocations);

    if (apiResponse != null) {
      return temperaturesFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<CategoriesResModel?> fetchCategories(
      String locationId
      ) async {

    var apiResponse =
    await RemoteService.simpleGet('${ApiUrls.urlFetchCategories}?location=$locationId');

    if (apiResponse != null) {
      return categoriesResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }




  static Future<ProductsResModel?> fetchProducts(
      String categoryId
      ) async {

    var apiResponse =
    await RemoteService.simpleGet('${ApiUrls.urlFetchProducts}?category=$categoryId');

    if (apiResponse != null) {
      return productsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }




  static Future<BaseResModel?> decQtyProductList(
      String productId
      ) async {

    var apiResponse =
    await RemoteService.simpleGet(ApiUrls.urlDecreaseProductQuantityProductList+productId);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<BaseResModel?> decQtyCart(
      String cartItemId
      ) async {

    var apiResponse =
    await RemoteService.simpleGet(ApiUrls.urlDecreaseProductQuantityCart+cartItemId);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }



  static Future<BaseResModel?> incQtyCart(
      String? cartItemId
      ) async {

    var apiResponse =
    await RemoteService.simpleGet(ApiUrls.urlIncreaseProductQuantityCart+ (cartItemId??''));

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }





  static Future<ProductVariantsResModel?> fetchSingleProductVariant(
      String productId
      ) async {
    var apiResponse =
    await RemoteService.simpleGet(ApiUrls.urlFetchProductVariant+productId);

    if (apiResponse != null) {
      return productVariantsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }




  static Future<CartResModel?> fetchCart(
      String locationId

      ) async {
    var apiResponse =
    await RemoteService.simpleGet('${ApiUrls.urlFetchCart}?location=$locationId');

    if (apiResponse != null) {
      return cartResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }




  static Future<TimeSlotsResModel?> fetchTimeSlots(
      String locationId

      ) async {
    var apiResponse =
    await RemoteService.simpleGet('${ApiUrls.urlFetchTimeSlots}?location=$locationId');

    if (apiResponse != null) {
      return timeSlotsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }



  static Future<OrdersResModel?> fetchOrders(
      String locationId,
      dynamic dateInMillis
      ) async {
    var apiResponse =
    await RemoteService.simpleGet('${ApiUrls.urlFetchOrders}?location=$locationId&date=$dateInMillis');

    if (apiResponse != null) {
      return ordersResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<CartStatusResModel?> fetchCartState(
      String locationId
      ) async {
    var apiResponse =
    await RemoteService.simpleGet('${ApiUrls.urlCartState}?location=$locationId');

    if (apiResponse != null) {
      return cartStatusResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<ProfileResModel?> fetchUserProfile(

      ) async {
    var apiResponse =
    await RemoteService.simpleGet(ApiUrls.urlFetchUserProfile);

    if (apiResponse != null) {
      return profileResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<BaseResModel?> logout(

      ) async {
    var apiResponse =
    await RemoteService.simpleGet(ApiUrls.urlLogoutProfile);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<PaymentLinkResModel?> getPaymentLink(
String orderId,
      num tip
      ) async {

   // final queryString = (tip ==null || tip.isEmpty ? '':'?tip=$tip').trim();

    var apiResponse =
    await RemoteService.simpleGet('${ApiUrls.urlGetPaymentLink}$orderId?tip=$tip');

    if (apiResponse != null) {
      return paymentLinkResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<InvoiceLinkResModel?> getInvoiceLink(
String orderId
      ) async {



    var apiResponse =
    await RemoteService.simpleGet(ApiUrls.urlGetInvoiceLink+orderId);

    if (apiResponse != null) {
      return invoiceLinkResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }



}