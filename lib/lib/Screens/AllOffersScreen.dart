
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'CartScreen.dart';
import 'OfferItem.dart';

class AllOffersScreen extends StatefulWidget {
  @override
  _AllOffersScreenState createState() => _AllOffersScreenState();
}

class _AllOffersScreenState extends State<AllOffersScreen> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();
List catLength=[];
  Future<void> getProductsData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    setState(() {
      catLength=preferences.getStringList("cart");

    });
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/requests"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    print("dddddssssssss"+mapResponse.toString());
    return mapResponse;
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
        backgroundColor: Colors.white,
        title: Text("طلبات عرض السعر",style: TextStyle(color: Colors.black),),
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
              child: Icon(Icons.arrow_forward,size: 28,color: Colors.black,)),
        ],
      ),
     // endDrawer: DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
            future: getProductsData(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                print(snapshot.data['reqs']);
                return snapshot.data['reqs'].length !=0?ListView.builder(
                  itemCount: snapshot.data['reqs'].length,
                    itemBuilder:(context,index){
                  return ordersCardUI(snapshot.data['reqs'][index]['request_number'],"${snapshot.data['reqs'][index]['total']}",snapshot.data['reqs'][index]['payment_method'],snapshot.data['reqs'][index]['status'],snapshot.data['reqs'][index]);
                }):
                Center(child: Text("لا يوجد طلب عرض السعر",style: TextStyle(color: Colors.black,fontSize: 20,),));

              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
        ),
      ),
    );
  }

  Widget ordersCardUI(String orderNumber,String total,String paymentMethod,String status, Map orderItems) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.red
        ),
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OfferItemScreen(orderItems)));
          },
          child: Container(
            height: 150,
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white
            ),
            child: Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("رقم الطلب :- $orderNumber",textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 7,),
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
