import 'dart:convert';

import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/restaurant_locations_res_model.dart';
import 'package:denis_kebap/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const prefKeyIsLogin = 'pref_key_is_user_login';
  static const prefKeyIsFirstLaunch = 'pref_key_is_first_launch';
  static const prefKeyUserToken = 'pref_key_user_token';
  static const prefKeyFcmToken = 'pref_fcm_token';
  static const prefKeyLatitude = 'pref_latitude';
  static const prefKeyLongitude = 'pref_longitude';
  static const prefKeyUser= 'pref_key_user';
  static const prefKeyRestaurantLocation = 'pref_key_restaurant_location';
  static const prefKeyIsAllowAppNotification= 'pref_key_is_allow_app_notification';
  static const prefKeyAppLanguage= 'pref_key_app_language';

  static late SharedPreferences _prefs;

  PreferenceManager._();

  static Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  static Future<bool> init() async {
    _prefs = await _getInstance();
    return Future.value(true);
  }
  static bool isFirstTimeLaunch() {
    bool? isFirstLaunch = getPref(prefKeyIsFirstLaunch) as bool?;
    return isFirstLaunch ?? true;
  }

  static void save2Pref(String key, dynamic value) {
    if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is String) {
      // print('key = $key, value = $value');
      _prefs.setString(key, value);
    } else {
      // throw Exception("Attempting to save non-primitive preference");
    }
  }

  static Object? getPref(String key) {
    return _prefs.get(key);
  }
  static String get userToken => _prefs.getString(prefKeyUserToken)??'';
  static  set userToken(String? token){
    _prefs.setString(prefKeyUserToken, token??'');
  }


  static User? get user {
  String? user = _prefs.getString(prefKeyUser);
  if(user !=null){
  return User.fromJson(jsonDecode(user));
  }else{
  return null;
  }
  }
  
  
  
  static set restaurantLocation(RestaurantLocation? restaurantLocation){
    if(restaurantLocation !=null){
      _prefs.setString(prefKeyRestaurantLocation,jsonEncode(restaurantLocation.toJson()));
    }else{
      _prefs.remove(prefKeyRestaurantLocation);
    }
  }

  static RestaurantLocation? get restaurantLocation{
  String? restaurantLocation =   _prefs.getString(prefKeyRestaurantLocation);
  if(restaurantLocation !=null){
    return RestaurantLocation.fromJson(jsonDecode(restaurantLocation));
  }else{
    return null;
  }
  }

  static set user(User? user){
    if(user !=null){
      _prefs.setString(prefKeyUser,jsonEncode(user.toJson()));
    }else{
      _prefs.remove(prefKeyUser);
    }
  }


  static AppLanguage get appLanguage => appLanguageValues.map[_prefs.getString(prefKeyAppLanguage)] ?? AppLanguage.german;
  static set appLanguage(AppLanguage appLanguage){
    _prefs.setString(prefKeyAppLanguage, appLanguageValues.reverse[appLanguage]??'');
  }







  static String get token => (getPref(prefKeyUserToken)??'') as String;
  static set token(String? token){
    _prefs.setString(prefKeyUserToken, token??'');
  }




  static bool get isFirstLaunch  => (getPref(prefKeyIsFirstLaunch)??true) as bool;
  static set  isFirstLaunch(bool isFirstLaunch) {
    _prefs.setBool(prefKeyIsFirstLaunch, isFirstLaunch);

  }

  static bool get isAllowAppNotification  => (getPref(prefKeyIsAllowAppNotification)??true) as bool;
  static set  isAllowAppNotification(bool isAllowAppNotification) {
    _prefs.setBool(prefKeyIsAllowAppNotification, isAllowAppNotification);
  }


  static void clean() {
    _prefs.clear();
  }

  static void logoutUser() {
    _prefs.remove(prefKeyUserToken);
    _prefs.remove(prefKeyIsLogin);
    //  prefs.remove(prefIsFistLaunch);
  }
}
