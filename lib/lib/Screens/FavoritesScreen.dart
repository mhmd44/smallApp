
import 'package:agre/lib/Models/CartItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'CartScreen.dart';
import 'DrawerScreen.dart';
import 'ProductDetails.dart';
class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();
  List<String> idList;
List catLength=[];
  Future<void> getProductsFavData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    setState(() {
      catLength=preferences.getStringList("cart");

    });
    http.Response response = await http.get(Uri.parse("https://elwadyelakhdar-egy.com/api/favorites"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("المفضلة",style: TextStyle(color: Colors.white),),
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
              child: Icon(Icons.arrow_forward,size: 28,color: Colors.white,)),
        ],

      ),

     // endDrawer: DrawerScreen(),

      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: getProductsFavData(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              print(snapshot.data['favorites']);
              return snapshot.data['favorites'].length!=0?
              Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 15,
                  childAspectRatio: (150 / 320),
                  controller: new ScrollController(keepScrollOffset: false),
                  children: List.generate(snapshot.data['favorites'].length, (index) {
                    // return BestProductsCardUI(
                    //   snapshot.data['data'][index]['id'],
                    //   snapshot.data['data'][index]['name'],
                    //   int.parse('${snapshot.data['data'][index]['sale_price']=='null'||snapshot.data['data'][index]['sale_price']==null?'0':snapshot.data['data'][index]['sale_price']}'),
                    //   int.parse('${snapshot.data['data'][index]['price']=='null'||snapshot.data['data'][index]['price']==null?'0':snapshot.data['data'][index]['price']}'),
                    //   int.parse('${snapshot.data['data'][index]['favorites_count']=='null'||snapshot.data['data'][index]['favorites_count']==null?'0':snapshot.data['data'][index]['favorites_count']}'),
                    //   snapshot.data['data'][index]['images'].length >0?
                    //   snapshot.data['data'][index]['images'][0]['full'].toString(): '',
                    //   int.parse('${snapshot.data['data'][index]['tax']=='null'||snapshot.data['data'][index]['tax']==null?'0':snapshot.data['data'][index]['tax']}'),
                    //   snapshot.data['data'][index]['quantity'],
                    // );

                    return BestProductsCardUI(
                        snapshot.data['favorites'][index]['product_id'],
                        snapshot.data['favorites'][index]['product']['name'],
                        snapshot.data['favorites'][index]['product']['description'],
                        int.parse('${snapshot.data['favorites'][index]['product']['sale_price']=='null'||snapshot.data['favorites'][index]['product']['sale_price']==null?'0':snapshot.data['favorites'][index]['product']['sale_price']}'),
                         int.parse('${snapshot.data['favorites'][index]['product']['tax']=='null'||snapshot.data['favorites'][index]['product']['tax']==null?'0':snapshot.data['favorites'][index]['product']['tax']}'),
                        snapshot.data['favorites'][index]['product']['quantity'],
                        int.parse('${snapshot.data['favorites'][index]['price']=='null'||snapshot.data['favorites'][index]['price']==null?'0':snapshot.data['favorites'][index]['price']}'),
                      snapshot.data['favorites'][index]['product']['images'].length >0?
                        snapshot.data['favorites'][index]['product']['images'][0]['full'].toString(): '',
                      int.parse('${snapshot.data['favorites'][index]['product']['favorites_count']=='null'||snapshot.data['favorites'][index]['product']['favorites_count']==null?'0':snapshot.data['favorites'][index]['product']['favorites_count']}'),);
                  }),
                ),
              ):
              Center(child: Text("لا يوجد منتجات في المفضلة",style: TextStyle(color: Colors.black,fontSize: 20,),));
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        ),
      ),
    );
  }
  Widget BestProductsCardUI(id , String name , String desc ,int sel_price,tax,quantity,price, String img,fav) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id, name, price,sel_price,img,tax,quantity,1)));
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
                      child: Image(
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
                              child: Container(alignment:Alignment.centerRight,child: sel_price > 0?
                              Row(children: [
                                Text("$price ",style: TextStyle(color: Colors.red,decoration: TextDecoration.lineThrough),),
                                Text("$sel_price جنيه مصري  ",style: TextStyle(color: Colors.black),),

                              ],):Text("$price جنيه مصري ",style: TextStyle(color: Colors.red),))
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
                                          addToCart(id,name, sel_price, price, fav, img,tax,quantity);
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
                                        },
                                        child: Container(
                                          height: 45,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(7)),
                                              color: Colors.red
                                          ),
                                          child: Text("اشتري الان",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
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
  Future<void> DeleteFromFav(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/favorite/delete"), body: {
      "product_id": id.toString(),
    },headers: {"Authorization": "Bearer $jwt"});
    setState(() {
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

}
