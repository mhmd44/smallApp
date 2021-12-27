
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AboutUsScreen.dart';
import 'AllOrdersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CartScreen.dart';
import 'Categories.dart';
import 'ChargeOrders.dart';
import 'ContactUsScreen.dart';
import 'FavoritesScreen.dart';
import 'HomeScreen.dart';
import 'LogInScreen.dart';
import 'ProfileScreen.dart';
import 'RecomendationScreen.dart';
import 'ShoppingCart.dart';
import 'ShowYorProductScreen.dart';
import 'SignUpScreen.dart';
class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  var _listItems = <Widget>[];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  String img;

  int balance;
  Map userdata;

  String deptId;
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
  Future<void> getProfileUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse("https://7agat.app/api/current/user"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    setState(() {
      userdata = mapResponse;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _loadItems();
    getProfileUserData();

  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          AnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            padding: EdgeInsets.only(top: 10),
            initialItemCount: _listItems.length,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                position: CurvedAnimation(
                  curve: Curves.easeOut,
                  parent: animation,
                ).drive((Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset(0, 0),
                ))),
                child: _listItems[index],
              );
            },
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
  void _loadItems() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      img = preferences.getString("img");
      deptId = preferences.getString("deptId");
    });
    _listItems.clear();
    // fetching data from web api, db...
    final fetchedList = [
      Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("الرئيسية",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.home,color: Colors.red, size: 25,),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Categories()));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("الاقسام",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.category,color: Colors.red, size: 25,),
            ),
          ),
          loginState ?
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("الحساب الشخصي",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.person,color: Colors.red, size: 25,),
            ),
          ) : SizedBox(),

          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("سلة المشتريات",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.shopping_cart,color: Colors.red, size: 25,),
            ),
          ),
          loginState ? InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoritesScreen()));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("المنتجات المفضلة",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.favorite,color: Colors.red,size: 25),
            ),
          ): SizedBox(),
          loginState ? InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllOrdersScreen()));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("الطلبات السابقة",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.card_travel,color: Colors.red,size: 25),
            ),
          ): SizedBox(),


          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsScreen()));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("من نحن ؟",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.error,color: Colors.red,size: 25),
            ),
          ),

          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUsScreen()));
            },
            child: ListTile(
              title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("اتصل بنا",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
              leading: Icon(Icons.chevron_left,),
              trailing: Icon(Icons.phone,color: Colors.red,size: 25),
            ),
          ),
          loginState ? ListTile(
            onTap: () async {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen(pagename: '',)));
            },
            title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("تسجيل الخروج",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
            leading: Icon(Icons.chevron_left,),
            trailing: Icon(Icons.exit_to_app,color: Colors.red,size: 25),
          ) :
          ListTile(
            onTap: () async {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInScreen(pagename: '',)));
            },
            title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("تسجيل دخول",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
            leading: Icon(Icons.chevron_left,),
            trailing: Icon(Icons.login_outlined,color: Colors.red,size: 25),
          ),

        ],
      ),

    ];

    var future = Future(() {});
    for (var i = 0; i < fetchedList.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 150), () {
          _listItems.add(fetchedList[i]);
          _listKey.currentState.insertItem(_listItems.length - 1);
        });
      });
    }
  }

}
