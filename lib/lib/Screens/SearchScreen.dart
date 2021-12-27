import 'dart:async';
import 'dart:convert';

import 'package:agre/lib/Models/CartItems.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'CartScreen.dart';
import 'DrawerScreen.dart';
import 'ProductDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  int id;
  String text;

  SearchScreen(this.text);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> idList;
  List itemIdList=[];
  Map mapResponse;
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();

  List<Widget> imagesSwipper = [];
  bool cartState = false;

  bool searchState = false;


  Future<void> getSpecialProducts() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/products/special"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
///////////////
  List catLength=[];
  Future<void> getProductsData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      catLength=preferences.getStringList("cart");

    });
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/products/byCategory/${widget.id}"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }

  Future<void> getProductsSearchData()async{
    return mapResponse;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Search(widget.text);

    print("hhhhhhhhhhhhhh${widget.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: Text("نتائج البحث",style: TextStyle(color: Colors.white),),
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
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.of(context).pop();

              },
              child: Icon(Icons.arrow_forward,size: 28,)),
        ],

      ),
      //endDrawer: DrawerScreen(),
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [

            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerRight,
              child: Text("المنتجات",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FutureBuilder(
                  future: getProductsSearchData(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      print( snapshot.data['data'].toString()+'ff');
                      if(snapshot.data['data']!=null) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 15,
                            childAspectRatio: (150 / 280),
                            controller: new ScrollController(keepScrollOffset: false),
                            children: List.generate(
                                snapshot.data['data'].length, (index) {
                              if (snapshot.hasData) {
                                print('${snapshot.data['data'].length}ssss');
                                print('${snapshot.data['data'][index]['images']}yyyyy');
                                return BestProductsCardUI(
                                  snapshot.data['data'][index]['id'],
                                  snapshot.data['data'][index]['name'],
                                  snapshot.data['data'][index]['sale_price'],
                                  snapshot.data['data'][index]['price'],
                                  snapshot.data['data'][index]['tax'],
                                  snapshot.data['data'][index]['quantity'],
                                  snapshot.data['data'][index]['favorites_count'],
                                  snapshot.data['data'][index]['images'].length >0?
                                  snapshot.data['data'][index]['images'][0]['full'].toString():
                                  '',
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
          ],
        ),
      ),
    );
  }


  Widget BestProductsCardUI( id,name,int desc,int price,tax,quantity,int favState,String img) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: InkWell(
        onTap: () {
          print(favState);
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id,name,price,desc,img,tax,quantity,favState)));
        },
        child: Container(
          height: 320,
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
                      child: img==''?Text('غير متوفر صورة للمنتج حاليا'):
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
                              child: Container(alignment:Alignment.centerRight,child: desc > 0?
                              Row(children: [
                                Text("$price ",style: TextStyle(color: Colors.green,decoration: TextDecoration.lineThrough),),
                                Text("$desc جنيه مصري  ",style: TextStyle(color: Colors.black),),

                              ],):Text("$price جنيه مصري ",style: TextStyle(color: Colors.green),))
                          ),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [

                                  SizedBox(width: 5,),
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
                                              color: Colors.green
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
  List<String> CartItemList;

  Future<void> addToCart( id,name,int desc,int price,int favState,String img,tax,quantity) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // List<CartItems>cartItems=List<CartItems>();
    //   cartItems.add(CartItems.formMap({
    //   'id':id,
    //   'title':name,
    //   'price':price,
    //   'sel_price':desc,
    //   'img':img,
    //   'tax':tax,
    //   'quantity':quantity,
    // }));
    //if(CartItemList==null){}
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

  Future<void> AddToFavorite(id,favState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/favorite"), body: {
      "product_id": id.toString(),
    },headers: {"Authorization": "Bearer $jwt"});
    setState(() {
      favState = 1;
    });
    Map mapResponse = json.decode(response.body);
    Fluttertoast.showToast(
        msg: mapResponse['message'],
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
        msg: "تمت العملية",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }

  // Widget FetchImages(images,id, name,price,desc,tax,quantity, favState) {
  //   snapshot.data['data'][index]['id'],
  //   snapshot.data['data'][index]['name'],
  //   snapshot.data['data'][index]['sale_price'],
  //   snapshot.data['data'][index]['price'],
  //   snapshot.data['data'][index]['tax'],
  //   snapshot.data['data'][index]['quantity'],
  //   snapshot.data['data'][index]['favorites_count'],
  //   snapshot.data['data'][index]['images'].length >0?
  //   snapshot.data['data'][index]['images'][0]['full'].toString():
  //   '',
  //   return InkWell(
  //     onTap: (){
  //       FocusScope.of(context).requestFocus(FocusNode());
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id,name,price,desc,img,tax,quantity,favState)));
  //     },
  //     child: ClipRRect(
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //         child: Image.network(images.length==0?"http://via.placeholder.com/288x188":images[0]['full'],fit: BoxFit.fill,)
  //     ),
  //   );
  // }
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
