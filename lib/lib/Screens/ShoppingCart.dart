import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import 'CartScreen.dart';
import 'ChargeOrders.dart';
import 'DrawerScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();

  bool chargeState = false;

  File imageFile;

  var bankNameController = TextEditingController();
  var amountController = TextEditingController();


  bool progressState = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();
  }
List catLength=[];
  Future<void> getBalance()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    setState(() {
      catLength=preferences.getStringList("cart");

    });
    http.Response response = await http.post(Uri.parse("https://7agat.app/api/current/user"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("بطاقة التسوق",style: TextStyle(color: Colors.white),),
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

     // endDrawer: DrawerScreen(),

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FutureBuilder(
            future: getBalance(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 150,
                            // borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: SvgPicture.asset(
                              "assets/images/cart.svg", fit: BoxFit.fill,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("النقاط", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10,),
                                      Text("${snapshot.data['data']['point']} LE", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("رصيدي", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10,),
                                      Text("${snapshot.data['data']['balance']} LE", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      DottedBorder(
                        color: Colors.red,
                        strokeWidth: 2,
                        dashPattern: [6],
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              chargeState = true;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.red[100],
                            height: 55,
                            child: Text("اشحن بطاقة التسويق",
                              style: TextStyle(color: Colors.red),),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }else{
                return Center(child: CircularProgressIndicator());
              }
            }
          ),
      chargeState?Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
        ),
        elevation: 15,
        child: Container(
          height: MediaQuery.of(context).size.height *.8,
          child: Column(
            children: [
              Container(
                height: 55,
                alignment: Alignment.center,
                child: Text("إضافة رصيد",style: TextStyle(color: Colors.red,fontSize: 17),),
              ),
              Divider(),
              SizedBox(height: 20,),
              imageFile == null? InkWell(
                onTap: (){
                  _showDialog();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 125),
                  height: 100,
                  child: Icon(Icons.add_a_photo,size: 90,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(0xffeeeeee),
                  ),
                ),
              ):Padding(
                padding: const EdgeInsets.symmetric(horizontal: 125),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.file(imageFile,fit: BoxFit.fill,height: 100,width: 120,
                    )
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.red[100],
                ),
                child: TextFormField(
                  controller: bankNameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "اسم البنك",
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
              ),

              SizedBox(height: 10,),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.red[100],
                ),
                child: TextFormField(
                  controller: amountController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "المبلغ",
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
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  setState(() {
                    setState(() {
                      progressState = true;
                    });
                    PostBalance(imageFile,bankNameController.text,amountController.text);
                  });
                },
                child: !progressState?Container(
                  height: 55,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: Text("إضافة",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                ):Center(child: CircularProgressIndicator()),
              )
            ],
          ),
        ),
      ):SizedBox(),
        ],
      ),
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

  Future<void> openGallary() async{
    var picture = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture.path);
      Navigator.of(context).pop();
    });
  }
  final ImagePicker _picker = ImagePicker();

  Future<void> openCamera() async{
    var picture = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture.path);
      Navigator.of(context).pop();
    });
  }

  Future<void> PostBalance(File imageFile, String bank,String amount) async {
    print(imageFile);

    if(imageFile==null){
      Fluttertoast.showToast(
          msg: "من فضلك اختر صورة",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }else {
      Dio dio = Dio();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwt = preferences.getString("jwt");
      String fileName = imageFile.path
          .split('/')
          .last;
      FormData formData = FormData.fromMap({
        "image":
        await MultipartFile.fromFile(imageFile.path, filename: fileName),
        "bank_name": bank,
        "amount": amount,
      });
      var data;

      await dio.post("https://7agat.app/api/balance/request/store",
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
      print(data);
      Fluttertoast.showToast(
          msg: 'تمت العملية',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
      if (data['error'] == false) {
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // preferences.setString("balance", amountController.text);
        setState(() {
          // balance = amountController.text;
        });
        imageFile = null;
        bankNameController.text = "";
        amountController.text = "";
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChargeOrders()));
      }
    }
    setState(() {
      progressState = false;
    });
  }

}
