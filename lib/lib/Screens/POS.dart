import 'dart:convert';
import 'dart:ui';

import 'package:agre/lib/Models/CartItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class POS extends StatefulWidget {
  const POS({Key key}) : super(key: key);

  @override
  _POSState createState() => _POSState();
}

class _POSState extends State<POS> {
  List<String> idList;

  List<String> CartItemList;
  Future<void> getProductsData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://pos.waitbuzz.net/api/products/byCategory/${60}"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  List<int> roomCounter = [];
  List<CartItems> cartItemsList = [];
  List<String> itemIdList = [];
  bool noData = false;
  int tot=0;
  int tx = 0;
  List<String> list=[];
  Map catAdsResponse={};
  List ads = [];
  bool catAdsState = false;

  bool loginState = false;
  Future<void> GetCatAds(int id) async {
    ads.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    print(jwt);
    http.Response response = await http.get(Uri.parse("https://pos.waitbuzz.net/api/products/byCategory/${id}"),headers: {"Authorization": "Bearer $jwt"});

    Map mapResponse = json.decode(response.body);
    catAdsResponse = mapResponse;
    if(mapResponse['data']==null){
    }else{

      for(int i = 0 ; i<mapResponse['data'].length ; i++){
        setState(() {
          ads = mapResponse['data'];
        });
      }
    }
  }
  Future<void> getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(loginState != null){
      setState(() {
        loginState = preferences.getBool("logInState");
      });
    }else{
      setState(() {
        loginState = false;
      });
    }
   await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartItems();
    getData();
  }
  Future<void> getCartItems() async{
    itemIdList=[];
    cartItemsList=[];
    roomCounter=[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    itemIdList = preferences.getStringList("cart");
    print(itemIdList);
    String jwt = preferences.getString("jwt");
    // http.Response response = await http.get(Uri.parse("https://elwadyelakhdar-egy.com/api/allproducts"),headers: {"Authorization": "Bearer $jwt"});
    // Map mapResponse = json.decode(response.body);
    if(itemIdList==null){
      setState(() {
        noData=true;
      });
    }
    //  List<CartItems>cartItems=List<CartItems>();
    list = preferences.getStringList("carts");
    if(list.length>0){
      for(int i=0;i<list.length;i++){
        cartItemsList.add(CartItems.formMap(jsonDecode(list[i])));
        roomCounter.add(1);
      }
    }
    if(itemIdList.length==0){
      setState(() {
        noData=true;
      });
    }else{
      setState(() {
        noData=false;
      });
    }
    List<int> prices=[];
    List<int> idList = [];
    List<int> taxes=[];
    tot=0;
    for(int i = 0 ; i<roomCounter.length ; i++){
      idList.add(cartItemsList[i].id);

        prices.add(roomCounter[i]*cartItemsList[i].price);
        tot+=roomCounter[i]*cartItemsList[i].price;
      setState(() {
      });
    }
  }
  clear()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('cart');
    preferences.remove('carts');
    setState(() {
    });
    getCartItems();

  }
  Future<void> getCategories()async{
    http.Response response = await http.get(Uri.parse("https://pos.waitbuzz.net/api/cats"));
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  bool searchactive = false;

  @override
  Widget build(BuildContext context) {
   double width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: 100,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                      future: getCategories(),
                      builder: (context,snapshot){
                    if(snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data['data'].length,
                            itemBuilder: (context, index) {
                              List catList=snapshot.data['data'];
                              return InkWell(
                                onTap: (){
                                    GetCatAds(catList[index]['id']);
                                    // print(catList[index].title);
                                    // changeCardColor(index);
                                    // changeCardColor(index);
                                    // print(catList[index].title);
                                    // postCallings.latestAds(lang,jwt).then((latestAds) {
                                    //   setState(() {
                                    //     ads.clear();
                                    //     ads = latestAds;
                                    //   });
                                    // });
                                },
                                child:Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                alignment: Alignment.center,
                                                image: NetworkImage(
                                                    "${catList[index]['image']}"),
                                                fit: BoxFit.fitWidth),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${catList[index]['name']}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
    }else{
      return Center(child: CircularProgressIndicator(),);
    }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child:   ads!=null ?  ads.length !=0?
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        shrinkWrap: true,
                        mainAxisSpacing: 15,
                        physics:NeverScrollableScrollPhysics() ,
                        childAspectRatio: (150 / 280),
                        children: List.generate(
                            ads.length, (index) {
                            // print('${snapshot.data['data'].length}ssss');
                            //   print('${snapshot.data['data'][index]['images']}yyyyy');
                            return BestProductsCardUI(
                              ads[index]['id'],
                              ads[index]['name'],
                              ads[index]['price'],
                              ads[index]['images'].length >0?
                              ads[index]['images'][0]['full'].toString(): '',
                              ads[index]['quantity'],
                            );
                          }
                        ),
                      ),
                    ) :Text("لا يوجد منتجات"):
                    Text("لا يوجد منتجات")
                  ),
                ],
              ),
            )
          ),
       searchactive==false? Expanded(
            flex: 1,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:0.0),
                        child: !noData?cartItemsList.length!=0?
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartItemsList.length,
                            itemBuilder: (context,index){
                              print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$itemIdList");
                              return CartCardUI(index,cartItemsList[index].id,cartItemsList[index].title,cartItemsList[index].price,cartItemsList[index].img,cartItemsList[index].quantity);
                            }
                        ):Center(child: CircularProgressIndicator(),):Center(child: Text("لايوجد منتجات في السلة")),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:0.0),
                        child: !noData?cartItemsList.length!=0?
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartItemsList.length,
                            itemBuilder: (context,index){
                              print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$itemIdList");
                              return CartCardUI(index,cartItemsList[index].id,cartItemsList[index].title,cartItemsList[index].price,cartItemsList[index].img,cartItemsList[index].quantity);
                            }
                        ):Center(child: CircularProgressIndicator(),):Center(child: Text("لايوجد منتجات في السلة")),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:0.0),
                        child: !noData?cartItemsList.length!=0?
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartItemsList.length,
                            itemBuilder: (context,index){
                              print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$itemIdList");
                              return CartCardUI(index,cartItemsList[index].id,cartItemsList[index].title,cartItemsList[index].price,cartItemsList[index].img,cartItemsList[index].quantity);
                            }
                        ):Center(child: CircularProgressIndicator(),):Center(child: Text("لايوجد منتجات في السلة")),
                      ),
                      Container(
                        color: Colors.grey[200],
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),                              child: Text('اسم العميل',style: TextStyle(
                                  color: Colors.black ,fontWeight: FontWeight.bold
                              ),),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  searchactive=true;
                                });
                              },
                              child: Icon(Icons.add_circle,color: Theme.of(context).primaryColor,size: 50,),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.grey[200],
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('الغرف',style: TextStyle(
                                  color: Colors.black ,fontWeight: FontWeight.bold
                              ),),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Icon(Icons.add_circle,color: Theme.of(context).primaryColor,size: 50,),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('السعر',style: TextStyle(
                                color: Colors.black ,fontWeight: FontWeight.bold
                            ),),
                            Text('جنية مصري${widget.hashCode}',style: TextStyle(
                                color: Colors.green ,fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 70,),


                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60,
                    child: InkWell(
                      onTap: (){
                        FocusScope.of(context).requestFocus(FocusNode());
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
                      },
                      child: Container(

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Colors.green
                        ),
                        child: Text("شراء",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ):
       Expanded(
         flex:1,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xFFE0ECFF),

                  borderRadius: BorderRadius.circular(20)),
              child: TextField(

                textDirection: TextDirection.rtl,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {

                },
                style: TextStyle(color: Colors.green, fontSize: 18),
                textAlign: TextAlign.right,


                decoration: InputDecoration(

                  border: InputBorder.none,


                  hintText: 'ابحث عن المنتج',
                  prefixIcon: InkWell(
                    onTap: () {
                    },
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: Color(0xFFA9BDDC),
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: (){
                      setState(() {
                        searchactive=false;

                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color:Colors.green,
                    ),
                  ),
                  hintStyle: TextStyle(color: Color(0xFFA9BDDC),fontSize: 15),
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
  Widget BestProductsCardUI( id,name,int price,String img,quantity) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(id, name,price,desc,img,tax,quantity,favState)));
        },
        child: Container(
          height: 250,
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
                              child: Container(alignment:Alignment.centerRight,child: Text("$price جنيه مصري ",style: TextStyle(color: Colors.green),))
                          ),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [

                                  Expanded(
                                      flex: 4,
                                      child: InkWell(
                                        onTap: (){
                                          addToCart( id,name,  price, img,quantity);
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
                                        },
                                        child: Container(
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
  Future<void> addToCart( id,name,int price,String img,quantity) async {
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
            'img':img,
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
          'img':img,
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
  Widget CartCardUI(int index, int id, String title, int price, String img, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                    Expanded(
                        flex: 1,
                        child: Directionality(textDirection: TextDirection.rtl,child: Container(child: Text("$price جنيه مصري ",style: TextStyle(color: Colors.green),maxLines: 1,)))
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(title,textAlign: TextAlign.right,textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.normal),maxLines: 1,))
                    ),
                    SizedBox(height: 1,),

                    Expanded(
                      flex:1,
                      child: AddProduct(index,quantity),
                    ),
SizedBox(width: 4,),
            Expanded(
              flex: 0,
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.red[100]
                ),
                child: Center(
                  child: IconButton(icon: Icon(Icons.delete_outline,color: Colors.red,), onPressed: () async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    itemIdList.removeAt(itemIdList.indexOf(id.toString()));
                    list.removeAt(index);
                    preferences.setStringList("carts",list);
                    preferences.setStringList("cart",itemIdList);
                    getCartItems();
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget AddProduct(int index, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              border: Border.all(color:  roomCounter[index]!=1?Colors.green:Colors.grey,width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: InkWell(

              onTap: (){
                setState(() {
                  if(roomCounter[index]!=1){
                    int number = --roomCounter[index];
                    roomCounter.insert(index, number);
                    roomCounter.removeAt(index+1);
                    List<int> prices=[];
                    List<int> idList = [];
                    tot=0;
                    for(int i = 0 ; i<roomCounter.length ; i++){

                        prices.add(roomCounter[i]*cartItemsList[i].price);
                        tot+=roomCounter[i]*cartItemsList[i].price;


                      idList.add(cartItemsList[i].id);

                    }
                  }
                });
              },

              child: Icon(Icons.minimize,size: 15, ),
            ),
          ),
        ),
        SizedBox(width: 3,),
        Text(roomCounter[index].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(width: 3,),
        InkWell(
            child: Icon(Icons.add_circle_outline_rounded,size: 30, color: roomCounter[index]!=quantity?Colors.green:Colors.grey,),
            onTap: () {
              setState(() {
                if(roomCounter[index]!=quantity){
                  int number = ++roomCounter[index];
                  roomCounter.insert(index, number);
                  roomCounter.removeAt(index + 1);
                  List<int> prices=[];
                  List<int> idList = [];
                  tot=0;
                  for(int i = 0 ; i<roomCounter.length ; i++){
                    idList.add(cartItemsList[i].id);

                      prices.add(roomCounter[i]*cartItemsList[i].price);
                      tot+=roomCounter[i]*cartItemsList[i].price;

                  }
                }
              });
            }),
      ],
    );
  }

}
//color: roomCounter[index]!=1?Colors.green:Colors.grey