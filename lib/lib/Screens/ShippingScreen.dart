
import 'package:agre/lib/Models/ShowDailog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AllOffersScreen.dart';
import 'AllOrdersScreen.dart';
import 'LogInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShippingScreen extends StatefulWidget {
  List<int> idList = [];
  List<int> roomCounter=[];
  List<int> prices=[];
  int total;
  int taxtotal;
  List cartItemsList;
  bool noData;
  int tot;
  bool ask;
  List<String> itemIdList;
  ShippingScreen(this.idList, this.roomCounter, this.prices, this.total, this.taxtotal, this.cartItemsList,this.noData,this.tot, this.itemIdList,this.ask);
  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  bool country = false;
  bool subCountry = false;
  bool city = false;
  int finaltotal = 0;

  int shippinCost = 0;
  Map countriesData,subCountriesData,citiesData;

  var countryController = TextEditingController();
  var cityController = TextEditingController();
  var subCountryController = TextEditingController();
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  int countryId,subCountryId,cityId;


  Future<void> getCountriesData()async{
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/countries"));
    Map mapResponse = json.decode(response.body);
    setState(() {
      countriesData = mapResponse;
    });
  }

  Future<void> getSubCountriesData(id)async{
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/getCitybyCountryId/$id"));
    Map mapResponse = json.decode(response.body);
    setState(() {
      subCountriesData = mapResponse;
    });
  }

  Future<void> getCitiesData(id)async{
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/getTownbyCityId/$id"));
    Map mapResponse = json.decode(response.body);
    setState(() {
      citiesData = mapResponse;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountriesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(!widget.ask ? "???????????? ??????????": "?????? ??????",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(!widget.ask ? "?????????? ?????????? ???????????? ??????????":"?????????? ?????????? ???????????? ??????????????",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Container(
                height: 70,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Colors.red[100],
                ),
                child: Icon(Icons.agriculture,
                  size: 35,color: Colors.red,),
              ),
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: nameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "??????????",
                    suffixIcon: Icon(Icons.person,color: Colors.red,size: 30,),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: phoneController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "?????? ????????????",
                    suffixIcon: Icon(Icons.phone,color: Colors.red,size: 30,),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),
              !widget.ask ? Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: countryController,
                  textAlign: TextAlign.right,
                  readOnly: true,
                  onTap: (){
                    setState(() {
                      country = !country;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "????????????",
                    suffixIcon: Icon(Icons.map,color: Colors.red,size: 30,),
                    prefixIcon: Icon(country?Icons.keyboard_arrow_down:Icons.keyboard_arrow_left),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ):SizedBox(),
              !widget.ask?country?countriesData!=null?Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(1),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: countriesData['data'].length,
                    itemBuilder:(context,index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          countryController.text = countriesData['data'][index]['name'];
                          countryId = countriesData['data'][index]['id'];
                          getSubCountriesData(countriesData['data'][index]['id']);
                          country = !country;
                        });
                      },
                      child: Container(
                            height: 45,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(top: 1),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.white,
                            child: Text(countriesData['data'][index]['name'],style: TextStyle(color: Colors.black),),
                          ),
                    );
                    }
                ),
              ):Center(child: CircularProgressIndicator(),):SizedBox():SizedBox(),
              !widget.ask?SizedBox(height: 10,):SizedBox(),
              !widget.ask?Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: subCountryController,
                  readOnly: true,
                  onTap: (){
                    setState(() {
                      subCountry = !subCountry;
                    });
                  },
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "????????????????",
                    suffixIcon: Icon(Icons.map,color: Colors.red,size: 30,),
                    prefixIcon: Icon(subCountry?Icons.keyboard_arrow_down:Icons.keyboard_arrow_left),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ):SizedBox(),
              !widget.ask?subCountry?subCountriesData != null?Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(1),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subCountriesData['data'].length,
                    itemBuilder:(context,index){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            subCountryController.text = subCountriesData['data'][index]['name'];
                            subCountryId = subCountriesData['data'][index]['id'];
                            getCitiesData(subCountriesData['data'][index]['id']);
                            subCountry = false;
                          });
                        },
                          child: Container(
                            height: 45,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(top: 1),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.white,
                            child: Text(subCountriesData['data'][index]['name'],style: TextStyle(color: Colors.black),),
                          ),
                        );
                    }
                ),
              ):SizedBox():SizedBox():SizedBox(),
              !widget.ask?SizedBox(height: 10,):SizedBox(),
              !widget.ask?Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: cityController,
                  readOnly: true,
                  onTap: (){
                    setState(() {
                      city = !city;
                    });
                  },
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "??????????????",
                    suffixIcon: Icon(Icons.map,color: Colors.red,size: 30,),
                    prefixIcon: Icon(city?Icons.keyboard_arrow_down:Icons.keyboard_arrow_left),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ):SizedBox(),
              !widget.ask?city?citiesData!=null?Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(1),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: citiesData['data'].length,
                    itemBuilder:(context,index){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            cityController.text = citiesData['data'][index]['name'];
                            cityId = subCountriesData['data'][index]['id'];
                            shippinCost = citiesData['data'][index]['cost'];
                            print(citiesData);
                            city = !city;
                            finaltotal = [widget.taxtotal, widget.total, shippinCost].fold(0, (p, c) => p + c);
                          });
                        },
                          child: Container(
                            height: 45,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(top: 1),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.white,
                            child: Text(citiesData['data'][index]['name'],style: TextStyle(color: Colors.black),),
                          ),
                        );
                    }
                ),
              ):SizedBox():SizedBox():SizedBox(),
              !widget.ask?SizedBox(height: 10,):SizedBox(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: addressController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "??????????????",
                    suffixIcon: Icon(Icons.person,color: Colors.red,size: 30,),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              !widget.ask?Container(
                child: Column(
                  children: [
                ListTile(
                  title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("???????????? ????????????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
                  leading: Directionality(textDirection: TextDirection.rtl, child:Text("${widget.total} ???????? ????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)),
                ),
                    ListTile(
                      title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("?????????? ??????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
                      leading: Directionality(textDirection: TextDirection.rtl, child:Text("${shippinCost} ???????? ????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)),
                    ),
                    ListTile(
                      title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("??????????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
                      leading: Directionality(textDirection: TextDirection.rtl, child:Text("${widget.taxtotal} ???????? ????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)),
                    ),
                    finaltotal != 0 ?
                    ListTile(
                      title: Container(child: Directionality(textDirection: TextDirection.rtl, child: Text("????????????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),))),
                      leading: Directionality(textDirection: TextDirection.rtl, child:Text("${finaltotal} ???????? ????????",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)),
                    ):SizedBox(height: 0,)
                ]
              ),
              ):SizedBox(),
              InkWell(
                onTap: (){
                  if(widget.ask == true){
                    if(nameController.text==''&&phoneController.text==''&&addressController.text==''){
                   showDialog(context: context, builder: (context){
                     return AlertDialog(
                       content: Text('?????? ?????????? ???????? ????????????????'),
                       actions: [IconButton(onPressed: (){
                         Navigator.pop(context);
                       }, icon: Text('????',style: TextStyle(color: Colors.red,fontSize: 18),))],
                     );
                   });

                      }
                    else{
                      askprice(widget.idList, widget.roomCounter, widget.prices, widget.total);
                    }
                    }else{
                    if(nameController.text==''&&phoneController.text==''&&addressController.text==''&&cityController.text==''&&countryController.text==''&&subCountryController.text==''){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Text('?????? ?????????? ???????? ????????????????'),
                          actions: [IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Text('????',style: TextStyle(color: Colors.red,fontSize: 18),))],
                        );
                      });

                    }
                    else{
                            showPaymentBottomSheet();
                    }
                    }


                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: Text("?????????? ??????????",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
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
                child: Text("?????????? ?????????? ??????",style: TextStyle(color: Colors.red),),
              ),
              Divider(),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  AddOrder(widget.idList, widget.roomCounter, widget.prices, finaltotal,"cash");
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
                      Text("?????????? ?????? ????????????????")
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,),
              InkWell(
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  int balance = preferences.getInt("balance") ?? 0;
                  if(balance>=finaltotal) {
                    AddOrder(widget.idList, widget.roomCounter, widget.prices, finaltotal,"balance");
                  }else{
                    Fluttertoast.showToast(
                        msg: "???????? ???? ???????? ???????? ????????",
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
                      Text("?????? ???? ?????????? ????????????")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  int point = preferences.getInt("point") ?? 0;
                  if(point>=finaltotal) {
                    AddOrder(widget.idList, widget.roomCounter, widget.prices, finaltotal,"point");
                  }else{
                    Fluttertoast.showToast(
                        msg: "???????? ???? ???????? ???????? ????????",
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
                      Text("?????? ???? ???????? ????????????")
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
    print(idList);
    showDialogShared(context);
    Map mapResponse ;

    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/order/store"), body: {
      "product_ids": idList.toString(),
      "quantitys": quantityList.toString(),
      "prices": prices.toString(),
      "payment_method": payMethod,
      "total": finaltotal.toString(),
      "name": nameController.text,
      "address": addressController.text,
      "country_id": countryId.toString(),
      "city_id": subCountryId.toString(),
      "town_id": cityId.toString(),
      "phone": phoneController.text,
    },headers: {"Authorization": "Bearer $jwt"}).then((value){
      mapResponse=jsonDecode(value.body);
      Navigator.pop(context);
    });
    print(mapResponse);
    Fluttertoast.showToast(
        msg: mapResponse['message'],
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
    if(!mapResponse['error']){
      setState(() {
        widget.roomCounter = [];
        widget.cartItemsList = [];
        widget.itemIdList = [];
        widget.noData = false;
        widget.tot=0;
        preferences.remove('cart');
        preferences.remove('carts');
        // preferences.setStringList("cart",widget.itemIdList);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllOrdersScreen()));
      });
    }
  }
  Future<void> askprice(List<int> idList, List<int> quantityList, List<int> prices, int total) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map mapResponse ;
    String jwt = preferences.getString("jwt");
    showDialogShared(context);
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/request/store"),
        body: {
      "product_ids": idList.toString(),
      "quantitys": quantityList.toString(),
      "prices": prices.toString(),
      "total": total.toString(),
      "name": nameController.text,
      "address": addressController.text,
      "phone": phoneController.text,
    },headers: {"Authorization": "Bearer $jwt"}).then((value) {
      mapResponse=jsonDecode(value.body);
      print(mapResponse.toString()+'ssssssdddd');
      Navigator.pop(context);
    });
    Fluttertoast.showToast(
        msg: '?????? ??????????',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
    if(!mapResponse['error']){
      setState(() {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllOffersScreen()));
      });
    }
  }
}


