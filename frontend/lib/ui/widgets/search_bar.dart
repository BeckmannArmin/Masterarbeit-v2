import 'package:flutter/material.dart';

import '../../service/SizeConfig.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const SearchInput({@required this.textController, @required this.hintText, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1)),
        ]),
        child: TextField(
                          decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: TextStyle(fontSize: MySize.size13),
                              prefixIcon: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: MySize.size10),
                                  padding: EdgeInsets.all(MySize.size10),
                                  child: Image.asset(
                                    'icons/search.png',
                                    width: MySize.size15,
                                    height: MySize.size15,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xffB1B1FF)
                                          .withOpacity(0.24)),
                                  borderRadius:
                                      BorderRadius.circular(MySize.size32)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xffB1B1FF)
                                          .withOpacity(0.24)),
                                  borderRadius:
                                      BorderRadius.circular(MySize.size32)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xffB1B1FF)
                                          .withOpacity(0.24)),
                                  borderRadius:
                                      BorderRadius.circular(MySize.size32))),
                        ),
    );
  }
}