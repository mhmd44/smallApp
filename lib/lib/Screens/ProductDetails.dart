
import 'package:agre/lib/Models/CartItems.dart';
import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AllOffersScreen.dart';
import 'AllOrdersScreen.dart';
import 'CartScreen.dart';
class ProductDetails extends StatefulWidget {
  String title;
  int id,price,sel_price,quantity,tax;
  String name ;
  String image;
  int favState;

  ProductDetails(this.id, this.name,this.price,this.sel_price,this.image,this.tax,this.quantity,this.favState);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>{
  List<String> urlList =[];
  Map mapResponse;
  List<String> idList;
  List<String> CartItemList;
  List<String> idLists;
  List<String> idListss = [];
  bool cartState = false;
  int balance;
  Map userdata;
  double totalRate = 0;
  var commentController = TextEditingController();
  var title;
  Map commentResponse;
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
  Future<Map> getOrderProduct()async{
    return mapResponse;
  }
  Future<void> getProfileUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse("https://7agat.app/api/current/user"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    setState(() {
      userdata = mapResponse;
    });
    print("eeeeeeeeee ${userdata}");
  }

  Future<void> getProductData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    print("uuuuuuuuuu ${jwt}");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/product/${widget.id}"),headers: {"Authorization": "Bearer $jwt"});
    mapResponse = json.decode(response.body);

    print("qqqqqqqqqqq ${mapResponse['data']['name']}");
    return mapResponse;
  }


  Future<void> getProductCommentsData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://7agat.app/api/comment/${widget.id}"),headers: {"Authorization": "Bearer $jwt"});
    commentResponse = json.decode(response.body);
    return commentResponse;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileUserData();
    getData();
    getProductData();
    print(widget.name.toString()+'dddd');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("${widget.name}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(icon: Icon(widget.favState==1?Icons.favorite:Icons.favorite_border,color: Colors.red,), onPressed: (){
              if(loginState){
                if(mapResponse!=null) {
                  if(widget.favState== 1){
                    DeleteFromFav(mapResponse['data']['id']);
                  }else {
                    AddToFavorite(mapResponse['data']['id']);
                  }
                }
              }else {
                Fluttertoast.showToast(
                    msg: 'يجب تسجيل الدخول',
                    gravity: ToastGravity.CENTER,
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 2
                );
              }
                    }),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getProductData(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      height: 220,
                      child: Stack(
                        children: [
                          Center(child: CircularProgressIndicator(),),
                          Carousel(
                            // onImageTap: onImageTap,
                            radius: Radius.circular(115),
                            animationCurve: Curves.fastOutSlowIn,
                            images: FetchImages(snapshot.data['data']['images']),
                            autoplay: true,
                            boxFit: BoxFit.fill,
                            // animationDuration: Duration(seconds: 6),
                            autoplayDuration: Duration(seconds: 7),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    snapshot.data['data']['name'],
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),),
                                ),

                              ],
                            ),
                            SizedBox(height: 10,),
                            snapshot.data['data']['sale_price'] !=0   ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("${snapshot.data['data']['price']} ",style: TextStyle(color: Colors.red,decoration: TextDecoration.lineThrough),),
                                Text("${snapshot.data['data']['sale_price']}جنيه مصري  ",style: TextStyle(color: Colors.black),),
],
                            ):
                            Text("${snapshot.data['data']['price']} جنيه مصري", style: TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,),textDirection: TextDirection.rtl,),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: (){

                                      addToCart("yes");
                                    },
                                    child: Center(
                                      child: Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width*.7,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white,
                                        ),
                                        child: Text("اشتري الان",style: TextStyle(color: Colors.black,fontSize: 18,),),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: (){
                                      addToCart("no");
                                    },
                                    child: Center(
                                      child: Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width*.7,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: Text("اضف الى السلة",style: TextStyle(color: Colors.white,fontSize: 18,),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.only(left: 15.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                  snapshot.data['data']['description'],textAlign: TextAlign.right,
                              ),
                            ),
                            loginState ? Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                      child: Image(image: NetworkImage(
                                          "http://via.placeholder.com/288x188")
                                        , fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3,),
                                Expanded(
                                  flex: 12,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(27)),
                                      color: Colors.grey[100],
                                    ),
                                    child: TextFormField(
                                      // controller: msgController,
                                      textAlign: TextAlign.right,
                                      readOnly:true,
                                      textDirection: TextDirection.rtl,
                                      onTap: (){
                                        AddCommentAndRateDialog(snapshot.data['data']['id']);
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        hintText: "اكتب تعليقك هنا",
                                        hintStyle: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(27)),
                                          borderSide: BorderSide(
                                              color: Colors.white),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(27)),
                                          borderSide: BorderSide(
                                              color: Colors.white),
                                        ),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(27)),
                                          borderSide: BorderSide(
                                              color: Colors.white),
                                        ),

                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(27)),
                                          borderSide: BorderSide(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
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
  List<Widget> FetchImages(images) {
    List<Widget> imagesUrl = [];
    if(images.length==0){
      imagesUrl.add(Image.network("http://via.placeholder.com/288x188"));
    }else {
      for (int i = 0; i < images.length; i++) {
        urlList.add(images[i]['full']);
        imagesUrl.add(Image.network(urlList[i]));
      }
    }
    return imagesUrl;
  }

  Future<void> AddToFavorite(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/favorite"), body: {
      "product_id": id.toString(),
    },headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    setState(() {
      widget.favState= 1;
    });
    Fluttertoast.showToast(
        msg: 'تم الاضافة بنجاح',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }

  Future<void> AddCommentAndRateDialog(int id) {
    return showDialog(context: context, builder: (BuildContext){
      return AlertDialog(
          content: SingleChildScrollView(
              child: ListBody(
                children: [
                  SizedBox(height: 10,),
                  RatingBar(
                    initialRating: 0,
                    isHalfAllowed: false,
                    filledColor: Colors.amber,
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border, onRatingChanged: (double rating) {
                    totalRate = rating;
                  },
                  ),

                  SizedBox(height: 15,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Color(0xfff2f2f2),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      controller: commentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "اكتب تعليقك",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Text("إلغاء",textDirection: TextDirection.rtl,style: TextStyle(fontSize: 16,color: Colors.white),),
                          padding: EdgeInsets.all(10),
                          onPressed: (){
                            Navigator.pop(context);
                          }
                      ),
                      SizedBox(width: 10,),
                      RaisedButton(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Text("إضافة",textDirection: TextDirection.rtl,style: TextStyle(fontSize: 16,color: Colors.white),),
                          padding: EdgeInsets.all(10),
                          onPressed: (){
                            AddMyRateAndComment(id,totalRate,commentController.text);
                            Navigator.pop(context);
                          }
                      ),
                    ],
                  ),

                  SizedBox(height: 15,),
                ],
              )
          )
      );
    });
  }

  Future<void> AddMyRateAndComment(int id, double rate, String comment) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/comment"), body: {
      "product_id": id.toString(),
      "body": comment,
      "stars": rate.toString()
    },headers: {"Authorization": "Bearer $jwt"});
    setState(() {
      commentResponse = json.decode(response.body);
    });
    print(mapResponse);
    Fluttertoast.showToast(
        msg: "تم إرسال تعليقك وسيتم نشره قريبا",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }

  Widget CommentsCardUI(comment,stars,userName,String img) {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(30)),
              child: Image(image: NetworkImage(img)
                , fit: BoxFit.fill,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(userName,
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                RatingBar.readOnly(
                  initialRating: double.parse(stars),
                  isHalfAllowed: false,
                  filledColor: Colors.amber,
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  size: 17,
                ),
              ],
            ),
            Spacer(),
            IconButton(icon: Icon(Icons.more_horiz),
              onPressed: () {},),
          ],
        ),
        SizedBox(height: 7,),
        Container(
          child: Text(
            comment,
            textDirection: TextDirection.rtl, style: TextStyle(color: Colors.grey[400]),),
        ),
        Divider()
      ],
    );
  }

  Future<void> DeleteFromFav(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/favorite/delete"), body: {
      "product_id": id.toString(),
    },headers: {"Authorization": "Bearer $jwt"});

    setState(() {
      widget.favState=0;
    });
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    Fluttertoast.showToast(
        msg: 'تم الحذف بنجاح',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }

  Future<void> addToCart(check) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    CartItemList = preferences.getStringList("carts");
    idList = preferences.getStringList("cart");
    print(idList);
    print(idList);
    if(idList!=null){
      if(!idList.contains(widget.id.toString())) {
        if(CartItemList != null){
          CartItemList.add(jsonEncode(CartItems.formMap({
            'id':widget.id,
            'title':widget.name,
            'price':widget.price,
            'sel_price':widget.sel_price,
            'img':widget.image,
            'tax':widget.tax,
            'quantity':widget.quantity,
          }).toMAp()));
          preferences.setStringList("carts",CartItemList);
        }
        idList.add(widget.id.toString());
        preferences.setStringList("cart", idList);
        Fluttertoast.showToast(
            msg: "تم إضافة المنتج الي السلة",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2
        );
//        Navigator.push(context, MaterialPageRoute(builder:(context)=> CartScreen('')));

        FocusScope.of(context).requestFocus(FocusNode());
        if(check=="yes"){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> CartScreen('')));
        }else{
          print("noo");
        }
      }else{
        Fluttertoast.showToast(
            msg: "هذا المنتج تم إضافته من قبل",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2
        );
      }
    }else {
      idList = [widget.id.toString()];
      if(CartItemList == null){
        CartItemList = [jsonEncode(CartItems.formMap({
          'id':widget.id,
          'title':widget.name,
          'price':widget.price,
          'sel_price':widget.sel_price,
          'img':widget.image,
          'tax':widget.tax,
          'quantity':widget.quantity,
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

  Future<void> askprice(int id,int offer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    setState(() {
      idLists = [id.toString()];
    });
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/request/store"), body: {
      "product_ids": idLists.toString(),
      "total": offer.toString(),
    },headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    Fluttertoast.showToast(
        msg: "تمت العملية",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
    if(!mapResponse['error']){
      setState(() {
        idLists = [];
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllOffersScreen()));
      });
    }
  }


}
