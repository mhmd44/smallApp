import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'CartScreen.dart';
import 'DrawerScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class ShowYorProductScreen extends StatefulWidget {
  @override
  _ShowYorProductScreenState createState() => _ShowYorProductScreenState();
}

class _ShowYorProductScreenState extends State<ShowYorProductScreen> {

  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();
  File imageFile;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var bodyController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool progresState = false;
  bool loginState = false;
  List catLength=[];
  Future<void> getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(loginState != null){
      setState(() {
        loginState = preferences.getBool("logInState");
        catLength=preferences.getStringList("cart");

      });
    }else{
      setState(() {
        loginState = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "اشحن/اعرض منتجك معنا", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading:  Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(icon: Icon(Icons.shopping_cart,color: Colors.white,), onPressed: (){
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
            }),
            Container(
              margin: EdgeInsets.only(left: 5,top: 5),
              height: 17,width: 17,decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(20),color: Colors.white,),
              child: Center(
                child: Transform.translate(
                  offset: Offset(0, -2),
                  child: Text("${catLength==null?"0":catLength.length}",style: TextStyle(color: Colors.red,fontSize: 10),textAlign: TextAlign.center,),
                ),),alignment: Alignment.center, )
          ],
        ),

        actions: [
          InkWell(
              onTap: (){
                Navigator.of(context).pop();

              },
              child: Icon(Icons.arrow_forward,size: 28,color: Colors.white,)),
        ],

      ),

      //endDrawer: DrawerScreen(),

      body: loginState?Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          //autovalidateMode: true,
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "الإسم",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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

              SizedBox(height: 15,),
              TextFormField(
                validator: (value) => EmailValidator.validate(value) ? null : "من فضلك ادخل الإيميل",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "البريد الإلكتروني",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
              SizedBox(height: 15,),
              TextFormField(
                validator: (value) {
                  return value.length < 11 ? 'من فضلك ادخل رقم هاتف صحيح' : null;
                },
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "رقم الهاتف",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
              SizedBox(height: 15,),
              InkWell(
                onTap: () {
                  _showDialog();
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.grey,
                  ),
                  child: Container(
                    height: 100,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Colors.grey[100],
                    ),
                    child: imageFile == null ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, color: Colors.red[200],
                          size: 40,),
                        SizedBox(height: 15,),
                        Text("ارفع الملف هنا", style: TextStyle(
                            color: Colors.grey[500], fontSize: 20),)
                      ],
                    ) : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.file(
                          imageFile, fit: BoxFit.fill, height: 100, width: 120,
                        )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "من فضلك ادخل الوصف";
                  }
                },
                controller: bodyController,
                textAlign: TextAlign.right,
                maxLines: 13,
                decoration: InputDecoration(
                  hintText: "اكتب هنا",
                  contentPadding: EdgeInsets.all(10),
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
              SizedBox(height: 15,),
              InkWell(
                onTap: () {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      progresState = true;
                    });
                    PostData();
                  }
                },
                child: !progresState?Container(
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: Text("إرسال", style: TextStyle(color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),),
                ):Center(child: CircularProgressIndicator()),
              )
            ],
          ),
        ),
      ):Center(child: Text('يجب تسجيل الدخول اولا',style:TextStyle(
        fontSize: 22,color: Colors.black87
      ) ,),),
    );
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
  final ImagePicker _picker = ImagePicker();

  Future<void> openGallary() async {
    var picture = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture.path);
      Navigator.of(context).pop();
    });
  }

  Future<void> openCamera() async {
    var picture = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture.path);
      Navigator.of(context).pop();
    });
  }


  Future<void> PostData() async {
    if (imageFile == null) {
      Fluttertoast.showToast(
          msg: "من فضلك اختر صورة",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    } else {
      Dio dio = Dio();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwt = preferences.getString("jwt");
      String fileName = imageFile.path
          .split('/')
          .last;
      FormData formData = FormData.fromMap({
        "file":
        await MultipartFile.fromFile(imageFile.path, filename: fileName),
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "body": bodyController.text
      });
      var data;

      await dio.post("https://7agat.app/api/charge/store",
          data: formData,
          options: Options(
            headers: {"Authorization": "Bearer $jwt"},
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
          ))
          .then((response) {
        data = response.data;
      });

      Fluttertoast.showToast(
          msg: ' تمت العملية',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
      setState(() {
        progresState = false;
      });
    }
  }
}
