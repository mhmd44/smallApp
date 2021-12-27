import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CartScreen.dart';
import 'DrawerScreen.dart';
class ChargeOrders extends StatefulWidget {
  @override
  _ChargeOrdersState createState() => _ChargeOrdersState();
}

class _ChargeOrdersState extends State<ChargeOrders> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();



  Future<void> getProductsData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/balance/request/get"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("طلبات الرصيد",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.shopping_cart,color: Colors.white,), onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
        }),
        actions: [
          InkWell(
              onTap: (){
                Navigator.of(context).pop();

              },
              child: Icon(Icons.arrow_forward,size: 28,color: Colors.white,)),
        ],
      ),

      //endDrawer: DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
            future: getProductsData(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return snapshot.data['data'].length!=0? ListView.builder(
                    itemCount: snapshot.data['data'].length,
                    itemBuilder:(context,index){
                      return OrdersCardUI(snapshot.data['data'][index]['id'],snapshot.data['data'][index]['reason'],snapshot.data['data'][index]['bank_name'],"${snapshot.data['data'][index]['amount']}","${snapshot.data['data'][index]['status']}",snapshot.data['data'][index]["image"]);
                    }):
              Center(child: Text("لا يوجد طلبات رصيد",style: TextStyle(color: Colors.black,fontSize: 17,),));
              ;
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
        ),
      ),
    );
  }
  Widget OrdersCardUI(int id,String reason,String name,String amount,String status, String img) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 248,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.red
        ),
        child: InkWell(
          onTap: (){
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChargeOrdersDetails(orderItems)));
          },
          child: Container(
            height: 140,
            alignment: Alignment.center,
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.network(img,fit: BoxFit.fill,height: 100,width: 120,
                  ),
                ),
                SizedBox(height: 5,),

                Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:3,
                        child: Container(
                          height: 40,
                          // width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: status=="2"?Colors.red:status=="0"?Colors.orange:Colors.red
                          ),
                          child: Text(status=="0"?"تم ارسال الطلب":status=="1"?"تم قبول الطلب":"تم رفض الطلب",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      // Spacer(),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("اسم البنك :- $name",textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 7,),
                            reason!=null?Text("سبب الرفض :- $reason",textDirection: TextDirection.rtl,):SizedBox(),
                            SizedBox(height: 7,),
                            Text("$amount جنيه مصري",style: TextStyle(color: Colors.red,fontSize: 17,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
