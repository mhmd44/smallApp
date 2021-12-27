
import 'package:agre/lib/Models/ShowDailog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CartScreen.dart';
import 'ConfirmScreen.dart';
import 'HomeScreen.dart';
import 'LogInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';


class SignUpScreen extends StatefulWidget {
  var pagename='';
  SignUpScreen({@required this.pagename});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordVisability = false;
  bool passwordVisability2 = false;
  bool country = false;
  bool delegate = false;
  bool subCountry = false;
  bool city = false;
  Map countriesData,subCountriesData,citiesData,delegatesData;

  var countryController = TextEditingController();
  var delegateController = TextEditingController();
  var cityController = TextEditingController();
  var subCountryController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var passConfirmationController = TextEditingController();
  var nationalIdController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  int countryId,subCountryId,cityId,delegateId;


  Future<void> getCountriesData()async{
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/countries"));
    Map mapResponse = json.decode(response.body);
    setState(() {
      countriesData = mapResponse;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountriesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
           // autovalidate: true,
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 50,),
                Text("تسجيل مستخدم جديد",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Color(0xfff2f2f2),
                  ),
                  child: TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'يجب ادخال الإسم';
                      }
                    },
                    controller: nameController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "الإسم",
                      suffixIcon: Icon(Icons.person,color: Colors.blue,size: 30,),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Color(0xfff2f2f2),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    textAlign: TextAlign.right,
                    validator: (value) => value.isEmpty  ? EmailValidator.validate(value) ? null : "برجاء ادخال بريد الالكتروني صحيح":null,
                    decoration: InputDecoration(
                      hintText: "البريد الإلكتروني",
                      suffixIcon: Icon(Icons.email,color: Colors.yellow.shade800,size: 30,),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Color(0xfff2f2f2),
                  ),
                  child: TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'يجب ادخال كلمة المرور';
                      }
                    },
                    controller: passController,
                    textAlign: TextAlign.right,
                    obscureText: passwordVisability == false ?true:false,
                    decoration: InputDecoration(
                      hintText: "كلمة المرور",
                      suffixIcon: Icon(Icons.lock,color: Colors.red,size: 30,),
                      prefixIcon: passwordVisability == false ?
                      IconButton(
                        icon: Icon(Icons.visibility_off,color: Colors.grey.shade800,size: 30,),
                        onPressed: (){
                          passwordVisabilityState();
                        },
                      ):
                      IconButton(
                        icon: Icon(Icons.visibility,color: Colors.grey.shade800,size: 30,),
                        onPressed: (){
                          passwordVisabilityState();
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Color(0xfff2f2f2),
                  ),
                  child: TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'يجب ادخال كلمة المرور';
                      }
                    },
                    controller: passConfirmationController,
                    textAlign: TextAlign.right,
                    obscureText: passwordVisability2==false?true:false,
                    decoration: InputDecoration(
                      hintText: "تأكيد كلمة المرور",
                      suffixIcon: Icon(Icons.lock,color: Colors.red,size: 30,),
                      prefixIcon: passwordVisability2 == false ?
                      IconButton(
                        icon: Icon(Icons.visibility_off,color: Colors.grey.shade800,size: 30,),
                        onPressed: (){
                          passwordVisabilityState2();
                        },
                      ):
                      IconButton(
                        icon: Icon(Icons.visibility,color: Colors.grey.shade800,size: 30,),
                        onPressed: (){
                          passwordVisabilityState2();
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1)
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Color(0xfff2f2f2),
                  ),
                  child: TextFormField(
                    controller: phoneController,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      return  value.isEmpty ? 'من فضلك ادخل رقم هاتف صحيح'  : null;
                    },
                    decoration: InputDecoration(
                      hintText: "رقم الهاتف",
                      suffixIcon: Icon(Icons.phone,color: Colors.lightGreen,size: 30,),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1)
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                              color: Colors.red, width: 1)
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                InkWell(
                  onTap: (){

                    if (formKey.currentState.validate()) {
                      PostUserData();
                    }
                    formKey.currentState.save();

                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red,
                    ),
                    child: Text("التسجيل",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget.pagename == '' ?LogInScreen(pagename: "",):LogInScreen(pagename: 'cart')));
                        },
                        child: Text("تسجيل الدخول",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.red),)),
                    SizedBox(width: 3,),
                    Text("هل لديك حساب بالفعل؟",textDirection: TextDirection.rtl,)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void passwordVisabilityState (){
    setState(() {
      passwordVisability = !passwordVisability;
    });
  }
  void passwordVisabilityState2 (){
    setState(() {
      passwordVisability2 = !passwordVisability2;
    });
  }
  Future<void> PostUserData() async{
    showDialogShared(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(countryId);
    print(delegateId);
    print(subCountryId);
    print(cityId);
    print(phoneController);
    print(nameController.text);

    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/register"), body: {
      "name": nameController.text,
      "email": emailController.text,
      "password": passController.text,
      "password_confirmation": passConfirmationController.text,
      "phone": phoneController.text,
    });
    var mapResponse = json.decode(response.body);
    print(mapResponse.toString()+'dddd');
    if(mapResponse['data']['status']){
      preferences.setBool("logInState", true);
      preferences.setString("currentLogedEmail", emailController.text);
      preferences.setString("jwt",mapResponse['data']['token']);
      preferences.setString("point",mapResponse['data']['point']==null?"0":mapResponse['user']['point']);
      preferences.setString("balance", '${mapResponse['data']['balance']}');
      preferences.setString("pass", passController.text);
      preferences.setString("img", mapResponse['data']['image']);
      Fluttertoast.showToast(
          msg: "تم التسجيل بنجاح",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
      if(widget.pagename != 'cart'){
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => HomeScreen()), (
            Route<dynamic> route) => false);
      }else{
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CartScreen('no')));
      }
      return mapResponse;
    }
    else{
      Navigator.pop(context);
      print(mapResponse);
      Fluttertoast.showToast(
          msg: "هذا الإيميل موجود مسبقا",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }
  }
}


