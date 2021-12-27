import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'CartScreen.dart';
import 'HomeScreen.dart';
import 'DrawerScreen.dart';

class DepartmentScreen extends StatefulWidget {
  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {

  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();
  List catLength=[];
  Future<void> getCategories()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    http.Response response = await http.get(Uri.parse("https://7agat.app/api/cats"));
    setState(() {
      catLength=preferences.getStringList("cart");

    });
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: InkWell(onTap: (){
        },child: Text("منتجاتنا",style: TextStyle(color: Colors.white),)),
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
                if(scafoldKey.currentState.isEndDrawerOpen){
                  Navigator.of(context).pop();
                }else{
                  scafoldKey.currentState.openEndDrawer();
                }
              },
              child: Image.asset("assets/images/menu.png")),
        ],
      ),
      endDrawer: DrawerScreen(),
      body: WillPopScope(
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
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder(
            future: getCategories(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                print(snapshot.data['data'][0].toString()+'sss');
                return GridView.count(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 15,
                  children: List.generate(snapshot.data['data'].length, (index) {
                    return InkWell(onTap:(){},child: DeptCardUI(snapshot.data['data'][index]['id'],snapshot.data['data'][index]['name'],snapshot.data['data'][index]['image']));
                  }),
                );
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
          ),
        ),
      ),
    );
  }

  Widget DeptCardUI(id,String name, String image,) {
    return Padding(
      padding: const EdgeInsets.only(right: 8,left: 8),
      child: InkWell(
        onTap: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("deptId", id.toString());
         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(id,name)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width *.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image(image: NetworkImage(image),fit: BoxFit.fill,height: 200,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: Text(name,textDirection: TextDirection.rtl,textAlign:TextAlign.center,style: TextStyle(color: Colors.yellowAccent,fontSize: 12,fontWeight: FontWeight.bold),),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
