


enum DeviceType { phone, tablet }
enum RegistrationType { existingCustomer,newCustomer}
enum InputBorderType { underline,outline}
enum OtpVerificationType {login,updatePhone}
enum OrderType {current,past}

enum ProfileEditingType{ name, email}
enum QtyChangeType { increase, decrease }
//only inQue,ready and cancelled is coming from server rest is handled by app itself by implementing local timer
enum OrderStatus{ inQueue, ready,cancelled,delayed,preparing,completed}


enum TipType {
  noTip,autoCalculated,userDefined
}


enum ListingType{
  mainListing,cartListing,orderDetailListing
}

enum AppLanguage{english,german}

var appLanguageValues = EnumValues({
  'english':AppLanguage.english,
  'german':AppLanguage.german,

});









enum ButtonAttrType{
  title,titleColor,backgroundColor,clickEvent
}




class EnumValues<T>{

  Map<String,T> map;
   Map<T,String>? _reverseMap;

  EnumValues(this.map);


  Map<T,String> get reverse{
    _reverseMap = map.map((key, value) => MapEntry(value, key));
    return _reverseMap!;
  }

}

