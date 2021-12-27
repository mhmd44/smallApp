import 'dart:async';
import 'dart:convert';

import 'package:agre/lib/Models/CartItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'CartScreen.dart';
import 'DrawerScreen.dart';
import 'ProductDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SearchScreen.dart';
import 'package:pagination_view/pagination_view.dart';


class Products extends StatefulWidget {
  int id;
  String name;
  Products(this.id,this.name);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> idList;
  List itemIdList=[];
  Map mapResponse;
  List<String> CartItemList;
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
  Future getProductsData(idd)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/products/byCategory/$idd"));
      Map mapResponse = json.decode(response.body);
      return mapResponse;
  }

  List products=[];
  List sub=[];
  List catLength=[];

  Future getCategories(idd)async{
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/subCats/$idd"));

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {

      catLength=preferences.getStringList("cart");

    });
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    return mapResponse;
  }
  Future<void> getProductsSearchData()async{
    return mapResponse;
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
  int last_page=0;
  int page=1;
  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      page=page+1;
    });
    if(int.parse(last_page.toString()) < page){
    }
    else{
      getProductsData(c_id).then((value) {

        if(value['success'].toString()=="true"){
          setState(()
          {
            for(int i = 0 ; i< value['results']['data'].length ; i++){
              setState(() {
                products.add(value['results']['data'][i]);
              });
            }
          });
        }
        else{
        }

      }
      );
    }
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  int c_id;
   int sub_id;
  @override
  void initState() {
    setState(() {
      c_id =widget.id;
      sub_id =widget.id;
    });
    getCategories(sub_id).then((value){
      setState(() {
        sub=value['data'];
      });

    });
    getProductsData(c_id).then((value) {
      setState(()
      {
        if(value['success'].toString()=="true"){
          products=value['results']['data'];
          last_page=int.parse("${value['results']['last_page']}");
        }
        else{
          products=value['data'];
        }
      }
      );
    }
    );
    super.initState();
  }
  showDialogShared(context) {
    Color primaryColor=Theme.of(context).primaryColor;
    return showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
            child: SpinKitRotatingCircle(
              color: primaryColor,
              size: 50.0,
            ),
          );
        });
  }
  int parameter=10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: Text("${widget.name}",style: TextStyle(color: Colors.white),),
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
      body:Stack(
        alignment: Alignment.topCenter,
        children: [
           Container(
             height: MediaQuery.of(context).size.height-140,
             margin: EdgeInsets.only(top: sub.length==0?50:210.0),
             child: SmartRefresher(
               enablePullDown: true,
               enablePullUp: true,
               header: WaterDropHeader(),
               footer: CustomFooter(
                 builder: (BuildContext context,LoadStatus mode){
                   Widget body ;
                   if(mode==LoadStatus.idle){
                     body =  Text("pull up load");
                   }
                   else if(mode==LoadStatus.loading){
                     body =  CupertinoActivityIndicator();
                   }
                   else if(mode == LoadStatus.failed){
                     body = Text("Load Failed!Click retry!");
                   }
                   else if(mode == LoadStatus.canLoading){
                     body = Text("release to load more");
                   }
                   else{
                     body = Text("No more Data");
                   }
                   return Container(
                     height: 55.0,
                     child: Center(child:body),
                   );
                 },
               ),
               controller: _refreshController,
               onRefresh: _onRefresh,
               onLoading: _onLoading,
               scrollDirection: Axis.vertical,
               physics: NeverScrollableScrollPhysics(),

               child: products.length==0?
               Center(child: Padding(
                 padding: const EdgeInsets.only(top: 250.0),
                 child: Text('لا يوجد داتا'),
               ),):
               Directionality(
                 textDirection: TextDirection.rtl,
                 child: GridView.count(
                   scrollDirection: Axis.vertical,
                   crossAxisCount: 2,
                   crossAxisSpacing:3 ,
                   mainAxisSpacing: 3,
                   childAspectRatio: (150 / 250),
                   children: List.generate(
                       products.length, (index) {
                     return
                       BestProductsCardUI(
                         products[index]['id'],
                         products[index]['name'],
                         int.parse('${products[index]['sale_price']=='null'||products[index]['sale_price']==null?'0':products[index]['sale_price']}'),
                         int.parse('${products[index]['price']=='null'||products[index]['price']==null?'0':products[index]['price']}'),
                         int.parse('${products[index]['favorites_count']=='null'||products[index]['favorites_count']==null?'0':products[index]['favorites_count']}'),
                         products[index]['images'].length >0?
                         products[index]['images'][0]['full'].toString(): '',
                         int.parse('${products[index]['tax']=='null'||products[index]['tax']==null?'0':products[index]['tax']}'),
                         products[index]['quantity'],
                       );
                   }),
                 ),
               ),
             ),
           ),
          Container(
            color: Colors.white,
            height: sub.length==0?50: 200,
            child: Column(
              children: [
                sub.length==0?SizedBox(): Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerRight,
                  child: Text("الاقسام الفرعية",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                ),
                sub.length==0?SizedBox():
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 125,
                  padding: EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                      future: getCategories(sub_id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data['data']==null?Center(child: CircularProgressIndicator(),):Directionality(
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
                          return Center(child: CircularProgressIndicator()
                          );
                        }
                      }
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerRight,
                  child: Text("المنتجات",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),


              ],
            ),
          ),
        ],
      )

    );
  }


  Widget BestProductsCardUI( id,name,int desc,int price,int favState,String img,tax,quantity) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id, name,price,desc,img,tax,quantity,favState)));
        },
        child: Container(
          height: 320,
          margin: EdgeInsets.only(bottom: 5),
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
                        height: 120,)),
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
                                Text("$price ",style: TextStyle(color: Colors.red,decoration: TextDecoration.lineThrough),),
                                Text("$desc جنيه مصري  ",style: TextStyle(color: Colors.black),),
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
          }).toMAp())
          );
          preferences.setStringList("carts",CartItemList);
        }
        idList.add(id.toString());
//      ("dddddddddddddddd${cartItems.length}");
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
      }
      else{
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
  }

  Widget DeptCardUI(id,String name, String image,) {
    return InkWell(
      onTap: () async {
        showDialogShared(context);
        setState(() {
          sub_id=id;
          c_id=id;
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("deptId", id.toString());
        getCategories(sub_id).then((valuee) {
          setState(() {
            sub=valuee['data'];
          });
          getProductsData(c_id).then((value) {
            if(value['success'].toString()=="true"){
              setState(()
              {
                page=1;
                products=[];
                last_page=int.parse("${value['results']['last_page']}");
                products=value['results']['data'];
              }
              );
              Navigator.pop(context);

            }
            else {
              Navigator.pop(context);
            }
          }
          );
        });
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
    setState(() {
      favState = 1;
    });
    Map mapResponse = json.decode(response.body);
    Fluttertoast.showToast(
        msg: 'تمت العملية',
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
    Fluttertoast.showToast(
        msg: "تمت العملية",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }

  Widget FetchImages(images,id, name,price,desc,tax,quantity ,favState) {
    return InkWell(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id,name,price,desc,images[0]['full'].toString(),tax,quantity,favState)));
      },
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.network(images.length==0?"http://via.placeholder.com/288x188":images[0]['full'],fit: BoxFit.fill,)
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

    Fluttertoast.showToast(
        msg: "تمت العملية",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1
    );
  }
}
