import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showDialogShared(context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SpinKitRotatingCircle(
            color: Colors.green,
            size: 50.0,
          ),
        );
      });
}
