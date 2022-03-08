import 'package:flutter/material.dart';

import '../../service/SizeConfig.dart';

class HeaderImage extends StatelessWidget {
  String title, subtitle;

  HeaderImage({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Container(
      child: ListTile(
        minLeadingWidth: MySize.size15,
          contentPadding: const EdgeInsets.all(15),
          //leading: Image.asset(image,width: MySize.size30,height: MySize.size30,),

          title: Align(
            child: Text(
              title,
              style:
              TextStyle(fontSize: MySize.size18, fontWeight: FontWeight.w600),
            ),
            alignment: const Alignment(-1.2, 0),
          ),
          subtitle:
          Align(
            alignment: const Alignment(-1.2, 0),
            child: Text(
              subtitle,
              style: TextStyle(
                  fontSize: MySize.size14, fontWeight: FontWeight.normal),
            ),
          ),
          trailing: CircleAvatar(
            radius: MySize.size10,
            backgroundColor: const Color(0xffE2E3E5),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: MySize.size3,
                    top: MySize.size2,
                    bottom: MySize.size2),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: MySize.size10,
                  color: Colors.black,
                ),
              ),
            ),
          )
      ),
    );
  }
}
