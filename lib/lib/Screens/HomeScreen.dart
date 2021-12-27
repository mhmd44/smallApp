import 'dart:async';
import 'dart:convert';


import 'package:agre/lib/Models/CartItems.dart';
import 'package:agre/lib/Screens/pruducts.dart';
import 'package:flutter/services.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'CartScreen.dart';
import 'DrawerScreen.dart';
import 'ProductDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> idList;
  List itemIdList=[];
  Map mapResponse;
  List<String> CartItemList;
   final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();

  List<Widget> imagesSwipper = [];
  bool cartState = false;

  bool searchState = false;


  Future getSpecialProducts() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/slides"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    print('dddd'+mapResponse['data'].toString());
    return mapResponse;
  }
     List catLength=[];
   Future<void> getProductsData()async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     String jwt = preferences.getString("jwt");
     http.Response response = await http.get(Uri.parse("https://7agat.app/api/products/special"),headers: {"Authorization": "Bearer $jwt"});
     Map mapResponse = json.decode(response.body);
     return mapResponse;
   }
  Future latestproducts()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/latestproducts"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  Future<void> getCategories()async{
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/cats"));
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  Future<void> getProductsSearchData()async{
    return mapResponse;
  }
  bool loginState = false;

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
     getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: ()async{
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                      margin: EdgeInsets.only(left: 30),
                      child:  Text('هل تريد الخروج من التطبيق',style: TextStyle(
                          color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold
                      ),)),
                  actions: <Widget>[
                    FlatButton(
                        color: Colors.red,
                        child: Center(
                          child:  Text('تاكيد',style: TextStyle(
                              color: Colors.white,fontSize: 18
                          ),),
                        ),
                        onPressed: () =>SystemNavigator.pop()),

                    FlatButton(

                        color: Colors.red,
                        child:  Center(child: Text('الغاء',style: TextStyle(
                            color: Colors.white,fontSize: 18
                        ),)),
                        onPressed: () => Navigator.pop(context)),
                  ],
                );
              },
            );

          },
      child: Scaffold(
        key: scafoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.red,
          title:  Image(image: AssetImage("assets/images/logo.png"),width: 100,height: 30,),
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
        ),

        endDrawer: DrawerScreen(),
        body: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 15,),

              Container(
                height: 170,
                child: FutureBuilder(
                  future: getSpecialProducts(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      if(snapshot.data['data'].length!=0) {
                        return Swiper(
                          itemBuilder: (BuildContext context, int index) {

                            return FetchImages(
                                snapshot.data['data'][index]['image'],''
                            );
                          },
                          itemCount: snapshot.data['data'].length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                        );
                      }else{
                        return Center(child: Text("لا يوجد عروض مميزة"));
                      }
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                ),
              ) ,
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                child: Text("الاقسام",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 130,
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(

                ),
                child: FutureBuilder(
                    future: getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data);
                        if (snapshot.data.length != 0) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListView.builder(
                                itemCount: snapshot.data['data'].length,
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, int index) {
                                  return DeptCardUI(snapshot.data['data'][index]['id'],snapshot.data['data'][index]['name'],snapshot.data['data'][index]['image']);
                                }
                            ),
                          );
                        }else{
                          return Center(child:CircularProgressIndicator()
                          );
                        }
                      }else{
                        return Center(child: CircularProgressIndicator()
                        );
                      }
                    }
                ),
              ),
          SizedBox(height: 15,),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("احدث المنتجات",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
              ),
              Container(
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FutureBuilder(
                      future: latestproducts(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          print( snapshot.data['data'].toString()+'ff');
                          if(snapshot.data['data']!=null) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: ListView(
                                scrollDirection: Axis.horizontal,

                                children: List.generate(
                                    snapshot.data['data'].length, (index) {
                                  if (snapshot.hasData) {
                                    return BestProductsCardUI(
                                      snapshot.data['data'][index]['id'],
                                      snapshot.data['data'][index]['name'],
                                      int.parse('${snapshot.data['data'][index]['sale_price']=='null'||snapshot.data['data'][index]['sale_price']==null?'0':snapshot.data['data'][index]['sale_price']}'),
                                      int.parse('${snapshot.data['data'][index]['price']=='null'||snapshot.data['data'][index]['price']==null?'0':snapshot.data['data'][index]['price']}'),
                                      int.parse('${snapshot.data['data'][index]['favorites_count']=='null'||snapshot.data['data'][index]['favorites_count']==null?'0':snapshot.data['data'][index]['favorites_count']}'),

                                      snapshot.data['data'][index]['images'].length >0?
                                      snapshot.data['data'][index]['images'][0]['full'].toString(): '',
                                      int.parse('${snapshot.data['data'][index]['tax']=='null'||snapshot.data['data'][index]['tax']==null?'0':snapshot.data['data'][index]['tax']}'),
                                      snapshot.data['data'][index]['quantity'],
                                    );
                                  } else {
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                }),
                              ),
                            );
                          }
                          else{
                            return Text("لا يوجد بيانات");
                          }
                        }else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int favState;
  Widget BestProductsCardUI( id,name,int desc,int price,int favState,String img,tax,quantity) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: InkWell(
        onTap: () {
          print(favState);
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id, name,price,desc,img,tax,quantity,favState)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width/2.2,
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight: Radius.circular(10)),
                      child: img==''? Image(
                        image: NetworkImage('http://via.placeholder.com/288x188'),
                        fit: BoxFit.fill,
                        height: 140,):
                      Image(
                        image: NetworkImage(img),
                        fit: BoxFit.fill,
                        height: 140,)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    // margin: const EdgeInsets.only(right: 16,left: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(alignment:Alignment.centerRight,child: Text(name,textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold),))
                          ),
                          SizedBox(height: 3,),

                          Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Container(alignment:Alignment.centerRight,child: desc > 0?
                                  Row(
                                    children: [
                                    Text("$price ",style: TextStyle(color: Colors.red,decoration: TextDecoration.lineThrough),),
                                    Text("${desc.toString()} جنيه مصري  ",style: TextStyle(color: Colors.black),),
                                  ],):Text("$price جنيه مصري ",style: TextStyle(color: Colors.red),)),
                                  // IconButton(icon: Icon(favState==1?Icons.favorite:Icons.favorite_border,color: Colors.red,), onPressed: (){
                                  //   if(loginState){
                                  //     if(mapResponse!=null) {
                                  //       if(favState== 1){
                                  //         DeleteFromFav(id,favState);
                                  //       }else {
                                  //         AddToFavorite(id,favState);
                                  //       }
                                  //     }
                                  //   }else {
                                  //     Fluttertoast.showToast(
                                  //         msg: 'يجب تسجيل الدخول',
                                  //         gravity: ToastGravity.CENTER,
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         timeInSecForIosWeb: 2
                                  //     );
                                  //   }
                                  // }),
                                ],
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: InkWell(
                                        onTap: (){
                                          addToCart( id,name, desc, price, favState, img,tax,quantity);
                                          FocusScope.of(context).requestFocus(FocusNode());
                                       //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
                                        },
                                        child: Container(
                                          height: 45,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(7)),
                                              color: Colors.red
                                          ),
                                          child: Text("اضف الي السلة",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                        ),
                                      )
                                  )
                                ],
                              )
                          ),
                          SizedBox(height: 3,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToCart( id,name,int desc,int price,int favState,String img,tax,quantity) async {
    print(desc.runtimeType.toString()+'sss');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CartItemList = preferences.getStringList("carts");
    //print('${CartItemList.length}length');
    idList = preferences.getStringList("cart");
    print(idList);
    print(idList);
    if(idList!=null){
    if(!idList.contains(id.toString())) {
      if(CartItemList != null){
        CartItemList.add(jsonEncode(CartItems.formMap({
          'id':id,
          'title':name,
          'price':price,
          'sel_price':desc,
          'img':img,
          'tax':tax,
          'quantity':quantity,
        }).toMAp()));
        preferences.setStringList("carts",CartItemList);
      }
      idList.add(id.toString());
//      print("dddddddddddddddd${cartItems.length}");
      preferences.setStringList("cart", idList);
   //   CartItemList= preferences.getStringList("carts");
    //  print(CartItemList.length.toString()+'length2');
      Fluttertoast.showToast(
          msg: "تم إضافة المنتج الي السلة",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
      FocusScope.of(context).requestFocus(FocusNode());
      //Navigator.push(context, MaterialPageRoute(builder:(context)=> CartScreen('')));
    }else{
          Fluttertoast.showToast(
          msg: "هذا المنتج تم إضافته من قبل",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }
    }else {
      idList = [id.toString()];
      if(CartItemList == null){
        CartItemList = [jsonEncode(CartItems.formMap({
          'id':id,
          'title':name,
          'price':price,
          'sel_price':desc,
          'img':img,
          'tax':tax,
          'quantity':quantity,
        }).toMAp())];
        preferences.setStringList("carts", CartItemList);
      }
      preferences.setStringList("cart", idList);
      Fluttertoast.showToast(
          msg: "تم إضافة المنتج الي السلة",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }
    print("rrrrrrrrrrrrrrrrrr$idList");
  }

  Widget DeptCardUI(id,String name, String image,) {
    return InkWell(
      onTap: () async {
        print(image);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("deptId", id.toString());
        //Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Products(id,name)));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(image: NetworkImage(image) ,fit:BoxFit.fill )
        ),
        width: 120,
        height: 110,
        child: Container(
          color: Colors.grey.withOpacity(.4),
          child:  Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.bottomCenter,
              child: Text(
                "${name}",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold
                ),
              )),
        ),
      ),
    );
  }

  Future<void> AddToFavorite(id,favState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/favorite"), body: {
      "product_id": id.toString(),
    },headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    setState(() {
      favState= 1;
    });
    Fluttertoast.showToast(
        msg: 'تم الاضافة بنجاح',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }

  Future<void> DeleteFromFav(id, favState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/favorite/delete"), body: {
      "product_id": id.toString(),
    },headers: {"Authorization": "Bearer $jwt"});

    setState(() {
      favState=0;
    });
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    Fluttertoast.showToast(
        msg: mapResponse['message'],
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }

  Widget FetchImages(image,url) {
    return InkWell(
      onTap: ()async{
       await  launch('${url}');
   },
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.network(image==null||image==''?"http://via.placeholder.com/288x188":image,fit: BoxFit.fill,)
      ),
    );
  }
String text='';
  Future<void> Search(String text) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/products/search"), body: {
      "name": text,
    },headers: {"Authorization": "Bearer $jwt"});

    setState(() {
      mapResponse = json.decode(response.body);
      searchState = true;
    });

    print(mapResponse);
    Fluttertoast.showToast(
        msg: "تمت العملية",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1
    );
  }
  }
