import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CacheHelper{
 static  SharedPreferences  sharedprefernces ;
  static init()async{
   sharedprefernces = await SharedPreferences.getInstance();
 }
 Future<bool> putData({
  @required String key,
  @required bool value,
})async{
 return await  sharedprefernces.setBool(key, value);
 }
 Future<bool> getData({
 @required String key,

 })async {
   return await sharedprefernces.getBool(key);
 }

}