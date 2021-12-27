import 'dart:io';

import 'package:agre/lib/Models/ShowDailog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  bool editState = false;

  bool passwordVisability = false;
  bool country = false;
  bool subCountry = false;
  bool city = false;
  bool delegate = false;

  Map countriesData,subCountriesData,citiesData,delegatesData;

  var countryController = TextEditingController();
  var cityController = TextEditingController();
  var delegateController = TextEditingController();
  var subCountryController = TextEditingController();
  File imageFile;

  var bankNameController = TextEditingController();
  var amountController = TextEditingController();

  String pass;


  int countryId,subCountryId,cityId,delegateId;

  var nameController = TextEditingController();

  var nationalIdController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passController = TextEditingController();


  Future<void> getProfileUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse("https://7agat.app/api/current/user"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    print(mapResponse['data']);
    return mapResponse;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPass();
    getProfileUserData();
  }
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
          actions: [
            InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_forward,size: 28,color: Colors.black,)),
          ],
        backgroundColor: Colors.white,
        title: Text("الملف الشخصي",style: TextStyle(color: Colors.black),),
    centerTitle: true,
    leading: IconButton(icon: Icon(Icons.edit,color: Colors.black,), onPressed: (){
      setState(() {
        editState = !editState;
      });
    }),
        ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: getProfileUserData(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return ListView(
                children: [

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: nameController,
                      readOnly: editState ? false : true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: snapshot.data['data']['name'],
                        suffixIcon: Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)),
                                color: Colors.red[100]
                            ),
                            child: Icon(Icons.person, color: Colors.red,)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: Colors.white, width: 1)
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: phoneController,
                      readOnly: editState ? false : true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: snapshot.data['data']['phone'],
                        suffixIcon: Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)),
                                color: Colors.red[100]
                            ),
                            child: Icon(Icons.phone, color: Colors.red,)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: Colors.white, width: 1)
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: emailController,
                      readOnly: editState ? false : true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: snapshot.data['data']['email'],
                        suffixIcon: Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)),
                                color: Colors.red[100]
                            ),
                            child: Icon(Icons.email, color: Colors.red,)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: Colors.white, width: 1)
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: passController,
                      readOnly: editState ? false : true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: pass,
                        prefixIcon: editState ? passwordVisability == false ?
                        IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: () {
                            passwordVisabilityState();
                          },
                        ) :
                        IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            passwordVisabilityState();
                          },
                        ) : SizedBox(),
                        suffixIcon: Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)),
                                color: Colors.red[100]
                            ),
                            child: Icon(Icons.lock, color: Colors.red,)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: Colors.white, width: 1)
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: editState ? Colors.red : Colors.white,
                                width: 1)
                        ),
                      ),
                    ),
                  ),




                  SizedBox(),
                  editState ? InkWell(
                    onTap: () {
                        UpdateProfile(
                            snapshot.data['data']['name'],
                            snapshot.data['data']['phone'],
                            snapshot.data['data']['email'],
                            pass,
                        );


                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      child: Text(
                        "حفظ التغييرات", style: TextStyle(color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),),
                    ),
                  ) : SizedBox(),
                ],
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        ),
      ),
    );
  }
  void passwordVisabilityState (){
    setState(() {
      passwordVisability = !passwordVisability;
    });
  }

  Future<void> getUserPass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      pass = preferences.getString("pass");
    });
  }


  Future<void> _showDialog() {
    return showDialog(context: context, builder: (BuildContext) {
      return AlertDialog(
        title: Text("هل تريد التقاط الصورة من..؟",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              InkWell(
                child: Text("الأستوديو", style: TextStyle(fontSize: 20),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,),
                onTap: () {
                  openGallary();
                },
              ),

              Padding(padding: EdgeInsets.only(top: 8)),
              InkWell(
                child: Text("الكاميرا", style: TextStyle(fontSize: 20),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,),
                onTap: () {
                  openCamera();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
  Future<void> openGallary() async{
    var picture = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture.path);
      Navigator.of(context).pop();
    });
  }

  Future<void> openCamera() async{
    var  picture = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture.path);
      Navigator.of(context).pop();
    });
  }

  Future<void> UpdateProfile(name, phone, email, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    Dio dio = Dio();
    FormData formData;
    if(imageFile!=null)  {
      String fileName = imageFile.path
          .split('/')
          .last;
      formData = FormData.fromMap({
        "image":
        await MultipartFile.fromFile(imageFile.path.toString(), filename: fileName.toString()),
        "name": nameController.text.length == 0 ? name : nameController.text,
        "email": emailController.text.length == 0 ? email : emailController
            .text,
        "password": passController.text.length == 0 ? pass : passController
            .text,
        "password_confirmation": passController.text.length == 0
            ? pass
            : passController.text,
        "country_id": countryId == null ? country.toString() : countryId
            .toString(),
        "city_id": subCountryId == null ? subCountry.toString() : subCountryId
            .toString(),
        "phone": phoneController.text.length == 0 ? phone : phoneController
            .text,

      });
      preferences.setString("img", imageFile.path.toString());

    }
    else{
      print('image  null');

      formData = FormData.fromMap({
        "name": nameController.text.length == 0 ? name : nameController.text,
        "email": emailController.text.length == 0 ? email : emailController
            .text,
        "password": passController.text.length == 0 ? pass : passController
            .text,
        "password_confirmation": passController.text.length == 0
            ? pass
            : passController.text,
        "country_id": countryId == null ? country.toString() : countryId
            .toString(),
        "city_id": subCountryId == null ? subCountry.toString() : subCountryId
            .toString(),
        "phone": phoneController.text.length == 0 ? phone : phoneController
            .text,
      });
    }
    var data;
    showDialogShared(context);
    await dio.post("https://7agat.app/api/update",
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $jwt"},
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
        ))
        .then((response) {
          print(response.toString()+'ssssssssssssssssssssssssss');
      data = response.data;
      Navigator.pop(context);
      print(response);

    });
    print(data);

    if(passController.text.length!=0){
      preferences.setString("pass", passController.text);
    }

    Fluttertoast.showToast(
        msg: "تم تعديل البروفايل بنجاح",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
    setState(() {
      editState = !editState;
    });
  }

}
