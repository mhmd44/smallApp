import 'package:agre/lib/network/local/cache_helper.dart';
import 'package:flutter/material.dart';

import 'Screens/SplashScreen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
await CacheHelper.init();
    runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'Elwady',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
            fontFamily: "Cairo"
        ),
        home: SplashScreen(),
      ),
    );
  }
}