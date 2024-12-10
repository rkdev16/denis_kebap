import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/ingredient.dart';
import 'package:denis_kebap/network/ApiUrls.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  static String _formatNumber(String s) =>
      NumberFormat.decimalPattern(AppConsts.locale).format(double.parse(s));

  static printLog({required String screenName, required String message}) {
    if (AppConsts.isDebug) debugPrint("$screenName ==== $message");
  }

  static bool isResponseSuccessful(int code) {
    return code >= 200 && code < 300;
  }

   static getGreetingMessages(String message) {
   // String message = "";
    var hours = DateTime.now().hour;
    if (hours <= 12) {
      message = "Good Morning ";
    } else if (hours > 12 && DateTime.now().hour <= 16) {
      message = "Good Afternoon ";
    } else if (hours > 16 && DateTime.now().hour <= 20) {
      message = "Good Evening ";
    } else {
      message = "Good Night ";
    }
    print("message...${message}");
  }

  static String getCompleteUrl(String? url) {
    if (url == null) return '';

    if (url.startsWith('http')) {
      return url;
    } else {
      return ApiUrls.baseUrlImage + url;
    }
  }

  static double getTotal(List<double> values) {
    debugPrint("values ======= = $values");

    double result = 0;

    if (values.isEmpty) result = 0;

    return result;
  }

  static String twelveHourTimeFormat(String? time) {
    if (time != null) {
      if (time.contains(':')) {
        List<String> splitTime = time.split(':');
        int hour = int.parse(splitTime.first);
        int minute = int.parse(splitTime.last);

        if (hour <= 12) {
          return '${hour <= 9 ? '0$hour' : hour}:${minute <= 9 ? '0$minute' : minute} AM';
        } else {
          return '${(hour - 12) <= 9 ? '0${hour - 12}' : (hour - 12)}:${minute <= 9 ? '0$minute' : minute} PM';
        }
      }
      return '';
    } else {
      return '';
    }
  }

  static String formatPrice(dynamic price) {
    var priceFormatter = NumberFormat.currency(locale: "de_DE", symbol: "");

    return priceFormatter.format(price ?? 0);
  }

  static Future<String> getCityName(double latitude, double longitude) async {
    debugPrint('GET_CITY_NAME_LOCATION = $latitude, $longitude');
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    debugPrint('FIRST_PLACE_MARK = ${placemark[0].toJson()}');

    if (placemark.isNotEmpty) {
      if (placemark[0].subAdministrativeArea != null &&
          placemark[0].subAdministrativeArea!.isNotEmpty) {
        return placemark[0].subAdministrativeArea!;
      } else if (placemark[0].locality != null &&
          placemark[0].locality!.isNotEmpty) {
        return placemark[0].locality!;
      } else if (placemark[0].subLocality != null &&
          placemark[0].subLocality!.isNotEmpty) {
        return placemark[0].subLocality!;
      } else {
        return placemark[0].country ?? '';
      }
    }
    return "City";
  }




  static String getFullName(List<String?> names) {
    if (names.isEmpty) return '';

    StringBuffer result = StringBuffer();

    for (var name in names) {
      if (name != null && name.isNotEmpty) {
        result.write(name);
        result.write(' ');
      }
    }
    return result.toString().trim();
  }

  static String getTimeAgo(DateTime? time) {
    if (time == null) return '';

    String timeAgo = '';
    var minutes = DateTime.now().difference(time).inMinutes;
    if (minutes < 60) {
      timeAgo = "${minutes.round()} minutes ago";
    } else if (minutes < 1440) {
      timeAgo = "${(minutes / 60).round()} hours ago";
    } else if (minutes < 43800) {
      timeAgo = "${(minutes / 1440).round()} days ago";
    } else if (minutes < 525800) {
      timeAgo = "${(minutes / 43800).round()} months ago";
    } else {
      timeAgo = "${(minutes / 525800).round()} years ago";
    }
    return timeAgo;
  }

 static String getGreetingMessage() {
    var hours = DateTime.now().hour;
    if (hours < 12) {
      return "good_morning";
    } else if (hours < 17) {
      return  "good_afternoon";
    } else if (hours < 21) {
      return  "good_evening";
    } else {
      return  "good_evening";
    }

  }



static double calculateProductPrice({
   required double productPrice,
   required List<AddOn> addOns,
   required List<Ingredient> ingredients,
   required int quantity
 }){

    debugPrint("totalAddOnsPrice = ${totalAddonsPrice(addOns)}");
    debugPrint("totalIngredientsPrice = ${totalIngredientsPrice(ingredients)}");
    debugPrint("quantity = ${quantity}");


  return  ( productPrice + totalAddonsPrice(addOns) -  totalIngredientsPrice(ingredients)) * quantity ;
  }


 static double totalAddonsPrice(List<AddOn> addOns) {
    num result = 0;
    for (var element in addOns) {
      if (element.isChecked) {
        result += element.price;
      }
    }
    return result.toDouble();
  }


 static double totalIngredientsPrice(List<Ingredient> ingredients) {

    debugPrint("Ingredients = $ingredients");
    num result = 0;
    for (var element in ingredients) {
      if (!element.isChecked) {
        result += element.price;
      }
    }
    return result.toDouble();
  }


  static formatAmountInDecimal(String value, TextEditingController controller) {

    if(value.isEmpty) return;
    debugPrint("Value = $value");
    debugPrint("Contains_decimal_point = ${value.contains('.')}");


    String wholePart;
    String? decimalPart;

    if(value.startsWith('.')){
      value = '0.';
    }



    if(value.contains('.')){
      wholePart = value.split('.').first;
      decimalPart = value.split('.').last;



    }else{
      wholePart = value;
    }
    debugPrint("wholePart = $wholePart");
    debugPrint("decimalPart = $decimalPart");


    wholePart = _formatNumber(wholePart.replaceAll(',',''));


    StringBuffer newValue = StringBuffer(wholePart);
    newValue.write(decimalPart==null?'':'.$decimalPart');

    debugPrint("newValue = $newValue");

    controller.value = TextEditingValue(
        text: newValue.toString(), selection: TextSelection.collapsed(offset: newValue.length));
  }









  static Map<String, String> country2phone = {
    "AF": "+93",
    "AL": "+355",
    "DZ": "+213",
    "AD": "+376",
    "AO": "+244",
    "AG": "+1-268",
    "AR": "+54",
    "AM": "+374",
    "AU": "+61",
    "AT": "+43",
    "AZ": "+994",
    "BS": "+1-242",
    "BH": "+973",
    "BD": "+880",
    "BB": "+1-246",
    "BY": "+375",
    "BE": "+32",
    "BZ": "+501",
    "BJ": "+229",
    "BT": "+975",
    "BO": "+591",
    "BA": "+387",
    "BW": "+267",
    "BR": "+55",
    "BN": "+673",
    "BG": "+359",
    "BF": "+226",
    "BI": "+257",
    "KH": "+855",
    "CM": "+237",
    "CA": "+1",
    "CV": "+238",
    "CF": "+236",
    "TD": "+235",
    "CL": "+56",
    "CN": "+86",
    "CO": "+57",
    "KM": "+269",
    "CD": "+243",
    "CG": "+242",
    "CR": "+506",
    "CI": "+225",
    "HR": "+385",
    "CU": "+53",
    "CY": "+357",
    "CZ": "+420",
    "DK": "+45",
    "DJ": "+253",
    "DM": "+1-767",
    "DO": "+1-809and1-829",
    "EC": "+593",
    "EG": "+20",
    "SV": "+503",
    "GQ": "+240",
    "ER": "+291",
    "EE": "+372",
    "ET": "+251",
    "FJ": "+679",
    "FI": "+358",
    "FR": "+33",
    "GA": "+241",
    "GM": "+220",
    "GE": "+995",
    "DE": "+49",
    "GH": "+233",
    "GR": "+30",
    "GD": "+1-473",
    "GT": "+502",
    "GN": "+224",
    "GW": "+245",
    "GY": "+592",
    "HT": "+509",
    "HN": "+504",
    "HU": "+36",
    "IS": "+354",
    "IN": "+91",
    "ID": "+62",
    "IR": "+98",
    "IQ": "+964",
    "IE": "+353",
    "IL": "+972",
    "IT": "+39",
    "JM": "+1-876",
    "JP": "+81",
    "JO": "+962",
    "KZ": "+7",
    "KE": "+254",
    "KI": "+686",
    "KP": "+850",
    "KR": "+82",
    "KW": "+965",
    "KG": "+996",
    "LA": "+856",
    "LV": "+371",
    "LB": "+961",
    "LS": "+266",
    "LR": "+231",
    "LY": "+218",
    "LI": "+423",
    "LT": "+370",
    "LU": "+352",
    "MK": "+389",
    "MG": "+261",
    "MW": "+265",
    "MY": "+60",
    "MV": "+960",
    "ML": "+223",
    "MT": "+356",
    "MH": "+692",
    "MR": "+222",
    "MU": "+230",
    "MX": "+52",
    "FM": "+691",
    "MD": "+373",
    "MC": "+377",
    "MN": "+976",
    "ME": "+382",
    "MA": "+212",
    "MZ": "+258",
    "MM": "+95",
    "NA": "+264",
    "NR": "+674",
    "NP": "+977",
    "NL": "+31",
    "NZ": "+64",
    "NI": "+505",
    "NE": "+227",
    "NG": "+234",
    "NO": "+47",
    "OM": "+968",
    "PK": "+92",
    "PW": "+680",
    "PA": "+507",
    "PG": "+675",
    "PY": "+595",
    "PE": "+51",
    "PH": "+63",
    "PL": "+48",
    "PT": "+351",
    "QA": "+974",
    "RO": "+40",
    "RU": "+7",
    "RW": "+250",
    "KN": "+1-869",
    "LC": "+1-758",
    "VC": "+1-784",
    "WS": "+685",
    "SM": "+378",
    "ST": "+239",
    "SA": "+966",
    "SN": "+221",
    "RS": "+381",
    "SC": "+248",
    "SL": "+232",
    "SG": "+65",
    "SK": "+421",
    "SI": "+386",
    "SB": "+677",
    "SO": "+252",
    "ZA": "+27",
    "ES": "+34",
    "LK": "+94",
    "SD": "+249",
    "SR": "+597",
    "SZ": "+268",
    "SE": "+46",
    "CH": "+41",
    "SY": "+963",
    "TJ": "+992",
    "TZ": "+255",
    "TH": "+66",
    "TL": "+670",
    "TG": "+228",
    "TO": "+676",
    "TT": "+1-868",
    "TN": "+216",
    "TR": "+90",
    "TM": "+993",
    "TV": "+688",
    "UG": "+256",
    "UA": "+380",
    "AE": "+971",
    "GB": "+44",
    "US": "+1",
    "UY": "+598",
    "UZ": "+998",
    "VU": "+678",
    "VA": "+379",
    "VE": "+58",
    "VN": "+84",
    "YE": "+967",
    "ZM": "+260",
    "ZW": "+263",
    "GE": "+995",
    "TW": "+886",
    "AZ": "+374-97",
    "CY": "+90-392",
    "MD": "+373-533",
    "SO": "+252",
    "GE": "+995",
    "CX": "+61",
    "CC": "+61",
    "NF": "+672",
    "NC": "+687",
    "PF": "+689",
    "YT": "+262",
    "GP": "+590",
    "GP": "+590",
    "PM": "+508",
    "WF": "+681",
    "CK": "+682",
    "NU": "+683",
    "TK": "+690",
    "GG": "+44",
    "IM": "+44",
    "JE": "+44",
    "AI": "+1-264",
    "BM": "+1-441",
    "IO": "+246",
    "": "+357",
    "VG": "+1-284",
    "KY": "+1-345",
    "FK": "+500",
    "GI": "+350",
    "MS": "+1-664",
    "SH": "+290",
    "TC": "+1-649",
    "MP": "+1-670",
    "PR": "+1-787and1-939",
    "AS": "+1-684",
    "GU": "+1-671",
    "VI": "+1-340",
    "HK": "+852",
    "MO": "+853",
    "FO": "+298",
    "GL": "+299",
    "GF": "+594",
    "GP": "+590",
    "MQ": "+596",
    "RE": "+262",
    "AX": "+358-18",
    "AW": "+297",
    "AN": "+599",
    "SJ": "+47",
    "AC": "+247",
    "TA": "+290",
    "CS": "+381",
    "PS": "+970",
    "EH": "+212",
  };

  static Map<String, String> phone2Country =
      country2phone.map((key, value) => MapEntry(value, key));
}
