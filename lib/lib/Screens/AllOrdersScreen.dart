import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'BreviosOrdersScreen.dart';
import 'CartScreen.dart';

class AllOrdersScreen extends StatefulWidget {
  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();


List catLength=[];
  Future<void> getProductsData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    setState(() {
      catLength=preferences.getStringList("cart");

    });
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/orders"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    print('ddddddddddddddddddddddddddd'+mapResponse.toString());
    return mapResponse;
  }
  @override
  void initState() {
    // TODO: implement initState
    getProductsData();
    super.initState();
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

     // endDrawer: DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
            future: getProductsData(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data['orders'].length,
                    itemBuilder:(context,index){
                  return ordersCardUI(snapshot.data['orders'][index]['order_number'],"${snapshot.data['orders'][index]['total']}",snapshot.data['orders'][index]['payment_method'],snapshot.data['orders'][index]['status'],snapshot.data['orders'][index],snapshot.data['orders'][index]['address']);
                });
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
        ),
      ),
    );
  }

  Widget ordersCardUI(String orderNumber,String total,String paymentMethod,String status, Map orderItems ,adress) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.red
        ),
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BreviosOrdersScreen(orderItems)));
          },
          child: Container(
            height: 150,
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 40,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: status=="disapprove"?Colors.red:Colors.red
                    ),
                    child: Text(status=="disapprove"?"تحت المراجعة":"تم ارسال الطلب",style: TextStyle(color: Colors.white),),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("رقم الطلب :- $orderNumber",textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 2,),
                      Text("طريقة الدفع :- $paymentMethod",textDirection: TextDirection.rtl,),
                  SizedBox(height: 2,),
                Text("العنوان :- $adress",textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold),),

                SizedBox(height: 2,),
                      Text("$total جنيه مصري",style: TextStyle(color: Colors.red,fontSize: 17,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,)

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
