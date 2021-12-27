import 'dart:convert';

import 'package:agre/lib/Screens/pruducts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CartScreen.dart';
class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List catLength=[];
  Future<void> getCategories()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/cats"));
    Map mapResponse = json.decode(response.body);
    setState((){
      catLength=preferences.getStringList("cart");
    }
    );
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: Text("الاقسام",style: TextStyle(color: Colors.white),),
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
      body: Padding(padding: EdgeInsets.all(5),
      child: FutureBuilder(builder: (context,snapshot){
        if(snapshot.hasData){
        return  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: .9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
              itemCount: snapshot.data['data'].length,
              itemBuilder: (context,index){
                return DeptCardUI(snapshot.data['data'][index]['id'],snapshot.data['data'][index]['name'],snapshot.data['data'][index]['image']);

          });
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },future: getCategories(),),
      ),

    );
  }
  Widget DeptCardUI(id,String name, String image,) {
    return InkWell(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("deptId", id.toString());
        //Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Products(id,name)));
      },
      child:  Container(
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

}
