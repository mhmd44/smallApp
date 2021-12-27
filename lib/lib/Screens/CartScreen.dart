
import 'package:agre/lib/Models/CartItems.dart';
import 'package:agre/lib/Models/ShowDailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AllOffersScreen.dart';
import 'AllOrdersScreen.dart';
import 'HomeScreen.dart';
import 'LogInScreen.dart';
import 'ShippingScreen.dart';

class CartScreen extends StatefulWidget {
  String nav='';
  CartScreen(this.nav);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> roomCounter = [];
  List<CartItems> cartItemsList = [];
  List<String> itemIdList = [];
  bool noData = false;
  int tot=0;
  int tx = 0;
  List<String> list=[];
  bool loginState = false;
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
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartItems();
    getData();
  }
  List<String>cartItems;
  Future<void> getCartItems() async{
    itemIdList=[];
    cartItemsList=[];
    roomCounter=[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    itemIdList = preferences.getStringList("cart");

    if(itemIdList==null){
      setState(() {
        noData=true;
      });
    }
    list = preferences.getStringList("carts");
    if(list.length>0){
      for(int i=0;i<list.length;i++){
        cartItemsList.add(CartItems.formMap(jsonDecode(list[i])));
        roomCounter.add(1);
      }
      print(cartItemsList[0].selPrice.toString()+' gfgf');
      print(list[0].toString()+'hhh');

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
      if(roomCounter[i]*cartItemsList[i].selPrice > 0){
        prices.add(roomCounter[i]*cartItemsList[i].selPrice);
        tot+=roomCounter[i]*cartItemsList[i].selPrice;
      }else{
        prices.add(roomCounter[i]*cartItemsList[i].price);
        tot+=roomCounter[i]*cartItemsList[i].price;
      }
      taxes.add(roomCounter[i]*cartItemsList[i].tax);
      setState(() {
        tx+=roomCounter[i]*cartItemsList[i].tax;
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
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(onTap: (){
                  clear();
                }, child: Text('تفريغ',style: TextStyle(color: Colors.white),)),
              ),
            )
          ],
          leading: IconButton(onPressed: (){
            if(widget.nav==''||widget.nav==null){
              setState(() {
                Navigator.pop(context);
              });
            }
            else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

            }
          },icon: Icon(Icons.arrow_back),),
          backgroundColor: Colors.red,
          title: Text("سلة المشتريات",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar:
        cartItemsList.length!=0?  Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Directionality(textDirection: TextDirection.rtl,child: Container(alignment:Alignment.center,child: Text("$tot جنيه مصري",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),))),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          if(loginState==true){
                            List<int> prices=[];
                            List<int> idList = [];
                            List<int> taxes = [];
                            int total=0;
                            int taxtotal =0;
                            for(int i = 0 ; i<roomCounter.length ; i++){
                              idList.add(cartItemsList[i].id);
                              prices.add(roomCounter[i]*cartItemsList[i].price);
                              taxes.add(roomCounter[i]*cartItemsList[i].tax);
                              total+=roomCounter[i]*cartItemsList[i].price;
                              taxtotal+=roomCounter[i]*cartItemsList[i].tax;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ShippingScreen(idList, roomCounter, prices, total, taxtotal, cartItemsList, noData, tot, itemIdList, false)));
                            //showPaymentBottomSheet();
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child:  Text('يجب تسجيل الدخول اولا',style: TextStyle(
                                          color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold
                                      ),)),
                                  actions: <Widget>[

                                    FlatButton(
                                        color: Colors.red,

                                        child: Center(
                                          child:  Text('تسجيل الدخول',style: TextStyle(
                                              color: Colors.white,fontSize: 18
                                          ),),
                                        ),
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen(pagename: 'cart')))),

                                    // ignore: deprecated_member_use
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

                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.red[300],
                          ),
                          child: Center(child: Text("إتمام عملية الشراء",style: TextStyle(color: Colors.white,fontSize: 16,),)),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: 7,)
            ],
          ),
        ):SizedBox(),
        body:  WillPopScope(
          onWillPop: ()async{
            if(widget.nav==''||widget.nav==null){
              setState(() {
                Navigator.pop(context);
              });
            }
            else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top:15.0),
            child: !noData?cartItemsList.length!=0?ListView.builder(
                itemCount: cartItemsList.length,
                itemBuilder: (context,index){
                  return CartCardUI(index,cartItemsList[index].id,cartItemsList[index].title,cartItemsList[index].price,cartItemsList[index].selPrice,cartItemsList[index].img,cartItemsList[index].quantity);
                }
            ):Center(child: CircularProgressIndicator(),):Center(child: Text("لايوجد منتجات في السلة")),
          ),
        ),
      ),
    );
  }

  Widget CartCardUI(int index, int id, String title, int price,int se_price, String img, int quantity) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Container(
        color: Colors.white,
        height: 170,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(img,
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                )
            ),
            SizedBox(width: 7,),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(title,textAlign: TextAlign.right,textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold),))
                    ),
                    SizedBox(height: 3,),
                    Expanded(
                        flex: 2,
                        child: Directionality(textDirection: TextDirection.rtl,child: Container(child: se_price > 0?
                        Row(children: [
                          Text("$price ",style: TextStyle(color: Colors.red,decoration: TextDecoration.lineThrough),),
                          Text("$se_priceجنيه مصري  ",style: TextStyle(color: Colors.black),),

                        ],):Text("$price جنيه مصري ",style: TextStyle(color: Colors.red),)))
                    ),
                    Expanded(
                      flex:2,
                      child: AddProduct(index,quantity),
                    )
                  ],
                )
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.red[100]
                  ),
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: roomCounter[index]!=1?Colors.red:Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Container(
            height: 37,
            width: 37,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(20))
            ),
            // padding: EdgeInsets.all(2),
            margin: EdgeInsets.all(2),
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
                      if(roomCounter[i]*cartItemsList[i].selPrice > 0){
                        prices.add(roomCounter[i]*cartItemsList[i].selPrice);
                        tot+=roomCounter[i]*cartItemsList[i].selPrice;
                      }else{
                        prices.add(roomCounter[i]*cartItemsList[i].price);
                        tot+=roomCounter[i]*cartItemsList[i].price;
                      }
                      idList.add(cartItemsList[i].id);
                    }
                  }
                });
              },
              child: Icon(Icons.minimize, color: roomCounter[index]!=1?Colors.red:Colors.grey),
            ),
          ),
        ),
        SizedBox(width: 5,),
        Container(
          width: 70,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: Colors.white,
          ),
          child: TextFormField(

            controller: TextEditingController(text: roomCounter[index].toString()),
            onChanged: (value){
              setState(() {
                roomCounter[index]=int.parse(value.toString());
                if(roomCounter[index]!=1){
                  int number =roomCounter[index];
                  roomCounter.insert(index, number);
                  roomCounter.removeAt(index+1);
                  List<int> prices=[];
                  List<int> idList = [];
                  tot=0;
                  for(int i = 0 ; i<roomCounter.length ; i++){
                    if(roomCounter[i]*cartItemsList[i].selPrice > 0){
                      prices.add(roomCounter[i]*cartItemsList[i].selPrice);
                      tot+=roomCounter[i]*cartItemsList[i].selPrice;
                    }else{
                      prices.add(roomCounter[i]*cartItemsList[i].price);
                      tot+=roomCounter[i]*cartItemsList[i].price;
                    }
                    idList.add(cartItemsList[i].id);
                  }
                }
              });
            },
            style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 10),
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black,width: 1)
              ),

              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black,width: 1)
              ),

              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black,width: 1)
              ),

              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black,width: 1)
              ),

            ),
          ),
        ),
       // Text(roomCounter[index].toString(), style: TextStyle(fontSize: 20),),
        SizedBox(width: 5,),
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(23))
          ),
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(23))
            ),
            // padding: EdgeInsets.all(2),
            margin: EdgeInsets.all(2),
            child: InkWell(
                child: Icon(Icons.add, color: roomCounter[index]!=quantity?Colors.red:Colors.grey,),
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
                        if(roomCounter[i]*cartItemsList[i].selPrice > 0){
                          prices.add(roomCounter[i]*cartItemsList[i].selPrice);
                          tot+=roomCounter[i]*cartItemsList[i].selPrice;
                        }else{
                          prices.add(roomCounter[i]*cartItemsList[i].price);
                          tot+=roomCounter[i]*cartItemsList[i].price;
                        }
                      }
                    }
                  });
                }),
          ),
        ),
      ],
    );
  }

  Future<void> showPaymentBottomSheet() {
    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15) , topRight: Radius.circular(15))
        ),
        builder: (context){
          return Column(
            children: [
              Container(
                height: 60,
                alignment: Alignment.center,
                child: Text("اختار وسيلة دفع",style: TextStyle(color: Colors.red),),
              ),
              Divider(),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  List<int> prices=[];
                  List<int> idList = [];
                  int total=0;
                  for(int i = 0 ; i<roomCounter.length ; i++){
                    idList.add(cartItemsList[i].id);
                    prices.add(roomCounter[i]*cartItemsList[i].price);
                    total+=roomCounter[i]*cartItemsList[i].price;
                  }                showDialogShared(context);

                  AddOrder(idList, roomCounter, prices, total,"cash").then((value) {
                    Navigator.pop(context);

                  });
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red[100]
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/bitcoin.png"),
                      Spacer(),
                      Text("الدفع عند الاستلام")
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,),
              InkWell(
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  int balance = preferences.getInt("balance") ?? 0;
                  List<int> prices=[];
                  List<int> idList = [];
                  int total=0;
                  for(int i = 0 ; i<roomCounter.length ; i++){
                    idList.add(cartItemsList[i].id);
                    prices.add(roomCounter[i]*cartItemsList[i].price);
                    total+=roomCounter[i]*cartItemsList[i].price;
                  }

                  if(balance>=total) {
                    showDialogShared(context);
                    AddOrder(idList, roomCounter, prices, total,"balance").then((value) {
                      Navigator.pop(context);
                    });
                  }else{
                    Fluttertoast.showToast(
                        msg: "عفوا لا يوجد رصيد كافي",
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 2
                    );
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red[100]
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/mastercard.png"),
                      Spacer(),
                      Text("سحب من بطاقة التسوق")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  int point = preferences.getInt("point") ?? 0;
                  List<int> prices=[];
                  List<int> idList = [];
                  int total=0;
                  for(int i = 0 ; i<roomCounter.length ; i++){
                    idList.add(cartItemsList[i].id);
                    prices.add(roomCounter[i]*cartItemsList[i].price);
                    total+=roomCounter[i]*cartItemsList[i].price;
                  }

                  if(point>=total) {
                    showDialogShared(context);
                    AddOrder(idList, roomCounter, prices, total,"point").then((value) {
                      Navigator.pop(context);
                    });
                  }else{
                    Fluttertoast.showToast(
                        msg: "عفوا لا يوجد رصيد كافي",
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 2
                    );
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red[100]
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/mastercard.png"),
                      Spacer(),
                      Text("سحب من خلال النقاط")
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> AddOrder(List<int> idList,List<int> quantityList,List<int> prices, int total, String payMethod) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/order/store"), body: {
      "product_ids": idList.toString(),
      "quantitys": quantityList.toString(),
      "prices": prices.toString(),
      "payment_method": payMethod,
      "total": total.toString(),
      "name": "sss",
      "phone": "0000",
      "address": "sss",
      "country_id": "1",
      "city_id": "1",
      "town_id": "1",
    },headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    Fluttertoast.showToast(
        msg: 'تمت العملية بنجاح',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
    if(!mapResponse['error']){
      setState(() {
        roomCounter = [];
        cartItemsList = [];
        itemIdList = [];
        noData = false;
        tot=0;
        preferences.setStringList("cart",itemIdList);
        getCartItems();
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllOrdersScreen()));
      });
    }
  }
  Future<void> askprice(idList, roomCounter, prices, total) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    showDialogShared(context);
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/request/store"), body: {
      "product_ids": idList.toString(),
      "total": total.toString(),
    },headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    Fluttertoast.showToast(
        msg: 'تمت العملية بنجاح',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
    Navigator.pop(context);
    if(!mapResponse['error']){
      setState(() {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllOffersScreen()));
      });
    }
  }

}
