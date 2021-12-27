
import 'package:agre/lib/Models/ShowDailog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'CartScreen.dart';
import 'ForgotPassword.dart';
import 'HomeScreen.dart';
import 'SignUpScreen.dart';

class LogInScreen extends StatefulWidget {
  var pagename='';
  LogInScreen({@required this.pagename});
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool passwordVisability = false;
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passController = TextEditingController();


  @override
  void initState() {

    super.initState();
    createDB();
  }
  void createDB()async{
    var database = await openDatabase(
        'todo.db',
        version: 1,
        onCreate: (data, version){
          print ('database created');
          data.execute('CREATE TABLE TASKS (id INTEGER PRIMARY KEY, title TEXT ,date TEXT, time TEXT, status TEXT)').then((value) => print ('table created')).catchError((onError){print('errrror when create table ${onError.toString()}');});
        },
        onOpen: (data){
          print ('database opened');

        }
    );
  }
  @override
  Widget build(BuildContext context) {
///////////// adding


    Future< String> getName() async{
      return  'ahmed ali';
    }


    getName().then((value)  {
      print(value); print('hello');
      throw('errrrrorr');
    }).catchError((onError){print(onError.toString());});




    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            //autovalidate: true,
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 60,),
                Text("تسجيل الدخول", textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),),

                SizedBox(height: 25,),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Color(0xfff2f2f2),
                  ),
                  child: TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                      return 'يجب ادخال البريد ';
                    }
                      },
                    controller: emailController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "البريد الإلكتروني",
                      suffixIcon: Icon(
                        Icons.email, color: Colors.red, size: 30,),
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
                    controller: passController,
                    textAlign: TextAlign.right,
                    obscureText: passwordVisability?false:true,
                    validator: (value){
                      if(value.isEmpty){
                        return 'يجب ادخال كلمة المرور ';
                      }
                    },
                    decoration: InputDecoration(

                      hintText: "كلمة المرور",
                      suffixIcon: Icon(
                        Icons.lock, color: Colors.red, size: 30,),
                      prefixIcon: passwordVisability == false ?
                      IconButton(
                        icon: Icon(
                          Icons.visibility_off, color: Colors.red, size: 30,),
                        onPressed: () {
                          passwordVisabilityState();
                        },
                      ) :
                      IconButton(
                        icon: Icon(
                          Icons.visibility, color: Colors.red, size: 30,),
                        onPressed: () {
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

                SizedBox(height: 3,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPassword()));
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text("نسيت كلمة المرور؟")),
                ),
                SizedBox(height: 15,),

                 InkWell(
                  onTap: () {
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
                    child: Text("تسجيل الدخول", textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => widget.pagename == '' ? SignUpScreen(pagename: '',):SignUpScreen(pagename: 'cart',)));
                        },
                        child: Text(
                          "ليس لديك حساب؟", textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.red),)),
                    SizedBox(width: 3,),
                    Text("تسجيل مستخدم جديد", textDirection: TextDirection.rtl,)
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                    onTap: () async{
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.setBool("logInState", false);
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (context) => HomeScreen()), (
                          Route<dynamic> route) => false);
                    },
                    child: Center(child: Text("تخطي",style: TextStyle(color: Colors.red),))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void passwordVisabilityState() {
    setState(() {
      passwordVisability = !passwordVisability;
    });
  }
  Future<void> PostUserData() async{
    showDialogShared(context);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(emailController.text);
    print(passController.text);
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/login"),
        body: {
      "email": emailController.text,
      "password": passController.text,
    });
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    if(mapResponse['success']){
      preferences.setBool("logInState", true);
      preferences.setString("currentLogedEmail", emailController.text);
      preferences.setString("jwt",mapResponse['user']['token']);
      preferences.setInt("point",int.parse(mapResponse['user']['point'].toString()));
      preferences.setInt("balance", int.parse(mapResponse['user']['balance'].toString()));
      preferences.setString("pass", passController.text);
      preferences.setString("img", mapResponse['user']['image']);
      Fluttertoast.showToast(
          msg: "تم تسجيل الدخول بنجاح",
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
    }else{
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: mapResponse['message'],
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }
  }

}
