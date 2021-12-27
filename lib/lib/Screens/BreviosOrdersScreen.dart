
import 'package:agre/lib/Models/CartItems.dart';
import 'package:flutter/material.dart';
import 'CartScreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ProductDetails.dart';
import 'package:http/http.dart' as http;
class BreviosOrdersScreen extends StatefulWidget {
  Map orderItemsResponse;

  BreviosOrdersScreen(this.orderItemsResponse);

  @override
  _BreviosOrdersScreenState createState() => _BreviosOrdersScreenState();
}

class _BreviosOrdersScreenState extends State<BreviosOrdersScreen> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();
  List<String> idList;

List catLength=[];
   Future<void> getProductsData()async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     String jwt = preferences.getString("jwt");
     setState(() {
       catLength=preferences.getStringList("cart");
     });
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("الطلبات السابقة",style: TextStyle(color: Colors.white),),
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

   //   endDrawer: DrawerScreen(),

      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 15,
                  childAspectRatio: (150 / 320),
                  controller: new ScrollController(keepScrollOffset: false),
                  children: List.generate(
                      widget.orderItemsResponse['items'].length, (index) {
                    return bestProductscarduI(
                        widget.orderItemsResponse['items'][index]['product']['id'],
                        widget.orderItemsResponse['items'][index]['product']['name'],
                        widget.orderItemsResponse['items'][index]['price'],
                        widget.orderItemsResponse['items'][index]['sale_price'],
                        widget.orderItemsResponse['items'][index]['tax'],

                        widget.orderItemsResponse['items'][index]['quantity'],
                        widget.orderItemsResponse['items'][index]['product']['favorites_count'],
                        widget.orderItemsResponse['items'][index]['product']['images'][0]['full']);
                  }),
                ),
        ),

      ),
    );
  }
  Widget bestProductscarduI(int id , String name , int price ,desc,tax, quantity , int favState , String img) {
    print(name);

    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id, name, price,desc,img,tax,quantity,favState)));
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
                        height: 160,)),
                  //
                  // Container(
                  //     height: 40,
                  //     width: 40,
                  //     alignment: Alignment.center,
                  //     margin: EdgeInsets.only(top: 10, right: 10),
                  //     // padding: EdgeInsets.symmetric(horizontal: 5),
                  //     // alignment: Alignment.topLeft,
                  //     decoration: BoxDecoration(
                  //         color: Colors.green.withOpacity(0.2),
                  //         borderRadius: BorderRadius.all(Radius.circular(25))
                  //     ),
                  //     // child: IconButton(icon: Icon(favState==1?Icons.favorite:Icons.favorite_border,color: Colors.green,), onPressed: () async {
                  //     //   if(favState==1){
                  //     //     DeleteFromFav(id);
                  //     //   }else {
                  //     //     AddToFavorite(id);
                  //     //   }
                  //     // })
                  // ),
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
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${quantity.toString()} قطعة",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.red),),
                                ],
                              )
                          ),
                          SizedBox(height: 3,),
                          Expanded(
                              flex: 2,
                              child: Container(alignment:Alignment.centerRight,child: Text("${price.toString()} جنيه مصري",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.red),))
                          ),
                          // Expanded(
                          //     flex: 2,
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //           flex: 1,
                          //           child: InkWell(
                          //             onTap: (){
                          //               addToCart(id);
                          //             },
                          //               child: Icon(Icons.shopping_cart,color: Colors.green,size: 30,)),
                          //         ),
                          //         SizedBox(width: 5,),
                          //         Expanded(
                          //             flex: 4,
                          //             child: InkWell(
                          //               onTap: (){
                          //                 addToCart(id);
                          //                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));
                          //               },
                          //               child: Container(
                          //                 alignment: Alignment.center,
                          //                 decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.all(Radius.circular(7)),
                          //                     color: Colors.green
                          //                 ),
                          //                 child: Text("اشتري الان",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                          //               ),
                          //             )
                          //         )
                          //       ],
                          //     )
                          // ),
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

  List<String> cartItemList;

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
    cartItemList = preferences.getStringList("carts");
    //print('${CartItemList.length}length');
    idList = preferences.getStringList("cart");
    print(idList);
    print(idList);
    if(idList!=null){
      if(!idList.contains(id.toString())) {
        if(cartItemList != null){
          cartItemList.add(jsonEncode(CartItems.formMap({
            'id':id,
            'title':name,
            'price':price,
            'sel_price':desc,
            'img':img,
            'tax':tax,
            'quantity':quantity,
          }).toMAp()));
          preferences.setStringList("carts",cartItemList);
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
      if(cartItemList == null){
        cartItemList = [jsonEncode(CartItems.formMap({
          'id':id,
          'title':name,
          'price':price,
          'sel_price':desc,
          'img':img,
          'tax':tax,
          'quantity':quantity,
        }).toMAp())];
        preferences.setStringList("carts", cartItemList);
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


  Future<void> AddToFavorite(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/favorite"), body: {
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
