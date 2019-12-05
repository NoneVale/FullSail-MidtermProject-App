import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//NOTE: All Cards may not be used in their classes, and the code may be put into the Screen it's needed on for functionality purposes.  This is mainly just to have a template needed for the card itself
class ImagePickerCard extends StatefulWidget {

  @override
  ImagePickerCardState createState() => new ImagePickerCardState();
}

class ImagePickerCardState extends State<ImagePickerCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.4),
      )
  );
}